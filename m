Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793F974B628
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 20:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjGGSNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 14:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjGGSNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 14:13:41 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924262689
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 11:13:38 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-47e5cf4e347so830242e0c.3
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688753617; x=1691345617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wl3EtNl/p1Cktt9fRTEmIICzF7/RfPgCrlONVu2JLF8=;
        b=eI1zn4t8Fh6JGMDJI5Bq+7k9dpO6L9rVaMjrtcmWYqrKPrO1lGvoMbJkHOfcaiJRuu
         8ZcS1BjOpz6qzvA+9pcDi8DgVD2VZEcgbkRP7s4oBej2iD5vPASUI6/bfougCWgKO43P
         rEPDKe/FvfuX94farPxg9s98aZydJ/J/L6rlBXiN6AXcJcnvLREy6w9Y/LEKYv8mqiy2
         d9vVawDgwU9Nt8Ojzzr91B1hTG43ayZTAGEk6ATiupXwyhplsjkV6fc+Bxqn+kZNBHM7
         IwoW71Fs7kXMoLYCT0sEKaMNCLSOXxg6zIhSzg6qiaUmVfJGk7LSUV1Kosj4ds6WvrT9
         K4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688753617; x=1691345617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl3EtNl/p1Cktt9fRTEmIICzF7/RfPgCrlONVu2JLF8=;
        b=WISa2Nvy8XO+diYxnJDk1wT4e27kkjH5K/G4RzBpx/pf0ULbLDgp1SNanmzKMsCJyR
         zMRACEGKJQsqSTjpicgGL94kuDkEPp+nM0Sg0sfCNJyC70tzffEck3U92NRVRu1IN8kU
         7tb4Dz1VC+BpjG9mOh+eDAX24xuXYgaXrSdw/IOkbOzPB5czMMgYZLhK1SQDbVqEAV7a
         b53+eooFnt71+6oIjYoVqrz8u9dE0TNS4cQjVZUQ4rZCVd1Iun3PvY0LWMeiLFssPcof
         BwrGE5m8YczVoEH/oDzqwff1zxjpm67KpXSIGOHv59RE0flZSnMt/vPIN1lZXzL2UndN
         /MeQ==
X-Gm-Message-State: ABy/qLYYM2NbnIJQmBiI1u6UO0WA2KSkn+JuHKmGvDmCqgDCIPUwuUuf
        mlkqTh2bhKysMsZzDbniaCHtLqLjlDU+I5ucekZwrw==
X-Google-Smtp-Source: APBJJlEeTRK3Fec77w837oSHwaixg5smdIYjkVaVUq4TvKapitjrP1VnWLoUGMQU/BcoXrFfefLWUw1J8FwYAXlfSXU=
X-Received: by 2002:a1f:d2c5:0:b0:471:5110:49e8 with SMTP id
 j188-20020a1fd2c5000000b00471511049e8mr4471582vkg.4.1688753617480; Fri, 07
 Jul 2023 11:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com>
In-Reply-To: <ZIovIBVLIM69E5Bo@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 7 Jul 2023 11:13:01 -0700
Message-ID: <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +static inline bool kvm_slot_nowait_on_fault(
> > +     const struct kvm_memory_slot *slot)
>
> Just when I was starting to think that we had beat all of the Google3 out=
 of you :-)

I was trying to stay under the line limit here :( But you've commented
on that elsewhere. Fixed (hopefully :)

> And predicate helpers in KVM typically have "is" or "has" in the name, so=
 that it's
> clear the helper queries, versus e.g. sets the flag or something.

Done

> KVM is anything but consistent, but if the helper is likely to be called =
without
> a known good memslot, it probably makes sense to have the helper check fo=
r NULL,
> e.g.

Done: I was doing the null checks in other ways in the arch-specific
code, but yeah it's easier to centralize that here.

> However, do we actually need to force vendor code to query nowait?  At a =
glance,
> the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot(=
) are
> in flows that play nice with nowait or that don't support it at all.  So =
I *think*
> we can do this?
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index be06b09e9104..78024318286d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_m=
emory_slot *slot)
>         return slot->flags & KVM_MEM_READONLY;
>  }
>
> +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slo=
t)
> +{
> +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> +}
> +
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slo=
t, gfn_t gfn,
>                                        gfn_t *nr_pages, bool write)
>  {
> @@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_me=
mory_slot *slot, gfn_t gfn,
>                 writable =3D NULL;
>         }
>
> +       if (async && memslot_is_nowait_on_fault(slot)) {
> +               *async =3D false;
> +               async =3D NULL;
> +       }
> +
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault=
,
>                           writable);
>  }

Hmm, well not having to modify the vendor code would be nice... but
I'll have to look more at __gfn_to_pfn_memslot()'s callers (and
probably send more questions your way :). Hopefully it works out more
like what you suggest.
