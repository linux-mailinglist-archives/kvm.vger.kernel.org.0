Return-Path: <kvm+bounces-26674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F38297651B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 541421C23262
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD05919258D;
	Thu, 12 Sep 2024 09:03:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57209188A01;
	Thu, 12 Sep 2024 09:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726131819; cv=none; b=WUs+rS75kTH02NbCHltaMqUKuYfbSvb5Qh/cKc0b6pPooMAOXpgz4QfFvdC1Ma4QNXvuFRb3Oa6I9kC6qY+zdtRQt4GJ8cH4/RuLBIi8yrLn50GC5I2CzMjCEsnjfFdgQq1oDZGsCHb6B49iuFjuRISJY3osuleItyYFmxrwlXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726131819; c=relaxed/simple;
	bh=VJd4Y2IN/9od+WeuKVCAFWnWbNilas3cNK4GJ2oyySw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwKLHVTV09FobzY7Op4wm4v99TyYvH3SL4bK2rGlyxC3l5w4PaqhDxMjcCTdFJQhaRjM5a3cOWMngrq/uuuqPuAzg88N4ez2+7gZqpoRgNalOHtJA71CAHRhr5vlu3ZOesal4le2reK5H9IrFGGJn9Z2WwRCBfXcOEvVE0hI+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.114] (unknown [180.111.103.6])
	by APP-01 (Coremail) with SMTP id qwCowAC3aKhbruJmh60BAw--.7963S2;
	Thu, 12 Sep 2024 17:03:24 +0800 (CST)
Message-ID: <b5128162-278a-4284-8271-b2b91dc446e1@iscas.ac.cn>
Date: Thu, 12 Sep 2024 17:03:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Redirect instruction access fault trap to
 guest
To: anup@brainfault.org, ajones@ventanamicro.com, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <83c2234d582b7e823ce9ac9b73a6bbcf63971a29.1724911120.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <83c2234d582b7e823ce9ac9b73a6bbcf63971a29.1724911120.git.zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAC3aKhbruJmh60BAw--.7963S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtF1rtr1xWF43Gr4fGFW8Xrb_yoW8JryrpF
	43CF1a9r4rWFyq93WIvrs7uFWIqwn5K3ZxWr4jqFW5Xwsrtas5Crs0g3yUtFy8Gr4rX3yI
	9F4IqFyvyFn8twUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr0_Gr
	1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07UN2-5UUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCQ8SBmbifb-JEgAAsP


On 2024/8/29 14:20, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The M-mode redirects an unhandled instruction access
> fault trap back to S-mode when not delegating it to
> VS-mode(hedeleg). However, KVM running in HS-mode
> terminates the VS-mode software when back from M-mode.
> 
> The KVM should redirect the trap back to VS-mode, and
> let VS-mode trap handler decide the next step.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>   arch/riscv/kvm/vcpu_exit.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index fa98e5c024b2..696b62850d0b 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -182,6 +182,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>   	ret = -EFAULT;
>   	run->exit_reason = KVM_EXIT_UNKNOWN;
>   	switch (trap->scause) {
> +	case EXC_INST_ACCESS:

A gentle ping, the instruction access fault should be redirected to
VS-mode for handling, is my understanding correct?

>   	case EXC_INST_ILLEGAL:
>   	case EXC_LOAD_MISALIGNED:
>   	case EXC_STORE_MISALIGNED:
> 
> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba


