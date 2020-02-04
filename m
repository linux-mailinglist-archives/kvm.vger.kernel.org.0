Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3DD151581
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 06:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgBDFfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 00:35:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:62720 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgBDFfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 00:35:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 21:35:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="403678791"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 03 Feb 2020 21:35:52 -0800
Date:   Mon, 3 Feb 2020 21:35:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 6/6] x86: vmx: virtualize split lock detection
Message-ID: <20200204053552.GA31665@linux.intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-7-xiaoyao.li@intel.com>
 <20200203214212.GH19638@linux.intel.com>
 <addf50c8-f683-9176-d6e4-51bc217dcc92@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addf50c8-f683-9176-d6e4-51bc217dcc92@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 10:52:01AM +0800, Xiaoyao Li wrote:
> On 2/4/2020 5:42 AM, Sean Christopherson wrote:
> >On Mon, Feb 03, 2020 at 11:16:08PM +0800, Xiaoyao Li wrote:
> >>
> >>Only when host is sld_off, can guest control the hardware value of
> >>MSR_TEST_CTL, i.e., KVM loads guest's value into hardware when vcpu is
> >>running.

...

> Right, SLD is exposed to the guest only when host is sld_off makes thing
> much simpler. But this seems only meaning for using guest for debugging or
> testing?

Ah, I misunderstood.  I thought the above quote was saying SLD would be
exposed to the guest if it's off in the host, i.e. intended only to reword
the changelog.

Per our offline discussion:

  sld_fatal - MSR_TEST_CTL.SDL is forced on and is sticky from the guest's
              perspective (so the guest can detect a forced fatal mode).

  sld_warn - SLD is exposed to the guest.  MSR_TEST_CTL.SDL is left on
             until an #AC is intercepted with MSR_TEST_CTL.SDL=0 in the
             guest, at which point normal sld_warn rules apply.  If a vCPU
             associated with the task does VM-Enter with MSR_TEST_CTL.SDL=1,
             TIF_SLD is reset and the cycle begins anew.

  sld_off - When set by the guest, MSR_TEST_CTL.SLD is set on VM-Entry
            and cleared on VM-Exit.

Side topic, this means we need more than is_split_lock_detect_enabled(),
but it's probably still a good idea to hide the enum, e.g. have
is_sld_enabled() and is_sld_fatal() wrappers.
 
> >Reiterating everything that was implemented in previous patches does more
> >harm than good.

...

> >>@@ -1934,6 +1960,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>  	u32 index;
> >>  	switch (msr_index) {
> >>+	case MSR_TEST_CTRL:
> >>+		if (!msr_info->host_initiated &&
> >>+		    (!guest_has_feature_split_lock_detect(vcpu) ||
> >>+		     data & ~vmx_msr_test_ctrl_valid_bits(vcpu)))
> >>+			return 1;
> >>+		if (data & MSR_TEST_CTRL_SPLIT_LOCK_DETECT)
> >>+			vmx->disable_split_lock_detect = false;
> >
> >Pretty sure disable_split_lock_detect won't exist, but if it does, don't
> >reuse it for emulating guest behavior.  Keep the two things separate, i.e.
> >use vmx->msr_test_ctrl to track guest state and use the disable_sld to
> >track when the feature has been disabled for an ignorant guest.
> 
> My thought was that when both host and guest are sld_warn.
> If there is a split lock in guest user space,
>  1. #AC trapped in kvm, and re-injected to guest due to guest's MSR bit set;
>  2. Guest clears MSR bit but hardware bit not cleared, re-execute the
> instruction
>  3. #AC trapped again, vmx->disable_sld set to true, vm-enter to guest with
> hardware MSR bit cleared, re-execute the instruction
>  4. After guest user space application finishes/ or scheduled, guest set MSR
> bit, here we'd better clear vmx->disable_sld, otherwise hardware MSR bit
> keeps cleared for this vcpu thread.

Ya, all that works.  But I don't think KVM needs to context switch
MSR_TEST_CTRL in any mode except sld_off.  For sld_fatal, it's simply on.
For sld_warn, it's only disabled when TIF_SLD=1, i.e. after a warning #AC.

I suppose there's a corner case where userspace is multiplexing vCPUs on
tasks, in which case we could end up with TIF_SLD=1 and MSR_TEST_CTRL.SLD=1.
KVM still doesn't need a separate flag, e.g.:

        if (static_cpu_has(...) && vmx->msr_test_control) {
                if (test_thread_flag(TIF_SLD))
                        sld_turn_back_on();
                else if (!is_split_lock_detect_enabled())
                        wrmsrl(MSR_TEST_CTL,
                               this_cpu_read(msr_test_ctl_val) |
                               vmx->msr_test_ctl);
	}

        __vmx_vcpu_run();

        if (static_cpu_has(...) && vmx->msr_test_control &&
            !is_split_lock_detect_enabled())
                wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_val));




> Also, this makes a difference for guest user space application that when it
> scheduled out then scheduled in, the MSR bit is set again while in bare
> metal it keeps cleared. That's why I use pr_warn_ratelimited() in #AC
> interceptor.
