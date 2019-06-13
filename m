Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F37446FD
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfFMQz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:55:58 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45079 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729983AbfFMBwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 21:52:04 -0400
Received: by mail-ot1-f67.google.com with SMTP id x21so6501214otq.12;
        Wed, 12 Jun 2019 18:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4YLpdO5VcPNfqGuCEmPtti/BB1Ea2T5YKgJiGp1aHp4=;
        b=tj0SOddsC5uFhxIdz4osLZ1oaNMbdtigpjpU9txIBvUrk90XVDrFgislox81vno4HA
         yL4jQxY3zcm6OkKjfBLN1+iwT9dr/DoKHFU1eChU/qA3QV7vOk76Df0PyqQK0BZCriJS
         SWBoQlCiEKqgmew6TS4AtZOTpb/hZNT5UBeV5VDGS7KMDqpVyjZUPFsvlx3sZKMdFFIb
         +9LasJI1iXSd0wiqSiHxyL+qphFlvzDjDeHRJzHIZ9C2u6uRiF1iT4GrnzXinqlNb1uZ
         jxjh607dzjapc+ARLclyIA+EzWR31aK+VAFIxnjbMmytpaVb1xJxAKJVBn0KAJMtkfNR
         TYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4YLpdO5VcPNfqGuCEmPtti/BB1Ea2T5YKgJiGp1aHp4=;
        b=Okk5c2q9lyppwqciv2fPvhmVDqc9MsqecKj81ZRCkvVbAq2GI4pAbIn8muUzk39xYw
         ptU7Bt6LJYU9eWutdiS1DyJ6F3BWsOjjBSwfe2+pBT4F7KU35tqkQCnTP3kbvh8jFzBL
         b4HKM/7JHmzCwZM60IGM28Eg7CPwlJ91aIxVDzvsBPSLTpM1wTY2A0C8ANHK291n9U2A
         RfsX5xqn4aRoOVk+BrxxnkCkplemPnhwOWfbAtmqZNKvR7Q2ZMeCAtrMOe104R2Vt25b
         LKtkIQg2d1XhGnRhE3Bxn/wMJz02ImbilshhMILWoO1Kr5biqg4OCsDC2ey5afd96PMn
         HMug==
X-Gm-Message-State: APjAAAVZuoN/Mq0bL6HugYxx5eAaG1TpqJylhNjDlfdCKFkjct2DRhxU
        XoWrqR9DNHwI1t9XL73p1myXLZX51njZvJR/i3A=
X-Google-Smtp-Source: APXvYqwIBFpXD0PfU+Hlo+MCCYXlsFZv9VFDlSPtmeYGxL/j63XAs/fxFiXUOP6JRjqYGHIiiDP1TTIFY/1pkb/3G9E=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr26184693otk.56.1560390723336;
 Wed, 12 Jun 2019 18:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
 <20190612151447.GD20308@linux.intel.com> <20190612192243.GA23583@flask> <20190612192720.GB23583@flask>
In-Reply-To: <20190612192720.GB23583@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 13 Jun 2019 09:52:45 +0800
Message-ID: <CANRm+CyoweaCXApSivdvicFfHhvdMeUzEK3QWgqjgvZaT7fNQg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jun 2019 at 03:27, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-06-12 21:22+0200, Radim Kr=C4=8Dm=C3=A1=C5=99:
> > 2019-06-12 08:14-0700, Sean Christopherson:
> > > On Wed, Jun 12, 2019 at 05:40:18PM +0800, Wanpeng Li wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > @@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO =
| S_IWUSR);
> > > >  static int __read_mostly lapic_timer_advance_ns =3D -1;
> > > >  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> > > >
> > > > +/*
> > > > + * lapic timer vmentry advance (tscdeadline mode only) in nanoseco=
nds.
> > > > + */
> > > > +u32 __read_mostly vmentry_advance_ns =3D 300;
> > >
> > > Enabling this by default makes me nervous, e.g. nothing guarantees th=
at
> > > future versions of KVM and/or CPUs will continue to have 300ns of ove=
rhead
> > > between wait_lapic_expire() and VM-Enter.
> > >
> > > If we want it enabled by default so that it gets tested, the default
> > > value should be extremely conservative, e.g. set the default to a sma=
ll
> > > percentage (25%?) of the latency of VM-Enter itself on modern CPUs,
> > > VM-Enter latency being the min between VMLAUNCH and VMLOAD+VMRUN+VMSA=
VE.
> >
> > I share the sentiment.  We definitely must not enter the guest before
> > the deadline has expired and CPUs are approaching 5 GHz (in turbo), so
> > 300 ns would be too much even today.
> >
> > I wrote a simple testcase for rough timing and there are 267 cycles
> > (111 ns @ 2.4 GHz) between doing rdtsc() right after
> > kvm_wait_lapic_expire() [1] and doing rdtsc() in the guest as soon as
> > possible (see the attached kvm-unit-test).
>
> I forgot to attach it, pasting here as a patch for kvm-unit-tests.

Thanks for this, Radim. :)

Regards,
Wanpeng Li

>
> ---
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index e612dbe..ceed648 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -58,7 +58,7 @@ tests-common =3D $(TEST_DIR)/vmexit.flat $(TEST_DIR)/ts=
c.flat \
>                 $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
>                 $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.f=
lat \
>                 $(TEST_DIR)/hyperv_connections.flat \
> -               $(TEST_DIR)/umip.flat
> +               $(TEST_DIR)/umip.flat $(TEST_DIR)/vmentry_latency.flat
>
>  ifdef API
>  tests-api =3D api/api-sample api/dirty-log api/dirty-log-perf
> diff --git a/x86/vmentry_latency.c b/x86/vmentry_latency.c
> new file mode 100644
> index 0000000..3859f09
> --- /dev/null
> +++ b/x86/vmentry_latency.c
> @@ -0,0 +1,45 @@
> +#include "x86/vm.h"
> +
> +static u64 get_last_hypervisor_tsc_delta(void)
> +{
> +       u64 a =3D 0, b, c, d;
> +       u64 tsc;
> +
> +       /*
> +        * The first vmcall is there to force a vm exit just before measu=
ring.
> +        */
> +       asm volatile ("vmcall" : "+a"(a), "=3Db"(b), "=3Dc"(c), "=3Dd"(d)=
);
> +
> +       tsc =3D rdtsc();
> +
> +       /*
> +        * The second hypercall recovers the value that was stored when v=
m
> +        * entering to execute the rdtsc()
> +        */
> +       a =3D 11;
> +       asm volatile ("vmcall" : "+a"(a), "=3Db"(b), "=3Dc"(c), "=3Dd"(d)=
);
> +
> +       return tsc - a;
> +}
> +
> +static void vmentry_latency(void)
> +{
> +       unsigned i =3D 1000000;
> +       u64 min =3D -1;
> +
> +       while (i--) {
> +               u64 latency =3D get_last_hypervisor_tsc_delta();
> +               if (latency < min)
> +                       min =3D latency;
> +       }
> +
> +       printf("vm entry latency is %"PRIu64" TSC cycles\n", min);
> +}
> +
> +int main(void)
> +{
> +       setup_vm();
> +       vmentry_latency();
> +
> +       return 0;
> +}
