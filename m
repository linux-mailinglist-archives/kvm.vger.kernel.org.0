Return-Path: <kvm+bounces-37670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07050A2E216
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 02:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2CA6165EF9
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 01:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1219F22EE4;
	Mon, 10 Feb 2025 01:44:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE83E9461;
	Mon, 10 Feb 2025 01:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739151862; cv=none; b=TltjEy+Euttr7aBDMyt3Kd4BbVAJztFbfWYGURdodpYaARc13Dct/a+K69Sjidba7K7qGggwkzxDHuGBH4KcppYhkCCIfaJBqlMmJg/00CEENjuwEWdLFZ4w0LXiEzgcEkRPdbp8vZXTbmceI+LFnGXzDV3kNkI8cZr8qZAekWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739151862; c=relaxed/simple;
	bh=oZ4i6G/vds3u2yDUC9W2NW8+SMos2V/3xYXBbeqGXYQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ETb21gHCRSFAo5CF7kzNEwtJofwK20BQZnFJ63dXlzJdca+OWgrgNPUB/cB62WOk1as4cjSsBDduyB7O6cx70UKZjVfDpnb5zNk5iqLimoZ+0SWqu3pLQrJa+DqLgJnQuMna8lqNnTEp8vMeHNBjT4qX8PrAHkpnLZ7CL6l8SwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxLOLyWaln1tpwAA--.26232S3;
	Mon, 10 Feb 2025 09:44:18 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBx3MTuWalnbHIJAA--.33964S3;
	Mon, 10 Feb 2025 09:44:16 +0800 (CST)
Subject: Re: [PATCH 3/3] LoongArch: KVM: Set host with kernel mode when switch
 to VM mode
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250207032634.2333300-1-maobibo@loongson.cn>
 <20250207032634.2333300-4-maobibo@loongson.cn>
 <CAAhV-H4o7WS6J-eU=3VR16iVscrr5znpa67Do96cxmd6A0JS0g@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <cc68705c-6900-f185-84b7-5473acb3ce96@loongson.cn>
Date: Mon, 10 Feb 2025 09:43:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4o7WS6J-eU=3VR16iVscrr5znpa67Do96cxmd6A0JS0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBx3MTuWalnbHIJAA--.33964S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWruw4UCF48tr4kArWfWw4fCrX_yoW8Jr4xpr
	WayFs5KF4F9r1q9aykKw45tF98urZFgr4Sg3W3tFyFyrnxX3ZYqa4DWFZrXFyavw4rJF40
	9r1rtr1Iva1UAacCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU82g
	43UUUUU==



On 2025/2/9 下午5:47, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Fri, Feb 7, 2025 at 11:26 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> PRMD and ERA register is only meaningful on the beginning stage
>> of exception entry, and it can be overwritten for nested irq or
>> exception.
> The code doesn't touch ERA, so ERA in the commit message is a typo?
oh, ERA is redundant here.
Will remove it in next version.

Regards
Bibo Mao
> 
> Huacai
>>
>> When CPU runs in VM mode, interrupt need be enabled on host. And the
>> mode for host had better be kernel mode rather than random.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/switch.S | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> index 0c292f818492..1be185e94807 100644
>> --- a/arch/loongarch/kvm/switch.S
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -85,7 +85,7 @@
>>           * Guest CRMD comes from separate GCSR_CRMD register
>>           */
>>          ori     t0, zero, CSR_PRMD_PIE
>> -       csrxchg t0, t0,   LOONGARCH_CSR_PRMD
>> +       csrwr   t0, LOONGARCH_CSR_PRMD
>>
>>          /* Set PVM bit to setup ertn to guest context */
>>          ori     t0, zero, CSR_GSTAT_PVM
>> --
>> 2.39.3
>>


