Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811124B5789
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356769AbiBNQ6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:58:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBNQ6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:58:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA24265163
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:58:27 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA5AE13D5;
        Mon, 14 Feb 2022 08:58:27 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37F813F70D;
        Mon, 14 Feb 2022 08:58:26 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, pierre.gondois@arm.com
Subject: [PATCH kvmtool 3/3] arm: pci: Generate "msi-parent" property only with a MSI controller
Date:   Mon, 14 Feb 2022 16:58:30 +0000
Message-Id: <20220214165830.69207-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "msi-parent" PCI root complex property describes the MSI parent of the
root complex. When the VM is created with a GICv2 or GICv3 irqchip
(--irqchip=gicv3 or --irqchip=gicv2), there is no MSI controller present on
the system and the corresponding phandle is not generated, leaving the
"msi-parent" property to point to a non-existing phandle. Skip creating the
"msi-parent" property when no MSI controller exists.

Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/fdt.c                    | 2 +-
 arm/include/arm-common/pci.h | 3 ++-
 arm/pci.c                    | 8 ++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 635de7f27fa5..286ccadf1311 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -190,7 +190,7 @@ static int setup_fdt(struct kvm *kvm)
 	}
 
 	/* PCI host controller */
-	pci__generate_fdt_nodes(fdt);
+	pci__generate_fdt_nodes(fdt, kvm);
 
 	/* PSCI firmware */
 	_FDT(fdt_begin_node(fdt, "psci"));
diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
index 9008a0ed072e..afa7f7f42bcb 100644
--- a/arm/include/arm-common/pci.h
+++ b/arm/include/arm-common/pci.h
@@ -1,6 +1,7 @@
 #ifndef ARM_COMMON__PCI_H
 #define ARM_COMMON__PCI_H
 
-void pci__generate_fdt_nodes(void *fdt);
+struct kvm;
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 #endif /* ARM_COMMON__PCI_H */
diff --git a/arm/pci.c b/arm/pci.c
index e44e45343c6a..5bd82d438807 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -6,6 +6,7 @@
 #include "kvm/util.h"
 
 #include "arm-common/pci.h"
+#include "arm-common/gic.h"
 
 /*
  * An entry in the interrupt-map table looks like:
@@ -24,8 +25,9 @@ struct of_interrupt_map_entry {
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
-void pci__generate_fdt_nodes(void *fdt)
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
+	enum irqchip_type irqchip = kvm->cfg.arch.irqchip;
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
 	unsigned nentries = 0;
@@ -68,7 +70,9 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
-	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
+
+	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
+		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
-- 
2.31.1

