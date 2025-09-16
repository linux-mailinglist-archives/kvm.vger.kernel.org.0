Return-Path: <kvm+bounces-57665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10070B58B2B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 03:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 428041B2443E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 01:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AC3220F5C;
	Tue, 16 Sep 2025 01:30:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677141DF265;
	Tue, 16 Sep 2025 01:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757986211; cv=none; b=QiavSt2pbrwrEByiMAgAYg9eM3vs8icCyYOOLIJsgmenIl58O3nRNWKqPy3KDr/Vp/AFsUS+5Y0NyxYonL/Gb8PohVwxQCfs6i/msDtxUNaGMoSkyfAbQiEgNPs34m4b1BkTs2hsK6snnVmpQPLtdpNVnjQlkQcYqhPYF1IZwDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757986211; c=relaxed/simple;
	bh=Rm0gHAfk+FjEIZWY7YKRbPW4JOwxvHlJnH3iKfsrlHY=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CkuZ0cO3xhJrM9skK4Ged5yMsIiYddUUTGFf0yFZrpgzF/PGL7sCX0PXZ/CKHUxsP5WIMpPxJhH+CSi163LDbtYo0Wixq3n1TfEh7K6cl+oNo1n5m7rvu4eFWxnmwi8vPU8Sm71EdYUx5aHx2Kp0Ooef1KglET/1wb7/mZImxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxaNGXvcho2cUKAA--.23230S3;
	Tue, 16 Sep 2025 09:29:59 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxvsGVvcho7lSYAA--.49454S3;
	Tue, 16 Sep 2025 09:29:59 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: rework pch_pic_update_batch_irqs()
To: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Xianglai Li <lixianglai@loongson.cn>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250913002907.69703-1-yury.norov@gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <0e330fc0-1200-6a02-7b21-78064fc63a2e@loongson.cn>
Date: Tue, 16 Sep 2025 09:27:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250913002907.69703-1-yury.norov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxvsGVvcho7lSYAA--.49454S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CF1DGFW5AF47WFyDtr4UJrc_yoW8GF1UpF
	W5uanIkFs5Gr1DXFy8uayUtF4ayrnrtr1SgF9F934xKrnxtr1FvF1kGrWkX3W5K393GF4I
	vrs3tr1Sqa47AacCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXU
	UUUU=



On 2025/9/13 上午8:29, Yury Norov (NVIDIA) wrote:
> Use proper bitmap API and drop all the housekeeping code.
> 
> Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> ---
>   arch/loongarch/kvm/intc/pch_pic.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
> index 119290bcea79..57e13ae51d24 100644
> --- a/arch/loongarch/kvm/intc/pch_pic.c
> +++ b/arch/loongarch/kvm/intc/pch_pic.c
> @@ -35,16 +35,11 @@ static void pch_pic_update_irq(struct loongarch_pch_pic *s, int irq, int level)
>   /* update batch irqs, the irq_mask is a bitmap of irqs */
>   static void pch_pic_update_batch_irqs(struct loongarch_pch_pic *s, u64 irq_mask, int level)
>   {
> -	int irq, bits;
> +	DECLARE_BITMAP(irqs, 64) = { BITMAP_FROM_U64(irq_mask) };
> +	unsigned int irq;
>   
> -	/* find each irq by irqs bitmap and update each irq */
> -	bits = sizeof(irq_mask) * 8;
> -	irq = find_first_bit((void *)&irq_mask, bits);
> -	while (irq < bits) {
> +	for_each_set_bit(irq, irqs, 64)
>   		pch_pic_update_irq(s, irq, level);
> -		bitmap_clear((void *)&irq_mask, irq, 1);
> -		irq = find_first_bit((void *)&irq_mask, bits);
> -	}
>   }
>   
>   /* called when a irq is triggered in pch pic */
> 
Thanks for doing this.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>


