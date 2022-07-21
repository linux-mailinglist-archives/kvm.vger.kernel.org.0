Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6E57D175
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiGUQ1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGUQ1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:27:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595598875B
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:27:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f11so2299341plr.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycEo8rq5UtZnwC6hQzTjMDJ45cvRJruq/s+I5GijYek=;
        b=j0qCNnv3YhAAKWjdYM5hb/iiBS30UPtTpaKzK/5qfPWowKMKN4d51LIGszGBELf1T+
         S78AwILwSJ9DGmtRJg3Fo0Q3HhOGWjRSvwiNv73dTHvika9+p/eTIaWfdsYziUnAWJMl
         croBjvv43nQChvWY1XFao+twS9ZtdTCzWyv4a83Dp/exb9x/Bqyl0JeB/q0Yp1juZCBq
         lddLvZs2GQ9c7JFK33gblg5uN7yYRMG84FEVG7/JzluBpwMPzV0FGwgJJWjkVhTPA0Ow
         zEF/51QmZNBUPsRkKSJysVjXePa9LJJ1MHTqquG6SRF9tIRxP10I8y62z9DSKEUGlj4v
         laZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ycEo8rq5UtZnwC6hQzTjMDJ45cvRJruq/s+I5GijYek=;
        b=QJBQY4bnxrBxnFFRrZBbS/WhHS+wSrkPYODBTz7T/cf5f9Q93vZPs67UT8J2WhSHhw
         32N9BCATQfb/ATXe6F563UBukPgBnX/f78uhlSMMrYgiZhDSvF6NX9zKyVAL71jZMhht
         PtmikRMwl5c2V8P/j+YtuGkMWoY+B1JsbTL1gVcWIAmxrazKFtG1HNgRrsf6DPxxBMA8
         e9DEir65A+F8Qf+XWYUhbgxpWLgLT5e8sc7/GnB5Q+Mgh0KQMaayRAUnP0nyAeu9QWI+
         N5w4lDzvofnvTyMaQQ+S1387lJxv7e6nLXLHBCf4nrSl5Rdvt8o9I8Sh28IS00cYPSQz
         OR6g==
X-Gm-Message-State: AJIora8drzEURSe1ynjYLgJF52WTBbF/nDZacZ7b4MQD0db5QaQ6ywyT
        rzHgNAvUgxJ0pWyZyG6fNsJgyQ==
X-Google-Smtp-Source: AGRyM1sBSifkUkW8ZgrEcen6BJPb/an/LJjySGt8ij20fV7nzG2bKuCb7RU2JZuXyxjk+6YJLjKcIw==
X-Received: by 2002:a17:90b:3e8a:b0:1f0:4157:daf8 with SMTP id rj10-20020a17090b3e8a00b001f04157daf8mr12089359pjb.222.1658420819607;
        Thu, 21 Jul 2022 09:26:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s32-20020a17090a2f2300b001efc839ac97sm3900801pjd.3.2022.07.21.09.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:26:57 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:26:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 05/12] KVM: X86/MMU: Clear unsync bit directly in
 __mmu_unsync_walk()
Message-ID: <Ytl+Tn8YBQR3KQFM@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-6-jiangshanlai@gmail.com>
 <YtcLiNskPb8z/2Qc@google.com>
 <CAJhGHyAoM+6cOh7XQUvavgJcUts53FW6BnjM_wqMD6fkoYoB3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JZkyYl2Tfi/vytoa"
