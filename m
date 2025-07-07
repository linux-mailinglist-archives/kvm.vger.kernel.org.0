Return-Path: <kvm+bounces-51635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D906AFAA38
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E3117951E
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731A525A359;
	Mon,  7 Jul 2025 03:30:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D291D259CBD;
	Mon,  7 Jul 2025 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859032; cv=none; b=Cs6iWPnjdPzxDirqK1ELGmXe1OFrHWUQkpCSPfbGheLe5nnwn2G/PYy3m/7ipq5ObKrlL5g6+VDa+hBvw0DPeACMvg4VEv6qqe7GkslJle/f1G/Zo8kSzgvNh64IpG4JqE/Q0H3EZXpjitcuJDC7ZkNetEOqht6CHqbLY04J/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859032; c=relaxed/simple;
	bh=jcllR5P8q4bLzpLytl+VWfbXYNskCJm/L07jIzv8ark=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tdrAXXFbsSr3zktGmT5DC/IrSjeJOajEWDymQWP8+KfZeW1ZWMnmm4sIi/yRCpAVqN4Xe9bIJ4NalSneBCWH8gPZscwgr5TrcRNF/NtHAu3o+EnC9WYti+ubDpjVdpdvOBXj5Apw/rzPHk8cjXDNI4oSZW9x+ObbxlYeT9CFhyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxjaxMP2toQUcjAQ--.42680S3;
	Mon, 07 Jul 2025 11:30:20 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxQ+RJP2toGVYMAA--.6511S3;
	Mon, 07 Jul 2025 11:30:19 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add tracepoints for CPUCFG and CSR
 emulation exits
To: Yulong Han <wheatfox17@icloud.com>, chenhuacai@kernel.org
Cc: kernel@xen0n.name, zhaotianrui@loongson.cn, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250702105922.1035771-1-wheatfox17@icloud.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <9e9b54fe-4762-f128-a53f-1a92d160a5b7@loongson.cn>
Date: Mon, 7 Jul 2025 11:28:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250702105922.1035771-1-wheatfox17@icloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+RJP2toGVYMAA--.6511S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7AF47ZF15uw4DJw13Kw17urX_yoW5JFWfpr
	1vvws0gw4rKrySvwsFqws5WrsxAwsagry7XF9xCFWYvr4IqryrJFy8KrWDuF18KwnY9a4I
	qF95u3WqkF4qq3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zw
	Z7UUUUU==

On 2025/7/2 下午6:59, Yulong Han wrote:
> This patch adds tracepoints to track KVM exits caused by CPUCFG
> and CSR emulation. Note that IOCSR emulation tracing is already
> covered by the generic trace_kvm_iocsr().
> 
> Signed-off-by: Yulong Han <wheatfox17@icloud.com>
> ---
>   arch/loongarch/kvm/exit.c  |  2 ++
>   arch/loongarch/kvm/trace.h | 14 +++++++++++++-
>   2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index fa52251b3bf1c..6a47a23ae9cd6 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -289,9 +289,11 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>   	er = EMULATE_FAIL;
>   	switch (((inst.word >> 24) & 0xff)) {
>   	case 0x0: /* CPUCFG GSPR */
> +		trace_kvm_exit_cpucfg(vcpu, KVM_TRACE_EXIT_CPUCFG);
>   		er = kvm_emu_cpucfg(vcpu, inst);
>   		break;
>   	case 0x4: /* CSR{RD,WR,XCHG} GSPR */
> +		trace_kvm_exit_csr(vcpu, KVM_TRACE_EXIT_CSR);
>   		er = kvm_handle_csr(vcpu, inst);
>   		break;
>   	case 0x6: /* Cache, Idle and IOCSR GSPR */
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> index 1783397b1bc88..145514dab6d5b 100644
> --- a/arch/loongarch/kvm/trace.h
> +++ b/arch/loongarch/kvm/trace.h
> @@ -46,11 +46,15 @@ DEFINE_EVENT(kvm_transition, kvm_out,
>   /* Further exit reasons */
>   #define KVM_TRACE_EXIT_IDLE		64
>   #define KVM_TRACE_EXIT_CACHE		65
> +#define KVM_TRACE_EXIT_CPUCFG		66
> +#define KVM_TRACE_EXIT_CSR		67
>   
>   /* Tracepoints for VM exits */
>   #define kvm_trace_symbol_exit_types			\
>   	{ KVM_TRACE_EXIT_IDLE,		"IDLE" },	\
> -	{ KVM_TRACE_EXIT_CACHE,		"CACHE" }
> +	{ KVM_TRACE_EXIT_CACHE,		"CACHE" },	\
> +	{ KVM_TRACE_EXIT_CPUCFG,	"CPUCFG" },	\
> +	{ KVM_TRACE_EXIT_CSR,		"CSR" }
>   
>   DECLARE_EVENT_CLASS(kvm_exit,
>   	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> @@ -82,6 +86,14 @@ DEFINE_EVENT(kvm_exit, kvm_exit_cache,
>   	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>   	     TP_ARGS(vcpu, reason));
>   
> +DEFINE_EVENT(kvm_exit, kvm_exit_cpucfg,
> +	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +	     TP_ARGS(vcpu, reason));
> +
> +DEFINE_EVENT(kvm_exit, kvm_exit_csr,
> +	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
> +	     TP_ARGS(vcpu, reason));
> +
>   DEFINE_EVENT(kvm_exit, kvm_exit,
>   	     TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
>   	     TP_ARGS(vcpu, reason));
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


