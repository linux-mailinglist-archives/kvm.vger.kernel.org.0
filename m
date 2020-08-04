Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4930623BCB0
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgHDOwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:52:30 -0400
Received: from foss.arm.com ([217.140.110.172]:44952 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgHDOw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 10:52:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2299431B;
        Tue,  4 Aug 2020 07:52:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.12.88])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D86BE3F718;
        Tue,  4 Aug 2020 07:52:24 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     milon@wq.cz, julien.thierry.kdev@gmail.com, will@kernel.org,
        jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
Subject: [PATCH v2 kvmtool] virtio: Fix ordering of virtio_queue__should_signal()
Date:   Tue,  4 Aug 2020 15:53:17 +0100
Message-Id: <20200804145317.51633-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest programs used_event in the avail ring to let the host know when
it wants a notification from the device. The host notifies the guest when
the used ring index passes used_event. It is possible for the guest to
submit a buffer, and then go into uninterruptible sleep waiting for this
notification.

The virtio-blk guest driver, in the notification callback virtblk_done(),
increments the last known used ring index, then sets used_event to this
value, which means it will get a notification after the next buffer is
consumed by the host. virtblk_done() exits after the value of the used
ring idx has been propagated from the host thread.

On the host side, the virtio-blk device increments the used ring index,
then compares it to used_event to decide if a notification should be sent.

This is a common communication pattern between two threads, called store
buffer. Memory barriers are needed in order for the pattern to work
correctly, otherwise it is possible for the host to miss sending a required
notification.

Initial state: vring.used.idx = 2, vring.used_event = 1 (idx passes
used_event, which means kvmtool notifies the guest).

	GUEST (in virtblk_done())	| KVMTOOL (in virtio_blk_complete())
					|
(increment vq->last_used_idx = 2)	|
// virtqueue_enable_cb_prepare_split():	| // virt_queue__used_idx_advance():
write vring.used_event = 2		| write vring.used.idx = 3
// virtqueue_poll():			|
mb()					| wmb()
// virtqueue_poll_split():		| // virt_queue__should_signal():
read vring.used.idx = 2			| read vring.used_event = 1
// virtblk_done() exits.		| // No notification.

The write memory barrier on the host side is not enough to prevent
reordering of the read in the kvmtool thread, which can lead to the guest
thread waiting forever for IO to complete. Replace it with a full memory
barrier to get the correct store buffer pattern described in the Linux
litmus test SB+fencembonceonces.litmus, which forbids both threads reading
the initial values.

Also move the barrier in virtio_queue__should_signal(), because the barrier
is needed for notifications to work correctly, and it makes more sense to
have it in the function that determines if the host should notify the
guest.

Reported-by: Anvay Virkar <anvay.virkar@arm.com>
Suggested-by: Anvay Virkar <anvay.virkar@arm.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes in v2:
- Updated commit message with suggestions from Jean. Hoping that now it's
  clearer that the hang is caused by kvmtool not implementing the store
  buffer pattern correctly.

I've added a link to the online herd7 memory model tool with the store
buffer pattern [1]. The DMB SY can be replaced with DMB ST in one of
the threads, to mimic what kvmtool does, and the forbidden behaviour
becomes possible.

This was observed by Anvay, where both the guest and kvmtool read the
previous values of used.idx, and used_event respectively. The guest goes
into uninterruptible sleep and the notification is not sent.

I *think* this also fixes the VM hang reported in [2], where several
processes in the guest were stuck in uninterruptible sleep. I am not
familiar with the block layer, but my theory is that the threads were stuck
in wait_for_completion_io(), from blk_execute_rq() executing a flush
request. Milan has agreed to give this patch a spin [3], but that might
take a while because the bug is not easily reproducible. I believe the
patch can be merged on its own.

[1] http://diy.inria.fr/www/index.html?record=aarch64&cat=aarch64-v04&litmus=SB%2Bdmb.sys&cfg=new-web
[2] https://www.spinics.net/lists/kvm/msg204543.html
[3] https://www.spinics.net/lists/kvm/msg222201.html

 virtio/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/virtio/core.c b/virtio/core.c
index f5b3c07fc100..90a661d12e14 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -33,13 +33,6 @@ void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
 	wmb();
 	idx += jump;
 	queue->vring.used->idx = virtio_host_to_guest_u16(queue, idx);
-
-	/*
-	 * Use wmb to assure used idx has been increased before we signal the guest.
-	 * Without a wmb here the guest may ignore the queue since it won't see
-	 * an updated idx.
-	 */
-	wmb();
 }
 
 struct vring_used_elem *
@@ -194,6 +187,14 @@ bool virtio_queue__should_signal(struct virt_queue *vq)
 {
 	u16 old_idx, new_idx, event_idx;
 
+	/*
+	 * Use mb to assure used idx has been increased before we signal the
+	 * guest, and we don't read a stale value for used_event. Without a mb
+	 * here we might not send a notification that we need to send, or the
+	 * guest may ignore the queue since it won't see an updated idx.
+	 */
+	mb();
+
 	if (!vq->use_event_idx) {
 		/*
 		 * When VIRTIO_RING_F_EVENT_IDX isn't negotiated, interrupt the
-- 
2.28.0

