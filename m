Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34519431D
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgCZPZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:23 -0400
Received: from foss.arm.com ([217.140.110.172]:33882 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgCZPZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 963841045;
        Thu, 26 Mar 2020 08:25:21 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AF1FA3F71E;
        Thu, 26 Mar 2020 08:25:20 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 24/32] pci: Limit configuration transaction size to 32 bits
Date:   Thu, 26 Mar 2020 15:24:30 +0000
Message-Id: <20200326152438.6218-25-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From PCI Local Bus Specification Revision 3.0. section 3.8 "64-Bit Bus
Extension":

"The bandwidth requirements for I/O and configuration transactions cannot
justify the added complexity, and, therefore, only memory transactions
support 64-bit data transfers".

Further down, the spec also describes the possible responses of a target
which has been requested to do a 64-bit transaction. Limit the transaction
to the lower 32 bits, to match the second accepted behaviour.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/pci.c b/pci.c
index 7399c76c0819..611e2c0bf1da 100644
--- a/pci.c
+++ b/pci.c
@@ -119,6 +119,9 @@ static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 {
 	union pci_config_address pci_config_address;
 
+	if (size > 4)
+		size = 4;
+
 	pci_config_address.w = ioport__read32(&pci_config_address_bits);
 	/*
 	 * If someone accesses PCI configuration space offsets that are not
@@ -135,6 +138,9 @@ static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 {
 	union pci_config_address pci_config_address;
 
+	if (size > 4)
+		size = 4;
+
 	pci_config_address.w = ioport__read32(&pci_config_address_bits);
 	/*
 	 * If someone accesses PCI configuration space offsets that are not
@@ -248,6 +254,9 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	cfg_addr.w		= (u32)addr;
 	cfg_addr.enable_bit	= 1;
 
+	if (len > 4)
+		len = 4;
+
 	if (is_write)
 		pci__config_wr(kvm, cfg_addr, data, len);
 	else
-- 
2.20.1

