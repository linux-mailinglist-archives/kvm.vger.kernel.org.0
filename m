Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC7D1BD8A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfEMTAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:00:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:13143 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfEMTAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:00:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:00:17 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 13 May 2019 12:00:16 -0700
Date:   Mon, 13 May 2019 12:00:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 4/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL"
 VM-exit control on vmentry of nested guests
Message-ID: <20190513190016.GI28561@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-5-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424231724.2014-5-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 07:17:20PM -0400, Krish Sadhukhan wrote:
> According to section "Checks on Host Control Registers and MSRs" in Intel
> SDM vol 3C, the following check is performed on vmentry of nested guests:
> 
>     "If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, bits reserved
>     in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
>     register."
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 83cd887638cb..d2067370e288 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2595,6 +2595,11 @@ static int nested_check_host_control_regs(struct kvm_vcpu *vcpu,
>  	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
>  	    !nested_cr3_valid(vcpu, vmcs12->host_cr3))
>  		return -EINVAL;
> +
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
> +	   !kvm_valid_perf_global_ctrl(vmcs12->host_ia32_perf_global_ctrl))

If vmcs12->host_ia32_perf_global_ctrl were ever actually consumed, this
needs to ensure L1 isn't able to take control of counters that are owned
by the host.

> +		return -EINVAL;
> +
>  	/*
>  	 * If the load IA32_EFER VM-exit control is 1, bits reserved in the
>  	 * IA32_EFER MSR must be 0 in the field for that register. In addition,
> -- 
> 2.17.2
> 
