Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC2324846
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhBYBEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:04:22 -0500
Received: from foss.arm.com ([217.140.110.172]:58544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236667AbhBYBCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A9381478;
        Wed, 24 Feb 2021 17:00:54 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C44993F73B;
        Wed, 24 Feb 2021 17:00:52 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 18/22] pci: Switch trap handling to use MMIO handler
Date:   Thu, 25 Feb 2021 00:59:11 +0000
Message-Id: <20210225005915.26423-19-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Merge the existing _in and _out handlers to adhere to that MMIO
interface, and register these using the new registration function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 82 +++++++++++++++++------------------------------------------
 1 file changed, 24 insertions(+), 58 deletions(-)

diff --git a/pci.c b/pci.c
index 2e2c0270..d6da79e0 100644
--- a/pci.c
+++ b/pci.c
@@ -87,29 +87,16 @@ static void *pci_config_address_ptr(u16 port)
 	return base + offset;
 }
 
-static bool pci_config_address_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void pci_config_address_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				    u32 len, u8 is_write, void *ptr)
 {
-	void *p = pci_config_address_ptr(port);
+	void *p = pci_config_address_ptr(addr);
 
-	memcpy(p, data, size);
-
-	return true;
-}
-
-static bool pci_config_address_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	void *p = pci_config_address_ptr(port);
-
-	memcpy(data, p, size);
-
-	return true;
+	if (is_write)
+		memcpy(p, data, len);
+	else
+		memcpy(data, p, len);
 }
-
-static struct ioport_operations pci_config_address_ops = {
-	.io_in	= pci_config_address_in,
-	.io_out	= pci_config_address_out,
-};
-
 static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_number)
 {
 	union pci_config_address pci_config_address;
@@ -125,49 +112,27 @@ static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_numbe
 	return !IS_ERR_OR_NULL(device__find_dev(DEVICE_BUS_PCI, device_number));
 }
 
-static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	union pci_config_address pci_config_address;
-
-	if (size > 4)
-		size = 4;
-
-	pci_config_address.w = ioport__read32(&pci_config_address_bits);
-	/*
-	 * If someone accesses PCI configuration space offsets that are not
-	 * aligned to 4 bytes, it uses ioports to signify that.
-	 */
-	pci_config_address.reg_offset = port - PCI_CONFIG_DATA;
-
-	pci__config_wr(vcpu->kvm, pci_config_address, data, size);
-
-	return true;
-}
-
-static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void pci_config_data_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				 u32 len, u8 is_write, void *kvm)
 {
 	union pci_config_address pci_config_address;
 
-	if (size > 4)
-		size = 4;
+	if (len > 4)
+		len = 4;
 
 	pci_config_address.w = ioport__read32(&pci_config_address_bits);
 	/*
 	 * If someone accesses PCI configuration space offsets that are not
 	 * aligned to 4 bytes, it uses ioports to signify that.
 	 */
-	pci_config_address.reg_offset = port - PCI_CONFIG_DATA;
+	pci_config_address.reg_offset = addr - PCI_CONFIG_DATA;
 
-	pci__config_rd(vcpu->kvm, pci_config_address, data, size);
-
-	return true;
+	if (is_write)
+		pci__config_wr(vcpu->kvm, pci_config_address, data, len);
+	else
+		pci__config_rd(vcpu->kvm, pci_config_address, data, len);
 }
 
-static struct ioport_operations pci_config_data_ops = {
-	.io_in	= pci_config_data_in,
-	.io_out	= pci_config_data_out,
-};
-
 static int pci_activate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			    int bar_num)
 {
@@ -512,11 +477,12 @@ int pci__init(struct kvm *kvm)
 {
 	int r;
 
-	r = ioport__register(kvm, PCI_CONFIG_DATA + 0, &pci_config_data_ops, 4, NULL);
+	r = kvm__register_pio(kvm, PCI_CONFIG_DATA, 4,
+				 pci_config_data_mmio, NULL);
 	if (r < 0)
 		return r;
-
-	r = ioport__register(kvm, PCI_CONFIG_ADDRESS + 0, &pci_config_address_ops, 4, NULL);
+	r = kvm__register_pio(kvm, PCI_CONFIG_ADDRESS, 4,
+				 pci_config_address_mmio, NULL);
 	if (r < 0)
 		goto err_unregister_data;
 
@@ -528,17 +494,17 @@ int pci__init(struct kvm *kvm)
 	return 0;
 
 err_unregister_addr:
-	ioport__unregister(kvm, PCI_CONFIG_ADDRESS);
+	kvm__deregister_pio(kvm, PCI_CONFIG_ADDRESS);
 err_unregister_data:
-	ioport__unregister(kvm, PCI_CONFIG_DATA);
+	kvm__deregister_pio(kvm, PCI_CONFIG_DATA);
 	return r;
 }
 dev_base_init(pci__init);
 
 int pci__exit(struct kvm *kvm)
 {
-	ioport__unregister(kvm, PCI_CONFIG_DATA);
-	ioport__unregister(kvm, PCI_CONFIG_ADDRESS);
+	kvm__deregister_pio(kvm, PCI_CONFIG_DATA);
+	kvm__deregister_pio(kvm, PCI_CONFIG_ADDRESS);
 
 	return 0;
 }
-- 
2.17.5

