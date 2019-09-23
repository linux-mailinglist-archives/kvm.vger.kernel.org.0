Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C5BB578
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439785AbfIWNfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:51 -0400
Received: from foss.arm.com ([217.140.110.172]:42372 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439778AbfIWNfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FB1C1000;
        Mon, 23 Sep 2019 06:35:50 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B15B3F694;
        Mon, 23 Sep 2019 06:35:49 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 11/16] arm/pci: Remove unused ioports
Date:   Mon, 23 Sep 2019 14:35:17 +0100
Message-Id: <1569245722-23375-12-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM does not use the PCI_CONFIG_DATA and PCI_CONFIG_ADDRESS I/O ports and
has no way of knowing about them, since they are not generated in the DTB
file. Do not register these I/O addresses for the ARM architecture.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/pci.c b/pci.c
index 689869cb79a3..88ee78ad7d08 100644
--- a/pci.c
+++ b/pci.c
@@ -68,7 +68,9 @@ static void *pci_config_address_ptr(u16 port)
 	return base + offset;
 }
 
-static bool pci_config_address_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool __used pci_config_address_out(struct ioport *ioport,
+					  struct kvm_cpu *vcpu,
+					  u16 port, void *data, int size)
 {
 	void *p = pci_config_address_ptr(port);
 
@@ -77,7 +79,9 @@ static bool pci_config_address_out(struct ioport *ioport, struct kvm_cpu *vcpu,
 	return true;
 }
 
-static bool pci_config_address_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool __used pci_config_address_in(struct ioport *ioport,
+					 struct kvm_cpu *vcpu,
+					 u16 port, void *data, int size)
 {
 	void *p = pci_config_address_ptr(port);
 
@@ -86,7 +90,7 @@ static bool pci_config_address_in(struct ioport *ioport, struct kvm_cpu *vcpu, u
 	return true;
 }
 
-static struct ioport_operations pci_config_address_ops = {
+static struct ioport_operations __used pci_config_address_ops = {
 	.io_in	= pci_config_address_in,
 	.io_out	= pci_config_address_out,
 };
@@ -106,7 +110,9 @@ static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_numbe
 	return !IS_ERR_OR_NULL(device__find_dev(DEVICE_BUS_PCI, device_number));
 }
 
-static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool __used pci_config_data_out(struct ioport *ioport,
+				       struct kvm_cpu *vcpu,
+				       u16 port, void *data, int size)
 {
 	union pci_config_address pci_config_address;
 
@@ -122,7 +128,9 @@ static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 	return true;
 }
 
-static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool __used pci_config_data_in(struct ioport *ioport,
+				      struct kvm_cpu *vcpu,
+				      u16 port, void *data, int size)
 {
 	union pci_config_address pci_config_address;
 
@@ -138,7 +146,7 @@ static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 	return true;
 }
 
-static struct ioport_operations pci_config_data_ops = {
+static struct ioport_operations __used pci_config_data_ops = {
 	.io_in	= pci_config_data_in,
 	.io_out	= pci_config_data_out,
 };
@@ -225,6 +233,13 @@ struct pci_device_header *pci__find_dev(u8 dev_num)
 	return hdr->data;
 }
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+int pci__init(struct kvm *kvm)
+{
+	return kvm__register_mmio(kvm, KVM_PCI_CFG_AREA, PCI_CFG_SIZE, false,
+				  pci_config_mmio_access, kvm);
+}
+#else
 int pci__init(struct kvm *kvm)
 {
 	int r;
@@ -250,6 +265,7 @@ err_unregister_data:
 	ioport__unregister(kvm, PCI_CONFIG_DATA);
 	return r;
 }
+#endif
 dev_base_init(pci__init);
 
 int pci__exit(struct kvm *kvm)
-- 
2.7.4

