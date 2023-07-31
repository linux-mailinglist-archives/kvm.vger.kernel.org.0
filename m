Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BA3769F91
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjGaRhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjGaRhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:37:46 -0400
Received: from out-87.mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAA795
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:37:44 -0700 (PDT)
Date:   Mon, 31 Jul 2023 17:37:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690825062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8YdaDmAxh2tQ04c65R6HIInMSDgiFElU1rQyABOujGA=;
        b=EX5P5RrbAyGLiUihHg1zPC7oGWSKDM/ElBWxcBqxOnEfqsICZbH2/AKd3VVoNKwHnOFruh
        7NElv6WY+11J1OOCKqt98Yd2d6vWX/LMv7f7kzf3/02EtNU3neXRdqSxXfp5KfexlS5rP8
        7iRednQbNTf1lNnkOTSMwB1k8yGXoT8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
Message-ID: <ZMfxYR41K71UV/84@linux.dev>
References: <20230729004144.1054885-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729004144.1054885-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 05:41:44PM -0700, Sean Christopherson wrote:
> Wrap kvm_{gfn,hva}_range.pte in a union so that future notifier events can
> pass event specific information up and down the stack without needing to
> constantly expand and churn the APIs.  Lockless aging of SPTEs will pass
> around a bitmap, and support for memory attributes will pass around the
> new attributes for the range.
> 
> Add a "KVM_NO_ARG" placeholder to simplify handling events without an
> argument (creating a dummy union variable is midly annoying).
> 
> Opportunstically drop explicit zero-initialization of the "pte" field, as
> omitting the field (now a union) has the same effect.
> 
> Cc: Yu Zhao <yuzhao@google.com>
> Link: https://lore.kernel.org/all/CAOUHufagkd2Jk3_HrVoFFptRXM=hX2CV8f+M-dka-hJU4bP8kw@mail.gmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good, and I don't think it'll conflict with anything on the arm64
side.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
> 
> If this looks good, my thought is to squeeze it into 6.6 so that the MGLRU
> and guest_memfd() series can build on it.  Or those series could just
> include it?

Eh, I'm not a huge fan of having two series independently reposting a
common base. It can be a bit annoying when the two authors have slightly
different interpretations on how to improve it...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dfbaafbe3a00..f84ef9399aee 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -526,7 +526,7 @@ typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>  struct kvm_hva_range {
>  	unsigned long start;
>  	unsigned long end;
> -	pte_t pte;
> +	union kvm_mmu_notifier_arg arg;
>  	hva_handler_t handler;
>  	on_lock_fn_t on_lock;
>  	on_unlock_fn_t on_unlock;
> @@ -547,6 +547,8 @@ static void kvm_null_fn(void)
>  }
>  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
>  
> +static const union kvm_mmu_notifier_arg KVM_NO_ARG;
> +

I'm guessing you were trying to keep this short, but it might be nice to
use MMU_NOTIFIER_ (or similar) as the prefix to make the scope
immediately obvious.

-- 
Thanks,
Oliver
