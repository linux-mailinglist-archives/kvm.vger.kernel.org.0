Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95506D23E2
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 17:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjCaPU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 11:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjCaPU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 11:20:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0471FFC
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680276007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6CU5Ddpdec3UHjfBbCvATcfi/WoCiZcAaFwRhOVJWY=;
        b=W9U0YTb/DjLG/aXIMEvN7LsYmpSWsfZ3dE6STqlZbErsCXk03PIO3vT+LH0D5Xmw/ZquwP
        qXr8Q3iUjogw846TAQ7uIaOU5syJFLp66QSxpvH4gDhuZKx2nxXVrDhuCrChShBOr8Lgk/
        GQmhUb436gmcitzmoUn7xaTALmbQfns=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-Ww3g-n0JO3uPMR3UyrDlSA-1; Fri, 31 Mar 2023 11:20:03 -0400
X-MC-Unique: Ww3g-n0JO3uPMR3UyrDlSA-1
Received: by mail-vs1-f71.google.com with SMTP id ei25-20020a056102471900b00426df093b17so1624508vsb.0
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680276003; x=1682868003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f6CU5Ddpdec3UHjfBbCvATcfi/WoCiZcAaFwRhOVJWY=;
        b=cE5gZA5tCylzS1CfbyRXhFs5GoEI/7/fxgkteR2XH9I3Bvolr9kJDs8TzupWHO3gZA
         ROW9q4y2up8uTRifkeDkpDWXWn7KD204TfB5lxRpPQTH/skWyknLCprhgowi+7om/UH+
         bafs1ggpMuxV4224hGmExjjgbBqAAulKujklNgR7KHrCnP6LZUCgH8rbpS1JY2k8iLfS
         TEeoSImVrovNlt0Bh9BESA8K9ou4rkNJDTMf9sNeFk1nu4Ocw+7veNjPnwHhMmESUIf4
         BKtQDqg7Qn2YukgVwK4hrBQlBI4K/Y/OpwRARUrdm/8R6M6GZb8rxoBzNqRyKV3TCsz/
         gKqw==
X-Gm-Message-State: AAQBX9cV0gKfnnb5XKHJBARa2/T+LCW4SLqpM8EA+CpwY7bMDcjvfrEd
        oPXBBhYTu7LsJjM7AFVEXxQxNWFUOsUSaXA5o+CHIxwuFgWfbg5+G8tGO85eHyIXPqBw2/Cl5yQ
        npgUtRI69b/QEKiW/ljWJ8DfA+HYs
X-Received: by 2002:ab0:3d10:0:b0:765:7f94:7b6b with SMTP id f16-20020ab03d10000000b007657f947b6bmr13850657uax.0.1680276002836;
        Fri, 31 Mar 2023 08:20:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNB8MLpvwpoDgxebxMSRuolwGHn7MFfpewXuQbNDHBUzcjFG8BWXR164/Vxxdzxpp1boNm3vhbys8xMKlvimI=
X-Received: by 2002:ab0:3d10:0:b0:765:7f94:7b6b with SMTP id
 f16-20020ab03d10000000b007657f947b6bmr13850635uax.0.1680276002534; Fri, 31
 Mar 2023 08:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20221003235722.2085145-1-aik@ozlabs.ru> <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
In-Reply-To: <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 31 Mar 2023 17:19:51 +0200
Message-ID: <CABgObfYGqT2V0NgTShx2=QACK5o6=TOwsMV+MeQWqQbfcNWr3g@mail.gmail.com>
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm-riscv@lists.infradead.org,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 9:38=E2=80=AFAM Alexey Kardashevskiy <aik@ozlabs.ru=
> wrote:
>
> Paolo, ping?

Queued, thanks (the automated message used the wrong reply but this is
the patch I applied).

Paolo

>
> On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
> > When introduced, IRQFD resampling worked on POWER8 with XICS. However
> > KVM on POWER9 has never implemented it - the compatibility mode code
> > ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> > XIVE mode does not handle INTx in KVM at all.
> >
> > This moved the capability support advertising to platforms and stops
> > advertising it on XIVE, i.e. POWER9 and later.
> >
> > This should cause no behavioural change for other architectures.
> >
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > Acked-by: Nicholas Piggin <npiggin@gmail.com>
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > ---
> > Changes:
> > v4:
> > * removed incorrect clause about changing behavoir on MIPS and RISCV
> >
> > v3:
> > * removed all ifdeferry
> > * removed the capability for MIPS and RISCV
> > * adjusted the commit log about MIPS and RISCV
> >
> > v2:
> > * removed ifdef for ARM64.
> > ---
> >   arch/arm64/kvm/arm.c       | 1 +
> >   arch/powerpc/kvm/powerpc.c | 6 ++++++
> >   arch/s390/kvm/kvm-s390.c   | 1 +
> >   arch/x86/kvm/x86.c         | 1 +
> >   virt/kvm/kvm_main.c        | 1 -
> >   5 files changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 2ff0ef62abad..d2daa4d375b5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_VCPU_ATTRIBUTES:
> >       case KVM_CAP_PTP_KVM:
> >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> > +     case KVM_CAP_IRQFD_RESAMPLE:
> >               r =3D 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> > index fb1490761c87..908ce8bd91c9 100644
> > --- a/arch/powerpc/kvm/powerpc.c
> > +++ b/arch/powerpc/kvm/powerpc.c
> > @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
> >               break;
> >   #endif
> >
> > +#ifdef CONFIG_HAVE_KVM_IRQFD
> > +     case KVM_CAP_IRQFD_RESAMPLE:
> > +             r =3D !xive_enabled();
> > +             break;
> > +#endif
> > +
> >       case KVM_CAP_PPC_ALLOC_HTAB:
> >               r =3D hv_enabled;
> >               break;
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index edfd4bbd0cba..7521adadb81b 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_SET_GUEST_DEBUG:
> >       case KVM_CAP_S390_DIAG318:
> >       case KVM_CAP_S390_MEM_OP_EXTENSION:
> > +     case KVM_CAP_IRQFD_RESAMPLE:
> >               r =3D 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 43a6a7efc6ec..2d6c5a8fdf14 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> >       case KVM_CAP_VAPIC:
> >       case KVM_CAP_ENABLE_CAP:
> >       case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> > +     case KVM_CAP_IRQFD_RESAMPLE:
> >               r =3D 1;
> >               break;
> >       case KVM_CAP_EXIT_HYPERCALL:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 584a5bab3af3..05cf94013f02 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4447,7 +4447,6 @@ static long kvm_vm_ioctl_check_extension_generic(=
struct kvm *kvm, long arg)
> >   #endif
> >   #ifdef CONFIG_HAVE_KVM_IRQFD
> >       case KVM_CAP_IRQFD:
> > -     case KVM_CAP_IRQFD_RESAMPLE:
> >   #endif
> >       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
> >       case KVM_CAP_CHECK_EXTENSION_VM:
>
> --
> Alexey
>

