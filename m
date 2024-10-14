Return-Path: <kvm+bounces-28706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A576499BD3F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 03:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A8491F21D12
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 01:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F8CF9D9;
	Mon, 14 Oct 2024 01:19:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9841BC2A;
	Mon, 14 Oct 2024 01:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728868764; cv=none; b=oGW3e7Lf90pdElgBhgRYLxFEIFIEQIukhunCnQ3J/3VDMuPwyjeZZn0iGH8xAR3z5cPX9qRRuxIsRtmfKFBGIii9OUJJuYJYkdLpnnkwaYCRjhvUlxant8ezNSyquZrSRbl1PFc3xCqFjQwzifSjvtvEyigcJNxYmCnDpivmjOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728868764; c=relaxed/simple;
	bh=zUv6ILKKCU7ghNWQyBMVZ63qcvkg6BgiCPLp6kS4zzQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HjnjAPXVQK0ib6yU+C8vLXBoz4q61jdL+qooAoTEvJV8DUMS5vuUs5kBeQPhY417rxRS3MU8bRfCmKOAtdYGvCCyHY/Lj3NzfzX3+p10ps94XgOXE6eVrR3zp0ekxN3ihEGzK6iOc2dVQNHkRS2BV8qAJB+nHnbtdLamErkmYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dxn_GQcQxns7MZAA--.41498S3;
	Mon, 14 Oct 2024 09:19:12 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAx_9WNcQxn32goAA--.13131S3;
	Mon, 14 Oct 2024 09:19:11 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Mark hrtimer to expire in hard interrupt
 context
To: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini
 <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20241013090136.1254036-1-chenhuacai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <395a4ab9-ee2b-618d-3836-3ff041582ab2@loongson.cn>
Date: Mon, 14 Oct 2024 09:18:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241013090136.1254036-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx_9WNcQxn32goAA--.13131S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGF13tF4xur4kAw47Gr4kAFc_yoWrtF1fpr
	WUAr48Gr48Jr17tw1jyFyDuF45Xw4DCF1xXFWUAry8Ar17Wrn8XF18KrW3JFs8Jw4UAF1x
	Xr18tr1aqF15J3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=



On 2024/10/13 下午5:01, Huacai Chen wrote:
> Like commit 2c0d278f3293fc5 ("KVM: LAPIC: Mark hrtimer to expire in hard
> interrupt context"), On PREEMPT_RT enabled kernels unmarked hrtimers are
> moved into soft interrupt expiry mode by default.
> 
> While that's not a functional requirement for the KVM constant timer
> emulation, it is a latency issue which can be avoided by marking the
> timer so hard interrupt context expiry is enforced.
> 
> This fix a "scheduling while atomic" bug for PREEMPT_RT enabled kernels:
> 
>   BUG: scheduling while atomic: qemu-system-loo/1011/0x00000002
>   Modules linked in: amdgpu rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ns
>   CPU: 1 UID: 0 PID: 1011 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc2+ #1774
>   Tainted: [W]=WARN
>   Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
>   Stack : ffffffffffffffff 0000000000000000 9000000004e3ea38 9000000116744000
>           90000001167475a0 0000000000000000 90000001167475a8 9000000005644830
>           90000000058dc000 90000000058dbff8 9000000116747420 0000000000000001
>           0000000000000001 6a613fc938313980 000000000790c000 90000001001c1140
>           00000000000003fe 0000000000000001 000000000000000d 0000000000000003
>           0000000000000030 00000000000003f3 000000000790c000 9000000116747830
>           90000000057ef000 0000000000000000 9000000005644830 0000000000000004
>           0000000000000000 90000000057f4b58 0000000000000001 9000000116747868
>           900000000451b600 9000000005644830 9000000003a13998 0000000010000020
>           00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
>           ...
>   Call Trace:
>   [<9000000003a13998>] show_stack+0x38/0x180
>   [<9000000004e3ea34>] dump_stack_lvl+0x84/0xc0
>   [<9000000003a71708>] __schedule_bug+0x48/0x60
>   [<9000000004e45734>] __schedule+0x1114/0x1660
>   [<9000000004e46040>] schedule_rtlock+0x20/0x60
>   [<9000000004e4e330>] rtlock_slowlock_locked+0x3f0/0x10a0
>   [<9000000004e4f038>] rt_spin_lock+0x58/0x80
>   [<9000000003b02d68>] hrtimer_cancel_wait_running+0x68/0xc0
>   [<9000000003b02e30>] hrtimer_cancel+0x70/0x80
>   [<ffff80000235eb70>] kvm_restore_timer+0x50/0x1a0 [kvm]
>   [<ffff8000023616c8>] kvm_arch_vcpu_load+0x68/0x2a0 [kvm]
>   [<ffff80000234c2d4>] kvm_sched_in+0x34/0x60 [kvm]
>   [<9000000003a749a0>] finish_task_switch.isra.0+0x140/0x2e0
>   [<9000000004e44a70>] __schedule+0x450/0x1660
>   [<9000000004e45cb0>] schedule+0x30/0x180
>   [<ffff800002354c70>] kvm_vcpu_block+0x70/0x120 [kvm]
>   [<ffff800002354d80>] kvm_vcpu_halt+0x60/0x3e0 [kvm]
>   [<ffff80000235b194>] kvm_handle_gspr+0x3f4/0x4e0 [kvm]
>   [<ffff80000235f548>] kvm_handle_exit+0x1c8/0x260 [kvm]
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   arch/loongarch/kvm/timer.c | 7 ++++---
>   arch/loongarch/kvm/vcpu.c  | 2 +-
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> index 74a4b5c272d6..32dc213374be 100644
> --- a/arch/loongarch/kvm/timer.c
> +++ b/arch/loongarch/kvm/timer.c
> @@ -161,10 +161,11 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
>   	if (kvm_vcpu_is_blocking(vcpu)) {
>   
>   		/*
> -		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
> -		 * the same physical cpu in next time
> +		 * HRTIMER_MODE_PINNED_HARD is suggested since vcpu may run in
> +		 * the same physical cpu in next time, and the timer should run
> +		 * in hardirq context even in the PREEMPT_RT case.
>   		 */
> -		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
> +		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED_HARD);
>   	}
>   }
>   
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 0697b1064251..174734a23d0a 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1457,7 +1457,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.vpid = 0;
>   	vcpu->arch.flush_gpa = INVALID_GPA;
>   
> -	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
> +	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
>   	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
>   
>   	vcpu->arch.handle_exit = kvm_handle_exit;
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


