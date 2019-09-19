Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE1B825C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 22:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404464AbfISUWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 16:22:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:61633 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387854AbfISUWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 16:22:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 13:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,526,1559545200"; 
   d="scan'208";a="362636810"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 19 Sep 2019 13:22:35 -0700
Date:   Thu, 19 Sep 2019 13:22:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com
Subject: Re: [kvm-unit-tests PATCH v5 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190919202235.GE30495@linux.intel.com>
References: <20190918222354.184162-1-marcorr@google.com>
 <20190918222354.184162-2-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918222354.184162-2-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 03:23:54PM -0700, Marc Orr wrote:

...

> +static void atomic_switch_msr_limit_test_guest(void)
> +{
> +	vmcall();

I finally dug into the weird double-enter_guest().  Rather than re-enter
the guest to cleanup, just remove this vmcall() so that the first VM-Enter
invokes hypercall() with HYPERCALL_VMEXIT to set guest_finished.

enter_guest() will verify VM-Enter succeeded, and the guest_finished check
verifies the guest did a VMCALL.  I don't see any added value in an extra
VMCALL.

> +}
> +
> +static void populate_msr_list(struct vmx_msr_entry *msr_list,
> +			      size_t byte_capacity, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		msr_list[i].index = MSR_IA32_TSC;
> +		msr_list[i].reserved = 0;
> +		msr_list[i].value = 0x1234567890abcdef;
> +	}
> +
> +	memset(msr_list + count, 0xff,
> +	       byte_capacity - count * sizeof(*msr_list));
> +}
> +
> +static int max_msr_list_size(void)
> +{
> +	u32 vmx_misc = rdmsr(MSR_IA32_VMX_MISC);
> +	u32 factor = ((vmx_misc & GENMASK(27, 25)) >> 25) + 1;
> +
> +	return factor * 512;
> +}
> +
> +static void atomic_switch_msrs_test(int count)
> +{
> +	struct vmx_msr_entry *vm_enter_load;
> +	struct vmx_msr_entry *vm_exit_load;
> +	struct vmx_msr_entry *vm_exit_store;
> +	int max_allowed = max_msr_list_size();
> +	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
> +	/* KVM signals VM-Abort if an exit MSR list exceeds the max size. */
> +	int exit_count = MIN(count, max_allowed);
> +
> +	/*
> +	 * Check for the IA32_TSC MSR,
> +	 * available with the "TSC flag" and used to populate the MSR lists.
> +	 */
> +	if (!(cpuid(1).d & (1 << 4))) {
> +		report_skip(__func__);
> +		return;
> +	}
> +
> +	/* Set L2 guest. */
> +	test_set_guest(atomic_switch_msr_limit_test_guest);
> +
> +	/* Setup atomic MSR switch lists. */
> +	vm_enter_load = alloc_pages(msr_list_page_order);
> +	vm_exit_load = alloc_pages(msr_list_page_order);
> +	vm_exit_store = alloc_pages(msr_list_page_order);
> +
> +	vmcs_write(ENTER_MSR_LD_ADDR, (u64)vm_enter_load);
> +	vmcs_write(EXIT_MSR_LD_ADDR, (u64)vm_exit_load);
> +	vmcs_write(EXIT_MSR_ST_ADDR, (u64)vm_exit_store);
> +
> +	/*
> +	 * VM-Enter should succeed up to the max number of MSRs per list, and
> +	 * should not consume junk beyond the last entry.
> +	 */
> +	populate_msr_list(vm_enter_load, byte_capacity, count);
> +	populate_msr_list(vm_exit_load, byte_capacity, exit_count);
> +	populate_msr_list(vm_exit_store, byte_capacity, exit_count);
> +
> +	vmcs_write(ENT_MSR_LD_CNT, count);
> +	vmcs_write(EXI_MSR_LD_CNT, exit_count);
> +	vmcs_write(EXI_MSR_ST_CNT, exit_count);
> +
> +	if (count <= max_allowed) {
> +		enter_guest();
> +		skip_exit_vmcall();

If vmcall() is removed, this skip and the one in the else{} can be dropped.

> +	} else {
> +		u32 exit_reason;
> +		u32 exit_reason_want;
> +		u32 exit_qual;
> +
> +		enter_guest_with_invalid_guest_state();
> +
> +		exit_reason = vmcs_read(EXI_REASON);
> +		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> +		report("exit_reason, %u, is %u.",
> +		       exit_reason == exit_reason_want, exit_reason,
> +		       exit_reason_want);
> +
> +		exit_qual = vmcs_read(EXI_QUALIFICATION);
> +		report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
> +		       exit_qual, max_allowed + 1);
> +
> +		/*
> +		 * Re-enter the guest with valid counts
> +		 * and proceed past the single vmcall instruction.
> +		 */

Nit: "Re-enter the guest" should either be "Retry VM-Enter" or simply
     "Enter".  The reason this code exists is that we never actually
     entered the guest :-)

     E.g. if you drop the vmcall():

		/* Enter the guest (with valid counts) to set guest_finished. */

> +		vmcs_write(ENT_MSR_LD_CNT, 0);
> +		vmcs_write(EXI_MSR_LD_CNT, 0);
> +		vmcs_write(EXI_MSR_ST_CNT, 0);
> +		enter_guest();
> +		skip_exit_vmcall();
> +	}
> +
> +	/* Cleanup. */
> +	enter_guest();
> +	skip_exit_vmcall();
> +	free_pages_by_order(vm_enter_load, msr_list_page_order);
> +	free_pages_by_order(vm_exit_load, msr_list_page_order);
> +	free_pages_by_order(vm_exit_store, msr_list_page_order);
> +}
> +
> +static void atomic_switch_max_msrs_test(void)
> +{
> +	atomic_switch_msrs_test(max_msr_list_size());
> +}
> +
> +static void atomic_switch_overflow_msrs_test(void)
> +{
> +	atomic_switch_msrs_test(max_msr_list_size() + 1);
> +}
>  
>  #define TEST(name) { #name, .v2 = name }
>  
> @@ -8660,5 +8791,8 @@ struct vmx_test vmx_tests[] = {
>  	TEST(ept_access_test_paddr_read_execute_ad_enabled),
>  	TEST(ept_access_test_paddr_not_present_page_fault),
>  	TEST(ept_access_test_force_2m_page),
> +	/* Atomic MSR switch tests. */
> +	TEST(atomic_switch_max_msrs_test),
> +	TEST(atomic_switch_overflow_msrs_test),
>  	{ NULL, NULL, NULL, NULL, NULL, {0} },
>  };
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
