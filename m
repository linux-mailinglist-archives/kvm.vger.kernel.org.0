Return-Path: <kvm+bounces-4603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C48F28157A2
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 06:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF79C1C238EB
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 05:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C545F11705;
	Sat, 16 Dec 2023 05:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y5GOZijB"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DAC10A06;
	Sat, 16 Dec 2023 05:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=LNbpWQOmt7apCl5n0HnfiCBr/R0dZ7dJOsEv+sS5huc=; b=y5GOZijB/vsGTnQ+5eB2ALoG0J
	QbRBUDvMMXk8egB3bzntff0aMPHjDgL1QBarq3yN7547EbeMlZYrraYv7y4oaxu77e0Bj8MdYaUUF
	1UWCgYXMlfuQ2CqZ/gCBNgqkQXDbehSH8acWnkSip8lKqa9rZpXGpHzulX2LSFxjqrrishniuxvyg
	HVclsNKj/+S+bjT7s43UjOy1y2YL2zFXBv9sJ+1oZhf4c6cR/8ebJGgz6FEO/ryZ6tTYD2wvvBE5G
	DgRBtO131N3UhZRagRg7D/fbD+ce66yx+98zteFsLpZHAJGFVQmm99Uuzgx88JNiiQfODb/UkjX2N
	8U5PuARw==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEMuE-005RHJ-2R;
	Sat, 16 Dec 2023 05:08:06 +0000
Message-ID: <15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
Date: Fri, 15 Dec 2023 21:08:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
Content-Language: en-US
To: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini
 <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20231115090735.2404866-1-chenhuacai@loongson.cn>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20231115090735.2404866-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Someone please merge this patch...
Thanks.


On 11/15/23 01:07, Huacai Chen wrote:
> Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> to fix build.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/loongarch/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 80480df5f550..9463ebecd39b 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -627,7 +627,7 @@ static bool fault_supports_huge_mapping(struct kvm_memory_slot *memslot,
>   *
>   * There are several ways to safely use this helper:
>   *
> - * - Check mmu_invalidate_retry_hva() after grabbing the mapping level, before
> + * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, before
>   *   consuming it.  In this case, mmu_lock doesn't need to be held during the
>   *   lookup, but it does need to be held while checking the MMU notifier.
>   *
> @@ -807,7 +807,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>  
>  	/* Check if an invalidation has taken place since we got pfn */
>  	spin_lock(&kvm->mmu_lock);
> -	if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
> +	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
>  		/*
>  		 * This can happen when mappings are changed asynchronously, but
>  		 * also synchronously if a COW is triggered by

-- 
#Randy
https://people.kernel.org/tglx/notes-about-netiquette
https://subspace.kernel.org/etiquette.html

