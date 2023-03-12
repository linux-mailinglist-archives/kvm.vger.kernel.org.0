Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB596B648B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCLJ7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCLJ65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47E22D46
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615076; x=1710151076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2VOP/5KCED/UEeXdm5DezP9u35+bVSgNf2MgAcgwWvc=;
  b=j06HII0jwGi3Dmyi/73zF6utjUBUhm2MCr+DCt39awY7X22HkYGCTh32
   Ef96O+aN0pmBG1HPNBLtDPP1SVfo2tUigzTiOh5WZfJEMTbdE8x1m44SZ
   3Xuhhx1p27r1lxcnNxgRdI7BHQq1SBzd5FpTLC4nVP+Qt7IVawSN2D2gx
   vyYaZe0p1Gr035jtyEkpgSi/58YMFsulKd+FSCK3N/ah/oRsRP4bHjSVz
   frvTH6K2b/nKp5tAUQzT5IXXYr1CsmC/2ZyGQEcDcZ3pKs7nvFwg96tvM
   uUMxJuXc3q/96u6uCAqQURW+tc256OunvtflCCh/nFEBPW22lBHxtF7UJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998118"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998118"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677727"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677727"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:23 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 13/22] pkvm: x86: Initialize emulated fields for vmcs emulation
Date:   Mon, 13 Mar 2023 02:02:54 +0800
Message-Id: <20230312180303.1778492-14-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For vmcs shadow fields, Host VM directly access through VMREAD/WMWRITE
without vmexit.

Meanwhile for other vmcs fields, the VMREAD/WMWRITE from host VM cause
vmread/wmwrite vmexit, pKVM need to handle them. Such fields can be
divided into two categories: one is host fields, pKVM just need to
record them as the value host VM set, the other one is emulated fields
which pKVM need to do emulation to ensure the isolation/security.

Introduce a MACRO EMULATED_FIELD_RW in pkvm_nested_vmcs_fields.h to
help pre-define the emulated fields for vmcs emulation, based on
it, initialize emulated_fields[] array for future emulation.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c            | 23 +++++++++++
 .../vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h    | 41 ++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 8ae37feda5ff..8e6d0f01819a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -149,6 +149,12 @@ static struct shadow_vmcs_field shadow_read_write_fields[] = {
 };
 static int max_shadow_read_write_fields =
 	ARRAY_SIZE(shadow_read_write_fields);
+static struct shadow_vmcs_field emulated_fields[] = {
+#define EMULATED_FIELD_RW(x, y) { x, offsetof(struct vmcs12, y) },
+#include "pkvm_nested_vmcs_fields.h"
+};
+static int max_emulated_fields =
+	ARRAY_SIZE(emulated_fields);
 
 static void init_vmcs_shadow_fields(void)
 {
@@ -201,6 +207,22 @@ static void init_vmcs_shadow_fields(void)
 	max_shadow_read_write_fields = j;
 }
 
+static void init_emulated_vmcs_fields(void)
+{
+	int i, j;
+
+	for (i = j = 0; i < max_emulated_fields; i++) {
+		struct shadow_vmcs_field entry = emulated_fields[i];
+		u16 field = entry.encoding;
+
+		if (!has_vmcs_field(field))
+			continue;
+
+		emulated_fields[j++] = entry;
+	}
+	max_emulated_fields = j;
+}
+
 static void nested_vmx_result(enum VMXResult result, int error_number)
 {
 	u64 rflags = vmcs_readl(GUEST_RFLAGS);
@@ -384,4 +406,5 @@ int handle_vmxoff(struct kvm_vcpu *vcpu)
 void pkvm_init_nest(void)
 {
 	init_vmcs_shadow_fields();
+	init_emulated_vmcs_fields();
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
index 4380d415428f..8666cda4ee6d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
@@ -2,10 +2,13 @@
 /*
  * Copyright (C) 2022 Intel Corporation
  */
-#if !defined(SHADOW_FIELD_RW) && !defined(SHADOW_FIELD_RO)
+#if !defined(EMULATED_FIELD_RW) && !defined(SHADOW_FIELD_RW) && !defined(SHADOW_FIELD_RO)
 BUILD_BUG_ON(1)
 #endif
 
+#ifndef EMULATED_FIELD_RW
+#define EMULATED_FIELD_RW(x, y)
+#endif
 #ifndef SHADOW_FIELD_RW
 #define SHADOW_FIELD_RW(x, y)
 #endif
@@ -13,6 +16,41 @@ BUILD_BUG_ON(1)
 #define SHADOW_FIELD_RO(x, y)
 #endif
 
+/*
+ * Emulated fields for vmcs02:
+ *
+ * These fields are recorded in cached_vmcs12, and should be emulated to
+ * real value in vmcs02 before vmcs01 active.
+ */
+/* 16-bits */
+EMULATED_FIELD_RW(VIRTUAL_PROCESSOR_ID, virtual_processor_id)
+
+/* 32-bits */
+EMULATED_FIELD_RW(VM_EXIT_CONTROLS, vm_exit_controls)
+EMULATED_FIELD_RW(VM_ENTRY_CONTROLS, vm_entry_controls)
+
+/* 64-bits, what about their HIGH 32 fields?  */
+EMULATED_FIELD_RW(IO_BITMAP_A, io_bitmap_a)
+EMULATED_FIELD_RW(IO_BITMAP_B, io_bitmap_b)
+EMULATED_FIELD_RW(MSR_BITMAP, msr_bitmap)
+EMULATED_FIELD_RW(VM_EXIT_MSR_STORE_ADDR, vm_exit_msr_store_addr)
+EMULATED_FIELD_RW(VM_EXIT_MSR_LOAD_ADDR, vm_exit_msr_load_addr)
+EMULATED_FIELD_RW(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr)
+EMULATED_FIELD_RW(XSS_EXIT_BITMAP, xss_exit_bitmap)
+EMULATED_FIELD_RW(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr)
+EMULATED_FIELD_RW(PML_ADDRESS, pml_address)
+EMULATED_FIELD_RW(VM_FUNCTION_CONTROL, vm_function_control)
+EMULATED_FIELD_RW(EPT_POINTER, ept_pointer)
+EMULATED_FIELD_RW(EOI_EXIT_BITMAP0, eoi_exit_bitmap0)
+EMULATED_FIELD_RW(EOI_EXIT_BITMAP1, eoi_exit_bitmap1)
+EMULATED_FIELD_RW(EOI_EXIT_BITMAP2, eoi_exit_bitmap2)
+EMULATED_FIELD_RW(EOI_EXIT_BITMAP3, eoi_exit_bitmap3)
+EMULATED_FIELD_RW(EPTP_LIST_ADDRESS, eptp_list_address)
+EMULATED_FIELD_RW(VMREAD_BITMAP, vmread_bitmap)
+EMULATED_FIELD_RW(VMWRITE_BITMAP, vmwrite_bitmap)
+EMULATED_FIELD_RW(ENCLS_EXITING_BITMAP, encls_exiting_bitmap)
+EMULATED_FIELD_RW(VMCS_LINK_POINTER, vmcs_link_pointer)
+
 /*
  * Shadow fields for vmcs02:
  *
@@ -152,5 +190,6 @@ SHADOW_FIELD_RO(GUEST_LINEAR_ADDRESS, guest_linear_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
 
+#undef EMULATED_FIELD_RW
 #undef SHADOW_FIELD_RW
 #undef SHADOW_FIELD_RO
-- 
2.25.1

