Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A243101F6
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhBEA7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhBEA7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:59:19 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A831C06121E
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:58:09 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id p20so3977345qtn.23
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qDXicDUbhn4YmvlL0f6DyDFtKs0LcCvxgmmb6ZOcH4k=;
        b=tN8U9hVcAGc+PeCBemCHFv7xmc4Se1qo/cn4XEcYgt6FZFN5eqjZG2FOPUt60F+++u
         OdUllKAQ6W2fdX2aJS0eP8zeffm/zASOHCowy/pf52dJc2x3D49UMW/aATCkcKw6emm/
         ei/PJJAsc+T5Q6OxPR2Rfk6sdtpLGTRj1Ya8IUZblwlkIO2rIMS5M+LWZJZM3WZ0QQoN
         QtUY/ssQpjRMbeNWBtktu4Gk3R8PzKIweb2NtDbvcd/85KdYaAvPQcZrweYSFgUFFbgl
         0Q/sOPJMhy9uI1sf/Pu5YfCBi3y/qmBCBlYvpLy9Qxng8DSI4wiZQXkdG+undy7kBxAL
         wPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qDXicDUbhn4YmvlL0f6DyDFtKs0LcCvxgmmb6ZOcH4k=;
        b=gRfipCextM2reC2VcT9xp249CZ+KPi5rOs/CBHOFs5S19lqhpvXBDL8/bOFlfxnAcs
         A/Z6m2GcK5yHtjR1wylYsStoXX5XPs9NwzxFrG1gebttikcH6dSN5YCFFA4bMWFqOQHv
         gNOnsyGsM7U57LLnP7iOWhajY91N+GaR5z5aphVRNNHqG+NOXQkn+vOsW08aOKCNpksV
         eD6nrURBOUAA7oSuxvXCrAVdXHWZ3knHswk4WYzmch9t3OESm5b0XwzVT11AcHjf8JJ7
         +jMFC0qdN8rDU+CUFDY6RzUbMWpuCDREIxlG1e9gyj4zuGDlU6BvGWyq2A0DX522SwfA
         xbpQ==
X-Gm-Message-State: AOAM531yIP0qHSFB5jWVU7haqChplcCW+G7M8xZcqhVlDnjOtAEIyJLU
        gDMYDZlztBVWx53JNsIuaOljtnCxPL4=
X-Google-Smtp-Source: ABdhPJz9PQJp0fdRbSrzvwi9aKxSkyuhjsN9fixS7W6IA0EN75m0KCckyCNon8hYHetIKh3w1yA2WzS+NOM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:ad4:4b2c:: with SMTP id s12mr2152920qvw.21.1612486688356;
 Thu, 04 Feb 2021 16:58:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:46 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 5/9] KVM: x86: Move XSETBV emulation to common code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the entirety of XSETBV emulation to x86.c, and assign the
function directly to both VMX's and SVM's exit handlers, i.e. drop the
unnecessary trampolines.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 +----------
 arch/x86/kvm/vmx/vmx.c          | 11 +----------
 arch/x86/kvm/x86.c              | 13 ++++++++-----
 4 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f70241a1136d..3f9d343aa071 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1567,7 +1567,7 @@ void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d8c3bb33e59c..46646d7539ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2356,15 +2356,6 @@ static int wbinvd_interception(struct kvm_vcpu *vcpu)
 	return kvm_emulate_wbinvd(vcpu);
 }
 
-static int xsetbv_interception(struct kvm_vcpu *vcpu)
-{
-	u64 new_bv = kvm_read_edx_eax(vcpu);
-	u32 index = kvm_rcx_read(vcpu);
-
-	int err = kvm_set_xcr(vcpu, index, new_bv);
-	return kvm_complete_insn_gp(vcpu, err);
-}
-
 static int rdpru_interception(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
@@ -3166,7 +3157,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_WBINVD]                       = wbinvd_interception,
 	[SVM_EXIT_MONITOR]			= monitor_interception,
 	[SVM_EXIT_MWAIT]			= mwait_interception,
-	[SVM_EXIT_XSETBV]			= xsetbv_interception,
+	[SVM_EXIT_XSETBV]			= kvm_emulate_xsetbv,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbeb0748f25f..96b58aef8d29 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5334,15 +5334,6 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu)
 	return kvm_emulate_wbinvd(vcpu);
 }
 
-static int handle_xsetbv(struct kvm_vcpu *vcpu)
-{
-	u64 new_bv = kvm_read_edx_eax(vcpu);
-	u32 index = kvm_rcx_read(vcpu);
-
-	int err = kvm_set_xcr(vcpu, index, new_bv);
-	return kvm_complete_insn_gp(vcpu, err);
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -5804,7 +5795,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_APIC_WRITE]              = handle_apic_write,
 	[EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
-	[EXIT_REASON_XSETBV]                  = handle_xsetbv,
+	[EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 	[EXIT_REASON_GDTR_IDTR]		      = handle_desc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205f7cf6dda3..51f2485bc6d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -993,14 +993,17 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	return 0;
 }
 
-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
-	if (static_call(kvm_x86_get_cpl)(vcpu) == 0)
-		return __kvm_set_xcr(vcpu, index, xcr);
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
-	return 1;
+	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_set_xcr);
+EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-- 
2.30.0.365.g02bc693789-goog

