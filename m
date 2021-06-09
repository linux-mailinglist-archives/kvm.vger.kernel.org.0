Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E645E3A1CDC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhFISjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:39:37 -0400
Received: from foss.arm.com ([217.140.110.172]:39818 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhFISjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:39:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC9D106F;
        Wed,  9 Jun 2021 11:37:40 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A7F23F719;
        Wed,  9 Jun 2021 11:37:38 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH kvmtool 4/4] arm/arm64: vfio: Add PCI Express Capability Structure
Date:   Wed,  9 Jun 2021 19:38:12 +0100
Message-Id: <20210609183812.29596-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210609183812.29596-1-alexandru.elisei@arm.com>
References: <20210609183812.29596-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It turns out that some Linux drivers (like Realtek R8169) fall back to a
device-specific configuration method if the device is not PCI Express
capable:

[    1.433825] r8169 0000:00:00.0 enp0s0: No native access to PCI extended config space, falling back to CSI

Add the PCI Express Capability Structure and populate it for assigned
devices, as this is how the Linux PCI driver determines if a device is PCI
Express capable.

Because we don't emulate a PCI Express link, a root complex or any slot
related properties, the PCI Express capability is kept as small as possible
by ignoring those fields.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/pci.h | 24 ++++++++++++++++++++++++
 vfio/pci.c        | 13 +++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 42d9e1c5645f..0f2d5bbabdc3 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -46,6 +46,8 @@ struct kvm;
 #define PCI_DEV_CFG_SIZE_EXTENDED 	4096
 
 #ifdef ARCH_HAS_PCI_EXP
+#define arch_has_pci_exp()	(true)
+
 #define PCI_CFG_SIZE		PCI_CFG_SIZE_EXTENDED
 #define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_EXTENDED
 
@@ -73,6 +75,8 @@ union pci_config_address {
 };
 
 #else
+#define arch_has_pci_exp()	(false)
+
 #define PCI_CFG_SIZE		PCI_CFG_SIZE_LEGACY
 #define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_LEGACY
 
@@ -143,6 +147,24 @@ struct pci_cap_hdr {
 	u8	next;
 };
 
+struct pci_exp_cap {
+	u8 cap;
+	u8 next;
+	u16 cap_reg;
+	u32 dev_cap;
+	u16 dev_ctrl;
+	u16 dev_status;
+	u32 link_cap;
+	u16 link_ctrl;
+	u16 link_status;
+	u32 slot_cap;
+	u16 slot_ctrl;
+	u16 slot_status;
+	u16 root_ctrl;
+	u16 root_cap;
+	u32 root_status;
+};
+
 struct pci_device_header;
 
 typedef int (*bar_activate_fn_t)(struct kvm *kvm,
@@ -188,6 +210,8 @@ struct pci_device_header {
 			u8		min_gnt;
 			u8		max_lat;
 			struct msix_cap msix;
+			/* Used only by architectures which support PCIE */
+			struct pci_exp_cap pci_exp;
 		} __attribute__((packed));
 		/* Pad to PCI config space size */
 		u8	__pad[PCI_DEV_CFG_SIZE];
diff --git a/vfio/pci.c b/vfio/pci.c
index 6a4204634e71..5c9bec6db710 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -623,6 +623,12 @@ static ssize_t vfio_pci_cap_size(struct pci_cap_hdr *cap_hdr)
 		return PCI_CAP_MSIX_SIZEOF;
 	case PCI_CAP_ID_MSI:
 		return vfio_pci_msi_cap_size((void *)cap_hdr);
+	case PCI_CAP_ID_EXP:
+		/*
+		 * We don't emulate any of the link, slot and root complex
+		 * properties, so ignore them.
+		 */
+		return PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1;
 	default:
 		pr_err("unknown PCI capability 0x%x", cap_hdr->type);
 		return 0;
@@ -696,6 +702,13 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
 			pdev->msi.pos = pos;
 			pdev->irq_modes |= VFIO_PCI_IRQ_MODE_MSI;
 			break;
+		case PCI_CAP_ID_EXP:
+			if (!arch_has_pci_exp())
+				continue;
+			ret = vfio_pci_add_cap(vdev, virt_hdr, cap, pos);
+			if (ret)
+				return ret;
+			break;
 		}
 	}
 
-- 
2.32.0

