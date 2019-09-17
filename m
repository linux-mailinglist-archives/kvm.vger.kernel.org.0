Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3271BB566B
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfIQTrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 15:47:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:25530 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfIQTrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 15:47:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 12:47:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,517,1559545200"; 
   d="scan'208";a="198801360"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2019 12:47:38 -0700
Date:   Tue, 17 Sep 2019 12:47:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190917194738.GD8804@linux.intel.com>
References: <20190917185753.256039-1-marcorr@google.com>
 <20190917185753.256039-2-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917185753.256039-2-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 11:57:53AM -0700, Marc Orr wrote:
> Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
> list) at the maximum number of MSRs supported, as described in the SDM,
> in the appendix chapter titled "MISCELLANEOUS DATA".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  lib/alloc_page.c  |   5 ++
>  lib/alloc_page.h  |   1 +
>  x86/unittests.cfg |   2 +-
>  x86/vmx_tests.c   | 131 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 97d13395ff08..ed236389537e 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -53,6 +53,11 @@ void free_pages(void *mem, unsigned long size)
>  	spin_unlock(&lock);
>  }
>  
> +void free_pages_by_order(void *mem, unsigned long order)
> +{
> +	free_pages(mem, 1ul << (order + PAGE_SHIFT));
> +}
> +
>  void *alloc_page()
>  {
>  	void *p;
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 5cdfec57a0a8..739a91def979 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -14,5 +14,6 @@ void *alloc_page(void);
>  void *alloc_pages(unsigned long order);
>  void free_page(void *page);
>  void free_pages(void *mem, unsigned long size);
> +void free_pages_by_order(void *mem, unsigned long order);
>  
>  #endif
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d42f3a..05122cf91ea1 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
>  
>  [vmx]
>  file = vmx.flat
> -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
> +extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
>  arch = x86_64
>  groups = vmx
>  
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24a771a..fb665f38b1e5 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8570,6 +8570,134 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
>  	return VMX_TEST_VMEXIT;
>  }
>  
> +/*
> + * The max number of MSRs in an atomic switch MSR list is:
> + * (111B + 1) * 512 = 4096
> + *
> + * Each list entry consumes:
> + * 4-byte MSR index + 4 bytes reserved + 8-byte data = 16 bytes
> + *
> + * Allocate 128 kB to cover max_msr_list_size (i.e., 64 kB) and then some.
> + */
> +static const u32 msr_list_page_order = 5;
> +
> +static void atomic_switch_msr_limit_test_guest(void)
> +{
> +	vmcall();
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
> +        struct vmx_msr_entry *vm_exit_load;
> +        struct vmx_msr_entry *vm_exit_store;

Spaces need to be replaced with tabs.

> +	int max_allowed = max_msr_list_size();
> +	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
> +	/* Exceeding the max MSR list size at exit trigers KVM to abort. */

s/trigers/triggers

The whole sentence kinda is kinda funky.  Maybe

	/* KVM signals VM-Abort if an exit MSR list exceeds the max size. */

> +	int exit_count = count > max_allowed ? max_allowed : count;

If only we had MIN()... ;-)

> +	int cleanup_count = count > max_allowed ? 2 : 1;
> +	int i;
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
> +		assert_exit_reason(VMX_VMCALL);
> +		skip_exit_vmcall();
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
> +	}
> +
> +	/* Cleanup. */
> +	vmcs_write(ENT_MSR_LD_CNT, 0);
> +	vmcs_write(EXI_MSR_LD_CNT, 0);
> +	vmcs_write(EXI_MSR_ST_CNT, 0);
> +	for (i = 0; i < cleanup_count; i++) {
> +		enter_guest();
> +		skip_exit_vmcall();
> +	}

I'm missing something, why do we need to reenter the guest after setting
the count to 0?

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
> @@ -8660,5 +8788,8 @@ struct vmx_test vmx_tests[] = {
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
