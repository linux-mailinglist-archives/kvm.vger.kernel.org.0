Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB606DC88C
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDJPdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDJPdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:33:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B036A4EC7
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681140831; x=1712676831;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O9ybTCAaBqEcs5h/5H9XlTnX6AMU0+zhX0uV+lZeFnU=;
  b=k7c+Vbq/2Z5vueOYSyizv1DFqmGHIcmXxFa5pPEBSkZ1EAFjvJbFoSar
   n0wAkIAXFBKUvNsMjeGc7RbBTkAa4dj6IeZPzKMrg+hXl8OdG0xn2C1GC
   3d9pfcLZkjyW1KHGc5K4FIJBznm2fYt7oQMh3EbKD8ZqZMQIK7TkGImJT
   8fu4zjzi+rRWGGzdpcRfuuMAYJkQfzJak6U9M3B5C5QXWc5EY6FCvpapw
   KvrIVWhgbWmuEe/4T7OfqtCyXB9k2J1hz+LEIcZk+RIk0YEEbC9achxtl
   40H204akDUiOnhKARTrZ2QI8YmWypAPAUk56e6bCzNmr5E3qvKyZVZRtj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343386351"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="343386351"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="690805392"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="690805392"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.83]) ([10.254.214.83])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:33:49 -0700
Message-ID: <4799fa94-8918-a620-1f48-3b694cb3d999@linux.intel.com>
Date:   Mon, 10 Apr 2023 23:33:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 2/4] x86: Add test case for LAM_SUP
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
 <20230319082225.14302-3-binbin.wu@linux.intel.com> <ZC5BavtkM5TRa55a@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZC5BavtkM5TRa55a@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/2023 11:50 AM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:22:23PM +0800, Binbin Wu wrote:
