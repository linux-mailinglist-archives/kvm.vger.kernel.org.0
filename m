Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9B1769AA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCCA52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:57:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:28810 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgCCA52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 19:57:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 16:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233579149"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 16:57:27 -0800
Date:   Mon, 2 Mar 2020 16:57:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
Message-ID: <20200303005727.GB27842@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com>
 <CALMp9eTNY0Wd=Wc=b8xzg0xRYE-ht5m=+cZeEb7nZup6EdYhCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTNY0Wd=Wc=b8xzg0xRYE-ht5m=+cZeEb7nZup6EdYhCg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 01:59:10PM -0800, Jim Mattson wrote:
> On Mon, Mar 2, 2020 at 11:57 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Extend the mask in cpuid_function_in_range() for finding the "class" of
> > the function to 0xfffffff00.  While there is no official definition of
> > what constitutes a class, e.g. arguably bits 31:16 should be the class
> > and bits 15:0 the functions within that class, the Hypervisor logic
> > effectively uses bits 31:8 as the class by virtue of checking for
> > different bases in increments of 0x100, e.g. KVM advertises its CPUID
> > functions starting at 0x40000100 when HyperV features are advertised at
> > the default base of 0x40000000.
> 
> This convention deserves explicit documentation outside of the commit message.

No argument there.
 
> > Masking against 0x80000000 only handles basic and extended leafs, which
> > results in Centaur and Hypervisor range checks being performed against
> > the basic CPUID range, e.g. if CPUID.0x40000000.EAX=0x4000000A and there
> > is no entry for CPUID.0x40000006, then function 0x40000006 would be
> > incorrectly reported as out of bounds.
> >
> > The bad range check doesn't cause function problems for any known VMM
> > because out-of-range semantics only come into play if the exact entry
> > isn't found, and VMMs either support a very limited Hypervisor range,
> > e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
> > room for undefined leafs) or explicitly defines gaps to be zero, e.g.
> > Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
> > limits (the latter comes into play when providing HyperV features).
> 
> Does Centaur implement the bizarre Intel behavior for out-of-bound
> entries? It seems that if there are Centaur leaves defined, the CPUD
> semantics should be those specified by Centaur.

Ah, right, because this code triggers on !=AMD, not ==Intel.  Your guess
is as good as mine, I've dug around a few times trying to track down a spec
for Centaur/VIA without success.

I would say that KVM's emulation behavior should probably be all or
nothing, i.e. either due Intel's silly logic for all ranges/classes or do
it for none.

> > The bad behavior can be visually confirmed by dumping CPUID output in
> > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > without defining zeroed entries for 0x40000002 - 0x4000000f.
> >
> > Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 6be012937eba..c320126e0118 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -993,7 +993,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
> >  {
> >         struct kvm_cpuid_entry2 *max;
> >
> > -       max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> > +       max = kvm_find_cpuid_entry(vcpu, function & 0xffffff00u, 0);
> 
> This assumes that CPUID.(function & 0xffffff00):EAX always contains
> the maximum input value for the 256-entry range sharing the high 24
> bits. I don't believe that convention has ever been established or
> documented.

Not sure if it's formally documented, but it's well established.  The
closest thing I could find to documentation is the lkml thread where what's
implemented today (AFAICT) was proposed.

https://lore.kernel.org/lkml/48E3BBC1.2050607@goop.org/


The relevant linux code in Linux (arch/x86/include/asm/processor.h), where
@leaves contains the kernel's required minimum leaf to enable paravirt
stuff for the hypervisor.

static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
{
        uint32_t base, eax, signature[3];

        for (base = 0x40000000; base < 0x40010000; base += 0x100) {
                cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);

                if (!memcmp(sig, signature, 12) &&
                    (leaves == 0 || ((eax - base) >= leaves)))
                        return base;
        }

        return 0;
}

> >         return max && function <= max->eax;
> >  }
> >
> > --
> > 2.24.1
> >
