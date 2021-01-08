Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500922EEE56
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 09:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbhAHIHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 03:07:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:45585 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbhAHIHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 03:07:33 -0500
IronPort-SDR: rLSIc5koBvogA0irM6sT8Gw4tiiaxMAZH/DZJQ19IFnoDWkJLKfF2XZ3iF4NGy7VK0WjVR8b82
 dYMzrMLfnZbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="174980811"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="174980811"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 00:06:52 -0800
IronPort-SDR: 2XikNNlFB7opI7unW8tCgWvujwU9rZ7H5e9fUKJhOe3Qcir0w2XW81jsyx5OBRWLHe4eqPPL/a
 /aII1d5eT12g==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="396249662"
Received: from sspraker-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.3.60])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 00:06:49 -0800
Date:   Fri, 8 Jan 2021 21:06:47 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210108210647.40ecb8233f0387578cb0d45a@intel.com>
In-Reply-To: <20210108071722.GA4042@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <20210106221527.GB24607@zn.tnic>
        <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
        <20210107064125.GB14697@zn.tnic>
        <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
        <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
        <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
        <20210108071722.GA4042@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jan 2021 08:17:22 +0100 Borislav Petkov wrote:
> On Fri, Jan 08, 2021 at 08:03:50PM +1300, Kai Huang wrote:
> > > > I am not sure changing reverse lookup to handle dynamic would be acceptable. To
> > > > me it is ugly, and I don't have a first glance on how to do it. KVM can query
> > > > host CPUID when dealing with SGX w/o X86_FEATURE_SGX1/2, but it is not as
> > > > straightforward as having X86_FEATURE_SGX1/2.
> > > 
> > > So, Boris was pretty direct here.  Could you please go spend a bit of
> > > time to see what it would take to make these dynamic?  You can check
> > > what our (Intel) plans are for this leaf, but if it's going to remain
> > > sparsely-used, we need to look into making the leaves a bit more dynamic.
> > 
> > I don't think reverse lookup can be made dyanmic, but like I said if we don't
> > have X86_FEATURE_SGX1/2, KVM needs to query raw CPUID when dealing with SGX.
> 
> How about before you go and say that "it is ugly" and "don't think can
> be made" you actually go and *really* try it first? Because actually
> trying is sometimes faster than trying to find arguments against it. :)

THanks. Lesson learned :)

> 
> Because I just did it and unless I'm missing something obvious - I
> haven't actually tested it - this is not ugly at all and in the long run
> it will become one big switch-case, which is perfectly fine.

No offence, but using synthetic bits is a little bit hack to me,given they are
actually hardware feature bits. And using synthetic leaf in reverse lookup is
against current KVM code. 

I'll try my own  way in next version, but thank you for the insight! :)

> 
> ---
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 59bf91c57aa8..0bf5cb5441f8 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -30,6 +30,7 @@ enum cpuid_leafs
>  	CPUID_7_ECX,
>  	CPUID_8000_0007_EBX,
>  	CPUID_7_EDX,
> +	CPUID_12_EAX,	/* used only by KVM for now */
>  };
>  
>  #ifdef CONFIG_X86_FEATURE_NAMES
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..1bc1ade64489 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -292,6 +292,8 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_SGX1		(11*32+ 8) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(11*32+ 9) /* SGX2 leaf functions */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index dc921d76e42e..33c53a7411a1 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -63,8 +63,27 @@ static const struct cpuid_reg reverse_cpuid[] = {
>  	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
>  	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>  	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
> +	[CPUID_12_EAX]        = {      0x12, 0, CPUID_EAX},
>  };
>  
> +/*
> + * Map a synthetic X86_FEATURE bit definition to the corresponding bit in the
> + * hardware CPUID leaf.
> + */
> +static int map_synthetic_leaf(int x86_feature)
> +{
> +	switch (x86_feature) {
> +	case X86_FEATURE_SGX1:	return BIT(0);
> +	case X86_FEATURE_SGX2:	return BIT(1);
> +	default:
> +		break;
> +	}
> +
> +	WARN_ON_ONCE(1);
> +
> +	return 0;
> +}
> +
>  /*
>   * Reverse CPUID and its derivatives can only be used for hardware-defined
>   * feature words, i.e. words whose bits directly correspond to a CPUID leaf.
> @@ -78,7 +97,6 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
>  	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
>  	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
>  	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
> -	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
>  	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
>  	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
>  }
> @@ -91,8 +109,14 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
>   */
>  static __always_inline u32 __feature_bit(int x86_feature)
>  {
> -	reverse_cpuid_check(x86_feature / 32);
> -	return 1 << (x86_feature & 31);
> +	int leaf = x86_feature / 32;
> +
> +	reverse_cpuid_check(leaf);
> +
> +	if (leaf == CPUID_LNX_4)
> +		return map_synthetic_leaf(x86_feature);
> +
> +	return BIT(x86_feature & 31);
>  }
>  
>  #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
