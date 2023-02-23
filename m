Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AFD6A10A0
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBWThi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjBWThH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:37:07 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEA059E50
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:37:06 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id v27so9414141vsa.7
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQKTd1mzsg/pi2cH97hh9NzvK6Pa7c5BewHqL7hHt/g=;
        b=WVsEQT6PPy34hEkjLZAQ1Q4pou3W21hsg4lj+Y9rlbMvhBUpDkgNnnyF1+9kH4FqAn
         qTUy0r7+8+kyQgV0L8sMPzZ963+pTxRWWEu1N2Swdx0P+IVuT1Tp0Lq2NHGTYZZWsKf+
         kCn6QOqveulzJ4bhrYdghA2c7pAlxBLF4NVOD75oVbMiMWgxJh7o5GeWiUK7cHiSmf6k
         xSBQ0cwHc0NlX3NKUWdMRAPRU2xunE6JyEtgyJBIjQIEp+ql/nZZCSVk/HxaAL8d0g6r
         sVBLv2wm5MgsxZft5qwDVO4U+vYcyEgqCLaG3xdWMDMWg1qZsODxo7jaPyxqfa+SdBtj
         FkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQKTd1mzsg/pi2cH97hh9NzvK6Pa7c5BewHqL7hHt/g=;
        b=q+vnrffHirYfpUVcR7xuawYOlg6yclC66ORQEzqrRu6OCIOvriDps/ocFT3jfLj7xu
         CuwbH4ChH492gMvH6ubKh5rVqHwNMUIAJMdqBvhxCoOmYgK7bo5UyvtW5l3iBK0hThUw
         IAEdIBaZ0J8m64OJJOKtrTkEx7rr+v2rlqyUwJHe2tCuukzMYPxa8zDKCtjrNwPzcp95
         7ZwhD5a/Y+sAmRsmUlQU9nBg5uYXtBrx7kGzyOIVNsaFGxyb8AP13fckvPwHvNGZF6JI
         rMC4CJWN9cFAQf8RFQxUyrL7lnEFrUHyMQkEx2uyqlbs45yELxQrrRgcp5ngerDs+UlR
         oVwg==
X-Gm-Message-State: AO0yUKXy7Ta+dCyE6BfllUtKGck2I22NkseAVXD3eo6bNHASm+47MEDv
        9JxM4l3YYm0Aj5CM/wDLsze+0GQ4eTyMm87aqQ2Y3g==
X-Google-Smtp-Source: AK7set8VQE1ZUs/DARz1uDJOtOd3y5APdCNGehQzmQqDg5Sq2V+KxGB+BR0gjpLPcgnhYR5yHSA4XUwuxFt6OaxzPsA=
X-Received: by 2002:a05:6102:5d9:b0:415:74b4:6067 with SMTP id
 v25-20020a05610205d900b0041574b46067mr658682vsf.6.1677181024793; Thu, 23 Feb
 2023 11:37:04 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
 <Y/e6Z+KIl6sYJoRg@google.com>
In-Reply-To: <Y/e6Z+KIl6sYJoRg@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 12:36:26 -0700
Message-ID: <CAOUHufbwcqx21T=zmvYpnX_Mnd2A0KkPORbtxnJEwKuUKVSPzA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Feb 23, 2023 at 12:11=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 23, 2023, Yu Zhao wrote:
> > On Thu, Feb 23, 2023 at 10:43=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Thu, Feb 16, 2023, Yu Zhao wrote:
> > > >   kswapd (MGLRU before)
> > > >     100.00%  balance_pgdat
> > > >       100.00%  shrink_node
> > > >         100.00%  shrink_one
> > > >           99.97%  try_to_shrink_lruvec
> > > >             99.06%  evict_folios
> > > >               97.41%  shrink_folio_list
> > > >                 31.33%  folio_referenced
> > > >                   31.06%  rmap_walk_file
> > > >                     30.89%  folio_referenced_one
> > > >                       20.83%  __mmu_notifier_clear_flush_young
> > > >                         20.54%  kvm_mmu_notifier_clear_flush_young
> > > >   =3D>                      19.34%  _raw_write_lock
> > > >
> > > >   kswapd (MGLRU after)
> > > >     100.00%  balance_pgdat
> > > >       100.00%  shrink_node
> > > >         100.00%  shrink_one
> > > >           99.97%  try_to_shrink_lruvec
> > > >             99.51%  evict_folios
> > > >               71.70%  shrink_folio_list
> > > >                 7.08%  folio_referenced
> > > >                   6.78%  rmap_walk_file
> > > >                     6.72%  folio_referenced_one
> > > >                       5.60%  lru_gen_look_around
> > > >   =3D>                    1.53%  __mmu_notifier_test_clear_young
> > >
> > > Do you happen to know how much of the improvement is due to batching,=
 and how
