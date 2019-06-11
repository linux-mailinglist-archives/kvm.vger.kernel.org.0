Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1376E3C5F8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 10:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404650AbfFKIbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 04:31:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44412 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404559AbfFKIbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 04:31:07 -0400
Received: by mail-oi1-f196.google.com with SMTP id e189so8294135oib.11;
        Tue, 11 Jun 2019 01:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=plF9EUw7TyHNpfL0P80Li90/GvbC90xRPW7WbuEGRrw=;
        b=STIBD5QRNrnJjB6ay2PBheCJMGl6Pyi5Kg0oMntu247qVoim2jvzS6o4EQo105McAa
         Xc4qga9Zpevcr4DhgS5B6Ysl4HYkGsYyxZSftYz/CweAvrMSPCuqxacbqVIVr5LisTNt
         oPIMN/YJ+wH4TmdduEfpRY/NPyorGi/Q+QKWRtj10+qWl3v0bpL0r1al6l/nCPkdxffJ
         EkJrcK9zX7qGOcHtHfljEU6sCo7scKO9msNksWKlTH1tYv6XkKLDZYTBUuD0m7YJM8m+
         AgeCo0o8suF0lzXRTLlEwPAF2hrFrC3oMV6PGvNFoj1+wIKzAjpkuGezvGm0EQtxYfen
         H7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=plF9EUw7TyHNpfL0P80Li90/GvbC90xRPW7WbuEGRrw=;
        b=H/M5d56lUIbvtzLHYi49ivdLbbdOSqqgf33GgnWHXJTk6y0s5kZC889xIzTkb1LB0X
         XjYnJc3LLLIpwt+elgl83nN0xUFmVF29UhJ/eGXln/DF6Yu9qYJz1QGDcUBHG1kv07Cy
         I0hrTI28OFQUlmexQntdcTGeKbwBCdLbl0tMkwRsC9lvD4yuhh57tS5u9soN5adgEMKL
         dl1ETV4oCTKPJSs9i3Y/Opl7XGCFWIUJSbF22fnpbsfQF6PnYDr87z5zJIot4DGut3lW
         43f4AI/JjY0UigiEqCCkzPH5hIaD3ZG7H3C9ro+U8BWOAaXJR8udehH90gorOOhyZoqt
         mTUw==
X-Gm-Message-State: APjAAAUob9/OH/kkh0z9TUutKZwZrikIpZmIOMysZEG0iPMbys7KaEYz
        v+2acVmZzlrJFzujaqzeHrj6Dun9EiH4zmz7VdM=
X-Google-Smtp-Source: APXvYqyEVNhVFsRQz4293qyXqjskQmZyc4CWyUAIgmuI3f4psvPMm+87iSGutaET+CEJn/vDwxj7TkDv7ROARuNH040=
X-Received: by 2002:aca:544b:: with SMTP id i72mr14978000oib.174.1560241866957;
 Tue, 11 Jun 2019 01:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
 <1559799086-13912-2-git-send-email-wanpengli@tencent.com> <20190610171110.GB8389@flask>
In-Reply-To: <20190610171110.GB8389@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 16:31:51 +0800
Message-ID: <CANRm+CzgNu7-FOieFqkC3MpnF1GX2dQzfcAuTKAodF4ZdnDmFw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: LAPIC: Make lapic timer unpinned when timer
 is injected by posted-interrupt
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 01:11, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-06-06 13:31+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Make lapic timer unpinned when timer is injected by posted-interrupt,
> > the emulated timer can be offload to the housekeeping cpus.
> >
> > The host admin should fine tuned, e.g. dedicated instances scenario
> > w/ nohz_full cover the pCPUs which vCPUs resident, several pCPUs
> > surplus for housekeeping, disable mwait/hlt/pause vmexits to occupy
> > the pCPUs, fortunately preemption timer is disabled after mwait is
> > exposed to guest which makes emulated timer offload can be possible.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c            | 20 ++++++++++++++++----
> >  arch/x86/kvm/x86.c              |  5 +++++
> >  arch/x86/kvm/x86.h              |  2 ++
> >  include/linux/sched/isolation.h |  2 ++
> >  kernel/sched/isolation.c        |  6 ++++++
> >  5 files changed, 31 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index fcf42a3..09b7387 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -127,6 +127,12 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *=
apic)
> >       return apic->vcpu->vcpu_id;
> >  }
> >
> > +static inline bool posted_interrupt_inject_timer_enabled(struct kvm_vc=
pu *vcpu)
> > +{
> > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +             kvm_mwait_in_guest(vcpu->kvm);
>
> I'm torn about the mwait dependency.  It covers a lot of the targeted
> user base, but the relation is convoluted and not fitting perfectly.
>
> What do you think about making posted_interrupt_inject_timer_enabled()
> just
>
>         pi_inject_timer && kvm_vcpu_apicv_active(vcpu)
>
> and disarming the vmx preemption timer when
> posted_interrupt_inject_timer_enabled(), just like we do with mwait now?

Agreed, thanks for the review. :)

Regards,
Wanpeng Li
