Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97199218663
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgGHLuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:50:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40306 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728757AbgGHLuC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 07:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594209000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xM3KNO4zTe2DwnAsh9jy5dc/gc1QWSrQFG/k46eKNXU=;
        b=RPPqgFfxBK/AetqXiSZq2+A5Y71UgIUyeDF8JKMCui1d5Xxj3Mp/xNO3f89IUzjuqznuwR
        6siqhRHRsyWV7jT9GBNCsdFxlDTlENDiNLBJItR1XOSASAFjO9qUMEyEGV4mMkWP7agbh6
        GJewrY+Okc4oE3Ki7RKWHyww6Fnrl6w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-pPXSHbQEPY2M76HLGTgkQw-1; Wed, 08 Jul 2020 07:49:58 -0400
X-MC-Unique: pPXSHbQEPY2M76HLGTgkQw-1
Received: by mail-wm1-f70.google.com with SMTP id e15so2635273wme.8
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xM3KNO4zTe2DwnAsh9jy5dc/gc1QWSrQFG/k46eKNXU=;
        b=suHpEnyx+o251JNm5Ep1ZzUgG8KtklwTbJu2qdTScmk9Qd9FQtr2wvQOTsplD2MuuQ
         RJ5S/Nnhlv+IToLoKQBTz+SOMdo3GAlfETIjVEP7N622mupe4P3BnG0M3RAlFvNlUons
         QlAc2jnXPBvHMpliSWGIgEkyiy0HDFQxb5Kdi0aLElypBjkPOiTZ5Sm5IhuOXowWhZSc
         hhDm5HNlwDeOs9dPBrdSF9gFs1wNJxeXU9MuV2DoBHmztsu4nNjHYucd7z1VCtsSd6ew
         5BZqX6/jJGRujZ2yNjm5uxP2bHmXmbE9tXAoGTLjJ615Fc4uM+oPLw7vZXU1Q/AWvwcz
         XkeQ==
X-Gm-Message-State: AOAM533eoA14WKEDXmtM7Lbp2ax2U4yWLZcwcGUd7S0J12d6/p2AzsCt
        IXCPeDwDMds5rhf8Pe8PVU2o1KtBUK+SBNzXKrUEmn2j0brFQZCnSDKEpaxyA2uy/b/OaU37+OZ
        UDqlCH+X2rhQb
X-Received: by 2002:adf:f34e:: with SMTP id e14mr57807330wrp.299.1594208997410;
        Wed, 08 Jul 2020 04:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyugNuqxN5rzVdPBX5slxGKgyferLOH3BJsa69EiZC8VmURNSyq7nrqd1rqYUrnGgu/1A3QIg==
X-Received: by 2002:adf:f34e:: with SMTP id e14mr57807317wrp.299.1594208997184;
        Wed, 08 Jul 2020 04:49:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 22sm6269944wmb.11.2020.07.08.04.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:49:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: nSVM: properly call kvm_mmu_new_pgd() upon
 switching to guest
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200708093611.1453618-1-vkuznets@redhat.com>
 <20200708093611.1453618-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b7989497-562e-c9a1-3f62-dd5afb9fd3d5@redhat.com>
Date:   Wed, 8 Jul 2020 13:49:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708093611.1453618-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 11:36, Vitaly Kuznetsov wrote:
> Undesired triple fault gets injected to L1 guest on SVM when L2 is
> launched with certain CR3 values. #TF is raised by mmu_check_root()
> check in fast_pgd_switch() and the root cause is that when
> kvm_set_cr3() is called from nested_prepare_vmcb_save() with NPT
> enabled CR3 points to a nGPA so we can't check it with
> kvm_is_visible_gfn().
> 
> Calling kvm_mmu_new_pgd() with L2's CR3 idea when NPT is in use
> seems to be wrong, an acceptable place for it seems to be
> kvm_init_shadow_npt_mmu(). This also matches nVMX code.
> 
> Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 7 ++++++-
>  arch/x86/kvm/mmu/mmu.c          | 2 ++
>  arch/x86/kvm/svm/nested.c       | 2 +-
>  arch/x86/kvm/x86.c              | 8 +++++---
>  4 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..49b62f024f51 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1459,7 +1459,12 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  		    int reason, bool has_error_code, u32 error_code);
>  
>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> -int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
> +int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested);
> +static inline int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	return __kvm_set_cr3(vcpu, cr3, false);
> +}
> +
>  int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
>  int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 167d12ab957a..ebf0cb3f1ce0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4987,6 +4987,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
>  	union kvm_mmu_role new_role =
>  		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
>  
> +	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, true, true);
> +
>  	if (new_role.as_u64 != context->mmu_role.as_u64)
>  		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
>  }
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e424bce13e6c..b467917a9784 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -324,7 +324,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
>  	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
>  	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
>  	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
> -	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
> +	(void)__kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3, npt_enabled);
>  
>  	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
>  	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b92db412335..3761135eb052 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1004,7 +1004,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_cr4);
>  
> -int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested)
>  {
>  	bool skip_tlb_flush = false;
>  #ifdef CONFIG_X86_64
> @@ -1031,13 +1031,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>  		return 1;
>  
> -	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
> +	if (!cr3_is_nested)
> +		kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
> +
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(kvm_set_cr3);
> +EXPORT_SYMBOL_GPL(__kvm_set_cr3);
>  
>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
>  {
> 

Instead of the new argument (which is not really named right since it's
never true for !NPT) you could perhaps check vcpu->arch.mmu.  But also,
for NPT=1 the kvm_mmu_new_pgd is also unnecessary on vmexit, because the
old roots are still valid (or has been invalidated otherwise) while L2
was running.

I'm also not sure if skip_tlb_flush can use X86_CR3_PCID_NOFLUSH the way
kvm_set_cr3 does, so I wouldn't mind duplicating the code completely as
is already the case for nested_vmx_load_cr3.  It would introduce some
code duplication, but overall the code would be better.  For now, there
need not be an equivalent to nested_vmx_transition_mmu_sync, ASID
handling can be left for later.

Paolo

