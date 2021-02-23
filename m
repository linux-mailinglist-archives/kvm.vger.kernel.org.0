Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498613233E7
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 23:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhBWWqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 17:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhBWWnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 17:43:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C60C06178A
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 14:42:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e9so3006826pjj.0
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 14:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3X9RsbT+EkP8KOLo4leGyvzPPYNl+5jnHk95JrGfpNc=;
        b=DjiTtFBjXhh9NgpVr88R1zSE+9jtAiD2zCqSurmyDlmqYcv1kenhoFbpwv+QJeI4gH
         SE5QjjM6ifKOMzpNB/7YEGBydTNOOd5g3RL3DtT3zoTxwJ00KG0h25BCJ0EXjze+0rP3
         wmNhbBsGke79Hl/tW5Akvj7RVk2vRSIPQr4kIk4yOkxE1OiV9gbFqEfXe2nbUBpERlU3
         xq172LBuxoZuYxHi8Scp1BKF0fqSBZv8jQnhKkoTR8KrT7kDeApPXGDLmC+fbPZFQRRA
         iNS3AMxBmj7nJxPKjcxg31GM1WPEU1uM5g8sjuDyC098sIp0NyHpRUeF7k2vFfNsmPQY
         rgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3X9RsbT+EkP8KOLo4leGyvzPPYNl+5jnHk95JrGfpNc=;
        b=pwskEPfXUAYoSRLUmxJjhuy3oYflhwL3dSVhglVC9JOXCI7vE9jnZ3UmngPFHGS35h
         ujgvchru+wQstZyl14vjtnRq2K6eo1aqIbqqhaa1l8QpumpzXP6fG7GxKXhYiD8bIX21
         T6YTj/4LDhyvLb2h1uq3O2ZrepbEDfcBVf5WXD83X9dNYZhEdmPrrjVoOesa69Vg/HOt
         qsSNRs4QJcPlu5h0YPyuloVhnMfpbUq26j/x5WEA5XsjpSp7rTxPocPFrm8p0YSoo6wJ
         Su58UQPsCa7V/JQ4jt/yGjmdjQxzruLCAHZGxW6PtICSMJOp+IBPamQFj3p2qlj0mLrN
         oz9Q==
X-Gm-Message-State: AOAM532rAnyt9SNa06Yvv59iDZaT80E+9EY5bPWzH6PfeGIk65L5CpiX
        6jTjDksm9rHt4Igwn5od03A84mH2nqme/A==
X-Google-Smtp-Source: ABdhPJyT1f4IHJ5oXjH7bwHWT4VnjXnzUZIyBmJPepe9KUByAVJ95lPhNMmCH36wQXbZmpn9AvmAHw==
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr1036216pjb.35.1614120166898;
        Tue, 23 Feb 2021 14:42:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:c939:813f:76bc:d651])
        by smtp.gmail.com with ESMTPSA id ga17sm162200pjb.7.2021.02.23.14.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 14:42:46 -0800 (PST)
Date:   Tue, 23 Feb 2021 14:42:37 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN
 completion if the latter is single-stepped
Message-ID: <YDWE3cYXoQRq+XZ3@google.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
 <20210223191958.24218-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223191958.24218-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021, Krish Sadhukhan wrote:
> Currently, svm_vcpu_run() advances the RIP following VMRUN completion when
> control returns to host. This works fine if there is no trap flag set
> on the VMRUN instruction i.e., if VMRUN is not single-stepped. But if
> VMRUN is single-stepped, this advancement of the RIP leads to an incorrect
> RIP in the #DB handler invoked for the single-step trap. Therefore, check
> if the VMRUN instruction is single-stepped and if so, do not advance the RIP
> when the #DB intercept #VMEXIT happens.

This really needs to clarify which VMRUN, i.e. L0 vs. L1.  AFAICT, you're
talking about both at separate times.  Is this an issue with L1 single-stepping
its VMRUN, L0 single-stepping its VMRUN, L0 single-stepping L1's VMRUN, ???
 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
> ---
>  arch/x86/kvm/svm/svm.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3442d44ca53b..427d32213f51 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3740,6 +3740,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	instrumentation_end();
>  }
>  
> +static bool single_step_vmrun = false;

Sharing a global flag amongst all vCPUs isn't going to fare well...

> +
>  static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3800,6 +3802,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	svm_vcpu_enter_exit(vcpu, svm);
>  
> +	if (svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
> +	    (svm->vmcb->save.rflags & X86_EFLAGS_TF))
> +                single_step_vmrun = true;
> +
>  	/*
>  	 * We do not use IBRS in the kernel. If this vCPU has used the
>  	 * SPEC_CTRL MSR it may have left it on; save the value and
> @@ -3827,7 +3833,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  		vcpu->arch.cr2 = svm->vmcb->save.cr2;
>  		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
>  		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
> -		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
> +		if (single_step_vmrun && svm->vmcb->control.exit_code ==
> +		    SVM_EXIT_EXCP_BASE + DB_VECTOR)
> +			single_step_vmrun = false;

Even if you fix the global flag issue, this can't possibly work if userspace
changes state, if VMRUN fails and leaves a timebomb, and probably any number of
other conditions.

> +		else
> +			vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
>  	}
>  
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
> -- 
> 2.27.0
> 
