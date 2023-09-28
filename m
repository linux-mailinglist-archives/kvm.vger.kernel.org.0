Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77FA7B254A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjI1Sb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjI1Sbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:31:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA932BF
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:31:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f4f2a9ef0so227283407b3.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695925913; x=1696530713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/8BgKxt0pmpt8+0WGKUzTJnRK7udqyBpxUOUSK21ys=;
        b=o20930i+RwRtL68BBLJtpsotwQ2PZanntrJ3mjCBY5betS3AucdmMZPHk13K/IhZ6R
         iKRCOoZNZe9kH285ZB1gCgu8cmqflIeTPnApeBk3UmHdnW+e4JHfZN5+kdu93tCt9k4T
         ZXDMItK/a+gWSaDgO4bg4fOj05aH4pzF45L6D4pGlpbfdRfDw4lZez9at/aMPDQopipJ
         QgZjtZ7T4MP6QfYHJERYDOMPwMdo7+iPPxUcPPBjtQ5gwlhnWEUlj/8Wpln74Szw4DlV
         B121neJ7UJqVaKR77SqCwgTr/CdkBH3FW+HrrsE9fAS22/LLWeFxwDj1CuSMbYlcJxKq
         H3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695925913; x=1696530713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/8BgKxt0pmpt8+0WGKUzTJnRK7udqyBpxUOUSK21ys=;
        b=Lcx8tYqd75hkdFhEpmo6/Sosyh8a0YBFrjchZkQFCMC3dM+B1jJGpUlX59FbYIiWsw
         wmIl9bzeSB7Ifyg7qUWOjsruuRIGzFv5CbAylYQw7f8maucgC4dU19e2TdNQf5uYAo+h
         oSy6tcor1SVG/V7Sx3qKbFIm8mFzPE3MCGj5usWYkto92aOzYcyy7CggfEH/m+Mr1lcR
         MssvLi3d1nPKkLa++KFIjgAdHzuA8VYkxaQeOMNebppdeVQxzJyfLB5/pTkskhvNQGfo
         RxrkRf2T3OP2xC/XIgKQu5wD8du+JSuu1J0DNi96fZ9DdcUpQBWpBYojNty3vuduLPft
         5HUw==
X-Gm-Message-State: AOJu0YwVQrqQo3haGesPNAMKQ8yDk2UAeFe0bIsBGHJjtQ7EJaSp8SNY
        9KJswi2PxejSZ34XaE4htGfGGOGL/XY=
X-Google-Smtp-Source: AGHT+IGfVEgupQd2XwnlnnpG5qLgubn7xydVSelYD5RWBn46P+oeWmA6LKQrcSiItH4E8llJ5yjqZ7x6btE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3412:b0:579:f832:74b with SMTP id
 fn18-20020a05690c341200b00579f832074bmr32603ywb.10.1695925913160; Thu, 28 Sep
 2023 11:31:53 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:31:51 -0700
In-Reply-To: <20230922224210.6klwbphnsk5j2wft@amd.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com> <20230921203331.3746712-7-seanjc@google.com>
 <20230922224210.6klwbphnsk5j2wft@amd.com>
Message-ID: <ZRXGl44g8oD-FtNy@google.com>
Subject: Re: [PATCH 06/13] KVM: Disallow hugepages for incompatible gmem
 bindings, but let 'em succeed
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Michael Roth wrote:
> On Thu, Sep 21, 2023 at 01:33:23PM -0700, Sean Christopherson wrote:
> > +	/*
> > +	 * For simplicity, allow mapping a hugepage if and only if the entire
> > +	 * binding is compatible, i.e. don't bother supporting mapping interior
> > +	 * sub-ranges with hugepages (unless userspace comes up with a *really*
> > +	 * strong use case for needing hugepages within unaligned bindings).
> > +	 */
> > +	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> > +	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
> > +		*max_order = 0;
> 
> Thanks for working this in. Unfortunately on x86 the bulk of guest memory
> ends up getting slotted directly above legacy regions at GFN 0x100, 

Can you provide an example?  I'm struggling to understand what the layout actually
is.  I don't think it changes the story for the kernel, but it sounds like there
might be room for optimization in QEMU?  Or more likely, I just don't understand
what you're saying :-)

> so the associated slot still ends failing these alignment checks if it tries
> to match the gmemfd offsets up with the shared RAM/memfd offsets.
> 
> I tried to work around it in userspace by padding the gmemfd offset of
> each slot to the next 2M boundary, but that also requires dynamically
> growing the gmemfd inode to account for the padding of each new slot and
> it gets ugly enough that I'm not sure it's any better than your
> suggested alternative of using a unique gmemfd for each slot.
> 
> But what if we relax the check to simply make sure that any large folio
> must is fully-contained by the range of the slot is bound to? It *seems*
> like that would still avoid stuff like mapping 2M pages in the NPT (or
> setting up 2M RMP table entries) that aren't fully contained by a slot
> while still allowing the bulk of guest memory to get mapped as 2M. Are
> there other edge cases to consider?
> 
> The following seems to work for a basic 16GB SNP guest at least:
> 
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index 9109bf5751ee..e73128d4ebc2 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -618,6 +618,7 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                        gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prep)
>  {
>         pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> +       pgoff_t huge_index;
>         struct kvm_gmem *gmem;
>         struct folio *folio;
>         struct page *page;
> @@ -662,9 +663,12 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>          * sub-ranges with hugepages (unless userspace comes up with a *really*
>          * strong use case for needing hugepages within unaligned bindings).
>          */
> -       if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> -           !IS_ALIGNED(slot->npages, 1ull << *max_order))
> +       huge_index = round_down(index, 1ull << *max_order);

Why not use ALIGN() here?  The size is obviously a power-of-2.  Or is my math
even worse than I thought?

> +       if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
> +           huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages) {

Argh, I keep forgetting that the MMU is responsible for handling misaligned gfns.
Yeah, this looks right.

Can you post this as a proper patch, on top of my fixes?  And without the pr_debug().
That'll be the easiest for me to apply+squash when the time comes.

Thanks much!
