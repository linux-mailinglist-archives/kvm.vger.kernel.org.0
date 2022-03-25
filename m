Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453824E7681
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357206AbiCYPP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377486AbiCYPOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:14:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF9DC32
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:13:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q11so8297793pln.11
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F5PY9X/jp0F4AgxSPkBkfgIyJrI2tyNfex9j4AupEbk=;
        b=HmQuyS8md0PfvL+aGN85J4Lkm/vGXCQvpc/ISSNkxX1kjJOFD2GzH4dbWHzLnxrcZn
         yejEeN+M5vd+milk5coOyyjZ68MwLLgzzJKbhoaom7SDa5J4ghXvBrZYlhJA4C12gSS3
         ombiTcVWYo3Pt9IyuBui81rxtprixViYxTsGjgaESz+SsRhYdhL6s1vSo1o05VNBo9xH
         Y0Irgux8iAjuKv5u6ZhQUD5AjEou4BHpcxIuyEsGFeRvFhsyOgcAKp6Qfan50PKOmkQP
         +rEY9ZuRtlqIAfRSSXUuMQvagsHqrnMclgtwjm7W+27EwS8StEzUUZqy/U3xN4iVKkvd
         68dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F5PY9X/jp0F4AgxSPkBkfgIyJrI2tyNfex9j4AupEbk=;
        b=IikTBVVWXoVELA7HiHbOuFIKEPxtnD4FSM2nZkPrJvyZ4gRUiphxJmtIJIrgEtLZJm
         X0Kq/7ZizbOxubxNxrwV0BoKZmHR9+txpME2Z2MVHzgxgyNqh0pqpxyGp9kqC2EzW+hY
         of7icoj88SzHLKMT8fmkWG0634HNz/kWhOswaSPy+xseJRvA7PrUn6ao55gjVOA37qmA
         gaY0Fu18+so3HW7bkOxvm5rB00N8ar9xEDCy2aLNSrcKGuT7YmxetSKAmCEMfzs2hUxD
         cUaD5tjJ7Suf6f7+5b/9mMmnS5xYky4qLu61JuldBMBYpoLfjAUrm14EeY16mEI1vLHn
         2PGQ==
X-Gm-Message-State: AOAM53161PVSwQ7lOnDa2OsdSTNxEcGkyGPxXLm6i487CmCIONdIZL4F
        iRbBfzzpx0uxuDs8Q2I74T1wyQ==
X-Google-Smtp-Source: ABdhPJwc/sVCV5MbQy209QJPcZg2mXqaNy4LQDF1x6hrbgePnG/Gd8+vwGXUaI/HJC0PUMslKFcNPg==
X-Received: by 2002:a17:903:1205:b0:151:8ae9:93ea with SMTP id l5-20020a170903120500b001518ae993eamr12288183plh.37.1648221184638;
        Fri, 25 Mar 2022 08:13:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r1-20020a63b101000000b00380989bcb1bsm5682437pgf.5.2022.03.25.08.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 08:13:03 -0700 (PDT)
Date:   Fri, 25 Mar 2022 15:13:00 +0000
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
Message-ID: <Yj3b/IhXU9eutjoS@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
 <CAL715WJc3QdFe4gkbefW5zHPaYZfErG9vQmOLsbXz=kbaB-6uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WJc3QdFe4gkbefW5zHPaYZfErG9vQmOLsbXz=kbaB-6uw@mail.gmail.com>
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

On Sun, Mar 13, 2022, Mingwei Zhang wrote:
> On Thu, Mar 3, 2022 at 11:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > @@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >   * SPTEs have been cleared and a TLB flush is needed before releasing the
> >   * MMU lock.
> >   */
> > -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> > -                                gfn_t end, bool can_yield, bool flush)
> > +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> > +                          bool can_yield, bool flush)
> >  {
> >         struct kvm_mmu_page *root;
> >
> >         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> > -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> > +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
> 
> hmm, I think we might have to be very careful here. If we only zap
> leafs, then there could be side effects. For instance, the code in
> disallowed_hugepage_adjust() may not work as intended. If you check
> the following condition in arch/x86/kvm/mmu/mmu.c:2918
> 
> if (cur_level > PG_LEVEL_4K &&
>     cur_level == fault->goal_level &&
>     is_shadow_present_pte(spte) &&
>     !is_large_pte(spte)) {
> 
> If we previously use 4K mappings in this range due to various reasons
> (dirty logging etc), then afterwards, we zap the range. Then the guest
> touches a 4K and now we should map the range with whatever the maximum
> level we can for the guest.
> 
> However, if we just zap only the leafs, then when the code comes to
> the above location, is_shadow_present_pte(spte) will return true,
> since the spte is a non-leaf (say a regular PMD entry). The whole if
> statement will be true, then we never allow remapping guest memory
> with huge pages.

But that's at worst a performance issue, and arguably working as intended.  The
zap in this case is never due to the _guest_ unmapping the pfn, so odds are good
the guest will want to map back in the same pfns with the same permissions.
Zapping shadow pages so that the guest can maybe create a hugepage may end up
being a lot of extra work for no benefit.  Or it may be a net positive.  Either
way, it's not a functional issue.
