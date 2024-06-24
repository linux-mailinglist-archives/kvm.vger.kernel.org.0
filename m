Return-Path: <kvm+bounces-20347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AA0913FB7
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C02331F2179C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F214414;
	Mon, 24 Jun 2024 01:23:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9749A139D;
	Mon, 24 Jun 2024 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719192182; cv=none; b=KHevPq7+gHH5tKT4hN60D8g9CoHe50d6OfE+cMNYGJ5F87UcrW6+iY4f70oLgKKK2yA7/9nGMUjydo18bV/vVSWHss/pPqA2XNpU8L0Ly9nWxaHVkCQC6KfJnsYwXUh4GryAq58T/8oaz6R+7Foly9zvsGj/IRZmVPwOnXivD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719192182; c=relaxed/simple;
	bh=9llltrIGMmBESmvIfao8Pke88QIUolelyZPvVi4Whis=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a+pH8BiH1Hh8nukA1vCVUy6yL4r/0eHDNENpVytspRUYuWR0vQcY4Chze7EI0EAundSUivRFSzeGLbMBNC47R7ppx181NCUdgFwHfUn0XGBdApmvEEMvW/2Fs6hQGhyNKpfMpFORzl2bxwGZliBQgOnDng7naeF7XKRQtGY4ZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxP_BvynhmgWEJAA--.37948S3;
	Mon, 24 Jun 2024 09:22:55 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx68ZsynhmVoQuAA--.45218S3;
	Mon, 24 Jun 2024 09:22:54 +0800 (CST)
Subject: Re: [PATCH v2 1/6] LoongArch: KVM: Delay secondary mmu tlb flush
 until guest entry
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240619080940.2690756-1-maobibo@loongson.cn>
 <20240619080940.2690756-2-maobibo@loongson.cn>
 <CAAhV-H7zF7zDZQ0tHtZndTmWDteaV=nAwXL3Q1P2zcJssVt7tA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <5df4d756-d261-2629-a938-c9bfdb9d2534@loongson.cn>
Date: Mon, 24 Jun 2024 09:22:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7zF7zDZQ0tHtZndTmWDteaV=nAwXL3Q1P2zcJssVt7tA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx68ZsynhmVoQuAA--.45218S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JrWxWw15XFWxtrW5CF47Jrc_yoW7ur1UpF
	97uFnYqr4FgryfJ3s2qwn8Wr42qrWkKr1IvFy2yFWFyr1qqrn5Cr4vkrZ8XFy5Jw1rAF1I
	qFyrtFnI9FWjq3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU82g43UU
	UUU==



On 2024/6/23 下午3:54, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 19, 2024 at 4:09 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> If there is page fault for secondary mmu, there needs tlb flush
> What does "secondary mmu" in this context mean? Maybe "guest mmu"?
"secondary mmu" following x86 concepts, the weblink is:
    https://lwn.net/Articles/977945/

It is called stage-2 mmu on ARM64 also. "guest mmu" cannot represent 
whether it is gva to gpa, or gpa to hpa, or gva to hpa directly.

Regards
Bibo Mao

