Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A1577653E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjHIQmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 12:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjHIQl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 12:41:58 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA351982
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 09:41:57 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-40a47e8e38dso309761cf.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 09:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691599317; x=1692204117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPf4XGOX6Yz3caGFLI4HNiFX/4urner6v/ltX/ESS/0=;
        b=M8NqHm95x4nGnCdrVnscaqRXS4zv1xJk+mKi6qhzpoV0xAgedW8xKK1WrktthW+/qX
         b79Rjw1HWdoTj0bfrzxyYngD13WhEXYtTDNUTB4Nwp3syn4yn8vOXHVKklDeZcJZpc9o
         GDICgnZbUUQ4VwPvxkozg6ZrzrsWy820TbFiNBjvXSnVlLga3PusimdxiUHWSrjmgq9M
         YMKKBcxudeH5NygCy+Ei5czOibqi8SOG3nDIHx+h0cIT0Z9F1Ff0QOjnl3TwU7bKPVG3
         fESF+gvCoCtyd47weuYbH5uFlwg9LfCAVKAGmtq8i8np6ERRNhFQ4wt4KpNnlYCunDKT
         NTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691599317; x=1692204117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPf4XGOX6Yz3caGFLI4HNiFX/4urner6v/ltX/ESS/0=;
        b=Sauxc8zSKHHhlmZMyxSOunKdqIepLg+fM8o6yYTOFMD9lBRvRlW+fxr4ggdYs06vFX
         pa5wv+u9N6cmh30EnNU5Ak+QzeU+4FHkj6Xd+i7Eu9JvwGzkMjrZPHV15Ekb4TdDtGaS
         XPuHeZ+G+xJrD2Gdi7GosdOJ34RoFZmofcw7IBFhh9yrboNxv5Jjp29PgSH90xPMJpA+
         vRAhAPldE8Ed8dKSeR+eLMWIxL2eY7JIOD1eiHc/zdLqFBveRbdlV2FCnLIHBvxYEw2D
         QNjuGhYT+SrRBoVH9lWKptKWStZaoJL5ZJoHEe0WDZjSnwbODjyDuZ3iAuumvwwNAdBQ
         HLxQ==
X-Gm-Message-State: AOJu0Ywa5otsvfDri7G0K20KuioHhZosImRKvkDu+8ysOKb9Zftmg39g
        2EdOgPmO/pyxHzbbijPvHyvWk7SRKWrMHV1wzJMTQg==
X-Google-Smtp-Source: AGHT+IEasKjYjirTCPg/lhza9bQPF4rYp5ejx4/QKjY7XilhifZ9KFaFlpeH95SrDC1XV+HGwPF+ASFIZPAlqAB/AME=
X-Received: by 2002:ac8:5dc9:0:b0:3f5:2006:50f1 with SMTP id
 e9-20020ac85dc9000000b003f5200650f1mr133814qtx.12.1691599316808; Wed, 09 Aug
 2023 09:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-6-rananta@google.com>
 <15975205-6161-d54b-fe40-805a16b0cb27@redhat.com>
In-Reply-To: <15975205-6161-d54b-fe40-805a16b0cb27@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 9 Aug 2023 09:41:44 -0700
Message-ID: <CAJHc60xk1ZAw-44FG7CDbAGPMUSnAmZ3LxMPGcQ0RPBcenHrig@mail.gmail.com>
Subject: Re: [PATCH v8 05/14] KVM: Allow range-based TLB invalidation from
 common code
To:     Gavin Shan <gshan@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
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

On Tue, Aug 8, 2023 at 11:09=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote=
:
>
> On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> > From: David Matlack <dmatlack@google.com>
> >
> > Make kvm_flush_remote_tlbs_range() visible in common code and create a
> > default implementation that just invalidates the whole TLB.
> >
> > This paves the way for several future features/cleanups:
> >
> >   - Introduction of range-based TLBI on ARM.
> >   - Eliminating kvm_arch_flush_remote_tlbs_memslot()
> >   - Moving the KVM/x86 TDP MMU to common code.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  2 ++
> >   arch/x86/kvm/mmu/mmu.c          |  8 ++++----
> >   arch/x86/kvm/mmu/mmu_internal.h |  3 ---
> >   include/linux/kvm_host.h        | 12 ++++++++++++
> >   virt/kvm/kvm_main.c             | 13 +++++++++++++
> >   5 files changed, 31 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index a2d3cfc2eb75c..b547d17c58f63 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1804,6 +1804,8 @@ static inline int kvm_arch_flush_remote_tlbs(stru=
ct kvm *kvm)
> >               return -ENOTSUPP;
> >   }
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +
> >   #define kvm_arch_pmi_in_guest(vcpu) \
> >       ((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce2..6adbe6c870982 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -278,16 +278,16 @@ static inline bool kvm_available_flush_remote_tlb=
s_range(void)
> >       return kvm_x86_ops.flush_remote_tlbs_range;
> >   }
> >
> > -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > -                              gfn_t nr_pages)
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > +                                   u64 nr_pages)
> >   {
> >       int ret =3D -EOPNOTSUPP;
> >
> >       if (kvm_x86_ops.flush_remote_tlbs_range)
> >               ret =3D static_call(kvm_x86_flush_remote_tlbs_range)(kvm,=
 start_gfn,
> >                                                                  nr_pag=
es);
> > -     if (ret)
> > -             kvm_flush_remote_tlbs(kvm);
> > +
> > +     return ret;
> >   }
> >
>
> I guess @start_gfn can be renamed to @gfn, to be consistent with its decl=
aration
> in include/linux/kvm_host.h and struct kvm_x86_ops::flush_remote_tlbs_ran=
ge()
>
Oh, yes. I'll consider this change for v9 (if there are enough changes
and we plan to push one).

Thank you.
Raghavendra

> >   static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)=
;
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_int=
ernal.h
> > index d39af5639ce97..86cb83bb34804 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm=
,
> >                                   struct kvm_memory_slot *slot, u64 gfn=
,
> >                                   int min_level);
> >
> > -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > -                              gfn_t nr_pages);
> > -
> >   /* Flush the given page (huge or not) of guest memory. */
> >   static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t g=
fn, int level)
> >   {
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ade5d4500c2ce..f0be5d9c37dd1 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
> >   void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mod=
e);
> >
> >   void kvm_flush_remote_tlbs(struct kvm *kvm);
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pa=
ges);
> >
> >   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> >   int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int m=
in);
> > @@ -1488,6 +1489,17 @@ static inline int kvm_arch_flush_remote_tlbs(str=
uct kvm *kvm)
> >   int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >   #endif
> >
> > +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> > +                                                 gfn_t gfn, u64 nr_pag=
es)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#else
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> > +                                   gfn_t gfn, u64 nr_pages);
> > +#endif
> > +
> >   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> >   void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
> >   void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d6b0507861550..26e91000f579d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> >
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pa=
ges)
> > +{
> > +     if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, nr_pages))
> > +             return;
> > +
> > +     /*
> > +      * Fall back to a flushing entire TLBs if the architecture range-=
based
> > +      * TLB invalidation is unsupported or can't be performed for what=
ever
> > +      * reason.
> > +      */
> > +     kvm_flush_remote_tlbs(kvm);
> > +}
> > +
> >   static void kvm_flush_shadow_all(struct kvm *kvm)
> >   {
> >       kvm_arch_flush_shadow_all(kvm);
>
> Thanks,
> Gavin
>
