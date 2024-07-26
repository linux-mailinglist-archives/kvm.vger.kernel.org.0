Return-Path: <kvm+bounces-22278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D334293CCAA
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 04:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 538A21F21E7E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 02:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243D51C6BE;
	Fri, 26 Jul 2024 02:13:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3A922EEF;
	Fri, 26 Jul 2024 02:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721960009; cv=none; b=ZUiMNI5zYzhUyEeUxX0NYHU9vTY+vrhzB7uxBUd+l8WCG+qRaT13Igd9jok1zTGNiNWLR3h1TqpOKAi8RbYCHjfUldtPbBZFO+NMeZchsD3TsxBIQJMlNWpq3MmfQZOKqs/QeclEucSy6kjsemi5xck1dACuGEntywYNTMyCU7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721960009; c=relaxed/simple;
	bh=HqY4XQUSLvr0yzGY1uG570fMO9Gjd2nrXF8D75jC9bQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bT7ZcwofIFwfE71o889TJVBtzV+PbwX1coZw32xW5y+MaILrK4MOy/QqMeJIUYl3M6aXZ9x6WIQ0IN+GNHke9aDpwGw314A4BZI341AOiLjmfBLlnAOihWEfenBAaqXvzpJE713SNe5T6PWaNHQdnkahxKIdZSaqM7Aohf6qKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dxi+pDBqNmjd0BAA--.7089S3;
	Fri, 26 Jul 2024 10:13:23 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCx2sVABqNmTQ0CAA--.11809S3;
	Fri, 26 Jul 2024 10:13:22 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Remove redundant assignment in
 kvm_map_page_fast
To: tangbin <tangbin@cmss.chinamobile.com>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240713155937.45261-1-tangbin@cmss.chinamobile.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <286be0a6-dac3-b2cd-e88a-e6feb5a240de@loongson.cn>
Date: Fri, 26 Jul 2024 10:13:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240713155937.45261-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx2sVABqNmTQ0CAA--.11809S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ww1Dur4rtr17Zry3XryDXFc_yoW8Kw17pr
	ZIkrnrCr4rtr1FkFZrta4DCFy29395KryxXa4Ig34rXwnFqr1Yq3W8X3yDZFy5J3ykZayS
	qF4rJ3WUuan0yacCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7_Ma
	UUUUU

Hi Tangbin,

There is only return value with -EFAULT or 0 in function 
kvm_map_page_fast(), if there is better error code or different error 
for new code, the situation will be different :)

I would like to keep existing code unchanged, however thanks for your patch.

Regards
Bibo Mao

On 2024/7/13 下午11:59, tangbin wrote:
> In the function kvm_map_page_fast, the assignment of 'ret' is
> redundant, so remove it.
> 
> Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
> ---
>   arch/loongarch/kvm/mmu.c | 17 +++++------------
>   1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 2634a9e8d..d6c922a4a 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -551,7 +551,6 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>    */
>   static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>   {
> -	int ret = 0;
>   	kvm_pfn_t pfn = 0;
>   	kvm_pte_t *ptep, changed, new;
>   	gfn_t gfn = gpa >> PAGE_SHIFT;
> @@ -563,20 +562,16 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   
>   	/* Fast path - just check GPA page table for an existing entry */
>   	ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
> -	if (!ptep || !kvm_pte_present(NULL, ptep)) {
> -		ret = -EFAULT;
> +	if (!ptep || !kvm_pte_present(NULL, ptep))
>   		goto out;
> -	}
>   
>   	/* Track access to pages marked old */
>   	new = kvm_pte_mkyoung(*ptep);
>   	/* call kvm_set_pfn_accessed() after unlock */
>   
>   	if (write && !kvm_pte_dirty(new)) {
> -		if (!kvm_pte_write(new)) {
> -			ret = -EFAULT;
> +		if (!kvm_pte_write(new))
>   			goto out;
> -		}
>   
>   		if (kvm_pte_huge(new)) {
>   			/*
> @@ -584,10 +579,8 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   			 * enabled for HugePages
>   			 */
>   			slot = gfn_to_memslot(kvm, gfn);
> -			if (kvm_slot_dirty_track_enabled(slot)) {
> -				ret = -EFAULT;
> +			if (kvm_slot_dirty_track_enabled(slot))
>   				goto out;
> -			}
>   		}
>   
>   		/* Track dirtying of writeable pages */
> @@ -615,10 +608,10 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   		if (page)
>   			put_page(page);
>   	}
> -	return ret;
> +	return 0;
>   out:
>   	spin_unlock(&kvm->mmu_lock);
> -	return ret;
> +	return -EFAULT;
>   }
>   
>   static bool fault_supports_huge_mapping(struct kvm_memory_slot *memslot,
> 


