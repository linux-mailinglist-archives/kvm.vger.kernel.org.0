Return-Path: <kvm+bounces-1867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0602F7EDA28
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5CE7281089
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC128F7A;
	Thu, 16 Nov 2023 03:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06896189;
	Wed, 15 Nov 2023 19:26:39 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cx5_Hui1VlznI6AA--.49344S3;
	Thu, 16 Nov 2023 11:26:38 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxO9zqi1VlAaxDAA--.16678S3;
	Thu, 16 Nov 2023 11:26:37 +0800 (CST)
Subject: Re: [PATCH v4 0/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231116023036.2324371-1-maobibo@loongson.cn>
 <CAAhV-H4Wyp-6_gFSfm8uWUMiEJnebk9n4JxQrx_nBdxkTF5wUA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <06908fb4-cbd8-74a1-2e6f-3da016bd3280@loongson.cn>
Date: Thu, 16 Nov 2023 11:26:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4Wyp-6_gFSfm8uWUMiEJnebk9n4JxQrx_nBdxkTF5wUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxO9zqi1VlAaxDAA--.16678S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tF1UuFWUAF48WFy3Wry7XFc_yoW8KFWkpF
	ZIkFnIqr4kKr4kK3Zaqa1DXr9Fq3yIqF1xXrn3tryrArsIyF1YqF18KrWF9F9xu393AFyI
	vryrt3Z8Za4UA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU82g
	43UUUUU==



On 2023/11/16 上午10:54, Huacai Chen wrote:
> Hi, Bibo,
> 
> I suggest submitting this series to the internal repo, too. Because we
> don't have enough resources to test the stability for the upstream
> version, while this is a fundamental change. On the other hand, the
> patch "LoongArch:LSVZ: set timer offset at first time once" can be
> submitted first because it is already in the internal repo.
We ever consider to keep the same between internal repo and upstream, 
only that there are many differences since kernel version is different.

We are preparing to setup test environment for upstream kvm module, the 
stability for the upstream is very important for us -:)

Regards
Bibo Mao

> 
> Huacai
> 
> On Thu, Nov 16, 2023 at 10:33 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This patches removes SW timer switch during vcpu block stage. VM uses HW
>> timer rather than SW PV timer on LoongArch system, it can check pending
>> HW timer interrupt status directly, rather than switch to SW timer and
>> check injected SW timer interrupt.
>>
>> When SW timer is not used in vcpu halt-polling mode, the relative
>> SW timer handling before entering guest can be removed also. Timer
>> emulation is simpler than before, SW timer emuation is only used in vcpu
>> thread context switch.
>> ---
>> Changes in v4:
>>    If vcpu is scheduled out since there is no pending event, and timer is
>> fired during sched-out period. SW hrtimer is used to wake up vcpu thread
>> in time, rather than inject pending timer irq.
>>
>> Changes in v3:
>>    Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.
>>
>> Changes in v2:
>>    Add halt polling support for idle instruction emulation, using api
>> kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.
>>
>> ---
>> Bibo Mao (3):
>>    LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>>    LoongArch: KVM: Allow to access HW timer CSR registers always
>>    LoongArch: KVM: Remove kvm_acquire_timer before entering guest
>>
>>   arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>>   arch/loongarch/kvm/exit.c             | 13 +-----
>>   arch/loongarch/kvm/main.c             |  1 -
>>   arch/loongarch/kvm/timer.c            | 62 ++++++++++-----------------
>>   arch/loongarch/kvm/vcpu.c             | 38 ++++------------
>>   5 files changed, 32 insertions(+), 83 deletions(-)
>>
>>
>> base-commit: c42d9eeef8e5ba9292eda36fd8e3c11f35ee065c
>> --
>> 2.39.3
>>


