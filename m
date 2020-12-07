Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580122D1E2A
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgLGXOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgLGXOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:14:04 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD89C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:13:23 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e2so2059371pgi.5
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Gbbh4ibxUFpi3OAKBtYtSpm5Z1JaNbGkY8hc3Ov1OeA=;
        b=rQuROwycmhYuaF7TU7X0pJ/7xgAKppbha0BqNqI/sLgV4WGQtuvMyx/qz4/M6diqaM
         4yf4lx3yMt5uuRfdfcWpaRMCphkexOi4D552m/ygiWSe6uLCLJxxpRtLSxWw0NXKf6MQ
         I54+XaVd9b0lekf+QJbUGZtHpZ82agD2LA9P+yl19No7qjTNsXYYXMfeSa+xaU8mMFEi
         uLrDoqpU20YTcJTGOaA1cj2Op/n7hQuB+LEPk1gLvyx8DoeLtoiy2GNrITZQoJeo5jUB
         IaDgnyi+LRWPnIpDRD7nUL3A1fFkN71X5vkdgCoq2/zAz32iDISvdGw7DTfMZxG1dzG1
         IEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Gbbh4ibxUFpi3OAKBtYtSpm5Z1JaNbGkY8hc3Ov1OeA=;
        b=aTpDvh+FTxHUCmFyXSqU1HxSrqFBJelgGdheN3U7wg7TjyMsT8h1Qd/6rH68IZwEDR
         eBzndsDFkeY+bjWPNabdPF6h/tMCiWy4QTOsL4rxPUsBrxPQ+vLysTpEZ4yMTTQ1VBUO
         ACIsauaNcWJ4dwGpz5uc0s1zp57R1/EwjBA1W52XR7AzqxThFuTow8/zfhBMusd86vJ+
         SJ4P5j3SfppfDUH6jl/fmwHX7f2FWP2yg73p6Y4gKJiHp7Ml4t+jYOHhRzeqOII29nuU
         Ai5z4Gj5lB9uCpsz2k3oGmOKBQkH8uBMfPl30C8XBE5a4CFdxEDqTM2mbtkpJBw44uqK
         sKGQ==
X-Gm-Message-State: AOAM532YnRawzqs7zm7sYxGQmTIzLfPwlrAysCcOaHZhtqS3Je5Jcjcz
        BxXLPktwrZGI3pZ4kh2Td4vwrNJsJzXuMw==
X-Google-Smtp-Source: ABdhPJzgZm8lZG6NLh0a3gHZKxqCco0EwwEK2TdtHU5AGRJyE33wH6Jn7x6sYZJjVFNbqYCNbs1S4A==
X-Received: by 2002:a17:902:6b45:b029:d6:c43e:ad13 with SMTP id g5-20020a1709026b45b02900d6c43ead13mr18461110plt.77.1607382802822;
        Mon, 07 Dec 2020 15:13:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c3sm13598807pgm.41.2020.12.07.15.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:13:22 -0800 (PST)
Date:   Mon, 7 Dec 2020 15:13:15 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, joro@8bytes.org,
        x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Message-ID: <X863C6ikshtMHemk@google.com>
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020, Babu Moger wrote:
> Newer AMD processors have a feature to virtualize the use of the
> SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
> virtualized and no longer requires hypervisor intervention.

Hrm, is MSR_AMD64_VIRT_SPEC_CTRL only for SSBD?  Should that MSR be renamed to
avoid confusion with the new form of VIRT_SPEC_CTRL?

> This feature is detected via CPUID function 0x8000000A_EDX[20]:
> GuestSpecCtrl.
> 
> Hypervisors are not required to enable this feature since it is
> automatically enabled on processors that support it.
> 
> When this feature is enabled, the hypervisor no longer has to
> intercept the usage of the SPEC_CTRL MSR and no longer is required to
> save and restore the guest SPEC_CTRL setting when switching
> hypervisor/guest modes.

Well, it's still required if the hypervisor wanted to allow the guest to turn
off mitigations that are enabled in the host.  I'd omit this entirely and focus
on what hardware does and how Linux/KVM utilize the new feature.

> The effective SPEC_CTRL setting is the guest SPEC_CTRL setting or'ed with the
> hypervisor SPEC_CTRL setting. 

This line needs to be higher in the changelog, it's easily the most relevant
info for understanding the mechanics.  Please also explicitly state the context
switching mechanics, e.g. is it tracked in the VMCB, loaded on VMRUN, saved on
VM-Exit, etc...

> This allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
>
> This support also fixes an issue where a guest may sometimes see an
> inconsistent value for the SPEC_CTRL MSR on processors that support
> this feature. With the current SPEC_CTRL support, the first write to
> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> will be 0x0, instead of the actual expected value. There isn’t a
> security concern here, because the host SPEC_CTRL value is or’ed with
> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> MSR just before the VMRUN, so it will always have the actual value
> even though it doesn’t appear that way in the guest. The guest will
> only see the proper value for the SPEC_CTRL register if the guest was
> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> support, the MSR interception of SPEC_CTRL is disabled during
> vmcb_init, so this will no longer be an issue.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 79b3a564f1c9..3d73ec0cdb87 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
>  
>  	svm_check_invpcid(svm);
>  
> +	/*
> +	 * If the host supports V_SPEC_CTRL then disable the interception
> +	 * of MSR_IA32_SPEC_CTRL.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
> +				     1, 1);
> +
>  	if (kvm_vcpu_apicv_active(&svm->vcpu))
>  		avic_init_vmcb(svm);
>  
> @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * is no need to worry about the conditional branch over the wrmsr
>  	 * being speculatively taken.
>  	 */
> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>  
>  	svm_vcpu_enter_exit(vcpu, svm);
>  
> @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>  	 * save it.
>  	 */
> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> +	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))

This will break migration, or maybe just cause wierdness, as userspace will
always see '0' when reading SPEC_CTRL and its writes will be ignored.  Is there
a VMCB field that holds the guest's value?  If so, this read can be skipped, and
instead the MSR set/get flows probably need to poke into the VMCB.

>  		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
>  
>  	reload_tss(vcpu);
>  
> -	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>  
>  	vcpu->arch.cr2 = svm->vmcb->save.cr2;
>  	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
> 
