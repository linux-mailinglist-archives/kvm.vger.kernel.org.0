Return-Path: <kvm+bounces-9003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A87859B32
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 05:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7E131C21934
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 04:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A953B648;
	Mon, 19 Feb 2024 04:01:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916DC610C;
	Mon, 19 Feb 2024 04:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708315275; cv=none; b=Jm9UNZy89zNtYUze6I4xZgrUNjyg33f71tJ49uEJDp3Vf9nOaR+LLIYOmr+WLukvHZUgAYY9zBOmXf+LVr0Hl+L5QwUJb69dUm6P8gBqoGZii+RxgqqaSxCwFAY0nm+hODYZbpT2gZ19TK/EPCJf+JdAxlI5ASYaYPWkcrMLyIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708315275; c=relaxed/simple;
	bh=fWO/d8vJQnGDSG3OxxHaW0J4YDg798l5D8qL91e8iJo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=efP2Vgyvbi2nCXTH2l3WfFCZfgTEEuFFCCynQxrKml6a8b96oBJbfN2gGYw7r1rmtnAE9ztnAwC/IpWrTCykvR2sPB/XCJ48En+Fo3NGT93olm6z/xYOCHC7G/oO0rjSHDRn6xDeGlxgFT6ozMd9/Cax8VlRDDv7SSa2I70lllo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cx2uiH0tJlUDQOAA--.18456S3;
	Mon, 19 Feb 2024 12:01:11 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c6E0tJl98I7AA--.22346S3;
	Mon, 19 Feb 2024 12:01:10 +0800 (CST)
Subject: Re: [PATCH v4 2/6] LoongArch: KVM: Add hypercall instruction
 emulation support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <20240201031950.3225626-3-maobibo@loongson.cn>
 <CAAhV-H4f=m2xX7_WF3YkRbxWyVAyBLemNv3OVq-AbqtsKKtCyA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <3dec97d2-a4fd-93fb-9232-87fd05912d36@loongson.cn>
Date: Mon, 19 Feb 2024 12:01:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4f=m2xX7_WF3YkRbxWyVAyBLemNv3OVq-AbqtsKKtCyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx_c6E0tJl98I7AA--.22346S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWr45JFWfXFWUXr13Zr43Jwc_yoWrGry8pF
	ykCFn5Ga1rKr1xCFy3tFnIgr13Ars5Kr129Fy2k3yUAFnFqr1Fyr4kKr98uFyUGw4rXF1I
	gFWFqw13uF4UtacCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0epB3UUUU
	U==


On 2024/2/19 上午10:41, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Thu, Feb 1, 2024 at 11:19 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> On LoongArch system, hypercall instruction is supported when system
>> runs on VM mode. This patch adds dummy function with hypercall
>> instruction emulation, rather than inject EXCCODE_INE invalid
>> instruction exception.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/Kbuild      |  1 -
>>   arch/loongarch/include/asm/kvm_para.h  | 26 ++++++++++++++++++++++++++
>>   arch/loongarch/include/uapi/asm/Kbuild |  2 --
>>   arch/loongarch/kvm/exit.c              | 10 ++++++++++
>>   4 files changed, 36 insertions(+), 3 deletions(-)
>>   create mode 100644 arch/loongarch/include/asm/kvm_para.h
>>   delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
>>
>> diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
>> index 93783fa24f6e..22991a6f0e2b 100644
>> --- a/arch/loongarch/include/asm/Kbuild
>> +++ b/arch/loongarch/include/asm/Kbuild
>> @@ -23,4 +23,3 @@ generic-y += poll.h
>>   generic-y += param.h
>>   generic-y += posix_types.h
>>   generic-y += resource.h
>> -generic-y += kvm_para.h
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> new file mode 100644
>> index 000000000000..9425d3b7e486
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_LOONGARCH_KVM_PARA_H
>> +#define _ASM_LOONGARCH_KVM_PARA_H
>> +
>> +/*
>> + * LoongArch hypcall return code
> Maybe using "hypercall" in comments is better.
will modify in next patch.

> 
>> + */
>> +#define KVM_HC_STATUS_SUCCESS          0
>> +#define KVM_HC_INVALID_CODE            -1UL
>> +#define KVM_HC_INVALID_PARAMETER       -2UL
> Maybe KVM_HCALL_SUCCESS/KVM_HCALL_INVALID_CODE/KVM_HCALL_PARAMETER is better.
yes, KVM_HCALL_xxxx sounds better. Will modify it.

Regards
Bibo Mao
> 
> Huacai
> 
>> +
>> +static inline unsigned int kvm_arch_para_features(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline unsigned int kvm_arch_para_hints(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline bool kvm_check_and_clear_guest_paused(void)
>> +{
>> +       return false;
>> +}
>> +#endif /* _ASM_LOONGARCH_KVM_PARA_H */
>> diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/include/uapi/asm/Kbuild
>> deleted file mode 100644
>> index 4aa680ca2e5f..000000000000
>> --- a/arch/loongarch/include/uapi/asm/Kbuild
>> +++ /dev/null
>> @@ -1,2 +0,0 @@
>> -# SPDX-License-Identifier: GPL-2.0
>> -generic-y += kvm_para.h
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index ed1d89d53e2e..d15c71320a11 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
>>          return RESUME_GUEST;
>>   }
>>
>> +static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
>> +{
>> +       update_pc(&vcpu->arch);
>> +
>> +       /* Treat it as noop intruction, only set return value */
>> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
>> +       return RESUME_GUEST;
>> +}
>> +
>>   /*
>>    * LoongArch KVM callback handling for unimplemented guest exiting
>>    */
>> @@ -716,6 +725,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
>>          [EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
>>          [EXCCODE_LASXDIS]               = kvm_handle_lasx_disabled,
>>          [EXCCODE_GSPR]                  = kvm_handle_gspr,
>> +       [EXCCODE_HVC]                   = kvm_handle_hypcall,
>>   };
>>
>>   int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
>> --
>> 2.39.3
>>


