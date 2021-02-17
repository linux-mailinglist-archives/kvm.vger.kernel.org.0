Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668BC31DEA5
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 18:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhBQRxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 12:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhBQRxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 12:53:16 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D7C061756
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:52:35 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id b21so8951844pgk.7
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOCe5PYkwzvBTCjUqjfwu5MbezXLsz+MQqoZZzPtqIo=;
        b=NI6hmK7fnoNmYMxf/0vyYTIo3++c2idrXg3o/ifyuLeFiTt2sQ89GSvi4wLeK/Qz+o
         JbPnre5of7Ms0SQwkzvIeTussofIVt4zjs2Uvr+q+GeyZxoDgUpUhfHh+EbZsIA75ZDM
         mHMIQ/O7CVMgizZt26p42mhfK3N6+tikwo+P43BL6oxeVgUokbX5wV5rgYRZoVGM0OOj
         SNNuSrWaWaJP2Yolu67DxZz6PCYlSQdpm3aLrDTTfkwML6oHB1oqR240ydUFDSrZxVgI
         YxLlMM1ZOLTfcTseKx1oKHpPoh9710BOiTyHi9rcjWd6sdRlCAI2i9oU7dGtPWJDM8lP
         d9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOCe5PYkwzvBTCjUqjfwu5MbezXLsz+MQqoZZzPtqIo=;
        b=RCz35VfzsB02sjcY+0o56QV1Rhs1Gxue21ipKJJhBdpkWQF3tMj1AJTYH/I+6pL7vt
         9y/e8J2McIYpeJEk07q9XC47tK66JypTuh1V91GSefi1Uq1amDt6AZ1dKhU/4fV1p120
         pxtH+wlBU7rfGpvDkuFt35tqAX38XPOJ+tJ5VH1qPxjfxppuM5hE2Xa/drXUV6vF6mfh
         EilbbR0KJj2OWD4sQQ8qo1AtDQ5lI/OXiN9uP1LeiZ7OPMa6I2Rq2OPzWQ4TXzQfc90F
         wdM+TPZO18BPUlv3Gk6ZCvKtpoMOXJmoBalM1TTr5giioVxBBVUKaE4+fUwGqLXpJHxl
         vCAQ==
X-Gm-Message-State: AOAM532rxPxXS7mfBQIWd4L2Q6ySD4gdhkwhdKHxVXKcYFJCZtHSPalE
        bjak4lY4I7gSBY/d2VsRlDoxgg==
X-Google-Smtp-Source: ABdhPJwoAtT56T+4DDBERd3JGUyUosvrp4cFYFB9PD9fRIT3zOPWW9o59YqkEzdm9rwWeZhnIZIxmw==
X-Received: by 2002:a62:6005:0:b029:1d9:ce00:26cf with SMTP id u5-20020a6260050000b02901d9ce0026cfmr318256pfb.7.1613584351227;
        Wed, 17 Feb 2021 09:52:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id z22sm3288603pfa.41.2021.02.17.09.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 09:52:30 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:52:24 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 6/7] KVM: nVMX: don't load PDPTRS right after nested
 state set
Message-ID: <YC1X2FMdPn32ci1C@google.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217145718.1217358-7-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021, Maxim Levitsky wrote:
> Just like all other nested memory accesses, after a migration loading
> PDPTRs should be delayed to first VM entry to ensure
> that guest memory is fully initialized.
> 
> Just move the call to nested_vmx_load_cr3 to nested_get_vmcs12_pages
> to implement this.

I don't love this approach.  KVM_SET_NESTED_STATE will now succeed with a bad
vmcs12.GUEST_CR3.  At a minimum, GUEST_CR3 should be checked in
nested_vmx_check_guest_state().  It also feels like vcpu->arch.cr3 should be set
immediately, e.g. KVM_SET_NESTED_STATE -> KVM_GET_SREGS should reflect L2's CR3
even if KVM_RUN hasn't been invoked.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f9de729dbea6..26084f8eee82 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2596,11 +2596,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		return -EINVAL;
>  	}
>  
> -	/* Shadow page tables on either EPT or shadow page tables. */
> -	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> -				entry_failure_code))
> -		return -EINVAL;
> -
>  	/*
>  	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
>  	 * on nested VM-Exit, which can occur without actually running L2 and
> @@ -3138,11 +3133,16 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	enum vm_entry_failure_code entry_failure_code;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct kvm_host_map *map;
>  	struct page *page;
>  	u64 hpa;
>  
> +	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
> +				&entry_failure_code))
> +		return false;
> +
>  	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
>  		/*
>  		 * Translate L1 physical address to host physical
> @@ -3386,6 +3386,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	if (from_vmentry) {
> +		if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3,
> +		    nested_cpu_has_ept(vmcs12), &entry_failure_code))
> +			goto vmentry_fail_vmexit_guest_mode;

This neglects to set both exit_reason.basic and vmcs12->exit_qualification.

> +
>  		failed_index = nested_vmx_load_msr(vcpu,
>  						   vmcs12->vm_entry_msr_load_addr,
>  						   vmcs12->vm_entry_msr_load_count);
> -- 
> 2.26.2
> 
