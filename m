Return-Path: <kvm+bounces-50625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4739DAE78CD
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE7F81BC5E12
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8566C2135D7;
	Wed, 25 Jun 2025 07:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="4GaTykie"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-19.ptr.tlmpb.com (sg-3-19.ptr.tlmpb.com [101.45.255.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1DA210F59
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836938; cv=none; b=lw6Uu5/oh4HjxTwNaRZhwpv3BTJG/78AKaF4X1rn1FqafBmh0deSIKLf1vvYmHdYBx8L9C5TQ+X1GD51isF1XtVDnTU6vR4YYdGmrjsoWdbBknbzSBjlNQ+DqubZaA8xM+SP7+QPrXhuB0svMPSNFNk0BWeXP6rJCFFxXrQDJZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836938; c=relaxed/simple;
	bh=a3DMDdHA6v6pJEswAP0XuoxOFgG+epMDo8MP/gCuqCc=;
	h=From:To:Cc:Mime-Version:Content-Type:Date:Message-Id:Subject:
	 In-Reply-To:References; b=SrawG6/5E9Ja+it90qTaksPtTnABFd4r+Zd5BaSEzuhf7EcqsyT64DxKEXK6HtkXRluSAV3Usv4FVuMQa796bT1khvLHmMvIewm0Q/q5kYfAAPZPWYZz6IUhqB1zjSQ+PrK1hB98H+gc77Rmvy3HBjNtLxvbWB+iQZ8QHZu4t7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=4GaTykie; arc=none smtp.client-ip=101.45.255.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750836927;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CEUqe5ahfZFpVFJnOYxZcTEDjpo1QaA063NLvGo/wqE=;
 b=4GaTykiebG8UNFNWxzI0CcLswfHuuePdzu31ndQJtrBNXMy4B8WQCqIc1vbDAFofS1GWU2
 z0PFgNdpMRTiW/vq+GgDbtpziDRA4Yr0XL6636HYF2aswHkKBSCqJUJr8DKcRK4YfjgGgL
 0t5IJn7BhFQGkXNfis1NlC03x/U9XU3Unpik1KgFlh9fupDoOHSjSBMv4DLrmHxYxfICvw
 dMfkj6u+8RHBb5T6G+Ua9Bw8cyMOfGCIYvUtrA9csuGzL3Y0o+rbMd/P8opCQSBdMsiJh/
 SMoyjYsHio0+TevQ4HTJ7DBzs9pXIi7V5GGqglbpPMS5L/zw8wOXT2L0ctkf8w==
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Content-Language: en-US
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jun 2025 15:35:23 +0800
Message-Id: <794a81fa-41d5-4b1e-816f-6d63b883f935@lanxincomputing.com>
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Subject: Re: [PATCH v3 04/12] RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FLUSH
X-Lms-Return-Path: <lba+2685ba6bd+3a517f+vger.kernel.org+liujingqi@lanxincomputing.com>
In-Reply-To: <20250618113532.471448-5-apatel@ventanamicro.com>
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 15:35:24 +0800
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-5-apatel@ventanamicro.com>

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The KVM_REQ_HFENCE_GVMA_VMID_ALL is same as KVM_REQ_TLB_FLUSH so
> to avoid confusion let's replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
> KVM_REQ_TLB_FLUSH. Also, rename kvm_riscv_hfence_gvma_vmid_all_process()
> to kvm_riscv_tlb_flush_process().
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h | 4 ++--
>   arch/riscv/kvm/tlb.c              | 8 ++++----
>   arch/riscv/kvm/vcpu.c             | 8 ++------
>   3 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 8aa705ac75a5..ff1f76d6f177 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -37,7 +37,6 @@
>   #define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
>   #define KVM_REQ_FENCE_I			\
>   	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_HFENCE_GVMA_VMID_ALL	KVM_REQ_TLB_FLUSH
>   #define KVM_REQ_HFENCE_VVMA_ALL		\
>   	KVM_ARCH_REQ_FLAGS(4, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_HFENCE			\
> @@ -331,8 +330,9 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
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
> index a2dd4161e5a4..6eb11c913b13 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -721,12 +721,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
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

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty

