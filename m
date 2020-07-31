Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6992343FC
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 12:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbgGaKNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 06:13:45 -0400
Received: from foss.arm.com ([217.140.110.172]:54494 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGaKNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 06:13:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97E441FB;
        Fri, 31 Jul 2020 03:13:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.12.100])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 365C73F71F;
        Fri, 31 Jul 2020 03:13:41 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     milon@wq.cz, julien.thierry.kdev@gmail.com, will@kernel.org,
        jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
Subject: [PATCH kvmtool] virtio: Fix ordering of virt_queue__should_signal()
Date:   Fri, 31 Jul 2020 11:14:27 +0100
Message-Id: <20200731101427.16284-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest programs used_event in the avail queue to let the host know when
it wants a notification from the device. The host notifies the guest when
the used queue vring index passes used_event.

The virtio-blk guest driver, in the notification callback, sets used_event
to the value of the current used queue vring index, which means it will get
a notification after the next buffer is consumed by the host. It is
possible for the guest to submit a job, and then go into uninterruptible
sleep waiting for the notification (for example, via submit_bio_wait()).

On the host side, the virtio-blk device increments the used queue vring
index, then compares it to used_event to decide if a notification should be
sent.

A memory barrier between writing the new index value and reading used_event
is needed to make sure we read the latest used_event value.  kvmtool uses a
write memory barrier, which on arm64 translates into DMB ISHST. The
instruction orders memory writes that have been executed in program order
before the barrier relative to writes that have been executed in program
order after the barrier. The barrier doesn't apply to reads, which means it
is not enough to prevent reading a stale value for used_event. This can
lead to the host not sending the notification, and the guest thread remains
stuck indefinitely waiting for IO to complete.

Using a memory barrier for reads and writes matches what the guest driver
does when deciding to kick the host: after updating the avail queue vring
index via virtio_queue_rq() -> virtblk_add_req() -> .. ->
virtqueue_add_split(), it uses a read/write memory barrier before reading
avail_event from the used queue in virtio_commit_rqs() -> .. ->
virtqueue_kick_prepare_split().

Also move the barrier in virt_queue__should_signal(), because the barrier
is needed for notifications to work correctly, and it makes more sense to
have it in the function that determines if the host should notify the
guest.

Reported-by: Anvay Virkar <anvay.virkar@arm.com>
Suggested-by: Anvay Virkar <anvay.virkar@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
This was observed by Anvay, where kvmtool reads the previous value of
used_event and the notification is not sent.

I *think* this also fixes the VM hang reported in [1], where several
processes in the guest were stuck in uninterruptible sleep. I am not
familiar with the block layer, but my theory is that the threads were stuck
in wait_for_completion_io(), from blk_execute_rq() executing a flush
request. It would be great if Milan could give this patch a spin and see if
the problem goes away. Don't know how reproducible it is though.

[1] https://www.spinics.net/lists/kvm/msg204543.html

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

