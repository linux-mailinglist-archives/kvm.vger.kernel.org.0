Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF93670F4
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhDURKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238034AbhDURKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 13:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5606A61360;
        Wed, 21 Apr 2021 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619025020;
        bh=vQW/O+ZRlOWfybjW1VBTul75liFN4bSm4NGQMUpQUt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLe+rypc/AwdIGixQpLnD3YnfRANOWDeSjFkhTfu2bu9XAezbNXlXjq8ttbMvesTs
         dS7Fs2XcrFBDivtz+XddlwOTQeb7OOnU583/I6hT2E6JMgShitGXLx+uy6QrsddQYz
         RoUmSUUwG8o+h82IA4MkGK7dAuU09qPIVzbE/u1dIbSMFnuw7TZAnIWHhpRX9sCVkc
         IYzaSDVRZyRFJ0FtRkmoZ5/AbJL3Ox4K7vDts12Fv80qKOPCBInSLxqFlvGJcrY9W4
         +mNbg+JCcUIcz6vF3bM3iC51b4FbhFE94l01WZBgVQxDnCS0QqRvKWz4jk7HOpfYUk
         II82pwHBSlvyQ==
Date:   Wed, 21 Apr 2021 10:10:15 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: x86: Fix implicit enum conversion goof in scattered
 reverse CPUID code
Message-ID: <YIBcd+5NKJFnkTC1@archlinux-ax161>
References: <20210421010850.3009718-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421010850.3009718-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 06:08:50PM -0700, Sean Christopherson wrote:
> Take "enum kvm_only_cpuid_leafs" in scattered specific CPUID helpers
> (which is obvious in hindsight), and use "unsigned int" for leafs that
> can be the kernel's standard "enum cpuid_leaf" or the aforementioned
> KVM-only variant.  Loss of the enum params is a bit disapponting, but
> gcc obviously isn't providing any extra sanity checks, and the various

Unfortunately, gcc's -Wenum-conversion is behind -Wextra rather than
-Wall like clang. If you explicitly enable it with
KCFLAGS=-Wenum-conversion to your make invocation, it will warn in the
exact same way as clang:

arch/x86/kvm/cpuid.c: In function 'kvm_set_cpu_caps':
arch/x86/kvm/cpuid.c:499:29: warning: implicit conversion from 'enum kvm_only_cpuid_leafs' to 'enum cpuid_leafs' [-Wenum-conversion]
  499 |  kvm_cpu_cap_init_scattered(CPUID_12_EAX,
      |                             ^~~~~~~~~~~~
arch/x86/kvm/cpuid.c: In function '__do_cpuid_func':
arch/x86/kvm/cpuid.c:837:31: warning: implicit conversion from 'enum kvm_only_cpuid_leafs' to 'enum cpuid_leafs' [-Wenum-conversion]
  837 |   cpuid_entry_override(entry, CPUID_12_EAX);
      |                               ^~~~~~~~~~~~

clang's warning for comparison/posterity:

arch/x86/kvm/cpuid.c:499:29: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs' [-Wenum-conversion]
        kvm_cpu_cap_init_scattered(CPUID_12_EAX,
        ~~~~~~~~~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~
arch/x86/kvm/cpuid.c:837:31: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs' [-Wenum-conversion]
                cpuid_entry_override(entry, CPUID_12_EAX);
                ~~~~~~~~~~~~~~~~~~~~        ^~~~~~~~~~~~
2 warnings generated.

> BUILD_BUG_ON() assertions ensure the input is in range.
> 
> This fixes implicit enum conversions that are detected by clang-11.
> 
> Fixes: 4e66c0cb79b7 ("KVM: x86: Add support for reverse CPUID lookup of scattered features")
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This makes GCC and clang happy in my brief testing.

I assume this will get squashed but in case not, here are some tags:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> 
> Hopefully it's not too late to squash this...
> 
>  arch/x86/kvm/cpuid.c | 5 +++--
>  arch/x86/kvm/cpuid.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 96e41e1a1bde..e9d644147bf5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -365,7 +365,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
> -static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
> +static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>  {
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>  	struct kvm_cpuid_entry2 entry;
> @@ -378,7 +378,8 @@ static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
>  	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
>  }
>  
> -static __always_inline void kvm_cpu_cap_init_scattered(enum cpuid_leafs leaf, u32 mask)
> +static __always_inline
> +void kvm_cpu_cap_init_scattered(enum kvm_only_cpuid_leafs leaf, u32 mask)
>  {
>  	/* Use kvm_cpu_cap_mask for non-scattered leafs. */
>  	BUILD_BUG_ON(leaf < NCAPINTS);
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index eeb4a3020e1b..7bb4504a2944 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -236,7 +236,7 @@ static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
>  }
>  
>  static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
> -						 enum cpuid_leafs leaf)
> +						 unsigned int leaf)
>  {
>  	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
>  
> -- 
> 2.31.1.368.gbe11c130af-goog
> 
