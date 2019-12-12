Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36ECD11C195
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfLLAk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:40:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:57723 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbfLLAk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 19:40:58 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 16:40:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="296434047"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 11 Dec 2019 16:40:55 -0800
Date:   Thu, 12 Dec 2019 08:42:16 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 7/7] KVM: X86: Add user-space access interface for CET
 MSRs
Message-ID: <20191212004215.GA17570@local-michael-cet-test.sh.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-8-weijiang.yang@intel.com>
 <20191210215859.GO15758@linux.intel.com>
 <20191211021951.GE12845@local-michael-cet-test>
 <20191211162702.GE5044@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211162702.GE5044@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 08:27:02AM -0800, Sean Christopherson wrote:
> On Wed, Dec 11, 2019 at 10:19:51AM +0800, Yang Weijiang wrote:
> > On Tue, Dec 10, 2019 at 01:58:59PM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2019 at 04:52:22PM +0800, Yang Weijiang wrote:
> > > > There're two different places storing Guest CET states, states
> > > > managed with XSAVES/XRSTORS, as restored/saved
> > > > in previous patch, can be read/write directly from/to the MSRs.
> > > > For those stored in VMCS fields, they're access via vmcs_read/
> > > > vmcs_write.
> > > > 
> > > >  
> > > > +#define CET_MSR_RSVD_BITS_1    0x3
> > > > +#define CET_MSR_RSVD_BITS_2   (0xF << 6)
> > > > +
> > > > +static bool cet_msr_write_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > +{
> > > > +	u32 index = msr->index;
> > > > +	u64 data = msr->data;
> > > > +	u32 high_word = data >> 32;
> > > > +
> > > > +	if ((index == MSR_IA32_U_CET || index == MSR_IA32_S_CET) &&
> > > > +	    (data & CET_MSR_RSVD_BITS_2))
> > > > +		return false;
> > > > +
> > > > +	if (is_64_bit_mode(vcpu)) {
> > > > +		if (is_noncanonical_address(data & PAGE_MASK, vcpu))
> > > 
> > > I don't think this is correct.  MSRs that contain an address usually only
> > > fault on a non-canonical value and do the non-canonical check regardless
> > > of mode.  E.g. VM-Enter's consistency checks on SYSENTER_E{I,S}P only care
> > > about a canonical address and are not dependent on mode, and SYSENTER
> > > itself states that bits 63:32 are ignored in 32-bit mode.  I assume the
> > > same is true here.
> > The spec. reads like this:  Must be machine canonical when written on parts
> > that support 64 bit mode. On parts that do not support 64 bit mode, the bits
> > 63:32 are reserved and must be 0.
> 
> Yes, that agrees with me.  The key word is "support", i.e. "on parts that
> support 64 bit mode" means "on parts with CPUID.0x80000001.EDX.LM=1."
> 
> The reason the architecture works this way is that unless hardware clears
> the MSRs on transition from 64->32, bits 63:32 need to be ignored on the
> way out instead of being validated on the way in, e.g. software writes a
> 64-bit value to the MSR and then transitions to 32-bit mode.  Clearing the
> MSRs would be painful, slow and error prone, so it's easier for hardware
> to simply ignore bits 63:32 in 32-bit mode.
>
Make sense, I'll move the canonical check up to kvm_set_msr() like other
MSRs, thanks!

> > > If that is indeed the case, what about adding these to the common canonical
> > > check in __kvm_set_msr()?  That'd cut down on the boilerplate here and
> > > might make it easier to audit KVM's canonical checks.
> > > 
> > > > +			return false;
> > > > +		else if ((index == MSR_IA32_PL0_SSP ||
> > > > +			  index == MSR_IA32_PL1_SSP ||
> > > > +			  index == MSR_IA32_PL2_SSP ||
> > > > +			  index == MSR_IA32_PL3_SSP) &&
> > > > +			  (data & CET_MSR_RSVD_BITS_1))
> > > > +			return false;
> > > > +	} else {
> > > > +		if (msr->index == MSR_IA32_INT_SSP_TAB)
> > > > +			return false;
> > > > +		else if ((index == MSR_IA32_U_CET ||
> > > > +			  index == MSR_IA32_S_CET ||
> > > > +			  index == MSR_IA32_PL0_SSP ||
> > > > +			  index == MSR_IA32_PL1_SSP ||
> > > > +			  index == MSR_IA32_PL2_SSP ||
> > > > +			  index == MSR_IA32_PL3_SSP) &&
> > > > +			  (high_word & ~0ul))
> > > > +			return false;
> > > > +	}
> > > > +
> > > > +	return true;
> > > > +}
> > > 
> > > This helper seems like overkill, e.g. it's filled with index-specific
> > > checks, but is called from code that has already switched on the index.
> > > Open coding the individual checks is likely more readable and would require
> > > less code, especially if the canonical checks are cleaned up.
> > >
> > I'm afraid if the checks are not wrapped in a helper, there're many
> > repeat checking-code, that's why I'm using a wrapper.
> 
> But you're adding almost as much, if not more, code to re-split the checks
> in this helper.
>
Sure, thanks!

> > > > +
> > > > +static bool cet_msr_access_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > +{
> > > > +	u64 kvm_xss;
> > > > +	u32 index = msr->index;
> > > > +
> > > > +	if (is_guest_mode(vcpu))
> > > > +		return false;
> > > 
> > > I may have missed this in an earlier discussion, does CET not support
> > > nesting?
> > >
> > I don't want to make CET avaible to nested guest at time being, first to
> > make it available to L1 guest first. So I need to avoid exposing any CET
> > CPUID/MSRs to a nested guest.
