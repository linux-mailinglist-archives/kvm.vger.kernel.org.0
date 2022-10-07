Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE85F7418
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 08:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJGGEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 02:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGGD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 02:03:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46848A024D
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 23:03:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p70so2915793iod.13
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 23:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/TxaYjGBe0JV2lzNrA+E/wu8QG+vfOtXqWin55f54II=;
        b=jTrxfIcHwJyXnCjYLnmh5lTZvamd6Pw1/joQ20nsXL8p8bWPgskpRoTBgmfzGWYoG6
         gXsAq6FM4O4L9pna/vxTUWXHaRmDyfYBakJRbf0snQIzgy5aoRL6W/BxKAD+mo0RtiSA
         UFsjpvdEzDD0v3tVaS8//1TiJmv+mdORLYVyuLy8ZRTDqjObdUv3bDE4IKcQZLWN4fyb
         pcA98TI4Y8ZZ9naYc4I/JoAvJxxAPdP8Vx24/GMWj0WNw9tQwhIlE6fQG2HL7AX/2WGu
         kTXS5d2f0pi5zZbtzbfI6onBoAvYSOsgpLqC7lgiWg6GBGgoQeUtSYBgNAMaQ2m8+Nvh
         n1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/TxaYjGBe0JV2lzNrA+E/wu8QG+vfOtXqWin55f54II=;
        b=4N1mpuupWhhy9thV8d77V2BuUrMTl7MebZm7NkThYmLIGtj+P12Un0FuIF5LddL0eH
         W5upEA8cysCNbcToPixJLWJK3QZP0PgZucESTiDFJx4Euox8bFwc0i2UD3FHmv9NFTVn
         ux+ybg733B3lIinpvuPYLw0pI2N9DxQK/qgvAJ86w1b56+2EEWJA+f9MrO24rxlIMTWe
         UtT45MkkWA04YqY6l4D3ufsYYnSi1I1B/rCkDRvX0SfC4BS5+NtSYERZbgWhucTfdBOT
         BWj/u1pf/Klskvd9z4r6vPOYMWhqdSvKYiOYuzOVS3Kfzl/i0yEjxifVBFKPYvS67iFl
         P62w==
X-Gm-Message-State: ACrzQf3cv1tG8ioq8jT7N8/BCqKBAH75waIgh5SFn9gvwI7GQPavP3VU
        at+AJxcicIeWPoqd+APM41KDrrK/C12zACB769hxfw==
X-Google-Smtp-Source: AMsMyM5bRB6AJU3wxS2VlmYcrUeCzCUr4ujVs3dQ+R4dArnHgOUyNntGgANz5UMKc1Eym8RxkR7dUKHPABpMvqcN+z4=
X-Received: by 2002:a05:6638:4184:b0:35a:3eb4:f932 with SMTP id
 az4-20020a056638418400b0035a3eb4f932mr1726487jab.216.1665122637553; Thu, 06
 Oct 2022 23:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com> <YzJFvWPb1syXcVQm@google.com>
 <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com> <Yz99nF+d6D+37efE@google.com>
In-Reply-To: <Yz99nF+d6D+37efE@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 6 Oct 2022 23:03:46 -0700
Message-ID: <CAL715WL4L=9vhhU3TvY7TOe3HZ73weWFNiaP2RyBtzN-kZ4EoQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 6:15 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 06, 2022, Kalra, Ashish wrote:
> > For the MMU invalidation notifiers we are going to make two changes
> > currently:
> >
> > 1). Use clflush/clflushopt instead of wbinvd_on_all_cpus() for range <= 2MB.
>
> IMO, this isn't worth pursuing, to the point where I might object to this code
> being added upstream.  Avoiding WBINVD for the mmu_notifiers doesn't prevent a
> malicious userspace from using SEV-induced WBINVD to effectively DoS the host,
> e.g. userspace can simply ADD+DELETE memslots, or mprotect() chunks > 2mb.
>

I think using clflush/clflushopt is a tactical workaround for SNP VMs.
As mentioned earlier by Ashish:

"For SNP guests we don't need to invoke the MMU invalidation notifiers
and the cache flush should be done at the point of RMP ownership change
instead of mmu_notifier, which will be when the unregister_enc_region
ioctl is called, but as we don't trust the userspace (which can bypass
this ioctl), therefore we continue to use the MMU invalidation
notifiers."

So if that is true: SNP VMs also have to use mmu_notifiers for
splitting the PMDs, then I think using clflush/clflushopt might be the
only workaround that I know of.

> Using clfushopt also effectively puts a requirement on mm/ that the notifiers
> be invoked _before_ PTEs are modified in the primary MMU, otherwise KVM may not
> be able to resolve the VA=>PFN, or even worse, resolve the wrong PFN.

I don't understand this. Isn't it always true that MM should fire
mmu_notifiers before modifying PTEs in host MMU? This should be a
strict rule as in my knowledge, no?

>
> And no sane VMM should be modifying userspace mappings that cover SEV guest memory
> at any reasonable rate.
>
> In other words, switching to CLFUSHOPT for SEV+SEV-ES VMs is effectively a
> band-aid for the NUMA balancing issue.

That's not true. KSM might also use the same mechanism. For NUMA
balancing and KSM, there seems to be a pattern: blindly flushing
mmu_notifier first, then try to do the actual work.

I have a limited knowledge on MM, but from my observations, it looks
like the property of a page being "PINNED" is very unreliable (or
expensive), i.e., anyone can jump in and pin the page. So it is hard
to see whether a page is truly "PINNED" or maybe just someone is
"working" on it without holding the lock. Holding the refcount of a
struct page requires a spinlock. I suspect that might be the reason
why NUMA balancing and KSM is just aggressively firing mmu_notifiers
first. I don't know if there is other stuff in MM following the same
pattern.

Concretely, my deep worry is the mmu_notifier in try_to_unmap_one(). I
cannot enumerate all of the callers. But if there is someone who calls
into this, it might be a disaster level (4K) performance lock. Hope we
can prove that won't happen.
