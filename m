Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29458778661
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjHKEJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbjHKEJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:09:27 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FFE1FE6
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:09:26 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-40c72caec5cso102081cf.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691726966; x=1692331766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrDrETV1MisK8Z8veMIfL3s41yT4QCG2F0LEIUYQOaY=;
        b=Ys/jY+yPMYklBKhfVgbfOydhc4kNHDE8icVjMrsLLgu+fpHp8tUAe/Z8tQi5EyliBP
         FOXJo9inc1/IlqmQUsyG0TlG4zYcizGN4mXKt2I7CrUe3Ao8uvjVv8FwEd4dfFhoFeJb
         EaGW5q3lZFFVwjmb97adxCHURuV9bY6SqtS9lgUeSR9+V77/nlLuuf3/oSVAakTdOloX
         il2Gz+HPmT8k90isCCKyijsYum0oCwD4qP5kG1ysYzFemHSs4mYGnOyByWqXQlx7/BBu
         InwZUI0LlaFdHMN/1iO1q/vbjsa3pUycjM3BfA+9gzpC1x5/svN9LNkTs9kPqTE82DYN
         CLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691726966; x=1692331766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrDrETV1MisK8Z8veMIfL3s41yT4QCG2F0LEIUYQOaY=;
        b=B7EexH08IK0pJdXKSPHq/wx0ADw98jjcLo4Alfm9R8JBCQ9dwzxeeMH6o/5npzb+qZ
         U/y83xucLyUe5wWPo5eTbQ11t2qOz0cpNU8+5qptB+0LRnq8T2R9T2opOQNJHhDmD1Cb
         WyeqTU67ox5eS13BcRkoA6QRPZnqK2cCvfIB2UqMZbvxRTxURNLrkM/QyXS8hAYDDGsw
         mtF72zXFsPenaxW5WHvFeW79Nou985ykxlnK/FLaqtAtSgHtyt89TabZEa4dciRj2xPe
         xyQ1COOMzyMsm8ARhNaJToT/AOxI2c3in/8ohbLgvsAMPrIjOFYxl+bxsfCgNTKVvY5X
         ktYQ==
X-Gm-Message-State: AOJu0YydN0kooGDW3YwdQGeiPdvrt1Z0SJk7ZJ7JYEt2F5pfeW1ye4Wa
        0Tq3Bl5gVfDaJi1s3La2+j0b+KeAsJ1YZ/3jefDlvg==
X-Google-Smtp-Source: AGHT+IHMAxFXSNCpcy2QB9U1hGdsPt6F2OIhTV8ziEnxB0IpNc9MS9/ILkbKDyBlu4LIoOvbAQ+67cSqZwr61oRzfZI=
X-Received: by 2002:ac8:580a:0:b0:403:ac17:c18a with SMTP id
 g10-20020ac8580a000000b00403ac17c18amr165255qtg.14.1691726965568; Thu, 10 Aug
 2023 21:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com> <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
 <ZNVfsxdYKu9Nt+j+@google.com> <CAJHc60w0By2Q+PCsfwReGXsN5zf5k1ww3Ov4m9Eb-pFH-UKBDg@mail.gmail.com>
 <ZNVtBQvjM45tmbce@google.com>
In-Reply-To: <ZNVtBQvjM45tmbce@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 10 Aug 2023 21:09:14 -0700
Message-ID: <CAJHc60y0izDbTE+XETkSURBzJiRrzmMwQB3+eNJ3YXR-kcg30g@mail.gmail.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
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
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 4:04=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> > On Thu, Aug 10, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> > > > After doing some experiments, I think it works because of the order=
 in
> > > > which the inline-definition and the declaration are laid out. If th=
e
> > > > 'inline' part of the function comes first and then the declaration,=
 we
