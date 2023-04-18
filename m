Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517B56E67A8
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 16:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjDRO5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 10:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjDRO5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 10:57:11 -0400
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FB4146CA
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 07:57:04 -0700 (PDT)
Received: from [167.98.27.226] (helo=rainbowdash)
        by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pomEF-000Ub9-Fe; Tue, 18 Apr 2023 15:22:43 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
        (envelope-from <ben@rainbowdash>)
        id 1pomEF-0066nY-0U;
        Tue, 18 Apr 2023 15:22:43 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     kvm@vger.kernel.org
Cc:     linux-riscv@lists.infradead.org, ajones@ventanamicro.com,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH kvmtool 2/2] riscv: add zicboz support
Date:   Tue, 18 Apr 2023 15:22:41 +0100
Message-Id: <20230418142241.1456070-3-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like ZICBOM, the ZICBOZ extension requires passing extra information to
the guest. Add the control to pass the information to the guest, get it
from the kvm ioctl and pass into the guest via the device-tree info.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 riscv/fdt.c                         | 11 +++++++++++
 riscv/include/asm/kvm.h             |  2 ++
 riscv/include/kvm/kvm-config-arch.h |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3cdb95c..fa6d153 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -20,6 +20,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
@@ -46,6 +47,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
 	int arr_sz = ARRAY_SIZE(isa_info_arr);
 	unsigned long cbom_blksz = 0;
+	unsigned long cboz_blksz = 0;
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -95,6 +97,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 					die("KVM_GET_ONE_REG failed (config.zicbom_block_size)");
 			}
 
+			if (isa_info_arr[i].ext_id == KVM_RISCV_ISA_EXT_ZICBOZ && !cboz_blksz) {
+				reg.id = RISCV_CONFIG_REG(zicboz_block_size);
+				reg.addr = (unsigned long)&cboz_blksz;
+				if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+					die("KVM_GET_ONE_REG failed (config.zicboz_block_size)");
+			}
+
 			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
 				pr_warning("Insufficient space to append ISA exension\n");
 				break;
@@ -116,6 +125,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
 		if (cbom_blksz)
 			_FDT(fdt_property_cell(fdt, "riscv,cbom-block-size", cbom_blksz));
+		if (cboz_blksz)
+			_FDT(fdt_property_cell(fdt, "riscv,cboz-block-size", cboz_blksz));
 		_FDT(fdt_property_cell(fdt, "reg", cpu));
 		_FDT(fdt_property_string(fdt, "status", "okay"));
 
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 92af6f3..e44c1e9 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -52,6 +52,7 @@ struct kvm_riscv_config {
 	unsigned long mvendorid;
 	unsigned long marchid;
 	unsigned long mimpid;
+	unsigned long zicboz_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -105,6 +106,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 188125c..46a774e 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -24,6 +24,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicboz",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
+		    "Disable Zicboz Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),
-- 
2.39.2

