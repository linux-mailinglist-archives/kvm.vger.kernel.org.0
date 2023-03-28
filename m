Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172986CCDFF
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjC1XZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjC1XZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:25:05 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9889F358C
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:25:03 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id d2so11819799vso.9
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680045902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1VR/BF0jQL+n/+bN9STmwrPdLJFsdBP342GdIuhsbw=;
        b=fsj3sD/1F95ToKmA30qh7ab3wBx6i4tUYzzz6HuBg7ELZhQ66vpLuYM10XGoHsPSIL
         h5UXh19q5u/XUurK/aMbI5C9kNny5sVosjeADh+av8W/djSf1B1X7goJKo38Ru9A6XVU
         w0nSIBVhOGu0P2Z2Jj5pS0LCO1dVJBnAZb9eZDA7EOPnJWU9iKXIlBU0dUtX35a22bfE
         bau7lgXpplftx76WVx9j32zqiCdgqSxJxnocB3g6G3vb1j1Yiik9CQzjvBuIVHsh3RFe
         tJrz8MmeOBNvdo7JfOuYiHB13zjxm3U0psI+spIKGmimN9fyj73O+A8D94/8LQ5BOWHn
         /8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680045902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1VR/BF0jQL+n/+bN9STmwrPdLJFsdBP342GdIuhsbw=;
        b=utwVBkvFdN3F8Gq+fQEbJcSjXqG1uITWEkE/JhRE7RUAeU9pW0Y20yBeyOzUNeM8xt
         xg8FtZNal/xVwRiHrDjDwRAjc8yRLYUaXjgwVDniC4z7t1/fdcItBWyUisEEJF8X+sNi
         vwtI0uV6+i4vg4kHGPMppbFWyZD8GDg+5huQHVVvjwSg6jqxZarxM38NIWNyfCOmxD/f
         A+DzJJXr9bH57P/9YIFpT8L8rXX4CPIuqqqKZjpaqTN/L3hjr6d8CVnOoYpKWJ0KaMVz
         Cr54Uu4sOBvAhjVHIx21r2r4RlJ/I8fteeRpEV/C15d1qRYsWHQ6hwUJKlo5bF9Y5yu3
         zg/g==
X-Gm-Message-State: AAQBX9eXfwtJgkBbmrgpdWTkPL4SxvkiQZoUIAkR8NL8gbXx0Mty4+eK
        fAeUUf1+XR0nE6qGV0PaX1jERSPNbCDFJ/0TWpLtaCeH3J2bUuOg8clrsA==
X-Google-Smtp-Source: AKy350b8nx51K1KTTclF52Rl6315MXjfFUIHs0S966i6F6S7B/cY/G0pcFLqO3A7VNlnZQurd/3QGxa4CHW/3WWlqpQ=
X-Received: by 2002:a67:c215:0:b0:425:eb13:b07d with SMTP id
 i21-20020a67c215000000b00425eb13b07dmr9173692vsj.4.1680045902618; Tue, 28 Mar
 2023 16:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-16-vipinsh@google.com>
 <ZBzS9WnZu9VtSVAt@google.com> <CAHVum0dOP6kR83Uuha=Ka7=enfEdrTTX7ZtR0nhXrkJDCo9dKQ@mail.gmail.com>
In-Reply-To: <CAHVum0dOP6kR83Uuha=Ka7=enfEdrTTX7ZtR0nhXrkJDCo9dKQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 28 Mar 2023 16:24:36 -0700
Message-ID: <CALzav=fgek=jgtaytz6ZEUgBzoHBKAgLk53n9w0LGZrJkMBg-A@mail.gmail.com>
Subject: Re: [Patch v4 15/18] KVM: mmu: Add NUMA node support in struct kvm_mmu_memory_cache{}
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 10:51=E2=80=AFAM Vipin Sharma <vipinsh@google.com> =
wrote:
>
> On Thu, Mar 23, 2023 at 3:30=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Mon, Mar 06, 2023 at 02:41:24PM -0800, Vipin Sharma wrote:
> > > Add NUMA node id variable in struct kvm_mmu_memory_cache{}. This
> > > variable denotes preferable NUMA node from which memory will be
> > > allocated under this memory cache.
> > >
> > > Set this variable to NUMA_NO_NODE if there is no preferred node.
> > >
> > > MIPS doesn't do any sort of initializatino of struct
> > > kvm_mmu_memory_cache{}. Keep things similar in MIPS by setting gfp_ze=
ro
> > > to 0 as INIT_KVM_MMU_MEMORY_CACHE() will initialize it to __GFP_ZERO.
> > >
> > > "node" cannot be left as 0, as 0 is a valid NUMA node value.
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  arch/mips/kvm/mips.c      | 3 +++
> > >  include/linux/kvm_types.h | 3 +++
> > >  2 files changed, 6 insertions(+)
> > >
> > > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > > index 36c8991b5d39..5ec5ce919918 100644
> > > --- a/arch/mips/kvm/mips.c
> > > +++ b/arch/mips/kvm/mips.c
> > > @@ -294,6 +294,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >                    HRTIMER_MODE_REL);
> > >       vcpu->arch.comparecount_timer.function =3D kvm_mips_comparecoun=
t_wakeup;
> > >
> > > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> > > +     vcpu->arch.mmu_page_cache.gfp_zero =3D 0;
> >
> > Oh MIPS is here. Why isn't MIPS covered in the previous commits?
>
> Because this is the patch where MIPS get impacted. MIPS doesn't
> initialize gfp_zero, so there was no need to change the code in MIPS.
> However, with the addition of "node" in kvm_mmu_memory_cache{} in this
> patch, we need initialization in MIPS to (1) Set  node to NUMA_NO_NODE
> as 0 is now a valid value, and (2) INIT_KVM_MMU_MEMORY_CACHE() will
> set gfp_zero to __GFP_ZERO which is different than existing code in
> MIPS to keep it 0.
>
> I asked MIPS maintainers in the previous version to see if GFP_ZERO
> can be added but didn't get any response.
> https://lore.kernel.org/lkml/CAHVum0c+17Z-RbGAFdU-xmRejDjDQ+MKOfN4XaObh2S=
wgWAjLg@mail.gmail.com/

I see. IMO it's more logical to convert the MIPS cache to
INIT_KVM_MMU_MEMORY_CACHE() in patch 13, along with all the other
users of struct kvm_mmu_memory_cache. Then in patch 14, add the line
to set gfp_zero to 0 for MIPS to preserve the existing behavior. That
produces a very simple chain of changes:

Patch 13: Convert all users of struct kvm_mmu_memory_cache to INIT()
Patch 14: Invert the default value of kvm_mmu_memory_cache.gfp_zero
Patch 15: Add node to kvm_mmu_memory_cache


>
> > > +
> > >       /*
> > >        * Allocate space for host mode exception handlers that handle
> > >        * guest mode exits
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index 5da7953532ce..b2a405c8e629 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -97,10 +97,13 @@ struct kvm_mmu_memory_cache {
> > >       struct kmem_cache *kmem_cache;
> > >       int capacity;
> > >       void **objects;
> > > +     /* Preferred NUMA node of memory allocation. */
> > > +     int node;
> > >  };
> > >
> > >  #define KVM_MMU_MEMORY_CACHE_INIT() {        \
> > >       .gfp_zero =3D __GFP_ZERO,         \
> > > +     .node =3D NUMA_NO_NODE,           \
> > >  }
> > >
> > >  #define KVM_MMU_MEMORY_CACHE(_name) \
> > > --
> > > 2.40.0.rc0.216.gc4246ad0f0-goog
> > >
