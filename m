Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0830C787
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhBBRWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbhBBRUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:20:15 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7721AC0613ED
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 09:19:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id j12so14766403pfj.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKy3eoqvCg/krr4iDU1R6HhW8EG/lr08wpIZgNms4lo=;
        b=QjyWXaYE/ktH8k+M1PZXVFkDQGY654WnrlMbX2RT6lGlP7xYHOnJwdKIxE08g9do/Z
         H9g/8s+/EXU/d+1pUIuup3xX+Yn6dfNEWhewWhfpQH56PvI5yrzP3z/oaggj9FD+TGXb
         nhKSpQPrF5Gw5ZguRWglXnUrlMN3PK4RtAFifsUTfYdSl0Mu/Rtn50e5lI4b2QqWZmlQ
         Wi+l3jQ+Iul4iHadIbo5TPfvJyOerkVZtM+BXlt4F3mC09w2PyTdWRVyMQzGiZq0PyVq
         EeHTG4ipW47unwVSj3tEBAb16IYePzoGjhvszigAlmUFNYzMH3s6erDyOTRdQ+bVQfi+
         b0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VKy3eoqvCg/krr4iDU1R6HhW8EG/lr08wpIZgNms4lo=;
        b=JNYPqRTLZwM476TP+qAWoIctba4UJ4/zCRueVFYN0ezgCTVSnOX0spNELiNCCryG4A
         R2JC30LnDROjttpfWC7kT1WHFz+paQ7PJSmd9+F+HU0RoqkXqyT0qTt1baW7xMDw75WY
         TlJxxks3AjoUL6qQ/Cj/7k79Xwi48dF0+prLTe1tcCB0Wk0aa8MYlu2ua2D7Jtz3LxsK
         F+fIXnfEYx+FMg5/o6QtJRyhXHPqI/5ncRSNF7V5qk5uW3lZ1t9mJX4xR+LwO9Iiycru
         MIs2EJtO+mxkArZQFP16jOsDFU1wOmS2mynfdUcvHex3qk9sgWlHjikh+jl69q5ASYST
         dFqw==
X-Gm-Message-State: AOAM533SMgObiFs6WhNbrmLJAhCZdA2l6LwV0+jTF5pZ4vWsqkgT/oZJ
        NC5lZjeWdFeeNKjzzzSt2ulQYw==
X-Google-Smtp-Source: ABdhPJyjEX2iatqs8Rpw3jRdeScsst9JctoPDeA6s/aCDfxBT52cKZsjTQOFXZkdskyhxwcfmxfAkg==
X-Received: by 2002:a63:1c12:: with SMTP id c18mr23063900pgc.356.1612286375831;
        Tue, 02 Feb 2021 09:19:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id l4sm3315225pju.26.2021.02.02.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 09:19:35 -0800 (PST)
Date:   Tue, 2 Feb 2021 09:19:29 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: move kvm_inject_gp up from kvm_set_xcr to
 callers
Message-ID: <YBmJoehBMbgvuuyW@google.com>
References: <20210202165141.88275-1-pbonzini@redhat.com>
 <20210202165141.88275-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202165141.88275-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> Push the injection of #GP up to the callers, so that they can just use
> kvm_complete_insn_gp.

The SVM and VMX code is identical, IMO we should push all the code to x86.c
instead of shuffling it around.

I'd also like to change svm_exit_handlers to take @vcpu instead of @svm so that
SVM can invoke common handlers directly.

If you agree, I'll send a proper series to do the above, plus whatever other
cleanups I find, e.g. INVD, WBINVD, etc...

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fa7b2df6422b..bf917efde35c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1530,7 +1530,7 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);

 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 687876211ebe..842a74d88f1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2334,14 +2334,7 @@ static int wbinvd_interception(struct vcpu_svm *svm)

 static int xsetbv_interception(struct vcpu_svm *svm)
 {
-       u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
-       u32 index = kvm_rcx_read(&svm->vcpu);
-
-       if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
-               return kvm_skip_emulated_instruction(&svm->vcpu);
-       }
-
-       return 1;
+       return kvm_emulate_xsetbv(&svm->vcpu);
 }

 static int rdpru_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf0c397dc3eb..474a169835de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5218,16 +5218,6 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu)
        return kvm_emulate_wbinvd(vcpu);
 }

-static int handle_xsetbv(struct kvm_vcpu *vcpu)
-{
-       u64 new_bv = kvm_read_edx_eax(vcpu);
-       u32 index = kvm_rcx_read(vcpu);
-
-       if (kvm_set_xcr(vcpu, index, new_bv) == 0)
-               return kvm_skip_emulated_instruction(vcpu);
-       return 1;
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
        if (likely(fasteoi)) {
@@ -5689,7 +5679,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
        [EXIT_REASON_APIC_WRITE]              = handle_apic_write,
        [EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
        [EXIT_REASON_WBINVD]                  = handle_wbinvd,
-       [EXIT_REASON_XSETBV]                  = handle_xsetbv,
+       [EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
        [EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
        [EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
        [EXIT_REASON_GDTR_IDTR]               = handle_desc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14fb8a138ec3..ef630f8d8bd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -984,16 +984,17 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
        return 0;
 }

-int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
+int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
        if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
-           __kvm_set_xcr(vcpu, index, xcr)) {
+           __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
                kvm_inject_gp(vcpu, 0);
                return 1;
        }
-       return 0;
+
+       return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_set_xcr);
+EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);

 bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {


