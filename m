Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BCF6CC9A7
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjC1RvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjC1RvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:51:23 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027BED318
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:51:23 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id cf7so16176259ybb.5
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680025882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZEzn+JGPoNcSFatTaZ9WitjfP3WMlM4dNjm+OppZbc=;
        b=OieQ4SZGkBW2/SExsYhGqU15A2mAcAmInmxt6J8/s9KALKTXn3usj7khAa5q8IGB88
         livMxTSdESBbWIi68HBRK4qTJdXwzuSgc1EUZfrc1pY4UfeAnm89Apod0gd5zKUcqmJx
         QWHp2ip40vAGACQXlqAHRLFDgB46IkF59/ss1sGPTmwybGoOGdVEffZ7B0FouiI1r5Z/
         005hr3jtvW9kcAVb1IQELVFg0nrxn662Xwlib9/8UYQuLq84fv4f2LkKqTb/26tFRIu/
         wuM0DYoCmgXjyXTX3JVdSZiBrK6FikUDsd3WlVvQShI1JQDKTj9mwY0MgOcUE5hewJ2p
         NJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680025882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MZEzn+JGPoNcSFatTaZ9WitjfP3WMlM4dNjm+OppZbc=;
        b=GSHfcOl/xIq07RcHNovnYw4jq/cW40jln/yroOmV20gtI1dCvdfbRIkq0eA6iobcdB
         B9d78UFbwDYiwEse1R0XFJaAyTmS81UVSSW86BAQUKN9+W8Tpd9OKioqVXn1cQFJgNLd
         Va6kF9LPwq9bpRnYebipzEO6KCsk9aCb1OyzMdL4leSYZkSSb+sh4dBlhRCGB8Z/Jo5c
         S/TEif9/6kIN5YpZp8HeF2NjXnI2DoFpCGGMaZabsOuK/K8yjQ4VLGPZieS3eIOrGuw9
         fDUlKPGOYP8gcR8Xz0njrM9QoWItAZ+ATri9D/h6Sb6hDwgZ/SlHAA8PaxoKMNWyZ+Ou
         U2RA==
X-Gm-Message-State: AAQBX9dGrBfTRUADzALSOrZ/xP6GezvjG1Y4egV4S/L8kGSq4TZMm6Ow
        XxyNgjujkjS7sw7BwJCW+IFA0gxUHLuq0Jzd7cDmkoOh+08SQUgtM4vMWQ==
X-Google-Smtp-Source: AKy350ZlRCZtMn3KRRJ84JI9QcNIcFQlWUn9DnQIDpcUWgynuefHJcEjRdInBN7kiMLaFcmihSmPTbxdABwFaFoHD+w=
X-Received: by 2002:a25:483:0:b0:a0d:8150:becf with SMTP id
 125-20020a250483000000b00a0d8150becfmr9966334ybe.13.1680025881991; Tue, 28
 Mar 2023 10:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-16-vipinsh@google.com>
 <ZBzS9WnZu9VtSVAt@google.com>
In-Reply-To: <ZBzS9WnZu9VtSVAt@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 28 Mar 2023 10:50:46 -0700
Message-ID: <CAHVum0dOP6kR83Uuha=Ka7=enfEdrTTX7ZtR0nhXrkJDCo9dKQ@mail.gmail.com>
Subject: Re: [Patch v4 15/18] KVM: mmu: Add NUMA node support in struct kvm_mmu_memory_cache{}
To:     David Matlack <dmatlack@google.com>
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

On Thu, Mar 23, 2023 at 3:30=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Mar 06, 2023 at 02:41:24PM -0800, Vipin Sharma wrote:
> > Add NUMA node id variable in struct kvm_mmu_memory_cache{}. This
> > variable denotes preferable NUMA node from which memory will be
> > allocated under this memory cache.
> >
> > Set this variable to NUMA_NO_NODE if there is no preferred node.
> >
> > MIPS doesn't do any sort of initializatino of struct
> > kvm_mmu_memory_cache{}. Keep things similar in MIPS by setting gfp_zero
> > to 0 as INIT_KVM_MMU_MEMORY_CACHE() will initialize it to __GFP_ZERO.
> >
> > "node" cannot be left as 0, as 0 is a valid NUMA node value.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/mips/kvm/mips.c      | 3 +++
> >  include/linux/kvm_types.h | 3 +++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index 36c8991b5d39..5ec5ce919918 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -294,6 +294,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >                    HRTIMER_MODE_REL);
> >       vcpu->arch.comparecount_timer.function =3D kvm_mips_comparecount_=
wakeup;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> > +     vcpu->arch.mmu_page_cache.gfp_zero =3D 0;
>
> Oh MIPS is here. Why isn't MIPS covered in the previous commits?
>

Because this is the patch where MIPS get impacted. MIPS doesn't
initialize gfp_zero, so there was no need to change the code in MIPS.
However, with the addition of "node" in kvm_mmu_memory_cache{} in this
patch, we need initialization in MIPS to (1) Set  node to NUMA_NO_NODE
as 0 is now a valid value, and (2) INIT_KVM_MMU_MEMORY_CACHE() will
set gfp_zero to __GFP_ZERO which is different than existing code in
MIPS to keep it 0.

I asked MIPS maintainers in the previous version to see if GFP_ZERO
can be added but didn't get any response.
https://lore.kernel.org/lkml/CAHVum0c+17Z-RbGAFdU-xmRejDjDQ+MKOfN4XaObh2Swg=
WAjLg@mail.gmail.com/

> > +
> >       /*
> >        * Allocate space for host mode exception handlers that handle
> >        * guest mode exits
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 5da7953532ce..b2a405c8e629 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -97,10 +97,13 @@ struct kvm_mmu_memory_cache {
> >       struct kmem_cache *kmem_cache;
> >       int capacity;
> >       void **objects;
> > +     /* Preferred NUMA node of memory allocation. */
> > +     int node;
> >  };
> >
> >  #define KVM_MMU_MEMORY_CACHE_INIT() {        \
> >       .gfp_zero =3D __GFP_ZERO,         \
> > +     .node =3D NUMA_NO_NODE,           \
> >  }
> >
> >  #define KVM_MMU_MEMORY_CACHE(_name) \
> > --
> > 2.40.0.rc0.216.gc4246ad0f0-goog
> >
