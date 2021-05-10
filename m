Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375F1377DB6
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhEJIKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhEJIKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oxvquNN/DeRfOUijTSqwF2POGMiEDfmanVEjyhInYWM=;
        b=MIkDMf9DqwhzsdnWqnFilIEYyDQ22UbKU2wADpTCjyRk49DFS1P23pZ65iWq4sD3685F36
        Nuet039PpuPmZRr9GPYta6LPv5zUohkkQ4FMVr1iQeHZHBxWGEWSDLmCReWgOebthIUU2U
        0Ei2MYWHuplobibTusjUXa955R4jj8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-UcUC3CJwMcqTVcGXkNrq1Q-1; Mon, 10 May 2021 04:08:55 -0400
X-MC-Unique: UcUC3CJwMcqTVcGXkNrq1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E8BD801817;
        Mon, 10 May 2021 08:08:54 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 627846268E;
        Mon, 10 May 2021 08:08:51 +0000 (UTC)
Message-ID: <e12e4e88e61b46c75086c75b7f20960e833f9d07.camel@redhat.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:08:50 +0300
In-Reply-To: <20210504171734.1434054-4-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.
> 
> Note, SVM does not support intercepting RDPID.  Unlike VMX's
> ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
> is a benign virtualization hole as the host kernel (incorrectly) sets
> MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
> into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
> the host's MSR_TSC_AUX to the guest.
> 
> But, when the kernel bug is fixed, KVM will start leaking the host's
> MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
> for whatever reason.  This leak will be remedied in a future commit.
> 
> Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a7271f31df47..8f2b184270c0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1100,7 +1100,9 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  	return svm->vmcb->control.tsc_offset;
>  }
>  
> -static void svm_check_invpcid(struct vcpu_svm *svm)
> +/* Evaluate instruction intercepts that depend on guest CPUID features. */
> +static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
> +					      struct vcpu_svm *svm)
>  {
>  	/*
>  	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
> @@ -1113,6 +1115,13 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
>  		else
>  			svm_clr_intercept(svm, INTERCEPT_INVPCID);
>  	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP)) {
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> +		else
> +			svm_set_intercept(svm, INTERCEPT_RDTSCP);
> +	}
>  }
>  
>  static void init_vmcb(struct kvm_vcpu *vcpu)
> @@ -1248,7 +1257,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		svm_clr_intercept(svm, INTERCEPT_PAUSE);
>  	}
>  
> -	svm_check_invpcid(svm);
> +	svm_recalc_instruction_intercepts(vcpu, svm);
>  
>  	/*
>  	 * If the host supports V_SPEC_CTRL then disable the interception
> @@ -3084,6 +3093,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_STGI]				= stgi_interception,
>  	[SVM_EXIT_CLGI]				= clgi_interception,
>  	[SVM_EXIT_SKINIT]			= skinit_interception,
> +	[SVM_EXIT_RDTSCP]			= kvm_handle_invalid_op,
>  	[SVM_EXIT_WBINVD]                       = kvm_emulate_wbinvd,
>  	[SVM_EXIT_MONITOR]			= kvm_emulate_monitor,
>  	[SVM_EXIT_MWAIT]			= kvm_emulate_mwait,
> @@ -4007,8 +4017,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
>  			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
>  
> -	/* Check again if INVPCID interception if required */
> -	svm_check_invpcid(svm);
> +	svm_recalc_instruction_intercepts(vcpu, svm);
>  
>  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
>  	if (sev_guest(vcpu->kvm)) {
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

