Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309954D21D2
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349528AbiCHTqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiCHTqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:46:17 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C44F461
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:45:20 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e2so25533pls.10
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/U9JTPqvWXFTbM25plsrED2wH9+oH9Gw1uAVvOqUumk=;
        b=mHgK8YYQ/2yu3bA5NCgo/IEEQ9C12zeYjgEHjIqIs7GS7uK8GvM4SLB+Jb/oGmbHnM
         sYB6dja1A1BighOV3gFwI7P59B0SEzFoHMB/RFE6zNUn3jCiAtNNvtRcnsZXoI7nn/1M
         mQIY+UqyytAw1p6Hh4OpTB3kPriJE6ZzkJ16QCTQ5FMTf6CgO0KIW+Ttetn0o4Tte84Y
         Pcltl41c/H8sblD0+iTt1rBiA4UiFVjf04XiC9LlEW5P+gOBt8ByAOyzWhmXAZHQ+Xgw
         GXE4NDvQof8dLW8HCZ09g9+lk04TRN4Av15sOyY7xFY/4Sp5seQxSe3ydkZroweuMnAA
         jRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/U9JTPqvWXFTbM25plsrED2wH9+oH9Gw1uAVvOqUumk=;
        b=DYKULFmj4ZEpUu93VszmHaPHxlWHP1G1oUN5bYdAkVGej4Azzd6GXhoOXdZbExpe7N
         hwPUr9mPHRMy2SZJj6oUHZ9flW4CgnmLd5ON3+v4FM1iul1Su3XtVv08jh+9UIrZJqaM
         ZcrxM5nH4oM4TL0dXZj3iiM8xtFZOjvSzvTQCvuXlfNgl0tvko0ZNKZO7YVEKkYxFTwx
         FoBkNcUKk1mF3fl1XcrYwFhGaVKHPnWKA6AF7Q3Yh7PjoHqMnmFeAk009d6s/b5Kp+wf
         EwIGf8Ectj1985gfivGmA6YqwQ59ZwRvadNzWAJOPdHkE1p2M8sbttpDOLrpcxCGy993
         QV7w==
X-Gm-Message-State: AOAM532cWAB0hvZ9o/XFkf4myfQFIjhjxNtot6y7/UEKtKISJujxWQky
        uj17uQYvzbNBXxFXDHiKc40xaA==
X-Google-Smtp-Source: ABdhPJxZYP2wL6kx+Q4AhwP4l3emhvff+Kv8jGS42/vpwZob0KjAXMqUoaxcBgaGtc3FCmZNzsj/JA==
X-Received: by 2002:a17:90b:4d0f:b0:1bf:6a2:5637 with SMTP id mw15-20020a17090b4d0f00b001bf06a25637mr6495372pjb.106.1646768719691;
        Tue, 08 Mar 2022 11:45:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090a055000b001bf5ad0e45esm3745286pjf.43.2022.03.08.11.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:45:19 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:45:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 20/25] KVM: x86/mmu: pull CPU mode computation to
 kvm_init_mmu
Message-ID: <YieyS8iVwIqSK0Wb@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-21-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-21-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> Do not lead init_kvm_*mmu into the temptation of poking
> into struct kvm_mmu_role_regs, by passing to it directly
> the CPU mode.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 47288643ab70..a7028c2ae5c7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4734,11 +4734,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	return role;
>  }
>  
> -static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
> -			     const struct kvm_mmu_role_regs *regs)
> +static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cpu_mode)

Please keep the newline.  I like running over the 80 char soft limit when it
improves readability, but IMO stacking params is easier to read than a long line
unless it's over by like 3 chars or less.

>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
>  	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
>  
>  	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&

...

> -static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> +static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode new_mode)

And add one here (or retroactively add it back when @regs was constified).
