Return-Path: <kvm+bounces-3446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DE180458B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 04:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3164F28142E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5AD8BF1;
	Tue,  5 Dec 2023 03:18:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68EE785;
	Mon,  4 Dec 2023 19:18:30 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Dxg_CDlm5lP_E+AA--.60337S3;
	Tue, 05 Dec 2023 11:18:28 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxvi9+lm5lyxRVAA--.57025S3;
	Tue, 05 Dec 2023 11:18:25 +0800 (CST)
Subject: Re: [PATCH v4 1/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: Huacai Chen <chenhuacai@kernel.org>, zhaotianrui <zhaotianrui@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231116023036.2324371-1-maobibo@loongson.cn>
 <20231116023036.2324371-2-maobibo@loongson.cn>
 <564a2fd3-ffba-3bc5-70b9-8a9fa9a0f1c6@loongson.cn>
 <CAAhV-H4P_JUewDM7R1ByNR4PZa97=xM_rAJ239J-wFSd6_+0GA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <17c54ef9-9ce5-bc2b-0566-851fe4da9483@loongson.cn>
Date: Tue, 5 Dec 2023 11:18:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4P_JUewDM7R1ByNR4PZa97=xM_rAJ239J-wFSd6_+0GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxvi9+lm5lyxRVAA--.57025S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFy3WF48KrW8Cw43Zr48Zrc_yoWrCFWDpF
	WxCFnrZr4rGr17G34aqan0qr42q3s3Kr1xWa47JFyFyrnrtr1xtF18GrZxuFy7Cw4fCFyI
	vr1rKasIvF45A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjwZcUUUUU=



On 2023/12/5 上午10:20, Huacai Chen wrote:
> This series looks good to me, If Paolo agrees, I will apply to
> loongarch-next after [1] is taken into the kvm tree (otherwise there
> will be build errors).
> 
> [1] https://lore.kernel.org/loongarch/CAAhV-H63QkfSw+Esn8oW2PDEsCnTRPFqkj8X-x8i9cH3AS0k9w@mail.gmail.com/T/#t
> 
Got it, and thanks for your information.

Regards
Bibo Mao

> On Mon, Dec 4, 2023 at 4:45 PM zhaotianrui <zhaotianrui@loongson.cn> wrote:
>>
>> Reviewed-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>>
>> 在 2023/11/16 上午10:30, Bibo Mao 写道:
>>> With halt-polling supported, there is checking for pending events
>>> or interrupts when vcpu executes idle instruction. Pending interrupts
>>> include injected SW interrupts and passthrough HW interrupts, such as
>>> HW timer interrupts, since HW timer works still even if vcpu exists
>>> from VM mode.
>>>
>>> Since HW timer pending interrupt can be set directly with CSR status
>>> register, and pending HW timer interrupt checking is used in vcpu block
>>> checking function, it is not necessary to switch to sw timer during
>>> halt-polling. This patch adds preemption disabling in function
>>> kvm_cpu_has_pending_timer, and removes SW timer switching in idle
>>> instruction emulation function.
>>>
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> ---
>>>    arch/loongarch/kvm/exit.c  | 13 ++-----------
>>>    arch/loongarch/kvm/timer.c | 13 ++++++++++---
>>>    arch/loongarch/kvm/vcpu.c  |  9 ++++++++-
>>>    3 files changed, 20 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>> index ce8de3fa472c..e708a1786d6b 100644
>>> --- a/arch/loongarch/kvm/exit.c
>>> +++ b/arch/loongarch/kvm/exit.c
>>> @@ -200,17 +200,8 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>>>        ++vcpu->stat.idle_exits;
>>>        trace_kvm_exit_idle(vcpu, KVM_TRACE_EXIT_IDLE);
>>>
>>> -     if (!kvm_arch_vcpu_runnable(vcpu)) {
>>> -             /*
>>> -              * Switch to the software timer before halt-polling/blocking as
>>> -              * the guest's timer may be a break event for the vCPU, and the
>>> -              * hypervisor timer runs only when the CPU is in guest mode.
>>> -              * Switch before halt-polling so that KVM recognizes an expired
>>> -              * timer before blocking.
>>> -              */
>>> -             kvm_save_timer(vcpu);
>>> -             kvm_vcpu_block(vcpu);
>>> -     }
>>> +     if (!kvm_arch_vcpu_runnable(vcpu))
>>> +             kvm_vcpu_halt(vcpu);
>>>
>>>        return EMULATE_DONE;
>>>    }
>>> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
>>> index 284bf553fefe..437e960d8fdb 100644
>>> --- a/arch/loongarch/kvm/timer.c
>>> +++ b/arch/loongarch/kvm/timer.c
>>> @@ -155,11 +155,18 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
>>>                 */
>>>                hrtimer_cancel(&vcpu->arch.swtimer);
>>>                hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
>>> -     } else
>>> +     } else if (vcpu->stat.generic.blocking) {
>>>                /*
>>> -              * Inject timer interrupt so that hall polling can dectect and exit
>>> +              * Inject timer interrupt so that hall polling can dectect and
>>> +              * exit.
>>> +              * VCPU is scheduled out already and sleeps in rcuwait queue and
>>> +              * will not poll pending events again. kvm_queue_irq is not
>>> +              * enough, hrtimer swtimer should be used here.
>>>                 */
>>> -             kvm_queue_irq(vcpu, INT_TI);
>>> +             expire = ktime_add_ns(ktime_get(), 10);  // 10ns is enough here?
>>> +             vcpu->arch.expire = expire;
>>> +             hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
>>> +     }
>>>    }
>>>
>>>    /*
>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>> index 73d0c2b9c1a5..42663a345bd1 100644
>>> --- a/arch/loongarch/kvm/vcpu.c
>>> +++ b/arch/loongarch/kvm/vcpu.c
>>> @@ -187,8 +187,15 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>>>
>>>    int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>>>    {
>>> -     return kvm_pending_timer(vcpu) ||
>>> +     int ret;
>>> +
>>> +     /* protect from TOD sync and vcpu_load/put */
>>> +     preempt_disable();
>>> +     ret = kvm_pending_timer(vcpu) ||
>>>                kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT) & (1 << INT_TI);
>>> +     preempt_enable();
>>> +
>>> +     return ret;
>>>    }
>>>
>>>    int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
>>
>>


