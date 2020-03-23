Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25CD18F99F
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgCWQYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:24:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:34255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgCWQYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:24:39 -0400
IronPort-SDR: HcBSzj9ijTKrdAFhkbiKhwgpC1LWpzLV0Tg0Aa2eSDxXIbBG7R/UojpG8ZRnq+qL8JWnGE2yJ+
 t7sFUs2DF56g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:24:34 -0700
IronPort-SDR: ILxdQq3+j9Vnb0zCRl2g3RbrQ/rEFfNL+NiB/AhCXo3ug7V9WcN3CMUcLGYSGlc4vQNmCJEc1x
 4RwWn8KfWJsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="447444518"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 23 Mar 2020 09:24:33 -0700
Date:   Mon, 23 Mar 2020 09:24:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 05/37] KVM: x86: Export kvm_propagate_fault() (as
 kvm_inject_emulated_page_fault)
Message-ID: <20200323162433.GM28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-6-sean.j.christopherson@intel.com>
 <87sghz844a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sghz844a.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 04:47:49PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e54c6ad628a8..64ed6e6e2b56 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -611,8 +611,11 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
> >  
> > -static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
> > +bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> > +				    struct x86_exception *fault)
> >  {
> > +	WARN_ON_ONCE(fault->vector != PF_VECTOR);
> > +
> >  	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
> >  		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
> >  	else
> > @@ -620,6 +623,7 @@ static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fau
> >  
> >  	return fault->nested_page_fault;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
> 
> We don't seem to use the return value a lot, actually,
> inject_emulated_exception() seems to be the only one, the rest just call
> it without checking the return value. Judging by the new name, I'd guess
> that the function returns whether it was able to inject the exception or
> not but this doesn't seem to be the case. My suggestion would then be to
> make it return 'void' and return 'fault->nested_page_fault' separately
> in inject_emulated_exception().

Oooh, I like that idea.  The return from the common helper also confuses me
every time I look at it.

> >  void kvm_inject_nmi(struct kvm_vcpu *vcpu)
> >  {
> > @@ -6373,7 +6377,7 @@ static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
> >  {
> >  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> >  	if (ctxt->exception.vector == PF_VECTOR)
> > -		return kvm_propagate_fault(vcpu, &ctxt->exception);
> > +		return kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
> >  
> >  	if (ctxt->exception.error_code_valid)
> >  		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
> 
> With or without the change suggested above,
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
