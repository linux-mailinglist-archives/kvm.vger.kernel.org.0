Return-Path: <kvm+bounces-66563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4FFCD7B83
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 02:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E42E30DDA2F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 01:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27607352953;
	Tue, 23 Dec 2025 01:27:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C1E350D58;
	Tue, 23 Dec 2025 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766453274; cv=none; b=TP5juCCHMWeTSOCvsBK5IEvwKw5MPigj5gUJ8mitNCEd2vGjqC/uML4Ob2Dygf+BkWslK9JXJQyX6mJn0+d6+NXnQQ6nJ2M3r6uaSmlUrvhY2mf2RXeDvjozPM8r3stF+Z74NQi9Mdk9eINua5Lb6GPbRK3DFxKY5k+QgAmXiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766453274; c=relaxed/simple;
	bh=EiSccUwHH1y9gPi/yQ/Pfx3UYwckUvKIjhlNFOmdrXI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ua0gIrSdP5cBa4D6tW3L22YWQp0i8dMyHmPvO9IHxXhfE8M+TOms6jjYIhfndkjGrxECq3DMkpkLU0DIjBpv5Ug/yF10ABHTWFMcrZI7Ji7MTt3/LBy8I1zaKLw0+e76KmKG4b5eiVYAwrm4QDygbCYqd03qwDcS5E+z/fgoSwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxisIR8ElpAzoCAA--.6899S3;
	Tue, 23 Dec 2025 09:27:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxSeAN8ElpnaMDAA--.11084S3;
	Tue, 23 Dec 2025 09:27:43 +0800 (CST)
Subject: Re: [PATCH V2 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Xianglai Li <lixianglai@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-3-lixianglai@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <e1f4b85e-0177-91b7-c422-22ed60607260@loongson.cn>
Date: Tue, 23 Dec 2025 09:25:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251222113409.2343711-3-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxSeAN8ElpnaMDAA--.11084S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuF1Dur48tr1xKFyftrW5Jwc_yoW5GFWxpa
	4avF1qqF4kKw1vga1DG34qkr4xZFWkWr1xWrn7tryrZr1kWryrXF18GwsxAFn8Gw48WF4k
	XFy8KFn0vay8AwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4AhLUUUUU



On 2025/12/22 下午7:34, Xianglai Li wrote:
> Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
> the assembly function to guide the generation of correct ORC table entries,
> thereby solving the timeout problem of loading the livepatch-sample module
> on a physical machine running multiple vcpus virtual machines.
> 
> While solving the above problems, we have gained an additional benefit,
> that is, we can obtain more call stack information
> 
> Stack information that can be obtained before the problem is fixed:
> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> [<0>] kvm_exc_entry+0x100/0x1e0
> 
> Stack information that can be obtained after the problem is fixed:
> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> [<0>] kvm_exc_entry+0x100/0x1e0
> [<0>] kvm_arch_vcpu_ioctl_run+0x260/0x488 [kvm]
> [<0>] kvm_vcpu_ioctl+0x200/0xcd8 [kvm]
> [<0>] sys_ioctl+0x498/0xf00
> [<0>] do_syscall+0x94/0x190
> [<0>] handle_syscall+0xb8/0x158
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Charlie Jenkins <charlie@rivosinc.com>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> 
>   arch/loongarch/kvm/switch.S | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 93845ce53651..e3ecb24a3bc5 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -170,6 +170,7 @@ SYM_CODE_START(kvm_exc_entry)
>   	/* restore per cpu register */
>   	ld.d	u0, a2, KVM_ARCH_HPERCPU
>   	addi.d	sp, sp, -PT_SIZE
> +	UNWIND_HINT_REGS
>   
>   	/* Prepare handle exception */
>   	or	a0, s0, zero
> @@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
>   	addi.d	a2, sp, -PT_SIZE
>   	/* Save host GPRs */
>   	kvm_save_host_gpr a2
> +	st.d	ra, a2, PT_ERA
Had better add some comments here to show that it is special for unwind 
usage since there is "st.d ra, a2, PT_R1" already in macro 
kvm_save_host_gpr().

Regards
Bibo Mao
>   
>   	addi.d	a2, a1, KVM_VCPU_ARCH
>   	st.d	sp, a2, KVM_ARCH_HSP
> 


