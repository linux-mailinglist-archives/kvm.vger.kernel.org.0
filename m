Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1674FA46
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 00:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjGKWAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 18:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjGKWAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 18:00:02 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83392170A
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 15:00:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57059e6f9c7so1630617b3.0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 15:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689112801; x=1691704801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ccVD+v/KXcHhv0uWZezqc41e6QVd7uWNQyLzMUxhDwI=;
        b=e/OHUuoBBcGsOIwFM1ihGsxpoWFlVjzLMAWcIxlED6fy/pQq7H8OwqSGXEvry5gTmX
         4n4LJm3GrKYhp1rDcb2yZjoYmKujuDdwTE/pTr0qBWVQ3Mv7FqTUboTB8BJqLnZ++eP3
         +Z5AMrB4uV2t/Yv3OGB4AzzvzxiLBamqfxXJJchimaePAXxst2FicMRdYA3ExEYktE31
         eN5Wkg4N5lrPnQj1QCrAi02P4cVVslhw60TH3+m1+hFgH21D8rCn0hHB6zVsMmcWGVZt
         f1BVBLr3QqPY8xNPlcA8vnOEbH04GpDVqoNu17fMR6IWcB/HZElSHY1LVXPIBa+K7LMT
         zAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689112801; x=1691704801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccVD+v/KXcHhv0uWZezqc41e6QVd7uWNQyLzMUxhDwI=;
        b=W+Mm4JgpUJESouJKyQRJBd5RggeUdneBCwFR6cE/8wvlPFiqKbrr5Xtp5JWA699Zkr
         ugpPyYuW/9T61jE+z5B7Q84YMbYz9KwiIYTu0F/V5SD/mqZ0E/gNDlbpVAE4sfwsHAxi
         OGRUZoOwqQfuii18PyeGu0zxXwFvxjismaA6M8k3HiNpCq0OXDXSOF86lQysTNHpPqa+
         nXFWqmJ/2x4qEOhZ+FDZ2yYDvBnAOWtXz0p3oIzeoFetkXtwIBWcy32eG7XJB1MKphA4
         wgx4tTc/fPODDqTMkm8veVNAZGnhbRmN1iwBrKjC43h307hVEASgdfFesGaNFTGGwkd9
         wNiw==
X-Gm-Message-State: ABy/qLY862PKTGWmUA3cO2huRVO9if1iG7Ic/Ic9ccwaDVtI1milQLhl
        /YrM0aC9mzoIPyyQLlMOscO9q1UZ5VU=
X-Google-Smtp-Source: APBJJlGIAl79q11h5ZhsnevB6cH0mxnTImxDoBGf6sOpWk2D0KKk/yU+n2H4PPFE466tsXaDVFr5sq8QXGg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae4b:0:b0:56c:ed45:442c with SMTP id
 g11-20020a81ae4b000000b0056ced45442cmr1839ywk.5.1689112800813; Tue, 11 Jul
 2023 15:00:00 -0700 (PDT)
Date:   Tue, 11 Jul 2023 14:59:59 -0700
In-Reply-To: <20230711203348.00000fb8.zhi.wang.linux@gmail.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705161914.00004070.zhi.wang.linux@gmail.com> <CAD=HUj5cbzjrc0KD7xcibtRMRCzoJRJAzt7jTHSXUSpzyAYbdg@mail.gmail.com>
 <20230711203348.00000fb8.zhi.wang.linux@gmail.com>
Message-ID: <ZK3Q34WNLjGVQQw+@google.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
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

On Tue, Jul 11, 2023, Zhi Wang wrote:
> On Thu, 6 Jul 2023 15:49:39 +0900
> David Stevens <stevensd@chromium.org> wrote:
> 
> > On Wed, Jul 5, 2023 at 10:19___PM Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> > >
> > > On Tue,  4 Jul 2023 16:50:48 +0900
> > > David Stevens <stevensd@chromium.org> wrote:
> > > If yes, do we have to use FOLL_GET to resolve GFN associated with a tail page?
> > > It seems gup can tolerate gup_flags without FOLL_GET, but it is more like a
> > > temporary solution. I don't think it is a good idea to play tricks with
> > > a temporary solution, more like we are abusing the toleration.  
> > 
> > I'm not sure I understand what you're getting at. This series never
> > calls gup without FOLL_GET.
> > 
> > This series aims to provide kvm_follow_pfn as a unified API on top of
> > gup+follow_pte. Since one of the major clients of this API uses an mmu
> > notifier, it makes sense to support returning a pfn without taking a
> > reference. And we indeed need to do that for certain types of memory.
> > 
> 
> I am not having prob with taking a pfn without taking a ref. I am
> questioning if using !FOLL_GET in struct kvm_follow_pfn to indicate taking
> a pfn without a ref is a good idea or not, while there is another flag
> actually showing it.
> 
> I can understand that using FOLL_XXX in kvm_follow_pfn saves some
> translation between struct kvm_follow_pfn.{write, async, xxxx} and GUP
> flags. However FOLL_XXX is for GUP. Using FOLL_XXX for reflecting the
> requirements of GUP in the code path that going to call GUP is reasonable.
> 
> But using FOLL_XXX with purposes that are not related to GUP call really
> feels off.

