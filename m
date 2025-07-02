Return-Path: <kvm+bounces-51267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF77AF0DB9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90C31480686
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA422367AC;
	Wed,  2 Jul 2025 08:20:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BCD1E5B6D;
	Wed,  2 Jul 2025 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444454; cv=none; b=tgE5g7+mzFIriWgW4E77g1v/QUyWXWIJf6bmvsPYSsINvu+eaYBx6gyF3duFfaV5whzaYGRV+5SimlXOvEXkwEIaD7Th1Q8kEBKzsLeY1fk5i+HQt8gY6jKcDgcppL3QQuv9JlbvLBEM0BkZYtLYYD60/UUHrYkVZ3ONfbI2omI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444454; c=relaxed/simple;
	bh=eL/d+ZF8/YwG2i7e33qcbNOChozOQUzOE16BHM7lC4Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IzMSOcDn8xSSrxpZ7PNAtj/0QohJZ5t+9DROK4YkYjwKtEDzvA2k+/Qd5SssEh6Xt7F6Ykd9L9jxMMq1O4Sz2BIphmgoic8i2NUUTODBXsF0zFzIhSc5tJhp3LvHNQvcW2vM/TxIc7jkw5QG71NXOuz2N5RpXAdr/6CfSN3LQ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxjXLe62RoABYhAQ--.6468S3;
	Wed, 02 Jul 2025 16:20:46 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxocLa62RoBnoGAA--.36762S3;
	Wed, 02 Jul 2025 16:20:45 +0800 (CST)
Subject: Re: [RFC] x86/kvm: Use native qspinlock by default when realtime
 hinted
To: Liangyan <liangyan.peng@bytedance.com>, pbonzini@redhat.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20250702064218.894-1-liangyan.peng@bytedance.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
Date: Wed, 2 Jul 2025 16:19:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250702064218.894-1-liangyan.peng@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocLa62RoBnoGAA--.36762S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kr18trykJw1Utr1fJw15Jrc_yoW8ZFW5pF
	W5JF9avFWxXr1FvasrAFyvgr15WayDGw15uasrWryrtF1Yqr93Kr1kCr1rZw1YqFyxWa1S
	vF1FqF48Ca4DXFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
	I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUUUU=



On 2025/7/2 下午2:42, Liangyan wrote:
> When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
> currently guest will use virt_spin_lock.
> Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
> and have better performance than virt_spin_lock.
Just be curious, do you have actual data where native qspinlock has 
better performance than virt_spin_lock()?

By my understanding, qspinlock is not friendly with VM. When lock is 
released, it is acquired with one by one order in contending queue. If 
the first vCPU in contending queue is preempted, the other vCPUs can not 
get lock. On physical machine it is almost impossible that CPU 
contending lock is preempted.

Regards
Bibo Mao
> 
> Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
> ---
>   arch/x86/kernel/kvm.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 921c1c783bc1..9080544a4007 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
>    */
>   void __init kvm_spinlock_init(void)
>   {
> +	/*
> +	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
> +	 * are available.
> +	 */
> +	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints\n");
> +		goto out;
> +	}
> +
>   	/*
>   	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
>   	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> @@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
>   		return;
>   	}
>   
> -	/*
> -	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
> -	 * are available.
> -	 */
> -	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> -		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints\n");
> -		goto out;
> -	}
> -
>   	if (num_possible_cpus() == 1) {
>   		pr_info("PV spinlocks disabled, single CPU\n");
>   		goto out;
> 