>> +#define LAM57_BITS 6
>> +#define LAM48_BITS 15
>> +#define LAM57_MASK	GENMASK_ULL(62, 57)
>> +#define LAM48_MASK	GENMASK_ULL(62, 48)
>> +
>> +struct invpcid_desc {
>> +    u64 pcid : 12;
>> +    u64 rsv  : 52;
>> +    u64 addr : 64;
> u64 addr;
>
>> +
>> +};
>> +static int get_sup_lam_bits(void)
>> +{
>> +	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>> +		return LAM57_BITS;
>> +	else
>> +		return LAM48_BITS;
>> +}
>> +
>> +/* According to LAM mode, set metadata in high bits */
>> +static u64 set_metadata(u64 src, unsigned long lam)
>> +{
>> +	u64 metadata;
>> +
>> +	switch (lam) {
>> +	case LAM57_BITS: /* Set metadata in bits 62:57 */
>> +		metadata = (NONCANONICAL & ((1UL << LAM57_BITS) - 1)) << 57;
>> +		metadata |= (src & ~(LAM57_MASK));
> this can be simplified to
>
> 	return (src & ~LAM47_MASK) | (NONCANONICAL & LAM47_MASK);
>
> and you can pass a mask to set_metadata() and set mask to 0 if LAM isn't
> enabled. Then set_metadata() can be further simplified to
>
> 	return (src & ~mask) | (NONCANONICAL & mask);
>
>> +		break;
>> +	case LAM48_BITS: /* Set metadata in bits 62:48 */
>> +		metadata = (NONCANONICAL & ((1UL << LAM48_BITS) - 1)) << 48;
>> +		metadata |= (src & ~(LAM48_MASK));
>> +		break;
>> +	default:
>> +		metadata = src;
>> +		break;
>> +	}
>> +
>> +	return metadata;
>> +}
>> +
>> +static void cr4_set_lam_sup(void *data)
>> +{
>> +	unsigned long cr4;
>> +
>> +	cr4 = read_cr4();
>> +	write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
>> +}
>> +
>> +static void cr4_clear_lam_sup(void *data)
>> +{
>> +	unsigned long cr4;
>> +
>> +	cr4 = read_cr4();
>> +	write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
>> +}
>> +
>> +static void test_cr4_lam_set_clear(bool lam_enumerated)
>> +{
>> +	bool fault;
>> +
>> +	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>> +	if (lam_enumerated)
>> +		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
>> +		       "Set CR4.LAM_SUP");
>> +	else
>> +		report(fault, "Set CR4.LAM_SUP causes #GP");
>> +
>> +	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
>> +	report(!fault, "Clear CR4.LAM_SUP");
>> +}
>> +
>> +static void do_strcpy(void *mem)
>> +{
>> +	strcpy((char *)mem, "LAM SUP Test string.");
>> +}
>> +
>> +static inline uint64_t test_tagged_ptr(uint64_t arg1, uint64_t arg2,
>> +	uint64_t arg3, uint64_t arg4)
>> +{
>> +	bool lam_enumerated = !!arg1;
>> +	int lam_bits = (int)arg2;
>> +	u64 *ptr = (u64 *)arg3;
>> +	bool la_57 = !!arg4;
>> +	bool fault;
>> +
>> +	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>> +	report(!fault, "strcpy to untagged addr");
>> +
>> +	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
>> +	fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>> +	if (lam_enumerated)
>> +		report(!fault, "strcpy to tagged addr");
>> +	else
>> +		report(fault, "strcpy to tagged addr causes #GP");
> ...
>
>> +
>> +	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
>> +		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
>> +		fault = test_for_exception(GP_VECTOR, do_strcpy, ptr);
>> +		report(fault, "strcpy to non-LAM-canonical addr causes #GP");
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Refer to emulator.c */
>> +static void do_mov_mmio(void *mem)
>> +{
>> +	unsigned long t1, t2;
>> +
>> +	// test mov reg, r/m and mov r/m, reg
>> +	t1 = 0x123456789abcdefull & -1ul;
>> +	asm volatile("mov %[t1], (%[mem])\n\t"
>> +		     "mov (%[mem]), %[t2]"
>> +		     : [t2]"=r"(t2)
>> +		     : [t1]"r"(t1), [mem]"r"(mem)
>> +		     : "memory");
>> +}
>> +
>> +static inline uint64_t test_tagged_mmio_ptr(uint64_t arg1, uint64_t arg2,
>> +	uint64_t arg3, uint64_t arg4)
>> +{
>> +	bool lam_enumerated = !!arg1;
>> +	int lam_bits = (int)arg2;
>> +	u64 *ptr = (u64 *)arg3;
>> +	bool la_57 = !!arg4;
>> +	bool fault;
>> +
>> +	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>> +	report(!fault, "Access MMIO with untagged addr");
>> +
>> +	ptr = (u64 *)set_metadata((u64)ptr, lam_bits);
>> +	fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>> +	if (lam_enumerated)
>> +		report(!fault,  "Access MMIO with tagged addr");
>> +	else
>> +		report(fault,  "Access MMIO with tagged addr causes #GP");
> Maybe make this (and other similar changes) more dense, e.g.,
>
> 	report(fault != lam_enumerated, "Access MMIO with tagged addr")
>
>> +	if (lam_enumerated && (lam_bits==LAM57_BITS) && !la_57) {
>> +		ptr = (u64 *)set_metadata((u64)ptr, LAM48_BITS);
>> +		fault = test_for_exception(GP_VECTOR, do_mov_mmio, ptr);
>> +		report(fault,  "Access MMIO with non-LAM-canonical addr"
>> +		               " causes #GP");
> don't break long strings.
>
>> +	}
> please add a comment to explain the intention of this test.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static void do_invlpg(void *mem)
>> +{
>> +	invlpg(mem);
>> +}
>> +
>> +static void do_invlpg_fep(void *mem)
>> +{
>> +	asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
>> +}
>> +
>> +/* invlpg with tagged address is same as NOP, no #GP */
>> +static void test_invlpg(void *va, bool fep)
>> +{
>> +	bool fault;
>> +	u64 *ptr;
>> +
>> +	ptr = (u64 *)set_metadata((u64)va, get_sup_lam_bits());
>> +	if (fep)
>> +		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
>> +	else
>> +		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
>> +
>> +	report(!fault, "%sINVLPG with tagged addr", fep?"fep: ":"");
>> +}
>> +
>> +static void do_invpcid(void *desc)
>> +{
>> +	unsigned long type = 0;
>> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
>> +
>> +	asm volatile("invpcid %0, %1" :
>> +	                              : "m" (*desc_ptr), "r" (type)
>> +	                              : "memory");
>> +}
>> +
>> +static void test_invpcid(bool lam_enumerated, void *data)
>> +{
>> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *) data;
>> +	int lam_bits = get_sup_lam_bits();
>> +	bool fault;
>> +
>> +	if (!this_cpu_has(X86_FEATURE_PCID) ||
>> +	    !this_cpu_has(X86_FEATURE_INVPCID)) {
>> +		report_skip("INVPCID not supported");
>> +		return;
>> +	}
>> +
>> +	memset(desc_ptr, 0, sizeof(struct invpcid_desc));
>> +	desc_ptr->addr = (u64)data + 16;
> why "+16"? looks you try to avoid invalidating mapping for the descriptor itself.

It's ture, no need to "+16".


>
> how about using a local invpcid_desc?
>
> 	struct invpcid_desc desc = { .addr = data };

The test case is for LAM_SUP, I also want to test the pointer of the 
descriptor.
But in kvm-unit-tests, the stack memory address doesn't obey the rule of 
kernel space address,
so I reuse the memory address.
Maybe I can add a comment to explain why.


Other advices are accepted.



>
>> +
>> +	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>> +	report(!fault, "INVPCID: untagged pointer + untagged addr");
>> +
>> +	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
>> +	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>> +	report(fault, "INVPCID: untagged pointer + tagged addr causes #GP");
>> +
>> +	desc_ptr->addr = (u64)data + 16;
>> +	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
>> +	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>> +	if (lam_enumerated && (read_cr4() & X86_CR4_LAM_SUP))
>> +		report(!fault, "INVPCID: tagged pointer + untagged addr");
>> +	else
>> +		report(fault, "INVPCID: tagged pointer + untagged addr"
>> +		              " causes #GP");
>> +
>> +	desc_ptr = (struct invpcid_desc *)data;
>> +	desc_ptr->addr = (u64)data + 16;
>> +	desc_ptr->addr = set_metadata(desc_ptr->addr, lam_bits);
>> +	desc_ptr = (struct invpcid_desc *)set_metadata((u64)desc_ptr, lam_bits);
>> +	fault = test_for_exception(GP_VECTOR, do_invpcid, desc_ptr);
>> +	report(fault, "INVPCID: tagged pointer + tagged addr causes #GP");
>> +}
>> +
>> +static void test_lam_sup(bool lam_enumerated, bool fep_available)
>> +{
>> +	void *vaddr, *vaddr_mmio;
>> +	phys_addr_t paddr;
>> +	bool fault;
>> +	bool la_57 = read_cr4() & X86_CR4_LA57;
>> +	int lam_bits = get_sup_lam_bits();
>> +
>> +	vaddr = alloc_vpage();
>> +	vaddr_mmio = alloc_vpage();
>> +	paddr = virt_to_phys(alloc_page());
>> +	install_page(current_page_table(), paddr, vaddr);
>> +	install_page(current_page_table(), IORAM_BASE_PHYS, vaddr_mmio);
>> +
>> +	test_cr4_lam_set_clear(lam_enumerated);
>> +
>> +	/* Set for the following LAM_SUP tests */
>> +	if (lam_enumerated) {
>> +		fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>> +		report(!fault && (read_cr4() & X86_CR4_LAM_SUP),
>> +		       "Set CR4.LAM_SUP");
>> +	}
>> +
>> +	test_tagged_ptr(lam_enumerated, lam_bits, (u64)vaddr, la_57);
>> +	test_tagged_mmio_ptr(lam_enumerated, lam_bits, (u64)vaddr_mmio, la_57);
>> +	test_invlpg(vaddr, false);
>> +	test_invpcid(lam_enumerated, vaddr);
>> +
>> +	if (fep_available)
>> +		test_invlpg(vaddr, true);
>> +}
>> +
>> +int main(int ac, char **av)
>> +{
>> +	bool lam_enumerated;
>> +	bool fep_available = is_fep_available();
>> +
>> +	setup_vm();
>> +
>> +	lam_enumerated = this_cpu_has(X86_FEATURE_LAM);
> has_lam?
>
>> +	if (!lam_enumerated)
>> +		report_info("This CPU doesn't support LAM feature\n");
>> +	else
>> +		report_info("This CPU supports LAM feature\n");
>> +
>> +	if (!fep_available)
>> +		report_skip("Skipping tests the forced emulation, "
>> +			    "use kvm.force_emulation_prefix=1 to enable\n");
>> +
>> +	test_lam_sup(lam_enumerated, fep_available);
>> +
>> +	return report_summary();
>> +}
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index f324e32..34b09eb 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -478,3 +478,13 @@ file = cet.flat
>> arch = x86_64
>> smp = 2
>> extra_params = -enable-kvm -m 2048 -cpu host
>> +
>> +[intel-lam]
>> +file = lam.flat
>> +arch = x86_64
>> +extra_params = -enable-kvm -cpu host
>> +
>> +[intel-no-lam]
>> +file = lam.flat
>> +arch = x86_64
>> +extra_params = -enable-kvm -cpu host,-lam
>> -- 
>> 2.25.1
>>
