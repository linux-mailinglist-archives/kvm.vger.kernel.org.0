Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5653F3A80
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhHUMIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Aug 2021 08:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHUMIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Aug 2021 08:08:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14E7761215;
        Sat, 21 Aug 2021 12:08:03 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mHPn6-006Md6-Oa; Sat, 21 Aug 2021 13:08:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     kernel-team@android.com, Andre Przywara <Andre.Przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Subject: [PATCH][kvmtool] virtio/pci: Correctly handle MSI-X masking while MSI-X is disabled
Date:   Sat, 21 Aug 2021 13:07:42 +0100
Message-Id: <20210821120742.855712-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, Andre.Przywara@arm.com, alexandru.elisei@arm.com, tglx@linutronix.de, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since Linux commit 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X
entries"), kvmtool segfaults when the guest boots and tries to
disable all the MSI-X entries of a virtio device while MSI-X itself
is disabled.

What Linux does is seems perfectly correct. However, kvmtool uses
a different decoding depending on whether MSI-X is enabled for
this device or not. Which seems pretty wrong.

Cure the problem by removing the check against MSI-X being enabled,
and simplify the whole logic which looked a bit odd. With this,
Linux is back booting as a kvmtool guest with MSI-X.

Cc: Andre Przywara <Andre.Przywara@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/virtio.h |  2 +-
 virtio/core.c        | 12 ++++--------
 virtio/pci.c         |  7 ++-----
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3a311f54..7047d36f 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -166,7 +166,7 @@ u16 virt_queue__get_head_iov(struct virt_queue *vq, struct iovec iov[],
 u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
 			      struct iovec in_iov[], struct iovec out_iov[],
 			      u16 *in, u16 *out);
-int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off);
+int virtio__get_dev_specific_field(int offset, u32 *config_off);
 
 enum virtio_trans {
 	VIRTIO_PCI,
diff --git a/virtio/core.c b/virtio/core.c
index 90a661d1..afb09e90 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -169,16 +169,12 @@ void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 	memset(vq, 0, sizeof(*vq));
 }
 
-int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off)
+int virtio__get_dev_specific_field(int offset, u32 *config_off)
 {
-	if (msix) {
-		if (offset < 4)
-			return VIRTIO_PCI_O_MSIX;
-		else
-			offset -= 4;
-	}
+	if (offset < 24)
+		return VIRTIO_PCI_O_MSIX;
 
-	*config_off = offset;
+	*config_off = offset - 24;
 
 	return VIRTIO_PCI_O_CONFIG;
 }
diff --git a/virtio/pci.c b/virtio/pci.c
index eb91f512..2a6e41f1 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -112,9 +112,7 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 {
 	u32 config_offset;
 	struct virtio_pci *vpci = vdev->virtio;
-	int type = virtio__get_dev_specific_field(offset - 20,
-							virtio_pci__msix_enabled(vpci),
-							&config_offset);
+	int type = virtio__get_dev_specific_field(offset, &config_offset);
 	if (type == VIRTIO_PCI_O_MSIX) {
 		switch (offset) {
 		case VIRTIO_MSI_CONFIG_VECTOR:
@@ -208,8 +206,7 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 config_offset, vec;
 	int gsi;
-	int type = virtio__get_dev_specific_field(offset - 20, virtio_pci__msix_enabled(vpci),
-							&config_offset);
+	int type = virtio__get_dev_specific_field(offset, &config_offset);
 	if (type == VIRTIO_PCI_O_MSIX) {
 		switch (offset) {
 		case VIRTIO_MSI_CONFIG_VECTOR:
-- 
2.30.2

