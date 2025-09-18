Return-Path: <kvm+bounces-57957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1774EB827D4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40B631752EC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 01:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AE72153D2;
	Thu, 18 Sep 2025 01:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRIIyGux"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BFA156C40
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 01:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758158785; cv=none; b=Wfj4cgPb7XAarW8gXcnq32aImPSP641w+R/HYppTq8b6prmLCabKnhdCXAApeWkillmwQ3D/EHubXtloBRbWZqi2BjizIk2jTDev+zK6kv0wGj2jUKaaKjCbuV06fE/0pSW6ckHlZmtNJTszWoDk0MWEm2Y7YFKFz1eMxU0WqNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758158785; c=relaxed/simple;
	bh=XQ/Q1dGjyHi18nLYd6ZQWciw1WjkgGa3wE8hOveg3jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5l5PJN+YlFgcECuQER/G4qTeBkmtw2e/bzCRKKhWFzIrH7KeTw3xXObLrfI/utaxlrQ2kbmfePenJTq+f8qU3WOc3hYWY5v2erF3vSpxsWebTF1N4ZKx1tjXcqGCd4U+1CBpPAXwWoYLAWII9/sL7wLlV08VqxhmFWZFApC34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rRIIyGux; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 18 Sep 2025 10:25:58 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758158769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Jjt7WIG30EfMyysMomZPghPo22dRWUV095XopjZOE=;
	b=rRIIyGux9mwYO5LpVSAUqWij4Ha3iOEdouYkK3XvQqZqV8cEnVNY1iFTrIRvXDdd9ULYpK
	m+xGg+O8Y2hLyQpPvrqkSg6Nd1k3z3Aw0lpRY80eWFpYCx4GbuzY8fjdO3CAVnL/NPZHwE
	Eh/u5laOzMOZIlMyZxWutvygrwpbGdw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH 01/13] KVM: arm64: selftests: Provide
 kvm_arch_vm_post_create() in library code
Message-ID: <aMtfpocXPg7mONac@vm4>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
 <20250917212044.294760-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917212044.294760-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 02:20:31PM -0700, Oliver Upton wrote:
> In order to compel the default usage of EL2 in selftests, move
> kvm_arch_vm_post_create() to library code and expose an opt-in for using
> MTE by default.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  .../testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++--------------
>  .../selftests/kvm/include/arm64/processor.h   |  2 ++
>  .../selftests/kvm/lib/arm64/processor.c       | 13 +++++++++++++
>  3 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 189321e96925..a2d367a2c93c 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -15,8 +15,6 @@
>  #include "test_util.h"
>  #include <linux/bitfield.h>
>  
> -bool have_cap_arm_mte;
> -
>  enum ftr_type {
>  	FTR_EXACT,			/* Use a predefined safe value */
>  	FTR_LOWER_SAFE,			/* Smaller value is safe */
> @@ -568,7 +566,9 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
>  	uint64_t mte_frac;
>  	int idx, err;
>  
> -	if (!have_cap_arm_mte) {
> +	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
> +	mte = FIELD_GET(ID_AA64PFR1_EL1_MTE, val);
> +	if (!mte) {
>  		ksft_test_result_skip("MTE capability not supported, nothing to test\n");
>  		return;
>  	}
> @@ -593,9 +593,6 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
>  	 * from unsupported (0xF) to supported (0).
>  	 *
>  	 */
> -	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
> -
> -	mte = FIELD_GET(ID_AA64PFR1_EL1_MTE, val);
>  	mte_frac = FIELD_GET(ID_AA64PFR1_EL1_MTE_frac, val);
>  	if (mte != ID_AA64PFR1_EL1_MTE_MTE2 ||
>  	    mte_frac != ID_AA64PFR1_EL1_MTE_frac_NI) {
> @@ -750,14 +747,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  	ksft_test_result_pass("%s\n", __func__);
>  }
>  
> -void kvm_arch_vm_post_create(struct kvm_vm *vm)
> -{
> -	if (vm_check_cap(vm, KVM_CAP_ARM_MTE)) {
> -		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);
> -		have_cap_arm_mte = true;
> -	}
> -}
> -
>  int main(void)
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -769,6 +758,8 @@ int main(void)
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_WRITABLE_IMP_ID_REGS));
>  
> +	test_wants_mte();
> +
>  	vm = vm_create(1);
>  	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
>  	vcpu = vm_vcpu_add(vm, 0, guest_code);
> diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
> index 255fed769a8a..8370fc94041d 100644
> --- a/tools/testing/selftests/kvm/include/arm64/processor.h
> +++ b/tools/testing/selftests/kvm/include/arm64/processor.h
> @@ -300,4 +300,6 @@ void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
>  /* Execute a Wait For Interrupt instruction. */
>  void wfi(void);
>  
> +void test_wants_mte(void);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index eb115123d741..caed1998c7b3 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -653,3 +653,16 @@ void wfi(void)
>  {
>  	asm volatile("wfi");
>  }
> +
> +static bool request_mte;
> +
> +void test_wants_mte(void)
> +{
> +	request_mte = true;
> +}
> +
> +void kvm_arch_vm_post_create(struct kvm_vm *vm)
> +{
> +	if (request_mte && vm_check_cap(vm, KVM_CAP_ARM_MTE))
> +		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);
> +}
> -- 
> 2.47.3
>

