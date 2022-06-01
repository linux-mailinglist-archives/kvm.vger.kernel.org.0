Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FC953AB52
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349351AbiFAQwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbiFAQww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:52:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3631F33EAB
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:52:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 047551480;
        Wed,  1 Jun 2022 09:52:47 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5428B3F66F;
        Wed,  1 Jun 2022 09:52:46 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool 2/4] virtio/mmio: access header members normally
Date:   Wed,  1 Jun 2022 17:51:36 +0100
Message-Id: <20220601165138.3135246-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601165138.3135246-1-andre.przywara@arm.com>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handlers for accessing the virtio-mmio header tried to be very
clever, by modelling the internal data structure to look exactly like
the protocol header, so that address offsets can "reused".

This requires using a packed structure, which creates other problems,
and seems to be totally unnecessary in this case.

Replace the offset-based access hacks to the structure with proper
compiler visible accesses, to avoid unaligned accesses and make the code
more robust.

This fixes UBSAN complaints about unaligned accesses.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/virtio-mmio.h |  2 +-
 virtio/mmio.c             | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 13dcccb6..aa4cab3c 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -39,7 +39,7 @@ struct virtio_mmio_hdr {
 	u32	interrupt_ack;
 	u32	reserved_5[2];
 	u32	status;
-} __attribute__((packed));
+};
 
 struct virtio_mmio {
 	u32			addr;
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 3782d55a..c9ad8ee7 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -135,12 +135,22 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 
 	switch (addr) {
 	case VIRTIO_MMIO_MAGIC_VALUE:
+		memcpy(data, &vmmio->hdr.magic, sizeof(vmmio->hdr.magic));
+		break;
 	case VIRTIO_MMIO_VERSION:
+		ioport__write32(data, vmmio->hdr.version);
+		break;
 	case VIRTIO_MMIO_DEVICE_ID:
+		ioport__write32(data, vmmio->hdr.device_id);
+		break;
 	case VIRTIO_MMIO_VENDOR_ID:
+		ioport__write32(data, vmmio->hdr.vendor_id);
+		break;
 	case VIRTIO_MMIO_STATUS:
+		ioport__write32(data, vmmio->hdr.status);
+		break;
 	case VIRTIO_MMIO_INTERRUPT_STATUS:
-		ioport__write32(data, *(u32 *)(((void *)&vmmio->hdr) + addr));
+		ioport__write32(data, vmmio->hdr.interrupt_state);
 		break;
 	case VIRTIO_MMIO_DEVICE_FEATURES:
 		if (vmmio->hdr.host_features_sel == 0)
@@ -174,9 +184,10 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 
 	switch (addr) {
 	case VIRTIO_MMIO_DEVICE_FEATURES_SEL:
+		vmmio->hdr.host_features_sel = ioport__read32(data);
+		break;
 	case VIRTIO_MMIO_DRIVER_FEATURES_SEL:
-		val = ioport__read32(data);
-		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		vmmio->hdr.guest_features_sel = ioport__read32(data);
 		break;
 	case VIRTIO_MMIO_QUEUE_SEL:
 		val = ioport__read32(data);
@@ -185,7 +196,7 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 				val, vq_count);
 			break;
 		}
-		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		vmmio->hdr.queue_sel = val;
 		break;
 	case VIRTIO_MMIO_STATUS:
 		vmmio->hdr.status = ioport__read32(data);
-- 
2.25.1

