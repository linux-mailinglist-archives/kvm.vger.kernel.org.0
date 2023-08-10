Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB05877846C
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjHJX6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjHJX6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:58:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707E272E
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:58:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4db57d2982so1624842276.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711919; x=1692316719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7TaVxk2ZLZyMV4sj4aUHau1XdgMachiHgDRxXpQpSw=;
        b=gtfJoNBtgf2nmA0MCyoIsgEUvN83zPnCfYVbdsmX+aecvQHhUIf7674qgmsPb9LxnM
         foW1+MNfR8qjGqSC2HMsKMixec7fNUm1Rh/FjjU1DQH377QerQVx7txYOx1z/2poukF7
         5Iz65EJQp3zzjfPQbgrc60824uuAWkZ+2B1OI//owRhEWHnVC9uj/mXea2GvtweUwsgK
         wjCJd6G9TY3DUAHHTaO2nlHI/YC0XsX5Uwi9yMTQG3QB41QrkFq/0GbyBJjJdrPsO14/
         HKcWf4CrI+bXJ4BJAcWEz8eyr0BdXen2htmeYURgEFe8ojoohHyg30bs83efcQ+pdsUR
         wn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711919; x=1692316719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7TaVxk2ZLZyMV4sj4aUHau1XdgMachiHgDRxXpQpSw=;
        b=Y1gOuKlQSIj30e4AoVEYHkHE3323voj209vsPNG/g6XI4+bddpB99hTRM/dAqWEADx
         eFFKr2KdCQ1Usf7nIS3u5jI/LddC/U+f9T/Nx8MHQ1WmhS2/fIgK6aqU3yI6T7IJQjtB
         jp5+1EYDS9IW4I7bOSnl6rPnm5iUuAlxEMQZSddvrw1DvJrvv3y0XdY4GEdUhSziGQqD
         kJ4KKorptuWm/D4IHqbbz9LRW88aycKOMSy9cPPZ2yUs6ugJxVfjhgAKqFI9vcbxoRM/
         cQSeCZN6kThyUvHEqo8mHwsIF3yRfZlZWz4Mt4J1E9dDNi8jyFOpl6S7R9Rlec0napuv
         7L0g==
X-Gm-Message-State: AOJu0Yz2gXX7sF1VuzoRLgT/Pk+WuT4wx7e0KDLs3Xqt458jPD8qLTgE
        WgZUbWYd8WhnxAZOmFICpp/oZV2wzrQ=
X-Google-Smtp-Source: AGHT+IHJDIYRFBW2LAZLR4csOSfB1VjiTYZ9Zt4brWftdaN1l/ClE48UHSPut/7oRadou49NRhv+18IvPXk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cf:b0:d4e:b0cb:c81d with SMTP id
 n15-20020a05690211cf00b00d4eb0cbc81dmr4745ybu.8.1691711919804; Thu, 10 Aug
 2023 16:58:39 -0700 (PDT)
Date:   Thu, 10 Aug 2023 16:58:38 -0700
In-Reply-To: <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net>
Mime-Version: 1.0
References: <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <e21d306a-bed6-36e1-be99-7cdab6b36d11@ewheeler.net>
 <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net>
Message-ID: <ZNV5rrq1Ja7QgES5@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
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

On Wed, Aug 09, 2023, Eric Wheeler wrote:
> On Wed, 9 Aug 2023, Eric Wheeler wrote:
> > On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > > On Tue, Aug 08, 2023, Amaan Cheval wrote:
> > > > Hey Sean,
> > > > 
> > > > > If NUMA balancing is going nuclear and constantly zapping PTEs, the resulting
> > > > > mmu_notifier events could theoretically stall a vCPU indefinitely.  The reason I
> > > > > dislike NUMA balancing is that it's all too easy to end up with subtle bugs
> > > > > and/or misconfigured setups where the NUMA balancing logic zaps PTEs/SPTEs without
> > > > > actuablly being able to move the page in the end, i.e. it's (IMO) too easy for
> > > > > NUMA balancing to get false positives when determining whether or not to try and
> > > > > migrate a page.
> > > > 
> > > > What are some situations where it might not be able to move the page in the end?
> > > 
> > > There's a pretty big list, see the "failure" paths of do_numa_page() and
> > > migrate_misplaced_page().
> > > 
> > > > > That said, it's definitely very unexpected that NUMA balancing would be zapping
> > > > > SPTEs to the point where a vCPU can't make forward progress.   It's theoretically
> > > > > possible that that's what's happening, but quite unlikely, especially since it
> > > > > sounds like you're seeing issues even with NUMA balancing disabled.
> 
> Brak indicated that they've seen this as early as v5.19.  IIRC, Hunter
> said that v5.15 is working fine, so I went through the >v5.15 and <v5.19
> commit logs for KVM that appear to be related to EPT. Of course if the
> problem is outside of KVM, then this is moot, but maybe these are worth
> a second look.
> 
> Sean, could any of these commits cause or hint at the problem?

No, it's extremely unlikely any of these are related.  FWIW, my money is on this
being a bug in generic KVM bug or even outside of KVM, not a bug in KVM x86's MMU.
But I'm not confident enough to bet real money ;-)

>   54275f74c KVM: x86/mmu: Don't attempt fast page fault just because EPT is in use
> 	- this mentions !PRESENT related to faulting out of mmu_lock.
> 
>   ec283cb1d KVM: x86/mmu: remove ept_ad field
> 	- looks like a simple patch, but could there be a reason that
> 	  this is somehow invalid in corner cases?  Here is the relevant 
> 	  diff snippet:
> 
> 	+++ b/arch/x86/kvm/mmu/mmu.c
> 	@@ -5007,7 +5007,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
> 	 
> 			context->shadow_root_level = level;
> 	 
> 	-               context->ept_ad = accessed_dirty;
> 
> 	+++ b/arch/x86/kvm/mmu/paging_tmpl.h
> 	-       #define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
> 	+       #define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
> 
>   ca2a7c22a KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits
> 	- "No functional change intended" but it mentions EPT
> 	  violations.  Could something unintentional have happened here?
> 
>   4f4aa80e3 KVM: X86: Handle implicit supervisor access with SMAP
> 	- This is a small change, but maybe it would be worth a quick review
> 	
>   5b22bbe71 KVM: X86: Change the type of access u32 to u64
> 	- This is just a datatype change in 5.17-rc3, probably not it.
