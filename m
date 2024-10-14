Return-Path: <kvm+bounces-28818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5A399D9E3
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 00:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E69CCB21BBA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 22:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8109C1D89F8;
	Mon, 14 Oct 2024 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fZU8pPiC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E401D1B85C2
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728946015; cv=none; b=ky1zm08H6lSpku5Ql0ZVVKtUZ5bVy74/qnp6T9N56WeKE+VLusMVlgX+Zl/AAyILHaoi+kl+xI1DK0MYTZfRD5+cXMyuAdBZUo54pzhYoa8ELJ++P7fqUa/R5hb9usCxuN151PitmKUL+ZAlnACvYlI5UTdG60k+/+t6O46unE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728946015; c=relaxed/simple;
	bh=B5L2VZOddCYqeH12Pk9UKFtrQqEsg5wbeR9LqrTVKLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ilNELIBQUhuZySUS/l3Iljx05byU3OoghorHzLreJgGSxO5VMSHYp1/l8MlcEU1ynZNDxCpHxgxSW6+WxBeN5Ska40Du4ca51avblIamCn/u6ldn89TB9uMiFSxCGg1wsT29qLGzEJPibrsuzDOnEABQ5UL8MvCmXVod42WYiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fZU8pPiC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6886cd07673so87318467b3.3
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 15:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728946013; x=1729550813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cxxXdg9XxKPp/AoPFfTBqP+RcgfeSiCP45VArRORxxA=;
        b=fZU8pPiCzDb4wR/74ZArUTViLISgI1aYUWg6WHmsfvvEJ/cfRnVNnm4Bb3YoosbBom
         dEXhu4NAGXdEDozfWZG9KqUH8uVNlCo764l1iwc2zwNT9pyQSezLahOWSu1gGcsYFRar
         +CTkmkXvvL+lIKGkQUbwnrW/4rdEcWMmHddvAu7whLVMRp2BloVpnDsXFv+AtalzW7wT
         Jzj4WwcA0ZnZjDjYVDyxoHb0DdtBPqnYflmAC/5s8JDvurol27AznLfibyhrulsmsXK4
         ZGZpjBOEnocx8Xdo6AicU4YWDoDmYRJN4F7SqB0wFhqDKM/R8aMVigWx28ateLxRnzwV
         rbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728946013; x=1729550813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cxxXdg9XxKPp/AoPFfTBqP+RcgfeSiCP45VArRORxxA=;
        b=XA+ZwxyRD5KKlzI1eksLjwGbRW5ZpuvF8deEBTnxAv+K09BsCQX1cYDzg8CBwxiC2P
         Qh98s8EiruASgNoZdJEYKIuw9ej4H1Tvr7VQECJ4gG9Rqr/V9vqdjLoVo5cTVxFBZKOa
         aAPh9bth3VbFiGLXTeDlFb3J+57VXpnDxhTMLb8oAueQV6uDtSNPLlZcunsYSCdRTzF7
         PKO0qdlXIpHi26GQZWwK6GVi9UWkv0KIdS9RRUFxfX7RF3UhzPFl6cy6NCBek56Up7TM
         rjsScswUuCsyPgyRfXTHdeCFnhQud4jyqJh9eR5sg9lCrSTWMGkx00ceT9xfNDBErITC
         hu2Q==
X-Gm-Message-State: AOJu0YwN9TDsTen1XOFz6kIVziOlWFQ47uvVdpOPJy+MaL6ZqWCqvByx
	aFPxnmsvcBM8h6n2GqxPqWKUVmHgoBRIv2AvAHQMX7dSTByQBbCyhf+B7cqaeygtdp91q8sQOuf
	YIw==
X-Google-Smtp-Source: AGHT+IFRlbMYItHK1u6t7ry7WP6k/ClFm4jeNr96qxGvWS6Dz7q9c6GarkSWyfBOxs9P+FjrkB8ZwRMKIBQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4286:b0:6de:19f:34d7 with SMTP id
 00721157ae682-6e3477bef8amr261287b3.2.1728946012942; Mon, 14 Oct 2024
 15:46:52 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:46:51 -0700
