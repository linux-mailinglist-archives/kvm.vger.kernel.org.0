Return-Path: <kvm+bounces-49550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFDAAD9930
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 02:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75B091712EF
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA61179A7;
	Sat, 14 Jun 2025 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u/e9RR/r"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2B6BA50
	for <kvm@vger.kernel.org>; Sat, 14 Jun 2025 00:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749861865; cv=none; b=ERQxaoCrU1+bVYGnK3nmyLGVw1581NGrHaPPNI2H0ULL3sqjIQVUhdZNgLx2sGRucPj6TAAZFl2G1gh1AXcFpHBjNlht0Ajrq0vtLsd+Ek53CY4q3OFfu6SGNN5/EZ3Iynt1EDIRJ+OU11UCT53zF0Ia+2HvDD0MOT8IUfEwcBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749861865; c=relaxed/simple;
	bh=29cRgpEIn9i77ft2ErJCGJTeGJHKAHEj16jzFLOkDO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AOOFC/PdvJzAgB5cfr0PBVtv+7ikg4TtOlWGdupzKNflLqqtErmYgI0ZcqBBY6+Nv6L43OW+9XnzScNIbyNuzoYHFEMgfSFAHNzvXFLGtBIUcGzBchD3ZN3DLkJJZhlqHtTwX/KQrTPhrBKRvsdjhdmid8IG0ZlxW3sbO6Q493w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u/e9RR/r; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <422c5677-48d1-41be-b128-595829c27167@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749861853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXuSTcUn0J6P+iqyqyqHY+kzA3pvndl/3kAQ7RECPmE=;
	b=u/e9RR/rxfXPFPycnlPVQqNrU5k0V5o6T4a0vCElbgKU5CYulJQONn820Lt+bxrHKt3EJj
	9HC0jaQ//KBjncZGpnjDfEzSqPcZs914149pSwPRty719isCXS245ZnwGFUdJjeAcsJvWy
	YIWig0jncgm0xUQ2x57lRJYqQf2oUeE=
Date: Fri, 13 Jun 2025 17:43:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 06/12] RISC-V: KVM: Implement
 kvm_arch_flush_remote_tlbs_range()
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-7-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250613065743.737102-7-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/12/25 11:57 PM, Anup Patel wrote:
> The kvm_arch_flush_remote_tlbs_range() expected by KVM core can be
> easily implemented for RISC-V using kvm_riscv_hfence_gvma_vmid_gpa()
> hence provide it.
>
> Also with kvm_arch_flush_remote_tlbs_range() available for RISC-V, the
> mmu_wp_memory_region() can happily use kvm_flush_remote_tlbs_memslot()
> instead of kvm_flush_remote_tlbs().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h | 2 ++
>   arch/riscv/kvm/mmu.c              | 2 +-
>   arch/riscv/kvm/tlb.c              | 8 ++++++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index ff1f76d6f177..6162575e2177 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -43,6 +43,8 @@
>   	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +
>   #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
>   					 BIT(EXC_BREAKPOINT)      | \
>   					 BIT(EXC_SYSCALL)         | \
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 29f1bd853a66..a5387927a1c1 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -344,7 +344,7 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
>   	spin_lock(&kvm->mmu_lock);
>   	gstage_wp_range(kvm, start, end);
>   	spin_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index da98ca801d31..f46a27658c2e 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -403,3 +403,11 @@ void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
>   	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
>   			    KVM_REQ_HFENCE_VVMA_ALL, NULL);
>   }
> +
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
> +{
> +	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
> +				       gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
> +				       PAGE_SHIFT);
> +	return 0;
> +}

LGTM. However, I noticed that kvm_flush_remote_tlbs_range doesn't 
increment remote_tlb_flush_requests/remote_tlb_flush stat counter.

So we would be losing those stats here. Do you know if there is a 
specific reason behind not supporting the stat counters in the *tlbs_range
function ?

Otherwise,
Reviewed-by: Atish Patra <atishp@rivosinc.com>


