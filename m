Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3882588FBC
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbiHCPve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiHCPvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A45E243314
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Beu1AQm9n7nTfMyN9Np+GAEvHHJH5+9TMEzmmDh6rKI=;
        b=Q4jYkSxMdaISB5w+C4rkKAB8lYI0fRRWCJpP8EBCIW0liqZjiHKmRRpU1FhhVC07HPxHjx
        dvu8gxP97Z+j1MzxlSsJLCeXfXGSrQvrTrdnnWT+l925LCHoQLt31KjqIlkTHWjBqoL6ae
        Lx0v+6JO0zFf4d/g4m6I0nLAgFAKghI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-dQ4-KMAhMEyFCp80zOmB-Q-1; Wed, 03 Aug 2022 11:50:47 -0400
X-MC-Unique: dQ4-KMAhMEyFCp80zOmB-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D34285A587;
        Wed,  3 Aug 2022 15:50:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA2F11121314;
        Wed,  3 Aug 2022 15:50:42 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 07/13] KVM: x86: emulator/smm: add structs for KVM's smram layout
Date:   Wed,  3 Aug 2022 18:50:05 +0300
Message-Id: <20220803155011.43721-8-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those structs will be used to read/write the smram state image.

Also document the differences between KVM's SMRAM layout and SMRAM
layout that is used by real Intel/AMD cpus.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c     |   6 +
 arch/x86/kvm/kvm_emulate.h | 218 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c         |   1 +
 3 files changed, 225 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 18551611cb13af..55d9328e6074a2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5864,3 +5864,9 @@ bool emulator_can_use_gpa(struct x86_emulate_ctxt *ctxt)
 
 	return true;
 }
+
+void  __init kvm_emulator_init(void)
+{
+	__check_smram32_offsets();
+	__check_smram64_offsets();
+}
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 89246446d6aa9d..dd0ae61e44a116 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -13,6 +13,7 @@
 #define _ASM_X86_KVM_X86_EMULATE_H
 
 #include <asm/desc_defs.h>
+#include <linux/build_bug.h>
 #include "fpu.h"
 
 struct x86_emulate_ctxt;
@@ -503,6 +504,223 @@ enum x86_intercept {
 	nr_x86_intercepts
 };
 
