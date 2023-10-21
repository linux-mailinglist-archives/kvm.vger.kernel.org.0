Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87EC7D19FD
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjJUAjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 20:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjJUAjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 20:39:41 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA970D7
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:39:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6b20577ef69so1236924b3a.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697848779; x=1698453579; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A/Jh0cabROh3tBKqefsJctpoBdTf5cZ3huGDHpuMVOI=;
        b=4ld123CNY/JRU0GxIH5bWSsiyVhgdQYuR81bzcQtAQ3S7k5XbBIXuccNLRET/R35NR
         ElqOSLAfe2WZ79gKq+b/byymiZxemWaYnJdvvwOO6KHHZltkTBIarzRGLVN/eDO80K6i
         6rZufvWqKGTBAxGv5YibU8+fdhfaMZp2N/FzBfRevoFU3Ikbtg87DjPPjrStaViUua5A
         Z6TJ4yriEd7kyTp0HLx+lRJhA2npMyD/KFis01ienEf9+0hq0mqS7nyAd9pdh0PrrVSw
         XN/dB1Lc3KYC8H5nQXrgEEo3vr2YulovZZ1rS/WA5a5o/avo/exShmwNybxjcqpDy5z3
         4RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697848779; x=1698453579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A/Jh0cabROh3tBKqefsJctpoBdTf5cZ3huGDHpuMVOI=;
        b=fHdBR41HBgwLj704uCHuHGSbtki9P1q/iazCwGgfAR58bKnSE6LnlyhMODLB6YeJQv
         C5TeHuPPqIBXqna8eReG80Pl8xnfceAyqZ/jR4fWKuBGeXjoq4pZqejLgdUKLulosTmb
         b6C5QQ6NnO/ddBrjIoeI/up6/hWSZVVTAfhWve2KjgxEkh6Uzg4PO8qlBGBCz05lQ4jS
         4v0g78JfUyV6kqFLHn8rDFp8FYynaGjnJO8HWndIgP6lpcI9mXWfu2Z/8ndL8KilyxfN
         HaG38MZ8/6Ml44g2fqJl/OJm6sNSbgAYvCll/b8L0iQs/n+Gdk9ybFZAwq3BoOtpSTVA
         mmAw==
X-Gm-Message-State: AOJu0Yxb+185Et71jz4xZFnbZMpllzm+r4oreHQJ6+bNmoR9IezxAi8h
        jxScbwlVE6oZUaDvrCydI3xMHVgnDTI=
X-Google-Smtp-Source: AGHT+IERTF/boS7m9A3yc+dkON4idgDVIRwkZ/vsTNZeATPA/9tJXZk8bTQe9YOPYHXiWU+IfFb3az19u/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3244:b0:6be:2a8a:abb7 with SMTP id
 bn4-20020a056a00324400b006be2a8aabb7mr93757pfb.1.1697848779063; Fri, 20 Oct
 2023 17:39:39 -0700 (PDT)
Date:   Fri, 20 Oct 2023 17:39:37 -0700
In-Reply-To: <20230914063325.85503-3-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com> <20230914063325.85503-3-weijiang.yang@intel.com>
Message-ID: <ZTMdyR8e63sCTKWc@google.com>
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
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

On Thu, Sep 14, 2023, Yang Weijiang wrote:
> Fix guest xsave area allocation size from fpu_user_cfg.default_size to
> fpu_kernel_cfg.default_size so that the xsave area size is consistent
> with fpstate->size set in __fpstate_reset().
> 
> With the fix, guest fpstate size is sufficient for KVM supported guest
> xfeatures.
> 
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

Shouldn't all the other calculations in this function also switch to fpu_kernel_cfg?
At the very least, this looks wrong when paired with the above:

	gfpu->uabi_size		= sizeof(struct kvm_xsave);
	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
		gfpu->uabi_size = fpu_user_cfg.default_size;
