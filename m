Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45C038838A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhESAJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 20:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbhESAJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 20:09:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA4DC061760
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 17:08:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso2451558pjb.5
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 17:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AvMPVw0tg5Dj6coxQ9DiblbWWNkeUP+FuTEACH0pmmE=;
        b=X6Jdzqp7soe6JpB+RYT10AVUzXA5SlKvXRdGCd9/Z1X1D5TRamVRfK1C3mBi4yVGTJ
         tyA6W9NNnzOR16JmphyK+GUYskg44Fz6qeLfS6tv3xIfWk7PLKIrknhyxIVu+sgNgz84
         GUzDjwKTNSN6vGYXClxgMaCVMFOqzH1ZfDPTJfDLUmLl/CTsZ5gVcUlX+9rRuITembQ3
         3x8VldsMd2XLXhv20MVP+gb3x365rniF7SK4YgeiCB+QSljDztRBrjAGKKoJ+9NOzY1l
         y5YuCjC85E2nMNFY5RxC34lyDvLY+m+KPJ1EU14m3f8txvr6TnVzzg7Iaetm0VEpkrB7
         tljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AvMPVw0tg5Dj6coxQ9DiblbWWNkeUP+FuTEACH0pmmE=;
        b=CtvB8mfmrGPEr4tgFDKbf5QNDZooCyC8r+yJ/5GHWz8Znh+v8qMAR/I6TzfpG+RjlC
         /O9iCa1wymBeOErUThmlcpwtASvwaI1BBDnlvfQ91iV/kYIXPMO4B70kETYmRUIfIdEC
         DfAeh4UUWidPe3Iw32BmITBDWlr8grZWF3vzqbPmziasw8GBbW2yNrmAzWDwV5LGrKrX
         hI+/HARwiz4reoKIGIKpjsoaYZQRpI30/MWx0FvK7OFlXIprKWyZhhHG8DWIRsLgd1AJ
         wir8nSNIiHL2nf+FjgRqgrR9kr7jxS3r9JV9X89LCbw00dE6IqduUn7usDJyVualz2yh
         blKQ==
X-Gm-Message-State: AOAM531IF+0zPEWVlfjPERIUOhDNuegO73El+0CwhGlI7VIr0dcUq6ZZ
        VBsRTY22NGpa2itQRTeouT1TfrsQvHVszg==
X-Google-Smtp-Source: ABdhPJyLsR01tQg11ggiMn8P8sQKtnWQ0lI1kVVOSQW3GOWH3n0+8jbZrbcKq9iwy4KTUfJK9ymVmA==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr8271086pjb.213.1621382881017;
        Tue, 18 May 2021 17:08:01 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d7sm2547470pfa.40.2021.05.18.17.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 17:08:00 -0700 (PDT)
Date:   Wed, 19 May 2021 00:07:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v2 08/10] KVM: VMX: Set the TSC offset and multiplier on
 nested entry and exit
Message-ID: <YKRW3EF5NHBlJEOn@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-9-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512150945.4591-9-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ilias Stamatis wrote:
> Now that nested TSC scaling is supported we need to calculate the
> correct 02 values for both the offset and the multiplier using the
> corresponding functions. On L2's exit the L1 values are restored.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6058a65a6ede..f1dff1ebaccb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3354,8 +3354,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	enter_guest_mode(vcpu);
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> +
> +	kvm_set_02_tsc_offset(vcpu);
> +	kvm_set_02_tsc_multiplier(vcpu);

Please move this code into prepare_vmcs02() to co-locate it with the relevant
vmcs02 logic.  If there's something in prepare_vmcs02() that consumes
vcpu->arch.tsc_offset() other than the obvious VMWRITE, I vote to move things
around to fix that rather than create this weird split.

>  	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
>  		exit_reason.basic = EXIT_REASON_INVALID_STATE;
> @@ -4463,8 +4464,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	if (nested_cpu_has_preemption_timer(vmcs12))
>  		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
>  
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
> +	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
> +		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
> +
> +		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
> +			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> +	}
>  
>  	if (likely(!vmx->fail)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
> -- 
> 2.17.1
> 