> > > much is due to using a walkless walk?
> >
> > No. I have three benchmarks running at the moment:
> > 1. Windows SQL server guest on x86 host,
> > 2. Apache Spark guest on arm64 host, and
> > 3. Memcached guest on ppc64 host.
> >
> > If you are really interested in that, I can reprioritize -- I need to
> > stop 1) and use that machine to get the number for you.
>
> After looking at the "MGLRU before" stack again, it's definitely worth ge=
tting
> those numbers.  The "before" isn't just taking mmu_lock, it's taking mmu_=
lock for
> write _and_ flushing remote TLBs on _every_ PTE.

Correct.

> I suspect the batching is a
> tiny percentage of the overall win (might be larger with RETPOLINE and fr=
iends),

Same here.

> and that the bulk of the improvement comes from avoiding the insanity of
> kvm_mmu_notifier_clear_flush_young().
>
> Speaking of which, what would it take to drop mmu_notifier_clear_flush_yo=
ung()
> entirely?

That's not my call :)

Adding Johannes.

> I.e. why can MGLRU tolerate stale information but !MGLRU cannot?

Good question. The native clear API doesn't flush:

  int ptep_clear_flush_young(struct vm_area_struct *vma,
                             unsigned long address, pte_t *ptep)
  {
          /*
           * On x86 CPUs, clearing the accessed bit without a TLB flush
           * doesn't cause data corruption. [ It could cause incorrect
           * page aging and the (mistaken) reclaim of hot pages, but the
           * chance of that should be relatively low. ]
           *
           * So as a performance optimization don't flush the TLB when
           * clearing the accessed bit, it will eventually be flushed by
           * a context switch or a VM operation anyway. [ In the rare
           * event of it not getting flushed for a long time the delay
           * shouldn't really matter because there's no real memory
           * pressure for swapout to react to. ]
           */
          return ptep_test_and_clear_young(vma, address, ptep);
  }

> If
> we simply deleted mmu_notifier_clear_flush_young() and used mmu_notifier_=
clear_young()
> instead, would anyone notice, let alone care?

I tend to agree.

> > > > @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *k=
obj, struct kobj_attribute *attr, c
> > > >       if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEA=
F_YOUNG))
> > > >               caps |=3D BIT(LRU_GEN_NONLEAF_YOUNG);
> > > >
> > > > +     if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_W=
ALK))
> > > > +             caps |=3D BIT(LRU_GEN_SPTE_WALK);
> > >
> > > As alluded to in patch 1, unless batching the walks even if KVM does =
_not_ support
> > > a lockless walk is somehow _worse_ than using the existing mmu_notifi=
er_clear_flush_young(),
> > > I think batching the calls should be conditional only on LRU_GEN_SPTE=
_WALK.  Or
> > > if we want to avoid batching when there are no mmu_notifier listeners=
, probe
> > > mmu_notifiers.  But don't call into KVM directly.
> >
> > I'm not sure I fully understand. Let's present the problem on the MM
> > side: assuming KVM supports lockless walks, batching can still be
> > worse (very unlikely), because GFNs can exhibit no memory locality at
> > all. So this option allows userspace to disable batching.
>
> I'm asking the opposite.  Is there a scenario where batching+lock is wors=
e than
> !batching+lock?  If not, then don't make batching depend on lockless walk=
s.

Yes, absolutely. batching+lock means we take/release mmu_lock for
every single PTE in the entire VA space -- each small batch contains
64 PTEs but the entire batch is the whole KVM.

> > I fully understand why you don't want MM to call into KVM directly. No
> > acceptable ways to set up a clear interface between MM and KVM other
> > than the MMU notifier?
>
> There are several options I can think of, but before we go spend time des=
igning
> the best API, I'd rather figure out if we care in the first place.

This is self serving -- MGLRU would be the only user in the near
future. But I never assume there will be no common ground, at least it
doesn't hurt to check.
