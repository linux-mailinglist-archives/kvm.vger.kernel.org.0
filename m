Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92056761DD0
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjGYP4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjGYP4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:56:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95642212F
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:56:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so6434521276.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690300594; x=1690905394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=192puc/qm0mn1nvHJQQuZAuevgCM+LQ+IAyFRTMu9UI=;
        b=oZHJ5tW0tbTnU+JGXamk16o2P6x09kfVHnHealC4waOtd6uXLmoIBdHIRK87U6tn0V
         O7wXly7QjyM+RqIH00hD9j1PbLvZ5JX0+cSSJRodxGhdLozQ2FNv3xhpnZ+sOcMNjHpe
         n2JcqSB6sFrK/WeSbuokR9t4Fic7FZrd8pfhMgNmPv+Bl5wmLR/a+DIc0biujeuW0iHU
         M9Eyd0CSXzzqdiUe7RZx6meZy/OfW3ddKDQaS7Hl0QGSh7UAkW1TPUEOfqbrzXVHdP06
         8jVzjfcMBdqEJqqK0+gT7/L/6GDvRN7t9iuWU/pmK/HDM13UVjs+VuNn0FQw2or4fDn6
         1Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690300594; x=1690905394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=192puc/qm0mn1nvHJQQuZAuevgCM+LQ+IAyFRTMu9UI=;
        b=WgiTRPHz8vkpFOX1TWMag5gWssWISCyZNKyU5EK2JrnegSv4CdJ/KvXmvRV2S1cUH4
         3Bt9rVneaOmE1wgGThUvnBEjdas5vcXfG2FsCIhfnAd5PcU9nAABcw7Z3OFGlkNVKohW
         8h7XEuAUB9u0JoFqhTf+4PjL9vrCAuuR3NcJCXrLfhyxgl65PPCg8Mowg5nBQLaMuOdG
         E3Dqe7StZyxgRUefEv32616DpzVBhbyN4/aBhG+nobyeCtBaHTr/33pszrAaYNPnQM2S
         jwDLQYAQsd0ykOeBPhIAv7vs+TzvdneUZjOkaAm5+PxTFygXhqVrxxOxdt5JY6d2lw/L
         Q4BA==
X-Gm-Message-State: ABy/qLag3sYYcZ680RdmXtlHdigrhryi6ZwkEaAo0uUzTgwPyfHvpdk5
        g68VomHjju5DwY+8lIlNFUWY7JXiZ0M=
X-Google-Smtp-Source: APBJJlEAyggedsH1gCoghZnma/qZapoi1yuUBu5b3Q+lCrrgQv4F06/B9A6hcBih6sdIzQsURAg3KiFRP8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cc82:0:b0:d0d:cce3:d32d with SMTP id
 l124-20020a25cc82000000b00d0dcce3d32dmr41470ybf.6.1690300594623; Tue, 25 Jul
 2023 08:56:34 -0700 (PDT)
Date:   Tue, 25 Jul 2023 08:56:32 -0700
In-Reply-To: <20230725103945.wfa5zdupen3oo6xl@linux.intel.com>
Mime-Version: 1.0
References: <20230722012350.2371049-1-seanjc@google.com> <20230722012350.2371049-4-seanjc@google.com>
 <20230725103945.wfa5zdupen3oo6xl@linux.intel.com>
Message-ID: <ZL/wsIVpcpKs/9Nq@google.com>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Harden TDP MMU iteration against root
 w/o shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Yu Zhang wrote:
> On Fri, Jul 21, 2023 at 06:23:48PM -0700, Sean Christopherson wrote:
> > Explicitly check that tdp_iter_start() is handed a valid shadow page
> > to harden KVM against bugs where
> 
> Sorry, where? 

Gah, I must have seen something shiny when writing the changelog.

> It's not about guest using an invisible GFN, it's about a KVM bug, right?

Yes, the intent is to guard against a KVM bug, e.g. if KVM managed to get into
the TDP MMU with an invalid root, or a root belonging to a shadow MMU.  I'll fix
the changelog in v2.

> > Opportunistically stop the TDP MMU iteration instead of continuing on
> > with garbage if the incoming root is bogus.  Attempting to walk a garbage
> > root is more likely to caused major problems than doing nothing.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_iter.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > index d2eb0d4f8710..bd30ebfb2f2c 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > @@ -39,13 +39,14 @@ void tdp_iter_restart(struct tdp_iter *iter)
> >  void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
> >  		    int min_level, gfn_t next_last_level_gfn)
> >  {
> > -	int root_level = root->role.level;
> > -
> > -	WARN_ON(root_level < 1);
> > -	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> > +	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
> > +			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
> > +		iter->valid = false;
> > +		return;
> > +	}
> >  
> 
> I saw many usages of WARN_ON_ONCE() and WARN_ON() in KVM. And just wonder,
> is there any criteria for KVM when to use which?

Heh, already a step ahead of you :-)

https://lore.kernel.org/all/20230721230006.2337941-5-seanjc@google.com
