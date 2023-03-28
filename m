Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956296CC8FC
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjC1RRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjC1RRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:17:18 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AA8B44C
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:17:17 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id n125so16006954ybg.7
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680023836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQnHU1M/MPboqyRKv1gTRYT/ZtZXQpcppYft9PMstwU=;
        b=humGhO7LERdMZlcUrHW8NTZcBX3+1mOSPyZahqWh+rFkHIvm/HPQXiX7KJiXUDIlh3
         gfZCfDW7E7wHUB4lqAJAhmQ5bYrMdFG3rD4AacVBv1L6Kan0KhIKuOgQ7FYcuHThUK8j
         iERdJa2qgc9UapONyWfdVzQfA8Q52B5ky/o1sA2gZeBX9Mu81tFd6z7P6He0fvdr+MHV
         d6s7rpXaGeBoEPbnfj9S/awZ3qYvtyXsmeQs2nfUBWgAVeXGH18zo/EJ9PjhsrD/fRVU
         i1odoyFYu2HThc76oPSGUvkeDk82LmXexJh66vS7XuR5oXzkHGpDB1FoaHOx9UcxCx7m
         4ziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680023836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQnHU1M/MPboqyRKv1gTRYT/ZtZXQpcppYft9PMstwU=;
        b=tVtxyPboxqeHQdx0AJv87dI1l5mt0AwQN558NBVzrEU9uNdCctNzC8cIhf3Z6+n8Nl
         JtI3HmAC8JZWyXTE2jlxB6n1FDB6/GDPen2Sqt0pn8iXGQRdfdTRUw3K2DL1dql3GIK/
         vtDh8b+wPlaF/D526H/XJj/gfNvhsTFsKCgBrJfsQpy8L8LiOISgcpHDY8nIt3snjwZJ
         z0RKxTPXzC335Q/bfLMJvJXzUAd9xzjXxuM7LRMLPeUUaOmv37Kvg7H4QWfECyKgl2eQ
         JOVyov6VN4tgK1JNiHbalhTQWm6ijJ5LT64IyqlkJYrAh59Ho0DPZuPYL3Uxkz+aRuks
         S8aw==
X-Gm-Message-State: AAQBX9dbTpp9FEFvU8Ou1D3FRnxFli/rKVuJZAObGyQVBGhNQaKMTmhB
        7igHAd8bzmflECiGBMRs1JTZ4CBzClrLeqsyx02+Hg==
X-Google-Smtp-Source: AKy350YTzRLa29aH7q9brLMmTyorYZNQRmkiMJPcWBgHbxwacVxOEg+NP1P2diLGGLrCZIprxNz2cE9YVVP/CpzaDLk=
X-Received: by 2002:a05:6902:100a:b0:b76:3e1:c42d with SMTP id
 w10-20020a056902100a00b00b7603e1c42dmr10629624ybt.13.1680023836016; Tue, 28
 Mar 2023 10:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-14-vipinsh@google.com>
 <ZBzRYgC0IWiZy7PI@google.com>
In-Reply-To: <ZBzRYgC0IWiZy7PI@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 28 Mar 2023 10:16:40 -0700
Message-ID: <CAHVum0duECXZQuk52FqckSY4yLxntSyRXLVMShH+UDtw0SfrZw@mail.gmail.com>
Subject: Re: [Patch v4 13/18] KVM: mmu: Add common initialization logic for
 struct kvm_mmu_memory_cache{}
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

On Thu, Mar 23, 2023 at 3:23=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Mar 06, 2023 at 02:41:22PM -0800, Vipin Sharma wrote:
> > Add macros and function to make common logic for struct
> > kvm_mmu_memory_cache{} declaration and initialization.
> >
> > Any user which wants different values in struct kvm_mmu_memory_cache{}
> > will overwrite the default values explicitly after the initialization.
> >
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/arm64/kvm/arm.c      |  1 +
> >  arch/arm64/kvm/mmu.c      |  3 ++-
> >  arch/riscv/kvm/mmu.c      |  9 +++++----
> >  arch/riscv/kvm/vcpu.c     |  1 +
>
> MIPS also has cache (git grep "struct kvm_mmu_memory_cache").
>

I will respond in Patch 15 where I added stuff for MIPS.

