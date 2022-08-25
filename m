Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398CC5A079A
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 05:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiHYD0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 23:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiHYD0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 23:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1716C4457B;
        Wed, 24 Aug 2022 20:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D929B8270E;
        Thu, 25 Aug 2022 03:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C467CC433D7;
        Thu, 25 Aug 2022 03:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661397970;
        bh=HeGNOJgM0wQLZmYpzMTvdEblf3M4r8hfez5I7qQKTDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uthsah3ggUqLBgSf7Xsaj2CfVpPYTpEHcQvSDZ9Nmn6I5tdmWTlcxKjE+u5jbkOy+
         Gk8Mw3na2LDv1j2hLxOqDIpOdN7ZAgJLskTF5/9ywYma0iEV/x/m9qEF2b5YIuehtP
         Ts8jjnQpZOdVosgU44gHYAbGtRKvSuGfjpivMu+k4nS56UllmHIS8geuuq7HKbLrzp
         3aUIq3n7/m521YAT5WzhiarPXsWZl6CSQJF1rl3Og+KyhZsgpkvW8xl/Be9o+JhPEb
         vOqCxbzJ7nqprSVl2Pdl3r61eB2ghcuGBsFlc9DeL1BKH+7fdvT8oqI7dMgEohE/H4
         HZqEMnoPdLftA==
Date:   Thu, 25 Aug 2022 06:26:03 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YwbrywL9S+XlPzaX@kernel.org>
References: <20220818023829.1250080-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818023829.1250080-1-kai.huang@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit: shouldn't be this be x86/kvm?

On Thu, Aug 18, 2022 at 02:38:29PM +1200, Kai Huang wrote:
> The new Asynchronous Exit (AEX) notification mechanism (AEX-notify)
> allows one enclave to receive a notification in the ERESUME after the
> enclave exit due to an AEX.  EDECCSSA is a new SGX user leaf function
> (ENCLU[EDECCSSA]) to facilitate the AEX notification handling.  The new
> EDECCSSA is enumerated via CPUID(EAX=0x12,ECX=0x0):EAX[11].
> 
> Besides Allowing reporting the new AEX-notify attribute to KVM guests,
> also allow reporting the new EDECCSSA user leaf function to KVM guests
> so the guest can fully utilize the AEX-notify mechanism.
> 
> Similar to existing X86_FEATURE_SGX1 and X86_FEATURE_SGX2, introduce a
> new scattered X86_FEATURE_SGX_EDECCSSA bit for the new EDECCSSA, and
> report it in KVM's supported CPUIDs so the userspace hypervisor (i.e.
> Qemu) can enable it for the guest.
> 
> Note there's no additional enabling work required to allow guest to use
> the new EDECCSSA.  KVM is not able to trap ENCLU anyway.
> 
> More background about how do AEX-notify and EDECCSSA work:
> 
> SGX maintains a Current State Save Area Frame (CSSA) for each enclave
> thread.  When AEX happens, the enclave thread context is saved to the
> CSSA and the CSSA is increased by 1.  For a normal ERESUME which doesn't
> deliver AEX notification, it restores the saved thread context from the
> previously saved SSA and decreases the CSSA.  If AEX-notify is enabled
> for one enclave, the ERESUME acts differently.  Instead of restoring the
> saved thread context and decreasing the CSSA, it acts like EENTER which
> doesn't decrease the CSSA but establishes a clean slate thread context
> using the CSSA for the enclave to handle the notification.  After some
> handling, the enclave must discard the "new-established" SSA and switch
> back to the previously saved SSA (upon AEX).  Otherwise, the enclave
> will run out of SSA space upon further AEXs and eventually fail to run.
> 
> To solve this problem, the new EDECCSSA essentially decreases the CSSA.
> It can be used by the enclave notification handler to switch back to the
> previous saved SSA when needed, i.e. after it handles the notification.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> Hi Dave,
> 
> This patch, along with your patch to expose AEX-notify attribute bit to
> guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> Feel free to merge this patch.
> 
> v1->v2:
> 
>  - Rebase to latest tip/x86/sgx
>  - Add scattered X86_FEATURE_SGX_EDECCSSA bit CPUID handling
>  - Add X86_FEATURE_SGX_EDECCSSA to cpuid dependency table.
>  - Slightly changed commit message.
> 
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  arch/x86/kvm/cpuid.c               | 2 +-
>  arch/x86/kvm/reverse_cpuid.h       | 3 +++
>  5 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 235dc85c91c3..ccdd35adae9e 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -304,6 +304,7 @@
>  #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
>  #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
>  #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
> +#define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index c881bcafba7d..d95221117129 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -75,6 +75,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>  	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
>  	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
>  	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
> +	{ X86_FEATURE_SGX_EDECCSSA,		X86_FEATURE_SGX1      },
>  	{ X86_FEATURE_XFD,			X86_FEATURE_XSAVES    },
>  	{ X86_FEATURE_XFD,			X86_FEATURE_XGETBV1   },
>  	{ X86_FEATURE_AMX_TILE,			X86_FEATURE_XFD       },
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index fd44b54c90d5..0bb339857985 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -40,6 +40,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_PER_THREAD_MBA,	CPUID_ECX,  0, 0x00000010, 3 },
>  	{ X86_FEATURE_SGX1,		CPUID_EAX,  0, 0x00000012, 0 },
>  	{ X86_FEATURE_SGX2,		CPUID_EAX,  1, 0x00000012, 0 },
> +	{ X86_FEATURE_SGX_EDECCSSA,	CPUID_EAX, 11, 0x00000012, 0 },
>  	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
>  	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
>  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..c21b4a5dc8fa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -644,7 +644,7 @@ void kvm_set_cpu_caps(void)
>  	);
>  
>  	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
> -		SF(SGX1) | SF(SGX2)
> +		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>  	);
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..4e5b8444f161 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -23,6 +23,7 @@ enum kvm_only_cpuid_leafs {
>  /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
>  #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
>  #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
> +#define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
>  
>  struct cpuid_reg {
>  	u32 function;
> @@ -78,6 +79,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
>  		return KVM_X86_FEATURE_SGX1;
>  	else if (x86_feature == X86_FEATURE_SGX2)
>  		return KVM_X86_FEATURE_SGX2;
> +	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
> +		return KVM_X86_FEATURE_SGX_EDECCSSA;
>  
>  	return x86_feature;
>  }
> 
> base-commit: ee56a283988d739c25d2d00ffb22707cb487ab47
> -- 
> 2.37.1
> 


BR, Jarkko
