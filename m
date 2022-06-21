Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B86355356B
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352112AbiFUPJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352307AbiFUPJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04A69286FE
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9bdeuqQcUBSdjmQo8dMHBeTNo5swwTJ8mubljrij5I=;
        b=CgYZIt2azM2eicdIqxOtr6t6r2r2Sb/UNkx+eFxv8XCZduiw5a/OeOTP+YjSEvL+GOAYwK
        fAsMiOBflOYAoavjNyDQaz1s7IEjlQMoXw27xAmfdUgEX0LO89XwCmXFFLYPxV+FtYg0cx
        ONOlVUsDzROwAsNP6CI/NwKCT6442Nw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-shJJ2STeMgyU3YMrYn421g-1; Tue, 21 Jun 2022 11:09:36 -0400
X-MC-Unique: shJJ2STeMgyU3YMrYn421g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F142C85A580;
        Tue, 21 Jun 2022 15:09:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 802EF18EA3;
        Tue, 21 Jun 2022 15:09:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 07/11] KVM: x86: emulator/smm: add structs for KVM's smram layout
Date:   Tue, 21 Jun 2022 18:08:58 +0300
Message-Id: <20220621150902.46126-8-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/kvm_emulate.h | 139 +++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 89246446d6aa9d..7015728da36d5f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -503,6 +503,145 @@ enum x86_intercept {
 	nr_x86_intercepts
 };
 
