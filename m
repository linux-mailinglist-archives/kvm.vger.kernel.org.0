Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1848DA89A6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbfIDPmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:42:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:60189 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfIDPmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:42:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 08:42:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="190207223"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Sep 2019 08:42:32 -0700
Date:   Wed, 4 Sep 2019 08:42:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set
 "launched" state when VM-entry fails
Message-ID: <20190904154231.GB24079@linux.intel.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829205635.20189-4-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 04:56:34PM -0400, Krish Sadhukhan wrote:
> Bit# 31 in VM-exit reason is set by hardware in both cases of early VM-entry
> failures and VM-entry failures due to invalid guest state.

This is incorrect, VMCS.EXIT_REASON is not written on a VM-Fail.  If the
tests are passing, you're probably consuming a stale EXIT_REASON.

> Whenever VM-entry
> fails, the nested VMCS is not in "launched" state any more. Hence,
> __enter_guest() should not set the "launched" state when a VM-entry fails.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  x86/vmx.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 872ba11..183d11b 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1805,6 +1805,8 @@ static void check_for_guest_termination(void)
>   */
>  static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>  {
> +	bool vm_entry_failure;
> +
>  	TEST_ASSERT_MSG(v2_guest_main,
>  			"Never called test_set_guest_func!");
>  
> @@ -1812,15 +1814,14 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>  			"Called enter_guest() after guest returned.");
>  
>  	vmx_enter_guest(failure);
> +	vm_entry_failure = vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE;

Rather than duplicating the code in vmx_run(), what if we move this check
into vmx_enter_guest() and rework struct vmentry_failure?  The code was
originally designed to handle only VM-Fail conditions, we should clean it
up instead of bolting more stuff on top.  E.g.:

struct vmentry_status {
	/* Did we attempt VMLAUNCH or VMRESUME */ 
	bool vmlaunch;
	/* Instruction mnemonic (for convenience). */
	const char *instr;
	/* VM-Enter passed all consistency checks, i.e. did not fail. */
	bool succeeded;
	/* VM-Enter failed before loading guest state, i.e. VM-Fail. */
	bool vm_fail;
	/* Contents of RFLAGS on VM-Fail, EXIT_REASON on VM-Exit.  */
	union {
		unsigned long vm_fail_flags;
		unsigned long vm_exit_reason;
	};
};

static void vmx_enter_guest(struct vmentry_status *status)
{
	status->vm_fail = 0;

	in_guest = 1;
	asm volatile (
		"mov %[HOST_RSP], %%rdi\n\t"
		"vmwrite %%rsp, %%rdi\n\t"
		LOAD_GPR_C
		"cmpb $0, %[launched]\n\t"
		"jne 1f\n\t"
		"vmlaunch\n\t"
		"jmp 2f\n\t"
		"1: "
		"vmresume\n\t"
		"2: "
		SAVE_GPR_C
		"pushf\n\t"
		"pop %%rdi\n\t"
		"mov %%rdi, %[vm_fail_flags]\n\t"
		"movl $1, %[vm_fail]\n\t"
		"jmp 3f\n\t"
		"vmx_return:\n\t"
		SAVE_GPR_C
		"3: \n\t"
		: [vm_fail]"+m"(status->vm_fail),
		  [vm_fail_flags]"=m"(status->vm_fail_flags)
		: [launched]"m"(launched), [HOST_RSP]"i"(HOST_RSP)
		: "rdi", "memory", "cc"
	);
	in_guest = 0;

	if (!status->vm_fail)
		status->vm_exit_reason = vmcs_read(EXI_REASON);
		
	status->succeeded = !status->vm_fail &&
			    !(status->vm_exit_reason & VMX_ENTRY_FAILURE);

	status->vmlaunch = !launched;
	status->instr = launched ? "vmresume" : "vmlaunch";

	if (status->succeeded)
		launched = 1;
}

>  	if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
> -	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
> -	    vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
> -
> +	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE && vm_entry_failure)) {
>  		print_vmentry_failure_info(failure);
>  		abort();
>  	}
>  
> -	if (!failure->early) {
> +	if (!vm_entry_failure) {
>  		launched = 1;
>  		check_for_guest_termination();
>  	}
> -- 
> 2.20.1
> 
