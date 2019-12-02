Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A817B10EEB6
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfLBRrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 12:47:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:12673 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbfLBRrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 12:47:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 09:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="218414545"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 02 Dec 2019 09:47:41 -0800
Date:   Mon, 2 Dec 2019 09:47:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Some cleanups in ioapic.h/lapic.h
Message-ID: <20191202174741.GC4063@linux.intel.com>
References: <20191129163234.18902-1-peterx@redhat.com>
 <20191129163234.18902-2-peterx@redhat.com>
 <87k17fcc14.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k17fcc14.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 10:27:51AM +0100, Vitaly Kuznetsov wrote:
> Peter Xu <peterx@redhat.com> writes:
> 
> > Both kvm_apic_match_dest() and kvm_irq_delivery_to_apic() should
> > probably suite more to lapic.h comparing to ioapic.h, moving.

Please use imperative mode, state *why* the prototypes belong in lapic.h,
and don't hedge, e.g.:

  kvm_apic_match_dest() is defined in lapic.c, move its declaration from
  ioapic.h to lapic.h.

Ditto for the subject:

  KVM: x86: Clean up function declarations in ioapic.h

> > kvm_apic_match_dest() is defined twice, once in each of the header.

s/defined/declared

> > Removing the one defined in ioapic.h.

Again:

  Remove a redundant declaration of kvm_apic_match_dest() from ioapic.h,
  it is declared and defined in lapic.{h,c}.

> kvm_apic_match_dest()'s implementation lives in lapic.c so moving the
> declaration to lapic.h makes perfect sense. kvm_irq_delivery_to_apic()'s
> body is, however, in irq_comm.c and declarations for it are usually
> found in asm/kvm_host.h. I'm not sure but maybe it would make sense to
> move kvm_irq_delivery_to_apic()'s body to lapic.c too.

asm/kvm_host.h is generally used only for exported functions, internal-only
functions for irq_comm.c are declared in arch/x86/kvm/irq.h.

> (Personally, I'd also greatly appreciate if functions working with lapic
> exclusively would have 'lapic' instead of 'apic' in their names. But
> this is unrelated to the patch.)
> 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/ioapic.h | 6 ------
> >  arch/x86/kvm/lapic.h  | 5 ++++-
> >  2 files changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> > index ea1a4e0297da..2fb2e3c80724 100644
> > --- a/arch/x86/kvm/ioapic.h
> > +++ b/arch/x86/kvm/ioapic.h
> > @@ -116,9 +116,6 @@ static inline int ioapic_in_kernel(struct kvm *kvm)
> >  }
> >  
> >  void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
> > -bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
> > -		int short_hand, unsigned int dest, int dest_mode);
> > -int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
> >  void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
> >  			int trigger_mode);
> >  int kvm_ioapic_init(struct kvm *kvm);
> > @@ -126,9 +123,6 @@ void kvm_ioapic_destroy(struct kvm *kvm);
> >  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
> >  		       int level, bool line_status);
> >  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
> > -int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> > -			     struct kvm_lapic_irq *irq,
> > -			     struct dest_map *dest_map);
> >  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
> >  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
> >  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 39925afdfcdc..19b36196e2ff 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -83,7 +83,10 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> >  		       void *data);
> >  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
> >  			   int short_hand, unsigned int dest, int dest_mode);
> > -
> > +int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
> > +int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> > +			     struct kvm_lapic_irq *irq,
> > +			     struct dest_map *dest_map);
> >  bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
> >  bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
> >  void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
> 
> -- 
> Vitaly
> 