In-Reply-To: <20240905124107.6954-3-pratikrajesh.sampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com> <20240905124107.6954-3-pratikrajesh.sampat@amd.com>
Message-ID: <Zw2fW2AJU-_Yi5U6@google.com>
Subject: Re: [PATCH v3 2/9] KVM: selftests: Add a basic SNP smoke test
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 05, 2024, Pratik R. Sampat wrote:
> Extend sev_smoke_test to also run a minimal SEV-SNP smoke test that
> initializes and sets up private memory regions required to run a simple
> SEV-SNP guest.
> 
> Similar to its SEV-ES smoke test counterpart, this also does not
> support GHCB and ucall yet and uses the GHCB MSR protocol to trigger an
> exit of the type KVM_EXIT_SYSTEM_EVENT.
> 
> Also, decouple policy and type and require functions to provide both
> such that there is no assumption regarding the type using policy.
> 
> Signed-off-by: Pratik R. Sampat <pratikrajesh.sampat@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  |   1 +
>  .../selftests/kvm/include/x86_64/sev.h        |  54 +++++++-
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   8 +-
>  .../selftests/kvm/lib/x86_64/processor.c      |   6 +-
>  tools/testing/selftests/kvm/lib/x86_64/sev.c  | 116 +++++++++++++++++-
>  .../selftests/kvm/x86_64/sev_smoke_test.c     |  67 ++++++++--
>  6 files changed, 230 insertions(+), 22 deletions(-)

There is *way* too much going on in this one patch.  There's at least 6+ patches
worth of stuff here:

 1. Add x86 architectural defines
 2. SNP ioctl() plumbing
 3..N. Other misc plumbing, e.g. is_smt_active()
 N+1. __vm_create() change to force GUEST_MEMFD for SNP
 N+2. Whatever the ASSERT_SEV_POLICY() thing is doing, if it's actually necessary
 N+3..M. Refactorings to existing code to prep for SNP
 M+1. SNP support

In general, if you feel the urge to start a changelog paragraph with "Also,"
that's a sign you need to break up the patch.

