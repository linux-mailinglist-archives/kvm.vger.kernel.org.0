Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D929F2283B0
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUPZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 11:25:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:23083 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgGUPZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 11:25:20 -0400
IronPort-SDR: LJ6UQTxFH+gM38HxVNQpxYU1Njy2u9rNriqtMszh2WgY+CZ/QMSGSkntRHG6w3bTAt4gYiLiW4
 CgioSaag+FKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="137645099"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="137645099"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 08:25:19 -0700
IronPort-SDR: mF/p4UxI4ru4M2p7zyiCrI6ezEH6Fo+bnChZJ5fWKESaDf83xina32HT96SalctZCIKikmxa6N
 z42EeI5W3pHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="392382633"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jul 2020 08:25:19 -0700
Date:   Tue, 21 Jul 2020 08:25:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Prevent setting the tscdeadline timer if
 the lapic is hw disabled
Message-ID: <20200721152519.GB22083@linux.intel.com>
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
 <87o8o9p356.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8o9p356.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:35:01PM +0200, Vitaly Kuznetsov wrote:
> Wanpeng Li <kernellwp@gmail.com> writes:
> 
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Prevent setting the tscdeadline timer if the lapic is hw disabled.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

A Fixes and/or Cc stable is probably needed for this.

> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 5bf72fc..4ce2ddd 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
> >  {
> >  	struct kvm_lapic *apic = vcpu->arch.apic;
> >  
> > -	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
> > +	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
> >  			apic_lvtt_period(apic))
> >  		return;
> 
> Out of pure curiosity, what is the architectural behavior if I disable
> LAPIC, write to IA32_TSC_DEADLINE and then re-enable LAPIC before the
> timer was supposed to fire?

Intel's SDM reserves the right for the CPU to do whatever it wants :-)

   When IA32_APIC_BASE[11] is set to 0, prior initialization to the APIC
   may be lost and the APIC may return to the state described in Section
   10.4.7.1, “Local APIC State After Power-Up or Reset.”

Practically speaking, resetting APIC state seems like the sane approach,
i.e. KVM should probably call kvm_lapic_reset() when the APIC transitions
from HW enabled -> disabled.  Maybe in a follow-up patch to this one?
