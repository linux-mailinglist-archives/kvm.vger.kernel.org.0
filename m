Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6AB2342
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 17:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390808AbfIMPYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 11:24:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:45794 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbfIMPYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 11:24:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 08:24:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="360789583"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 13 Sep 2019 08:24:42 -0700
Date:   Fri, 13 Sep 2019 08:24:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
Message-ID: <20190913152442.GC31125@linux.intel.com>
References: <20190912180928.123660-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912180928.123660-1-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 11:09:28AM -0700, Marc Orr wrote:
> Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
> list) at the maximum number of MSRs supported, as described in the SDM,
> in the appendix chapter titled "MISCELLANEOUS DATA".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  x86/vmx_tests.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24a771a..b3b4d5f7cc8f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -2718,6 +2718,11 @@ static void ept_reserved_bit(int bit)
>  #define PAGE_2M_ORDER 9
>  #define PAGE_1G_ORDER 18
>  
> +static void *alloc_2m_page(void)
> +{
> +	return alloc_pages(PAGE_2M_ORDER);
> +}

Allocating 2mb pages is complete overkill.  The absolute theoretical max
for the number of MSRs is (8 * 512) = 4096, for a total of 32kb per list.
We can even show the math so that it's obvious how the size is calculated.
Plus one order so we can test overrun.

/*
 * The max number of MSRs is specified in 3 bits bits, plus 1. I.e. 7+1==8.
 * Allocate 64k bytes of data to cover max_msr_list_size and then some.
 */
static const u32 msr_list_page_order = 4;

> +
>  static void *get_1g_page(void)
>  {
>  	static void *alloc;
> @@ -8570,6 +8575,138 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
>  	return VMX_TEST_VMEXIT;
>  }
>  
> +enum atomic_switch_msr_scenario {
> +	VM_ENTER_LOAD,
> +	VM_EXIT_LOAD,
> +	VM_EXIT_STORE,
> +	ATOMIC_SWITCH_MSR_SCENARIO_END,
> +};

How about:

enum atomic_switch_msr_lists {
	VM_ENTER_LOAD,
	VM_EXIT_LOAD,
	VM_EXIT_STORE,
	NR_ATOMIC_SWITCH_MSR_LISTS,
};

IMO that yields a much more intuitive test loop:

	for (i = 0; i < NR_ATOMIC_SWITCH_MSR_LISTS; i++) {
	}

But we probably don't even need a loop...

> +
> +static void atomic_switch_msr_limit_test_guest(void)
> +{
> +	vmcall();
> +}
> +
> +static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		msr_list[i].index = MSR_IA32_TSC;
> +		msr_list[i].reserved = 0;
> +		msr_list[i].value = 0x1234567890abcdef;

Maybe overkill, but we can use a fast string op for this.  I think
I got the union right?

static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
{
	union {
		struct vmx_msr_entry msr;
		u64 val;
	} tmp;

	tmp.msr.index = MSR_IA32_TSC;
	tmp.msr.reserved = 0;
	tmp.msr.value = 0x1234567890abcdef;

	asm volatile (
		"rep stosq\n\t"
		: "=c"(count), "=D"(msr_list)
		: "a"(tmp.val), "c"(count), "D"(msr_list)
		: "memory"
	);
}

> +	}
> +}
> +
> +static void configure_atomic_switch_msr_limit_test(
> +		struct vmx_msr_entry *test_msr_list, int count)
> +{
> +	struct vmx_msr_entry *msr_list;
> +	const u32 two_mb = 1 << 21;
> +	enum atomic_switch_msr_scenario s;
> +	enum Encoding addr_field;
> +	enum Encoding cnt_field;
> +
> +	for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {
> +		switch (s) {
> +		case VM_ENTER_LOAD:
> +			addr_field = ENTER_MSR_LD_ADDR;
> +			cnt_field = ENT_MSR_LD_CNT;
> +			break;
> +		case VM_EXIT_LOAD:
> +			addr_field = EXIT_MSR_LD_ADDR;
> +			cnt_field = EXI_MSR_LD_CNT;
> +			break;
> +		case VM_EXIT_STORE:
> +			addr_field = EXIT_MSR_ST_ADDR;
> +			cnt_field = EXI_MSR_ST_CNT;
> +			break;
> +		default:
> +			TEST_ASSERT(false);
> +		}
> +
> +		msr_list = (struct vmx_msr_entry *)vmcs_read(addr_field);
> +		memset(msr_list, 0xff, two_mb);

Writing 8mb of data for each test is a waste of time, i.e. 6mb to reset
each list, and another 2mb to populate the target list.

The for-loop in the helper is also confusing and superfluous.

> +		if (msr_list == test_msr_list) {
> +			populate_msr_list(msr_list, count);
> +			vmcs_write(cnt_field, count);
> +		} else {
> +			vmcs_write(cnt_field, 0);
> +		}
> +	}
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
> +static void atomic_switch_msr_limit_test(void)
> +{
> +	struct vmx_msr_entry *msr_list;
> +	enum atomic_switch_msr_scenario s;
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
> +	msr_list = alloc_2m_page();
> +	vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(msr_list));
> +	msr_list = alloc_2m_page();
> +	vmcs_write(EXIT_MSR_LD_ADDR, virt_to_phys(msr_list));
> +	msr_list = alloc_2m_page();
> +	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(msr_list));

