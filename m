Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF424710100
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbjEXWdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbjEXWdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:33:16 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F4E72
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:32:37 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d303dd87bso1487899b3a.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684967536; x=1687559536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=McTAZz5TDM/wNA+pFvseGWR8u1z//QTBMfmw5hfPpfs=;
        b=g/ZKhO12ISoI6HFD5/SS5tOhIqWpz2FWh4HPlVxaTZGw7NmkIFwsi5FxFUd/K4uls1
         8Vh29qUaC2GO9JKUQAwGb0nroHcRbcZ5poXwf4VmVf2MYaF1lY8K9cz9x/QsfRZr+DaF
         1RDf8Av4ZO2V363lBGXzfhby/bxWw1SKD+fHrOQyqLqSq2cd5/TsiHEM1uwfRj9Pbzvw
         xsfn6jobUSUO3Uvtna6zmnkGas+IO4c7JTWAJPTqFun18rP3d6aoFmyBo5UGQ8f8n3nG
         pXhDHy6OPPuiDWb80jffsRF4npsc03SjuGvD/IbDxxDSH76Es0C9zj+ISHxvMbSdW/GN
         zBpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684967536; x=1687559536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McTAZz5TDM/wNA+pFvseGWR8u1z//QTBMfmw5hfPpfs=;
        b=AHN6ZyJvBKEUfX7IycVeB8xVD3AyhPCD4pa0BuT7LRReOQwG1Wkq2RgrGUIoqJqDIy
         ubj4y9x+sSRH2nV/XkENqy70j6bxw4/jIywrWQQ0OjENvY/n1pt+brgOiu0eaL22kJs9
         /SU7AlCW39o8IuMI9mqI3c4Tu10K92Fj1h5i7XA+hYfJafcVb2OXe/9I9KAMIHm/DFaD
         2J6wDtXgb9wSYOlOxsMVeqL4jAgSKRVEWbzMIbNDKObYyuAtKY4CWqrhiNEQTo470MPL
         0bPpjXnL8QtR/PZhbn7p7ugz5vysJDAfzGxnUq+gvv2p/xcaFLvAzjSMTUYGJ5qGA8f0
         UPaA==
X-Gm-Message-State: AC+VfDzOfAv2doRpgI9qKkWyUh/lCF/gY0XRLU/E4hGmXxae2qChKZu0
        Mlgp30B3BC98u0snYs5Ke4UvMGudHMg=
X-Google-Smtp-Source: ACHHUZ7f8imVN4mHfpyTxq0yrWtQT+BrfgXSNEpa5yYX/4HxEQ9Ydq9/mTx70cR7zkzNpBjB4y1oTHe5FrM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:390c:b0:647:5400:a7cb with SMTP id
 fh12-20020a056a00390c00b006475400a7cbmr1699653pfb.3.1684967536684; Wed, 24
 May 2023 15:32:16 -0700 (PDT)
Date:   Wed, 24 May 2023 15:32:14 -0700
In-Reply-To: <20230323072714.82289-2-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-2-likexu@tencent.com>
Message-ID: <ZG6QbjRk7F8QyTr+@google.com>
Subject: Re: [PATCH 1/7] KVM: selftests: Test Intel PMU architectural events
 on gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Add test cases to check if different Architectural events are available
> after it's marked as unavailable via CPUID. It covers vPMU event filtering
> logic based on Intel CPUID, which is a complement to pmu_event_filter.
> 
> According to Intel SDM, the number of architectural events is reported
> through CPUID.0AH:EAX[31:24] and the architectural event x is
> supported if EBX[x]=0 && EAX[31:24]>x.
> 
> Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 202 ++++++++++++++++++

"cpuid" is a rather confusing name, e.g. I was half expecting tests where the guest
is executing CPUID.  IIUC, this is really just a basic functionality test, for a
somewhat loose definition of "basic".

Maybe something like pmu_basic_functionality_test?  Or pmu_functional_test?

>  2 files changed, 203 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c

...

> +#define EVENTSEL_OS BIT_ULL(17)
> +#define EVENTSEL_EN BIT_ULL(22)
> +#define PMU_CAP_FW_WRITES BIT_ULL(13)
> +#define EVENTS_MASK GENMASK_ULL(7, 0)
> +#define PMU_VERSION_MASK GENMASK_ULL(7, 0)
> +#define GP_CTR_NUM_OFS_BIT 8
> +#define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
> +#define EVT_LEN_OFS_BIT 24
> +#define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
> +
> +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
> +
> +/*
> + * Intel Pre-defined Architectural Performance Events. Note some events
> + * are skipped for testing due to difficulties in stable reproduction.
> + */
> +static const uint64_t arch_events[] = {
> +	[0] = ARCH_EVENT(0x3c, 0x0),
> +	[1] = ARCH_EVENT(0xc0, 0x0),
> +	[2] = ARCH_EVENT(0x3c, 0x1),
> +	[3] = ARCH_EVENT(0x2e, 0x4f), /* LLC Reference */
> +	[4] = ARCH_EVENT(0x2e, 0x41), /* LLC Misses */
> +	[5] = ARCH_EVENT(0xc4, 0x0),
> +	[6] = ARCH_EVENT(0xc5, 0x0),  /* Branch Misses Retired */
> +	[7] = ARCH_EVENT(0xa4, 0x1), /* Topdown Slots */
> +};

All of these definitions belong in library code.  Probably something like
tools/testing/selftests/kvm/include/x86_64/pmu.h, or maybe intel_pmu.h?

> +static struct kvm_vcpu *new_vcpu(void *guest_code)

Assuming the next version is sent before the aforementioned cleanup, how about
defining this as

static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
						  void *guest_code)

so that the cleanup can be a more straightforward replacement.  That should also
make the free_vcpu() wrapper completely unnecessary.

> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);

Ugh, I really need to put together that series to clean up the descriptor table
mess.

https://lore.kernel.org/all/Y8hCBOndYMD9zsDL@google.com

> +
> +	return vcpu;
> +}
> +
> +static void free_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	kvm_vm_free(vcpu->vm);

Just call kvm_vm_free().  Adding layers of unnecessary helpers just to provide
symmetry is not a good tradeoff.  As above, tweak the name/prototyp of new_vcpu()
if you really want something approaching symmetry.

> +static void run_vcpu(struct kvm_vcpu *vcpu, const char *msg,
> +		     bool (*check_ucall)(struct ucall *uc, void *data),
> +		     void *expect_args)
> +{
> +	struct ucall uc;
> +
> +	for (;;) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			TEST_ASSERT(check_ucall(&uc, expect_args), "%s", msg);

A callback is both overkill and debug hostile.  If the assert fails, it will report
this common code and not the caller.  Since all uses grab the first ucall param,
just "return" that from the run_vcpu() wrapper as out param.  Callers will need
to define their own loop, but that's one line of code, and it has the advantage
of making the code much more self-documenting

E.g.

static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
{
	struct ucall uc;

	vcpu_run(vcpu);
	switch (get_ucall(vcpu, &uc)) {
	case UCALL_SYNC:
		ucall_arg = uc->args[1];
		break;
	case UCALL_DONE:
		break;
	default:
		TEST_ASSERT(false, "Unexpected exit: %s",
				exit_reason_str(vcpu->run->exit_reason));
	}
	return uc.cmd;
}

and in intel_test_fixed_counters() as an example:

			while (run_vcpu(vcpu, &val) != UCALL_DONE)
				TEST_ASSERT(val, "One or more fixed counters not counting");

> +static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
> +				   uint8_t unavl_mask, uint8_t idx)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
> +	bool is_supported;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	entry->eax = (entry->eax & ~EVT_LEN_MASK) |
> +		(evt_vector << EVT_LEN_OFS_BIT);
> +	entry->ebx = (entry->ebx & ~EVENTS_MASK) | unavl_mask;
> +	vcpu_set_cpuid(vcpu);
> +
> +	if (vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
> +		ctr_msr = MSR_IA32_PMC0;
> +
> +	/* Arch event x is supported if EBX[x]=0 && EAX[31:24]>x */
> +	is_supported = !(entry->ebx & BIT_ULL(idx)) &&
> +		(((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
> +
> +	vcpu_args_set(vcpu, 5, entry->eax & PMU_VERSION_MASK,
> +		      (entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT,
> +		      is_supported, ctr_msr, arch_events[idx]);

Why pass all this stuff in as params?  Wouldn't it be easier to query CPUID from
the guest side?  And define KVM_X86_CPU_PROPERTY macros where possible to avoid
having to open code things in multiple places.

> +static void intel_check_arch_event_is_unavl(uint8_t idx)
> +{
> +	const char *msg = "Unavailable arch event is counting.";
> +	uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
> +	struct kvm_vcpu *vcpu;
> +
> +	/*
> +	 * A brute force iteration of all combinations of values is likely to
> +	 * exhaust the limit of the single-threaded thread fd nums, so it's
> +	 * tested here by iterating through all valid values on a single bit.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(arch_events); i++) {
> +		eax_evt_vec = BIT_ULL(i);
> +		for (j = 0; j < ARRAY_SIZE(arch_events); j++) {
> +			ebx_unavl_mask = BIT_ULL(j);
> +
> +			vcpu = new_vcpu(intel_guest_run_arch_event);
> +			test_arch_events_setup(vcpu, eax_evt_vec,
> +					       ebx_unavl_mask, idx);
> +			run_vcpu(vcpu, msg, first_uc_arg_non_zero, NULL);

Oof, this is super confusing.  At first, second, and third glances, it looks like
this is asserting that the counter _is_ counting.  It took me a while to find this
code in the guest:

		GUEST_SYNC(supported == !!_rdpmc(RDPMC_FIXED_BASE | i));

Either have the guest do GUEST_ASSERT() directly and process the output in the
common run_vcpu(), or just have the guest return the counter value and do the
assert here.  My vote would be the latter, e.g.

			while (run_vcpu(vcpu, &counter_val) != UCALL_DONE)
				TEST_ASSERT(is_supported == !!counter_val,
					    "blah blah blah");

That'd also likely avoid having to plumb the "supported" info into the guest.
