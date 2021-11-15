Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F564508EB
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 16:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhKOPyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 10:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbhKOPx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 10:53:56 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B29C0613B9
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 07:50:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so14850193plf.3
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 07:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BME1fSm2ROoLW7jWsWBGz1p8OXFk8JxNq5V1TauLp5Q=;
        b=HLvcHQp96QuOXyuPkCmhG2g+hcaPjiFRwauPLK//j87Y8hIfIJCg2yJtpLe6zKLUtz
         wmHI9JKK53uxNOBhREJNRGMMO1WAUt1qAiQlZ0GlSWqw5dR8zZ5hMwtHXmHL19rzoJPh
         X8X7pAkulAeWcuzJu8LGJE4zzTk4eGKX9EnwVyunm12PqycouX4nkBcZXdgKlxXNDUVn
         xz8+KQhL2Y4xVqqmDcPwRJC66+Aq7Q/LGx0TRytcv9s67zx1DBu3Kt3G2UoYLqzLat5a
         wmFg58k56pIJsp/BLajEadwgSrqZaSfxzCqwRV3BhY49uKpOFvI47q19MJhBQjzireUw
         1ZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BME1fSm2ROoLW7jWsWBGz1p8OXFk8JxNq5V1TauLp5Q=;
        b=jWDenZKXxq1Onr6BK2bTq6JQXXe0rXSyJwL1IniQXSdBFos15UBgpjVdef1k4XmNTs
         Pwnqi3B5tM0HltzOplFNxjod5uNqP9vAXNAU6EI9w8S0/2MGK+z2etf369DC5hL4l6P+
         yPIawp+jUrjQjtzOL4z8g4qmez/QiXbBqEpcpB5p2rzsiMZvsanhlaAcBacw/wll+vHI
         heo6y3HEwSbTGiHCjTlKyo4RrWTiSVzrbqCdzc+VCWG0LECQtq/2ki4h0eaRzkw5qg1z
         zZ76xA3v6QMKzJxOnhCoydul6roM0u2vR6DPaRStFxmTf4qnB4hJFOhGxUz8YTKweH+x
         hoGg==
X-Gm-Message-State: AOAM531F6oqwlEniRQz+GoUbTRdQWm7ISuhZMs5cHfLtkEW3dG3snMV8
        X/wV+Jplz9rLS6fSwChbcNBI3A==
X-Google-Smtp-Source: ABdhPJzkfNPFqJ2eOjVOjj++a8Q9aY0YzRwahIlHWylknHl5m6qCJ7esoFXilZ+0DUMiswsVTzJoWA==
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id i11-20020a1709026acb00b0014276c3d35fmr36151012plt.89.1636991457936;
        Mon, 15 Nov 2021 07:50:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v16sm12279434pgo.71.2021.11.15.07.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 07:50:57 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:50:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] KVM: nVMX: don't use vcpu->arch.efer when
 checking host state on nested state load
Message-ID: <YZKB3Q1ZMsPD6hHl@google.com>
References: <20211115131837.195527-1-mlevitsk@redhat.com>
 <20211115131837.195527-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115131837.195527-2-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Maxim Levitsky wrote:
> When loading the nested state, due to the way qemu loads
> the nested state, vcpu->arch.efer contains L2' IA32_EFER which
> can be completely different from L1's IA32_EFER, thus it is
> wrong to do consistency check of it vs the vmcs12 exit fields.

This is not sufficient justification.  It makes it sound like KVM is hacking
around a bug in its ABI, which it is not, but that fact is _very_ subtle.  The
"trust" blurb in bullet (3) in particular is misleading.

Instead, I would like something like:

  When loading nested state, don't use check vcpu->arch.efer to get the
  L1 host's 64-bit vs. 32-bit state and don't check it for consistency
  with respect to VM_EXIT_HOST_ADDR_SPACE_SIZE, as register state in vCPU
  may be stale when KVM_SET_NESTED_STATE is called and conceptually does
  not exist.  When the CPU is in non-root mode, i.e. when restoring L2
  state in KVM, there is no snapshot of L1 host state, it is (conditionally)
  loaded on VM-Exit.  E.g. EFER is either preserved on exit, loaded from the
  VMCS (vmcs12 in this case), or loaded from the MSR load list.

  Use vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE to determine the target mode of
  the L1 host, as it is the source of truth in this case.  Perform the EFER
  vs. vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE consistency check only on VM-Enter,
  as conceptually there's no "current" L1 EFER to check.

  Note, KVM still checks vmcs12.HOST_EFER for consistency if
  if vmcs12.VM_EXIT_LOAD_IA32_EFER is set, i.e. this skips only the check
  against current vCPU state, which does not exist, when loading nested state.

> To fix this
> 
> 1. Split the host state consistency check
> between current IA32_EFER.LMA and 'host address space' bit in VMCS12 into
> nested_vmx_check_address_state_size.
> 
> 2. Call this check only on a normal VM entry, while skipping this call
> on loading the nested state.
> 
> 3. Trust the 'host address space' bit to contain correct ia32e
> value on loading the nested state as it is the best value of
> it at that point.
> Still do a consistency check of it vs host_ia32_efer in vmcs12.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b4ee5e9f9e201..7b1d5510a7cdc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2866,6 +2866,17 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int nested_vmx_check_address_state_size(struct kvm_vcpu *vcpu,
> +				       struct vmcs12 *vmcs12)

Bad indentation.

> +{
> +#ifdef CONFIG_X86_64
> +	if (CC(!!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) !=
> +		!!(vcpu->arch.efer & EFER_LMA)))

Bad indentation.  The number of !'s is also unnecessary.  This also needs a comment
explaining why it's not included in the KVM_SET_NESTED_STATE path.

> +		return -EINVAL;
> +#endif
> +	return 0;
> +}
> +
>  static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  				       struct vmcs12 *vmcs12)
>  {
> @@ -2890,18 +2901,16 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  #ifdef CONFIG_X86_64
> -	ia32e = !!(vcpu->arch.efer & EFER_LMA);
> +	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);


>  #else
>  	ia32e = false;
>  #endif
>  
>  	if (ia32e) {
> -		if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
> -		    CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
> +		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
>  			return -EINVAL;
>  	} else {
> -		if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
> -		    CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
> +		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
>  		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
>  		    CC((vmcs12->host_rip) >> 32))
>  			return -EINVAL;
> @@ -3571,6 +3580,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (nested_vmx_check_controls(vcpu, vmcs12))
>  		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>  
> +	if (nested_vmx_check_address_state_size(vcpu, vmcs12))
> +		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +
>  	if (nested_vmx_check_host_state(vcpu, vmcs12))
>  		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  
> -- 
> 2.26.3
> 