This memory should really be freed.  Not holding pointers for each list
also seems silly, e.g. requires a VMREAD just to get a pointer.

> +
> +	/* Execute each test case. */
> +	for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {

Since you're testing the passing case, why not test all three at once?
I.e. hammer KVM while also consuming less test cycles.  The "MSR switch"
test already verifies the correctness of each list.

> +		struct vmx_msr_entry *msr_list;
> +		int count = max_msr_list_size();
> +
> +		switch (s) {
> +		case VM_ENTER_LOAD:
> +			msr_list = (struct vmx_msr_entry *)vmcs_read(
> +					ENTER_MSR_LD_ADDR);

These should use phys_to_virt() since virt_to_phys() is used to write them.

> +			break;
> +		case VM_EXIT_LOAD:
> +			msr_list = (struct vmx_msr_entry *)vmcs_read(
> +					EXIT_MSR_LD_ADDR);
> +			break;
> +		case VM_EXIT_STORE:
> +			msr_list = (struct vmx_msr_entry *)vmcs_read(
> +					EXIT_MSR_ST_ADDR);
> +			break;
> +		default:
> +			report("Bad test scenario, %d.", false, s);
> +			continue;
> +		}
> +
> +		configure_atomic_switch_msr_limit_test(msr_list, count);

Again, feeding the list into a helper that also iterates over the lists
is not intuitive in terms of understanding what is being tested.

> +		enter_guest();
> +		assert_exit_reason(VMX_VMCALL);
> +	}
> +
> +	/* Reset the atomic MSR switch count to 0 for all three lists. */
> +	configure_atomic_switch_msr_limit_test(0, 0);
> +	/* Proceed past guest's single vmcall instruction. */
> +	enter_guest();
> +	skip_exit_vmcall();
> +	/* Terminate the guest. */
> +	enter_guest();
> +	skip_exit_vmcall();
> +}
> +
>  
>  #define TEST(name) { #name, .v2 = name }
>  
> @@ -8660,5 +8797,7 @@ struct vmx_test vmx_tests[] = {
>  	TEST(ept_access_test_paddr_read_execute_ad_enabled),
>  	TEST(ept_access_test_paddr_not_present_page_fault),
>  	TEST(ept_access_test_force_2m_page),
> +	/* Atomic MSR switch tests. */
> +	TEST(atomic_switch_msr_limit_test),

This is a misleading name, e.g. it took me quite a while to realize this
is testing only the passing scenario.  For me, "limit test" implies that
it'd be deliberately exceeding the limit, or at least testing both the
passing and failing cases.  I suppose we can't easily test the VMX abort
cases, but we can at least test VM_ENTER_LOAD.

Distilling things down to the bare minimum yields something like the
following.

	struct vmx_msr_entry *vm_enter_load;
	struct vmx_msr_entry *vm_exit_load;
	struct vmx_msr_entry *vm_exit_store;
	u32 i, max_allowed;

	max_allowed = max_msr_list_size();

	/* Setup atomic MSR switch lists. */
	vm_enter_load = alloc_pages(msr_list_page_order);
	vm_exit_load = alloc_pages(msr_list_page_order);
	vm_exit_store = alloc_pages(msr_list_page_order);

	populate_msr_list(vm_enter_load, max_allowed + 1);
	populate_msr_list(vm_exit_load,  max_allowed + 1);
	populate_msr_list(vm_exit_store, max_allowed + 1);

	vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(vm_enter_load));
	vmcs_write(EXIT_MSR_LD_ADDR, virt_to_phys(vm_exit_load));
	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(vm_exit_store));

	/*
	 * VM-Enter should fail when exceeing max number of MSRs. The VM-Exit
	 * lists cause VMX abort, so those are currently not tested.
	 */
	vmcs_write(ENT_MSR_LD_CNT, max_allowed + 1);
	vmcs_write(EXI_MSR_LD_CNT, max_allowed);
	vmcs_write(EXI_MSR_ST_CNT, max_allowed);

	helper_function_to_verify_vm_fail();

	/*
	 * VM-Enter should succeed up to the max number of MSRs per list, and
	 * should not consume junk beyond the last entry.
	 */
	vmcs_write(ENT_MSR_LD_CNT, max_allowed);

	/* This pointer arithmetic is probably wrong. */
	memset(vm_enter_load + max_allowed + 1, 0xff, sizeof(*vm_enter_load);
	memset(vm_exit_load  + max_allowed + 1, 0xff, sizeof(*vm_exit_load);
	memset(vm_exit_store + max_allowed + 1, 0xff, sizeof(*vm_exit_store);

	enter_guest();
	assert_exit_reason(VMX_VMCALL);

	<clean up>

>  	{ NULL, NULL, NULL, NULL, NULL, {0} },
>  };
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
