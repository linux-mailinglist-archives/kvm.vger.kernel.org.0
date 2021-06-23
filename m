Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3823B22E7
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWWHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 18:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhFWWHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 18:07:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED60EC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 15:04:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso4346639pjx.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 15:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3T0h8VymAOWBOELTAhK8ofxW4KiGW2dPBpu/ihdjpQY=;
        b=esgNcxuILMFfkfwQC4UZueEjq87g2ye/8bxyEai81YSSkXq65nwlLdvt7roqP9VTDe
         4csJD7nFf0/wUE2a2QqKw5gStew+GZ6JJa55DtOSkEmk/rijwxH+gUQal6JqAJgxZ2aD
         QFOJfzT+AM4pMDfIyGtKpbDGXTVGJcYc+Dh632/5yMwnV39/Q/IGmt0oujIoqsVqO7ln
         4Pper/+X8UFe+a5/EFIlbZKptZmp1edPOp3L1qHtv+hvz4c7ScNlKOWm/1xtIsSEXdDy
         R27D9iSLxdCGef9Y+5HPZ+zYGasw7tPuyigTMffoyUDId5OcORRqibDeqqRrhgUqMRNP
         DDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3T0h8VymAOWBOELTAhK8ofxW4KiGW2dPBpu/ihdjpQY=;
        b=CSCeodRwT83/+Z9JjwjJYxBZORHrIB0+Dff4LVZjaA74HJieivrcNDlIpx4ezKAseH
         JBJbHCbodEEaAkuwpRIjH8S6l97yBuloBnM8pvMLyUWB4PYCgoP2j+58Z8udKpg93OAF
         tUMEbZfMrLDOYa/bIVmTexXKRLDt4SPgxAS67swmYbMPf+9izfix68oChNa/brpge+mS
         8TUP1ZF6AwZOrV2+FcYmsF2ZLcWLMpcjJBKdVVAPPS8A5eXVlc6cOgiF/8pDzUKg8SfM
         YyaSjtRjC8/5ABa24eS5RI1yMbshp4/QbFJvPhBs7VvRlKmQsNZV3TP0AURTCrq5FLj1
         CvMQ==
X-Gm-Message-State: AOAM531mOvhfywgB7angNtvI36M9zAiyuiOvUcYJfZW9COlH8kKWwI2W
        VgXPnyNmCzIhUjNxV6hjpQRmQw==
X-Google-Smtp-Source: ABdhPJyfj8xDC+MhQx9aBhaPxlRQZLmTX9RdN3IIvKXBeQkMfBPqu5YtBp6nc8gikeiiDk6GK4sVFQ==
X-Received: by 2002:a17:90a:ee85:: with SMTP id i5mr11936817pjz.156.1624485884182;
        Wed, 23 Jun 2021 15:04:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u20sm727885pfn.189.2021.06.23.15.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 15:04:43 -0700 (PDT)
Date:   Wed, 23 Jun 2021 22:04:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
Message-ID: <YNOv9wsr3yo2T55O@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
 <f2dcfe12-e562-754e-2756-1414e8e2775f@redhat.com>
 <YNNOeIWqNoZ3j8o+@google.com>
 <f13fcf5b-f6bc-fb95-6f69-ea524ae446f5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13fcf5b-f6bc-fb95-6f69-ea524ae446f5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 23/06/21 17:08, Sean Christopherson wrote:
> > Because the shadow page's level is incorporated into its role, if the level of
> > the new page is >4k, the branch at (1) will be taken for all 4k shadow pages.
> > 
> > Maybe something like this for a comment?
> 
> Good, integrated.
> 
> Though I also wonder why breaking out of the loop early is okay.  Initially I thought
> that zapping only matters if there's no existing page with the desired role,
> because otherwise the unsync page would have been zapped already by an earlier
> kvm_get_mmu_page, but what if the page was synced at the time of kvm_get_mmu_page
> and then both were unsynced?

That can't happen, because the new >4k SP will mark the page for write-tracking
via account_shadowed(), and any attempt to unsync the page will fail and
write-protect the entry.

It would be possible have both an unsync and a sync SP, e.g. unsync, then INVLPG
only one of the pages.  But as you pointed out, creating the first >4k SP would
be guaranteed to wipe out the unsync SP because no match should exist.

> It may be easier to just split the loop to avoid that additional confusion,
> something like:
> 
>         /*
>          * If the guest is creating an upper-level page, zap unsync pages
>          * for the same gfn, because the gfn will be write protected and
>          * future syncs of those unsync pages could happen with an incompatible
>          * context.

I don't think the part about "future syncs ... with an incompatible context" is
correct.  The unsync walks, i.e. the sync() flows, are done with the current root
and it should be impossible to reach a SP with an invalid context when walking
the child SPs.

I also can't find anything that would out break if the SP were left unsync, i.e.
I haven't found any code that assumes a write-protected SP can't be unsync.
E.g. mmu_try_to_unsync_pages() will force write-protection due to write tracking
even if unsync is left true.  Maybe there was a rule/assumption at some point
that has since gone away?  That's why my comment hedged and just said "don't
do it" without explaining why :-)

All that said, I'm definitely not opposed to simplying/clarifying the code and
ensuring all unsync SPs are zapped in this case.

>	   * While it's possible the guest is using recursive page
>          * tables, in all likelihood the guest has stopped using the unsync
>          * page and is installing a completely unrelated page.
>          */
>         if (level > PG_LEVEL_4K) {

I believe this can be "if (!direct && level > PG_LEVEL_4K)", because the direct
case won't write protect/track anything.

>                 for_each_valid_sp(vcpu->kvm, sp, sp_list)

This can technically be "for_each_gfn_indirect_valid_sp", though I'm not sure it
saves much, if anything.

>                         if (sp->gfn == gfn && sp->role.word != role.word && sp->unsync)
>                                 kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
>                                                          &invalid_list);
>         }
> 
> Paolo
> 
