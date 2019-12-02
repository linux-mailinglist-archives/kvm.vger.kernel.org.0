Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D7F10EE36
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfLBRbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 12:31:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:24777 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfLBRbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 12:31:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 09:31:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="410506885"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 02 Dec 2019 09:31:52 -0800
Date:   Mon, 2 Dec 2019 09:31:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Fixup kvm_apic_match_dest() dest_mode
 parameter
Message-ID: <20191202173152.GB4063@linux.intel.com>
References: <20191129163234.18902-1-peterx@redhat.com>
 <20191129163234.18902-4-peterx@redhat.com>
 <87mucbcchj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mucbcchj.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 10:18:00AM +0100, Vitaly Kuznetsov wrote:
> Peter Xu <peterx@redhat.com> writes:
> 
> > The problem is the same as the previous patch on that we've got too
> > many ways to define a dest_mode, but logically we should only pass in
> > APIC_DEST_* macros for this helper.
> 
> Using 'the previous patch' in changelog is OK until it comes to
> backporting as the order can change. I'd suggest to spell out "KVM: X86:
> Use APIC_DEST_* macros properly" explicitly.

Even that is bad practice IMO.  Unless there is an explicit dependency on
a previous patch, which does not seem to be the case here, the changelog
should fully describe and justify the patch without referencing a previous
patch/commit.

Case in point, I haven't looked at the previous patch yet and have no idea
why *this* patch is needed or what it's trying to accomplish.

> >
> > To make it easier, simply define dest_mode of kvm_apic_match_dest() to
> > be a boolean to make it right while we can avoid to touch the callers.
> >
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c | 5 +++--
> >  arch/x86/kvm/lapic.h | 2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index cf9177b4a07f..80732892c709 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -791,8 +791,9 @@ static u32 kvm_apic_mda(struct kvm_vcpu *vcpu, unsigned int dest_id,
> >  	return dest_id;
> >  }
> >  
> > +/* Set dest_mode to true for logical mode, false for physical mode */
> >  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
> > -			   int short_hand, unsigned int dest, int dest_mode)
> > +			   int short_hand, unsigned int dest, bool dest_mode)
> >  {
> >  	struct kvm_lapic *target = vcpu->arch.apic;
> >  	u32 mda = kvm_apic_mda(vcpu, dest, source, target);
> > @@ -800,7 +801,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
> >  	ASSERT(target);
> >  	switch (short_hand) {
> >  	case APIC_DEST_NOSHORT:
> > -		if (dest_mode == APIC_DEST_PHYSICAL)
> > +		if (dest_mode == false)
> 
> I must admit this seriously harm the readability of the code for
> me. Just look at the 
> 
>  if (dest_mode == false)
> 
> line without a context and try to say what's being checked. I can't.
> 
> I see to solutions:
> 1) Adhere to the APIC_DEST_PHYSICAL/APIC_DEST_LOGICAL (basically - just
> check against "dest_mode == APIC_DEST_LOGICAL" in the else branch)
> 2) Rename the dest_mode parameter to 'dest_mode_is_phys' or something
> like that.

For #2, it should be "logical" instead of "phys" as APIC_DEST_PHYSICAL is
the zero value.

There's also a third option:

  3) Add a WARN_ON_ONCE and fix the IO APIC callers, e.g.:

	WARN_ON_ONCE(dest_mode != APIC_DEST_PHYSICAL ||
		     dest_mode != APIC_DEST_LOGICAL);

	if (dest_mode == APIC_DEST_PHYSICAL)
		return kvm_apic_match_physical_addr(target, mda);
	else
		return kvm_apic_match_logical_addr(target, mda);

Part of me likes the simplicity of #2, but on the other hand I don't like
the inconsistency with respect to @short_hand and @dest, which take in
"full" values.  E.g. @short_hand would also be problematic for a caller
that uses a bitfield.

Side topic, the I/O APIC callers should explicitly pass APIC_DEST_NOSHORT
instead of 0.

> >  			return kvm_apic_match_physical_addr(target, mda);
> >  		else
> >  			return kvm_apic_match_logical_addr(target, mda);
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 19b36196e2ff..c0b472ed87ad 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -82,7 +82,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
> >  int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> >  		       void *data);
> >  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
> > -			   int short_hand, unsigned int dest, int dest_mode);
> > +			   int short_hand, unsigned int dest, bool dest_mode);
> >  int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
> >  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> >  			     struct kvm_lapic_irq *irq,
> 
> -- 
> Vitaly
> 
