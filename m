Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A5563262
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiGALQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiGALQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:16:32 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ACE33A18
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 04:16:30 -0700 (PDT)
Date:   Fri, 1 Jul 2022 13:16:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656674188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dHSdtkTknwbhIheMlfaURKEvB5QtSpUvC6+k5H3Z6Ig=;
        b=WvuTQiggpZyzFxZulIQ045w+tNvaeIV49GWlTUe5BGbLgZkgqr73SI0zJjH27+tPy61ySa
        4oZp5NMnlQn8BPgwqXtd2Oijl6EXYwLfj6phvU2U58+nYCo0pH8FGBgJPh2jS0mjzyt1E5
        UcIDEx+Vb2bx3FuNVtCiLygAX5nLmw0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean
 and invalidate before disabling
Message-ID: <20220701111627.w2jciiqnapt3z2sv@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
 <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
 <Yr2H3AiNGHeKReP2@monolith.localdoman>
 <218172cd-25fc-8888-96cc-a7b5a9c65f73@arm.com>
 <Yr3H4HM/bMaahFk2@monolith.localdoman>
 <20220701091214.savjgllxfcjk2l7g@kamzik>
 <Yr7LbKN4BK7G2LD2@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7LbKN4BK7G2LD2@monolith.localdoman>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 11:24:44AM +0100, Alexandru Elisei wrote:
...
> > being dropped and replaced by one of you with something that "makes
> > more sense" as long as the outcome (coherent execution on bare-metal)
> > still works.
> 
> Hmm... maybe an experiment will work. I propose the following:
> 
> 1. Revert this patch.
> 2. Apply this diff on top of the series:
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 30d04d0eb100..913f4088d96c 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -374,6 +374,11 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>                 }
>         }
>         __phys_end &= PHYS_MASK;
> +
> +       asm volatile("dc cvau, %0\n" :: "r" (&__phys_offset) : "memory");
> +       asm volatile("dc cvau, %0\n" :: "r" (&__phys_end) : "memory");
> +       dsb(sy);
> +
>         asm_mmu_disable();
> 
>         if (free_mem_pages == 0)
> 
> This is the solution, based on an architectural explanation of what we were
> observing, that I proposed on your github branch, a solution that you've
> tested with the result:
> 
> "I tested at least 10 times (lost count) with a build where "arm/arm64:
> mmu_disable: Clean and invalidate before disabling" was reverted from the
> target-efi branch and your hack was applied. It worked every time."
> 
> [1] https://github.com/rhdrjones/kvm-unit-tests/commit/fc58684bc47b7d07d75098fdfddb6083e9b12104#commitcomment-44222926
>

Hi Alex,

Thanks for digging that back up. I had lost track of it. The last comment
is you saying that you'll send a proper patch. Did you send one that got
lost? If not, would you like to send one now that Nikos can incorporate?

Thanks,
drew
