Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0544EBB6
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 18:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhKLREY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 12:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbhKLREX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 12:04:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D4C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 09:01:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso8087318pjo.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 09:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VeGP71NzWoQQd6cCJiug/uQuJURejP09aRjqzgCTBfk=;
        b=NtkoyEjKHc6Xn4X/LJyqef3xqvUGS079W8NtYqEYiOiQz3NfBgpH7LaFHtkUysnFGu
         nVSKDr+//uXJDqh6AafjH9N3/Q21QhlEbN8YGheXAwqO3vyUcPk+52Upu+nc9H6g5HNt
         DWw0oKbHFaeddcN/lD4T0dHQ2tiE0NKA2OTam5tiFLF+OIrI+F0fB6vqEm5EAV8guSiC
         AO/T5pZxDJMyelsCpF50WeDWZ8HADu8WWuv2WrlomQHa43/6PxWrL/3rW+w80d84h6Xs
         S1y73oWCb6yXgThgIU5YMeZKNo0O7C9QEeVdqMoeNx7+eF5cwMl7aQyjFtNswM5nVjtc
         PYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VeGP71NzWoQQd6cCJiug/uQuJURejP09aRjqzgCTBfk=;
        b=lHGVJ+PDczQ9LJFK/HAjjOzDJhj5TY1E0C66pFPm2zY9pR+nqd70eGLxbJY0DIKGf0
         cCUmPJQ5MIxVUAvW4XwjJ12il/f5ftJB0M58cjlQy4tVupYzOPuh9LMK8iL4AmbUvEWz
         K3N7RbqvtWmh04TliAS/cxL0g7+TJ21LjC08rf7K/drtnwSQg+WNrfQJJeSPPJ+HqsUA
         FiZl86Q7IcGIYz5DKjyN6AStSkXVOdzrPsQOebk2eWXnS054+TM0vB+13ilGhX/FQc2F
         wqi4VXu+rpow11RmZ9EwlKBons1fyyo91qGl5BfY7xGYyj9B5XwEL0ASSM409y6gDFa0
         a8wQ==
X-Gm-Message-State: AOAM533uKudTGUgKaZgDjf6Ary2nv9WeGf9CbGuzCl0EUpPy9hUuZx8Z
        BOrsGfyJgcS3Mit2q7Bqwz2nJQ==
X-Google-Smtp-Source: ABdhPJzVwuvoTZvv9S3bWPpUSl8MC8JKFmvfxQdzsR/rYhIPkyIIljB0lxQsBZK8RyQFHAut/b2XZQ==
X-Received: by 2002:a17:902:c94a:b0:141:fdaa:59ac with SMTP id i10-20020a170902c94a00b00141fdaa59acmr9359788pla.37.1636736491768;
        Fri, 12 Nov 2021 09:01:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id fs21sm10420998pjb.1.2021.11.12.09.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 09:01:31 -0800 (PST)
Date:   Fri, 12 Nov 2021 17:01:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 04/11] KVM: x86: Disable MCE related stuff for TDX
Message-ID: <YY6d57pWU8iJg/i+@google.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-5-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112153733.2767561-5-xiaoyao.li@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Xiaoyao Li wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> MCE is not supported for TDX VM and KVM cannot inject #MC to TDX VM.
> 
> Introduce kvm_guest_mce_disallowed() which actually reports the MCE
> availability based on vm_type. And use it to guard all the MCE related
> CAPs and IOCTLs.
> 
> Note: KVM_X86_GET_MCE_CAP_SUPPORTED is KVM scope so that what it reports
> may not match the behavior of specific VM (e.g., here for TDX VM). The
> same for KVM_CAP_MCE when queried from /dev/kvm. To qeuery the precise
> KVM_CAP_MCE of the VM, it should use VM's fd.
> 
> [ Xiaoyao: Guard MCE related CAPs ]
> 
> Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++++
>  arch/x86/kvm/x86.h |  5 +++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b02088343d80..2b21c5169f32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4150,6 +4150,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_MCE:
>  		r = KVM_MAX_MCE_BANKS;
> +		if (kvm)
> +			r = kvm_guest_mce_disallowed(kvm) ? 0 : r;

		r = KVM_MAX_MCE_BANKS;
		if (kvm && kvm_guest_mce_disallowed(kvm))
			r = 0;

or

		r = (kvm && kvm_guest_mce_disallowed(kvm)) ? 0 : KVM_MAX_MCE_BANKS;

>  		break;
>  	case KVM_CAP_XCRS:
>  		r = boot_cpu_has(X86_FEATURE_XSAVE);
> @@ -5155,6 +5157,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_X86_SETUP_MCE: {
>  		u64 mcg_cap;
>  
> +		r = EINVAL;
> +		if (kvm_guest_mce_disallowed(vcpu->kvm))
> +			goto out;
> +
>  		r = -EFAULT;
>  		if (copy_from_user(&mcg_cap, argp, sizeof(mcg_cap)))
>  			goto out;
> @@ -5164,6 +5170,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_X86_SET_MCE: {
>  		struct kvm_x86_mce mce;
>  
> +		r = EINVAL;
> +		if (kvm_guest_mce_disallowed(vcpu->kvm))
> +			goto out;
> +
>  		r = -EFAULT;
>  		if (copy_from_user(&mce, argp, sizeof(mce)))
>  			goto out;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a2813892740d..69c60297bef2 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -441,6 +441,11 @@ static __always_inline bool kvm_irq_injection_disallowed(struct kvm_vcpu *vcpu)
>  	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
>  }
>  
> +static __always_inline bool kvm_guest_mce_disallowed(struct kvm *kvm)

The "guest" part is potentially confusing and incosistent with e.g.
kvm_irq_injection_disallowed.  And given the current ridiculous spec, CR4.MCE=1
is _required_, so saying "mce disallowed" is arguably wrong from that perspective.

kvm_mce_injection_disallowed() would be more appropriate.

> +{
> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
> +}
> +
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  int kvm_spec_ctrl_test_value(u64 value);
> -- 
> 2.27.0
> 
