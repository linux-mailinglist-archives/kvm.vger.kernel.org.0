Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203E276A323
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjGaVmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjGaVmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:42:21 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B0C130
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:42:19 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbf8cb6250so20411065ad.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690839739; x=1691444539;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AU1Eyv4/z0dADLWEV1nEcRpLxJELbihGWkSyugO3ex8=;
        b=zHV044O9XwNQjgOLB3AfcpUidtjFsHSm7411oU0FzT/hBIi1OVCl2irlR0nDqKL8Cv
         hr4KfnJvAQ8KZYVTxOCRf7feP1xd884smGeXDTwo1Mxw39juIFwqargVifxiYkX3oNFO
         jGZAeL3BraA/GHqzFzm8zichi53qOSusN9afNCtFEmHZFTDQ5+1SlvbReoCXw9xfn3Sq
         Nxy3SDA+osZfzK8FprhkAlPfPKaV+dJMo4N5DxnhbU6aEOE2yJsGxe0D1EjnOIUEkic5
         iFCs47k5rbIbFAbkVkjH6/FwH8n0Jz0vylbUDue6VIQodFOLNkamKR23aV4KPT1WaTb8
         1QIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690839739; x=1691444539;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AU1Eyv4/z0dADLWEV1nEcRpLxJELbihGWkSyugO3ex8=;
        b=M5vYs5etVyTwt9qU30wcPa1FAm1K1pbejvsoGCkeNC44NcRjNfFRazgPXOtv9ZYmqW
         foh3SZsRrWdUIF6F9riapslFSHgzzM8HfEjOXimEr/64B9MuXaedlJN0YHgRYxJOb6Br
         9o4pPKapec3gUvg8mkfkgDD9wBPGGJZG+LFXJWxIFNPJse5pKDQ6/9Q9p0oEa1qO05xh
         gN9XxLL5MlximI+EVunJ5GnKxyysc9vCHJOIgoKWkOH8qbS49GOttlvDsGxbCGGjV9xi
         H7k+XaJ2qiNPj+0YW3qofUb1j22P5n27oFQZ8WyErDnZEEWrl59+7P+DgPxTg53BwvH5
         b0vA==
X-Gm-Message-State: ABy/qLaCtsyPcU6l4xeLiRD4jG46A3TEYwprsRhOn34AoFV6BgaIhByC
        SfvfFEsKZsGbLmaiTNA8HfQsDOM0mWg=
X-Google-Smtp-Source: APBJJlGvM6eC2793heXvfSouAIwfR2kqtZard40LOvURGFRGLCXd0Mte19jhWawRDx9GHaLxbY3CRW2x+Q4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac4:b0:1bb:91c9:d334 with SMTP id
 q4-20020a170902dac400b001bb91c9d334mr42299plx.0.1690839739050; Mon, 31 Jul
 2023 14:42:19 -0700 (PDT)
Date:   Mon, 31 Jul 2023 14:42:17 -0700
In-Reply-To: <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
Message-ID: <ZMgqueePlmKvgUId@google.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Raghavendra Rao Ananta wrote:
> On Thu, Jul 27, 2023 at 3:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> wro=
te:
> >
> > On Sat, 22 Jul 2023 03:22:40 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > >
> > > From: David Matlack <dmatlack@google.com>
> > >
> > > Rename kvm_arch_flush_remote_tlb() and the associated macro
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
> > >
> > > Making the name plural matches kvm_flush_remote_tlbs() and makes it m=
ore
> > > clear that this function can affect more than one remote TLB.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >  arch/mips/include/asm/kvm_host.h | 4 ++--
> > >  arch/mips/kvm/mips.c             | 2 +-
> > >  arch/x86/include/asm/kvm_host.h  | 4 ++--
> > >  include/linux/kvm_host.h         | 4 ++--
> > >  virt/kvm/kvm_main.c              | 2 +-
> > >  5 files changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm=
/kvm_host.h
> > > index 04cedf9f8811..9b0ad8f3bf32 100644
> > > --- a/arch/mips/include/asm/kvm_host.h
> > > +++ b/arch/mips/include/asm/kvm_host.h
> > > @@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_v=
cpu *vcpu, int cpu) {}
> > >  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> > >  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {=
}
> > >
> > > -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> > > -int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > How about making this prototype global? I don't see a point in having
> > it per-architecture, specially as you are adding arm64 to that mix in
> > the following patch.
> >
> We can make it global, but I'm not sure what was the intention of the
> original author. My guess is that he was following the same style that
> we have for some of the other kvm_arch_*() functions
> (kvm_arch_free_vm() for example)?

Heh, KVM has a *lot* of code that was written with questionable style.  I a=
gree
with Marc, I can't think of a single reason not to have the definition in c=
ommon
code.  Declaring the function doesn't preclude a "static inline" implementa=
tion,
and we could even keep the prototype under an #ifdef, e.g.=20

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..5ac64f933547 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlb(struct kv=
m *kvm)
 {
        return -ENOTSUPP;
 }
+#else
+int kvm_arch_flush_remote_tlb(struct kvm *kvm);
 #endif
=20
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA

