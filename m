Return-Path: <kvm+bounces-21472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A73692F5CA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50FEB281C29
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 06:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CF913D628;
	Fri, 12 Jul 2024 06:55:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D2E157E84;
	Fri, 12 Jul 2024 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720767316; cv=none; b=LgqiBfsOssPwaoo4S4cqa8AjNxHrFyQp2ALkGGJqNMONQpEAQAjj9z2YDVsXBt5ygMO/2vwEa7GS82tar0z/eCUQkBWhT54XbZjsP/JyltPnr0cXpgv+NRZm+N9XeUszWQkFILXnfsF874UR00h6/27Y/fdgB1Lt2AkOi10zu84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720767316; c=relaxed/simple;
	bh=usMyPBmwjlLAVglz+9yx79fn8nmpfP6b3u/cmknSBb4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R3EXe0wrV5Jf2yT2uSu68erGJu1wm+b/aM2NvsGJ49nLoiNUsc0NswBDQ41R/8oyD1gn5vqb3hRGyrDa5vPhCMtV9l9JrQnPP9aJDpA7P9u51neR9kT4a4uxhLboq60VvVMCyXwFcwxvxpB2jCAJByVQCOfgGGW6/Bpd+B2CKGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx_vBO05BmPJUDAA--.10561S3;
	Fri, 12 Jul 2024 14:55:10 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axw8RI05Bmn4BFAA--.16410S3;
	Fri, 12 Jul 2024 14:55:07 +0800 (CST)
Subject: Re: [PATCH 01/11] LoongArch: KVM: Add iocsr and mmio bus simulation
 in kernel
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-2-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4bd4a664-25c8-d86d-533a-d3dc338e0bec@loongson.cn>
Date: Fri, 12 Jul 2024 14:55:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-2-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axw8RI05Bmn4BFAA--.16410S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JF18Xr4Uur4DGw1DXr17CFX_yoW7urWUpF
	y5u3srZw4rtrZ7AwnrWrsa9ry2v395GFy7X3s7JrWfur1UtF95Ar40krWjvFWUJr9avF4x
	Z3WfJFy7C3WUA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Add iocsr and mmio memory read and write simulation to the kernel.
> When the VM accesses the device address space through iocsr
> instructions or mmio, it does not need to return to the qemu
> user mode but directly completes the access in the kernel mode.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Min Zhou <zhoumin@loongson.cn>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Xianglai li <lixianglai@loongson.cn>
> 
>   arch/loongarch/kvm/exit.c | 69 ++++++++++++++++++++++++++++-----------
>   include/linux/kvm_host.h  |  1 +
>   2 files changed, 51 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index a68573e091c0..e8e37e135dd1 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -148,7 +148,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
>   int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   {
>   	int ret;
> -	unsigned long val;
> +	unsigned long *val;
>   	u32 addr, rd, rj, opcode;
>   
>   	/*
> @@ -161,6 +161,7 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   	ret = EMULATE_DO_IOCSR;
>   	run->iocsr_io.phys_addr = addr;
>   	run->iocsr_io.is_write = 0;
> +	val = &vcpu->arch.gprs[rd];
>   
>   	/* LoongArch is Little endian */
>   	switch (opcode) {
> @@ -194,15 +195,21 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>   		break;
>   	default:
>   		ret = EMULATE_FAIL;
> -		break;
> +		return ret;
How about directly return such as *return EMULATE_FAIL;* ?

>   	}
>   
> -	if (ret == EMULATE_DO_IOCSR) {
> -		if (run->iocsr_io.is_write) {
> -			val = vcpu->arch.gprs[rd];
> -			memcpy(run->iocsr_io.data, &val, run->iocsr_io.len);
> -		}
> -		vcpu->arch.io_gpr = rd;
> +	if (run->iocsr_io.is_write) {
> +		if (!kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
It exceeds 80 chars, it will be better if line wrapper is added.

> +			ret = EMULATE_DONE;
> +		else
> +			/* Save data and let user space to write it */
> +			memcpy(run->iocsr_io.data, val, run->iocsr_io.len);
> +	} else {
> +		if (!kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
Ditto.
> +			ret = EMULATE_DONE;
> +		else
> +			/* Save register id for iocsr read completion */
> +			vcpu->arch.io_gpr = rd;
>   	}
>   
>   	return ret;
> @@ -438,19 +445,33 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
>   	}
>   
>   	if (ret == EMULATE_DO_MMIO) {
> +		/*
> +		 * if mmio device such as pch pic is emulated in KVM,
> +		 * it need not return to user space to handle the mmio
> +		 * exception.
> +		 */
> +		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
> +				run->mmio.len, &vcpu->arch.gprs[rd]);
> +		if (!ret) {
> +			update_pc(&vcpu->arch);
> +			vcpu->mmio_needed = 0;
> +			return EMULATE_DONE;
> +		}
> +
>   		/* Set for kvm_complete_mmio_read() use */
>   		vcpu->arch.io_gpr = rd;
>   		run->mmio.is_write = 0;
>   		vcpu->mmio_is_write = 0;
>   		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
>   				run->mmio.phys_addr, NULL);
Should the trace function be called for KVM_MMIO_BUS also? I think the 
trace function should be called before kvm_io_bus_read.

> -	} else {
> -		kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
> -			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> -		kvm_arch_vcpu_dump_regs(vcpu);
> -		vcpu->mmio_needed = 0;
> +		return EMULATE_DO_MMIO;
>   	}
>   
> +	kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
> +			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> +	kvm_arch_vcpu_dump_regs(vcpu);
> +	vcpu->mmio_needed = 0;
> +
Empty line is not necessary from my view :)
>   	return ret;
>   }
>   
> @@ -591,19 +612,29 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
>   	}
>   
>   	if (ret == EMULATE_DO_MMIO) {
> +		/*
> +		 * if mmio device such as pch pic is emulated in KVM,
> +		 * it need not return to user space to handle the mmio
> +		 * exception.
> +		 */
> +		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
> +				run->mmio.len, data);
> +		if (!ret)
> +			return EMULATE_DONE;
> +
>   		run->mmio.is_write = 1;
>   		vcpu->mmio_needed = 1;
>   		vcpu->mmio_is_write = 1;
>   		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
>   				run->mmio.phys_addr, data);
Ditto, trace function should be put before kvm_io_bus_write.

> -	} else {
> -		vcpu->arch.pc = curr_pc;
> -		kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
> -			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> -		kvm_arch_vcpu_dump_regs(vcpu);
> -		/* Rollback PC if emulation was unsuccessful */
> +		return EMULATE_DO_MMIO;
>   	}
>   
> +	vcpu->arch.pc = curr_pc;
> +	kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
> +			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> +	kvm_arch_vcpu_dump_regs(vcpu);
> +	/* Rollback PC if emulation was unsuccessful */
>   	return ret;
>   }
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 692c01e41a18..f51b2e53d81c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -219,6 +219,7 @@ enum kvm_bus {
>   	KVM_PIO_BUS,
>   	KVM_VIRTIO_CCW_NOTIFY_BUS,
>   	KVM_FAST_MMIO_BUS,
> +	KVM_IOCSR_BUS,
>   	KVM_NR_BUSES
>   };
I just think this patch should be after PCH/EXTIOI/IPI is created and 
IOCSR/MMIO space is registered in kernel space.It is only my points, I 
am not good at this:(

Regards
Bibo Mao
>   
> 


