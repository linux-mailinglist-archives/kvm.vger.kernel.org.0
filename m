Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABEB1E1B19
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgEZGQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbgEZGQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:16:20 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA1F5207D8;
        Tue, 26 May 2020 06:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473780;
        bh=gpUcruULznsEXcLKKRC5eQF+oxrznq/QzS5NKgeHNYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GcFzir3vTIFPY79bbVuH9b8AbvS1uA8m3OI44tZqw/MBOGlar8gnomGhlPR736+9t
         iqlLBronzDmvoOravaNxrcRm2iedky+0gvbZLuE6zUqEJwnmtK+AP5EMiXlqNIS8Lz
         YTYsY16A+kPjoeRT4Xcxhf1gCFd0iQt2L08pfsY8=
Date:   Tue, 26 May 2020 09:16:09 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 10/16] KVM: x86: Enabled protected memory extension
Message-ID: <20200526061609.GE13247@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-11-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522125214.31348-11-kirill.shutemov@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 03:52:08PM +0300, Kirill A. Shutemov wrote:
> Wire up hypercalls for the feature and define VM_KVM_PROTECTED.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/Kconfig     | 1 +
>  arch/x86/kvm/cpuid.c | 3 +++
>  arch/x86/kvm/x86.c   | 9 +++++++++
>  include/linux/mm.h   | 4 ++++
>  4 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58dd44a1b92f..420e3947f0c6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -801,6 +801,7 @@ config KVM_GUEST
>  	select ARCH_CPUIDLE_HALTPOLL
>  	select X86_MEM_ENCRYPT_COMMON
>  	select SWIOTLB
> +	select ARCH_USES_HIGH_VMA_FLAGS
>  	default y
>  	---help---
>  	  This option enables various optimizations for running under the KVM
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..94cc5e45467e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -714,6 +714,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
>  			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
>  
> +		if (VM_KVM_PROTECTED)
> +			entry->eax |=(1 << KVM_FEATURE_MEM_PROTECTED);
> +
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c17e6eb9ad43..acba0ac07f61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7598,6 +7598,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_ENABLE_MEM_PROTECTED:
> +		ret = kvm_protect_all_memory(vcpu->kvm);
> +		break;
> +	case KVM_HC_MEM_SHARE:
> +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, false);
> +		break;
> +	case KVM_HC_MEM_UNSHARE:
> +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, true);
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4f7195365cc0..6eb771c14968 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -329,7 +329,11 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
>  #endif
>  
> +#if defined(CONFIG_X86_64) && defined(CONFIG_KVM)

This would be better spelled as ARCH_WANTS_PROTECTED_MEMORY, IMHO.

> +#define VM_KVM_PROTECTED VM_HIGH_ARCH_4

Maybe this should be VM_HIGH_ARCH_5 so that powerpc could enable this
feature eventually?

> +#else
>  #define VM_KVM_PROTECTED 0
> +#endif
>  
>  #ifndef VM_GROWSUP
>  # define VM_GROWSUP	VM_NONE
> -- 
> 2.26.2
> 
> 

-- 
Sincerely yours,
Mike.
