Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1FD354377
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbhDEPdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhDEPdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:33:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D58AC061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:33:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a6so2509668pls.1
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yeIFAGZCFNTdJmgbYpc4gUYmXaafGM6W65Z0Dwz617w=;
        b=SnVghZsG+fhLZB71S0ubEqQb4pTFKy/pbi9N0bFrbFdwBK4OIMa3ujIWXXYPnwY+T5
         s3+rXHf/1mK2hyuRDYqWmpCtIQGWhFnUUtkMi+FMXUwePg6ZrkrPhYiInUYs21oKG7l5
         vj3lg12gqlX2nH5tz3GZ9uGwlg9FaRJQCEJuoHIDyHDNNGS6u1QGhSqEVuWqewnvBph3
         emL1WpHJVUhTHrMtAPda9b0jVGjW+j/2WarMJE46qwb719iCKewZQ+hin9d8PEoNtVIG
         kh7d9uPQsdIE8U3vmo9OWRLnnzAW+9vlE/wzmI2l7PdAcHAnnAFtEg/IUQLXSfNz3v/c
         0tUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yeIFAGZCFNTdJmgbYpc4gUYmXaafGM6W65Z0Dwz617w=;
        b=kN4Os8IGWYlRKiYricc5NxQXTCzj9ssV0XvSpnjl74g74ZMzu6sdCo/N6T9joJz67x
         c5EsST8Q9bQqbCA/1xKhF6oDvVlEovSDzRQz6l2GeUdg4ZQUu7CvC9c1hcWignbMLyJW
         iLFTbi3CvRYeQ/3y+kWvYGi9WveFHv8CZzLumWjfTy7gtbGlhsVunFqdq776rBrkTMhz
         tC1gi6AfPKHJPWKggMdMGA1Mv6r3DPRXEC1avdNxD9lYpOFrdCw3NDXXZ3QwXruSDQgq
         7xjGbRk0BESUxOE9gFO11g4bFWS4Y/G+LFJNDgj+DJOVpBieiEdjH5TRVnfZhWVObVTQ
         snLw==
X-Gm-Message-State: AOAM531ZH61baLHispnp5pm3tk6wmapAiJwh4X+5Dwk+f3NxuGvFoBaX
        XNgr0T+lYrboS0FSd2rQQvzm6w==
X-Google-Smtp-Source: ABdhPJzitTPRSGCStceP0JPmXSRHw7Fu8K1A2sJfGiiDAM4/0RthUO7888WL2OQilPQqiReKvdDlKQ==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr27165009pjb.154.1617636782342;
        Mon, 05 Apr 2021 08:33:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o3sm16467449pjm.30.2021.04.05.08.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 08:33:01 -0700 (PDT)
Date:   Mon, 5 Apr 2021 15:32:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 02/12] x86/cpufeature: Add CPUID.19H:{EBX,ECX} cpuid
 leaves
Message-ID: <YGstqj6YH96jrlAl@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-3-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611565580-47718-3-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> Though KeyLocker is generally enumerated by
> CPUID.(07H,0):ECX.KL[bit23], CPUID.19H:{EBX,ECX} enumerate
> more details of KeyLocker supporting status.
> 
> CPUID.19H:EBX
> bit0 enumerates if OS (CR4.KeyLocker) and BIOS have enabled KeyLocker.
> bit2 enumerates if wide Key Locker instructions are supported.
> bit4 enumerates if IWKey backup is supported.
> CPUID.19H:ECX
> bit0 enumerates if the NoBackup parameter to LOADIWKEY is supported.
> bit1 enumerates if IWKey randomization is supported.
> 
> Define these 2 cpuid_leafs so that get_cpu_cap() will have these
> capabilities included, which will be the knowledge source of KVM on
> host KeyLocker capabilities.
> 
> Most of above features don't have the necessity to appear in /proc/cpuinfo,
> except "iwkey_rand", which we think might be interesting for user to easily
> know if his system is using randomized IWKey.
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h        |  6 ++++--
>  arch/x86/include/asm/cpufeatures.h       | 11 ++++++++++-
>  arch/x86/include/asm/disabled-features.h |  2 +-
>  arch/x86/include/asm/required-features.h |  2 +-
>  arch/x86/kernel/cpu/common.c             |  7 +++++++
>  5 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 59bf91c..f9fea5f 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -30,6 +30,8 @@ enum cpuid_leafs
>  	CPUID_7_ECX,
>  	CPUID_8000_0007_EBX,
>  	CPUID_7_EDX,
> +	CPUID_19_EBX,
> +	CPUID_19_ECX,
>  };
>  
>  #ifdef CONFIG_X86_FEATURE_NAMES
> @@ -89,7 +91,7 @@ enum cpuid_leafs
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
>  	   REQUIRED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
>  
>  #define DISABLED_MASK_BIT_SET(feature_bit)				\
>  	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
> @@ -112,7 +114,7 @@ enum cpuid_leafs
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
>  	   DISABLED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
>  
>  #define cpu_has(c, bit)							\
>  	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8f2f050..d4a883a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -13,7 +13,7 @@
>  /*
>   * Defines x86 CPU feature bits
>   */
> -#define NCAPINTS			19	   /* N 32-bit words worth of info */
> +#define NCAPINTS			21	   /* N 32-bit words worth of info */
>  #define NBUGINTS			1	   /* N 32-bit bug flags */
>  
>  /*
> @@ -382,6 +382,15 @@
>  #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABILITIES MSR */
>  #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
>  
> +/* Intel-defined KeyLocker feature CPUID level 0x00000019 (EBX), word 20*/
> +#define X86_FEATURE_KL_INS_ENABLED  (19*32 + 0) /* "" Key Locker instructions */
> +#define X86_FEATURE_KL_WIDE  (19*32 + 2) /* "" Wide Key Locker instructions */
> +#define X86_FEATURE_IWKEY_BACKUP  (19*32 + 4) /* "" IWKey backup */
> +
> +/* Intel-defined KeyLocker feature CPUID level 0x00000019 (ECX), word 21*/
> +#define X86_FEATURE_IWKEY_NOBACKUP  (20*32 + 0) /* "" NoBackup parameter to LOADIWKEY */
> +#define X86_FEATURE_IWKEY_RAND  (20*32 + 1) /* IWKey Randomization */

These should probably go into a Linux-defined leaf, I'm guessing neither leaf
will be anywhere near full, at least in Linux.  KVM's reverse-CPUID code will
likely/hopefully be gaining support for scattered leafs in the near future[*],
that side of things should be a non-issue if/when this lands.

https://lkml.kernel.org/r/02455fc7521e9f1dc621b57c02c52cd04ce07797.1616136308.git.kai.huang@intel.com
