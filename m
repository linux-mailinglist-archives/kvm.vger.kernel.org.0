Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770DB3DAB44
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 20:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhG2Spj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 14:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhG2Spj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7218C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:45:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so6543233pjz.0
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eVRDaVeZVLkzia4aPGY5HOZ7g7OPG00/89JwlL9Gg6o=;
        b=Bv65pOFmFwcxmsUutOAzcMsKSn59cZUJMHcKFLdEFTmDn07L6oLnpRHm3jRjem4Uo7
         ZfxypJiG32HCvkUlfETb88Q56OWH3SCD7wxjVx7jEwycmnztHE4lJ/xAxf8IjC2hDnui
         sEZnFZ4rYz10YO8pGkeys0uD1uaFCsbEAPB5HM2oGRIT9oK1XVSfea4JmC9W9QdMTA4k
         hSw5/XjzBLXSKUk9qW4PvW2ACBLZR+vTx6kMA6echTki+6J/Cz8zM9shXUxn3z13aAdP
         aXzF4nJlBzIcxsVdzqcpOLF45/ypNDJg3DKS+xIyckfi8DlsoHclYCmNzk0e2NMM2gsN
         tmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eVRDaVeZVLkzia4aPGY5HOZ7g7OPG00/89JwlL9Gg6o=;
        b=S3M4ppaoizU9Oz4L/wXEBjQ6Zus+KD7yT5p+7orkb/ojxp4kfhoi73v67tJlIbmuE6
         QgyRG1ibkOXzfJQcj7yFZQHeGDcDuVzjOqxZKyFlXgxPLvx1mO00AZAiZ70qX75RZMwi
         FzP1eu0nAAo/YsfptfefRkVfUqqLnolERo2YNa6SNqrqwqWNplEzrUVAHI0evYbHqOBG
         pFaV3kqtgwMDagPj4xs4PJz9WxPQJMdIokCLgOaM670ta5R/l1cE/4ou0H//XUzwMMXS
         VU77FwH+5Hl5RiU5JF10ZzzmlQ3Q0AdUSGtLMxfqhv1Okn/HXrO/I9JrzPU17Z/cpaly
         j3qw==
X-Gm-Message-State: AOAM532eWsSw1lMn6Mn3rsUKwv8ivo1GjHoIv/1HuM2wuMPWfS3G7DJF
        u+dcKSTAmnYbLH4IFODW9oA2MA==
X-Google-Smtp-Source: ABdhPJy8Gzl6HNSYXwBzk334J2AbQ2BoPfKyDikeM1K5rfTNWw0Nb11fMHSoG4oOE+P98lKiqd3/nA==
X-Received: by 2002:a63:6f8c:: with SMTP id k134mr5002234pgc.35.1627584335225;
        Thu, 29 Jul 2021 11:45:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e35sm10908484pjk.28.2021.07.29.11.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:45:34 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:45:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Add detailed page size stats
Message-ID: <YQL3SlI5XGVxqlvB@google.com>
References: <20210726175357.1572951-1-mizhang@google.com>
 <20210726175357.1572951-4-mizhang@google.com>
 <CANgfPd8iohgpauQEEAFAQjLPXqHQw1Swguc7C0exHcz985igcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8iohgpauQEEAFAQjLPXqHQw1Swguc7C0exHcz985igcw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Ben Gardon wrote:
> On Mon, Jul 26, 2021 at 10:54 AM Mingwei Zhang <mizhang@google.com> wrote:
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 83e6c6965f1e..ad5638815311 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -240,4 +240,6 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> >         return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
> >  }
> >
> > +void kvm_update_page_stats(struct kvm *kvm, int level, int count);
> > +
> >  #endif
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 442cc554ebd6..7e0fc760739b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -588,16 +588,22 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> >         return flush;
> >  }
> >
> > +void kvm_update_page_stats(struct kvm *kvm, int level, int count)
> > +{
> > +       atomic64_add(count, &kvm->stat.page_stats.pages[level - 1]);
> > +}

This can be static inline in the header.  Ignoring prolog+RET, it's four instructions,
and two of those are sign extending input params.

> > +
> >  /*
> >   * Rules for using mmu_spte_clear_track_bits:
> >   * It sets the sptep from present to nonpresent, and track the
> >   * state bits, it is used to clear the last level sptep.
> >   * Returns non-zero if the PTE was previously valid.
> >   */
> > -static int mmu_spte_clear_track_bits(u64 *sptep)
> > +static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >  {
> >         kvm_pfn_t pfn;
> >         u64 old_spte = *sptep;
> > +       int level = sptep_to_sp(sptep)->role.level;
> >
> >         if (!spte_has_volatile_bits(old_spte))
> >                 __update_clear_spte_fast(sptep, 0ull);
> > @@ -607,6 +613,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
> >         if (!is_shadow_present_pte(old_spte))
> >                 return 0;
> >
> > +       if (is_last_spte(old_spte, level))
> 
> You can drop this check since it's part of the contract for calling
> this function.

Ah, nice!  I overlooked that.