Content-Disposition: inline
In-Reply-To: <CAJhGHyAoM+6cOh7XQUvavgJcUts53FW6BnjM_wqMD6fkoYoB3w@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JZkyYl2Tfi/vytoa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 21, 2022, Lai Jiangshan wrote:
> On Wed, Jul 20, 2022 at 3:52 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 22 +++++++++++++---------
> > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index f35fd5c59c38..2446ede0b7b9 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1794,19 +1794,23 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
> > >                               return -ENOSPC;
> > >
> > >                       ret = __mmu_unsync_walk(child, pvec);
> > > -                     if (!ret) {
> > > -                             clear_unsync_child_bit(sp, i);
> > > -                             continue;
> > > -                     } else if (ret > 0) {
> > > -                             nr_unsync_leaf += ret;
> > > -                     } else
> > > +                     if (ret < 0)
> > >                               return ret;
> > > -             } else if (child->unsync) {
> > > +                     nr_unsync_leaf += ret;
> > > +             }
> > > +
> > > +             /*
> > > +              * Clear unsync bit for @child directly if @child is fully
> > > +              * walked and all the unsync shadow pages descended from
> > > +              * @child (including itself) are added into @pvec, the caller
> > > +              * must sync or zap all the unsync shadow pages in @pvec.
> > > +              */
> > > +             clear_unsync_child_bit(sp, i);
> > > +             if (child->unsync) {
> > >                       nr_unsync_leaf++;
> > >                       if (mmu_pages_add(pvec, child, i))
> >
> > This ordering is wrong, no?  If the child itself is unsync and can't be added to
> > @pvec, i.e. fails here, then clearing its bit in unsync_child_bitmap is wrong.
> 
> mmu_pages_add() can always successfully add the page to @pvec and
> the caller needs to guarantee there is enough room to do so.
> 
> When it returns true, it means it will fail if you keep adding pages.

Oof, that's downright evil.  As prep work, can you fold in the attached patches
earlier in this series?  Then this patch can yield:

	for_each_set_bit(i, sp->unsync_child_bitmap, 512) {
		struct kvm_mmu_page *child;
		u64 ent = sp->spt[i];

		if (!is_shadow_present_pte(ent) || is_large_pte(ent))
			goto clear_unsync_child;

		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
		if (!child->unsync && !child->unsync_children)
			goto clear_unsync_child;

		if (mmu_is_page_vec_full(pvec))
			return -ENOSPC;

		mmu_pages_add(pvec, child, i);

		if (child->unsync_children) {
			ret = __mmu_unsync_walk(child, pvec);
			if (!ret)
				goto clear_unsync_child;
			else if (ret > 0)
				nr_unsync_leaf += ret;
			else
				return ret;
		} else {
			nr_unsync_leaf++;
		}

clear_unsync_child:
                /*
                 * Clear the unsync info, the child is either already sync
                 * (bitmap is stale) or is guaranteed to be zapped/synced by
                 * the caller before mmu_lock is released.  Note, the caller is
                 * required to zap/sync all entries in @pvec even if an error
                 * is returned!
                 */
                clear_unsync_child_bit(sp, i);
        }

--JZkyYl2Tfi/vytoa
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Separate-page-vec-is-full-from-adding-a-.patch"

From f2968d1afb08708c8292808b88aa915ec714e154 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Jul 2022 08:38:35 -0700
Subject: [PATCH 1/2] KVM: x86/mmu: Separate "page vec is full" from adding a
 page to the array

Move the check for a full "page vector" out of mmu_pages_add(), returning
true/false (effectively) looks a _lot_ like returning success/fail, which
is very misleading and will even be more misleading when a future patch
clears the unsync child bit upon a page being added to the vector (as
opposed to clearing the bit when the vector is processed by the caller).

Checking that the vector is full when adding a previous page is also
sub-optimal, e.g. KVM unnecessarily returns an error if the vector is
full but there are no more unsync pages to process.  Separating the check
from the "add" will allow fixing this quirk in a future patch.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52664c3caaab..ac60a52044ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1741,20 +1741,26 @@ struct kvm_mmu_pages {
 	unsigned int nr;
 };
 
-static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
+static bool mmu_is_page_vec_full(struct kvm_mmu_pages *pvec)
+{
+	return (pvec->nr == KVM_PAGE_ARRAY_NR);
+}
+
+static void mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 			 int idx)
 {
 	int i;
 
-	if (sp->unsync)
-		for (i=0; i < pvec->nr; i++)
+	if (sp->unsync) {
+		for (i = 0; i < pvec->nr; i++) {
 			if (pvec->page[i].sp == sp)
-				return 0;
+				return;
+		}
+	}
 
 	pvec->page[pvec->nr].sp = sp;
 	pvec->page[pvec->nr].idx = idx;
 	pvec->nr++;
-	return (pvec->nr == KVM_PAGE_ARRAY_NR);
 }
 
 static inline void clear_unsync_child_bit(struct kvm_mmu_page *sp, int idx)
@@ -1781,7 +1787,9 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
-			if (mmu_pages_add(pvec, child, i))
+			mmu_pages_add(pvec, child, i);
+
+			if (mmu_is_page_vec_full(pvec))
 				return -ENOSPC;
 
 			ret = __mmu_unsync_walk(child, pvec);
@@ -1794,7 +1802,9 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 				return ret;
 		} else if (child->unsync) {
 			nr_unsync_leaf++;
-			if (mmu_pages_add(pvec, child, i))
+			mmu_pages_add(pvec, child, i);
+
+			if (mmu_is_page_vec_full(pvec))
 				return -ENOSPC;
 		} else
 			clear_unsync_child_bit(sp, i);
-- 
2.37.1.359.gd136c6c3e2-goog


--JZkyYl2Tfi/vytoa
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-mmu-Check-for-full-page-vector-_before_-addi.patch"

From c8b0d983791ef783165bbf2230ebc41145bf052e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Jul 2022 08:49:37 -0700
Subject: [PATCH 2/2] KVM: x86/mmu: Check for full page vector _before_ adding
 a new page

Check for a full page vector before adding to the vector instead of after
adding to the vector array, i.e. bail if and only if the vector is full
_and_ a new page needs to be added.  Previously, KVM would still bail if
the vector was full but there were no more unsync pages to process.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ac60a52044ef..aca9a8e6c626 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1785,13 +1785,17 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 		}
 
 		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
+		if (!child->unsync && !child->unsync_children) {
+			clear_unsync_child_bit(sp, i);
+			continue;
+		}
+
+		if (mmu_is_page_vec_full(pvec))
+			return -ENOSPC;
+
+		mmu_pages_add(pvec, child, i);
 
 		if (child->unsync_children) {
-			mmu_pages_add(pvec, child, i);
-
-			if (mmu_is_page_vec_full(pvec))
-				return -ENOSPC;
-
 			ret = __mmu_unsync_walk(child, pvec);
 			if (!ret) {
 				clear_unsync_child_bit(sp, i);
@@ -1800,14 +1804,9 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 				nr_unsync_leaf += ret;
 			} else
 				return ret;
-		} else if (child->unsync) {
+		} else {
 			nr_unsync_leaf++;
-			mmu_pages_add(pvec, child, i);
-
-			if (mmu_is_page_vec_full(pvec))
-				return -ENOSPC;
-		} else
-			clear_unsync_child_bit(sp, i);
+		}
 	}
 
 	return nr_unsync_leaf;
-- 
2.37.1.359.gd136c6c3e2-goog


--JZkyYl2Tfi/vytoa--
