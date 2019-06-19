Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F874AF0C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 02:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfFSAev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 20:34:51 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39949 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFSAev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 20:34:51 -0400
Received: by mail-ot1-f65.google.com with SMTP id e8so16485968otl.7;
        Tue, 18 Jun 2019 17:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZXR7tAPaEkwGsGkQZyrZdvvi0BeI2lp41nwHf5CBMnU=;
        b=tIZk7NtZsCu5f5iH8jH7Sa9+vz4sThRbI8n900KepBBMPO2KBKQ4P0tmwTLwU+t4c0
         iEbUWDIPY/MBKqIEUNWjnEKN/vHeUN9U9LUMOHm41ETRZ2S1HBBvgkBjRF9ReJjfIhFq
         YiHSgQsCcRgDQ/PJOsxP5TEMBXgCZMFZVXRK4EvagCy+O4FBmQDyqRmHeP0yw3vcjL5b
         LSDJM7RVbToEUj/1LDk+K9x7/qEZ/yh3k3hcAiGmPEUrIf+Xm4COAT8BuRH/TtVRr19D
         BkjvlVpM3qYoErrvF3tXVWK4wMZaLwLftJywBnznYDxLJkE5nqUN87pGVHKp2dwivtNk
         j7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZXR7tAPaEkwGsGkQZyrZdvvi0BeI2lp41nwHf5CBMnU=;
        b=ALIVh11S7t/lyFaeU6jDkShP+skQYsr99xTWJpt4Gdt6eif7CBnCYxMF8hW9fHPV2K
         lWlzySeSnD2aONFNe8HLxXudtoLIjxMR6NSZnZIE8o27L3cW1G/CqhmlXqSAwSjlg5Oz
         3CdfN1JjIxotHQX0bmOIlG0UmKkxjm6zM6/QO8+JlAjne3of9kSJ06DsfrGpn3GOftDk
         9I7iTtM1E0BztIcDf/ikqjzlGZm3vJb01mMjJeeBPGYyAo9HfnB1b1c9csPNZek1k4c1
         AoNe3U9CeOGkdE+VtlQCcsX83ngmyOeTiKRrPbQwCMKna+w3kT2aDL+cPzMjLk27KarU
         UpBw==
X-Gm-Message-State: APjAAAXD/ZYdJiPfj5AncUXeh558lEjNgSRcU2R+KJsLGGuQaWvA+g7C
        RTI8cryAqHsiE/WFD3LfcdRv4Mazz/5zQQvZTDzCnt4y
X-Google-Smtp-Source: APXvYqyLWELQU60MDNt3lIlb8HFuSYqw22oFeQKzWoTpxaujCa+AaNrf8aiXAq7J85SDUVP0OwkvWPK4s7kqYrhLRmw=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr69195620otb.185.1560904490828;
 Tue, 18 Jun 2019 17:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
In-Reply-To: <20190618133541.GA3932@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 Jun 2019 08:36:06 +0800
Message-ID: <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by posted interrupt
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Dedicated instances are currently disturbed by unnecessary jitter due
> > to the emulated lapic timers fire on the same pCPUs which vCPUs residen=
t.
> > There is no hardware virtual timer on Intel for guest like ARM. Both
> > programming timer in guest and the emulated timer fires incur vmexits.
> > This patch tries to avoid vmexit which is incurred by the emulated
> > timer fires in dedicated instance scenario.
> >
> > When nohz_full is enabled in dedicated instances scenario, the emulated
> > timers can be offload to the nearest busy housekeeping cpus since APICv
> > is really common in recent years. The guest timer interrupt is injected
> > by posted-interrupt which is delivered by housekeeping cpu once the emu=
lated
> > timer fires.
> >
> > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-r=
oot
> > mode, ~3% redis performance benefit can be observed on Skylake server.
> >
> > w/o patch:
> >
> >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Av=
g time
> >
> > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.=
71us ( +-   1.09% )
> >
> > w/ patch:
> >
> >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time     =
    Avg time
> >
> > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.=
72us ( +-   4.02% )
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
> >  arch/x86/kvm/lapic.h            |  1 +
> >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> >  arch/x86/kvm/x86.c              |  5 +++++
> >  arch/x86/kvm/x86.h              |  2 ++
> >  include/linux/sched/isolation.h |  2 ++
> >  kernel/sched/isolation.c        |  6 ++++++
> >  7 files changed, 44 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 87ecb56..9ceeee5 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *=
apic)
> >       return apic->vcpu->vcpu_id;
> >  }
> >
> > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > +{
> > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +             kvm_hlt_in_guest(vcpu->kvm);
> > +}
> > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
>
> Paolo, can you explain the reasoning behind this?
>
> Should not be necessary...

Here some new discussions:
https://lkml.org/lkml/2019/6/13/1423
https://lkml.org/lkml/2019/6/13/1420
