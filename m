Return-Path: <kvm+bounces-9371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9F485F58E
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE32928873B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55253A29B;
	Thu, 22 Feb 2024 10:22:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF5A1B59E;
	Thu, 22 Feb 2024 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708597369; cv=none; b=qf1LPns7AVFETCtw6NoqK/HEZjLicpQhwzCHVWT+MNhtuBHCeawZ8wSb9cLIgytBvfXON8srpOrP68L2mQc1i+w/waNaNkcvifNkmemaXiQ1mlo0H4XHmzJddOC/+8D+hQJVqQXkIx52xZYhUhJhH+PlWk7XV+Db8L9ig2RhYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708597369; c=relaxed/simple;
	bh=n03uyduofiuvh8m537h9JLAs0TXp+Va2r31oM8G0N1o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=U8w7kHnYStJ9fjf5MdkPt/nRUcZ3P48tBqrPRtXpp5KCgrLhLfF+BvNawUhfrqMkMSZ6wws/rlEjiO6EhI6azRohVNJ5u+Mh1tesIzIDTG8Eg5vLaWq6eWw2prvDaSweH1rkUsgeKk7fx5lWQ8rNvjzzGl9858+s2g/7SNp3las=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxHOtvINdl0SoQAA--.31815S3;
	Thu, 22 Feb 2024 18:22:39 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfRNsINdl97U+AA--.92S3;
	Thu, 22 Feb 2024 18:22:38 +0800 (CST)
Subject: Re: [PATCH for-6.8 v3 1/3] LoongArch: KVM: Fix input validation of
 _kvm_get_cpucfg and kvm_check_cpucfg
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240216085822.3032984-1-kernel@xen0n.name>
 <20240216085822.3032984-2-kernel@xen0n.name>
 <412ea29b-7a53-1f91-1cdb-5a256e74826b@loongson.cn>
 <4a12394a-8ebf-40b8-b0bc-65b5a66967cd@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <0c27477b-d144-37f3-d47c-956f9ba07723@loongson.cn>
Date: Thu, 22 Feb 2024 18:22:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4a12394a-8ebf-40b8-b0bc-65b5a66967cd@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfRNsINdl97U+AA--.92S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CF1xCFWrKw4DKF45Gry8WFX_yoW8tF48pr
	WrKFWUuryjqw1xC34kKw1UJFyxAr4UGwsrJF1vqF1DCrW8Xry0gr4jqrnIgr13Jrs3AFy7
	tF4UXFsI934DAFgCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07j5WrAUUUUU=



On 2024/2/22 下午5:45, WANG Xuerui wrote:
> Hi,
> 
> On 2/17/24 11:03, maobibo wrote:
>> Hi Xuerui,
>>
>> Good catch, and thank for your patch.
>>
>> On 2024/2/16 下午4:58, WANG Xuerui wrote:
>>> [snip]
>>> @@ -324,31 +319,33 @@ static int _kvm_get_cpucfg(int id, u64 *v)
>>>           if (cpu_has_lasx)
>>>               *v |= CPUCFG2_LASX;
>>> -        break;
>>> +        return 0;
>>> +    case 0 ... 1:
>>> +    case 3 ... KVM_MAX_CPUCFG_REGS - 1:
>>> +        /* no restrictions on other CPUCFG IDs' values */
>>> +        *v = U64_MAX;
>>> +        return 0;
>> how about something like this?
>>      default:
>>          /* no restrictions on other CPUCFG IDs' values */
>>          *v = U64_MAX;
>>          return 0;
> 
> I don't think this version correctly expresses the intent. Note that the 
> CPUCFG ID range check is squashed into the switch as well, so one switch 
> conveniently expresses the three intended cases at once:
> 
> * the special treatment of CPUCFG2,
+	case 0 ... 1:
+	case 3 ... KVM_MAX_CPUCFG_REGS - 1:
+		/* no restrictions on other CPUCFG IDs' values */
+		*v = U64_MAX;
+		return 0;
cpucfg6 checking will be added for PMU support soon. So it will be
         case 6:
             do something check for cpucfg6
             return mask;
         case 0 ... 1:
         case 3 ... 5:
         case 7 ... KVM_MAX_CPUCFG_REGS - 1:
       	    *v = U64_MAX;
             return 0;

If you think it is reasonable to add these separate "case" sentences, I 
have no objection.
> * all-allow rules for other in-range CPUCFG IDs, and
> * rejection for out-of-range IDs.
  static int kvm_check_cpucfg(int id, u64 val)
  {
-	u64 mask;
-	int ret = 0;
-
-	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
-		return -EINVAL;
you can modify && with ||, like this:
	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
		return -EINVAL;

+	u64 mask = 0;
+	int ret;

Regards
Bibo Mao
> 
> Yet the suggestion here is conflating the latter two cases, with the 
> effect of allowing every ID that's not 2 to take any value (as expressed 
> by the U64_MAX mask), and *removing the range check* (because no return 
> path returns -EINVAL with this change).
> 
> So I'd like to stick to the current version, but thanks anyway for your 
> kind review and suggestion.
> 


