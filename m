Return-Path: <kvm+bounces-40015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C494FA4DD40
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A23189B659
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 11:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0AC20102F;
	Tue,  4 Mar 2025 11:58:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508A11FECAA;
	Tue,  4 Mar 2025 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741089483; cv=none; b=tclJTbagBVzM3oqXYehdpRZZyMcWJiKRbiQe4YcmW5jjQ0T40IFNLDgCYW5rOIeBmI6Svj3AwU6z4Xc5rlq7z6WFu9psya+CRY6i6vuPgMdxgX/i3rKl1BJt+VMYH4CQF9wwCgfCxxVDxFKt2LmAe696ARacrmtq3CGeIUpycbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741089483; c=relaxed/simple;
	bh=Nhu10BBEZYqhWwvbHcZpp6y3LPzTzrFgTqW0s1XBdmU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u9spylQ8Y+eyVaNjBY2jsyVvpt8GOxsSDUQsK4udq0KsqixAyBf/arHXi+eW0vkBtbILPdaj3G6gFXztFXaOirAVI8U21RN9bsBJI+uHhwzA+kElkNrMGCe7Zqr/sJY7BnuPXsb2vlthul5r5vH0A29evm1HHE2dTZhCQqvo3Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxmnHG6sZnKg+KAA--.39228S3;
	Tue, 04 Mar 2025 19:57:58 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxLcXD6sZnQ401AA--.65028S3;
	Tue, 04 Mar 2025 19:57:57 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Reload guest CSR registers after S4
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xianglai Li <lixianglai@loongson.cn>
References: <20250303091114.1511496-1-maobibo@loongson.cn>
 <CAAhV-H7VGkmRhu+bV0ueLdbaaxuY7W9tLu3yyYeK75FLSvRaug@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <8f3ae3e5-6827-7c8d-2b80-726b56254ea1@loongson.cn>
Date: Tue, 4 Mar 2025 19:57:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7VGkmRhu+bV0ueLdbaaxuY7W9tLu3yyYeK75FLSvRaug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLcXD6sZnQ401AA--.65028S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXw4kAF48Wr45JryDXryxJFc_yoW5XF48pr
	WUC3Z8trWrKr1Ik34qv3Z0qr4DuryDKr1Iv3yqqFyay3saqF1FgrWrKayDZFyUu3yFkF4I
	qryrK3WY9F45JwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25EfUUUU
	U



On 2025/3/3 下午10:06, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, Mar 3, 2025 at 5:11 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> On host HW guest CSR registers are lost after suspend and resume
>> operation. Since last_vcpu of boot CPU still records latest vCPU pointer
>> so that guest CSR register skips to reload when boot CPU resumes and
>> vCPU is scheduled.
>>
>> Here last_vcpu is cleared so that guest CSR register will reload from
>> scheduled vCPU context after suspend and resume.
>>
>> Also there is another small fix for Loongson AVEC support, bit 14 is added
>> in CSR ESTAT register. Macro CSR_ESTAT_IS is replaced with hardcoded value
>> 0x1fff and AVEC interrupt status bit 14 is supported with macro
>> CSR_ESTAT_IS.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/main.c | 8 ++++++++
>>   arch/loongarch/kvm/vcpu.c | 2 +-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index f6d3242b9234..b177773f38f6 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -284,6 +284,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>>   int kvm_arch_enable_virtualization_cpu(void)
>>   {
>>          unsigned long env, gcfg = 0;
>> +       struct kvm_context *context;
>>
>>          env = read_csr_gcfg();
>>
>> @@ -317,6 +318,13 @@ int kvm_arch_enable_virtualization_cpu(void)
>>          kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
>>                    read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
>>
>> +       /*
>> +        * HW Guest CSR registers are lost after CPU suspend and resume
>> +        * Clear last_vcpu so that Guest CSR register forced to reload
>> +        * from vCPU SW state
>> +        */
>> +       context = this_cpu_ptr(vmcs);
>> +       context->last_vcpu = NULL;
> This can be simplified as this_cpu_ptr(vmcs)->last_vcpu = NULL;
Sure, will do.
> 
>>          return 0;
>>   }
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 20f941af3e9e..9e1a9b4aa4c6 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -311,7 +311,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>   {
>>          int ret = RESUME_GUEST;
>>          unsigned long estat = vcpu->arch.host_estat;
>> -       u32 intr = estat & 0x1fff; /* Ignore NMI */
>> +       u32 intr = estat & CSR_ESTAT_IS;
> This part has nothing to do with S4, please split to another patch.
ok, will split into two patches.

Regards
Bibo Mao
> 
> Huacai
> 
>>          u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
>>
>>          vcpu->mode = OUTSIDE_GUEST_MODE;
>>
>> base-commit: 1e15510b71c99c6e49134d756df91069f7d18141
>> --
>> 2.39.3
>>
>>


