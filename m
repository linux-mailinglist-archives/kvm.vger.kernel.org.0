Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331C311025F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLCQc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:32:56 -0500
Received: from mga05.intel.com ([192.55.52.43]:6600 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfLCQc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:32:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 08:32:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,273,1571727600"; 
   d="scan'208";a="201056444"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 03 Dec 2019 08:32:55 -0800
Date:   Tue, 3 Dec 2019 08:32:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] KVM: X86: Fix callers of kvm_apic_match_dest() to
 use correct macros
Message-ID: <20191203163255.GA19877@linux.intel.com>
References: <20191202201314.543-1-peterx@redhat.com>
 <20191202201314.543-6-peterx@redhat.com>
 <87r21lbl0c.fsf@vitty.brq.redhat.com>
 <20191203162747.GD17275@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203162747.GD17275@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 11:27:47AM -0500, Peter Xu wrote:
> On Tue, Dec 03, 2019 at 02:23:47PM +0100, Vitaly Kuznetsov wrote:
> > > @@ -250,8 +252,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
> > >  		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
> > >  		    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
> > >  		    index == RTC_GSI) {
> > > -			if (kvm_apic_match_dest(vcpu, NULL, 0,
> > > -			             e->fields.dest_id, e->fields.dest_mode) ||
> > > +			dm = kvm_lapic_irq_dest_mode(e->fields.dest_mode);
> > 
> > Nit: you could've defined 'dm' right here in the block (after '{') but
> > in any case I'd suggest to stick to 'dest_mode' and not shorten it to
> > 'dm' for consistency.
> > 
> > > +			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> > > +						e->fields.dest_id, dm) ||
> > >  			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
> > >  				__set_bit(e->fields.vector,
> > >  					  ioapic_handled_vectors);
> > > diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> > > index 5f59e5ebdbed..e89c2160b39f 100644
> > > --- a/arch/x86/kvm/irq_comm.c
> > > +++ b/arch/x86/kvm/irq_comm.c
> > > @@ -417,7 +417,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
> > >  
> > >  			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
> > >  
> > > -			if (irq.level && kvm_apic_match_dest(vcpu, NULL, 0,
> > > +			if (irq.level &&
> > > +			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> > >  						irq.dest_id, irq.dest_mode))
> > >  				__set_bit(irq.vector, ioapic_handled_vectors);
> > >  		}
> > 
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I'll move the declaration in with your r-b.  'dm' is a silly trick of
> mine to avoid the 80-char line limit.  Thanks,

The 80-char limit isn't an unbreakable rule, it's ok for a line to run a
few chars over when there is no better alternative.
