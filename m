Return-Path: <kvm+bounces-19534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C16906140
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 03:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20F03283616
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FAC17756;
	Thu, 13 Jun 2024 01:45:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA91EEC8
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 01:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718243112; cv=none; b=O/4Kf0INw0aInPPxZWmtw4XVp8aNG0CadaA7PC/aDXwfhgSyiGdwGH0gWmYHQUNDOF4hxPJL/HJhgH6N6nPVuFNXgJPHmv1K0KL8Z8daHuGggU+4ZovdceCASqz5Pz2Yl7d/qgWGISytFleOMSjP4aI7Xur88vPBYtoG/K0JDpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718243112; c=relaxed/simple;
	bh=NNQ079lVsIfIshJjuc6aYA7UFVnnnc0bUnjPOIrn3iI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=abzFta2uCQuy513BNLZnGFRxTsgy/yHIBSnjh6m6FIVx1pKgPYpMho/cgfhYpoCpKLBY+Cld2DRpIqLOgLCSaON7FRSqPl0sggmntCW5hwBmH1I9+JWW0x9RrKeMHy79ZbWQQOui55yfHZPZ22QTPv/pLbXTcC2C7nxiw+PPZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxyOkiT2pmSD8GAA--.12560S3;
	Thu, 13 Jun 2024 09:45:07 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMcgT2pmZv4dAA--.8036S3;
	Thu, 13 Jun 2024 09:45:06 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: always make pte yong in page map's fast
 path
To: jiaqingtong97@gmail.com, zhaotianrui@loongson.cn, chenhuacai@kernel.org,
 kernel@xen0n.name
Cc: loongarch@lists.linux.dev, kvm@vger.kernel.org
References: <20240613003217.129303-1-jiaqingtong97@gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <7fcf7b1a-187e-5573-a9f1-336871106af1@loongson.cn>
Date: Thu, 13 Jun 2024 09:45:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240613003217.129303-1-jiaqingtong97@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMcgT2pmZv4dAA--.8036S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Jr4UZr4UWr4UXw17tFy5Awc_yoW8JF1xpF
	WfCw1DKrW8JrnrKFnIqa98XF47u395Gr1Iqa9Fya45urnFqFW8uw4FqrZ5X34DA3yIka1f
	ZFyrJa97Wa90y3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jeSoXUUUUU=



On 2024/6/13 上午8:32, jiaqingtong97@gmail.com wrote:
> From: Jia Qingtong <jiaqingtong97@gmail.com>
> 
> It seems redundant to check if pte is yong before the call to
> kvm_pte_mkyoung in kvm_map_page_fast.
> Just remove the check.
> 
> Signed-off-by: Jia Qingtong <jiaqingtong97@gmail.com>
> ---
>   arch/loongarch/kvm/mmu.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 98883aa23ab8..a46befcf85dc 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -551,10 +551,8 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   	}
>   
>   	/* Track access to pages marked old */
> -	new = *ptep;
> -	if (!kvm_pte_young(new))
> -		new = kvm_pte_mkyoung(new);
> -		/* call kvm_set_pfn_accessed() after unlock */
> +	new = kvm_pte_mkyoung(*ptep);
> +	/* call kvm_set_pfn_accessed() after unlock */
Sorry, please ignore my previous comments.
It is to modify local variable, rather than update pte entry.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>

>   
>   	if (write && !kvm_pte_dirty(new)) {
>   		if (!kvm_pte_write(new)) {
> 
> base-commit: eb36e520f4f1b690fd776f15cbac452f82ff7bfa
> 


