Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828BF6B7CD7
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCMPy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCMPyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:54:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0FA1BA
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:53:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u4-20020a170902bf4400b0019e30a57694so7490508pls.20
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678722819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou4eTHfchaovdyTcvsOJz1A/GQo+JKYaMd0j8j6QHK8=;
        b=RqXh4bxfWB+D0kxLETg5U2ZiLZMoAh0XWbDL0HXjMPHKUBEeKXZCJohVf4RzW3rVv5
         8E+1HTtAEIVvoyiAcfqSBcklqe0g5oNyXazRlXz2BJttEoIFQdpT7ow8bz2aLzGxReTR
         OUBj8yx1eFJRKJCgHg3oyU0XE48Xpd7PqTYQfgrZYpnSIO3/YNrkD5HR7enqiBGPEHHs
         t+Rtb43jLjOG3gF0NBUb7u23o+hBeaIR5BI6ViYiMKbanT2WPKiTbbabKSpys4/obFBm
         izJOOdKlEZPrbw7aWNzahXLXygf59Pod28WLA/vDuvvwitqaKJ4h0NQPzNnfBy/2kYLd
         Hwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678722819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou4eTHfchaovdyTcvsOJz1A/GQo+JKYaMd0j8j6QHK8=;
        b=DmBG+koSC7cudQGBBcp3beFfqVIy5oLrGkrS+MFEehWvXqXPu2QXZOLvKoCvagmBO/
         my8AGJr9aMWwDnwTes7+wNwQ38ntTlfYNjlWjPD3Ys3poJyR5HV/7yTP0eZi4BJ6yR3m
         I/jsqtS5OS8evhPGf2btcxZPMDQtaRirT6lZO0+rX2KTeAOTlUkwGYFqiFyNO6mkUnLe
         PtwCpDagm2d+qjZ2NR36gAGaRbIsMvPCkW+ZBbuuU2fnYuUVIV2D8FRwJFBtHHwgz9FH
         wtajWIpHxjmTTWT3NkGUWDL0bEjSAP45tJbAlolPWH19QuDYtgjqbCu6uQXx3bXe3OoJ
         /tJw==
X-Gm-Message-State: AO0yUKXmFoyX/15g1pAJ/JSRuqLz1ZF0JiOdkWrtR1POjOJW9nUu6tm4
        LQII9XpLGYqGtkAiL8M7LptNm+nCAS8=
X-Google-Smtp-Source: AK7set/B3AXUsWJi39YJ5IRScPm11y6++Mvi/PFxtBwCwD2hD3aoPc9yCn2f2bYzX1HNyskG85ynwYN2s2k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:33cb:b0:199:6e3:187a with SMTP id
 kc11-20020a17090333cb00b0019906e3187amr4475804plb.6.1678722819539; Mon, 13
 Mar 2023 08:53:39 -0700 (PDT)
Date:   Mon, 13 Mar 2023 08:53:37 -0700
In-Reply-To: <20230313091425.1962708-2-maz@kernel.org>
Mime-Version: 1.0
References: <20230313091425.1962708-1-maz@kernel.org> <20230313091425.1962708-2-maz@kernel.org>
Message-ID: <ZA9HAQtkCDwFXcsm@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+David

On Mon, Mar 13, 2023, Marc Zyngier wrote:
> We walk the userspace PTs to discover what mapping size was
> used there. However, this can race against the userspace tables
> being freed, and we end-up in the weeds.
> 
> Thankfully, the mm code is being generous and will IPI us when
> doing so. So let's implement our part of the bargain and disable
> interrupts around the walk. This ensures that nothing terrible
> happens during that time.
> 
> We still need to handle the removal of the page tables before
> the walk. For that, allow get_user_mapping_size() to return an
> error, and make sure this error can be propagated all the way
> to the the exit handler.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7113587222ff..d7b8b25942df 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>  				   CONFIG_PGTABLE_LEVELS),
>  		.mm_ops		= &kvm_user_mm_ops,
>  	};
> +	unsigned long flags;
>  	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
>  	u32 level = ~0;
>  	int ret;
>  
> +	/*
> +	 * Disable IRQs so that we hazard against a concurrent
> +	 * teardown of the userspace page tables (which relies on
> +	 * IPI-ing threads).
> +	 */
> +	local_irq_save(flags);
>  	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> -	VM_BUG_ON(ret);
> -	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
> -	VM_BUG_ON(!(pte & PTE_VALID));
> +	local_irq_restore(flags);
> +
> +	/* Oops, the userspace PTs are gone... */
> +	if (ret || level >= KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_VALID))
> +		return -EFAULT;

I don't think this should return -EFAULT all the way out to userspace.  Unless
arm64 differs from x86 in terms of how the userspace page tables are managed, not
having a valid translation _right now_ doesn't mean that one can't be created in
the future, e.g. by way of a subsequent hva_to_pfn().

FWIW, the approach x86 takes is to install a 4KiB (smallest granuale) translation,
which is safe since there _was_ a valid translation when mmu_lock was acquired and
mmu_invalidate_retry() was checked.  It's the primary MMU's responsibility to ensure
all secondary MMUs are purged before freeing memory, i.e. worst case should be that
KVMs stage-2 translation will be immediately zapped via mmu_notifier.

KVM ARM also has a bug that might be related: the mmu_seq snapshot needs to be
taken _before_ mmap_read_unlock(), otherwise vma_shift may be stale by the time
it's consumed.  I believe David is going to submit a patch (I found and "reported"
the bug when doing an internal review of "common MMU" stuff).
