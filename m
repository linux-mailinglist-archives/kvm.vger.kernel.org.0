Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E6421F1D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfEQUel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 16:34:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:15353 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfEQUel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 16:34:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 13:34:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,481,1549958400"; 
   d="scan'208";a="172926873"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 17 May 2019 13:34:40 -0700
Date:   Fri, 17 May 2019 13:34:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 4/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL"
 VM-exit control on vmentry of nested guests
Message-ID: <20190517203440.GL15006@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-5-krish.sadhukhan@oracle.com>
 <20190513190016.GI28561@linux.intel.com>
 <2c08cd38-fd7d-da68-7c8d-2c7c93c3a9c8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c08cd38-fd7d-da68-7c8d-2c7c93c3a9c8@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 16, 2019 at 03:07:48PM -0700, Krish Sadhukhan wrote:
> 
> 
> On 05/13/2019 12:00 PM, Sean Christopherson wrote:
> >On Wed, Apr 24, 2019 at 07:17:20PM -0400, Krish Sadhukhan wrote:
> >>According to section "Checks on Host Control Registers and MSRs" in Intel
> >>SDM vol 3C, the following check is performed on vmentry of nested guests:
> >>
> >>     "If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, bits reserved
> >>     in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
> >>     register."
> >>
> >>Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >>Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> >>---
> >>  arch/x86/kvm/vmx/nested.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >>index 83cd887638cb..d2067370e288 100644
> >>--- a/arch/x86/kvm/vmx/nested.c
> >>+++ b/arch/x86/kvm/vmx/nested.c
> >>@@ -2595,6 +2595,11 @@ static int nested_check_host_control_regs(struct kvm_vcpu *vcpu,
> >>  	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
> >>  	    !nested_cr3_valid(vcpu, vmcs12->host_cr3))
> >>  		return -EINVAL;
> >>+
> >>+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
> >>+	   !kvm_valid_perf_global_ctrl(vmcs12->host_ia32_perf_global_ctrl))
> >If vmcs12->host_ia32_perf_global_ctrl were ever actually consumed, this
> >needs to ensure L1 isn't able to take control of counters that are owned
> >by the host.
> 
> Sorry, I didn't understand your concern. Could you please explain how L1 can
> control L0's counters ?

MSR_CORE_PERF_GLOBAL_CTRL isn't virtualized in the sense that there is
only one MSR in hardware (per logical CPU).  Loading an arbitrary value
into hardware on a nested VM-Exit via vmcs12->host_ia32_perf_global_ctrl
means L1 could toggle counters on/off without L0's knowledge.  See
intel_guest_get_msrs() and intel_pmu_set_msr().

Except that your patches don't actually do anything functional with
vmcs12->host_ia32_perf_global_ctrl, hence my confusion over what you're
trying to accomplish.  If KVM advertises VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
to L1, then L1 will think it can use the VMCS field to handle
MSR_CORE_PERF_GLOBAL_CTRL when running L2, e.g. instead of adding
MSR_CORE_PERF_GLOBAL_CTRL to the MSR load lists, which will break L1
(assuming nested PMU works today).
