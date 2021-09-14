Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F4B40AA64
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 11:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhINJNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 05:13:55 -0400
Received: from foss.arm.com ([217.140.110.172]:41700 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231633AbhINJNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 05:13:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DA301FB;
        Tue, 14 Sep 2021 02:12:34 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45C723F719;
        Tue, 14 Sep 2021 02:12:33 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [RESEND PATCH v1 kvmtool 4/8] vfio/pci: Rename PBA offset in device descriptor to fd_offset
Date:   Tue, 14 Sep 2021 10:13:53 +0100
Message-Id: <20210914091353.10599-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-4-alexandru.elisei@arm.com>
References: <20210913154413.14322-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MSI-X capability defines a PBA offset, which is the offset of the PBA
array in the BAR that holds the array.

kvmtool uses the field "pba_offset" in struct msix_cap (which represents
the MSIX capability) to refer to the [PBA offset:BAR] field of the
capability; and the field "offset" in the struct vfio_pci_msix_pba to refer
to offset of the PBA array in the device descriptor created by the VFIO
driver.

As we're getting ready to add yet another field that represents an offset
to struct vfio_pci_msix_pba, try to avoid ambiguities by renaming the
struct's "offset" field to "fd_offset".

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
This is a resend of the original patch which kvm@vger.kernel.org rejected:

<kvm@vger.kernel.org>: host vger.kernel.org[23.128.96.18] said: 550 5.7.1
    Content-Policy reject msg: The message contains HTML, therefore we consider
    it SPAM.  Send pure TEXT/PLAIN if you are not a spammer. BF:<S 1>;
    S1343576AbhIMPoN (in reply to end of DATA command)

 include/kvm/vfio.h | 2 +-
 vfio/pci.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 28223cf2f036..8cdf04fcc265 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -48,7 +48,7 @@ struct vfio_pci_msix_table {
 
 struct vfio_pci_msix_pba {
 	size_t				size;
-	off_t				offset; /* in VFIO device fd */
+	off_t				fd_offset; /* in VFIO device fd */
 	unsigned int			bar;
 	u32				guest_phys_addr;
 };
diff --git a/vfio/pci.c b/vfio/pci.c
index 10ff99e70226..cc183118c7e3 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -256,7 +256,7 @@ static void vfio_pci_msix_pba_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	 * TODO: emulate PBA. Hardware MSI-X is never masked, so reading the PBA
 	 * is completely useless here. Note that Linux doesn't use PBA.
 	 */
-	if (pread(vdev->fd, data, len, pba->offset + offset) != (ssize_t)len)
+	if (pread(vdev->fd, data, len, pba->fd_offset + offset) != (ssize_t)len)
 		vfio_dev_err(vdev, "cannot access MSIX PBA\n");
 }
 
@@ -815,8 +815,8 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 	if (msix) {
 		/* Add a shortcut to the PBA region for the MMIO handler */
 		int pba_index = VFIO_PCI_BAR0_REGION_INDEX + pdev->msix_pba.bar;
-		pdev->msix_pba.offset = vdev->regions[pba_index].info.offset +
-					(msix->pba_offset & PCI_MSIX_PBA_OFFSET);
+		pdev->msix_pba.fd_offset = vdev->regions[pba_index].info.offset +
+					   (msix->pba_offset & PCI_MSIX_PBA_OFFSET);
 
 		/* Tidy up the capability */
 		msix->table_offset &= PCI_MSIX_TABLE_BIR;
-- 
2.33.0

