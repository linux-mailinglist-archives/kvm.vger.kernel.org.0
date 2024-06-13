Return-Path: <kvm+bounces-19533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34954906066
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 03:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6AD8283114
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F2BD534;
	Thu, 13 Jun 2024 01:27:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75934D30B
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 01:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718242053; cv=none; b=bWlpHmwH2SoP+5tPg5G776HRi4/476bEyq66Ly1rvYqWe7LiCYwxLqHmkaa+SSVectX02gBNEFN7vXamYI/IwqQxwJvOjl1aodFpC693um7Mo4aGwyZRaCbazAVKuf7EJzsuv28wL1QSC2ob8VNTJxOq9ji+kojVAWT6w73MtuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718242053; c=relaxed/simple;
	bh=5mgBH13DKl/I/xUby8jCKmJWhWVgmo/bpC3wtoWpOaY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NxK1eTVlkU2juhO9fB8wwk6FRrSLbJrlpM5V6F0EHiaCZKM2Ub7cHbstJbefL4PjrouwTyQ4rs5bfMhlSwinAnZxuuOpjlpNzS+2ziLwNrlKh9U1QAZZFeCfyaYHNseItVw+Gug5rbMlGNKZ8wjvwmnpx4D7xO2JmyUZP/X5ylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxHuv4Smpm8T0GAA--.25401S3;
	Thu, 13 Jun 2024 09:27:21 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxnsf1SmpmjvgdAA--.8480S3;
	Thu, 13 Jun 2024 09:27:19 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: always make pte yong in page map's fast
 path
To: jiaqingtong97@gmail.com, zhaotianrui@loongson.cn, chenhuacai@kernel.org,
 kernel@xen0n.name
Cc: loongarch@lists.linux.dev, kvm@vger.kernel.org
References: <20240613003217.129303-1-jiaqingtong97@gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <28916be2-f14d-069b-0543-172e261375a6@loongson.cn>
Date: Thu, 13 Jun 2024 09:27:17 +0800
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
X-CM-TRANSID:AQAAf8Bxnsf1SmpmjvgdAA--.8480S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CryfWryUJr18Ww1xXrW5Arc_yoW8XFy5pF
	WfCr1Dtr48Jr1fKrnIqaykXF45u398Gr4Iqa12934UCrnFqFyxu3y0qrZ5X34DA392ya1f
	ZFyrJ3WxWa90y3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjWlkUUUUU=

Hi Qingtong,

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
Thanks for noticing this.

The logic is right, however it does not improve performance to update 
pte entry unconditionally since pte entry is frequently accessed by HW 
and multpile CPUs. There may be cache thrashing issue, just maybe from 
my own point -:)

It is the same such as test_and_set_bit implementation on x86 or other 
architectures, it is not unconditionally logic or on x86.

Regards
Bibo Mao
>   
>   	if (write && !kvm_pte_dirty(new)) {
>   		if (!kvm_pte_write(new)) {
> 
> base-commit: eb36e520f4f1b690fd776f15cbac452f82ff7bfa
> 