+
+/* 32 bit KVM's emulated SMM layout. Loosely based on Intel's layout */
+
+struct kvm_smm_seg_state_32 {
+	u32 flags;
+	u32 limit;
+	u32 base;
+} __packed;
+
+struct kvm_smram_state_32 {
+	u32 reserved1[62];
+	u32 smbase;
+	u32 smm_revision;
+	u32 reserved2[5];
+	u32 cr4; /* CR4 is not present in Intel/AMD SMRAM image */
+	u32 reserved3[5];
+
+	/*
+	 * Segment state is not present/documented in the Intel/AMD SMRAM image
+	 * Instead this area on Intel/AMD contains IO/HLT restart flags.
+	 */
+	struct kvm_smm_seg_state_32 ds;
+	struct kvm_smm_seg_state_32 fs;
+	struct kvm_smm_seg_state_32 gs;
+	struct kvm_smm_seg_state_32 idtr; /* IDTR has only base and limit */
+	struct kvm_smm_seg_state_32 tr;
+	u32 reserved;
+	struct kvm_smm_seg_state_32 gdtr; /* GDTR has only base and limit */
+	struct kvm_smm_seg_state_32 ldtr;
+	struct kvm_smm_seg_state_32 es;
+	struct kvm_smm_seg_state_32 cs;
+	struct kvm_smm_seg_state_32 ss;
+
+	u32 es_sel;
+	u32 cs_sel;
+	u32 ss_sel;
+	u32 ds_sel;
+	u32 fs_sel;
+	u32 gs_sel;
+	u32 ldtr_sel;
+	u32 tr_sel;
+
+	u32 dr7;
+	u32 dr6;
+	u32 gprs[8]; /* GPRS in the "natural" X86 order (EAX/ECX/EDX.../EDI) */
+	u32 eip;
+	u32 eflags;
+	u32 cr3;
+	u32 cr0;
+} __packed;
+
+
+static inline void __check_smram32_offsets(void)
+{
+#define __CHECK_SMRAM32_OFFSET(field, offset) \
+	ASSERT_STRUCT_OFFSET(struct kvm_smram_state_32, field, offset - 0xFE00)
+
+	__CHECK_SMRAM32_OFFSET(reserved1,	0xFE00);
+	__CHECK_SMRAM32_OFFSET(smbase,		0xFEF8);
+	__CHECK_SMRAM32_OFFSET(smm_revision,	0xFEFC);
+	__CHECK_SMRAM32_OFFSET(reserved2,	0xFF00);
+	__CHECK_SMRAM32_OFFSET(cr4,		0xFF14);
+	__CHECK_SMRAM32_OFFSET(reserved3,	0xFF18);
+	__CHECK_SMRAM32_OFFSET(ds,		0xFF2C);
+	__CHECK_SMRAM32_OFFSET(fs,		0xFF38);
+	__CHECK_SMRAM32_OFFSET(gs,		0xFF44);
+	__CHECK_SMRAM32_OFFSET(idtr,		0xFF50);
+	__CHECK_SMRAM32_OFFSET(tr,		0xFF5C);
+	__CHECK_SMRAM32_OFFSET(gdtr,		0xFF6C);
+	__CHECK_SMRAM32_OFFSET(ldtr,		0xFF78);
+	__CHECK_SMRAM32_OFFSET(es,		0xFF84);
+	__CHECK_SMRAM32_OFFSET(cs,		0xFF90);
+	__CHECK_SMRAM32_OFFSET(ss,		0xFF9C);
+	__CHECK_SMRAM32_OFFSET(es_sel,		0xFFA8);
+	__CHECK_SMRAM32_OFFSET(cs_sel,		0xFFAC);
+	__CHECK_SMRAM32_OFFSET(ss_sel,		0xFFB0);
+	__CHECK_SMRAM32_OFFSET(ds_sel,		0xFFB4);
+	__CHECK_SMRAM32_OFFSET(fs_sel,		0xFFB8);
+	__CHECK_SMRAM32_OFFSET(gs_sel,		0xFFBC);
+	__CHECK_SMRAM32_OFFSET(ldtr_sel,	0xFFC0);
+	__CHECK_SMRAM32_OFFSET(tr_sel,		0xFFC4);
+	__CHECK_SMRAM32_OFFSET(dr7,		0xFFC8);
+	__CHECK_SMRAM32_OFFSET(dr6,		0xFFCC);
+	__CHECK_SMRAM32_OFFSET(gprs,		0xFFD0);
+	__CHECK_SMRAM32_OFFSET(eip,		0xFFF0);
+	__CHECK_SMRAM32_OFFSET(eflags,		0xFFF4);
+	__CHECK_SMRAM32_OFFSET(cr3,		0xFFF8);
+	__CHECK_SMRAM32_OFFSET(cr0,		0xFFFC);
+#undef __CHECK_SMRAM32_OFFSET
+}
+
+
+/* 64 bit KVM's emulated SMM layout. Based on AMD64 layout */
+
+struct kvm_smm_seg_state_64 {
+	u16 selector;
+	u16 attributes;
+	u32 limit;
+	u64 base;
+};
+
+struct kvm_smram_state_64 {
+
+	struct kvm_smm_seg_state_64 es;
+	struct kvm_smm_seg_state_64 cs;
+	struct kvm_smm_seg_state_64 ss;
+	struct kvm_smm_seg_state_64 ds;
+	struct kvm_smm_seg_state_64 fs;
+	struct kvm_smm_seg_state_64 gs;
+	struct kvm_smm_seg_state_64 gdtr; /* GDTR has only base and limit*/
+	struct kvm_smm_seg_state_64 ldtr;
+	struct kvm_smm_seg_state_64 idtr; /* IDTR has only base and limit*/
+	struct kvm_smm_seg_state_64 tr;
+
+	/* I/O restart and auto halt restart are not implemented by KVM */
+	u64 io_restart_rip;
+	u64 io_restart_rcx;
+	u64 io_restart_rsi;
+	u64 io_restart_rdi;
+	u32 io_restart_dword;
+	u32 reserved1;
+	u8 io_inst_restart;
+	u8 auto_hlt_restart;
+	u8 reserved2[6];
+
+	u64 efer;
+
+	/*
+	 * Two fields below are implemented on AMD only, to store
+	 * SVM guest vmcb address if the #SMI was received while in the guest mode.
+	 */
+	u64 svm_guest_flag;
+	u64 svm_guest_vmcb_gpa;
+	u64 svm_guest_virtual_int; /* unknown purpose, not implemented */
+
+	u32 reserved3[3];
+	u32 smm_revison;
+	u32 smbase;
+	u32 reserved4[5];
+
+	/* ssp and svm_* fields below are not implemented by KVM */
+	u64 ssp;
+	u64 svm_guest_pat;
+	u64 svm_host_efer;
+	u64 svm_host_cr4;
+	u64 svm_host_cr3;
+	u64 svm_host_cr0;
+
+	u64 cr4;
+	u64 cr3;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+	u64 rflags;
+	u64 rip;
+	u64 gprs[16]; /* GPRS in a reversed "natural" X86 order (R15/R14/../RCX/RAX.) */
+};
+
+
+static inline void __check_smram64_offsets(void)
+{
+#define __CHECK_SMRAM64_OFFSET(field, offset) \
+	ASSERT_STRUCT_OFFSET(struct kvm_smram_state_64, field, offset - 0xFE00)
+
+	__CHECK_SMRAM64_OFFSET(es,			0xFE00);
+	__CHECK_SMRAM64_OFFSET(cs,			0xFE10);
+	__CHECK_SMRAM64_OFFSET(ss,			0xFE20);
+	__CHECK_SMRAM64_OFFSET(ds,			0xFE30);
+	__CHECK_SMRAM64_OFFSET(fs,			0xFE40);
+	__CHECK_SMRAM64_OFFSET(gs,			0xFE50);
+	__CHECK_SMRAM64_OFFSET(gdtr,			0xFE60);
+	__CHECK_SMRAM64_OFFSET(ldtr,			0xFE70);
+	__CHECK_SMRAM64_OFFSET(idtr,			0xFE80);
+	__CHECK_SMRAM64_OFFSET(tr,			0xFE90);
+	__CHECK_SMRAM64_OFFSET(io_restart_rip,		0xFEA0);
+	__CHECK_SMRAM64_OFFSET(io_restart_rcx,		0xFEA8);
+	__CHECK_SMRAM64_OFFSET(io_restart_rsi,		0xFEB0);
+	__CHECK_SMRAM64_OFFSET(io_restart_rdi,		0xFEB8);
+	__CHECK_SMRAM64_OFFSET(io_restart_dword,	0xFEC0);
+	__CHECK_SMRAM64_OFFSET(reserved1,		0xFEC4);
+	__CHECK_SMRAM64_OFFSET(io_inst_restart,		0xFEC8);
+	__CHECK_SMRAM64_OFFSET(auto_hlt_restart,	0xFEC9);
+	__CHECK_SMRAM64_OFFSET(reserved2,		0xFECA);
+	__CHECK_SMRAM64_OFFSET(efer,			0xFED0);
+	__CHECK_SMRAM64_OFFSET(svm_guest_flag,		0xFED8);
+	__CHECK_SMRAM64_OFFSET(svm_guest_vmcb_gpa,	0xFEE0);
+	__CHECK_SMRAM64_OFFSET(svm_guest_virtual_int,	0xFEE8);
+	__CHECK_SMRAM64_OFFSET(reserved3,		0xFEF0);
+	__CHECK_SMRAM64_OFFSET(smm_revison,		0xFEFC);
+	__CHECK_SMRAM64_OFFSET(smbase,			0xFF00);
+	__CHECK_SMRAM64_OFFSET(reserved4,		0xFF04);
+	__CHECK_SMRAM64_OFFSET(ssp,			0xFF18);
+	__CHECK_SMRAM64_OFFSET(svm_guest_pat,		0xFF20);
+	__CHECK_SMRAM64_OFFSET(svm_host_efer,		0xFF28);
+	__CHECK_SMRAM64_OFFSET(svm_host_cr4,		0xFF30);
+	__CHECK_SMRAM64_OFFSET(svm_host_cr3,		0xFF38);
+	__CHECK_SMRAM64_OFFSET(svm_host_cr0,		0xFF40);
+	__CHECK_SMRAM64_OFFSET(cr4,			0xFF48);
+	__CHECK_SMRAM64_OFFSET(cr3,			0xFF50);
+	__CHECK_SMRAM64_OFFSET(cr0,			0xFF58);
+	__CHECK_SMRAM64_OFFSET(dr7,			0xFF60);
+	__CHECK_SMRAM64_OFFSET(dr6,			0xFF68);
+	__CHECK_SMRAM64_OFFSET(rflags,			0xFF70);
+	__CHECK_SMRAM64_OFFSET(rip,			0xFF78);
+	__CHECK_SMRAM64_OFFSET(gprs,			0xFF80);
+#undef __CHECK_SMRAM64_OFFSET
+}
+
+union kvm_smram {
+	struct kvm_smram_state_64 smram64;
+	struct kvm_smram_state_32 smram32;
+	u8 bytes[512];
+};
+
+void  __init kvm_emulator_init(void);
+
+
 /* Host execution mode. */
 #if defined(CONFIG_X86_32)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT32
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33560bfa0cac6e..bea7e5015d592e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13355,6 +13355,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
+	kvm_emulator_init();
 	return 0;
 }
 module_init(kvm_x86_init);
-- 
2.26.3

