Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860E24E9A59
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 17:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbiC1PIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiC1PHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 11:07:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93F842493
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:06:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w8so14975606pll.10
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zz78z33yFHtZRSSNmauNeT7l3F6pTP5Wuw/P3SLSelM=;
        b=me7G4cweEmp57KupCV467bfI1TSnYZyFADfTY35iTe03gSougwSmazMMO8MRhAdxM1
         pt7raBi4qOeZe96p56k5hKYBCp1OCqd+777Yy/z6DxHujuR8TsEE9PZ/tEr04WE5rTzr
         UuWUK4WGqFPP7Uyy3hQuJXEi8gWtLNXiBzDlDiq74wjtiwPer76rQ7MpIAgujB5asqW4
         jtFS+KDBPpt2P1gvO95B68rXtLs2yzZXC0j0xCvJcF1pO25O0E2vOowAa1AkxUa5AMwC
         oG0neeAVfEFAM0Gp0qfgc1SUqoMVn4qyed+MGMMgsbYG4MZ9NMA+Cord0Y0vtniA2E+5
         UdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zz78z33yFHtZRSSNmauNeT7l3F6pTP5Wuw/P3SLSelM=;
        b=m7eC5wQf32rIgc3GUpWIowwInWz0OCXGzhzjSqgJYqc2hen0qk9wY8r63ic0ExM8VJ
         bVy1IlwOtEMylMWFFo0Qc3C3bRNU0e+ltm9sRek1TbzhjMRtR+02OK6kBucrSVfjocuV
         YG2UMZX4ruk3QrPFI+aKl/u+do3CoGk5qhrPVeA6BACXbhWcpPsWDBegADW4jPC83hBs
         BWJ+LMpxVqEIhIW0P0wfazm3wpyN+llpub6Nq+tzAZ06TvEi7c7pud7ui7Tc9l0AHesA
         N2E0qL3oNjrTWOKfynz/+vpVb2oK2Jhb+87Su7WuryIrsI1Qm5UNhWdMiwGH4aiqyxH2
         hcNQ==
X-Gm-Message-State: AOAM531r5ZzEYcgi2UTaoJlUnAwHZ8y5U7zG/Sd5oiZiU0YH3o5+yVyZ
        ZQp44LM9tuvw0xyTUj1Wr6tltA==
X-Google-Smtp-Source: ABdhPJyg5EMl++69z2SYOt3nYMu654rYAjrcKMJF7WpjdZRu+pIqZPI9MApmXKgkiHS7sEEP6hYOdQ==
X-Received: by 2002:a17:90b:4c0a:b0:1c6:90be:1e03 with SMTP id na10-20020a17090b4c0a00b001c690be1e03mr41914850pjb.7.1648479964880;
        Mon, 28 Mar 2022 08:06:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p34-20020a056a000a2200b004cd49fc15e5sm17247471pfh.59.2022.03.28.08.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 08:06:04 -0700 (PDT)
Date:   Mon, 28 Mar 2022 15:06:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()
Message-ID: <YkHO2L14UF1jHHP2@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
 <CAL715WJc3QdFe4gkbefW5zHPaYZfErG9vQmOLsbXz=kbaB-6uw@mail.gmail.com>
 <Yj3b/IhXU9eutjoS@google.com>
 <Yj9XE/oeQXBp2Ryg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj9XE/oeQXBp2Ryg@google.com>
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

On Sat, Mar 26, 2022, Mingwei Zhang wrote:
> On Fri, Mar 25, 2022, Sean Christopherson wrote:
> > On Sun, Mar 13, 2022, Mingwei Zhang wrote:
> > > On Thu, Mar 3, 2022 at 11:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > @@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > > >   * SPTEs have been cleared and a TLB flush is needed before releasing the
> > > >   * MMU lock.
> > > >   */
> > > > -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> > > > -                                gfn_t end, bool can_yield, bool flush)
> > > > +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> > > > +                          bool can_yield, bool flush)
> > > >  {
> > > >         struct kvm_mmu_page *root;
> > > >
> > > >         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> > > > -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> > > > +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
> > > 
> > > hmm, I think we might have to be very careful here. If we only zap
> > > leafs, then there could be side effects. For instance, the code in
> > > disallowed_hugepage_adjust() may not work as intended. If you check
> > > the following condition in arch/x86/kvm/mmu/mmu.c:2918
> > > 
> > > if (cur_level > PG_LEVEL_4K &&
> > >     cur_level == fault->goal_level &&
> > >     is_shadow_present_pte(spte) &&
> > >     !is_large_pte(spte)) {
> > > 
> > > If we previously use 4K mappings in this range due to various reasons
> > > (dirty logging etc), then afterwards, we zap the range. Then the guest
> > > touches a 4K and now we should map the range with whatever the maximum
> > > level we can for the guest.
> > > 
> > > However, if we just zap only the leafs, then when the code comes to
> > > the above location, is_shadow_present_pte(spte) will return true,
> > > since the spte is a non-leaf (say a regular PMD entry). The whole if
> > > statement will be true, then we never allow remapping guest memory
> > > with huge pages.
> > 
> > But that's at worst a performance issue, and arguably working as intended.  The
> > zap in this case is never due to the _guest_ unmapping the pfn, so odds are good
> > the guest will want to map back in the same pfns with the same permissions.
> > Zapping shadow pages so that the guest can maybe create a hugepage may end up
> > being a lot of extra work for no benefit.  Or it may be a net positive.  Either
> > way, it's not a functional issue.
> 
> This should be a performance bug instead of a functional one. But it
> does affect both dirty logging (before Ben's early page promotion) and
> our demand paging.

I'd buy the argument that KVM should zap shadow pages when zapping specifically to
recreate huge pages, but that's a different path entirely.  Disabling of dirty
logging uses a dedicated path, zap_collapsible_spte_range().

> So I proposed the fix in here:
> 
> https://lore.kernel.org/lkml/20220323184915.1335049-2-mizhang@google.com/T/#me78d50ffac33f4f418432f7b171c50630414ef28
> 
> If we see memory corruptions, I bet it could only be that we miss some
> TLB flushes, since this patch series is basically trying to avoid
> immediate TLB flushing by simply changing ASID (assigning new root).

Ya, it was a lost TLB flush goof.  My apologaies for not cc'ing you on the patch.

https://lore.kernel.org/all/20220325230348.2587437-1-seanjc@google.com

> To debug, maybe force the TLB flushes after zap_gfn_range and see if the
> problem still exist?
> 
> 
