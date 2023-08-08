Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6B77425E
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbjHHRms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbjHHRmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:42:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1236A42
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:18:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c647150c254so11223276.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691511488; x=1692116288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zTo5ojti02a55E58VI3g974kVDsDFjEN9JowZT+qd/k=;
        b=L3qGN79NzQ9YFcEBxKQbxLXq5nGagBreae3fETdWihJen/AqQausiFOXRDy/MKNbKC
         DNDbxNALA3nwTdunEIRm643XAMv0nXvSUl7cWi0H0Iwfcye/KNF4xrua4ByFlyeHJN6+
         LTiSA006X/tjFKW6rpxy3IYcmKmToRUyduSg+3d+UyasgnqydJThU5zWgyJjq+2MM7dV
         3Qu4C57SNs+X8/qslYeqB1nfqzikaP7XpwqrsLXpkTtY/DNCmIUHkAx3kT7ck2dW/Du0
         tgPIRsc0h9+d9Svio+OG+Q3KtSOcD970RaADJsZk1C7ol4qP/Mun0or4CGj35Y5okGqw
         p8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511488; x=1692116288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zTo5ojti02a55E58VI3g974kVDsDFjEN9JowZT+qd/k=;
        b=kshwu1+6vUgUnB+Jt7Zz5MpTwOzt0bXtIUHIEVHXVLf7R0ZXfkfj/Y8ut0CiKWPObs
         Gv2iZrP9bp5dTZKmki0bb8LWH9jnNw3UtP19FnDZoFuV20swZ7pdjRm7obMh4FxLc5QM
         4rQ6G/qo5mE6NlMAdkS205Vhy4FyzNWIpCpZSgV+azz8lurvQRo2wa3TT1VfS8Rq+0Cu
         YU6KD9QPxNxqxccJBFuZHl9Nr7reavcoDex7hW3/+VQG1VXsi3MSMGdMYfzbnEOorbn/
         Ru+2oaBdkzrrr+eK+2QUKi9k3TKiQPjtWscQ1Bm2HMe2Bnh6T61zD0xqaZu4kSwjB5Qt
         ji4A==
X-Gm-Message-State: AOJu0Yyp8fs2kOtq3Hihr0CR3mCPJK2msL4B0OvtkXESVt7oznBw481G
        mjmbKTBlWFCiLeqWwfQohQP2xr8bxFU=
X-Google-Smtp-Source: AGHT+IEdPz8huAHqBMaXUgoEqld6bpjYXBbq0y8UIRXJ9G7iWwnU0w/pw1lOLCb7FPvPaLYPGA06MiJ6a7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2792:b0:267:f9ed:93b9 with SMTP id
 pw18-20020a17090b279200b00267f9ed93b9mr101702pjb.3.1691504768630; Tue, 08 Aug
 2023 07:26:08 -0700 (PDT)
Date:   Tue, 8 Aug 2023 07:26:07 -0700
In-Reply-To: <ZNI14eN4bFV5eO4W@nvidia.com>
Mime-Version: 1.0
References: <20230808071329.19995-1-yan.y.zhao@intel.com> <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
Message-ID: <ZNJQf1/jzEeyKaIi@google.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages for
 NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> > @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> >  		    !is_last_spte(iter.old_spte, iter.level))
> >  			continue;
> >  
> > +		if (skip_pinned) {
> > +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> > +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > +			struct folio *folio;
> > +
> > +			if (!page)
> > +				continue;
> > +
> > +			folio = page_folio(page);
> > +
> > +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> > +			    folio_maybe_dma_pinned(folio))
> > +				continue;
> > +		}
> > +
> 
> I don't get it..
> 
> The last patch made it so that the NUMA balancing code doesn't change
> page_maybe_dma_pinned() pages to PROT_NONE
> 
> So why doesn't KVM just check if the current and new SPTE are the same
> and refrain from invalidating if nothing changed?

Because KVM doesn't have visibility into the current and new PTEs when the zapping
occurs.  The contract for invalidate_range_start() requires that KVM drop all
references before returning, and so the zapping occurs before change_pte_range()
or change_huge_pmd() have done antyhing.

> Duplicating the checks here seems very frail to me.

Yes, this is approach gets a hard NAK from me.  IIUC, folio_maybe_dma_pinned()
can yield different results purely based on refcounts, i.e. KVM could skip pages
that the primary MMU does not, and thus violate the mmu_notifier contract.  And
in general, I am steadfastedly against adding any kind of heuristic to KVM's
zapping logic.

This really needs to be fixed in the primary MMU and not require any direct
involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
to be skipped.
