Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01F0558B46
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 00:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiFWWgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 18:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiFWWgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 18:36:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CA45133A
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 15:36:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so3971229pjm.4
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JetDtHU3X+1B2pqv06q6XrBYV3K3bGShzpXgJBS5x0g=;
        b=dyEgVIex9SIwN8/Oyba1p0Nc/YJDQKTUUM+mY41FwvpygkyZzf0UtRzkKtS4EIBHHA
         Xck2+vMALl3GyO0YO8LzH+UzcYB+LWSq4wyqHpkd6GB7JHgdEgY4GmC2kYqywMW9wsls
         zHvDQWimUQ2Amyryb6JyWPUCRISy1yFQeB2SK1K2Q1zmns78u8LqMrF2dCe0rnOnEtOS
         s4EI3EPGuqp63XvDPn4eK8iO6Q9nl13rFabYy1ssU8BiQGN2cC5gYvW0Kh0SSQATdEo1
         YR4qTvqz2T8gAwdcHcKLG32P3KZmowtxSSGghozM+FEM9d62/53a/FQfUV/bBixZfntZ
         9BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JetDtHU3X+1B2pqv06q6XrBYV3K3bGShzpXgJBS5x0g=;
        b=AYEU4+sS73OOZtTlQ2zX2D8D/q3vRjyjCP2I/6IiaAoOZboTYW351/h2JRwm5ITWvg
         maUnUuXPBmGigGN3LgQqoWvTnj/fLrbCIjaqDndE7tGoRhBR3m0klI1dVYZi9cqk/r3o
         RyZWDUB6OczhAWjRxOQEPLX4UXdrBNBVcbJHzK/iS/bsVdzknKJgG47CnWR54TkwNa/2
         IXbybrTwWdeazXrEg72BP/BLtSOdGiRxr7urZY5rrojZlepkdtNMvlwYf6qAH1XysADR
         XNNUApE3y1vPJUZYe2C47wcVBZEyZa2JPSV1Xc/e2z24/wZHRS2HBtcJ5FRS2h7yx9lC
         20PA==
X-Gm-Message-State: AJIora8UaIqQWYRgeBxv8VRNIC7K6ILO+cIZLz5m041T7o/VkMRPxccK
        1UBP1jjUouWdMyPfXSTJ7vXBww==
X-Google-Smtp-Source: AGRyM1tvIami/If6+RQSfpCBjEgTqjpFW/6mqfqXNmMf74n8X2WXBnNOJEHAYhBFEwQGjNfyTfwJcg==
X-Received: by 2002:a17:903:10a:b0:16a:2762:88e2 with SMTP id y10-20020a170903010a00b0016a276288e2mr21456838plc.22.1656023803838;
        Thu, 23 Jun 2022 15:36:43 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id ca27-20020a056a00419b00b00525133f98adsm154148pfb.146.2022.06.23.15.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 15:36:42 -0700 (PDT)
Date:   Thu, 23 Jun 2022 22:36:37 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v7 22/23] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YrTq9RU7r05ud+tb@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-23-pbonzini@redhat.com>
 <CALzav=fH_9_LKVE0_UCftwy2KZaB3nSBoWU07aPWALag4_mcHQ@mail.gmail.com>
 <YrTDcrsn0/+alpzf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTDcrsn0/+alpzf@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 07:48:02PM +0000, Sean Christopherson wrote:
> On Thu, Jun 23, 2022, David Matlack wrote:
> > On Wed, Jun 22, 2022 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> Please trim replies.
> 
> > > +static int topup_split_caches(struct kvm *kvm)
> > > +{
> > > +       int r;
> > > +
> > > +       lockdep_assert_held(&kvm->slots_lock);
> > > +
> > > +       /*
> > > +        * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> > > +        * when splitting a page, but setting capacity == min would cause
> > > +        * KVM to drop mmu_lock even if just one object was consumed from the
> > > +        * cache.  So make capacity larger than min and handle two huge pages
> > > +        * without having to drop the lock.
> > 
> > I was going to do some testing this week to confirm, but IIUC KVM will
> > only allocate from split_desc_cache if the L1 hypervisor has aliased a
> > huge page in multiple {E,N}PT12 page table entries. i.e. L1 is mapping
> > a huge page into an L2 multiple times, or mapped into multiple L2s.
> > This should be common in traditional, process-level, shadow paging,
> > but I think will be quite rare for nested shadow paging.
> 
> Ooooh, right, I forgot that that pte_list_add() needs to allocate if and only if
> there are multiple rmap entries, otherwise rmap->val points that the one and only
> rmap directly.
> 
> Doubling the capacity is all but guaranteed to be pointless overhead.  What about
> buffering with the default capacity?  That way KVM doesn't have to topup if it
> happens to encounter an aliased gfn.  It's arbitrary, but so is the default capacity
> size.
> 
> E.g. as fixup

LGTM

> 
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 22b87007efff..90d6195edcf3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6125,19 +6125,23 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> 
>  static int topup_split_caches(struct kvm *kvm)
>  {
> -	int r;
> -
> -	lockdep_assert_held(&kvm->slots_lock);
> -
>  	/*
> -	 * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> -	 * when splitting a page, but setting capacity == min would cause
> -	 * KVM to drop mmu_lock even if just one object was consumed from the
> -	 * cache.  So make capacity larger than min and handle two huge pages
> -	 * without having to drop the lock.
> +	 * Allocating rmap list entries when splitting huge pages for nested
> +	 * MMUs is rare as KVM needs to allocate if and only if there is more
> +	 * than one rmap entry for the gfn, i.e. requires an L1 gfn to be
> +	 * aliased by multiple L2 gfns, which is very atypical for VMMs.  If
> +	 * there is only one rmap entry, rmap->val points directly at that one
> +	 * entry and doesn't need to allocate a list.  Buffer the cache by the
> +	 * default capacity so that KVM doesn't have to topup the cache if it
> +	 * encounters an aliased gfn or two.
>  	 */
> -	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
> -					 2 * SPLIT_DESC_CACHE_MIN_NR_OBJECTS,
> +	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
> +			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
>  					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
>  	if (r)
>  		return r;
> 
> base-commit: 436b1c29f36ed3d4385058ba6f0d6266dbd2a882
> --
> 