> >  arch/x86/kvm/mmu/mmu.c    |  8 ++++++++
> >  include/linux/kvm_types.h | 10 ++++++++++
> >  6 files changed, 27 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..2b3d88e4ace8 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -330,6 +330,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >       vcpu->arch.target =3D -1;
> >       bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> >       vcpu->arch.mmu_page_cache.gfp_zero =3D __GFP_ZERO;
> >
> >       /*
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7113587222ff..8a56f071ca66 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -895,7 +895,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_add=
r_t guest_ipa,
> >  {
> >       phys_addr_t addr;
> >       int ret =3D 0;
> > -     struct kvm_mmu_memory_cache cache =3D { .gfp_zero =3D __GFP_ZERO =
};
> > +     KVM_MMU_MEMORY_CACHE(cache);
>
> nit: DEFINE_KVM_MMU_MEMORY_CACHE()
>
> (Based on similar existing macros in the kernel, e.g. DEFINE_MUTEX(),
> DEFINE_TIMER().)
>

I will update in v5.

> >       struct kvm_pgtable *pgt =3D kvm->arch.mmu.pgt;
> >       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_DEVICE |
> >                                    KVM_PGTABLE_PROT_R |
> > @@ -904,6 +904,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_add=
r_t guest_ipa,
> >       if (is_protected_kvm_enabled())
> >               return -EPERM;
> >
> > +     cache.gfp_zero =3D __GFP_ZERO;
> >       size +=3D offset_in_page(guest_ipa);
> >       guest_ipa &=3D PAGE_MASK;
> >
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 78211aed36fa..bdd8c17958dd 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -351,10 +351,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa=
_t gpa,
> >       int ret =3D 0;
> >       unsigned long pfn;
> >       phys_addr_t addr, end;
> > -     struct kvm_mmu_memory_cache pcache =3D {
> > -             .gfp_custom =3D (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT =
: 0,
> > -             .gfp_zero =3D __GFP_ZERO,
> > -     };
> > +     KVM_MMU_MEMORY_CACHE(pcache);
> > +
> > +     pcache.gfp_zero =3D __GFP_ZERO;
> > +     if (in_atomic)
> > +             pcache.gfp_custom =3D GFP_ATOMIC | __GFP_ACCOUNT;
> >
> >       end =3D (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> >       pfn =3D __phys_to_pfn(hpa);
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 7d010b0be54e..bc743e9122d1 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -163,6 +163,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >       /* Mark this VCPU never ran */
> >       vcpu->arch.ran_atleast_once =3D false;
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> >       vcpu->arch.mmu_page_cache.gfp_zero =3D __GFP_ZERO;
> >       bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a4bf2e433030..b706087ef74e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5961,15 +5961,20 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  {
> >       int ret;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
> >       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache =3D pte_list_desc_c=
ache;
> >       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero =3D __GFP_ZERO;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
> >       vcpu->arch.mmu_page_header_cache.kmem_cache =3D mmu_page_header_c=
ache;
> >       vcpu->arch.mmu_page_header_cache.gfp_zero =3D __GFP_ZERO;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache);
> >       vcpu->arch.mmu_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> >       mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadowed_info_cache);
> > +
> >       vcpu->arch.mmu =3D &vcpu->arch.root_mmu;
> >       vcpu->arch.walk_mmu =3D &vcpu->arch.root_mmu;
> >
> > @@ -6131,11 +6136,14 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >       node->track_flush_slot =3D kvm_mmu_invalidate_zap_pages_in_memslo=
t;
> >       kvm_page_track_register_notifier(kvm, node);
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
> >       kvm->arch.split_page_header_cache.kmem_cache =3D mmu_page_header_=
cache;
> >       kvm->arch.split_page_header_cache.gfp_zero =3D __GFP_ZERO;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
> >       kvm->arch.split_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> >
> > +     INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
> >       kvm->arch.split_desc_cache.kmem_cache =3D pte_list_desc_cache;
> >       kvm->arch.split_desc_cache.gfp_zero =3D __GFP_ZERO;
> >
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 2728d49bbdf6..192516eeccac 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -98,6 +98,16 @@ struct kvm_mmu_memory_cache {
> >       int capacity;
> >       void **objects;
> >  };
> > +
> > +#define KVM_MMU_MEMORY_CACHE_INIT() { }
> > +
> > +#define KVM_MMU_MEMORY_CACHE(_name) \
> > +             struct kvm_mmu_memory_cache _name =3D KVM_MMU_MEMORY_CACH=
E_INIT()
>
> nit: There's an extra tab here.
>

Auto formatting is happy with two tabs only. I will update in the next
version. Thanks for catching it.

> > +
> > +static inline void INIT_KVM_MMU_MEMORY_CACHE(struct kvm_mmu_memory_cac=
he *cache)
> > +{
> > +     *cache =3D (struct kvm_mmu_memory_cache)KVM_MMU_MEMORY_CACHE_INIT=
();
> > +}
> >  #endif
> >
> >  #define HALT_POLL_HIST_COUNT                 32
> > --
> > 2.40.0.rc0.216.gc4246ad0f0-goog
> >
