Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FC755F208
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiF1Xnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 19:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1Xni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 19:43:38 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F7F37A08
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 16:43:36 -0700 (PDT)
Date:   Tue, 28 Jun 2022 16:43:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656459815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iD9bxhnD+YSICtIu8LvsIbymkt3lQEvJM0mEtuYjhPE=;
        b=TK4gj2Rv519E4qzCOGaITxugQWfp+8adRlhp2JUURpxNugn+mwNHPjt8j233/0tNVbux64
        2Jp48OgWF/tFoxFJ0trFrFmxOzVrFUL8fVD8DmswWdFNvKJ/NmcvVgok1TI1fR+Ho4ROMG
        ermU4KO3Ec3i4mFyW0LNWE58JQb9eOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, bgardon@google.com,
        dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YruSIWFCOcKdj4NW@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220624213257.1504783-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Fri, Jun 24, 2022 at 02:32:53PM -0700, Ricardo Koller wrote:
> Add a new test for stage 2 faults when using different combinations of
> guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> and types of faults (e.g., read on hugetlbfs with a hole). The next
> commits will add different handling methods and more faults (e.g., uffd
> and dirty logging). This first commit starts by adding two sanity checks
> for all types of accesses: AF setting by the hw, and accessing memslots
> with holes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/page_fault_test.c   | 695 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |   6 +
>  3 files changed, 702 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index e4497a3a27d4..13b913225ae7 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -139,6 +139,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
> +TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>  TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> new file mode 100644
> index 000000000000..bdda4e3fcdaa
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c

[...]

> +/* Compare and swap instruction. */
> +static void guest_cas(void)
> +{
> +	uint64_t val;
> +
> +	GUEST_ASSERT_EQ(guest_check_lse(), 1);

Why not just GUEST_ASSERT(guest_check_lse()) ?

> +	asm volatile(".arch_extension lse\n"
> +		     "casal %0, %1, [%2]\n"
> +			:: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
> +	val = READ_ONCE(*guest_test_memory);
> +	GUEST_ASSERT_EQ(val, TEST_DATA);
> +}
> +
> +static void guest_read64(void)
> +{
> +	uint64_t val;
> +
> +	val = READ_ONCE(*guest_test_memory);
> +	GUEST_ASSERT_EQ(val, 0);
> +}
> +
> +/* Address translation instruction */
> +static void guest_at(void)
> +{
> +	uint64_t par;
> +	uint64_t paddr;
> +
> +	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
> +	par = read_sysreg(par_el1);

I believe you need explicit synchronization (an isb) before the fault
information is guaranteed visibile in PAR_EL1.

> +	/* Bit 1 indicates whether the AT was successful */
> +	GUEST_ASSERT_EQ(par & 1, 0);
> +	/* The PA in bits [51:12] */
> +	paddr = par & (((1ULL << 40) - 1) << 12);
> +	GUEST_ASSERT_EQ(paddr, memslot[TEST].gpa);
> +}
> +
> +/*
> + * The size of the block written by "dc zva" is guaranteed to be between (2 <<
> + * 0) and (2 << 9), which is safe in our case as we need the write to happen
> + * for at least a word, and not more than a page.
> + */
> +static void guest_dc_zva(void)
> +{
> +	uint16_t val;
> +
> +	asm volatile("dc zva, %0\n"
> +			"dsb ish\n"

nit: use the dsb() macro instead. Extremely minor, but makes it a bit
more obvious to the reader. Or maybe I need to get my eyes checked ;-)

> +			:: "r" (guest_test_memory));
> +	val = READ_ONCE(*guest_test_memory);
> +	GUEST_ASSERT_EQ(val, 0);
> +}
> +
> +/*
> + * Pre-indexing loads and stores don't have a valid syndrome (ESR_EL2.ISV==0).
> + * And that's special because KVM must take special care with those: they
> + * should still count as accesses for dirty logging or user-faulting, but
> + * should be handled differently on mmio.
> + */
> +static void guest_ld_preidx(void)
> +{
> +	uint64_t val;
> +	uint64_t addr = TEST_GVA - 8;
> +
> +	/*
> +	 * This ends up accessing "TEST_GVA + 8 - 8", where "TEST_GVA - 8" is
> +	 * in a gap between memslots not backing by anything.
> +	 */
> +	asm volatile("ldr %0, [%1, #8]!"
> +			: "=r" (val), "+r" (addr));
> +	GUEST_ASSERT_EQ(val, 0);
> +	GUEST_ASSERT_EQ(addr, TEST_GVA);
> +}
> +
> +static void guest_st_preidx(void)
> +{
> +	uint64_t val = TEST_DATA;
> +	uint64_t addr = TEST_GVA - 8;
> +
> +	asm volatile("str %0, [%1, #8]!"
> +			: "+r" (val), "+r" (addr));
> +
> +	GUEST_ASSERT_EQ(addr, TEST_GVA);
> +	val = READ_ONCE(*guest_test_memory);
> +}
> +
> +static bool guest_set_ha(void)
> +{
> +	uint64_t mmfr1 = read_sysreg(id_aa64mmfr1_el1);
> +	uint64_t hadbs, tcr;
> +
> +	/* Skip if HA is not supported. */
> +	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS), mmfr1);
> +	if (hadbs == 0)
> +		return false;
> +
> +	tcr = read_sysreg(tcr_el1) | TCR_EL1_HA;
> +	write_sysreg(tcr, tcr_el1);
> +	isb();
> +
> +	return true;
> +}
> +
> +static bool guest_clear_pte_af(void)
> +{
> +	*((uint64_t *)TEST_PTE_GVA) &= ~PTE_AF;
> +	flush_tlb_page(TEST_PTE_GVA);

Don't you want to actually flush TEST_GVA to force the TLB fill when you
poke the address again? This looks like you're flushing the VA of the
*PTE* not the test address.

> +	return true;
> +}
> +
> +static void guest_check_pte_af(void)

