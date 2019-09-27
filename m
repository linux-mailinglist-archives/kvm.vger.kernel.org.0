Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C765FC073B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfI0OYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:24:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:58764 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfI0OYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:24:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="194497797"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 27 Sep 2019 07:24:04 -0700
Date:   Fri, 27 Sep 2019 07:24:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 2/2] KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS
 is up-to-date
Message-ID: <20190927142404.GB24889@linux.intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-3-sean.j.christopherson@intel.com>
 <87r242547k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r242547k.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 02:11:27PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Skip the VMWRITE to update GUEST_CR3 if CR3 is not available, i.e. has
> > not been read from the VMCS since the last VM-Enter.  If vcpu->arch.cr3
> > is stale, kvm_read_cr3(vcpu) will refresh vcpu->arch.cr3 from the VMCS,
> > meaning KVM will do a VMREAD and then VMWRITE the value it just pulled
> > from the VMCS.
> >
> > Note, this is a purely theoretical change, no instances of skipping
> > the VMREAD+VMWRITE have been observed with this change.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b530950a9c2b..6de09f60edf3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3003,10 +3003,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  
> >  		if (is_guest_mode(vcpu))
> >  			skip_cr3 = true;
> > -		else if (enable_unrestricted_guest || is_paging(vcpu))
> > -			guest_cr3 = kvm_read_cr3(vcpu);
> > -		else
> > +		else if (!enable_unrestricted_guest && !is_paging(vcpu))
> >  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> > +		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> 
> Nit: with 'test_bit(,(ulong *)&vcpu->arch.regs_avail)' spreading more and
> more I'd suggest creating an inline in kvm_cache_regs.h
> (e.g. kvm_vcpu_reg_avail()).

Part of me wants to keep it painful to discourage one-off checks, but
yeah, a helper would be nice.

> > +			guest_cr3 = vcpu->arch.cr3;
> > +		else
> > +			skip_cr3 = true; /* vmcs01.GUEST_CR3 is up-to-date. */
> >  		ept_load_pdptrs(vcpu);
> >  	}
> 
> -- 
> Vitaly
