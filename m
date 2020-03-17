Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12030188CF8
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 19:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQSSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 14:18:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:55252 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQSSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 14:18:33 -0400
IronPort-SDR: VfFCcCbyDSjbbKAqvkq2yMPbiWlKg/8+wVqXTeSHSpfhbvz5IOj81Ghr1ubLDsq+zlbSaT4HFs
 iY6G46qBAePw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 11:18:32 -0700
IronPort-SDR: wyGlBpC71Kj1H0w9Yo5zB1GzVujxVGo8vK+dKfMkzHCDtUIwZF/5ultogDejaJhWStEkOANpGj
 vjGIS0YQT9Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="391152982"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 17 Mar 2020 11:18:32 -0700
Date:   Tue, 17 Mar 2020 11:18:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Subject: Re: [PATCH v2 23/32] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
Message-ID: <20200317181832.GC12959@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-24-sean.j.christopherson@intel.com>
 <0975d43f-42b6-74db-f916-b0995115d726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0975d43f-42b6-74db-f916-b0995115d726@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 17, 2020 at 06:17:59PM +0100, Paolo Bonzini wrote:
> On 17/03/20 05:52, Sean Christopherson wrote:
> > +	nested_vmx_transition_tlb_flush(vcpu, vmcs12);
> > +
> > +	/*
> > +	 * There is no direct mapping between vpid02 and vpid12, vpid02 is
> > +	 * per-vCPU and reused for all nested vCPUs.  If vpid12 is changing
> > +	 * then the new "virtual" VPID will reuse the same "real" VPID,
> > +	 * vpid02, and so needs to be sync'd.  Skip the sync if a TLB flush
> > +	 * has already been requested, but always update the last used VPID.
> > +	 */
> > +	if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu) &&
> > +	    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> > +		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > +		if (!kvm_test_request(KVM_REQ_TLB_FLUSH, vcpu))
> > +			vpid_sync_context(nested_get_vpid02(vcpu));
> >  	}
> 
> Would it make sense to move nested_vmx_transition_tlb_flush into an
> "else" branch?

Maybe?  I tried that at one point, but didn't like making the call to
nested_vmx_transition_tlb_flush() conditional.  My intent is to have
the ...tlb_flush() call be standalone, i.e. logic that is common to all
nested transitions, so that someone can look at the code can easily
(relatively speaking) understand the basic rules for TLB flushing on
nested transitions.

I also tried the oppositie, i.e. putting the above code in an else-branch,
with nested_vmx_transition_tlb_flush() returning true if it requested a
flush.  But that required updating vmx->nested.last_vpid in a separate
flow, which was quite awkward.

> And should this also test that KVM_REQ_TLB_FLUSH_CURRENT is not set?

Doh, yes.
