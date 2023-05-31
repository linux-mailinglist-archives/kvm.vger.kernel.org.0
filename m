Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8E718BA6
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 23:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjEaVNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 17:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjEaVNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 17:13:18 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165FBB3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 14:13:17 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f81ffc9065so19761cf.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 14:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685567596; x=1688159596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+2qoqODzznlrzJdzN64MjbCVNNnQuwRRtJuX4ggbCU=;
        b=kHJHBx69u6844yWRg+bdMx0m0tvgPlagRdL9WAIhqNvPpu8LX6GMuzHUHixyWgd9Mf
         qMY0qxpAkEmOxYZNrn0heIVjfGWpYgIwlgNcz8wlOeZnnk3GSZB4NDa6DPPoQDzEoBo0
         lR6HimNkut+XEN2CfKEthgqEw9XODXPnFgApD2MocwWQg3P600hpjTCFdeQ/aa4jxYoA
         id1X9co22nLUO5CFxyBWnUvevyXMChC/vrSNZ3kgUh9Qq84ljrXGo9BVv2lPuo5FhPmW
         R5vkwByRhT5602h6iBd8eMi2T7L9oJexCh5hLLcf6GpQ/OcBRYje/jyno1z0YmKsVGx1
         h3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685567596; x=1688159596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+2qoqODzznlrzJdzN64MjbCVNNnQuwRRtJuX4ggbCU=;
        b=DZ0so6SvarJwV13E/orob8VZqQXV6+O/GM1i8YcdN1jxxXt2t1BI0wYoBZJmHBb23+
         sKrzoenEGVZtueQ6yxStNXquIvNIM87F+lM77/6ggNFpbBYUkK6SkSLZopF2eXdDi3k8
         dBX4wM8ljagacDs0eQPMxBdpZZ+/jx4N/ChwEGvY2yTIxq4lh/JNmepF/0zbp7zFZjda
         aLH5ibHlAWpx8RCb3FM+60iN3QvmWpd3zeoWj5A/vroS6iGJWxqLw0mb6nNwoZIc7BgI
         jDuhNHIpTlGJiwXBC1x4oVmnVdKh1mJQEG4mIiIYf/7YrL2jqP+ZF/kj5+HqTVHOAZ6a
         eorA==
X-Gm-Message-State: AC+VfDxTrmMCUY3duDQ2EuMTMxbFbxsA6ljEA/n+7FqKEkEI+Ua1ORcR
        xIroibWT+33vJYFFAmLUL++vCOI9DKh2sxnalMVd2A==
X-Google-Smtp-Source: ACHHUZ5WfYJ6eA2+oGfutrPzowugKbbUX/q/GiLW+TIRlZfdD7OeKd4PuotxSoDS0rqsIQKlsK37axqyrYA0yyXPG+Q=
X-Received: by 2002:a05:622a:1a11:b0:3f8:3065:7fc5 with SMTP id
 f17-20020a05622a1a1100b003f830657fc5mr7534qtb.1.1685567595969; Wed, 31 May
 2023 14:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-6-yuzhao@google.com>
 <ZHemUc3DiSbxQbxJ@linux.dev>
