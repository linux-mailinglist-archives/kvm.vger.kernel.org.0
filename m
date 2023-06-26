Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A049D73ECF8
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjFZVhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjFZVho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:37:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E7AC2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:37:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57325434999so52302317b3.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687815462; x=1690407462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2hJTnGKaVBQkg0yz+eVOgG/0uK7zEDVVCQ+nLV5omt0=;
        b=pztYkiPL+Pja+QCn3bFgtqogw6fqAMuWeFWbIIMS5Rj9GDe2aa/AXa6mU5VjTQuFNT
         kGltwz4rKfXYPBP0V/suvXthJtqL23UOZ9I1kC2ChQ2UqCleP5jw6y4Zro6zDTTiKKiJ
         baH1iafxFDqTYS3Pg3RFmhHq/zni5MwsfmOFJaABmwgj0cG2Odcapj4vEa3Ec5/hCI3k
         IsjwRNGKD6lQsQ9yQzKrrpCUVjkcaeqjI4hPVx2/Pt/K5BHDt8YOq/N9PbyhCUnzpiOB
         mrtwGyU06SekKaDzW4z+lXgjDl9On2xsIE2YrMuPyoask0r7Tbqw+HeDqGgkVksZJ//l
         oUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687815462; x=1690407462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hJTnGKaVBQkg0yz+eVOgG/0uK7zEDVVCQ+nLV5omt0=;
        b=VKoxVfuelM9TsOrVSYF7bRkCxr+0dpiOwVCVddMAExukDmZSsEvEXYpIulWnzh6GwB
         ODfnw3H3ytYEPKKGz9yKmISv61FY+USD16dyuIe4xgp0VOzOigcK2z4PsAzA6IWuUy1w
         xURxqYZ1oviORYTpo+5wO3P4iWCHudRBd7wzioVW0A+71KQwSluiUr71nVjUhT+W7vNg
         dC0VPx7Z3BMet/tVrCyNqV3qpxvf6rNi+uwLyJ5+WSvZZoJFceHOuGgEzN05aQnN70u6
         CZ2WJqMIyCsAGV1uZKZ8ewMZiIOXJiFGTCOt5XNAokw+dsXP742tJpColDQ8pKuuqci5
         Ypfg==
X-Gm-Message-State: AC+VfDyZuU2eEQpHK1xSfXhVEdmg89JGdPzQ+9QldmwvowG/9U8ieLGG
        Ax4c0GT1z7vmZ3z1LolTvHbjQEGZRdM=
X-Google-Smtp-Source: ACHHUZ7NdZzNENhExS/VeuzxqO4azWnvTcARnkz17r9kguRpghEbyDaKgFneVMrHPrA+YunJHzIn4G7UK78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b710:0:b0:565:9f59:664f with SMTP id
 v16-20020a81b710000000b005659f59664fmr12998654ywh.6.1687815462579; Mon, 26
 Jun 2023 14:37:42 -0700 (PDT)
Date:   Mon, 26 Jun 2023 14:37:40 -0700
In-Reply-To: <a5398e4b-bb9f-9913-c436-7528479be2ee@gmail.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com> <20230321220021.2119033-7-seanjc@google.com>
 <a5398e4b-bb9f-9913-c436-7528479be2ee@gmail.com>
Message-ID: <ZJoFJMaY97CwloH/@google.com>
Subject: Re: [PATCH v4 06/13] KVM: x86/mmu: Bypass __handle_changed_spte()
 when clearing TDP MMU dirty bits
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 25, 2023, Like Xu wrote:
> On 22/3/2023 6:00 am, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 950c5d23ecee..467931c43968 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -517,7 +517,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> >    *	    threads that might be modifying SPTEs.
> >    *
> >    * Handle bookkeeping that might result from the modification of a SPTE.
> > - * This function must be called for all TDP SPTE modifications.
> >    */
> >   static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >   				  u64 old_spte, u64 new_spte, int level,
> > @@ -1689,8 +1688,10 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
> >   							iter.old_spte, dbit,
> >   							iter.level);
> > -		__handle_changed_spte(kvm, iter.as_id, iter.gfn, iter.old_spte,
> > -				      iter.old_spte & ~dbit, iter.level, false);
> > +		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
> 
> Here the first parameter "kvm" is no longer used in this context.
> 
> Please help confirm that for clear_dirty_pt_masked(), should the "struct kvm
> *kvm" parameter be cleared from the list of incoming parameters ?

Hmm, there's only one caller, so keeping @kvm around "just in case" probably
doesn't make sense, e.g. adding it back so that we could do KVM_BUG_ON() in the
future wouldn't require much churn.

That said, I'm tempted to move the lockdep so that it's more obvious why it's safe
for clear_dirty_pt_masked() to use the non-atomic (for non-volatile SPTEs)
tdp_mmu_clear_spte_bits() helper.  for_each_tdp_mmu_root() does its own lockdep,
so the only "loss" in lockdep coverage is if the list is completely empty.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..0b4f03bef70e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1600,6 +1600,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
                                                   shadow_dirty_mask;
        struct tdp_iter iter;
 
+       lockdep_assert_held_write(&kvm->mmu_lock);
+
        rcu_read_lock();
 
        tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
@@ -1646,7 +1648,6 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
        struct kvm_mmu_page *root;
 
-       lockdep_assert_held_write(&kvm->mmu_lock);
        for_each_tdp_mmu_root(kvm, root, slot->as_id)
                clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }


