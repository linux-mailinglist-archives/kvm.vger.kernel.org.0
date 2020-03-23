Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E07318F8E4
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 16:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCWPp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 11:45:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:15279 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCWPp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 11:45:57 -0400
IronPort-SDR: u7ZN4ARRIn8F7MchxD9fwYKEgcQj6DabdvWSO1U6JYjlwOcnIxl8icbOdiAyv+Io21fq8Cp805
 sq4bymdjfXaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 08:45:56 -0700
IronPort-SDR: bu1ik5F+bnR7ftr76+AYqs6SQU+gaMwj5hoyqpsiWSdHEg6qDPt3p7v6V7BJ2jXFoZan5rr/QE
 RFjx0wMxztJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,296,1580803200"; 
   d="scan'208";a="249669076"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 23 Mar 2020 08:45:55 -0700
Date:   Mon, 23 Mar 2020 08:45:55 -0700
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
Subject: Re: [PATCH v3 02/37] KVM: nVMX: Validate the EPTP when emulating
 INVEPT(EXTENT_CONTEXT)
Message-ID: <20200323154555.GH28711@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-3-sean.j.christopherson@intel.com>
 <871rpj9lay.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rpj9lay.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 03:51:17PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Signal VM-Fail for the single-context variant of INVEPT if the specified
> > EPTP is invalid.  Per the INEVPT pseudocode in Intel's SDM, it's subject
> > to the standard EPT checks:
> >
> >   If VM entry with the "enable EPT" VM execution control set to 1 would
> >   fail due to the EPTP value then VMfail(Invalid operand to INVEPT/INVVPID);
> >
> > Fixes: bfd0a56b90005 ("nEPT: Nested INVEPT")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 8578513907d7..f3774cef4fd4 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5156,8 +5156,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	switch (type) {
> > -	case VMX_EPT_EXTENT_GLOBAL:
> >  	case VMX_EPT_EXTENT_CONTEXT:
> > +		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
> > +			return nested_vmx_failValid(vcpu,
> > +				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> 
> I was going to ask "and we don't seem to check that current nested VMPTR
> is valid, how can we know that nested_vmx_failValid() is the right
> VMfail() to use" but then I checked our nested_vmx_failValid() and there
> is a fallback there:
> 
> 	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
> 		return nested_vmx_failInvalid(vcpu);
> 
> so this is a non-issue. My question, however, transforms into "would it
> make sense to introduce nested_vmx_fail() implementing the logic from
> SDM:
> 
> VMfail(ErrorNumber):
> 	IF VMCS pointer is valid
> 		THEN VMfailValid(ErrorNumber);
> 	ELSE VMfailInvalid;
> 	FI;
> 

Hmm, I wouldn't be opposed to such a wrapper.  It would pair with
nested_vmx_succeed().

> 
> > +		fallthrough;
> > +	case VMX_EPT_EXTENT_GLOBAL:
> >  	/*
> >  	 * TODO: Sync the necessary shadow EPT roots here, rather than
> >  	 * at the next emulated VM-entry.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
