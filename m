Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B02FBF0C
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbhASScV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389938AbhASSbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:31:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7FFC061574
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 10:31:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cq1so449316pjb.4
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 10:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qeHz0k448eNAbSKl9/y70hCJkDl4GVJ8biKbIHgRs58=;
        b=oKQDQb0xVyKRV+/c4nGVqoHTRSOtYoXMUS40R6UzHy2rVBQ0LY3zo71wAW/zDtDfVu
         ZXc3RAFhSoj7phzKYsx3VWfe1Pac1RZfBNSxzRbfi0r+BK5OfZ9j/G1I425LaQZxhtJE
         O+htKGMxky9G117TgbnhbKuRrMtcwOBD1HBAIdbhVyF5RHczvp8HQJfjzxOfGSKunybL
         fBgseqmqSghh3OIO8faPOaF2b5H8e21Afwa3nBs+oDvQ/r41K2K8OgZegGIt4yundmE1
         BiapXiavE7MAvPGAlvVd+6NqBPO3AKP5JXQiJWtl5Q663kjwMWsm+0Mz1Hk6sCxZj6fx
         Xh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qeHz0k448eNAbSKl9/y70hCJkDl4GVJ8biKbIHgRs58=;
        b=ZhjR8NKsWmo6N1EK9+DKy7pl2nKB29V6+sGMbpEy4cdBKbmcProGo+CMNSqt0HlOUK
         Cn5xrkjNnPUj/mVbmc/m9ng3XxoEEG2HsNBFXUHT2InZW80I262nVLtAHKe+OAB04Jn1
         GXEjIakjCrCsBo+qeCNVJ5sJJe5e8vSrsOcSsZkLb1MPmJoWdgcUbabxcJvLEMT4TZ1i
         1v5jNjmsFVzy1BkWIwF9xNzFoOkZq8Vgb2KZzV9+Q2epk6l+zeCHzm5/fCrYVh7FDDYL
         5/46jb86cU3SIviw8NEJB9ManqmvX2VLm025LeZ3SRcWCQwJukkBNfS89QGn9mkIHHVx
         4YLw==
X-Gm-Message-State: AOAM53040JKqez0HMc8WnlqIphUvgFXH3LolrWC1xbtIfTxmoj+DR9MO
        ErxAQZvDdfWo11EDjx2a3dMxzw==
X-Google-Smtp-Source: ABdhPJyDMuwnx++1Z35LFUhv27uQ5v8Xr4vR1+tqzfxAM8zbcvKlDr8AEeVfN8tTeqnKtADYp9PxQA==
X-Received: by 2002:a17:90a:df15:: with SMTP id gp21mr1046339pjb.63.1611081074224;
        Tue, 19 Jan 2021 10:31:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u1sm3736060pjr.51.2021.01.19.10.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 10:31:13 -0800 (PST)
Date:   Tue, 19 Jan 2021 10:31:05 -0800
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
Subject: Re: [PATCH v3 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Message-ID: <YAclaWCL20at/0n+@google.com>
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
 <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Babu Moger wrote:
> ---
>  arch/x86/include/asm/svm.h |    4 +++-
>  arch/x86/kvm/svm/sev.c     |    4 ++++
>  arch/x86/kvm/svm/svm.c     |   19 +++++++++++++++----
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 1c561945b426..772e60efe243 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -269,7 +269,9 @@ struct vmcb_save_area {
>  	 * SEV-ES guests when referenced through the GHCB or for
>  	 * saving to the host save area.
>  	 */
> -	u8 reserved_7[80];
> +	u8 reserved_7[72];
> +	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
> +	u8 reserved_7b[4];

Don't nested_prepare_vmcb_save() and nested_vmcb_checks() need to be updated to
handle the new field, too?

>  	u32 pkru;
>  	u8 reserved_7a[20];
>  	u64 reserved_8;		/* rax already available at 0x01f8 */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..959d6e47bd84 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -546,6 +546,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->pkru = svm->vcpu.arch.pkru;
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  
> +	/* Update the guest SPEC_CTRL value in the save area */
> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		save->spec_ctrl = svm->spec_ctrl;

I think this can be dropped if svm->spec_ctrl is unused when V_SPEC_CTRL is
supported (see below).  IIUC, the memcpy() that's just out of sight would do
the propgation to the VMSA.

> +
>  	/*
>  	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>  	 * the traditional VMSA that is part of the VMCB. Copy the
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..a0cb01a5c8c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1244,6 +1244,9 @@ static void init_vmcb(struct vcpu_svm *svm)
>  
>  	svm_check_invpcid(svm);
>  
> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		save->spec_ctrl = svm->spec_ctrl;
> +
>  	if (kvm_vcpu_apicv_active(&svm->vcpu))
>  		avic_init_vmcb(svm);
>  
> @@ -3789,7 +3792,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * is no need to worry about the conditional branch over the wrmsr
>  	 * being speculatively taken.
>  	 */
> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
> +	else
> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);

Can't we avoid functional code in svm_vcpu_run() entirely when V_SPEC_CTRL is
supported?  Make this code a nop, disable interception from time zero, and
read/write the VMBC field in svm_{get,set}_msr().  I.e. don't touch
svm->spec_ctrl if V_SPEC_CTRL is supported.  

	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);

	svm_vcpu_enter_exit(vcpu, svm);

	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

>  	svm_vcpu_enter_exit(vcpu, svm);
>  
> @@ -3808,13 +3814,18 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>  	 * save it.
>  	 */
> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> -		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> +	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))) {
> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +			svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
> +		else
> +			svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> +	}
>  
>  	if (!sev_es_guest(svm->vcpu.kvm))
>  		reload_tss(vcpu);
>  
> -	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>  
>  	if (!sev_es_guest(svm->vcpu.kvm)) {
>  		vcpu->arch.cr2 = svm->vmcb->save.cr2;
> 
