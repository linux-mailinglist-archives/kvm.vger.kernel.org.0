Return-Path: <kvm+bounces-25219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 900EE961B87
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 03:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DED5285085
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 01:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344BC3AC2B;
	Wed, 28 Aug 2024 01:34:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119BDBA41;
	Wed, 28 Aug 2024 01:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808855; cv=none; b=o4KWfjT0Um+tT1ru9IETbGCVXtEMeuXkRDngbJBbB5/V1RUNG35cVSS7AdGo7kw+L+VNC5aZdXoqTNkWp4R398dAukZwLC22MaCdF/jR8bITLkmyA9Ll9TwPTjBYTcCrLZ4wpxS92UHHZdtwO3q0mHDScnYxycpwv0wLSWgWHuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808855; c=relaxed/simple;
	bh=jXJwKIxwjynFk0lSDadFNFFEdN2d17y6EP185A9AB/w=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=A3+tsaiWym/oII8/9EZUadcWqH9VTkP/O2wdr0fEii8/9dXCd9LpdjTtubgZyKQ+02QEmRosBkegGaNNRUQXVUTj2pkuLRo5zHRmeMzXWxRvq1I605BNaeypFaJQkW8YweuhSyT9qjFqqCUShCZLeUi+fhj3OKWE/t0SUh8p6+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnOqSfs5m5UEiAA--.3968S3;
	Wed, 28 Aug 2024 09:34:10 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxiWaSfs5mSAslAA--.1685S3;
	Wed, 28 Aug 2024 09:34:10 +0800 (CST)
Subject: Re: [PATCH v2 1/2] LoongArch: Fix AP booting issue in VM mode
From: maobibo <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240815071545.925867-1-maobibo@loongson.cn>
 <20240815071545.925867-2-maobibo@loongson.cn>
Message-ID: <3e88f855-5edc-9416-0348-ea16cd860a1f@loongson.cn>
Date: Wed, 28 Aug 2024 09:33:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240815071545.925867-2-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxiWaSfs5mSAslAA--.1685S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGryxtry5CrW7AF4DAw13trc_yoW5AFW7pF
	W7ZrsYgF48Ka1kX3s8GayDur15ur9aqrWxuayUKryFyFZIgFnYqF1DGrW3XF18G3yIk3W0
	qFnY9F4jga1DJagCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jnUUUU
	UUUU=

ping.


On 2024/8/15 下午3:15, Bibo Mao wrote:
> Native IPI is used for AP booting, it is booting interface between
> OS and BIOS firmware. The paravirt ipi is only used inside OS, native
> IPI is necessary to boot AP.
> 
> When booting AP, BP writes kernel entry address in the HW mailbox of
> AP and send IPI interrupt to AP. AP executes idle instruction and
> waits for interrupt or SW events, and clears IPI interrupt and jumps
> to kernel entry from HW mailbox.
> 
> Between BP writes HW mailbox and is ready to send IPI to AP, AP is woken
> up by SW events and jumps to kernel entry, so ACTION_BOOT_CPU IPI
> interrupt will keep pending during AP booting. And native IPI interrupt
> handler needs be registered so that it can clear pending native IPI, else
> there will be endless IRQ handling during AP booting stage.
> 
> Here native ipi interrupt is initialized even if paravirt IPI is used.
> 
> Fixes: 74c16b2e2b0c ("LoongArch: KVM: Add PV IPI support on guest side")
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/kernel/paravirt.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
> index 9c9b75b76f62..348920b25460 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -13,6 +13,9 @@ static int has_steal_clock;
>   struct static_key paravirt_steal_enabled;
>   struct static_key paravirt_steal_rq_enabled;
>   static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
> +#ifdef CONFIG_SMP
> +static struct smp_ops old_ops;
> +#endif
>   
>   static u64 native_steal_clock(int cpu)
>   {
> @@ -55,6 +58,11 @@ static void pv_send_ipi_single(int cpu, unsigned int action)
>   	int min, old;
>   	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
>   
> +	if (unlikely(action == ACTION_BOOT_CPU)) {
> +		old_ops.send_ipi_single(cpu, action);
> +		return;
> +	}
> +
>   	old = atomic_fetch_or(BIT(action), &info->message);
>   	if (old)
>   		return;
> @@ -71,6 +79,12 @@ static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int action)
>   	__uint128_t bitmap = 0;
>   	irq_cpustat_t *info;
>   
> +	if (unlikely(action == ACTION_BOOT_CPU)) {
> +		/* Use native IPI to boot AP */
> +		old_ops.send_ipi_mask(mask, action);
> +		return;
> +	}
> +
>   	if (cpumask_empty(mask))
>   		return;
>   
> @@ -141,6 +155,8 @@ static void pv_init_ipi(void)
>   {
>   	int r, swi;
>   
> +	/* Init native ipi irq since AP booting uses it */
> +	old_ops.init_ipi();
>   	swi = get_percpu_irq(INT_SWI0);
>   	if (swi < 0)
>   		panic("SWI0 IRQ mapping failed\n");
> @@ -179,6 +195,9 @@ int __init pv_ipi_init(void)
>   		return 0;
>   
>   #ifdef CONFIG_SMP
> +	old_ops.init_ipi	= mp_ops.init_ipi;
> +	old_ops.send_ipi_single = mp_ops.send_ipi_single;
> +	old_ops.send_ipi_mask	= mp_ops.send_ipi_mask;
>   	mp_ops.init_ipi		= pv_init_ipi;
>   	mp_ops.send_ipi_single	= pv_send_ipi_single;
>   	mp_ops.send_ipi_mask	= pv_send_ipi_mask;
> 


