Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3685C96D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfGBGkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 02:40:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43540 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBGkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 02:40:45 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hiCSv-0007m3-QT; Tue, 02 Jul 2019 08:40:33 +0200
Date:   Tue, 2 Jul 2019 08:40:32 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Wanpeng Li <kernellwp@gmail.com>
cc:     Rong Chen <rong.a.chen@intel.com>, Feng Tang <feng.tang@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tipbuild@zytor.com" <tipbuild@zytor.com>,
        "lkp@01.org" <lkp@01.org>, Ingo Molnar <mingo@kernel.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [BUG] kvm: APIC emulation problem - was Re: [LKP] [x86/hotplug]
 ...
In-Reply-To: <CANRm+CyQy+=fzY7jn6Q=q6C4ucHS-Z37rq87sOJT-yO0ECiHFw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1907020837020.1802@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1906250821220.32342@nanos.tec.linutronix.de> <f5c36f89-61bf-a82e-3d3b-79720b2da2ef@intel.com> <alpine.DEB.2.21.1906251330330.32342@nanos.tec.linutronix.de> <20190628063231.GA7766@shbuild999.sh.intel.com>
 <alpine.DEB.2.21.1906280929010.32342@nanos.tec.linutronix.de> <alpine.DEB.2.21.1906290912390.1802@nanos.tec.linutronix.de> <alpine.DEB.2.21.1906301334290.1802@nanos.tec.linutronix.de> <20190630130347.GB93752@shbuild999.sh.intel.com>
 <alpine.DEB.2.21.1906302021320.1802@nanos.tec.linutronix.de> <alpine.DEB.2.21.1907010829590.1802@nanos.tec.linutronix.de> <20190701083654.GB12486@shbuild999.sh.intel.com> <alpine.DEB.2.21.1907011123220.1802@nanos.tec.linutronix.de>
 <d08d55c5-bb02-f832-4306-9daf234428a8@intel.com> <alpine.DEB.2.21.1907012011460.1802@nanos.tec.linutronix.de> <CANRm+CyQy+=fzY7jn6Q=q6C4ucHS-Z37rq87sOJT-yO0ECiHFw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng,

On Tue, 2 Jul 2019, Wanpeng Li wrote:
> On Tue, 2 Jul 2019 at 06:44, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > While that CPU0 hotplug test case is surely an esoteric issue, the APIC
> > emulation is still wrong, Even if the play_dead() code would not enable
> > interrupts then the pending IRR bit would turn into an ISR .. interrupt
> > when the APIC is reenabled on startup.
> 
> >From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
> * Pending interrupts in the IRR and ISR registers are held and require
> masking or handling by the CPU.

Correct.
 
> In your testing, hardware cpu will not respect soft disable APIC when
> IRR has already been set or APICv posted-interrupt is in flight, so we
> can skip soft disable APIC checking when clearing IRR and set ISR,
> continue to respect soft disable APIC when attempting to set IRR.
> Could you try below fix?

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 05d8934..f857a12 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2376,7 +2376,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>      struct kvm_lapic *apic = vcpu->arch.apic;
>      u32 ppr;
> 
> -    if (!apic_enabled(apic))
> +    if (!kvm_apic_hw_enabled(apic))
>          return -1;
> 
>      __apic_update_ppr(apic, &ppr);

Yes. That fixes it and works as expected. Thanks for the quick
resolution. I surely stared at that function, but was not sure how to fix
it proper.

Tested-by: Thomas Gleixner <tglx@linutronix.de>

Please add a Cc: stable... tag when you post the patch.

Thanks,

	tglx
