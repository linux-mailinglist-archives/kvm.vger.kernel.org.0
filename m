Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5A16A0F2B
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjBWSJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjBWSJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 13:09:19 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054AB113EE
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:09:04 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id s1so539110vsk.5
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFS2s1TR/3Kjk49puEHZLo8Qp1XbI3IEgMXOzJt184k=;
        b=T5IJAdz1LLwq9Wpe/lYsePig5wU3ht7E3XBfh+hgfH9QST0GfyYIgBlwgpI5O4mani
         rZIblgtTc6rbIYvr29cW1lsZGQDsNNjbLJmM9HYUEKikey9Qql1PRkJPgYlaRmFu5e2N
         LGj2FMYFaOEkWL8mGYvTQ3Vn7z0ODfq96Tsg1YXvbb5WVEEyoz5Sfs0JGBUwPeZzM21h
         27AMPaY+3E8diGs3Qq+0UvjwD32cBcn5tHRKFEFz4XJWCYmEnw744gDyE01cZp3Q9MRJ
         C7l0NSF4td3tovqrUj6grQE1k5M5JoTxHepZybKKiQDz154BjPBgwzQNflKkDkbRn1Fi
         zNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFS2s1TR/3Kjk49puEHZLo8Qp1XbI3IEgMXOzJt184k=;
        b=AH7N2JHDFNy7FLCytm7uOeDmjxiMF55Ap1fon4H7+wi9kO9kXGgnyCrw6XFqIPXr3z
         7acyXbMAXATevzhba13CPkch059excRGMVZ+tOqwyytrDZU2IEFPRTBoXKmf6dxXCF5D
         1yWBVRjN6jMXPa4SU0NbnEuDH7fM43XjPM5QGSJU6mmxek+1QI9+KS1sU/ZpSzY6NER+
         GE4cUjF2gIlOHoTmTsaYz+9ZeWs4eOAoG23Flvy/mCk7S/ZY2Axx2N9PR3jatY0l1bfX
         KGzE8GzZYfxweIXJofSwg8A7BB6xG190+xusd92U6yihpYykcwgpP0ojB5O0iyL1D2u1
         T3IQ==
X-Gm-Message-State: AO0yUKV+7UYVBwjGGkxTFrLrp+z0+eU3zKM624+RpKXeUFCU7Y9rLWiN
        pjekOy2NBmpKc8l1TzBZFbdRcqh5v6/zcvv3DerOeA==
X-Google-Smtp-Source: AK7set/BLzsOKlrQCPCfz1/Srjggdbaz1bD3yeHmhdVN17JBRgqFpgtS/JiELfEpEe2qyTgQFGrUqdU1JBFociC1vOk=
X-Received: by 2002:a05:6102:22c2:b0:414:d29b:497c with SMTP id
 a2-20020a05610222c200b00414d29b497cmr479716vsh.6.1677175740528; Thu, 23 Feb
 2023 10:09:00 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com>
In-Reply-To: <Y/elw7CTvVWt0Js6@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 11:08:21 -0700
Message-ID: <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 10:43=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 16, 2023, Yu Zhao wrote:
> > An existing selftest can quickly demonstrate the effectiveness of this
> > patch. On a generic workstation equipped with 128 CPUs and 256GB DRAM:
>
> Not my area of maintenance, but a non-existent changelog (for all intents=
 and
> purposes) for a change of this size and complexity is not acceptable.

Will fix.

> >   $ sudo max_guest_memory_test -c 64 -m 250 -s 250
> >
> >   MGLRU      run2
> >   ---------------
> >   Before    ~600s
> >   After      ~50s
> >   Off       ~250s
> >
> >   kswapd (MGLRU before)
> >     100.00%  balance_pgdat
> >       100.00%  shrink_node
> >         100.00%  shrink_one
> >           99.97%  try_to_shrink_lruvec
> >             99.06%  evict_folios
> >               97.41%  shrink_folio_list
> >                 31.33%  folio_referenced
> >                   31.06%  rmap_walk_file
> >                     30.89%  folio_referenced_one
> >                       20.83%  __mmu_notifier_clear_flush_young
> >                         20.54%  kvm_mmu_notifier_clear_flush_young
> >   =3D>                      19.34%  _raw_write_lock
> >
> >   kswapd (MGLRU after)
> >     100.00%  balance_pgdat
> >       100.00%  shrink_node
> >         100.00%  shrink_one
> >           99.97%  try_to_shrink_lruvec
> >             99.51%  evict_folios
> >               71.70%  shrink_folio_list
> >                 7.08%  folio_referenced
> >                   6.78%  rmap_walk_file
> >                     6.72%  folio_referenced_one
> >                       5.60%  lru_gen_look_around
> >   =3D>                    1.53%  __mmu_notifier_test_clear_young
>
> Do you happen to know how much of the improvement is due to batching, and=
 how
> much is due to using a walkless walk?

No. I have three benchmarks running at the moment:
1. Windows SQL server guest on x86 host,
2. Apache Spark guest on arm64 host, and
3. Memcached guest on ppc64 host.

If you are really interested in that, I can reprioritize -- I need to
stop 1) and use that machine to get the number for you.

> > @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *kobj,=
 struct kobj_attribute *attr, c
> >       if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YO=
UNG))
> >               caps |=3D BIT(LRU_GEN_NONLEAF_YOUNG);
> >
> > +     if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_WALK)=
)
> > +             caps |=3D BIT(LRU_GEN_SPTE_WALK);
>
> As alluded to in patch 1, unless batching the walks even if KVM does _not=
_ support
> a lockless walk is somehow _worse_ than using the existing mmu_notifier_c=
lear_flush_young(),
> I think batching the calls should be conditional only on LRU_GEN_SPTE_WAL=
K.  Or
> if we want to avoid batching when there are no mmu_notifier listeners, pr=
obe
> mmu_notifiers.  But don't call into KVM directly.

I'm not sure I fully understand. Let's present the problem on the MM
side: assuming KVM supports lockless walks, batching can still be
worse (very unlikely), because GFNs can exhibit no memory locality at
all. So this option allows userspace to disable batching.

I fully understand why you don't want MM to call into KVM directly. No
acceptable ways to set up a clear interface between MM and KVM other
than the MMU notifier?