I agree, assuming you're talking specifically about the logic in hva_to_pfn_remapped()
that handles non-refcounted pages, i.e. this

	if (get_page_unless_zero(page)) {
		foll->is_refcounted_page = true;
		if (!(foll->flags & FOLL_GET))
			put_page(page);
	} else if (foll->flags & FOLL_GET) {
		r = -EFAULT;
	}

should be

	if (get_page_unless_zero(page)) {
		foll->is_refcounted_page = true;
		if (!(foll->flags & FOLL_GET))
			put_page(page);
	else if (!foll->guarded_by_mmu_notifier)
		r = -EFAULT;

because it's not the desire to grab a reference that makes getting non-refcounted
pfns "safe", it's whether or not the caller is plugged into the MMU notifiers.

Though that highlights that checking guarded_by_mmu_notifier should be done for
*all* non-refcounted pfns, not just non-refcounted struct page memory.

As for the other usage of FOLL_GET in this series (using it to conditionally do
put_page()), IMO that's very much related to the GUP call.  Invoking put_page()
is a hack to workaround the fact that GUP doesn't provide a way to get the pfn
without grabbing a reference to the page.  In an ideal world, KVM would NOT pass
FOLL_GET to the various GUP helpers, i.e. FOLL_GET would be passed as-is and KVM
wouldn't "need" to kinda sorta overload FOLL_GET to manually drop the reference.

I do think it's worth providing a helper to consolidate and document that hacky
code, e.g. add a kvm_follow_refcounted_pfn() helper.

All in all, I think the below (completely untested) is what we want?

David (and others), I am planning on doing a full review of this series "soon",
but it will likely be a few weeks until that happens.  I jumped in on this
specific thread because this caught my eye and I really don't want to throw out
*all* of the FOLL_GET usage.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b5afd70f239..90d424990e0a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2481,6 +2481,25 @@ static inline int check_user_page_hwpoison(unsigned long addr)
        return rc == -EHWPOISON;
 }
 
+static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
+                                          struct page *page)
+{
+       kvm_pfn_t pfn = page_to_pfn(page);
+
+       foll->is_refcounted_page = true;
+
+       /*
+        * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the caller
+        * doesn't want to grab a reference, but gup() doesn't support getting
+        * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ever
+        * changes, drop this and simply don't pass FOLL_GET to gup().
+        */
+       if (!(foll->flags & FOLL_GET))
+               put_page(page);
+
+       return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
@@ -2500,11 +2519,9 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
                return false;
 
        if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
-               *pfn = page_to_pfn(page[0]);
                foll->writable = foll->allow_write_mapping;
-               foll->is_refcounted_page = true;
-               if (!(foll->flags & FOLL_GET))
-                       put_page(page[0]);
+
+               *pfn = kvm_follow_refcounted_pfn(foll, page[0]);
                return true;
        }
 
@@ -2528,7 +2545,6 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
                return npages;
 
        foll->writable = (foll->flags & FOLL_WRITE) && foll->allow_write_mapping;
-       foll->is_refcounted_page = true;
 
        /* map read fault as writable if possible */
        if (unlikely(!foll->writable) && foll->allow_write_mapping) {
@@ -2540,9 +2556,8 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
                        page = wpage;
                }
        }
-       *pfn = page_to_pfn(page);
-       if (!(foll->flags & FOLL_GET))
-               put_page(page);
+
+       *pfn = kvm_follow_refcounted_pfn(foll, page);
        return npages;
 }
 
@@ -2610,17 +2625,16 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma, struct kvm_follow_pfn
        if (!page)
                goto out;
 
-       if (get_page_unless_zero(page)) {
-               foll->is_refcounted_page = true;
-               if (!(foll->flags & FOLL_GET))
-                       put_page(page);
-       } else if (foll->flags & FOLL_GET) {
-               r = -EFAULT;
-       }
-
+       if (get_page_unless_zero(page))
+               WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) != pfn);
 out:
        pte_unmap_unlock(ptep, ptl);
-       *p_pfn = pfn;
+
+       if (!foll->is_refcounted_page && !foll->guarded_by_mmu_notifier &&
+           !allow_unsafe_mappings)
+               r = -EFAULT;
+       else
+               *p_pfn = pfn;
 
        return r;
 }

