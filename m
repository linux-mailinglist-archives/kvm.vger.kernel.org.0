Return-Path: <kvm+bounces-66956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9F7CEF08A
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 18:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E80E7300AFD5
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 17:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D605428725A;
	Fri,  2 Jan 2026 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tE3edi5d"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19666176ADE
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767373968; cv=none; b=VQ8rzz+Ywwc1t0FxjFtYlhtZq7U+L2F5uBuz0wiUvBm9RMk3/QXgxWfMagfUPJXoVuzsq9/Kaigg2BEUprILW8yvilJadp1W3gYE7QOqRnSZon4mdVrVEFWKt9yY/8TuCwNM6nqATko0CAH9DBh/nzCzgZmhQuuEqimVf5uqtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767373968; c=relaxed/simple;
	bh=m7CcLV+RKDA9af6SLmRAl1Gf5wgIWP2PpUJ0Fc/Ksig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrPeg+yePqMcyC27Fn799EhRKuobBGtqxVrQx94rpX8bf8QHkgof6TsWz01vDJ8ygfLrSU0BydDji5j7szbmdHhkfmMVT1rzEo2gc3+NGl3iB/Fmnf8Q5jCRrdRP3GgnKGBIwGSfE0Gp6UTFaNTiEpJa6PvTMeQCenYSlR79JnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tE3edi5d; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Jan 2026 17:12:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767373964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBw6jLCJqAbKt1gkP3x7IcMHDaYkQ9qOJdP3tWYRjcc=;
	b=tE3edi5dhKdd1e36NLf+C61+fg98V5chjikLV24JwFiW9GnZCHh5NRwOvEyOW+ozrhieYo
	hHIlCrKKBYF/gSbrNYalY/OPgEJM8dNARujl6Uiuqa5V2geAPoIry9JOrOcH4h/2f3DEhM
	mOCd6qfzfDqEhcx2+z7etRL8NSM+u64=
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
Subject: Re: [PATCH v4 11/21] KVM: selftests: Stop passing VMX metadata to
 TDP mapping functions
Message-ID: <rkbap4vemw6yu52djlg7lerquuhucw3urlvbvfpekfxgnibosf@ijebzfchpulp>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-12-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:40PM -0800, Sean Christopherson wrote:
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> The root GPA can now be retrieved from the nested MMU, stop passing VMX
> metadata. This is in preparation for making these functions work for
> NPTs as well.
> 
> Opportunistically drop tdp_pg_map() since it's unused.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86/vmx.h | 11 ++-----
>  .../testing/selftests/kvm/lib/x86/memstress.c | 11 +++----
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 33 +++++++------------
>  .../selftests/kvm/x86/vmx_dirty_log_test.c    |  9 +++--
>  4 files changed, 24 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
> index 1fd83c23529a..4dd4c2094ee6 100644
> --- a/tools/testing/selftests/kvm/include/x86/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86/vmx.h
> @@ -557,14 +557,9 @@ bool load_vmcs(struct vmx_pages *vmx);
>  
>  bool ept_1g_pages_supported(void);
>  
> -void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
> -		uint64_t paddr);
> -void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
> -	     uint64_t paddr, uint64_t size);
> -void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
> -				       struct kvm_vm *vm);
> -void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
> -			 uint64_t addr, uint64_t size);
> +void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
> +void tdp_identity_map_default_memslots(struct kvm_vm *vm);
> +void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
>  bool kvm_cpu_has_ept(void);
>  void vm_enable_ept(struct kvm_vm *vm);
>  void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
> index 00f7f11e5f0e..3319cb57a78d 100644
> --- a/tools/testing/selftests/kvm/lib/x86/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
> @@ -59,7 +59,7 @@ uint64_t memstress_nested_pages(int nr_vcpus)
>  	return 513 + 10 * nr_vcpus;
>  }
>  
> -static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *vm)
> +static void memstress_setup_ept_mappings(struct kvm_vm *vm)
>  {
>  	uint64_t start, end;
>  
> @@ -68,16 +68,15 @@ static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *v
>  	 * KVM can shadow the EPT12 with the maximum huge page size supported
>  	 * by the backing source.
>  	 */
> -	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
> +	tdp_identity_map_1g(vm, 0, 0x100000000ULL);
>  
>  	start = align_down(memstress_args.gpa, PG_SIZE_1G);
>  	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
> -	tdp_identity_map_1g(vmx, vm, start, end - start);
> +	tdp_identity_map_1g(vm, start, end - start);
>  }
>  
>  void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
>  {
> -	struct vmx_pages *vmx;
>  	struct kvm_regs regs;
>  	vm_vaddr_t vmx_gva;
>  	int vcpu_id;
> @@ -87,11 +86,11 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
>  
>  	vm_enable_ept(vm);
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> -		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
> +		vcpu_alloc_vmx(vm, &vmx_gva);
>  
>  		/* The EPTs are shared across vCPUs, setup the mappings once */
>  		if (vcpu_id == 0)
> -			memstress_setup_ept_mappings(vmx, vm);
> +			memstress_setup_ept_mappings(vm);

Oh and if you're feeling nitpicky while applying, I think this call can
actually be moved outside of the loop now, right after vm_enable_ept(),
dropping the whole vcpu_id == 0 special case.

>  
>  		/*
>  		 * Override the vCPU to run memstress_l1_guest_code() which will

