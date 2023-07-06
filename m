Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8F74955F
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 08:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjGFGKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 02:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjGFGKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 02:10:14 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8E51BF0
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 23:09:30 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b6f52e1c5cso3541731fa.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688623769; x=1691215769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnXCFXxOhLyq4lCoBGcKBYyF+4vukIbIpcnG55iOM5c=;
        b=Mb8mQeODhASdfKj+hHmylndEuVUiM/b1apoiBK04bLwBY4ajtvROBk8GMW7aZY/V0i
         W1Z+4ltSxdNVbESwxHXe2Nto30vwXM0F3QS91jS46XmSmaIFT07lHu3Fjhw9FLn8BQ2Y
         YvMVdpKSmiU70sMHWlcr+gv3eHgbBItZzvHwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688623769; x=1691215769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnXCFXxOhLyq4lCoBGcKBYyF+4vukIbIpcnG55iOM5c=;
        b=KLJKjzeF8coj6TnQBq7qt8mqEENKPs0RlpmgZVo03iwLdWQDzk+1oj8aSajw3YStWB
         hslrmNjtv/zPJB5B4Uw55xxSwI7iD92Ms0ppYSLzgftzKlxZ+0JSezh3ywdAf37/9984
         f+2Y17yW60gN0xIA9yEokY/YzWlQxLdevGdrUGLPujMDbYM9r2aghxERD3m5XWAF8Xld
         FS4rh/kLNkaA87nu355bDH1EJUweqoSoa/pTWM+x3zPEaEVjE8Phr/zPbbScoMGlBRVL
         yCG0MpRDc2/mGo42OzMmkSJ4+Ewox1H0JyiGgTAtIQ6ssyqtYm5CYsd+sPnhN5TItA3g
         gYtA==
X-Gm-Message-State: ABy/qLZszlzLG2TBEVMA8YkbCrajDuWIIQcvWPn7Y13lsswqgS1rl50w
        W8UpTLukvJBXInmuWzHSKZl4r6S5UBoIAnDrGko9AQ==
X-Google-Smtp-Source: APBJJlFQB6JQNb0dZ8JFG6eZYjbcpaXMlqxVbVKudZNWo1HIe+n1zgkzENdCl4UX7JHIJWm/W9286vJy7CQ1VvEz4L0=
X-Received: by 2002:a2e:9c46:0:b0:2b7:857:7cb5 with SMTP id
 t6-20020a2e9c46000000b002b708577cb5mr58264ljj.24.1688623768867; Wed, 05 Jul
 2023 23:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705115653.5whvhvcvmflqmcse@linux.intel.com>
In-Reply-To: <20230705115653.5whvhvcvmflqmcse@linux.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Thu, 6 Jul 2023 15:09:17 +0900
Message-ID: <CAD=HUj4E84MxZn8=U3wkBtx-VYdeD1mqOH9BUYpG=Y2POvY6sg@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 8:56=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:48PM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
> > callers to resolve a gfn when the associated pfn has a valid struct pag=
e
> > that isn't being actively refcounted (e.g. tail pages of non-compound
> > higher order pages). For a caller to safely omit FOLL_GET, all usages o=
f
> > the returned pfn must be guarded by a mmu notifier.
> >
> > This also adds a is_refcounted_page out parameter to kvm_follow_pfn tha=
t
> > is set when the returned pfn has an associated struct page with a valid
> > refcount. Callers that don't pass FOLL_GET should remember this value
> > and use it to avoid places like kvm_is_ad_tracked_page that assume a
> > non-zero refcount.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++
> >  virt/kvm/kvm_main.c      | 67 +++++++++++++++++++++-------------------
> >  virt/kvm/pfncache.c      |  2 +-
> >  3 files changed, 47 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ef2763c2b12e..a45308c7d2d9 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_=
memory_slot *slot, gfn_t gfn,
> >  void kvm_release_page_clean(struct page *page);
> >  void kvm_release_page_dirty(struct page *page);
> >
> > +void kvm_set_page_accessed(struct page *page);
> > +void kvm_set_page_dirty(struct page *page);
> > +
> >  struct kvm_follow_pfn {
> >       const struct kvm_memory_slot *slot;
> >       gfn_t gfn;
> > @@ -1164,10 +1167,17 @@ struct kvm_follow_pfn {
> >       bool atomic;
> >       /* Allow a read fault to create a writeable mapping. */
> >       bool allow_write_mapping;
> > +     /*
> > +      * Usage of the returned pfn will be guared by a mmu notifier. Mu=
st
> > +      * be true if FOLL_GET is not set.
> > +      */
> > +     bool guarded_by_mmu_notifier;
>
> And how? Any place to check the invalidate seq?

kvm_follow_pfn can't meaningfully validate the seq number, since the
mmu notifier locking is handled by the caller. This is more of a
sanity check that the API is being used properly, as proposed here
[1]. I did deviate from the proposal with a bool instead of some type
of integer, since the exact value of mmu_seq wouldn't be useful.

[1] https://lore.kernel.org/all/ZGvUsf7lMkrNDHuE@google.com/#t

-David