nit: call this guest_test_pte_af(). You use the guest_check_* pattern
for test preconditions (like guest_check_lse()).

> +{
> +	flush_tlb_page(TEST_PTE_GVA);

What is the purpose of this flush? I believe you are actually depending
on a dsb(ish) between the hardware PTE update and the load below. Or,
that's at least what I gleaned from the jargon of DDI0487H.a D5.4.13 
'Ordering of hardware updates to the translation tables'.

> +	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
> +}

[...]

> +static void sync_stats_from_guest(struct kvm_vm *vm)
> +{
> +	struct event_cnt *ec = addr_gva2hva(vm, (uint64_t)&events);
> +
> +	events.aborts += ec->aborts;
> +}

I believe you can use sync_global_from_guest() instead of this.

> +void fail_vcpu_run_no_handler(int ret)
> +{
> +	TEST_FAIL("Unexpected vcpu run failure\n");
> +}
> +
> +extern unsigned char __exec_test;
> +
> +void noinline __return_0x77(void)
> +{
> +	asm volatile("__exec_test: mov x0, #0x77\n"
> +			"ret\n");
> +}
> +
> +static void load_exec_code_for_test(void)
> +{
> +	uint64_t *code, *c;
> +
> +	assert(TEST_EXEC_GVA - TEST_GVA);
> +	code = memslot[TEST].hva + 8;
> +
> +	/*
> +	 * We need the cast to be separate in order for the compiler to not
> +	 * complain with: "‘memcpy’ forming offset [1, 7] is out of the bounds
> +	 * [0, 1] of object ‘__exec_test’ with type ‘unsigned char’"
> +	 */
> +	c = (uint64_t *)&__exec_test;
> +	memcpy(code, c, 8);

Don't you need to sync D$ and I$?

--
Thanks,
Oliver
