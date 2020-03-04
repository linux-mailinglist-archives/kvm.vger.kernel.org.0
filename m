Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41C1793DA
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgCDPpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 10:45:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:46206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgCDPpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 10:45:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 07:45:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="352130079"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 04 Mar 2020 07:45:39 -0800
Date:   Wed, 4 Mar 2020 07:45:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 7/7] KVM: X86: Add user-space access interface for CET
 MSRs
Message-ID: <20200304154538.GB21662@linux.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-8-weijiang.yang@intel.com>
 <20200303222827.GC1439@linux.intel.com>
 <20200304151815.GD5831@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304151815.GD5831@local-michael-cet-test.sh.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 11:18:15PM +0800, Yang Weijiang wrote:
> On Tue, Mar 03, 2020 at 02:28:27PM -0800, Sean Christopherson wrote:
> > > @@ -1886,6 +1976,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >  		else
> > >  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> > >  		break;
> > > +	case MSR_IA32_S_CET:
> > > +		if (!cet_ctl_access_allowed(vcpu, msr_info))
> > > +			return 1;
> > > +		msr_info->data = vmcs_readl(GUEST_S_CET);
> > > +		break;
> > > +	case MSR_IA32_INT_SSP_TAB:
> > > +		if (!cet_ssp_access_allowed(vcpu, msr_info))
> > > +			return 1;
> > > +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > +		break;
> > > +	case MSR_IA32_U_CET:
> > > +		if (!cet_ctl_access_allowed(vcpu, msr_info))
> > > +			return 1;
> > > +		rdmsrl(MSR_IA32_U_CET, msr_info->data);
> > > +		break;
> > > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > > +		if (!cet_ssp_access_allowed(vcpu, msr_info))
> > > +			return 1;
> > > +		rdmsrl(msr_info->index, msr_info->data);
> > 
> > Ugh, thought of another problem.  If a SoftIRQ runs after an IRQ it can
> > load the kernel FPU state.  So for all the XSAVES MSRs we'll need a helper
> > similar to vmx_write_guest_kernel_gs_base(), except XSAVES has to be even
> > more restrictive and disable IRQs entirely.  E.g.
> > 
> > static void vmx_get_xsave_msr(struct msr_data *msr_info)
> > {
> > 	local_irq_disable();
> > 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> > 		switch_fpu_return();
> > 	rdmsrl(msr_info->index, msr_info->data);
> > 	local_irq_enable();
> In this case, would SoftIRQ destroy vcpu->arch.guest.fpu states which
> had been restored to XSAVES MSRs that we were accessing?

Doing kernel_fpu_begin() from a softirq would swap guest.fpu out of the
CPUs registers.  It sets TIF_NEED_FPU_LOAD to mark the tasks has needing to
reload its FPU state prior to returning to userspace.  So it doesn't
destroy it per se.  The result is that KVM would read/write the CET MSRs
after they're loaded from the kernel's FPU state instead of reading the
MSRs loaded from the guest's FPU state.

> So should we restore
> guest.fpu or? In previous patch, we have restored guest.fpu before
> access the XSAVES MSRs.

There are three different FPU states:

  - kernel
  - userspace
  - guest

RDMSR/WRMSR for CET MSRs need to run while the guest.fpu state is loaded
into the CPU registers[1].  At the beginning of the syscall from userspace,
i.e. the vCPU ioctl(), the task's FPU state[2] holds userspace FPU state.
Patch 6/7 swaps out the userspace state and loads the guest state.

But, if a softirq runs between kvm_load_guest_fpu() and now, and executes
kernel_fpu_begin(), it will swap the guest state (out of CPU registers)
and load the kernel state (into PCU registers).  The actual RDMSR/WRMSR
needs to ensure the guest state is still loaded by checking and handling
TIF_NEED_FPU_LOAD.

[1] An alternative to doing switch_fpu_return() on TIF_NEED_FPU_LOAD would
    be to calculate the offset into the xsave and read/write directly
    to/from memory.  But IMO that's unnecessary complexity as the guest's
    fpu state still needs to be reloaded before re-entering the guest, e.g.
    if vmx_{g,s}et_msr() is invoked on {RD,WR}MSR intercept, while loading
    or saving MSR state from userspace isn't a hot path.

[2] I worded this to say "task's FPU state" because it's also possible the
    CPU registers hold kernel state at the beginning of the vCPU ioctl(),
    e.g. because of softirq.
