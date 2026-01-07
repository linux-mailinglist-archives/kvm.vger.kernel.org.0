Return-Path: <kvm+bounces-67302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8036BD005EF
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 00:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 70FE4300486C
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 23:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7332FD689;
	Wed,  7 Jan 2026 23:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u5Bh4aFM"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9717F2D592F
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 23:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767827649; cv=none; b=T80xbIchfbKBM5lzbO0Q8XxVQtTQ2PocFf9JsEy+r34QU4VYyXPe4mIHe/slUD1dfTmbsg1KY1HpcE+o1sDFO8Jy1Y3/lDsEE9ZJrJasBjDgU9PeWU6xQ8yDK9SJPeVQCM3A3fAJ7nwEtbqD97GcPBc7qy2Gf97+7YO7+Jz0t8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767827649; c=relaxed/simple;
	bh=Jy64zneAKwy0rKILEqV/YoGs8qWJ+teoZELZJO5YOUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n900ZYFgSj0beY7aFFnwNNW/jJ3lQ3PmNTfzuyFF7IzYA4+sYb89/gFMLJMHNkOrZxPk3D0oX+O6Tsls6kkpeS4bw8RTgX5Q0pysELz0WM+AvL/FVDKFSxFps7RyIMRrgg4LA9muLW39VdzUpeBERNl83/FhyoyRgwn7ZxSnYSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u5Bh4aFM; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Jan 2026 23:12:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767827632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rR1fnvTTjB0CTE6RfkOtCAeY2jGW4kIZ+UMk8iaKGdI=;
	b=u5Bh4aFM/DJ6EI3tKWN9ieFoB4g6EEjw1qSeYhK/tQ+6PGvPQrzcSVID7cPg1+zCvC6KFm
	XbMjwJ3hL72SpmGfx9q0LV4fstFFuDLFPPm5Dw+mLKGD28qAisxn74YyTOvcRrbHUMU5DQ
	sLtTKWYIAxdxWioTvQMqczCGjCOTVFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 16/21] KVM: selftests: Add support for nested NPTs
Message-ID: <fj2wis2dluwtlaawrelfj25ldsk35dpbytytd2koemnv2va4np@feeu6in4gjjg>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-17-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:45PM -0800, Sean Christopherson wrote:
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> Implement nCR3 and NPT initialization functions, similar to the EPT
> equivalents, and create common TDP helpers for enablement checking and
> initialization. Enable NPT for nested guests by default if the TDP MMU
> was initialized, similar to VMX.
> 
> Reuse the PTE masks from the main MMU in the NPT MMU, except for the C
> and S bits related to confidential VMs.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Funny story, I missed a teeny tiny part here..

diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 18e9e9089643..2e5c480c9afd 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -46,6 +46,9 @@ vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
        svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
        memset(svm->msr_hva, 0, getpagesize());

+       if (vm->stage2_mmu.pgd_created)
+               svm->ncr3_gpa = vm->stage2_mmu.pgd;
+
        *p_svm_gva = svm_gva;
        return svm;
 }

---

The good news is that the test still passes after we start ACTUALLY
USING the nested NPT :)

