Return-Path: <kvm+bounces-32897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A949E1646
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16167164953
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 08:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A091DE2A7;
	Tue,  3 Dec 2024 08:51:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2808C11;
	Tue,  3 Dec 2024 08:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733215915; cv=none; b=bFrx7YU9emfJrD0Opxb/2tPErb9Zn2m78DFrVmwNNwr/DHBJ2IiqlaXgxeorjeOv0XHoZScVYZ7OqeD7dYeg4qM56Kjd1eTMum89VTTQ3XfSpyR1sMq4UqTBCm1m+0z3BB7zZ07KZyipbjKlzTWTk5jakFDs+Jyv4DWN5oADaWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733215915; c=relaxed/simple;
	bh=9a4HS1lGr3UMK6mdUPo5Xx1GNq7+BWdWa6MBtV1k8f4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=joCVuNrfdpZlkWbz7xUwu8kSqNVKTjIGr/jwtn7oqYKxMZLhlWdMIi82s7Xz9x8Zl6rbVgwIO2k8sKeipYuE2yfHGUx1Hw8KVyMMYmSWI82ReqbXCSyOhnj+PxiXLslIMDqbH/U/5RlgQioxqGt72Niieu7tAVrSmj3iNomOxk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bx366ixk5n8I9PAA--.49532S3;
	Tue, 03 Dec 2024 16:51:46 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxP+Gexk5ntqFzAA--.34411S3;
	Tue, 03 Dec 2024 16:51:45 +0800 (CST)
Subject: Re: [PATCH 2/2] LoongArch: KVM: Protect kvm_io_bus_{read,write}()
 with SRCU
To: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini
 <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <20241203065058.4164631-1-chenhuacai@loongson.cn>
 <20241203065058.4164631-2-chenhuacai@loongson.cn>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <99ccaf01-9176-20c3-2463-148cb5cafcea@loongson.cn>
Date: Tue, 3 Dec 2024 16:51:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241203065058.4164631-2-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxP+Gexk5ntqFzAA--.34411S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ar1rCFWkCr47Jr43CF48AFc_yoW3JF1rpr
	yruay3uw4rJr97ZwnrAr1qvr1Yq3yv9F1UJrykJFWrGr1jvrn8JF48trW7ZFy5Kw1rCa1x
	XF1fJr1Ykr1jywcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4s2-UUUUU



On 2024/12/3 下午2:50, Huacai Chen wrote:
> When we enable lockdep we get such a warning:
> 
>   =============================
>   WARNING: suspicious RCU usage
>   6.12.0-rc7+ #1891 Tainted: G        W
>   -----------------------------
>   arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5945 suspicious rcu_dereference_check() usage!
>   other info that might help us debug this:
>   rcu_scheduler_active = 2, debug_locks = 1
>   1 lock held by qemu-system-loo/948:
>    #0: 90000001184a00a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0xf4/0xe20 [kvm]
>   stack backtrace:
>   CPU: 2 UID: 0 PID: 948 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc7+ #1891
>   Tainted: [W]=WARN
>   Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
>   Stack : 0000000000000089 9000000005a0db9c 90000000071519c8 900000012c578000
>           900000012c57b940 0000000000000000 900000012c57b948 9000000007e53788
>           900000000815bcc8 900000000815bcc0 900000012c57b7b0 0000000000000001
>           0000000000000001 4b031894b9d6b725 0000000005dec000 9000000100427b00
>           00000000000003d2 0000000000000001 000000000000002d 0000000000000003
>           0000000000000030 00000000000003b4 0000000005dec000 0000000000000000
>           900000000806d000 9000000007e53788 00000000000000b4 0000000000000004
>           0000000000000004 0000000000000000 0000000000000000 9000000107baf600
>           9000000008916000 9000000007e53788 9000000005924778 000000001fe001e5
>           00000000000000b0 0000000000000007 0000000000000000 0000000000071c1d
>           ...
>   Call Trace:
>   [<9000000005924778>] show_stack+0x38/0x180
>   [<90000000071519c4>] dump_stack_lvl+0x94/0xe4
>   [<90000000059eb754>] lockdep_rcu_suspicious+0x194/0x240
>   [<ffff80000221f47c>] kvm_io_bus_read+0x19c/0x1e0 [kvm]
>   [<ffff800002225118>] kvm_emu_mmio_read+0xd8/0x440 [kvm]
>   [<ffff8000022254bc>] kvm_handle_read_fault+0x3c/0xe0 [kvm]
>   [<ffff80000222b3c8>] kvm_handle_exit+0x228/0x480 [kvm]
> 
> Fix it by protecting kvm_io_bus_{read,write}() with SRCU.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   arch/loongarch/kvm/exit.c     | 31 +++++++++++++++++++++----------
>   arch/loongarch/kvm/intc/ipi.c |  6 +++++-
>   2 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 69f3e3782cc9..a7893bd01e73 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -156,7 +156,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
>   
>   int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   {
> -	int ret;
> +	int idx, ret;
>   	unsigned long *val;
>   	u32 addr, rd, rj, opcode;
>   
> @@ -167,7 +167,6 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   	rj = inst.reg2_format.rj;
>   	opcode = inst.reg2_format.opcode;
>   	addr = vcpu->arch.gprs[rj];
> -	ret = EMULATE_DO_IOCSR;
>   	run->iocsr_io.phys_addr = addr;
>   	run->iocsr_io.is_write = 0;
>   	val = &vcpu->arch.gprs[rd];
> @@ -207,20 +206,28 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (run->iocsr_io.is_write) {
> -		if (!kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (ret == 0)
>   			ret = EMULATE_DONE;
> -		else
> +		else {
> +			ret = EMULATE_DO_IOCSR;
>   			/* Save data and let user space to write it */
>   			memcpy(run->iocsr_io.data, val, run->iocsr_io.len);
> -
> +		}
>   		trace_kvm_iocsr(KVM_TRACE_IOCSR_WRITE, run->iocsr_io.len, addr, val);
>   	} else {
> -		if (!kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (ret == 0)
>   			ret = EMULATE_DONE;
> -		else
> +		else {
> +			ret = EMULATE_DO_IOCSR;
>   			/* Save register id for iocsr read completion */
>   			vcpu->arch.io_gpr = rd;
> -
> +		}
>   		trace_kvm_iocsr(KVM_TRACE_IOCSR_READ, run->iocsr_io.len, addr, NULL);
>   	}
>   
> @@ -359,7 +366,7 @@ static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
>   
>   int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
>   {
> -	int ret;
> +	int idx, ret;
>   	unsigned int op8, opcode, rd;
>   	struct kvm_run *run = vcpu->run;
>   
> @@ -464,8 +471,10 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
>   		 * it need not return to user space to handle the mmio
>   		 * exception.
>   		 */
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
>   		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
>   				      run->mmio.len, &vcpu->arch.gprs[rd]);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   		if (!ret) {
>   			update_pc(&vcpu->arch);
>   			vcpu->mmio_needed = 0;
> @@ -531,7 +540,7 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   
>   int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
>   {
> -	int ret;
> +	int idx, ret;
>   	unsigned int rd, op8, opcode;
>   	unsigned long curr_pc, rd_val = 0;
>   	struct kvm_run *run = vcpu->run;
> @@ -631,7 +640,9 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
>   		 * it need not return to user space to handle the mmio
>   		 * exception.
>   		 */
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
>   		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, vcpu->arch.badv, run->mmio.len, data);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   		if (!ret)
>   			return EMULATE_DONE;
>   
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
> index a233a323e295..4b7ff20ed438 100644
> --- a/arch/loongarch/kvm/intc/ipi.c
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -98,7 +98,7 @@ static void write_mailbox(struct kvm_vcpu *vcpu, int offset, uint64_t data, int
>   
>   static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
>   {
> -	int i, ret;
> +	int i, idx, ret;
>   	uint32_t val = 0, mask = 0;
>   
>   	/*
> @@ -107,7 +107,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
>   	 */
>   	if ((data >> 27) & 0xf) {
>   		/* Read the old val */
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
here should be idx = srcu_read_lock(&vcpu->kvm->srcu) ?

>   		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   		if (unlikely(ret)) {
>   			kvm_err("%s: : read date from addr %llx failed\n", __func__, addr);
>   			return ret;
> @@ -121,7 +123,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
>   		val &= mask;
>   	}
>   	val |= ((uint32_t)(data >> 32) & ~mask);
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
here should be idx = srcu_read_lock(&vcpu->kvm->srcu)

>   	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   	if (unlikely(ret))
>   		kvm_err("%s: : write date to addr %llx failed\n", __func__, addr);
>   
> 
otherwise looks good to me.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>