Hi,
On FVP RevC with the kernel your series applied, I see set_id_regs fails
to execute.

# ./arm64/set_id_regs
Random seed: 0x6b8b4567
TAP version 13
1..102
ok 1 ID_AA64DFR0_EL1_DoubleLock
ok 2 ID_AA64DFR0_EL1_WRPs
ok 3 ID_AA64DFR0_EL1_PMUVer
ok 4 ID_AA64DFR0_EL1_DebugVer
ok 5 # SKIP ID_DFR0_EL1_PerfMon on AARCH64 only system
ok 6 # SKIP ID_DFR0_EL1_CopDbg on AARCH64 only system
ok 7 ID_AA64ISAR0_EL1_RNDR
ok 8 ID_AA64ISAR0_EL1_TLB
ok 9 ID_AA64ISAR0_EL1_TS
ok 10 ID_AA64ISAR0_EL1_FHM
ok 11 ID_AA64ISAR0_EL1_DP
ok 12 ID_AA64ISAR0_EL1_SM4
ok 13 ID_AA64ISAR0_EL1_SM3
ok 14 ID_AA64ISAR0_EL1_SHA3
ok 15 ID_AA64ISAR0_EL1_RDM
ok 16 ID_AA64ISAR0_EL1_TME
ok 17 ID_AA64ISAR0_EL1_ATOMIC
ok 18 ID_AA64ISAR0_EL1_CRC32
ok 19 ID_AA64ISAR0_EL1_SHA2
ok 20 ID_AA64ISAR0_EL1_SHA1
ok 21 ID_AA64ISAR0_EL1_AES
ok 22 ID_AA64ISAR1_EL1_LS64
ok 23 ID_AA64ISAR1_EL1_XS
ok 24 ID_AA64ISAR1_EL1_I8MM
ok 25 ID_AA64ISAR1_EL1_DGH
ok 26 ID_AA64ISAR1_EL1_BF16
ok 27 ID_AA64ISAR1_EL1_SPECRES
ok 28 ID_AA64ISAR1_EL1_SB
ok 29 ID_AA64ISAR1_EL1_FRINTTS
ok 30 ID_AA64ISAR1_EL1_LRCPC
ok 31 ID_AA64ISAR1_EL1_FCMA
ok 32 ID_AA64ISAR1_EL1_JSCVT
ok 33 ID_AA64ISAR1_EL1_DPB
ok 34 ID_AA64ISAR2_EL1_BC
ok 35 ID_AA64ISAR2_EL1_RPRES
ok 36 ID_AA64ISAR2_EL1_WFxT
ok 37 ID_AA64PFR0_EL1_CSV3
ok 38 ID_AA64PFR0_EL1_CSV2
ok 39 ID_AA64PFR0_EL1_DIT
ok 40 ID_AA64PFR0_EL1_SEL2
ok 41 ID_AA64PFR0_EL1_GIC
ok 42 ID_AA64PFR0_EL1_EL3
ok 43 ID_AA64PFR0_EL1_EL2
ok 44 ID_AA64PFR0_EL1_EL1
ok 45 ID_AA64PFR0_EL1_EL0
ok 46 ID_AA64PFR1_EL1_DF2
ok 47 ID_AA64PFR1_EL1_CSV2_frac
ok 48 ID_AA64PFR1_EL1_SSBS
ok 49 ID_AA64PFR1_EL1_BT
ok 50 ID_AA64MMFR0_EL1_ECV
ok 51 ID_AA64MMFR0_EL1_EXS
==== Test Assertion Failure ====
  include/kvm_util.h:815: !ret
    pid=897 tid=897 errno=22 - Invalid argument
    sh: line 1: addr2line: command not found
      KVM_SET_ONE_REG failed, rc: -1 errno: 22 (Invalid argument)


