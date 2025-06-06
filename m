Return-Path: <kvm+bounces-48626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 889CFACFAB2
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 03:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 145E61895527
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 01:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D16735947;
	Fri,  6 Jun 2025 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VqrJUU7A"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5994D17BCE;
	Fri,  6 Jun 2025 01:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749173061; cv=none; b=nJCcw+xdcjmrp/GWAvlkDcC3cHZh/MGq3EvDtvx/bWe1W2XZZ9nUcVE5yBov2S4Kxm2rh8VQrexv16YSY2y0yTf5cttCMcv28RcEIL/ng7o7L2ZoFtXDFbuTxisD6TFGkQhycbScXyr1v0i0BWWZRNAtGwYBKN31kQ+FD/z19A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749173061; c=relaxed/simple;
	bh=9a+8dVoOU6Q0X47fam7mGjgtk1K1w+/rSe00VDfrNCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuoAM8ZF42ValY9OWF96FcqGZvRfoLuhBoQbzNTuc2cuRuROYHCqe549panAlj529qTYJpadOFqk1iRChZu3hZ9rIzWp1drmC7MIC3ZSmZEvr8flXYIUqQ6Y5zH5AtbvEGq8N/ZY+AVz/2eIMCSDj+JwaxBjUkBaVLJufe+nEdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VqrJUU7A; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <62127f1a-9225-463b-99d7-947970ea4566@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749173057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJK/hnY54oQVvH8TRxxIkliQGw6OOPeITtsaEgMgZ8k=;
	b=VqrJUU7Amz2gH+bou9q0erywhgpVUg2nncDGYqxQoZbbuJh7LnXqJMgfFuQ2OjBL6qgugV
	sK6FikWQIxN939njpJ9xE5K/OkWoG5dotw2aamV0tg+mbifo1GFPRrPsvi+0Yka9v4AwmH
	yNeWH1tlRfe7vofZ/Mp0MY3jyMBez/w=
Date: Thu, 5 Jun 2025 18:24:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL
 with KVM_REQ_TLB_FLUSH
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250605061458.196003-1-apatel@ventanamicro.com>
 <20250605061458.196003-7-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250605061458.196003-7-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/4/25 11:14 PM, Anup Patel wrote:
> The KVM_REQ_HFENCE_GVMA_VMID_ALL is same as KVM_REQ_TLB_FLUSH so
> to avoid confusion let's replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
> KVM_REQ_TLB_FLUSH. Also, rename kvm_riscv_hfence_gvma_vmid_all_process()
> to kvm_riscv_tlb_flush_process().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h | 4 ++--
>   arch/riscv/kvm/tlb.c              | 8 ++++----
>   arch/riscv/kvm/vcpu.c             | 8 ++------
>   3 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 134adc30af52..afaf25f2c5ab 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -36,7 +36,6 @@
>   #define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
>   #define KVM_REQ_FENCE_I			\
>   	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_HFENCE_GVMA_VMID_ALL	KVM_REQ_TLB_FLUSH
>   #define KVM_REQ_HFENCE_VVMA_ALL		\
>   	KVM_ARCH_REQ_FLAGS(4, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_HFENCE			\
> @@ -327,8 +326,9 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
>   				     unsigned long order);
>   void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
>   
> +void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
> +
>   void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
> -void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
>   void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
>   void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index b3461bfd9756..da98ca801d31 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -162,7 +162,7 @@ void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
>   	local_flush_icache_all();
>   }
>   
> -void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu)
> +void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
>   	unsigned long vmid = READ_ONCE(v->vmid);
> @@ -342,14 +342,14 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
>   	data.size = gpsz;
>   	data.order = order;
>   	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
> -			    KVM_REQ_HFENCE_GVMA_VMID_ALL, &data);
> +			    KVM_REQ_TLB_FLUSH, &data);
>   }
>   
>   void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
>   				    unsigned long hbase, unsigned long hmask)
>   {
> -	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_GVMA_VMID_ALL,
> -			    KVM_REQ_HFENCE_GVMA_VMID_ALL, NULL);
> +	make_xfence_request(kvm, hbase, hmask, KVM_REQ_TLB_FLUSH,
> +			    KVM_REQ_TLB_FLUSH, NULL);
>   }
>   
>   void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index cc7d00bcf345..684efaf5cee9 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -720,12 +720,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>   		if (kvm_check_request(KVM_REQ_FENCE_I, vcpu))
>   			kvm_riscv_fence_i_process(vcpu);
>   
> -		/*
> -		 * The generic KVM_REQ_TLB_FLUSH is same as
> -		 * KVM_REQ_HFENCE_GVMA_VMID_ALL
> -		 */
> -		if (kvm_check_request(KVM_REQ_HFENCE_GVMA_VMID_ALL, vcpu))
> -			kvm_riscv_hfence_gvma_vmid_all_process(vcpu);
> +		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
> +			kvm_riscv_tlb_flush_process(vcpu);
>   
>   		if (kvm_check_request(KVM_REQ_HFENCE_VVMA_ALL, vcpu))
>   			kvm_riscv_hfence_vvma_all_process(vcpu);
Reviewed-by: Atish Patra <atishp@rivosinc.com>

