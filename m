Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642686B6460
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCLJzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCLJy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BE737B77
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614893; x=1710150893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VHOrdn3js1HanmLp5K/DRqugYymociC/omgjkPuQCDM=;
  b=g8THHgGzPpUPu6GvcuNBW5pMTzxAhpMHYfDuhpaxMRkyLE5/fWMwq2PU
   gF7hEq3MG+KqxXr/FPe85jFN3sxRCtynFwcK8L2DiVF/W2qQU0wxtCLUo
   Psua9KrQ2Vf/KJsHiMP8t7rAKG8jv/Cr50Sde7/1LmbxA929VJ4e0NPX/
   yg4YpZKvEk12YOMuObZ8/2xyRcRBoa0bb7oh3mFSYn3w1IZLyfjxjHQwh
   NuCyPvQbhtV7lKTroTBYYuS8vfYWrviUCUBIyU/KyO3nUvkZGHud1UwkE
   YdZkQPJJn/fKjCgIAowws/IwRQ7+5PFDDIkvcMnwgUz7vE5kNIYWw8prv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622953"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622953"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409042"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409042"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:38 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 15/17] pkvm: x86: Build pKVM runtime as an independent binary
Date:   Mon, 13 Mar 2023 02:01:10 +0800
Message-Id: <20230312180112.1778254-16-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM runtime is running under VMX root mode, need isolating
from host Linux, so it shall be built as an independent binary.

Add pKVM link script to build an independent binary with separated
sections, and add prefix __pkvm for all its symbols to ensure host
Linux will not touch it and meantime ensure pKVM will not touch
host Linux symbols as well. For special case that Linux need to call
into pKVM's functions during init time, provide macros PKVM_DECLARE
& pkvm_sym to intently add __pkvm prefix.

To simplify, remove ftrace, Shadow Call Stack, CFI CFLAGS, and
disable stack protector. pKVM shall not export any symbols, so
disable 'EXPORT_SYMBOL'.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_image.h    | 42 ++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S        | 32 +++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/.gitignore     |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   | 32 ++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S | 10 +++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  3 +-
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    |  2 +-
 include/asm-generic/vmlinux.lds.h    | 17 +++++++++++
 8 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pkvm_image.h b/arch/x86/include/asm/pkvm_image.h
new file mode 100644
index 000000000000..191776677ce2
--- /dev/null
+++ b/arch/x86/include/asm/pkvm_image.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef __X86_INTEL_PKVM_IMAGE_H
+#define __X86_INTEL_PKVM_IMAGE_H
+
+#ifdef __PKVM_HYP__
+/* No prefix will be added */
+#define PKVM_DECLARE(type, f)	type f
+#define pkvm_sym(sym)		sym
+#else
+/* prefix is added by Makefile */
+#define PKVM_DECLARE(type, f)	type __pkvm_##f
+#define pkvm_sym(sym)		__pkvm_##sym
+#endif
+
+#define __PKVM_CONCAT(a, b)	a ## b
+#define PKVM_CONCAT(a, b)	__PKVM_CONCAT(a, b)
+
+#ifdef LINKER_SCRIPT
+
+#define PKVM_SECTION_NAME(NAME)	.pkvm##NAME
+
+#define PKVM_SECTION_SYMBOL_NAME(NAME) \
+	PKVM_CONCAT(__pkvm_section_, PKVM_SECTION_NAME(NAME))
+
+#define BEGIN_PKVM_SECTION(NAME)			\
+	PKVM_SECTION_NAME(NAME) : {			\
+		PKVM_SECTION_SYMBOL_NAME(NAME) = .;
+
+#define END_PKVM_SECTION				\
+	}
+
+#define PKVM_SECTION(NAME)			\
+	BEGIN_PKVM_SECTION(NAME)		\
+		*(NAME NAME##.*)		\
+	END_PKVM_SECTION
+
+#endif /* LINKER_SCRIPT */
+
+#endif /* __X86_INTEL_PKVM_IMAGE_H */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2e0ee14229bf..0199d81147db 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -111,6 +111,35 @@ PHDRS {
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
 
+#ifdef CONFIG_PKVM_INTEL
+#include <asm/pkvm_image.h>
+
+#define PKVM_TEXT							\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_text_start = .;						\
+	*(PKVM_SECTION_NAME(.text))					\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_text_end = .;
+
+#define PKVM_BSS							\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_bss_start = .;						\
+	*(PKVM_SECTION_NAME(.bss))					\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_bss_end = .;
+
+#define PKVM_DATA							\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_data_start = .;						\
+	*(PKVM_SECTION_NAME(.data))					\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_data_end = .;
+#else
+#define PKVM_TEXT
+#define PKVM_BSS
+#define PKVM_DATA
+#endif
+
 SECTIONS
 {
 #ifdef CONFIG_X86_32
@@ -143,6 +172,7 @@ SECTIONS
 		ALIGN_ENTRY_TEXT_BEGIN
 		ENTRY_TEXT
 		ALIGN_ENTRY_TEXT_END
+		PKVM_TEXT
 		*(.gnu.warning)
 
 	} :text =0xcccc
@@ -167,6 +197,7 @@ SECTIONS
 		/* 32 bit has nosave before _edata */
 		NOSAVE_DATA
 #endif
+		PKVM_DATA
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
 
@@ -396,6 +427,7 @@ SECTIONS
 		. = ALIGN(PAGE_SIZE);
 		*(BSS_MAIN)
 		BSS_DECRYPTED
+		PKVM_BSS
 		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
 	}