> > > > don't see any error. However if the positions were reversed, we wou=
ld
> > > > see an error. (I'm not sure what the technical reason for this is).
> > > >
> > > > Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.=
c
> > > > as a non-inline function.
> > >
> > > No need, asm/kvm_host.h _must_ be included before the declaration, ot=
herwise the
> > > declaration wouldn't be made because __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB=
S wouldn't
> > > be defined.  I.e. we won't run into issues where the non-static decla=
ration comes
> > > before the static inline definition.
> > >
> > > C99 explicitly covers this case:
> > >
> > >   6.2.2 Linkages of identifiers
> > >
> > >   ...
> > >
> > >   If the declaration of a file scope identifier for an object or a fu=
nction contains the storage-
> > >   class specifier static, the identifier has internal linkage.
> > >
> > >   For an identifier declared with the storage-class specifier extern =
in a scope in which a
> > >   prior declaration of that identifier is visible if the prior declar=
ation specifies internal or
> > >   external linkage, the linkage of the identifier at the later declar=
ation is the same as the
> > >   linkage specified at the prior declaration. If no prior declaration=
 is visible, or if the prior
> > >   declaration specifies no linkage, then the identifier has external =
linkage.
> > >
> > > In short, because the "static inline" declared internal linkage first=
, it wins.
> > Thanks for sharing this! I can keep the 'static inline' definition as
> > is then. However, since a later patch (patch-05/14) defines
> > kvm_arch_flush_remote_tlbs_range() in arch/x86/kvm/mmu/mmu.c, do you
> > think we can move this definition to the .c file as well for
> > consistency?
>
> We "can", but I don't see any reason to do so.  Trying to make helpers co=
nsistently
> inline or not is usually a fools errand.  And in this case, I'd actually =
rather go
> the opposite direction and make the range variant an inline.
>
> Ha!  And I can justify that with minimal effort.  The below makes the hel=
per a
> straight passthrough for CONFIG_HYPERV=3Dn builds, at which point I think=
 it makes
> sense for it to be inline.
>
> If it won't slow your series down even more, any objection to sliding the=
 below
> patch in somewhere before patch 5?  And then add a patch to inline the ra=
nge-based
> helper?
>
Since it is a little diverted from the rest of the series' goal (and
yes, the slowing down part), do you mind if we send it as a separate
series? :)
I'll keep the functions as we have on v8 for now.

Thank you.
Raghavendra
> Disclaimer: compile tested only.
>
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 10 Aug 2023 15:58:53 -0700
> Subject: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks =
iff
>  HYPERV!=3Dn
>
> Declare the kvm_x86_ops hooks used to wire up paravirt TLB flushes when
> running under Hyper-V if and only if CONFIG_HYPERV!=3Dn.  Wrapping yet mo=
re
> code with IS_ENABLED(CONFIG_HYPERV) eliminates a handful of conditional
> branches, and makes it super obvious why the hooks *might* be valid.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 ++
>  arch/x86/include/asm/kvm_host.h    | 4 ++++
>  arch/x86/kvm/mmu/mmu.c             | 6 ++++++
>  3 files changed, 12 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 13bc212cd4bc..6bc1ab0627b7 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -54,8 +54,10 @@ KVM_X86_OP(set_rflags)
>  KVM_X86_OP(get_if_flag)
>  KVM_X86_OP(flush_tlb_all)
>  KVM_X86_OP(flush_tlb_current)
> +#if IS_ENABLED(CONFIG_HYPERV)
>  KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
>  KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
> +#endif
>  KVM_X86_OP(flush_tlb_gva)
>  KVM_X86_OP(flush_tlb_guest)
>  KVM_X86_OP(vcpu_pre_run)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 60d430b4650f..04fc80112dfe 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1604,9 +1604,11 @@ struct kvm_x86_ops {
>
>         void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
>         void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
> +#if IS_ENABLED(CONFIG_HYPERV)
>         int  (*flush_remote_tlbs)(struct kvm *kvm);
>         int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
>                                         gfn_t nr_pages);
> +#endif
>
>         /*
>          * Flush any TLB entries associated with the given GVA.
> @@ -1814,6 +1816,7 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
>
> +#if IS_ENABLED(CONFIG_HYPERV)
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>  {
> @@ -1823,6 +1826,7 @@ static inline int kvm_arch_flush_remote_tlb(struct =
kvm *kvm)
>         else
>                 return -ENOTSUPP;
>  }
> +#endif
>
>  #define kvm_arch_pmi_in_guest(vcpu) \
>         ((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9e4cd8b4a202..0189dfecce1f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -271,18 +271,24 @@ static inline unsigned long kvm_mmu_get_guest_pgd(s=
truct kvm_vcpu *vcpu,
>
>  static inline bool kvm_available_flush_remote_tlbs_range(void)
>  {
> +#if IS_ENABLED(CONFIG_HYPERV)
>         return kvm_x86_ops.flush_remote_tlbs_range;
> +#else
> +       return false;
> +#endif
>  }
>
>  void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
>                                  gfn_t nr_pages)
>  {
> +#if IS_ENABLED(CONFIG_HYPERV)
>         int ret =3D -EOPNOTSUPP;
>
>         if (kvm_x86_ops.flush_remote_tlbs_range)
>                 ret =3D static_call(kvm_x86_flush_remote_tlbs_range)(kvm,=
 start_gfn,
>                                                                    nr_pag=
es);
>         if (ret)
> +#endif
>                 kvm_flush_remote_tlbs(kvm);
>  }
>
>
> base-commit: bc9e68820274c025840d3056d63f938d74ca35bb
> --
>
