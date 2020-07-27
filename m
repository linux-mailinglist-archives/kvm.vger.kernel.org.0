Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C2822E5C4
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 08:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgG0GTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 02:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0GTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 02:19:09 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2E3C0619D2;
        Sun, 26 Jul 2020 23:19:08 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id h13so11534536otr.0;
        Sun, 26 Jul 2020 23:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JcGPO+gK+jWmNFf+CGlBsEJa/nwVwhmsLiCBZk9Bm6c=;
        b=ZRIJqfmyF6JoJMPHAxV1n7kaOdtTfIJpUm3bc2ADAcF76KJ8yGRId56k4UMgAzNQ8Y
         eivWVwHPzAbmFcCMajMQVgGWXWwogG9JVeIVsv76CnA52v8sL8nyVLkQNGouowpP1/jP
         0dLoBUQGRRU/kgquLKrSb9Qqk8kwnVWIyhemjesO4sBsH68KBUGELGnprFO5ygqqJFrL
         MT2V93fnUdL921XD+jt+bU0F36X2/kwOa49EvAltpBZiAWVUH5oqBEte8dlOzE78c/Ya
         O/mcxAm2VdOiRlFSya4HXIwtJ85iyYOqYJnSwocGMg3KcH4SbQVQHrVSJ4bhYEep7Ud7
         2DDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JcGPO+gK+jWmNFf+CGlBsEJa/nwVwhmsLiCBZk9Bm6c=;
        b=YdNDuyOk3R5x5x6TQIKDHtG0OAZ2U/Yh9qLb9oKCXnYFuS3OC/Osy8xPh5KzaA/5zn
         EOqZnaswTBgrct++ol2+L117+BNsjhK/v3iqeXiy4EpXEh3E08SGUtbN5LW2lVrDsoqx
         4rdHUPwr0mQZIFs3cAkJpSe3dy6m4wa4wCaoXWNTRb34il7aUpwEM93NCrGSRhvfLHPE
         SMBUi+Vcboi0cRs4D9pxf81Dc8EdkYx5mutjQXi04OGX5UFY5HCkX5TY67SJbuAt6uon
         tuNdgUFsSgV/7jobkv82DNTkaLriXfO6bOMwoeSkAfgv3mw3KPJE6ITMySRoA2+Ev771
         1iAg==
X-Gm-Message-State: AOAM531QSjRKTIF1R3yvHkG5vbDtSzKo5hj6iHCYokk/UIjKInxT2rnk
        UuTNnMgF63NHvCcikJrPySSSoH06sKNGDU2inI4=
X-Google-Smtp-Source: ABdhPJzWMYxjlAWKnukYtCS5IfqtJyArVDfkAhXl9hq2Oot6XOnhsCh0gc+cqD95uKkNuV35K+8MNqDcESTaSG6Um6o=
X-Received: by 2002:a9d:6f0d:: with SMTP id n13mr17284568otq.254.1595830747538;
 Sun, 26 Jul 2020 23:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
 <87o8o9p356.fsf@vitty.brq.redhat.com> <20200721152519.GB22083@linux.intel.com>
In-Reply-To: <20200721152519.GB22083@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 27 Jul 2020 14:18:56 +0800
Message-ID: <CANRm+CxLrTWJL-adSsu47=Jm_85i-c-V1VGDBrVDfXmbe5qumg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Prevent setting the tscdeadline timer if
 the lapic is hw disabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jul 2020 at 23:25, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jul 21, 2020 at 12:35:01PM +0200, Vitaly Kuznetsov wrote:
> > Wanpeng Li <kernellwp@gmail.com> writes:
> >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Prevent setting the tscdeadline timer if the lapic is hw disabled.
> > >
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> A Fixes and/or Cc stable is probably needed for this.
>
> > > ---
> > >  arch/x86/kvm/lapic.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 5bf72fc..4ce2ddd 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_v=
cpu *vcpu, u64 data)
> > >  {
> > >     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > >
> > > -   if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
> > > +   if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
> > >                     apic_lvtt_period(apic))
> > >             return;
> >
> > Out of pure curiosity, what is the architectural behavior if I disable
> > LAPIC, write to IA32_TSC_DEADLINE and then re-enable LAPIC before the
> > timer was supposed to fire?
>
> Intel's SDM reserves the right for the CPU to do whatever it wants :-)
>
>    When IA32_APIC_BASE[11] is set to 0, prior initialization to the APIC
>    may be lost and the APIC may return to the state described in Section
>    10.4.7.1, =E2=80=9CLocal APIC State After Power-Up or Reset.=E2=80=9D
>
> Practically speaking, resetting APIC state seems like the sane approach,
> i.e. KVM should probably call kvm_lapic_reset() when the APIC transitions
> from HW enabled -> disabled.  Maybe in a follow-up patch to this one?

kvm_lapic_reset() will call the set base logic, a little recursive in
the codes, it can be done after this recursion is solved.

    Wanpeng
