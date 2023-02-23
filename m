Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950F36A0ED4
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 18:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjBWRk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 12:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBWRk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 12:40:57 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D04851FB3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 09:40:56 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id o2so3248894vss.8
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 09:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo7AgQ2bct21yLgbxRinWk51c7Sq7xFh6y+K3L6/tTM=;
        b=GBvZr3FRKM3NOesy8gVSZUY02Sq7aNLAUfDffqGDvKf740Ehqv8nBE7Oi8FsVIN6J1
         JkZFMoh+qCPEAzymwVHG0z1bBMx/KYg6SymF2QTZuOLraOywk3TLiLhpYUErfPSbomdU
         FdELqyo5w45/teVQSzUk24vH1+jYHCr88FiP2s8cZmTnhZ/p9c9I1VeiW+nF0kurnbWN
         zU2trwEFNYfVM5n6sxlFHrJwWriTlH1Yux1MJGSccWSU+BwuGOcqC/WBw7sP08hDnexG
         HURlUENH3H2vj5o3TSRbImMuccAeHy0C5gzNj/u3KE2SP/RtkjYxI2vBWBhCxO8K3UcO
         df/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fo7AgQ2bct21yLgbxRinWk51c7Sq7xFh6y+K3L6/tTM=;
        b=bNf9k/sBo3NUxrAO/hpBCWPPIS5VmgfBpRC8F57AZC9SCdWJmsEbRfr4I8MY65UQ38
         jpzZ/Lk4NbxZGSbEVGY2MQ4h17RsufQQviBA6YOguPlWfET/16E1j0OCzWmTd7m7GPiR
         gINPzsm41W3X+gGD4ljYeKJ3cIUIWgLtLMVhqyk5P/Gap+BEE7b6PqSyjjyH0XxgIPex
         M/x3EP/YnAa3AqdxsMYn9v7RfEFvQ+l7/7q6HDMZmwCaa3eLY3H9DpNm10Nd0kLx23hR
         L/dVpQFP72YQ/2kvRyLuP13BxslKyZbZz/OwcEKKJ04hZC+IV6scPd30qUIu11kE6R4r
         LzSg==
X-Gm-Message-State: AO0yUKXDVfy7DWTAnHuoq/7QciNIVM7yUEXlfWbi653VpfYhdK0fN/lK
        zbBEXUVq9TVzT8PrwgRIcvxHS164F2VmM6iZVz2a0Q==
X-Google-Smtp-Source: AK7set9wJbC1t128b6r/YElZqMz+AmeZGkkjsbu1lRieG6NYjdy/fQfX1OM7M72E6+9T9qCprQHwdxazlikgHRzNMDs=
X-Received: by 2002:a05:6102:108f:b0:41e:d8b5:ee40 with SMTP id
 s15-20020a056102108f00b0041ed8b5ee40mr899877vsr.26.1677174055279; Thu, 23 Feb
 2023 09:40:55 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-2-yuzhao@google.com>
 <Y/ee1s3XPGa62SFV@google.com>
In-Reply-To: <Y/ee1s3XPGa62SFV@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 10:40:19 -0700
Message-ID: <CAOUHufZ0Ep4_Edo4OoeUVpVK4uFJF6_yVL=xSrQM8an_Vw4VKw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm/kvm: add mmu_notifier_test_clear_young()
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 10:14=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 16, 2023, Yu Zhao wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9c60384b5ae0..1b465df4a93d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -875,6 +875,63 @@ static int kvm_mmu_notifier_clear_young(struct mmu=
_notifier *mn,
> >       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn)=
;
> >  }
> >
> > +static bool kvm_test_clear_young(struct kvm *kvm, unsigned long start,
> > +                              unsigned long end, unsigned long *bitmap=
)
> > +{
> > +     int i;
> > +     int key;
> > +     bool success =3D true;
> > +
> > +     trace_kvm_age_hva(start, end);
> > +
> > +     key =3D srcu_read_lock(&kvm->srcu);
> > +
> > +     for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > +             struct interval_tree_node *node;
> > +             struct kvm_memslots *slots =3D __kvm_memslots(kvm, i);
> > +
> > +             kvm_for_each_memslot_in_hva_range(node, slots, start, end=
 - 1) {
> > +                     gfn_t lsb_gfn;
> > +                     unsigned long hva_start, hva_end;
> > +                     struct kvm_gfn_range range =3D {
> > +                             .slot =3D container_of(node, struct kvm_m=
emory_slot,
> > +                                                  hva_node[slots->node=
_idx]),
> > +                     };
> > +
> > +                     hva_start =3D max(start, range.slot->userspace_ad=
dr);
> > +                     hva_end =3D min(end - 1, range.slot->userspace_ad=
dr +
> > +                                            range.slot->npages * PAGE_=
SIZE - 1);
> > +
> > +                     range.start =3D hva_to_gfn_memslot(hva_start, ran=
ge.slot);
> > +                     range.end =3D hva_to_gfn_memslot(hva_end, range.s=
lot) + 1;
> > +
> > +                     if (WARN_ON_ONCE(range.end <=3D range.start))
> > +                             continue;
>
> Extend __kvm_handle_hva_range() instead of copy-pasting.  At a very quick=
 glance,
> I believe all that is needed is (minus sanity checks):

Yes, will do.

I do need to add one more parameter to kvm_gfn_range, because that's
what the current kvm_arch_test_clear_young() needs, assuming that
function is acceptable.

Also, just a side note, from MM's POV, the following in
__kvm_handle_hva_range() seems to forget to handle end =3D=3D 0, if that's
possible?

  hva_end =3D min(range->end, slot->userspace_addr + (slot->npages <<
PAGE_SHIFT));

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331..3296ae2cf6fa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -544,6 +544,7 @@ struct kvm_hva_range {
>         hva_handler_t handler;
>         on_lock_fn_t on_lock;
>         on_unlock_fn_t on_unlock;
> +       bool lockless;
>         bool flush_on_ret;
>         bool may_block;
>  };
> @@ -616,7 +617,7 @@ static __always_inline int __kvm_handle_hva_range(str=
uct kvm *kvm,
>                         gfn_range.end =3D hva_to_gfn_memslot(hva_end + PA=
GE_SIZE - 1, slot);
>                         gfn_range.slot =3D slot;
>
> -                       if (!locked) {
> +                       if (!range->lockless && !locked) {
>                                 locked =3D true;
>                                 KVM_MMU_LOCK(kvm);
>                                 if (!IS_KVM_NULL_FN(range->on_lock))
>
> > +
> > +                     /* see the comments on the generic kvm_arch_has_t=
est_clear_young() */
> > +                     lsb_gfn =3D hva_to_gfn_memslot(end - 1, range.slo=
t);
> > +
> > +                     success =3D kvm_arch_test_clear_young(kvm, &range=
, lsb_gfn, bitmap);
> > +                     if (!success)
> > +                             break;
> > +             }
> > +     }
> > +
> > +     srcu_read_unlock(&kvm->srcu, key);
> > +
> > +     return success;
> > +}