In-Reply-To: <ZHemUc3DiSbxQbxJ@linux.dev>
From:   Yu Zhao <yuzhao@google.com>
Date:   Wed, 31 May 2023 15:12:39 -0600
Message-ID: <CAOUHufa8+NZcctoYXOZQXNdvKTUxAMDF3sC=X+3mv4juMUyrLA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 05/10] kvm/arm64: add kvm_arch_test_clear_young()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 1:56=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Yu,
>
> On Fri, May 26, 2023 at 05:44:30PM -0600, Yu Zhao wrote:
> > Implement kvm_arch_test_clear_young() to support the fast path in
> > mmu_notifier_ops->test_clear_young().
> >
> > It focuses on a simple case, i.e., hardware sets the accessed bit in
> > KVM PTEs and VMs are not protected, where it can rely on RCU and
> > cmpxchg to safely clear the accessed bit without taking
> > kvm->mmu_lock. Complex cases fall back to the existing slow path
> > where kvm->mmu_lock is then taken.
> >
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  6 ++++++
> >  arch/arm64/kvm/mmu.c              | 36 +++++++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 7e7e19ef6993..da32b0890716 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1113,4 +1113,10 @@ static inline void kvm_hyp_reserve(void) { }
> >  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
> >
> > +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> > +static inline bool kvm_arch_has_test_clear_young(void)
> > +{
> > +     return cpu_has_hw_af() && !is_protected_kvm_enabled();
> > +}
>
> I would *strongly* suggest you consider supporting test_clear_young on
> systems that do software Access Flag management. FEAT_HAFDBS is an
> *optional* extension to the architecture, so we're going to support
> software AF management for a very long time in KVM. It is also a valid
> fallback option in the case of hardware errata which render HAFDBS
> broken.

Hi Oliver,

It's not about willingness but resources. Ideally we want to make
everything perfect, but in reality, we can only move forward one step
a time.

If I looked at your request from ARM's POV, I would agree with you.
But my goal is to lay the foundation for all architectures that could
benefit, so I may not be able to cover a lot for each architecture.
Specifically, I don't have the bandwidth to test the !FEAT_HAFDBS case
for ARM.

So here are some options I could offer, ordered by my preferences:
1. We proceed as it is for now. I *will* find someone from my team (or
yours) to follow up -- this way we can make sure !FEAT_HAFDBS is well
tested.
2. I drop the cpu_has_hw_af() check above. Not that I think there is
much risk, I'm just trying to be cautious.
3. I drop the entire ARM support (and include the RISC-V support which
I previously deprioritized). We revisit after the test is done.

Sounds reasonable?

> So, we should expect (and support) systems of all shapes and sizes that
> do software AF. I'm sure we'll hear about more in the not-too-distant
> future...
>
> For future reference (even though I'm suggesting you support software
> AF), decisions such of these need an extremely verbose comment
> describing the rationale behind the decision.
>
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c3b3e2afe26f..26a8d955b49c 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
>
> Please do not implement page table walkers outside of hyp/pgtable.c
>
> > @@ -1678,6 +1678,42 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kv=
m_gfn_range *range)
> >                                          range->start << PAGE_SHIFT);
> >  }
> >
> > +static int stage2_test_clear_young(const struct kvm_pgtable_visit_ctx =
*ctx,
> > +                                enum kvm_pgtable_walk_flags flags)
> > +{
> > +     kvm_pte_t new =3D ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > +
> > +     VM_WARN_ON_ONCE(!page_count(virt_to_page(ctx->ptep)));
>
> This sort of sanity checking is a bit excessive. Isn't there a risk of
> false negatives here too? IOW, if we tragically mess up RCU in the page
> table code, what's stopping a prematurely freed page from being
> allocated to another user?

Yes, but from my aforementioned POV (the breadth I'm focusing on),
this is a good practice. I can live without this assertion if you feel
strongly about it.

> > +     if (!kvm_pte_valid(new))
> > +             return 0;
> > +
> > +     if (new =3D=3D ctx->old)
> > +             return 0;
> > +
> > +     if (kvm_should_clear_young(ctx->arg, ctx->addr / PAGE_SIZE))
> > +             stage2_try_set_pte(ctx, new);
> > +
> > +     return 0;
> > +}
> > +
> > +bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *=
range)
> > +{
> > +     u64 start =3D range->start * PAGE_SIZE;
> > +     u64 end =3D range->end * PAGE_SIZE;
> > +     struct kvm_pgtable_walker walker =3D {
> > +             .cb     =3D stage2_test_clear_young,
> > +             .arg    =3D range,
> > +             .flags  =3D KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_SHAR=
ED,
> > +     };
> > +
> > +     BUILD_BUG_ON(is_hyp_code());
>
> Delete this assertion.

Will do.
