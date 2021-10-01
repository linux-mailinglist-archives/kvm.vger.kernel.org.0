Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3EA41EDBB
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354450AbhJAMrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 08:47:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57134 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354445AbhJAMrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 08:47:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633092323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTgL7kIUE93Xymjv16zGETKagJ0TIPP/q5KcKMxrjSM=;
        b=Jtj0w5Qb3JtEYFJDHS0GuwY7One/jOUkU5xQtvONnUfF5MFuDB2gHAOsOSo38A8SokyWF8
        M7r+us69GAVO8YutjxVbTYGEZ9U3mnso3UJad3UXfLTcAUgvWkz/zBaSKb+se9twxaN28J
        zmg6C27yYGNCIRNktWfDdzboOOSDvxtubt1b8l8C8ER91/B0lrisPtAy3Maa9Bo5QnLQbd
        44EblVjtmFAvIDNx+cbe7VJOgyGwcD0iWPS8lW3GU50Qughn0Jybw0UjQ7C0BJI8xN7pNG
        amNqtYS6/Bx8i5fKEJct8m6hMLAUiRb4s8kZlIcDe4T8RSrQ4I5PBVq7YJMvNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633092323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTgL7kIUE93Xymjv16zGETKagJ0TIPP/q5KcKMxrjSM=;
        b=9TFDbZX2xoGz1paBs1QM8K/OxxMUu9YGh2Q2CoFIimPMDDRgdKXJyTlJeOxALPtzw/ByzB
        iuTM/wYiAWoDVJCw==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v10 02/28] x86/fpu/xstate: Modify the initialization
 helper to handle both static and dynamic buffers
In-Reply-To: <20210825155413.19673-3-chang.seok.bae@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-3-chang.seok.bae@intel.com>
Date:   Fri, 01 Oct 2021 14:45:22 +0200
Message-ID: <87k0iw6hi5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Chang,

On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:
> Have the function initializing the XSTATE buffer take a struct fpu *
> pointer in preparation for dynamic state buffer support.
>
> init_fpstate is a special case, which is indicated by a null pointer
> parameter to fpstate_init().
>
> Also, fpstate_init_xstate() now accepts the state component bitmap to
> customize the compacted format.

That's not a changelog. Changelogs have to explain the WHY not the WHAT.

I can see the WHY when I look at the later changes, but that's not how
it works.

Also the subject of this patch is just wrong. It does not make the
functions handle dynamic buffers, it prepares them to add support for
that later.

> +static inline void fpstate_init_xstate(struct xregs_state *xsave, u64 mask)
> +{
> +	/*
> +	 * XRSTORS requires these bits set in xcomp_bv, or it will
> +	 * trigger #GP:
> +	 */
> +	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | mask;
> +}

This wants to be a separate cleanup patch which replaces the open coded
variant here:

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index fc1d529547e6..0fed7fbcf2e8 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -395,8 +395,7 @@ static void __init setup_init_fpu_buf(void)
>  	print_xstate_features();
>  
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		init_fpstate.xsave.header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
> -						     xfeatures_mask_all;
> +		fpstate_init_xstate(&init_fpstate.xsave, xfeatures_mask_all);

Thanks,

        tglx
