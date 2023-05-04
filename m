Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1A76F774F
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjEDUow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjEDUoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:44:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850501892D
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:42:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aae2223aaeso4694125ad.2
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 13:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683232877; x=1685824877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjkGj18Tl/NdfVrPbyDKfRjswecBEB5bOxxm+RgEgOA=;
        b=dwM0BsNHiZq4qN5FFSbCSGE++/6He9ZJ4z5viQWckrJ8WPqSLQ8Km8bPGMKJj+0R9p
         I0J3YecLSBxvD02tDtPU982IC8x9/a1YZb8X+0iRfNF3fiRMfxvvQUULR3hN79FAwnI/
         cAU4ZxDrnR4eK3dQFmer77OC9xbMVjvG7DPL3SgAqYCnzopDZ4sbT7kparWlvac/jrpe
         aywPdxXO07pbaZv/2mlj9qGJ7Q9r9pz4gOZuesNuCy0kVdWw40YrzzQQQEiQGUkTdoOc
         KxNZS7OaaTUFp1rlYp342z2i6irzzOSijP7gKUSkwl8xUGPyY5XEPsn+Su+NBS8T47K+
         kY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683232877; x=1685824877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjkGj18Tl/NdfVrPbyDKfRjswecBEB5bOxxm+RgEgOA=;
        b=WlOK8XubzIWTr2TKlJRRZQxkpcptSUoAJaMzuXhuX9d1EBBnsfwUSV/+3196np3JXq
         yf1O5gL00/BtoeNsR0Yzg7GPMyR3eQ2znSFDDmfdafInNPDF6qYwd2ejYf1wczZSiRcY
         YFBMFlB3zI2auMRW8yUKD18JUdZMWj0E/rdpaFfJ5rWIgw1fViOzd0ZSv/DZ8QGtJU5U
         Rsij9XI78xB3sQ0VxlRASpP9SeX7Yuok4QR+JKazxUMf3UhWqXjJEJpV7YS7k7tcVOkh
         0ExXA/JWIkAbIcRaRz5NBzH/hoCEcOkz12iKO5OSrj+S/ISsrkZb/c2EBpjkzUU/cDln
         JNAw==
X-Gm-Message-State: AC+VfDwEEZsyX1LKj4fSlLxTnbO798Fqltl8HMG2c0coA0tsT2u9Akz0
        2resgpKW/7YNLR6MCsz05F5wITpYc+Y=
X-Google-Smtp-Source: ACHHUZ4qDwy5vZenwdizmjrkDEh6vha7LNA0vevnvbKr11qb7WL0aDbrG3uXQqhgmVCsKenkgsLqX/R9iCE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1247:b0:1a6:c110:900a with SMTP id
 u7-20020a170903124700b001a6c110900amr1614861plh.3.1683232877690; Thu, 04 May
 2023 13:41:17 -0700 (PDT)
Date:   Thu, 4 May 2023 13:41:16 -0700
In-Reply-To: <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-6-seanjc@google.com>
 <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com>
Message-ID: <ZFQYbHTYgG4HJ+ac@google.com>
Subject: Re: [PATCH v2 05/27] drm/i915/gvt: Verify VFIO-pinned page is THP
 when shadowing 2M gtt entry
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
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

On Fri, Mar 17, 2023, Yan Zhao wrote:
> On Fri, Mar 10, 2023 at 04:22:36PM -0800, Sean Christopherson wrote:
> > When shadowing a GTT entry with a 2M page, explicitly verify that the
> > first page pinned by VFIO is a transparent hugepage instead of assuming
> > that page observed by is_2MB_gtt_possible() is the same page pinned by
> > vfio_pin_pages().  E.g. if userspace is doing something funky with the
> > guest's memslots, or if the page is demoted between is_2MB_gtt_possible()
> > and vfio_pin_pages().
> > 
> > This is more of a performance optimization than a bug fix as the check
> > for contiguous struct pages should guard against incorrect mapping (even
> > though assuming struct pages are virtually contiguous is wrong).
> > 
> > The real motivation for explicitly checking for a transparent hugepage
> > after pinning is that it will reduce the risk of introducing a bug in a
> > future fix for a page refcount leak (KVMGT doesn't put the reference
> > acquired by gfn_to_pfn()), and eventually will allow KVMGT to stop using
> > KVM's gfn_to_pfn() altogether.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 8ae7039b3683..90997cc385b4 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -159,11 +159,25 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
> >  			goto err;
> >  		}
> >  
> > -		if (npage == 0)
> > -			base_page = cur_page;
> > +		if (npage == 0) {
> > +			/*
> > +			 * Bail immediately to avoid unnecessary pinning when
> > +			 * trying to shadow a 2M page and the host page isn't
> > +			 * a transparent hugepage.
> > +			 *
> > +			 * TODO: support other type hugepages, e.g. HugeTLB.
> > +			 */
> > +			if (size == I915_GTT_PAGE_SIZE_2M &&
> > +			    !PageTransHuge(cur_page))
> Maybe the checking of PageTransHuge(cur_page) and bailing out is not necessary.
> If a page is not transparent huge, but there are 512 contigous 4K
> pages, I think it's still good to map them in IOMMU in 2M.
> See vfio_pin_map_dma() who does similar things.

I agree that bailing isn't strictly necessary, and processing "blindly" should
Just Work for HugeTLB and other hugepage types.  I was going to argue that it
would be safer to add this and then drop it at the end, but I think that's a
specious argument.  If not checking the page type is unsafe, then the existing
code is buggy, and this changelog literally states that the check for contiguous
pages guards against any such problems.

I do think there's a (very, very theoretical) issue though.  For "CONFIG_SPARSEMEM=y
&& CONFIG_SPARSEMEM_VMEMMAP=n", struct pages aren't virtually contiguous with respect
to their pfns, i.e. it's possible (again, very theoretically) that two struct pages
could be virtually contiguous but physically discontiguous.  I suspect I'm being
ridiculously paranoid, but for the efficient cases where pages are guaranteed to
be contiguous, the extra page_to_pfn() checks should be optimized away by the
compiler, i.e. there's no meaningful downside to the paranoia.

TL;DR: My plan is to drop this patch and instead harden the continuity check.
