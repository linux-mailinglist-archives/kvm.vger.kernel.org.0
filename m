Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E924232A6AD
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448729AbhCBPhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239529AbhCBAAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:00:48 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913B6C06178B
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 16:00:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w18so12619786pfu.9
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 16:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yq254SkrVPYkKMx5FhkZ8HM8pUWyZebr3dtEMZbEpmQ=;
        b=KHn/xhSySXn3fRA4EHKz+k28VC/PZO+vrsZfRduXz5+AjuNRnPtkaqYP7JG8TubLUK
         hRFt1gGOC2heiXHzduKFVFXs6WiNNWTo9WUk1bbPKS7FearKeUx07v9cM4stWQf1NFwh
         hjPmarpKBnPizLmty2WBpci0eIh5zGs6G1335QdKOSjmkurTJ4o6lnNh+Dilg86EdyeN
         BXEgibd52Yf/ZU4p/lZ0BEgAgGpRYq99q9OJht/D6eU8oA3GEthcjtvcUzjLYomAKHPT
         tKUblaWfzhBWf8x51b0mCNbqKFT/cy2V4vN51eytfvDueZwth5rPGG0/tvcITiISQejx
         s9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yq254SkrVPYkKMx5FhkZ8HM8pUWyZebr3dtEMZbEpmQ=;
        b=V9GHKfbS+AZ5aDCo0B32mTDbkHChng+R/+r9/tuV/GywyoGDc0LlhWRENYbcv0Qbcy
         FqRAI0AWRroC6Xoc1WTo+l6VPcesPxcJzjJBIVB+Y5lWTZGKeErBEUnhwPqBa+Euhyhv
         MwQEboGI7Oc0CwGXrdZFBVKeMvw0gHuzu3qhbk/owwEZwFy1rUXi6/Bg3M9AdY6jlCPy
         G2sHo+LM9PRFJrjYrO6HdhTvCr9VkAVMVW7n7Zay9ipQIuxOcYqi7aAFZ28ihx3KAGX5
         hDUPsNuN2pbfAH0n7kZGHXoS5Yi6m4Lwx5isBW1VbRx/+JWHVjzTFi7X2oRSUMHMvtJB
         z+jA==
X-Gm-Message-State: AOAM533pMCZAIJqlIcoZdFx4djBhmbDfsBB2S2F8piVJJf2onR3MjnnY
        LtWHh2pY1AIWyvBAts8o0w1lxg==
X-Google-Smtp-Source: ABdhPJwAT+GcPEZ1FmprKNY55vfpZmbu/uM/M2oFJkKCKneR+u8QUI9ttOwA/hkV3hk1G3YvTkL0eA==
X-Received: by 2002:a62:16c9:0:b029:1ed:df04:8fcf with SMTP id 192-20020a6216c90000b02901eddf048fcfmr17574872pfw.63.1614643206783;
        Mon, 01 Mar 2021 16:00:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id r16sm18650982pfh.168.2021.03.01.16.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 16:00:06 -0800 (PST)
Date:   Mon, 1 Mar 2021 15:59:59 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Revise guest_fpu xcomp_bv field
Message-ID: <YD1//+O57mr2D2Ne@google.com>
References: <20210225104955.3553-1-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225104955.3553-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021, Jing Liu wrote:
> XCOMP_BV[63] field indicates that the save area is in the compacted
> format and XCOMP_BV[62:0] indicates the states that have space allocated
> in the save area, including both XCR0 and XSS bits enabled by the host
> kernel. Use xfeatures_mask_all for calculating xcomp_bv and reuse
> XCOMP_BV_COMPACTED_FORMAT defined by kernel.
> 
> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b404e4d7dd8..f115493f577d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4435,8 +4435,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
> -
>  static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>  {
>  	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
> @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
>  	/* Set XSTATE_BV and possibly XCOMP_BV.  */
>  	xsave->header.xfeatures = xstate_bv;
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
> +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
> +					 xfeatures_mask_all;

Doesn't fill_xsave also need to be updated?  Not with xfeatures_mask_all, but
to account for arch.ia32_xss?  I believe it's a nop with the current code, since
supported_xss is zero, but it should be fixed, no?

>  
>  	/*
>  	 * Copy each region from the non-compacted offset to the
> @@ -9912,9 +9911,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	fpstate_init(&vcpu->arch.guest_fpu->state);
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
> -			host_xcr0 | XSTATE_COMPACTION_ENABLED;

Ugh, this _really_ needs a comment in the changelog.  It took me a while to
realize fpstate_init() does exactly what the new fill_xave() is doing.

And isn't the code in load_xsave() redundant and can be removed?  Any code that
uses get_xsave_addr() would be have a dependency on load_xsave() if it's not
redundant, and I can't see how that would work.

>  
>  	/*
>  	 * Ensure guest xcr0 is valid for loading
> -- 
> 2.18.4
> 
