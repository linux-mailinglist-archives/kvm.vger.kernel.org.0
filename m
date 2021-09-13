Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EDC4097AB
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbhIMPok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:44:40 -0400
Received: from foss.arm.com ([217.140.110.172]:33242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344192AbhIMPo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDDAE11FB;
        Mon, 13 Sep 2021 08:42:59 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5E163F719;
        Mon, 13 Sep 2021 08:42:58 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 6/7] vfio/pci: Print an error when offset is outside of the MSIX table or PBA
Date:   Mon, 13 Sep 2021 16:44:12 +0100
Message-Id: <20210913154413.14322-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we keep track of the real size of MSIX table and PBA, print an
error when the guest tries to write to an offset which is not inside the
correct regions.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/vfio/pci.c b/vfio/pci.c
index 7781868..a6d0408 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -249,6 +249,11 @@ static void vfio_pci_msix_pba_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	u64 offset = addr - pba->guest_phys_addr;
 	struct vfio_device *vdev = container_of(pdev, struct vfio_device, pci);
 
+	if (offset >= pba->size) {
+		vfio_dev_err(vdev, "access outside of the MSIX PBA");
+		return;
+	}
+
 	if (is_write)
 		return;
 
@@ -269,6 +274,10 @@ static void vfio_pci_msix_table_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	struct vfio_device *vdev = container_of(pdev, struct vfio_device, pci);
 
 	u64 offset = addr - pdev->msix_table.guest_phys_addr;
+	if (offset >= pdev->msix_table.size) {
+		vfio_dev_err(vdev, "access outside of the MSI-X table");
+		return;
+	}
 
 	size_t vector = offset / PCI_MSIX_ENTRY_SIZE;
 	off_t field = offset % PCI_MSIX_ENTRY_SIZE;
-- 
2.20.1

