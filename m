Return-Path: <kvm+bounces-15184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6158AA700
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 04:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCC2CB21535
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 02:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0EF7748E;
	Fri, 19 Apr 2024 02:36:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC2E37C;
	Fri, 19 Apr 2024 02:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713494183; cv=none; b=aLtQJRIZgbRDPkHJhJ6+BmbJzrY1Rv0enArG7qGoX1C0UPJqBBFQ9JyUQGFTBo5332iQxVOlbh5l3XvM0d1vQ3SdJJ8prJMv/FYNfsEzIMEkbeKH59yiUABImh/9SsDs5vWHtO/cSIN4F/NTw4xqS5sDs6Ru2rgFCShAgCUgKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713494183; c=relaxed/simple;
	bh=qYMQuTSjMOuc6HgYpB2N1Ti9jC+RyfAZ9XKAK6mbNRw=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZMVwS2QTtw7chwtWNDC+G5rhwC/5J7cnLWm4JVkZ7DEgGnrnqPLxln8Lh4Dco+o+U0lj5P3z7dN0YMnq3L1zhSgVZ03j1YfoHK57yslfCxrr6frjIAR1NmN39VrwQzOvAgfcQ1JO7BZ4/o2BuBjagJbCHVmVd9hXSVaJhoxFyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxK+mi2CFm55kpAA--.10364S3;
	Fri, 19 Apr 2024 10:36:18 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxRMyh2CFmJcV_AA--.37543S3;
	Fri, 19 Apr 2024 10:36:17 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add mmio trace support
From: maobibo <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240409094900.1118699-1-maobibo@loongson.cn>
Message-ID: <414a9d1d-842d-8cdd-377d-8272d753ebc8@loongson.cn>
Date: Fri, 19 Apr 2024 10:36:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240409094900.1118699-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxRMyh2CFmJcV_AA--.37543S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWrW5ZryUKF4fuw17AF1kJFc_yoWrWr45pF
	1DCr1DWr4kKrnFywnrXwsY9rs8ZFZ3u34kXFy7WrWIvr1xXFn5Grn2grWqkFWUK39Y9F4x
	XF4vkasrua1DZ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwMKu
	UUUUU

slightly ping...

On 2024/4/9 下午5:49, Bibo Mao wrote:
> Add mmio trace event support, currently generic mmio events
> KVM_TRACE_MMIO_WRITE/xxx_READ/xx_READ_UNSATISFIED are added here.
> 
> Also vcpu id field is added for all kvm trace events, since perf
> KVM tool parses vcpu id information for kvm entry event.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/kvm/exit.c  |  7 +++++++
>   arch/loongarch/kvm/trace.h | 20 ++++++++++++++------
>   2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index ed1d89d53e2e..3c05aade0122 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -9,6 +9,7 @@
>   #include <linux/module.h>
>   #include <linux/preempt.h>
>   #include <linux/vmalloc.h>
> +#include <trace/events/kvm.h>
>   #include <asm/fpu.h>
>   #include <asm/inst.h>
>   #include <asm/loongarch.h>
> @@ -417,6 +418,8 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
>   		vcpu->arch.io_gpr = rd;
>   		run->mmio.is_write = 0;
>   		vcpu->mmio_is_write = 0;
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
> +				run->mmio.phys_addr, NULL);
>   	} else {
>   		kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
>   			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> @@ -463,6 +466,8 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   		break;
>   	}
>   
> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, run->mmio.len,
> +			run->mmio.phys_addr, run->mmio.data);
>   	return er;
>   }
>   
> @@ -564,6 +569,8 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
>   		run->mmio.is_write = 1;
>   		vcpu->mmio_needed = 1;
>   		vcpu->mmio_is_write = 1;
> +		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
> +				run->mmio.phys_addr, data);
>   	} else {
>   		vcpu->arch.pc = curr_pc;
>   		kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> index c2484ad4cffa..1783397b1bc8 100644
> --- a/arch/loongarch/kvm/trace.h
> +++ b/arch/loongarch/kvm/trace.h
> @@ -19,14 +19,16 @@ DECLARE_EVENT_CLASS(kvm_transition,
>   	TP_PROTO(struct kvm_vcpu *vcpu),
>   	TP_ARGS(vcpu),
>   	TP_STRUCT__entry(
> +		__field(unsigned int, vcpu_id)
>   		__field(unsigned long, pc)
>   	),
>   
>   	TP_fast_assign(
> +		__entry->vcpu_id = vcpu->vcpu_id;
>   		__entry->pc = vcpu->arch.pc;
>   	),
>   
> -	TP_printk("PC: 0x%08lx", __entry->pc)
> +	TP_printk("vcpu %u PC: 0x%08lx", __entry->vcpu_id, __entry->pc)
>   );
>   
>   DEFINE_EVENT(kvm_transition, kvm_enter,
> @@ -54,19 +56,22 @@ DECLARE_EVENT_CLASS(kvm_exit,
>   	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>   	    TP_ARGS(vcpu, reason),
>   	    TP_STRUCT__entry(
> +			__field(unsigned int, vcpu_id)
>   			__field(unsigned long, pc)
>   			__field(unsigned int, reason)
>   	    ),
>   
>   	    TP_fast_assign(
> +			__entry->vcpu_id = vcpu->vcpu_id;
>   			__entry->pc = vcpu->arch.pc;
>   			__entry->reason = reason;
>   	    ),
>   
> -	    TP_printk("[%s]PC: 0x%08lx",
> -		      __print_symbolic(__entry->reason,
> -				       kvm_trace_symbol_exit_types),
> -		      __entry->pc)
> +	    TP_printk("vcpu %u [%s] PC: 0x%08lx",
> +			__entry->vcpu_id,
> +			__print_symbolic(__entry->reason,
> +				kvm_trace_symbol_exit_types),
> +			__entry->pc)
>   );
>   
>   DEFINE_EVENT(kvm_exit, kvm_exit_idle,
> @@ -85,14 +90,17 @@ TRACE_EVENT(kvm_exit_gspr,
>   	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
>   	    TP_ARGS(vcpu, inst_word),
>   	    TP_STRUCT__entry(
> +			__field(unsigned int, vcpu_id)
>   			__field(unsigned int, inst_word)
>   	    ),
>   
>   	    TP_fast_assign(
> +			__entry->vcpu_id = vcpu->vcpu_id;
>   			__entry->inst_word = inst_word;
>   	    ),
>   
> -	    TP_printk("Inst word: 0x%08x", __entry->inst_word)
> +	    TP_printk("vcpu %u Inst word: 0x%08x", __entry->vcpu_id,
> +			__entry->inst_word)
>   );
>   
>   #define KVM_TRACE_AUX_SAVE		0
> 
> base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
> 