> ---
>  .../selftests/kvm/include/x86/processor.h     |  2 ++
>  .../selftests/kvm/include/x86/svm_util.h      |  9 ++++++++
>  .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
>  .../testing/selftests/kvm/lib/x86/processor.c | 15 +++++++++++++
>  tools/testing/selftests/kvm/lib/x86/svm.c     | 21 +++++++++++++++++++
>  .../selftests/kvm/x86/vmx_dirty_log_test.c    |  4 ++--
>  6 files changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> index d134c886f280..deb471fb9b51 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -1477,6 +1477,8 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
>  void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  		    uint64_t nr_bytes, int level);
>  
> +void vm_enable_tdp(struct kvm_vm *vm);
> +bool kvm_cpu_has_tdp(void);
>  void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
>  void tdp_identity_map_default_memslots(struct kvm_vm *vm);
>  void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
> diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
> index b74c6dcddcbd..5d7c42534bc4 100644
> --- a/tools/testing/selftests/kvm/include/x86/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
> @@ -27,6 +27,9 @@ struct svm_test_data {
>  	void *msr; /* gva */
>  	void *msr_hva;
>  	uint64_t msr_gpa;
> +
> +	/* NPT */
> +	uint64_t ncr3_gpa;
>  };
>  
>  static inline void vmmcall(void)
> @@ -57,6 +60,12 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
>  void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
>  void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
>  
> +static inline bool kvm_cpu_has_npt(void)
> +{
> +	return kvm_cpu_has(X86_FEATURE_NPT);
> +}
> +void vm_enable_npt(struct kvm_vm *vm);
> +
>  int open_sev_dev_path_or_exit(void);
>  
>  #endif /* SELFTEST_KVM_SVM_UTILS_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
> index 3319cb57a78d..407abfc34909 100644
> --- a/tools/testing/selftests/kvm/lib/x86/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
> @@ -82,9 +82,9 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
>  	int vcpu_id;
>  
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
> -	TEST_REQUIRE(kvm_cpu_has_ept());
> +	TEST_REQUIRE(kvm_cpu_has_tdp());
>  
> -	vm_enable_ept(vm);
> +	vm_enable_tdp(vm);
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
>  		vcpu_alloc_vmx(vm, &vmx_gva);
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index 29e7d172f945..a3a4c9a4cbcb 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -8,7 +8,9 @@
>  #include "kvm_util.h"
>  #include "pmu.h"
>  #include "processor.h"
> +#include "svm_util.h"
>  #include "sev.h"
> +#include "vmx.h"
>  
>  #ifndef NUM_INTERRUPTS
>  #define NUM_INTERRUPTS 256
> @@ -472,6 +474,19 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> +void vm_enable_tdp(struct kvm_vm *vm)
> +{
> +	if (kvm_cpu_has(X86_FEATURE_VMX))
> +		vm_enable_ept(vm);
> +	else
> +		vm_enable_npt(vm);
> +}
> +
> +bool kvm_cpu_has_tdp(void)
> +{
> +	return kvm_cpu_has_ept() || kvm_cpu_has_npt();
> +}
> +
>  void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
>  	       uint64_t size, int level)
>  {
> diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
> index d239c2097391..8e4795225595 100644
> --- a/tools/testing/selftests/kvm/lib/x86/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86/svm.c
> @@ -59,6 +59,22 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>  	seg->base = base;
>  }
>  
> +void vm_enable_npt(struct kvm_vm *vm)
> +{
> +	struct pte_masks pte_masks;
> +
> +	TEST_ASSERT(kvm_cpu_has_npt(), "KVM doesn't supported nested NPT");
> +
> +	/*
> +	 * NPTs use the same PTE format, but deliberately drop the C-bit as the
> +	 * per-VM shared vs. private information is only meant for stage-1.
> +	 */
> +	pte_masks = vm->mmu.arch.pte_masks;
> +	pte_masks.c = 0;
> +
> +	tdp_mmu_init(vm, vm->mmu.pgtable_levels, &pte_masks);
> +}
> +
>  void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
>  {
>  	struct vmcb *vmcb = svm->vmcb;
> @@ -102,6 +118,11 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>  	vmcb->save.rip = (u64)guest_rip;
>  	vmcb->save.rsp = (u64)guest_rsp;
>  	guest_regs.rdi = (u64)svm;
> +
> +	if (svm->ncr3_gpa) {
> +		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
> +		ctrl->nested_cr3 = svm->ncr3_gpa;
> +	}
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> index 370f8d3117c2..032ab8bf60a4 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> @@ -93,7 +93,7 @@ static void test_vmx_dirty_log(bool enable_ept)
>  	/* Create VM */
>  	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
>  	if (enable_ept)
> -		vm_enable_ept(vm);
> +		vm_enable_tdp(vm);
>  
>  	vcpu_alloc_vmx(vm, &vmx_pages_gva);
>  	vcpu_args_set(vcpu, 1, vmx_pages_gva);
> @@ -170,7 +170,7 @@ int main(int argc, char *argv[])
>  
>  	test_vmx_dirty_log(/*enable_ept=*/false);
>  
> -	if (kvm_cpu_has_ept())
> +	if (kvm_cpu_has_tdp())
>  		test_vmx_dirty_log(/*enable_ept=*/true);
>  
>  	return 0;
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