diff --git a/arch/x86/kvm/vmx/pkvm/.gitignore b/arch/x86/kvm/vmx/pkvm/.gitignore
new file mode 100644
index 000000000000..3ac372c4eca7
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/.gitignore
@@ -0,0 +1 @@
+pkvm.lds
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index b58bb0325bab..09b749def56b 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -2,8 +2,38 @@
 
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
+ccflags-y += -fno-stack-protector
+ccflags-y += -D__DISABLE_EXPORTS
 ccflags-y += -D__PKVM_HYP__
 
+lib-dir		:= lib
+
 pkvm-hyp-y	:= vmx_asm.o vmexit.o
 
-obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-hyp-y)
+pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
+
+pkvm-obj 	:= $(patsubst %.o,%.pkvm.o,$(pkvm-hyp-y))
+obj-$(CONFIG_PKVM_INTEL)	+= pkvm.o
+targets += $(pkvm-obj) pkvm.tmp.o pkvm.lds
+
+$(obj)/%.pkvm.o: $(src)/%.c FORCE
+	$(call if_changed_rule,cc_o_c)
+$(obj)/%.pkvm.o: $(src)/%.S FORCE
+	$(call if_changed_rule,as_o_S)
+
+$(obj)/pkvm.lds: $(src)/pkvm.lds.S FORCE
+	$(call if_changed_dep,cpp_lds_S)
+
+LDFLAGS_pkvm.tmp.o := -r -T
+$(obj)/pkvm.tmp.o: $(obj)/pkvm.lds $(addprefix $(obj)/,$(pkvm-obj)) FORCE
+	$(call if_changed,ld)
+
+$(obj)/pkvm.o: $(obj)/pkvm.tmp.o FORCE
+	$(call if_changed,pkvmcopy)
+
+quiet_cmd_pkvmcopy = PKVMPCOPY $@
+      cmd_pkvmcopy = $(OBJCOPY) --prefix-symbols=__pkvm_ --remove-section=.retpoline_sites --remove-section=.return_sites $< $@
+
+# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
+# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S
new file mode 100644
index 000000000000..af81ce58c72f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.lds.S
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm/pkvm_image.h>
+
+SECTIONS {
+	PKVM_SECTION(.text)
+	PKVM_SECTION(.rodata)
+	PKVM_SECTION(.data)
+	PKVM_SECTION(.bss)
+}
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 65583c01574e..86a8f5870108 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -6,6 +6,7 @@
 #ifndef _PKVM_H_
 #define _PKVM_H_
 
+#include <asm/pkvm_image.h>
 #include <vmx/vmx.h>
 
 #define STACK_SIZE SZ_16K
@@ -47,6 +48,6 @@ struct pkvm_hyp {
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
-void __pkvm_vmx_vmexit(void);
+PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index d147d6ec7795..8aaacc56734e 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -278,7 +278,7 @@ static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu)
 	_init_host_state_area(pcpu);
 
 	/*host RIP*/
-	vmcs_writel(HOST_RIP, (unsigned long)__pkvm_vmx_vmexit);
+	vmcs_writel(HOST_RIP, (unsigned long)pkvm_sym(__pkvm_vmx_vmexit));
 }
 
 static __init void init_execution_control(struct vcpu_vmx *vmx,
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 659bf3b31c91..1e8932ffdfbf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -441,6 +441,22 @@
 	__end_ro_after_init = .;
 #endif
 
+#ifdef CONFIG_PKVM_INTEL
+#include <asm/pkvm_image.h>
+#define PKVM_RODATA							\
+	PKVM_SECTION_NAME(.rodata) : 					\
+		AT(ADDR(PKVM_SECTION_NAME(.rodata)) - LOAD_OFFSET) {	\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_rodata_start = .;					\
+	*(PKVM_SECTION_NAME(.rodata))					\
+	*(PKVM_SECTION_NAME(.data..ro_after_init))			\
+	. = ALIGN(PAGE_SIZE);						\
+	__pkvm_rodata_end = .;						\
+	}
+#else
+#define PKVM_RODATA
+#endif
+
 /*
  * .kcfi_traps contains a list KCFI trap locations.
  */
@@ -543,6 +559,7 @@
 									\
 	KCFI_TRAPS							\
 									\
+	PKVM_RODATA							\
 	RO_EXCEPTION_TABLE						\
 	NOTES								\
 	BTF								\
-- 
2.25.1

