Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C4E1B8525
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 11:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDYJSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 05:18:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:57844 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgDYJSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 05:18:23 -0400
IronPort-SDR: EMoVIatNoVV8QJn/Gfllh449zY/DVPWDRK8OGzoVa+4tQu7FpmCDRnVSM1fGmAQdbjzectvvLH
 vSUBIJ/AkkLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2020 02:18:23 -0700
IronPort-SDR: 0oOyyW0X97JuqAqE90wKs4Ch1mmAj2Sq9D/UuI0fhg3Wh0oPlPjtKxfwWnIHLPw3Wn96LxOaBi
 aw8gwALAxm0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,315,1583222400"; 
   d="scan'208";a="281127171"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 25 Apr 2020 02:18:21 -0700
Date:   Sat, 25 Apr 2020 17:20:21 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for
 vmexit/vmentry
Message-ID: <20200425092021.GB26221@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-4-weijiang.yang@intel.com>
 <20200423171741.GH17824@linux.intel.com>
 <20200424143510.GH24039@local-michael-cet-test>
 <20200424144941.GC30013@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424144941.GC30013@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 07:49:41AM -0700, Sean Christopherson wrote:
> On Fri, Apr 24, 2020 at 10:35:10PM +0800, Yang Weijiang wrote:
> > On Thu, Apr 23, 2020 at 10:17:41AM -0700, Sean Christopherson wrote:
> > > On Thu, Mar 26, 2020 at 04:18:40PM +0800, Yang Weijiang wrote:
> > > > @@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > >  	}
> > > >  
> > > >  	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > > -	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> > > >  		vmx_update_intercept_for_cet_msr(vcpu);
> > > > +
> > > > +		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
> > > > +			vm_entry_controls_setbit(to_vmx(vcpu),
> > > > +						 VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > > +		else
> > > > +			vm_entry_controls_clearbit(to_vmx(vcpu),
> > > > +						   VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > > +
> > > > +		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
> > > > +			vm_exit_controls_setbit(to_vmx(vcpu),
> > > > +						VM_EXIT_LOAD_HOST_CET_STATE);
> > > > +		else
> > > > +			vm_exit_controls_clearbit(to_vmx(vcpu),
> > > > +						  VM_EXIT_LOAD_HOST_CET_STATE);
> > > 
> > > As above, I think this can be done in vmx_set_cr4().
> > >
> > Hmm, it's in vmx_set_cr4() in early versions, OK, will move them back.
> 
> Did I advise you to move them out of vmx_set_cr4()?  It's entirely possible
> I forgot some detail since the last time I reviewed this series.
Things are always changing, I'm willing to change any part of the patch
before it's landed :-).
