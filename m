Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A5535569
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349195AbiEZVYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349174AbiEZVYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:24:33 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F79E731B
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f7dbceab08so23185267b3.10
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=v3CqCwLu207sw0GXSofBe8WSdEvT1VmqfkxogyjcNu0=;
        b=CROY8wgPYt/QN4wVpxCf+acAp5/1J2MFvYsgfk2a8xMRi00okIaGJrHRap54YmorIy
         zIc4GGHJS9bzqlz98B5dUqDfN/aKPwesQgmWIDu/vKJfMoL8EQlZYsc/NSSVA+Hehi4r
         9RVAi4eAeJiWr6p+EiC0AtRvSEG/Piqsb2bkYKULUJHdXE05q2O5qJ3U+QSJbXNJHZDW
         YVh0GHIz35VhiOjP+aLn1t+6k2v594qyu3RPj2g9SjcRIRcvkzm9GmpBgLHOGtXViplO
         X33SiVo/xTm753U5GmtpWqJmQndVyCxTNmHX1s6AcZOHsBrbQ65zhTGqHsQB2NfPxQod
         dhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=v3CqCwLu207sw0GXSofBe8WSdEvT1VmqfkxogyjcNu0=;
        b=I5muT66qRiQl7gDxHJcmwCHbeHWUHzznnTjqog7xMn7uNFqE36l8/y1L5z02H5Szfy
         n67fSilLVTAaxIk0xAmhNzii/lhqu1F0bOjHmGUz+LhNKTPlghyMdoCwtIbF9VWfBhkt
         Nn4INyEDPfmWMsqWhFrrkqJ+hV5Ri1HmwVP2GaDZn3d9NJb9NLt17nuTK8maeuelIz1o
         vdXxYCQK42BqZ0LK2rsiXt8ncw0oXgWDjdLVpBYRGhDVvFFKW16t9jD68PFwZSVs0Tob
         2ScxIl5OrSjOkYE44alEcNlo3ygt0BxRhpFejiOzIrcoTFrOf2i9XnuNd8jXvCNT33OG
         k+GA==
X-Gm-Message-State: AOAM531sonmpO2vEbdHJX52UN+D09rxmDZI8EESnE8biMxqhu92zdMb9
        gm1e9qBG8haF5ynClc+ISRQn9hEuT2g=
X-Google-Smtp-Source: ABdhPJzyOrxr5ivAn4As2fM0HXaXv+5iCh+M5Mi7bj9R/MWAkeKBLhyvHaMvSLhc2V0BxcDiao0TbwBrj+A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:4546:0:b0:655:845b:f3df with SMTP id
 s67-20020a254546000000b00655845bf3dfmr11137880yba.624.1653600267235; Thu, 26
 May 2022 14:24:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 May 2022 21:08:15 +0000
In-Reply-To: <20220526210817.3428868-1-seanjc@google.com>
Message-Id: <20220526210817.3428868-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220526210817.3428868-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 6/8] KVM: x86: Bug the VM if the emulator accesses a
 non-existent GPR
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Robert Dinse <nanook@eskimo.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bug the VM, i.e. kill it, if the emulator accesses a non-existent GPR,
i.e. generates an out-of-bounds GPR index.  Continuing on all but
gaurantees some form of data corruption in the guest, e.g. even if KVM
were to redirect to a dummy register, KVM would be incorrectly read zeros
and drop writes.

Note, bugging the VM doesn't completely prevent data corruption, e.g. the
current round of emulation will complete before the vCPU bails out to
userspace.  But, the very act of killing the guest can also cause data
corruption, e.g. due to lack of file writeback before termination, so
taking on additional complexity to cleanly bail out of the emulator isn't
justified, the goal is purely to stem the bleeding and alert userspace
that something has gone horribly wrong, i.e. to avoid _silent_ data
corruption.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     |  4 ++--
 arch/x86/kvm/kvm_emulate.h | 10 ++++++++++
 arch/x86/kvm/x86.c         |  9 +++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 77161f57c8d3..70a8e0cd9fdc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -247,7 +247,7 @@ enum x86_transfer_type {
 
 static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
-	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
+	if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
 		nr &= NR_EMULATOR_GPRS - 1;
 
 	if (!(ctxt->regs_valid & (1 << nr))) {
@@ -259,7 +259,7 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
-	if (WARN_ON_ONCE(nr >= NR_EMULATOR_GPRS))
+	if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
 		nr &= NR_EMULATOR_GPRS - 1;
 
 	BUILD_BUG_ON(sizeof(ctxt->regs_dirty) * BITS_PER_BYTE < NR_EMULATOR_GPRS);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 034c845b3c63..89246446d6aa 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -89,6 +89,7 @@ struct x86_instruction_info {
 #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
 
 struct x86_emulate_ops {
+	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
 	/*
 	 * read_gpr: read a general purpose register (rax - r15)
 	 *
@@ -383,6 +384,15 @@ struct x86_emulate_ctxt {
 	bool is_branch;
 };
 
+#define KVM_EMULATOR_BUG_ON(cond, ctxt)		\
+({						\
+	int __ret = (cond);			\
+						\
+	if (WARN_ON_ONCE(__ret))		\
+		ctxt->ops->vm_bugged(ctxt);	\
+	unlikely(__ret);			\
+})
+
 /* Repeat String Operation Prefix */
 #define REPE_PREFIX	0xf3
 #define REPNE_PREFIX	0xf2
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7460b9a77d9a..e60badfbbc42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7887,7 +7887,16 @@ static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
 	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
 }
 
+static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
+{
+	struct kvm *kvm = emul_to_vcpu(ctxt)->kvm;
+
+	if (!kvm->vm_bugged)
+		kvm_vm_bugged(kvm);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
+	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
 	.write_gpr           = emulator_write_gpr,
 	.read_std            = emulator_read_std,
-- 
2.36.1.255.ge46751e96f-goog

