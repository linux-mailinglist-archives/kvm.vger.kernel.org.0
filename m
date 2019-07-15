Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A3268803
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 13:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbfGOLPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 07:15:46 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40823 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbfGOLPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 07:15:46 -0400
Received: by mail-ot1-f67.google.com with SMTP id y20so581924otk.7;
        Mon, 15 Jul 2019 04:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vK1EJ0Smk9pXngHgA0jbq10uDF/odQe70t91y6XYjW0=;
        b=irVWGx/JbfrIHNKOdi4NZAj1LcPRC1dF96HOO3CTIhHBKa0JhFoRG1egyswiRVblV3
         qwG1kaMC4CND+4tTSUugXr3774mIsIBOvm5/aHmmTjbrK2f8+ieCB72hhQ1jws/kbjxb
         hdzCTu3ihFqriRpPhQHxarsaeu+noCUgHITYbRLmo9yW3QZRaOK+4f0UqKzxjToov72U
         Lh9NbAH9/Wx0JfiwjW5vpCmtSBN6OTtvjeRtOh9QYipwdsSk2d6TztC4HuVtxk3qtqkD
         nc+FezZhPUWY4G8ff5FOCqYRmEyOiJT3ysQPmia56iElmrVcIgw1wcvYaA1UTEcKm3J5
         DXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vK1EJ0Smk9pXngHgA0jbq10uDF/odQe70t91y6XYjW0=;
        b=LcCl7GyKyqDuz6zMsDf0mBAL7nOuNrhQn/eGW4xdLWWFwjkSmpnzkFzDLd09NcJvpR
         UjTTm4RDEmQshs1SUERAtGncAwq/TvizJ56WsZPYOfC8b55EvYhlrhDzCFMahlLmDcHu
         IZtGNKXAz5kam6rXlDW0ARsoMmJBKapITlPPcuD136dTIpFnfzexRl284NJrH41+7Kd/
         UqDB/tPA/IGOo9IYyhlBoulZ4kL13cW7SuiSl8OYz7+wTTEcob6Nhw7+IrmUfWvFIf55
         rXKVCMqpBhYyvG/mIKtAr++Ixhqyz3zLhz0xeJT/YJvgn6elOo+hAtBOXMWaBCp6n8bE
         OW7Q==
X-Gm-Message-State: APjAAAUFsSBPiDgkqCQ3kGNb0xf3QpdP4DgjYE91vx49BMw5t+H5fWg9
        EX+OIyTrVM4YkaG6i1B7hMbh5kpkXi/4IACxssULKuJz
X-Google-Smtp-Source: APXvYqx6jFELxmjiq1pnfkF6W04weLLG3wRgidgkcX7KYwuxd/GsbO3RahMF76SFisErkPa17A5wXEUg8GMUn8hNXZg=
X-Received: by 2002:a9d:1b02:: with SMTP id l2mr1255636otl.45.1563189345011;
 Mon, 15 Jul 2019 04:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <1562915435-8818-1-git-send-email-wanpengli@tencent.com> <326787d2-4cc6-82e5-f158-1e6899e40f63@de.ibm.com>
In-Reply-To: <326787d2-4cc6-82e5-f158-1e6899e40f63@de.ibm.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 15 Jul 2019 19:15:36 +0800
Message-ID: <CANRm+Cy=kOR350gegx=oh08nAQvZ+qzvgpqChUat917+wiWh3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: Boosting vCPUs that are delivering interrupts
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc arm and powerpc people,
On Mon, 15 Jul 2019 at 18:53, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 12.07.19 09:10, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during vcpu=
 wakeup
> > and interrupt delivery), except the lock holder, we want to also boost =
vCPUs
> > that are delivering interrupts. Actually most smp_call_function_many ca=
lls are
> > synchronous ipi calls, the ipi target vCPUs are also good yield candida=
tes.
> > This patch sets preempted flag during wakeup and interrupt delivery tim=
e.
> >
> > Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RA=
M:
> > ebizzy -M
> >
> >             vanilla     boosting    improved
> > 1VM          23000       21232        -9%
> > 2VM           2800        8000       180%
> > 3VM           1800        3100        72%
> >
> > Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs,
> > one running ebizzy -M, the other running 'stress --cpu 2':
> >
> > w/ boosting + w/o pv sched yield(vanilla)
> >
> >             vanilla     boosting   improved
> >                        1570         4000       55%
> >
> > w/ boosting + w/ pv sched yield(vanilla)
> >
> >                       vanilla     boosting   improved
> >              1844         5157       79%
> >
> > w/o boosting, perf top in VM:
> >
> >  72.33%  [kernel]       [k] smp_call_function_many
> >   4.22%  [kernel]       [k] call_function_i
> >   3.71%  [kernel]       [k] async_page_fault
> >
> > w/ boosting, perf top in VM:
> >
> >  38.43%  [kernel]       [k] smp_call_function_many
> >   6.31%  [kernel]       [k] async_page_fault
> >   6.13%  libc-2.23.so   [.] __memcpy_avx_unaligned
> >   4.88%  [kernel]       [k] call_function_interrupt
> This certainly made sense for s390 so I guess that this also makes sense
> for others.
> Nnote we (s390) do not use kvm_vcpu_kick, so this should not cause
> any issue for s390.
>
>
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  virt/kvm/kvm_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b4ab59d..2c46705 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> >       int me;
> >       int cpu =3D vcpu->cpu;
> >
> > -     if (kvm_vcpu_wake_up(vcpu))
> > +     if (kvm_vcpu_wake_up(vcpu)) {
> > +             vcpu->preempted =3D true;
> >               return;
> > +     }
> >
> >       me =3D get_cpu();
> >       if (cpu !=3D me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> >
>
