Return-Path: <kvm+bounces-15450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3543E8AC2BD
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 04:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E72661F2152C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 02:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AECF63C7;
	Mon, 22 Apr 2024 02:14:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577872F2D;
	Mon, 22 Apr 2024 02:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713752072; cv=none; b=QbXA1eRZuh/Kjn0zBDvpKJaKpopBcjg7JeoL9N5pJV/D70c1CrGqGDqKJC2szHAbppQucVJLFZHyVil/APAwV0lhEe6D9xB2AjMmiKQbKClJy15BF0ej4qNoA8ClSWoHPWkG9kThpI45glFgvn1POBOlb6xzffX+oTtNc+nsr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713752072; c=relaxed/simple;
	bh=6H+7xt2iNnE7kHtM2+NfnHVy0wCagkXB/VcEwCoXFFo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=N6SWLiU3ocoNi7Kf6oq5B5WI5nGU83aYhtXzta73Cj/aGeH5Dm+7szdyy8kXoIpnymWPypUjZNFVKSOeNddWpdLy0EOpNGjQcAxaDS4ZoQTD+6V505IHXBV9ipkoy/oXzKRSz6s5QkA1+pVxngs9V5qGLjArH0JPxz8EZLEqLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Bxnuv+xyVm8H0AAA--.1644S3;
	Mon, 22 Apr 2024 10:14:22 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd76xyVmQNAAAA--.3779S3;
	Mon, 22 Apr 2024 10:14:20 +0800 (CST)
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
 <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
Date: Mon, 22 Apr 2024 10:14:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zh2uFkfH8BA23lm0@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxjd76xyVmQNAAAA--.3779S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJFW3JrW7CF1rCr4rGF1xWFX_yoW5XF1DpF
	Wj9F1jyr4DJrWxAw1Iqa18AFySkFZ7GFWYgr1vqay5Aa98uF98Zr1UKrW3CF15uw4xKa42
	vrW0qasxG3ZIyacCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUUUUU



On 2024/4/16 上午6:45, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
>> On Mon, Apr 15, 2024 at 10:38 AM Sean Christopherson <seanjc@google.com> wrote:
>>> One my biggest complaints with the current vPMU code is that the roles and
>>> responsibilities between KVM and perf are poorly defined, which leads to suboptimal
>>> and hard to maintain code.
>>>
>>> Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak guest
>>> state to userspace processes that have RDPMC permissions, as the PMCs might not
>>> be dirty from perf's perspective (see perf_clear_dirty_counters()).
>>>
>>> Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes the
>>> overall code brittle because it's not clear whether KVM _needs_ to clear PMCs,
>>> or if KVM is just being paranoid.
>>
>> So once this rolls out, perf and vPMU are clients directly to PMU HW.
> 
> I don't think this is a statement we want to make, as it opens a discussion
> that we won't win.  Nor do I think it's one we *need* to make.  KVM doesn't need
> to be on equal footing with perf in terms of owning/managing PMU hardware, KVM
> just needs a few APIs to allow faithfully and accurately virtualizing a guest PMU.
> 
>> Faithful cleaning (blind cleaning) has to be the baseline
>> implementation, until both clients agree to a "deal" between them.
>> Currently, there is no such deal, but I believe we could have one via
>> future discussion.
> 
> What I am saying is that there needs to be a "deal" in place before this code
> is merged.  It doesn't need to be anything fancy, e.g. perf can still pave over
> PMCs it doesn't immediately load, as opposed to using cpu_hw_events.dirty to lazily
> do the clearing.  But perf and KVM need to work together from the get go, ie. I
> don't want KVM doing something without regard to what perf does, and vice versa.
> 
There is similar issue on LoongArch vPMU where vm can directly pmu 
hardware and pmu hw is shard with guest and host. Besides context switch 
there are other places where perf core will access pmu hw, such as tick 
timer/hrtimer/ipi function call, and KVM can only intercept context switch.

Can we add callback handler in structure kvm_guest_cbs?  just like this:
@@ -6403,6 +6403,7 @@ static struct perf_guest_info_callbacks 
kvm_guest_cbs = {
         .state                  = kvm_guest_state,
         .get_ip                 = kvm_guest_get_ip,
         .handle_intel_pt_intr   = NULL,
+       .lose_pmu               = kvm_guest_lose_pmu,
  };

By the way, I do not know should the callback handler be triggered in 
perf core or detailed pmu hw driver. From ARM pmu hw driver, it is 
triggered in pmu hw driver such as function kvm_vcpu_pmu_resync_el0,
but I think it will be better if it is done in perf core.

Regards
Bibo Mao


