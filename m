Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AA11B7995
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXPb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:31:28 -0400
Received: from foss.arm.com ([217.140.110.172]:37134 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgDXPb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:31:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38EE431B;
        Fri, 24 Apr 2020 08:31:28 -0700 (PDT)
Received: from red-moon.arm.com (unknown [10.57.30.150])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E6283F68F;
        Fri, 24 Apr 2020 08:31:26 -0700 (PDT)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     kvm@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v2] vfio: fix multi-MSI vector handling
Date:   Fri, 24 Apr 2020 16:31:19 +0100
Message-Id: <20200424153119.16913-1-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A PCI device with a MSI capability enabling Multiple MSI messages
(through the Multiple Message Enable field in the Message Control
register[6:4]) is expected to drive the Message Data lower bits (number
determined by the number of selected vectors) to generate the
corresponding MSI messages writes on the PCI bus.

Therefore, KVM expects the MSI data lower bits (a number of
bits that depend on bits [6:4] of the Message Control
register - which in turn control the number of vectors
allocated) to be set-up by kvmtool while programming the
MSI IRQ routing entries to make sure the MSI entries can
actually be demultiplexed by KVM and IRQ routes set-up
accordingly so that when an actual HW fires KVM can
route it to the correct entry in the interrupt controller
(and set-up a correct passthrough route for directly
injected interrupt).

Current kvmtool code does not set-up Message data entries
correctly for multi-MSI vectors - the data field is left
as programmed in the MSI capability by the guest for all
vector entries, triggering IRQs misrouting.

Fix it.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
---
v1 -> v2:
	- Removed superfluous nr_vectors check
	- Added MarcZ ACK
	- Added comment

 vfio/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/vfio/pci.c b/vfio/pci.c
index 76e24c1..3c11b86 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -434,6 +434,14 @@ static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
 
 	for (i = 0; i < nr_vectors; i++) {
 		entry = &pdev->msi.entries[i];
+
+		/*
+		 * Set the MSI data value as required by the PCI local
+		 * bus specifications, MSI capability, "Message Data".
+		 */
+		msg.data &= ~(nr_vectors - 1);
+		msg.data |= i;
+
 		entry->config.msg = msg;
 		vfio_pci_update_msi_entry(kvm, vdev, entry);
 	}
-- 
2.26.1

