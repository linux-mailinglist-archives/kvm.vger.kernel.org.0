Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A543D42C093
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhJMMxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:53:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:43600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhJMMxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:53:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="290908193"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="290908193"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 05:51:38 -0700
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="491444349"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 05:51:37 -0700
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     jan.kiszka@siemens.com, Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: [kvm-unit-tests PATCH] nVMX: Fix wrong setting on HOST_BASE_TR and GUEST_BASE_TR
Date:   Wed, 13 Oct 2021 20:52:28 +0800
Message-Id: <20211013125228.423038-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tss_descr was mapped to descriptor table pointer but in fact it
should be a gdt entry.

Add two helper functions to pick base and limit from gdt 64bit
entry and assign to HOST_BASE_TR, GUEST_BASE_TR and GUEST_LIMIT_TR.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 lib/x86/desc.h |  2 ++
 lib/x86/desc.c | 12 ++++++++++++
 x86/vmx.c      |  8 ++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..cb71046 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -209,6 +209,8 @@ void set_intr_task_gate(int vec, void *fn);
 void setup_tss32(void);
 #else
 extern tss64_t tss;
+u64 get_gdt_entry_64_base(struct segment_desc64 *entry);
+u64 get_gdt_entry_64_limit(struct segment_desc64 *entry);
 #endif
 
 unsigned exception_vector(void);
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..5482366 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -376,6 +376,18 @@ void setup_alt_stack(void)
 {
 	tss.ist1 = (u64)intr_alt_stack + 4096;
 }
+u64 get_gdt_entry_64_base(struct segment_desc64 *entry)
+{
+	return ((uint64_t) entry->base1 |
+			((uint64_t) entry->base2 << 16) |
+			((uint64_t) entry->base3 << 24) |
+			((uint64_t) entry->base4 << 32));
+}
+u64 get_gdt_entry_64_limit(struct segment_desc64 *entry)
+{
+	return ((uint64_t) entry->limit1 |
+			((uint64_t) entry->limit << 16));
+}
 #endif
 
 static bool exception;
diff --git a/x86/vmx.c b/x86/vmx.c
index 20dc677..2d87d88 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -75,7 +75,7 @@ union vmx_ept_vpid  ept_vpid;
 
 extern struct descriptor_table_ptr gdt64_desc;
 extern struct descriptor_table_ptr idt_descr;
-extern struct descriptor_table_ptr tss_descr;
+extern struct segment_desc64 tss_descr;
 extern void *vmx_return;
 extern void *entry_sysenter;
 extern void *guest_entry;
@@ -1275,7 +1275,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_SEL_FS, KERNEL_DS);
 	vmcs_write(HOST_SEL_GS, KERNEL_DS);
 	vmcs_write(HOST_SEL_TR, TSS_MAIN);
-	vmcs_write(HOST_BASE_TR, tss_descr.base);
+	vmcs_write(HOST_BASE_TR, get_gdt_entry_64_base(&tss_descr));
 	vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
@@ -1331,7 +1331,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_BASE_DS, 0);
 	vmcs_write(GUEST_BASE_FS, 0);
 	vmcs_write(GUEST_BASE_GS, 0);
-	vmcs_write(GUEST_BASE_TR, tss_descr.base);
+	vmcs_write(GUEST_BASE_TR, get_gdt_entry_64_base(&tss_descr));
 	vmcs_write(GUEST_BASE_LDTR, 0);
 
 	vmcs_write(GUEST_LIMIT_CS, 0xFFFFFFFF);
@@ -1341,7 +1341,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_LIMIT_FS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_GS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_LDTR, 0xffff);
-	vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
+	vmcs_write(GUEST_LIMIT_TR, get_gdt_entry_64_limit(&tss_descr));
 
 	vmcs_write(GUEST_AR_CS, 0xa09b);
 	vmcs_write(GUEST_AR_DS, 0xc093);
-- 
2.25.1

