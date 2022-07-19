Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3916F57A600
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 20:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiGSSD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 14:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiGSSD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 14:03:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB02652E40;
        Tue, 19 Jul 2022 11:03:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a15so15543402pjs.0;
        Tue, 19 Jul 2022 11:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c2Hf5x/4EgdstY9MF0D9wi/WtpWeS2CRpEW46fk8Oag=;
        b=SgCis5K1045Nou8JEOF4ez6iSkNGXLk2zyxwYhEsoXHVwMnhGoq8CuDdW+RcOd06gq
         FTgUeRlv+4q45TvOMEsFgsujzJXvJc6HuKtYeh2IbvzpsJc7m1qSkd8XCVyPTCMx/yro
         ZbHnYIlXg2HoHYJUaitskDWrMAOgdS0wNrjAqexymhj5ySF7VQiiI4OXoJjRtCKNQYGi
         RYvWa1MikV7wV9ezysWYbWpbCi/u3MPfO7AxQLN1kUbu6c2dVItGyQxJI6pK6jtv755k
         Ob1grwpJvW1rP/J2ZPAAsc9DzpiO0jZ5lKeqlxkdcbaegZQIC3SG/T/k0BaDUZztG/zH
         GVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c2Hf5x/4EgdstY9MF0D9wi/WtpWeS2CRpEW46fk8Oag=;
        b=ONpIh55tyGS1RHtCFdynI0v12idTt8AWSGICPL2c+E21I4TNDEdOTZ5i7yeyvMHFLl
         ++YRvx9KdZtIrS9gy5+zA0YIKi70KD9mcOuRa3V3XyBqIDsNdvtOlNwRWPr+3XajGhu1
         emm3N6nysB8jFQrZRt2f+r1AZtI6AJQovUuJCcD5xteEeEPPKglp/MfqKRfDo7ab9f5p
         FwYptnWxXlulknznea2YJOgcLN/cFZfN7oCn2Y12sElpsOm7WxOUW0btTZBqz0nYvhN7
         AKwvUlB2qWviW8OLxxglfd6EdG5tzUYs0XG01f1YYpfeO+k3M5z5JaA5eTU44V0sf6dx
         bFYA==
X-Gm-Message-State: AJIora9cqD05G34VbfSPbFZkoMdngyzKAwW840Zi6UdhBTgnuUbbsakO
        mbxmvSo9+0k7l9hS/dzpGwc=
X-Google-Smtp-Source: AGRyM1sghCUk5769Iyutf93F09AydcjiryPepFBTa6iisqzsDJNFLtnGTwK2l7M2bA4L5oD46dw4Fg==
X-Received: by 2002:a17:903:124e:b0:16b:e975:232f with SMTP id u14-20020a170903124e00b0016be975232fmr33476548plh.165.1658253806215;
        Tue, 19 Jul 2022 11:03:26 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a640f00b001ec92575e83sm11797433pjj.4.2022.07.19.11.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:03:25 -0700 (PDT)
Date:   Tue, 19 Jul 2022 11:03:23 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 049/102] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Message-ID: <20220719180323.GA1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <8d2266b3e10156ec10daa5ba9cd1bd2adce887a7.1656366338.git.isaku.yamahata@intel.com>
 <20220712025806.qqir22wbfpcg3bth@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712025806.qqir22wbfpcg3bth@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 10:58:06AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:41PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Some KVM MMU operations (dirty page logging, page migration, aging page)
> > aren't supported for private GFNs (yet) with the first generation of TDX.
> > Silently return on unsupported TDX KVM MMU operations.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 74 +++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c         |  3 ++
> >  2 files changed, 72 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 12f75e60a254..fef6246086a8 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -387,6 +387,8 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
> >
> >  	if ((!is_writable_pte(old_spte) || pfn_changed) &&
> >  	    is_writable_pte(new_spte)) {
> > +		/* For memory slot operations, use GFN without aliasing */
> > +		gfn = gfn & ~kvm_gfn_shared_mask(kvm);
> 
> This should be part of enabling, please consider to squash it into patch 46.

Yes, merged into it.


> >  		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
> >  		mark_page_dirty_in_slot(kvm, slot, gfn);
> >  	}
> > @@ -1398,7 +1400,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> >
> >  static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  						   struct kvm_gfn_range *range,
> > -						   tdp_handler_t handler)
> > +						   tdp_handler_t handler,
> > +						   bool only_shared)
> >  {
> >  	struct kvm_mmu_page *root;
> >  	struct tdp_iter iter;
> > @@ -1409,9 +1412,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  	 * into this helper allow blocking; it'd be dead, wasteful code.
> >  	 */
> >  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> > +		gfn_t start;
> > +		gfn_t end;
> > +
> > +		if (only_shared && is_private_sp(root))
> > +			continue;
> > +
> >  		rcu_read_lock();
> >
> > -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> > +		/*
> > +		 * For TDX shared mapping, set GFN shared bit to the range,
> > +		 * so the handler() doesn't need to set it, to avoid duplicated
> > +		 * code in multiple handler()s.
> > +		 */
> > +		start = kvm_gfn_for_root(kvm, root, range->start);
> > +		end = kvm_gfn_for_root(kvm, root, range->end);
> > +
> > +		tdp_root_for_each_leaf_pte(iter, root, start, end)
> >  			ret |= handler(kvm, &iter, range);
> >
> >  		rcu_read_unlock();
> > @@ -1455,7 +1472,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
> >
> >  bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> > -	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
> > +	/*
> > +	 * First TDX generation doesn't support clearing A bit for private
> > +	 * mapping, since there's no secure EPT API to support it.  However
> > +	 * it's a legitimate request for TDX guest.
> > +	 */
> > +	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range, true);
> >  }
> >
> >  static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
> > @@ -1466,7 +1488,7 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
> >
> >  bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> > -	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
> > +	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, false);
> 
> The "false" here means we will do young testing for even private
> pages, but we don't have actual A bit state in iter->old_spte for
> them, so may here should be "true" ?

Yes, nice catch.


> >  }
> >
> >  static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
> > @@ -1511,8 +1533,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  	 * No need to handle the remote TLB flush under RCU protection, the
> >  	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> >  	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> > +	 *
> > +	 * .change_pte() callback should not happen for private page, because
> > +	 * for now TDX private pages are pinned during VM's life time.
> >  	 */
> 
> Worth to catch this by WARN_ON() ? Depends on you.

It call back can be called for shared pages.  Here there is no easy way which
GPA (private or shared) caused it.  i.e. no easy condition for WARN_ON().

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