> 
> Huacai
> 
>> operation indexed with fault gpa address and VMID. VMID is stored
>> at register CSR_GSTAT and will be reload or recalculated during
>> guest entry.
>>
>> Currently CSR_GSTAT is not saved and restored during vcpu context
>> switch, it is recalculated during guest entry. So CSR_GSTAT is in
>> effect only when vcpu runs in guest mode, however it may be not in
>> effected if vcpu exits to host mode, since register CSR_GSTAT may
>> be stale, it maybe records VMID of last scheduled vcpu, rather than
>> current vcpu.
>>
>> Function kvm_flush_tlb_gpa() should be called with its real VMID,
>> here move it to guest entrance. Also arch specific request id
>> KVM_REQ_TLB_FLUSH_GPA is added to flush tlb, and it can be optimized
>> if VMID is updated, since all guest tlb entries will be invalid if
>> VMID is updated.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h |  2 ++
>>   arch/loongarch/kvm/main.c             |  1 +
>>   arch/loongarch/kvm/mmu.c              |  4 ++--
>>   arch/loongarch/kvm/tlb.c              |  5 +----
>>   arch/loongarch/kvm/vcpu.c             | 18 ++++++++++++++++++
>>   5 files changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index c87b6ea0ec47..32c4948f534f 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -30,6 +30,7 @@
>>   #define KVM_PRIVATE_MEM_SLOTS          0
>>
>>   #define KVM_HALT_POLL_NS_DEFAULT       500000
>> +#define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
>>
>>   #define KVM_GUESTDBG_SW_BP_MASK                \
>>          (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
>> @@ -190,6 +191,7 @@ struct kvm_vcpu_arch {
>>
>>          /* vcpu's vpid */
>>          u64 vpid;
>> +       gpa_t flush_gpa;
>>
>>          /* Frequency of stable timer in Hz */
>>          u64 timer_mhz;
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index 86a2f2d0cb27..844736b99d38 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -242,6 +242,7 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
>>                  kvm_update_vpid(vcpu, cpu);
>>                  trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
>>                  vcpu->cpu = cpu;
>> +               kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
>>          }
>>
>>          /* Restore GSTAT(0x50).vpid */
>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>> index 98883aa23ab8..9e39d28fec35 100644
>> --- a/arch/loongarch/kvm/mmu.c
>> +++ b/arch/loongarch/kvm/mmu.c
>> @@ -908,8 +908,8 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>                  return ret;
>>
>>          /* Invalidate this entry in the TLB */
>> -       kvm_flush_tlb_gpa(vcpu, gpa);
>> -
>> +       vcpu->arch.flush_gpa = gpa;
>> +       kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
>>          return 0;
>>   }
>>
>> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
>> index 02535df6b51f..ebdbe9264e9c 100644
>> --- a/arch/loongarch/kvm/tlb.c
>> +++ b/arch/loongarch/kvm/tlb.c
>> @@ -23,10 +23,7 @@ void kvm_flush_tlb_all(void)
>>
>>   void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>>   {
>> -       unsigned long flags;
>> -
>> -       local_irq_save(flags);
>> +       lockdep_assert_irqs_disabled();
>>          gpa &= (PAGE_MASK << 1);
>>          invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
>> -       local_irq_restore(flags);
>>   }
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 9e8030d45129..b747bd8bc037 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -51,6 +51,16 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>>          return RESUME_GUEST;
>>   }
>>
>> +static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
>> +{
>> +       lockdep_assert_irqs_disabled();
>> +       if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
>> +               if (vcpu->arch.flush_gpa != INVALID_GPA) {
>> +                       kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
>> +                       vcpu->arch.flush_gpa = INVALID_GPA;
>> +               }
>> +}
>> +
>>   /*
>>    * Check and handle pending signal and vCPU requests etc
>>    * Run with irq enabled and preempt enabled
>> @@ -101,6 +111,13 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>>                  /* Make sure the vcpu mode has been written */
>>                  smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>>                  kvm_check_vpid(vcpu);
>> +
>> +               /*
>> +                * Called after function kvm_check_vpid()
>> +                * Since it updates csr_gstat used by kvm_flush_tlb_gpa(),
>> +                * also it may clear KVM_REQ_TLB_FLUSH_GPA pending bit
>> +                */
>> +               kvm_late_check_requests(vcpu);
>>                  vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
>>                  /* Clear KVM_LARCH_SWCSR_LATEST as CSR will change when enter guest */
>>                  vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
>> @@ -994,6 +1011,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>          struct loongarch_csrs *csr;
>>
>>          vcpu->arch.vpid = 0;
>> +       vcpu->arch.flush_gpa = INVALID_GPA;
>>
>>          hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
>>          vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
>> --
>> 2.39.3
>>


