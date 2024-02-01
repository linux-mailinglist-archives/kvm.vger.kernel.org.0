Return-Path: <kvm+bounces-7661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD574844FC1
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 04:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68A3F1F267DB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E777C3AC34;
	Thu,  1 Feb 2024 03:30:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7EA3A8C5;
	Thu,  1 Feb 2024 03:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706758216; cv=none; b=YdgKtrcLVvI7UKC2t4a5HYuS3rvk73jHiUgpUnTbVXL84hAnHGcvRE3u/THtj+1InA/iorg56hz2hJkJ0EdK+vwccw4TC8XF1HW3xnnACpBECFHweYusSVrpWg7/bwbpR27vmxf21rOEZkISMVMr0CZAzSWjKeEmSHsOVImXTnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706758216; c=relaxed/simple;
	bh=9uBM/8fJawcJ3y/dAPR6vQeEhlmYRiH/RTb/Lg63Fxg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=O21879v0IbjcNC9sOElcexJ8SqBpJkUcFt7eWo9UE1F+X6uv9mTmaO2B68TvfNrvqD2UU2UDoXDBlKiRXfXmAxMCU1akvfSU18mipAj+YCqOrG4l4k0rHctAE4CM81Xa4gYQItixF52vYM4foICdgVXpWAN7QELa5/+vqcZnGwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.183])
	by gateway (Coremail) with SMTP id _____8BxefBEELtlFlYJAA--.28279S3;
	Thu, 01 Feb 2024 11:30:12 +0800 (CST)
Received: from [10.20.42.183] (unknown [10.20.42.183])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxfs1DELtlZEYrAA--.33789S3;
	Thu, 01 Feb 2024 11:30:11 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Remove unnecessary CSR register saving
 during enter guest
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240112035039.833974-1-maobibo@loongson.cn>
 <b7c08e0d-bd7d-aea9-250e-1649e95599b7@loongson.cn>
From: zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <fbd8b226-1972-322b-d884-bb41d262dd16@loongson.cn>
Date: Thu, 1 Feb 2024 11:29:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b7c08e0d-bd7d-aea9-250e-1649e95599b7@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxfs1DELtlZEYrAA--.33789S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Cw1xtr4rtF1DGr1xury8WFX_yoW8JFyUpF
	97AF1vyFW5urn7ArWDKas8WryUJ347K3Z5WFyUJFy5Gr45Zry0gr1UXFn2gF1UZw48Jr18
	uF1UJrnavFWUA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
	0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280
	aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2
	xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r
	1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UR
	a0PUUUUU=

Reviewed-by: Tianrui Zhao <zhaotianrui@loongson.cn>

在 2024/1/31 上午11:48, maobibo 写道:
> slightly ping :)
> 
> On 2024/1/12 上午11:50, Bibo Mao wrote:
>> Some CSR registers like CRMD/PRMD are saved during enter VM mode. However
>> they are not restored for actual use, saving for these CSR registers
>> can be removed.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/switch.S | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> index 0ed9040307b7..905b90de50e8 100644
>> --- a/arch/loongarch/kvm/switch.S
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -213,12 +213,6 @@ SYM_FUNC_START(kvm_enter_guest)
>>       /* Save host GPRs */
>>       kvm_save_host_gpr a2
>> -    /* Save host CRMD, PRMD to stack */
>> -    csrrd    a3, LOONGARCH_CSR_CRMD
>> -    st.d    a3, a2, PT_CRMD
>> -    csrrd    a3, LOONGARCH_CSR_PRMD
>> -    st.d    a3, a2, PT_PRMD
>> -
>>       addi.d    a2, a1, KVM_VCPU_ARCH
>>       st.d    sp, a2, KVM_ARCH_HSP
>>       st.d    tp, a2, KVM_ARCH_HTP
>>
>> base-commit: de927f6c0b07d9e698416c5b287c521b07694cac
>>


