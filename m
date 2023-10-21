Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0521E7D19EB
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 02:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjJUA3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 20:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjJUA3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 20:29:54 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E199D6F
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:29:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6a75fa285afso1972173b3a.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697848191; x=1698452991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=URhfPegiqULvnAXOPJSToRbMiiNQ69wTFBE4iKPjurk=;
        b=E/Xg8SZ40DoxEVuNzCVFu+Synj7hm6TJGDbm19AI/XhMlWlTVgtK74pW9A4n31g1JE
         QvTnMXvfGwg2O2t0VvjHJHxe0Ot3B2AjjXJLGrn1V5hVSjzwCiPloQT8l2fy16qaARKM
         vohrCldIv1aRBJG8V5W0BP/BsN7cDUKdVVU9xvlwfKrF8GMpdF7o08eVPBI1fhe0GMey
         +DkMjgLSG1bMPr4QwJfVH5au7T3tPOXi/XFHNDTZV27agEW3Jh8fc/IU8ukxiKGx12TZ
         yN/MMGOSTkNuAgXnpzD/KpujnbUACp+9MPY2ki6t0m9DimGR1Vcp35s2FsooSPzE+9yz
         /duA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697848191; x=1698452991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URhfPegiqULvnAXOPJSToRbMiiNQ69wTFBE4iKPjurk=;
        b=I0vLOB6s+VpKKFCzuFYaqkF/WHcCJBZbchVcYawecTNh+CXOgZJhTnKhqjjlo+sBM7
         Xi3TiEWPNo1yKq8k2QHQBdQNSm2CFdpWIeCrT6I46rvNdmrZg2fVrl0g+cc/Q//sav6c
         azj/pNSWp9o17zwWCxptfxxIRvEURDdu+ca3yjdTFhwmR/sV2SkSC6fyaKGMyZG0g83c
         rVPL/S55/7UymAJa1YtgpOQKik4mg38spurqLejirYOm6l1HLizlx0Ny4szJoNQ2IjX7
         gqTkpBPC5w4VNkvYVtUpA4bIYw9dY7i/bcT3oCdUAvUNpwkfp7HZthQF0G3t0C5fce3r
         zB5Q==
X-Gm-Message-State: AOJu0Yzrz+A1Vry2OaB2942P8NsPCf1mqEBtK/YZXqHvGUO+dTTBZS1M
        0srxWSzVgNfHk+2eXeggcceI9S1chjU=
X-Google-Smtp-Source: AGHT+IHTJGu4oUC6WhRS9Fv4v7keMn8G6pjxhOGW6tX1kz4keMdgDTwAycQMtBqyfBjL7Xy0sm01ol/mEas=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:26ea:b0:68a:5937:ea87 with SMTP id
 p42-20020a056a0026ea00b0068a5937ea87mr111591pfw.3.1697848191640; Fri, 20 Oct
 2023 17:29:51 -0700 (PDT)
Date:   Fri, 20 Oct 2023 17:29:49 -0700
In-Reply-To: <20230914032334.75212-3-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230914032334.75212-1-weijiang.yang@intel.com> <20230914032334.75212-3-weijiang.yang@intel.com>
Message-ID: <ZTMbfUhyOkmA9czp@google.com>
Subject: Re: [RFC PATCH 2/8] x86/fpu/xstate: Fix guest fpstate allocation size calculation
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, Yang Weijiang wrote:
> Fix guest xsave area allocation size from fpu_user_cfg.default_size to
> fpu_kernel_cfg.default_size so that the xsave area size is consistent
> with fpstate->size set in __fpstate_reset().
> 
> With the fix, guest fpstate size is sufficient for KVM supported guest
> xfeatures.
> 
> Fixes: 69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup");
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kernel/fpu/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index a86d37052a64..a42d8ad26ce6 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>  	struct fpstate *fpstate;
>  	unsigned int size;
>  
> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	size = fpu_kernel_cfg.default_size +
> +	       ALIGN(offsetof(struct fpstate, regs), 64);

This looks sketchy and incomplete.  I haven't looked at the gory details of
fpu_user_cfg vs. fpu_kernel_cfg, but the rest of this function uses fpu_user_cfg,
including a check on fpu_user_cfg.default_size.  That makes me think that changing
just the allocation size isn't quite right.

	/* Leave xfd to 0 (the reset value defined by spec) */
	__fpstate_reset(fpstate, 0);
	fpstate_init_user(fpstate);
	fpstate->is_valloc	= true;
	fpstate->is_guest	= true;

	gfpu->fpstate		= fpstate;
	gfpu->xfeatures		= fpu_user_cfg.default_features;
	gfpu->perm		= fpu_user_cfg.default_features;

	/*
	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
	 * to userspace, even when XSAVE is unsupported, so that restoring FPU
	 * state on a different CPU that does support XSAVE can cleanly load
	 * the incoming state using its natural XSAVE.  In other words, KVM's
	 * uABI size may be larger than this host's default size.  Conversely,
	 * the default size should never be larger than KVM's base uABI size;
	 * all features that can expand the uABI size must be opt-in.
	 */
	gfpu->uabi_size		= sizeof(struct kvm_xsave);
	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
		gfpu->uabi_size = fpu_user_cfg.default_size;
