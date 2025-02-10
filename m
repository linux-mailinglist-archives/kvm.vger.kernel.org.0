Return-Path: <kvm+bounces-37668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B15C4A2E1F3
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 02:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E03816094F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 01:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830AA15AF6;
	Mon, 10 Feb 2025 01:19:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B55122F11
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 01:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739150374; cv=none; b=Do07/iDwGJZoEUBkm18d8YTEuLXk5C9CLELmAZjeu9+TLfrnNleSa74Upxl7nZIfweuP1A+cD8nVafFD/tAxG+mz451RhF9edo13DpHWRHioU2zTBsG4D1VSHVe60N4oby4H9VrjXFd7yHmzReapCT7m94T0DGHY3SPqOGRJSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739150374; c=relaxed/simple;
	bh=w8hz3EC6SkQzB2/IAgNlLuYyLQ4pjyoJVeSZg+1fPdI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lwPIK1GgfeUZ2GYvMncAmWV+A1Hckvo0PhWu8fi1RD/jgA4Q7kiHnSJbrPmZGZpKNIX+pdK+agRbP9Dt6d3sZhEnKTbIVVMZZcI74oSxXxhbF4xmE0CYFZwNtJmq5DU+9spI9/Mnp82PS1iddmjvwdKw1KmtgaHzeYWoz/bOGZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8DxvnMYVKlntddwAA--.32962S3;
	Mon, 10 Feb 2025 09:19:20 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowMBxXsUVVKlnLmsJAA--.35757S3;
	Mon, 10 Feb 2025 09:19:19 +0800 (CST)
Subject: Re: [PATCH V2] target/loongarch: fix vcpu reset command word issue
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
Cc: Bibo Mao <Maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>
References: <20250208075023.5647-1-lixianglai@loongson.cn>
 <62ad5a5b-9860-42dc-a4f3-37f504f3ded6@linaro.org>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <cced0ac9-3f5b-0c5b-1c11-c45f6848a020@loongson.cn>
Date: Mon, 10 Feb 2025 09:17:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <62ad5a5b-9860-42dc-a4f3-37f504f3ded6@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMBxXsUVVKlnLmsJAA--.35757S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kw4kAFy3trykKrWxXrWDGFX_yoW8ZF1fpF
	WkAFZ7KFy8GrykJwn7X34DZa4DZrWxG34kXa4IqFy0yr1jqryvg3W0qwsIgFn8Aw48GF4Y
	vr18Cr1jvFW7J3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-
	e5UUUUU==

Hi Philippe Mathieu-Daudé:
> Hi,
>
> On 8/2/25 08:50, Xianglai Li wrote:
>> When the KVM_REG_LOONGARCH_VCPU_RESET command word
>> is sent to the kernel through the kvm_set_one_reg interface,
>> the parameter source needs to be a legal address,
>> otherwise the kernel will return an error and the command word
>> will fail to be sent.
>>
>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>> ---
>> Cc: Bibo Mao <Maobibo@loongson.cn>
>> Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Cc: Song Gao <gaosong@loongson.cn>
>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>
>> CHANGE:
>> V2<-V1:
>>    1.Sets the initial value of the variable and
>>    adds a function return value judgment and prints a log
>>
>>   target/loongarch/kvm/kvm.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
>> index a3f55155b0..3f499e60ab 100644
>> --- a/target/loongarch/kvm/kvm.c
>> +++ b/target/loongarch/kvm/kvm.c
>> @@ -581,9 +581,14 @@ static int kvm_loongarch_get_lbt(CPUState *cs)
>>   void kvm_arch_reset_vcpu(CPUState *cs)
>>   {
>>       CPULoongArchState *env = cpu_env(cs);
>> +    int ret = 0;
>> +    uint64_t unused = 0;
>>         env->mp_state = KVM_MP_STATE_RUNNABLE;
>> -    kvm_set_one_reg(cs, KVM_REG_LOONGARCH_VCPU_RESET, 0);
>> +    ret = kvm_set_one_reg(cs, KVM_REG_LOONGARCH_VCPU_RESET, &unused);
>> +    if (ret) {
>> +        error_report("Failed to set KVM_REG_LOONGARCH_VCPU_RESET");
>
> If this call fails, I'd not rely on the state of the VM. What about:
>
> if (ret < 0) {
>     error_report("Failed to set KVM_REG_LOONGARCH_VCPU_RESET: %s",
>                  strerror(errno));
>     exit(EXIT_FAILURE);
> }
>
> ?
>
I'll second that!

Thanks,
Xianglai.
>> +    }
>>   }
>>     static int kvm_loongarch_get_mpstate(CPUState *cs)
>


