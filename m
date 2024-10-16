Return-Path: <kvm+bounces-28971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C887E9A014E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 08:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EC5C1F23EEC
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 06:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462CC18C347;
	Wed, 16 Oct 2024 06:20:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54294156E4;
	Wed, 16 Oct 2024 06:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729059657; cv=none; b=L4ytgUecCzQKyoNLkAK2YrJBjr0GC9+RSq7YjHiPKemxaosX8JhjIVN7iB6ax/IR6tQTnMsG+FQsk7grGaj4YmB/EhO1McqvCNDSXNtMHh63A5fxJUfjm/HVowpFRKMDvePTOQfjslnvU1vxlHaEpbP4QY2tOpQnwDu1FJ5MUA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729059657; c=relaxed/simple;
	bh=QUJFG5JDDq4z9fFBBRCf84NQh3GYWK9emtnmcD3wnF4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lNnh26wfCjKpViLvCsCfHYYmJPd0C1EHqs2vM5Y/jGIeeSbfoxb/kkg85cWA+2ZKhvwaY+4PhEQUWV62KmSREKW5XFjsH/qEpXrXldxhNXilUFu3Fa3FQ0SgNyFTJFwyBUwZhc52wfiy5d/QSIi9N4sSjR6e8Dj3DRTOxUzg9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxvvBDWw9n94sfAA--.46537S3;
	Wed, 16 Oct 2024 14:20:51 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCx3tU+Ww9nNEMsAA--.28349S3;
	Wed, 16 Oct 2024 14:20:48 +0800 (CST)
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
To: Ankur Arora <ankur.a.arora@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
 rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
 arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
 mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
 misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com> <87ttddrr1r.fsf@oracle.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <188455ae-edf1-1eba-572b-6c259ddf8d27@loongson.cn>
Date: Wed, 16 Oct 2024 14:20:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87ttddrr1r.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx3tU+Ww9nNEMsAA--.28349S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxurW8uw17WF48trW7ZF15KFX_yoWrGryrpF
	Wjgay3KF4kJryYy392vw1v9rWY93ykt3yagryrG3yIkrs8AFySyF4fJF1a9F4vvr4kXF10
	vF409anrua4jyFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU_529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDU
	UUU



On 2024/10/16 上午5:32, Ankur Arora wrote:
> 
> Catalin Marinas <catalin.marinas@arm.com> writes:
> 
>> On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
>>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>>> index 9b6d90a72601..fc1204426158 100644
>>> --- a/drivers/cpuidle/poll_state.c
>>> +++ b/drivers/cpuidle/poll_state.c
>>> @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>>
>>>   	raw_local_irq_enable();
>>>   	if (!current_set_polling_and_test()) {
>>> -		unsigned int loop_count = 0;
>>>   		u64 limit;
>>>
>>>   		limit = cpuidle_poll_time(drv, dev);
>>>
>>>   		while (!need_resched()) {
>>> -			cpu_relax();
>>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>>> -				continue;
>>> -
>>> -			loop_count = 0;
>>> +			unsigned int loop_count = 0;
>>>   			if (local_clock_noinstr() - time_start > limit) {
>>>   				dev->poll_time_limit = true;
>>>   				break;
>>>   			}
>>> +
>>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>>> +					      VAL & _TIF_NEED_RESCHED ||
>>> +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
>>
>> The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
>> never set. With the event stream enabled on arm64, the WFE will
>> eventually be woken up, loop_count incremented and the condition would
>> become true.
> 
> That makes sense.
> 
>> However, the smp_cond_load_relaxed() semantics require that
>> a different agent updates the variable being waited on, not the waiting
>> CPU updating it itself.
> 
> Right. And, that seems to work well with the semantics of WFE. And,
> the event stream (if enabled) has a side effect that allows the exit
> from the loop.
> 
>> Also note that the event stream can be disabled
>> on arm64 on the kernel command line.
> 
> Yes, that's a good point. In patch-11 I tried to address that aspect
> by only allowing haltpoll to be force loaded.
> 
> But, I guess your point is that its not just haltpoll that has a problem,
> but also regular polling -- and maybe the right thing to do would be to
> disable polling if the event stream is disabled.
> 
>> Does the code above break any other architecture?
> 
> Me (and others) have so far tested x86, ARM64 (with/without the
> event stream), and I believe riscv. I haven't seen any obvious
> breakage. But, that's probably because most of the time somebody would
> be set TIF_NEED_RESCHED.
> 
>> I'd say if you want
>> something like this, better introduce a new smp_cond_load_timeout()
>> API. The above looks like a hack that may only work on arm64 when the
>> event stream is enabled.
> 
> I had a preliminary version of smp_cond_load_relaxed_timeout() here:
>   https://lore.kernel.org/lkml/87edae3a1x.fsf@oracle.com/
> 
> Even with an smp_cond_load_timeout(), we would need to fallback to
> something like the above for uarchs without WFxT.
> 
>> A generic option is udelay() (on arm64 it would use WFE/WFET by
>> default). Not sure how important it is for poll_idle() but the downside
>> of udelay() that it won't be able to also poll need_resched() while
>> waiting for the timeout. If this matters, you could instead make smaller
>> udelay() calls. Yet another problem, I don't know how energy efficient
>> udelay() is on x86 vs cpu_relax().
>>
>> So maybe an smp_cond_load_timeout() would be better, implemented with
>> cpu_relax() generically and the arm64 would use LDXR, WFE and rely on
>> the event stream (or fall back to cpu_relax() if the event stream is
>> disabled).
> 
> Yeah, something like that might work.
Yeah, I like idea about smp_cond_load_timeout method. If generic 
smp_cond_load_timeout method does not meet the requirement, the 
architecture can define itself one. And this keeps less modification 
about original code logic.

Regards
Bibo Mao
> 
> --
> ankur
> 


