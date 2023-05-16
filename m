Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDE87054D5
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjEPRRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjEPRRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:17:52 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8999421E
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:17:49 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-33164ec77ccso9635ab.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684257469; x=1686849469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUCGnNc5xR+rtR6/oclnI6VxbaAmUhSdHpmLK65pxbU=;
        b=WP5U2wcaWsXv3Oxoo+zTyEmgwNIWhgsTSSxIxDMkJZqg5hZecSQqIPqI1NTw9MusGz
         2ThXuPD/y3/78xJmYaS2UYqVuu6WbJ4PnkQ3uzYs9OXsqVU0Qn42GXYhsGmFHpIBsKmd
         wzRwG3yFvhv0I7WBrAk6kp/kHbXB4gfVxgm10i7uVsT68TxrJKTAhNEaOBLarIAGufGP
         WSYuWnCyyxOmFMFe7If+iXXK6MVHiDjiOHnXySXpuOJOPx6KdaxCWvaH1Gqryg0fNZzN
         B5O3duafvb+V2xsCgkgvy+7lvULJwXruppNnFcB0n2mM3f6cbPOgNKFlN50Y4PUIT+iG
         WLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684257469; x=1686849469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUCGnNc5xR+rtR6/oclnI6VxbaAmUhSdHpmLK65pxbU=;
        b=UXd3iL2xvsyquLekxap/txvatYYccIlnE+YQg4yIqwgcc8cS3Gp8LLEg8vER3RA9Z1
         qP1tB8gfwWcMKcAxSXcr05tRC7PMlgdo6m6omLBV1UH9Khql+tffssyraFriifwT5q01
         hK5BEjOD/v/+L7Wbm6py6uzU/hwczV+VI5g275IRtLXIH5kA72I5dfynyYixmG6MR/gS
         DCiF0BH/esQRVNCHn1BTznFMhsHItoLwOwMgu1H5U6eZloP2XAPc/G8a5lyfCsoboj9L
         nbiN6bL7mDjCeVduzjlvQ7iuT57XkB+RI3md873LZ//zvP8rgNxzElsAVrnjdoDQynES
         zrMQ==
X-Gm-Message-State: AC+VfDwTD86/gFHvpL3W56+62EonZu1rd/HOUY0Y5WaCIiOeh40VC6w4
        KhU6K/v7FwzPaDwg1f9QYf9SKIxvFXViRxFaOvrZKQ==
X-Google-Smtp-Source: ACHHUZ6gw/3CUJN+4WOAb0a0uaF2zNQt+KzQYCtFUHkL3fwoTY4WQlhtoW4+Jk7cJ2/qxzHrkJ3w6PM5smMOWN62R6A=
X-Received: by 2002:a05:6e02:1c25:b0:331:948c:86f3 with SMTP id
 m5-20020a056e021c2500b00331948c86f3mr248377ilh.19.1684257468980; Tue, 16 May
 2023 10:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-3-rananta@google.com>
 <ZF5uRWtvhhqZSQCa@linux.dev>
In-Reply-To: <ZF5uRWtvhhqZSQCa@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 16 May 2023 10:17:37 -0700
Message-ID: <CAJHc60yJogVr8BwQX1jugZpyDnzdYYpRe1BPto-R9ufLoCzUqQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] KVM: arm64: Implement __kvm_tlb_flush_vmid_range()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

Hi Oliver,

On Fri, May 12, 2023 at 9:50=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghavendra,
>
> On Fri, Apr 14, 2023 at 05:29:17PM +0000, Raghavendra Rao Ananta wrote:
> > Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
> > to flush a range of stage-2 page-tables using IPA in one go.
> > If the system supports FEAT_TLBIRANGE, the following patches
> > would conviniently replace global TLBI such as vmalls12e1is
> > in the map, unmap, and dirty-logging paths with ripas2e1is
> > instead.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      | 39 ++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/tlb.c       | 35 +++++++++++++++++++++++++++
> >  4 files changed, 88 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 43c3bc0f9544d..33352d9399e32 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> > +     __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
> >  };
> >
> >  #define DECLARE_KVM_VHE_SYM(sym)     extern char sym[]
> > @@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
> >  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
> >  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr=
_t ipa,
> >                                    int level);
> > +extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                                     phys_addr_t start, phys_addr_t en=
d);
> >  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
> >
> >  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 728e01d4536b0..81d30737dc7c9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct=
 kvm_cpu_context *host_ctxt)
> >       __kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> >  }
> >
> > +static void
> > +handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
> > +{
> > +     DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > +     DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> > +     DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
> > +
> > +     __kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, end);
> > +}
> > +
> >  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_c=
txt)
> >  {
> >       DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > @@ -315,6 +325,7 @@ static const hcall_t host_hcall[] =3D {
> >       HANDLE_FUNC(__kvm_vcpu_run),
> >       HANDLE_FUNC(__kvm_flush_vm_context),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> > +     HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid),
> >       HANDLE_FUNC(__kvm_flush_cpu_context),
> >       HANDLE_FUNC(__kvm_timer_set_cntvoff),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index d296d617f5896..d2504df9d38b6 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -109,6 +109,45 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *m=
mu,
> >       __tlb_switch_to_host(&cxt);
> >  }
> >
> > +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t start, phys_addr_t end)
> > +{
> > +     struct tlb_inv_context cxt;
> > +     unsigned long pages, stride;
> > +
> > +     /*
> > +      * Since the range of addresses may not be mapped at
> > +      * the same level, assume the worst case as PAGE_SIZE
> > +      */
> > +     stride =3D PAGE_SIZE;
> > +     start =3D round_down(start, stride);
> > +     end =3D round_up(end, stride);
> > +     pages =3D (end - start) >> PAGE_SHIFT;
> > +
> > +     if (!system_supports_tlb_range() || pages >=3D MAX_TLBI_RANGE_PAG=
ES) {
> > +             __kvm_tlb_flush_vmid(mmu);
> > +             return;
> > +     }
> > +
> > +     dsb(ishst);
>
> Due to some concerns w.r.t. the imprecision of the architecture for
> synchronizing with the table walkers, these preamble barriers were
> upgraded to dsb(ish) in commit 7e1b2329c205 ("KVM: arm64: nvhe:
> Synchronise with page table walker on TLBI"). Good news is, the magic is
> behind __tlb_switch_to_guest(), so just drop these barriers when you
> rebase the series onto a 6.4 rc.
>
Thanks for the info! I'll rebase the series and take care of this.

- Raghavendra
> --
> Thanks,
> Oliver
