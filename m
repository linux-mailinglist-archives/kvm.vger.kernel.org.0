Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9F9DAC6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 02:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfH0Ame (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 20:42:34 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42689 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfH0Ame (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 20:42:34 -0400
Received: by mail-ot1-f66.google.com with SMTP id j7so17036286ota.9;
        Mon, 26 Aug 2019 17:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B546kMhKUy8z/D0dBPZWv2yG7srEpQ9xVtt3JcGHphA=;
        b=qCkPAgRu9ZQ9liv/liUzT76kXgEIuMmU55XZcELkLfQHEFMMN33BKJLNKhKq9N0rOn
         s/Nv3FFKF+9eZ6JBG9kzvo010hosCwInrSU8XaDJTe6YM/YXHDOsCwSkL7IeGrQ/3PlZ
         3tky/wMW1h++0ObkUB3hxPXP5gx3eqJctCAY71Pd9/WuKjSfA1pCxwVimwBBVi910GUX
         1LeOh7YKeQFwPCjixyJ20HoyJwxdyBIdvmhKripKj3tbE0BMh6+PEl0VoTp7JTfKr4Ar
         /xuskAYTxrRpGr61gdmn1TnAuEbk2nE2ZHMHoFNY7XfILQzknELuWz7JY9hASvI3o6b0
         sE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B546kMhKUy8z/D0dBPZWv2yG7srEpQ9xVtt3JcGHphA=;
        b=c38r/rWttCdVz8oLeWZEML4ng6DGx1HbKQPLpJ17SrS8gpiE8EOQ74FKZDtHLUWwwb
         BPF38ksjCUGVFkqfIKozUj/BbdJqKQ5Kp/NfuyK/bEv1XEU+AbgJSX2NXwVkSaA/GPHA
         cb4K4NOBvNkFXMRNQHaiebmMYoREcRPdAVtBEZgyKtxXmlSyWLg0KNl9ZApypiGy5MsW
         l5bo4PpaPhmV1s103FGikun4xslE1X1SoGQQEmUQzcZntaMFwhZjrmwhvb+L3otegMhK
         VA551zrNRdyxgBGbm0ADBRKf+kN3PUmPErWfAxK/xB1iWBIoeYTfBaHvan8YLO8vDkFZ
         whjg==
X-Gm-Message-State: APjAAAVQvgQd6WHmi5W56zFJnaa36FtIdcGZsjBAM2drdMXP/Gru+XpK
        K9Ca0xMeRqWZiip3IBtz3kx2hOfqnLspcO03p/GzGOyA
X-Google-Smtp-Source: APXvYqxIHyQiKpnJItr9ft22ZV8g+cqcsYHCj7i+cceWeHSAe25OZkF+2FfCTwH+BpIsw+SthAIQtkdbz2o/e5smlu4=
X-Received: by 2002:a05:6830:144b:: with SMTP id w11mr17874315otp.185.1566866553351;
 Mon, 26 Aug 2019 17:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet> <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet>
In-Reply-To: <20190826204045.GA24697@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 27 Aug 2019 08:43:13 +0800
Message-ID: <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc Michael S. Tsirkin,
On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrot=
e:
> > >
> > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > >>
> > > > >> The downside of guest side polling is that polling is performed =
even
> > > > >> with other runnable tasks in the host. However, even if poll in =
kvm
> > > > >> can aware whether or not other runnable tasks in the same pCPU, =
it
> > > > >> can still incur extra overhead in over-subscribe scenario. Now w=
e can
> > > > >> just enable guest polling when dedicated pCPUs are available.
> > > > >>
> > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > >
> > > > > Paolo, Marcelo, any comments?
> > > >
> > > > Yes, it's a good idea.
> > > >
> > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > >
> > > > Paolo
> > >
> >
> > Hi Marcelo,
> >
> > Sorry for the late response.
> >
> > > I think KVM_HINTS_REALTIME is being abused somewhat.
> > > It has no clear meaning and used in different locations
> > > for different purposes.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > KVM_HINTS_REALTIME 0                      guest checks this feature bit=
 to
> >
> > determine that vCPUs are never
> >
> > preempted for an unlimited time
>
> Unlimited time means infinite time, or unlimited time means
> 10s ? 1s ?

The former one I think. There is a discussion here
https://lkml.org/lkml/2018/5/17/612

>
> The previous definition was much better IMO: HINTS_DEDICATED.
>
>
> > allowing optimizations
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Now it disables pv queued spinlock,
>
> OK.
>
> > pv tlb shootdown,
>
> OK.
>
> > pv sched yield
>
> "The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> yield if any of the IPI target vCPUs was preempted. 17% performance
> increasement of ebizzy benchmark can be observed in an over-subscribe
> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> IPI-many since call-function is not easy to be trigged by userspace
> workload)."
>
> This can probably hurt if vcpus are rarely preempted.

That's why I add the KVM_HINTS_REALTIME checking here.

>
> > which are not expected present in vCPUs are never preempted for an
> > unlimited time scenario.
> >
> > >
> > > For example, i think that using pv queued spinlocks and
> > > haltpoll is a desired scenario, which the patch below disallows.
> >
> > So even if dedicated pCPU is available, pv queued spinlocks should
> > still be chose if something like vhost-kthreads are used instead of
> > DPDK/vhost-user.
>
> Can't you enable the individual features you need for optimizing
> the overcommitted case? This is how things have been done historically:
> If a new feature is available, you enable it to get the desired
> performance. x2apic, invariant-tsc, cpuidle haltpoll...
>
> So in your case: enable pv schedyield, enable pv tlb shootdown.

Both of them are used to optimize function-call IPIs. pv sched yield
for call function interrupts, and pv tlb shootdown for tlb
invalidation. So still different here. Our latest testing against an
80 pCPUs host, and three 80 vCPUs VMs, the number is more better than
64 pCPUs host which I used when posting patches:

ebizzy -M
              vanilla    optimized     boost
1VM            31234       34489        10%
2VM             5380       26664       396%
3VM             2967       23140       679%

>
> > kvm adaptive halt-polling will compete with
> > vhost-kthreads, however, poll in guest unaware other runnable tasks in
> > the host which will defeat vhost-kthreads.
>
> It depends on how much work vhost-kthreads needs to do, how successful
> halt-poll in the guest is, and what improvement halt-polling brings.
> The amount of polling will be reduced to zero if polling
> is not successful.

We observe vhost-kthreads compete with vCPUs adaptive halt-polling in
kvm, it hurt performance in over-subscribe product environment,
polling in guest can make it worse.

Regards,
Wanpeng Li
