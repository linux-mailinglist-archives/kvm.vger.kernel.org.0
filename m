Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADC419C836
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390069AbgDBRkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 13:40:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:58433 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388677AbgDBRkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 13:40:24 -0400
IronPort-SDR: opsy7vuXbQnhtgdzGyq/p+etPe9stVLPT+VBEL4k7rxAVcjAW2FO+ItxT7uTL0bA4QhHdjcD/r
 WAW9YcNnNUng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 10:40:23 -0700
IronPort-SDR: DwsXJGbh+AAuswdYAzSTlcqUcw8FrYYYi+l9EiZsKyQU8zHTwwwBotq3rHUvaSuc7Ja76dH59J
 ZcE4FrUI7asw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="240887686"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 02 Apr 2020 10:40:23 -0700
Date:   Thu, 2 Apr 2020 10:40:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Message-ID: <20200402174023.GI13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-4-sean.j.christopherson@intel.com>
 <87sghln6tr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sghln6tr.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 07:19:44PM +0200, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > @@ -4623,6 +4623,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >  
> > +static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
> 
> I used a different function name intentionally so the check for 'guest
> want's split lock #AC' can go there as well once it's sorted.

Heh, IIRC, I advised Xiaoyao to do the opposite so that the injection logic
in the #AC case statement was more or less complete without having to dive
into the helper, e.g. the resulting code looks like this once split-lock is
exposed to the guest:

	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ||
	    guest_cpu_alignment_check_enabled(vcpu) ||
	    guest_cpu_sld_on(vmx)) {
		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
		return 1;
	}

> > +{
> > +	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
> > +	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> > +}
> > +
> >  static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -4688,9 +4694,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  		return handle_rmode_exception(vcpu, ex_no, error_code);
> >  
> >  	switch (ex_no) {
> > -	case AC_VECTOR:
> > -		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> > -		return 1;
> >  	case DB_VECTOR:
> >  		dr6 = vmcs_readl(EXIT_QUALIFICATION);
> >  		if (!(vcpu->guest_debug &
> > @@ -4719,6 +4722,27 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
> >  		kvm_run->debug.arch.exception = ex_no;
> >  		break;
> > +	case AC_VECTOR:
> > +		/*
> > +		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
> > +		 * legacy alignment check enabled.  Pre-check host split lock
> > +		 * turned on to avoid the VMREADs needed to check legacy #AC,
> > +		 * i.e. reflect the #AC if the only possible source is legacy
> > +		 * alignment checks.
> > +		 */
> > +		if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ||
> 
> I think the right thing to do here is to make this really independent of
> that feature, i.e. inject the exception if
> 
>  (CPL==3 && CR0.AM && EFLAGS.AC) || (FUTURE && (GUEST_TEST_CTRL & SLD))
> 
> iow. when its really clear that the guest asked for it. If there is an
> actual #AC with SLD disabled and !(CPL==3 && CR0.AM && EFLAGS.AC) then
> something is badly wrong and the thing should just die. That's why I
> separated handle_guest_split_lock() and tell about that case.

That puts KVM in a weird spot if/when intercepting #AC is no longer
necessary, e.g. "if" future CPUs happen to gain a feature that traps into
the hypervisor (KVM) if a potential near-infinite ucode loop is detected.

The only reason KVM intercepts #AC (before split-lock) is to prevent a
malicious guest from executing a DoS attack on the host by putting the #AC
handler in ring 3.  Current CPUs will get stuck in ucode vectoring #AC
faults more or less indefinitely, e.g. long enough to trigger watchdogs in
the host.

Injecting #AC if and only if KVM is 100% certain the guest wants the #AC
would lead to divergent behavior if KVM chose to not intercept #AC, e.g.
some theoretical unknown #AC source would conditionally result in exits to
userspace depending on whether or not KVM wanted to intercept #AC for
other reasons.

That's why we went with the approach of reflecting #AC unless KVM detected
that the #AC was host-induced.
