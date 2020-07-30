Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1B423293D
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 02:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgG3A45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 20:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgG3A4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 20:56:54 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFEC061794;
        Wed, 29 Jul 2020 17:56:54 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q9so3234449oth.5;
        Wed, 29 Jul 2020 17:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VwGC5we8NqM1/WqIBKe+R0LI4Ddr3r8VHSb3CITwzE=;
        b=PScGXoErZ4EY/dcMyDRi4iDpWGOSewRjuyIKMrlTalG7wtmT091Lt9/sAWUYDwAizb
         BCOVQ8mNemL3Xyeq/DL0Oha973Qxmg1xvXizNdO1Q2bw1pMM0sMP0VfrNCIIyG3fFjlj
         y5jC8WjPtdtMl8LMTatvMHsxq1HzCqbs5rowcQkmCCrxSlZOIsF/82ZWjTjYQhzzcj2R
         VndzvkAxX6kQgpBWfryaNugjJ0Uy0ywd8oXn/hMzLCPY2BrEF4AOJnk74hETT94AEifl
         LGOwFVLh18IEZmN2S6EG08P5b9qvD77e+941IBd7wqM5eWR6N1Gt2/7/QpOCEEGvirGG
         +0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VwGC5we8NqM1/WqIBKe+R0LI4Ddr3r8VHSb3CITwzE=;
        b=nmgwpyN1lZYD+bHpj8uA6IfaeDdnusgvLZKoVTRuUuzxgDqqrcMMFELl1UEpfmSjhi
         lZTecH7bC1PMVXys5+sfqx5N7oe9us8uv/fkr8Tqqv3jVOkPIMNlIuQIgipBtD17Adfm
         d4pYM8VW5nuejskmcfL+qRHuPbXBuLFiPAzRn9o+FQaZsUukvwHftsY5vUqT2XRZna0y
         v7JAGBvfi0a7Xb03DrP5jNPpXmkykqW25qMjN4jGn5PGApMGFGg3pIRfyjnmukXJZ2F2
         c5S93q8S25NQjrimosZbDJB/Px0cm1PYB0zi3rgtyRkwaWBPmm26XlcAZ2F4vSZltHzO
         +mDA==
X-Gm-Message-State: AOAM531n6XJ15ZkgBoq2yFbuKlsHUirrhCCOYVEU3mY77XlFR5j8YDvZ
        hjxKvMySL7C9uELB/JpLZmSBCoZJyv/x9u+WDlU=
X-Google-Smtp-Source: ABdhPJwkeeToi1bvgT2kK6So+NXMvcn8/ncDmL7dxNfHdEFMqAvWNpDMhVRqWyDmzoB1x0j8YMM+kmd3gX/NsczQwVg=
X-Received: by 2002:a9d:37f5:: with SMTP id x108mr414581otb.254.1596070614099;
 Wed, 29 Jul 2020 17:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
 <1595929506-9203-3-git-send-email-wanpengli@tencent.com> <87k0ymldg9.fsf@vitty.brq.redhat.com>
In-Reply-To: <87k0ymldg9.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 30 Jul 2020 08:56:42 +0800
Message-ID: <CANRm+Cx-VM=QGcDNG0oRq7YX+2wmmw8yDjESrJGxTeEWkUUv0A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Fix disable pause loop exit/pause
 filtering capability on SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jul 2020 at 20:21, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Commit 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM) drops
> > disable pause loop exit/pause filtering capability completely, I guess it
> > is a merge fault by Radim since disable vmexits capabilities and pause
> > loop exit for SVM patchsets are merged at the same time. This patch
> > reintroduces the disable pause loop exit/pause filtering capability
> > support.
> >
> > We can observe 2.9% hackbench improvement for a 92 vCPUs guest on AMD
> > Rome Server.
> >
> > Reported-by: Haiwei Li <lihaiwei@tencent.com>
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c0da4dd..c20f127 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> >       svm->nested.vmcb = 0;
> >       svm->vcpu.arch.hflags = 0;
> >
> > -     if (pause_filter_count) {
> > +     if (pause_filter_count && !kvm_pause_in_guest(svm->vcpu.kvm)) {
> >               control->pause_filter_count = pause_filter_count;
> >               if (pause_filter_thresh)
> >                       control->pause_filter_thresh = pause_filter_thresh;
> > @@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
> >       struct kvm_vcpu *vcpu = &svm->vcpu;
> >       bool in_kernel = (svm_get_cpl(vcpu) == 0);
> >
> > -     if (pause_filter_thresh)
> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >               grow_ple_window(vcpu);
> >
> >       kvm_vcpu_on_spin(vcpu, in_kernel);
> > @@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >
> >  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > -     if (pause_filter_thresh)
> > +     if (!kvm_pause_in_guest(vcpu->kvm))
> >               shrink_ple_window(vcpu);
> >  }
> >
> > @@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
> >
> >  static int svm_vm_init(struct kvm *kvm)
> >  {
> > +     if (!pause_filter_thresh)
> > +             kvm->arch.pause_in_guest = true;
>
> Would it make sense to do
>
>         if (!pause_filter_count || !pause_filter_thresh)
>                 kvm->arch.pause_in_guest = true;
>
> here and simplify the condition in init_vmcb()?

kvm->arch.pause_in_guest can also be true when userspace sets the
KVM_CAP_X86_DISABLE_EXITS capability, so we can't simplify the
condition in init_vmcb().

    Wanpeng