> @@ -74,8 +95,18 @@ kvm_static_assert(SEV_RET_SUCCESS == 0);
>  	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd,	ret, vm);		\
>  })
>  
> +/* Ensure policy is within bounds for SEV, SEV-ES */
> +#define ASSERT_SEV_POLICY(type, policy)				\
> +({									\
> +	if (type == KVM_X86_SEV_VM || type == KVM_X86_SEV_ES_VM) {	\
> +		TEST_ASSERT(policy < ((uint32_t)~0U),			\
> +			    "Policy beyond bounds for SEV");		\

This is asinine.  First, there's one user, i.e. I see no reason to have a funky
macro to assert on the type.  Second, _if_ this is a common macro, "type" can and
should be incorporated into the assert.  Third, I have no idea why selftests is
validating its own inputs to KVM.

> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 974bcd2df6d7..981f3c9fd1cf 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -625,7 +625,8 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  	sync_global_to_guest(vm, host_cpu_is_amd);
>  	sync_global_to_guest(vm, is_forced_emulation_enabled);
>  
> -	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM) {
> +	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM ||
> +	    vm->type == KVM_X86_SNP_VM) {

Probably time to add a helper, e.g. is_sev_vm() or something.  If we follow KVM's
lead, then we'd have is_sev_vm(), is_sev_es_vm(), and is_sev_snp_vm(), where an
SNP VM returns true for all of them.  Not sure I love that idea, just throwing it
out there as one possibility.

>  		struct kvm_sev_init init = { 0 };
>  
>  		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
> @@ -1134,7 +1135,8 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
>  
>  void kvm_init_vm_address_properties(struct kvm_vm *vm)
>  {
> -	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM) {
> +	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM ||
> +	    vm->type == KVM_X86_SNP_VM) {
>  		vm->arch.sev_fd = open_sev_dev_path_or_exit();
>  		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
>  		vm->gpa_tag_mask = vm->arch.c_bit;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> index 125a72246e09..ff3824564854 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> @@ -14,7 +14,8 @@
>   * and find the first range, but that's correct because the condition
>   * expression would cause us to quit the loop.
>   */
> -static int encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
> +static int encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region,
> +			  uint8_t page_type)
>  {
>  	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
>  	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
> @@ -25,12 +26,23 @@ static int encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region
>  	if (!sparsebit_any_set(protected_phy_pages))
>  		return 0;
>  
> -	sev_register_encrypted_memory(vm, region);
> +	if (vm->type == KVM_X86_SEV_VM || vm->type == KVM_X86_SEV_ES_VM)

And then this would be

	if (!is_sev_snp_vm())

> +		sev_register_encrypted_memory(vm, region);
>  
>  	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
>  		const uint64_t size = (j - i + 1) * vm->page_size;
>  		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
>  
> +		if (vm->type == KVM_X86_SNP_VM) {
> +			vm_mem_set_private(vm, gpa_base + offset, size);

Setting memory private seems like something that should be done by common code,
not by SNP specific code.

> @@ -158,6 +213,45 @@ void sev_vm_launch_finish(struct kvm_vm *vm)
>  	TEST_ASSERT_EQ(status.state, SEV_GUEST_STATE_RUNNING);
>  }
>  
> +void snp_vm_launch_start(struct kvm_vm *vm, uint64_t policy)
> +{
> +	int ret = __snp_vm_launch_start(vm, policy, 0);
> +
> +	TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_SEV_SNP_LAUNCH_START, ret, vm);

Please use vm_ioctl().  TEST_ASSERT_VM_VCPU_IOCTL() should pretty much never be
used directly, the only exceptions are cases where '0' is not the only success
value, e.g. for ioctls that return a file descriptor.
> +static void guest_snp_code(void)
> +{
> +	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
> +	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ES_ENABLED);
> +	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_SNP_ENABLED);

Read the MSR once.

> +
> +	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
> +	__asm__ __volatile__("rep; vmmcall");

Please add a vmgexit() helper (which I should have done as part of commit
40e09b3ccfac ("KVM: selftests: Add a basic SEV-ES smoke test")).

> +}
> +
>  static void guest_sev_es_code(void)
>  {
>  	/* TODO: Check CPUID after GHCB-based hypercall support is added. */
> @@ -61,7 +82,7 @@ static void compare_xsave(u8 *from_host, u8 *from_guest)
>  		abort();
>  }
>  
> -static void test_sync_vmsa(uint32_t policy)
> +static void test_sync_vmsa(uint32_t type, uint64_t policy)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> @@ -77,7 +98,10 @@ static void test_sync_vmsa(uint32_t policy)
>  		.xcrs[0].value = XFEATURE_MASK_X87_AVX,
>  	};
>  
> -	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_code_xsave, &vcpu);
> +	TEST_ASSERT(type != KVM_X86_SEV_VM,
> +		    "sync_vmsa only supported for SEV-ES and SNP VM types");
> +
> +	vm = vm_sev_create_with_one_vcpu(type, guest_code_xsave, &vcpu);
>  	gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
>  				    MEM_REGION_TEST_DATA);
>  	hva = addr_gva2hva(vm, gva);
> @@ -99,7 +123,7 @@ static void test_sync_vmsa(uint32_t policy)
>  	    : "ymm4", "st", "st(1)", "st(2)", "st(3)", "st(4)", "st(5)", "st(6)", "st(7)");
>  	vcpu_xsave_set(vcpu, &xsave);
>  
> -	vm_sev_launch(vm, SEV_POLICY_ES | policy, NULL);
> +	vm_sev_launch(vm, policy, NULL);
>  
>  	/* This page is shared, so make it decrypted.  */
>  	memset(hva, 0, 4096);
> @@ -118,14 +142,12 @@ static void test_sync_vmsa(uint32_t policy)
>  	kvm_vm_free(vm);
>  }
>  
> -static void test_sev(void *guest_code, uint64_t policy)
> +static void test_sev(void *guest_code, uint32_t type, uint64_t policy)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
>  	struct ucall uc;
>  
> -	uint32_t type = policy & SEV_POLICY_ES ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
> -
>  	vm = vm_sev_create_with_one_vcpu(type, guest_code, &vcpu);
>  
>  	/* TODO: Validate the measurement is as expected. */
> @@ -134,7 +156,7 @@ static void test_sev(void *guest_code, uint64_t policy)
>  	for (;;) {
>  		vcpu_run(vcpu);
>  
> -		if (policy & SEV_POLICY_ES) {
> +		if (vm->type == KVM_X86_SEV_ES_VM || vm->type == KVM_X86_SNP_VM) {
>  			TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
>  				    "Wanted SYSTEM_EVENT, got %s",
>  				    exit_reason_str(vcpu->run->exit_reason));
> @@ -194,19 +216,38 @@ int main(int argc, char *argv[])
>  {
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
>  
> -	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
> -	test_sev(guest_sev_code, 0);
> +	test_sev(guest_sev_code, KVM_X86_SEV_VM, SEV_POLICY_NO_DBG);
> +	test_sev(guest_sev_code, KVM_X86_SEV_VM, 0);

To cut down on the amount of copy+paste, and line lengths, I vote to add separate
wrappers, e.g.

	test_sev(<policy>)
	test_sev_es(<policy>)
	test_sev_snp(<policy>);
>  
>  	if (kvm_cpu_has(X86_FEATURE_SEV_ES)) {
> -		test_sev(guest_sev_es_code, SEV_POLICY_ES | SEV_POLICY_NO_DBG);
> -		test_sev(guest_sev_es_code, SEV_POLICY_ES);
> +		test_sev(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES | SEV_POLICY_NO_DBG);

Please wrap at ~80 chars.


> +		test_sev(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
>  
>  		test_sev_es_shutdown();
>  
>  		if (kvm_has_cap(KVM_CAP_XCRS) &&
>  		    (xgetbv(0) & XFEATURE_MASK_X87_AVX) == XFEATURE_MASK_X87_AVX) {
> -			test_sync_vmsa(0);
> -			test_sync_vmsa(SEV_POLICY_NO_DBG);
> +			test_sync_vmsa(KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
> +			test_sync_vmsa(KVM_X86_SEV_ES_VM, SEV_POLICY_ES | SEV_POLICY_NO_DBG);
> +		}
> +	}
> +
> +	if (kvm_cpu_has(X86_FEATURE_SNP) && is_kvm_snp_supported()) {

Why do we need both?  KVM shouldn't advertise SNP if it's not supported.

> +		unsigned long snp_policy = SNP_POLICY;

u64, no?

> +
> +		if (unlikely(!is_smt_active()))
> +			snp_policy &= ~SNP_POLICY_SMT;

Why does SNP_POLICY assume SMT?  And what is RSVD_MBO?  E.g. why not this?

		u64 policy = is_smt_active() ? SNP_POLICY_SMT : SNP_POLICY;

> +
> +		test_sev(guest_snp_code, KVM_X86_SNP_VM, snp_policy);
> +		/* Test minimum firmware level */
> +		test_sev(guest_snp_code, KVM_X86_SNP_VM,
> +			 snp_policy |
> +			 SNP_FW_VER_MAJOR(SNP_FW_REQ_VER_MAJOR) |
> +			 SNP_FW_VER_MINOR(SNP_FW_REQ_VER_MINOR));
> +
> +		if (kvm_has_cap(KVM_CAP_XCRS) &&
> +		    (xgetbv(0) & XFEATURE_MASK_X87_AVX) == XFEATURE_MASK_X87_AVX) {

Curly braces are unnecessary.

> +			test_sync_vmsa(KVM_X86_SNP_VM, snp_policy);
>  		}
>  	}
>  
> -- 
> 2.34.1
> 

