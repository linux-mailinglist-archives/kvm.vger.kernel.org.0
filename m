Return-Path: <kvm+bounces-69982-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAhKAarAgWm7JAMAu9opvQ
	(envelope-from <kvm+bounces-69982-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:32:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 473D9D6CAD
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62B543084F65
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 09:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C9F30C602;
	Tue,  3 Feb 2026 09:31:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47512225788;
	Tue,  3 Feb 2026 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111094; cv=none; b=RBjdsp551M5Ih3TSfJmSzb6L/dTyUJ5880SM5ljT/G+OxNeBkYiOkpBKRUkze301hZXR042AKx9zRs6dTDrsbTmnGLf7kJEnM6A19B39qT07YJp9J9olfZTAEIsOXuIi5DgDtzL308QRuJ2FRi1fKErqeBtkSA6KCDpnYRm5t18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111094; c=relaxed/simple;
	bh=5jmouTua6yslQRgrdx+A5bJpbyfqEnLPJRHjwE2hki4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BrBLpsoQ/E/kOHcA6cfhKi4Jt23KiXI26Zoof0Ju0OxA6AVUhWHhXUl+zr/tqp0pxdzioP8PxxPekmptq4BPu1SQ7CiDxg+kMdUGMIXPOAHRY9BcF5KoPLb0kwpA1c64XVHcAgNuH3/+Q9GB9H1cXd4tdZ0/mWBRxpLynP7ZpVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axz8NuwIFpaVAPAA--.50094S3;
	Tue, 03 Feb 2026 17:31:26 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxHMJrwIFpNwU_AA--.49621S3;
	Tue, 03 Feb 2026 17:31:26 +0800 (CST)
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add FPU delay load support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20260203033131.3372834-1-maobibo@loongson.cn>
 <20260203033131.3372834-5-maobibo@loongson.cn>
 <CAAhV-H7Y-m2wfV2YZ7J_nU0Zc198jroP6o8m0C+qSZ-8S79kwg@mail.gmail.com>
 <b9f311be-88f6-ffca-fc8e-70bec2cf7a75@loongson.cn>
 <CAAhV-H6v2oVe38HX7k_wvysUx4nyz6pbfUOU7wiaJO+1A3ASJw@mail.gmail.com>
 <03d39cc0-ed99-b32b-8678-575c646b6428@loongson.cn>
 <CAAhV-H5bz2dCGJbhGKMmgmmY8sgq4Ofex33+vRuQraKQRYC9mw@mail.gmail.com>
 <37a61461-bc15-39cf-61d0-3a908f25841f@loongson.cn>
 <CAAhV-H5bs5E4pMbMaTX+AZ9UwmSB81q0ga+CjM+ivY4kWVp2eQ@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <04c76933-f75b-0ea0-0d56-3ac52e7f80d2@loongson.cn>
Date: Tue, 3 Feb 2026 17:28:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5bs5E4pMbMaTX+AZ9UwmSB81q0ga+CjM+ivY4kWVp2eQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxHMJrwIFpNwU_AA--.49621S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3KF1DWrW7XFyDJryfXr4DKFX_yoWkCrW7pr
	y8JF1DAw48Jr15Jw12qr1qgrnFvr4UKr1xXryUJ345Jr1DtryUJr18JryUuFy5Jr18AF1x
	XF1Utr13CFyUJrgCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07j0sjUUUUUU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69982-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 473D9D6CAD
X-Rspamd-Action: no action



On 2026/2/3 下午5:17, Huacai Chen wrote:
> On Tue, Feb 3, 2026 at 4:59 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2026/2/3 下午4:50, Huacai Chen wrote:
>>> On Tue, Feb 3, 2026 at 3:51 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/2/3 下午3:34, Huacai Chen wrote:
>>>>> On Tue, Feb 3, 2026 at 2:48 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2026/2/3 下午12:15, Huacai Chen wrote:
>>>>>>> Hi, Bibo,
>>>>>>>
>>>>>>> On Tue, Feb 3, 2026 at 11:31 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>> FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
>>>>>>>> loaded, vCPU can be preempted and FPU will be lost again, there will
>>>>>>>> be unnecessary FPU exception, load and store process. Here FPU is
>>>>>>>> delay load until guest enter entry.
>>>>>>> Calling LSX/LASX as FPU is a little strange, but somewhat reasonable.
>>>>>>> Calling LBT as FPU is very strange. So I still like the V1 logic.
>>>>>> yeap, LBT can use another different BIT and separate with FPU. It is
>>>>>> actually normal use one bit + fpu type variant to represent different
>>>>>> different FPU load requirement, such as
>>>>>> TIF_FOREIGN_FPSTATE/TIF_NEED_FPU_LOAD on other architectures.
>>>>>>
>>>>>> I think it is better to put int fpu_load_type in structure loongarch_fpu.
>>>>>>
>>>>>> And there will be another optimization to avoid load FPU again if FPU HW
>>>>>> is owned by current thread/vCPU, that will add last_cpu int type in
>>>>>> structure loongarch_fpu also.
>>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>>
>>>>>>> If you insist on this version, please rename KVM_REQ_FPU_LOAD to
>>>>>>> KVM_REQ_AUX_LOAD and rename fpu_load_type to aux_type, which is
>>>>>>> similar to aux_inuse.
>>>>> Then why not consider this?
>>>> this can work now. However there is two different structure struct
>>>> loongarch_fpu and struct loongarch_lbt.
>>> Yes, but two structures don't block us from using KVM_REQ_AUX_LOAD and
>>> aux_type to abstract both FPU and LBT, which is similar to aux_inuse.
>>>>
>>>> 1. If kernel wants to use late FPU load, new element fpu_load_type can
>>>> be added in struct loongarch_fpu for both user app/KVM.
>> where aux_type is put for kernel/kvm? Put it in thread structure with
>> kernel late FPU load and vcpu.arch with KVM late FPU load?
> aux_type is renamed from fpu_load_type, so where fpu_load_type is,
> then where aux_type is.
> 
>>>>
>>>> 2. With further optimization, FPU HW can own by user app/kernel/KVM,
>>>> there will be another last_cpu int type added in struct loongarch_fpu.
>>> Both loongarch_fpu and loongarch_lbt are register copies, so adding
>>> fpu_load_type/last_cpu is not a good idea.
>> If vCPU using FPU is preempted by kernel thread and kernel thread does
>> not use FPU, HW FPU is the same with SW FPU state, HW FPU load can be
>> skipped.
>>
>> BTW do you ever investigate FPU load/save process on other general
>> architectures except MIPS?
> I investigate nothing, including MIPS. Other architectures may give us
> some inspiration, but that doesn't mean we should copy them, no matter
> X86 or MIPS.
> 
> X86 introduced lazy fpu, then others also use lazy fpu; but now X86
> have switched to eager fpu, others should also do the same?
I do not say easy fpu should be used. The problem is that for lazy FPU 
exception, if FPU HW register is the same with SW FPU state though FPU 
is disabled, can the FPU load be skipped and only enable FPU by EUEN 
register?

> 
> On the other hand, when you use separate FPU/LSX/LASX, I only mention
> the trace functions. Then you changed to centralized FPU/LSX/LASX/LBT.
The trace function is good suggestion, so I accept and post the second 
version. centralized FPU/LSX/LASX is because kvm_late_check_requests() 
is critical hot path, however FPU load is not, it is not necessary to 
add three cold kvm_check_request().

> Then I suggest you improve centralized FPU/LSX/LASX/LBT, you changed
> to separate FPU/LBT again, where is the end?
Now the LBT and FPU uses different structure to save and restore, FPU 
and LBT is separated already, however FPU/LSX/LASX uses the same 
structure loongarch_fpu.

Regards
Bibo Mao
> 
> 
> 
> Huacai
>>
>> Regards
>> Bibo Mao
>>>
>>>
>>> Huacai
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>>
>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>>> ---
>>>>>>>>      arch/loongarch/include/asm/kvm_host.h |  2 ++
>>>>>>>>      arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
>>>>>>>>      arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++---------
>>>>>>>>      3 files changed, 41 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>>>>>> index e4fe5b8e8149..902ff7bc0e35 100644
>>>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>>>>>> @@ -37,6 +37,7 @@
>>>>>>>>      #define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
>>>>>>>>      #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
>>>>>>>>      #define KVM_REQ_PMU                    KVM_ARCH_REQ(2)
>>>>>>>> +#define KVM_REQ_FPU_LOAD               KVM_ARCH_REQ(3)
>>>>>>>>
>>>>>>>>      #define KVM_GUESTDBG_SW_BP_MASK                \
>>>>>>>>             (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
>>>>>>>> @@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
>>>>>>>>             u64 vpid;
>>>>>>>>             gpa_t flush_gpa;
>>>>>>>>
>>>>>>>> +       int fpu_load_type;
>>>>>>>>             /* Frequency of stable timer in Hz */
>>>>>>>>             u64 timer_mhz;
>>>>>>>>             ktime_t expire;
>>>>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>>>>>> index 65ec10a7245a..62403c7c6f9a 100644
>>>>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>>>>> @@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
>>>>>>>>                     return RESUME_HOST;
>>>>>>>>             }
>>>>>>>>
>>>>>>>> -       kvm_own_fpu(vcpu);
>>>>>>>> +       vcpu->arch.fpu_load_type = KVM_LARCH_FPU;
>>>>>>>> +       kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
>>>>>>>>
>>>>>>>>             return RESUME_GUEST;
>>>>>>>>      }
>>>>>>>> @@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
>>>>>>>>      {
>>>>>>>>             if (!kvm_guest_has_lsx(&vcpu->arch))
>>>>>>>>                     kvm_queue_exception(vcpu, EXCCODE_INE, 0);
>>>>>>>> -       else
>>>>>>>> -               kvm_own_lsx(vcpu);
>>>>>>>> +       else {
>>>>>>>> +               vcpu->arch.fpu_load_type = KVM_LARCH_LSX;
>>>>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
>>>>>>>> +       }
>>>>>>>>
>>>>>>>>             return RESUME_GUEST;
>>>>>>>>      }
>>>>>>>> @@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
>>>>>>>>      {
>>>>>>>>             if (!kvm_guest_has_lasx(&vcpu->arch))
>>>>>>>>                     kvm_queue_exception(vcpu, EXCCODE_INE, 0);
>>>>>>>> -       else
>>>>>>>> -               kvm_own_lasx(vcpu);
>>>>>>>> +       else {
>>>>>>>> +               vcpu->arch.fpu_load_type = KVM_LARCH_LASX;
>>>>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
>>>>>>>> +       }
>>>>>>>>
>>>>>>>>             return RESUME_GUEST;
>>>>>>>>      }
>>>>>>>> @@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
>>>>>>>>      {
>>>>>>>>             if (!kvm_guest_has_lbt(&vcpu->arch))
>>>>>>>>                     kvm_queue_exception(vcpu, EXCCODE_INE, 0);
>>>>>>>> -       else
>>>>>>>> -               kvm_own_lbt(vcpu);
>>>>>>>> +       else {
>>>>>>>> +               vcpu->arch.fpu_load_type = KVM_LARCH_LBT;
>>>>>>>> +               kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
>>>>>>>> +       }
>>>>>>>>
>>>>>>>>             return RESUME_GUEST;
>>>>>>>>      }
>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>>>> index 995461d724b5..d05fe6c8f456 100644
>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>>>> @@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
>>>>>>>>                             kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
>>>>>>>>                             vcpu->arch.flush_gpa = INVALID_GPA;
>>>>>>>>                     }
>>>>>>>> +
>>>>>>>> +       if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
>>>>>>>> +               switch (vcpu->arch.fpu_load_type) {
>>>>>>>> +               case KVM_LARCH_FPU:
>>>>>>>> +                       kvm_own_fpu(vcpu);
>>>>>>>> +                       break;
>>>>>>>> +
>>>>>>>> +               case KVM_LARCH_LSX:
>>>>>>>> +                       kvm_own_lsx(vcpu);
>>>>>>>> +                       break;
>>>>>>>> +
>>>>>>>> +               case KVM_LARCH_LASX:
>>>>>>>> +                       kvm_own_lasx(vcpu);
>>>>>>>> +                       break;
>>>>>>>> +
>>>>>>>> +               case KVM_LARCH_LBT:
>>>>>>>> +                       kvm_own_lbt(vcpu);
>>>>>>>> +                       break;
>>>>>>>> +
>>>>>>>> +               default:
>>>>>>>> +                       break;
>>>>>>>> +               }
>>>>>>>> +
>>>>>>>> +               vcpu->arch.fpu_load_type = 0;
>>>>>>>> +       }
>>>>>>>>      }
>>>>>>>>
>>>>>>>>      /*
>>>>>>>> @@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>>>>>>>>      #ifdef CONFIG_CPU_HAS_LBT
>>>>>>>>      int kvm_own_lbt(struct kvm_vcpu *vcpu)
>>>>>>>>      {
>>>>>>>> -       preempt_disable();
>>>>>>>>             if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
>>>>>>>>                     set_csr_euen(CSR_EUEN_LBTEN);
>>>>>>>>                     _restore_lbt(&vcpu->arch.lbt);
>>>>>>>>                     vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
>>>>>>>>             }
>>>>>>>> -       preempt_enable();
>>>>>>>>
>>>>>>>>             return 0;
>>>>>>>>      }
>>>>>>>> @@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu) { }
>>>>>>>>      /* Enable FPU and restore context */
>>>>>>>>      void kvm_own_fpu(struct kvm_vcpu *vcpu)
>>>>>>>>      {
>>>>>>>> -       preempt_disable();
>>>>>>>> -
>>>>>>>>             /*
>>>>>>>>              * Enable FPU for guest
>>>>>>>>              * Set FR and FRE according to guest context
>>>>>>>> @@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>>>>>>>>             kvm_restore_fpu(&vcpu->arch.fpu);
>>>>>>>>             vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
>>>>>>>>             trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
>>>>>>>> -
>>>>>>>> -       preempt_enable();
>>>>>>>>      }
>>>>>>>>
>>>>>>>>      #ifdef CONFIG_CPU_HAS_LSX
>>>>>>>>      /* Enable LSX and restore context */
>>>>>>>>      int kvm_own_lsx(struct kvm_vcpu *vcpu)
>>>>>>>>      {
>>>>>>>> -       preempt_disable();
>>>>>>>> -
>>>>>>>>             /* Enable LSX for guest */
>>>>>>>>             kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
>>>>>>>>             set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
>>>>>>>> @@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>>>>>>>>
>>>>>>>>             trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
>>>>>>>>             vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
>>>>>>>> -       preempt_enable();
>>>>>>>>
>>>>>>>>             return 0;
>>>>>>>>      }
>>>>>>>> @@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>>>>>>>>      /* Enable LASX and restore context */
>>>>>>>>      int kvm_own_lasx(struct kvm_vcpu *vcpu)
>>>>>>>>      {
>>>>>>>> -       preempt_disable();
>>>>>>>> -
>>>>>>>>             kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
>>>>>>>>             set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
>>>>>>>>             switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
>>>>>>>> @@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
>>>>>>>>
>>>>>>>>             trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
>>>>>>>>             vcpu->arch.aux_inuse |= KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LARCH_FPU;
>>>>>>>> -       preempt_enable();
>>>>>>>>
>>>>>>>>             return 0;
>>>>>>>>      }
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>>>
>>>>>>
>>>>>>
>>>>
>>>>
>>
>>


