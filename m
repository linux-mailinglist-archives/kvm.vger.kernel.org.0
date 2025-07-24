Return-Path: <kvm+bounces-53325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D76EB0FE64
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 03:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 652B817180B
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6B519004A;
	Thu, 24 Jul 2025 01:41:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D27D156661;
	Thu, 24 Jul 2025 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753321290; cv=none; b=sk29Ue0d45VHRfpCLMN0f2ABoQNCbIMbfTeqdnzPQIjzCR1NYAKN5Jl49Qac98t8SmD7IY6S2j4h93wHYsBASq69e8FzAz7g9LdFQQufEftL5qsnReTuHenFTJHHf8lzXYptH6I48W0PNGLyHUuO9a0ljLDr91+QyFuyWu/9QFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753321290; c=relaxed/simple;
	bh=1BXpZI4scZTyVma5PgiR4xOt+Q2ng527W4S4xuCME2Y=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PVdjCbnTLKx4GvJ1C3Wkx2VmSDdurms7cqmeIczb6JxvW86RdEhmCQMf1gcEIw+YOC2uoj3RKPcT2eziRbrBPZFvMbNKc8pCv0NRzjU+3iA5CCkrI9IG0ytWiQjt/trqcehfUGFASdu618dT2LLI8yNjTK44JhfMv5tycoA4AT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxPOJEj4FoG8swAQ--.57961S3;
	Thu, 24 Jul 2025 09:41:24 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxocJAj4FotAYkAA--.53925S3;
	Thu, 24 Jul 2025 09:41:22 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic
 code
To: Steven Rostedt <rostedt@goodmis.org>, LKML
 <linux-kernel@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20250722094734.4920545b@gandalf.local.home>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
Date: Thu, 24 Jul 2025 09:39:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250722094734.4920545b@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocJAj4FotAYkAA--.53925S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAr43urW3Kr17Cr4Uuw4xXwc_yoW5uF4kpF
	17ArZIgr4xKrs7A34fZwn5Krsxu3s5uFy7t3srWrWkCF48Ar4rGr1qvrWkt3sIy3sYka4x
	tF1vvryUGayUZ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOiSdUUU
	UU=



On 2025/7/22 下午9:47, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The tracepoint kvm_iocsr is only used by the loongarch architecture. As
> trace events can take up to 5K of memory, move this tracepoint into the
> loongarch specific tracing file so that it doesn't waste memory for all
> other architectures.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   arch/loongarch/kvm/trace.h | 35 +++++++++++++++++++++++++++++++++++
>   include/trace/events/kvm.h | 35 -----------------------------------
>   2 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> index 145514dab6d5..d73dea8afb74 100644
> --- a/arch/loongarch/kvm/trace.h
> +++ b/arch/loongarch/kvm/trace.h
> @@ -115,6 +115,41 @@ TRACE_EVENT(kvm_exit_gspr,
>   			__entry->inst_word)
>   );
>   
> +#define KVM_TRACE_IOCSR_READ_UNSATISFIED 0
> +#define KVM_TRACE_IOCSR_READ 1
> +#define KVM_TRACE_IOCSR_WRITE 2
> +
> +#define kvm_trace_symbol_iocsr \
> +	{ KVM_TRACE_IOCSR_READ_UNSATISFIED, "unsatisfied-read" }, \
> +	{ KVM_TRACE_IOCSR_READ, "read" }, \
> +	{ KVM_TRACE_IOCSR_WRITE, "write" }
> +
> +TRACE_EVENT(kvm_iocsr,
> +	TP_PROTO(int type, int len, u64 gpa, void *val),
> +	TP_ARGS(type, len, gpa, val),
> +
> +	TP_STRUCT__entry(
> +		__field(	u32,	type	)
> +		__field(	u32,	len	)
> +		__field(	u64,	gpa	)
> +		__field(	u64,	val	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->type		= type;
> +		__entry->len		= len;
> +		__entry->gpa		= gpa;
> +		__entry->val		= 0;
> +		if (val)
> +			memcpy(&__entry->val, val,
> +			       min_t(u32, sizeof(__entry->val), len));
> +	),
> +
> +	TP_printk("iocsr %s len %u gpa 0x%llx val 0x%llx",
> +		  __print_symbolic(__entry->type, kvm_trace_symbol_iocsr),
> +		  __entry->len, __entry->gpa, __entry->val)
> +);
> +
>   #define KVM_TRACE_AUX_SAVE		0
>   #define KVM_TRACE_AUX_RESTORE		1
>   #define KVM_TRACE_AUX_ENABLE		2
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 8b7252b8d751..b282e3a86769 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -156,41 +156,6 @@ TRACE_EVENT(kvm_mmio,
>   		  __entry->len, __entry->gpa, __entry->val)
>   );
>   
> -#define KVM_TRACE_IOCSR_READ_UNSATISFIED 0
> -#define KVM_TRACE_IOCSR_READ 1
> -#define KVM_TRACE_IOCSR_WRITE 2
> -
> -#define kvm_trace_symbol_iocsr \
> -	{ KVM_TRACE_IOCSR_READ_UNSATISFIED, "unsatisfied-read" }, \
> -	{ KVM_TRACE_IOCSR_READ, "read" }, \
> -	{ KVM_TRACE_IOCSR_WRITE, "write" }
> -
> -TRACE_EVENT(kvm_iocsr,
> -	TP_PROTO(int type, int len, u64 gpa, void *val),
> -	TP_ARGS(type, len, gpa, val),
> -
> -	TP_STRUCT__entry(
> -		__field(	u32,	type	)
> -		__field(	u32,	len	)
> -		__field(	u64,	gpa	)
> -		__field(	u64,	val	)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->type		= type;
> -		__entry->len		= len;
> -		__entry->gpa		= gpa;
> -		__entry->val		= 0;
> -		if (val)
> -			memcpy(&__entry->val, val,
> -			       min_t(u32, sizeof(__entry->val), len));
> -	),
> -
> -	TP_printk("iocsr %s len %u gpa 0x%llx val 0x%llx",
> -		  __print_symbolic(__entry->type, kvm_trace_symbol_iocsr),
> -		  __entry->len, __entry->gpa, __entry->val)
> -);
> -
>   #define kvm_fpu_load_symbol	\
>   	{0, "unload"},		\
>   	{1, "load"}
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