+
+/*
+ * 32 bit KVM's emulated SMM layout
+ * Loosely based on Intel's layout
+ */
+
+struct kvm_smm_seg_state_32 {
+	u32 flags;
+	u32 limit;
+	u32 base;
+} __packed;
+
+struct kvm_smram_state_32 {
+
+	u32 reserved1[62];			/* FE00 - FEF7 */
+	u32 smbase;				/* FEF8 */
+	u32 smm_revision;			/* FEFC */
+	u32 reserved2[5];			/* FF00-FF13 */
+	/* CR4 is not present in Intel/AMD SMRAM image*/
+	u32 cr4;				/* FF14 */
+	u32 reserved3[5];			/* FF18 */
+
+	/*
+	 * Segment state is not present/documented in the
+	 * Intel/AMD SMRAM image
+	 */
+	struct kvm_smm_seg_state_32 ds;		/* FF2C */
+	struct kvm_smm_seg_state_32 fs;		/* FF38 */
+	struct kvm_smm_seg_state_32 gs;		/* FF44 */
+	/* idtr has only base and limit*/
+	struct kvm_smm_seg_state_32 idtr;	/* FF50 */
+	struct kvm_smm_seg_state_32 tr;		/* FF5C */
+	u32 reserved;				/* FF68 */
+	/* gdtr has only base and limit*/
+	struct kvm_smm_seg_state_32 gdtr;	/* FF6C */
+	struct kvm_smm_seg_state_32 ldtr;	/* FF78 */
+	struct kvm_smm_seg_state_32 es;		/* FF84 */
+	struct kvm_smm_seg_state_32 cs;		/* FF90 */
+	struct kvm_smm_seg_state_32 ss;		/* FF9C */
+
+	u32 es_sel;				/* FFA8 */
+	u32 cs_sel;				/* FFAC */
+	u32 ss_sel;				/* FFB0 */
+	u32 ds_sel;				/* FFB4 */
+	u32 fs_sel;				/* FFB8 */
+	u32 gs_sel;				/* FFBC */
+	u32 ldtr_sel;				/* FFC0 */
+	u32 tr_sel;				/* FFC4 */
+
+	u32 dr7;				/* FFC8 */
+	u32 dr6;				/* FFCC */
+
+	/* GPRS in the "natural" X86 order (RAX/RCX/RDX.../RDI)*/
+	u32 gprs[8];				/* FFD0-FFEC */
+
+	u32 eip;				/* FFF0 */
+	u32 eflags;				/* FFF4 */
+	u32 cr3;				/* FFF8 */
+	u32 cr0;				/* FFFC */
+} __packed;
+
+/*
+ * 64 bit KVM's emulated SMM layout
+ * Based on AMD64 layout
+ */
+
+struct kvm_smm_seg_state_64 {
+	u16 selector;
+	u16 attributes;
+	u32 limit;
+	u64 base;
+};
+
+struct kvm_smram_state_64 {
+	struct kvm_smm_seg_state_64 es;		/* FE00 (R/O) */
+	struct kvm_smm_seg_state_64 cs;		/* FE10 (R/O) */
+	struct kvm_smm_seg_state_64 ss;		/* FE20 (R/O) */
+	struct kvm_smm_seg_state_64 ds;		/* FE30 (R/O) */
+	struct kvm_smm_seg_state_64 fs;		/* FE40 (R/O) */
+	struct kvm_smm_seg_state_64 gs;		/* FE50 (R/O) */
+
+	/* gdtr has only base and limit*/
+	struct kvm_smm_seg_state_64 gdtr;	/* FE60 (R/O) */
+	struct kvm_smm_seg_state_64 ldtr;	/* FE70 (R/O) */
+
+	/* idtr has only base and limit*/
+	struct kvm_smm_seg_state_64 idtr;	/* FE80 (R/O) */
+	struct kvm_smm_seg_state_64 tr;		/* FE90 (R/O) */
+
+	/* I/O restart and auto halt restart are not implemented by KVM */
+	u64 io_restart_rip;			/* FEA0 (R/O) */
+	u64 io_restart_rcx;			/* FEA8 (R/O) */
+	u64 io_restart_rsi;			/* FEB0 (R/O) */
+	u64 io_restart_rdi;			/* FEB8 (R/O) */
+	u32 io_restart_dword;			/* FEC0 (R/O) */
+	u32 reserved1;				/* FEC4 */
+	u8 io_instruction_restart;		/* FEC8 (R/W) */
+	u8 auto_halt_restart;			/* FEC9 (R/W) */
+	u8 reserved2[6];			/* FECA-FECF */
+
+	u64 efer;				/* FED0 (R/O) */
+
+	/*
+	 * Implemented on AMD only, to store current SVM guest address.
+	 * svm_guest_virtual_int has unknown purpose, not implemented.
+	 */
+
+	u64 svm_guest_flag;			/* FED8 (R/O) */
+	u64 svm_guest_vmcb_gpa;			/* FEE0 (R/O) */
+	u64 svm_guest_virtual_int;		/* FEE8 (R/O) */
+
+	u32 reserved3[3];			/* FEF0-FEFB */
+	u32 smm_revison;			/* FEFC (R/O) */
+	u32 smbase;				/* FFF0 (R/W) */
+	u32 reserved4[5];			/* FF04-FF17 */
+
+	/* SSP and SVM fields below are not implemented by KVM */
+	u64 ssp;				/* FF18 (R/W) */
+	u64 svm_guest_pat;			/* FF20 (R/O) */
+	u64 svm_host_efer;			/* FF28 (R/O) */
+	u64 svm_host_cr4;			/* FF30 (R/O) */
+	u64 svm_host_cr3;			/* FF38 (R/O) */
+	u64 svm_host_cr0;			/* FF40 (R/O) */
+
+	u64 cr4;				/* FF48 (R/O) */
+	u64 cr3;				/* FF50 (R/O) */
+	u64 cr0;				/* FF58 (R/O) */
+
+	u64 dr7;				/* FF60 (R/O) */
+	u64 dr6;				/* FF68 (R/O) */
+
+	u64 rflags;				/* FF70 (R/W) */
+	u64 rip;				/* FF78 (R/W) */
+
+	/* GPRS in a reversed "natural" X86 order (R15/R14/../RCX/RAX.) */
+	u64 gprs[16];				/* FF80-FFFF (R/W) */
+};
+
+
 /* Host execution mode. */
 #if defined(CONFIG_X86_32)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT32
-- 
2.26.3

