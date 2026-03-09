Return-Path: <kvm+bounces-73267-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEntBZiDrmlwFgIAu9opvQ
	(envelope-from <kvm+bounces-73267-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:23:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F2470235774
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 88E413008D33
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C8B36D4FF;
	Mon,  9 Mar 2026 08:23:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4138366DAE;
	Mon,  9 Mar 2026 08:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773044594; cv=none; b=j5wU/pZWuwlYWT4hP7ROJR7Lhy8KWrDeeQsfB46z9qdUzURJ3KXA9EJQxjP2TEO7RrG7X6IBDD1gzaKD8nHmLGPSHNmCK5e+vneWflRsZ3r1OsTkvsROHnjCsg5UOwpViU9awbBSZChi1G3mIbYjKi2m+PmbayHaSSAqD8IEEUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773044594; c=relaxed/simple;
	bh=wXhG9EqwfgR2Iff0v9TwyKYObE3otgtsah2AmUBHidA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=K3iZ5+UhS0oYDn7b5U1LH6pz0RwmmkrYsUuOlQ12gUVlHvuI+1ld9unaI03fZQ/B4hV6SEmWrr3Xg575NGVJ3pqCRC57yZQGJPrvYvFlTcupQ7Oo5AYzWCzyedY9lWFkUbxqiJg/x+lNWnc6LvH6MudRDe34X66V0Lfnl6maUHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8BxcfBrg65p9tgYAA--.8580S3;
	Mon, 09 Mar 2026 16:23:07 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowJBx68Fog65pzTBRAA--.21392S3;
	Mon, 09 Mar 2026 16:23:06 +0800 (CST)
Subject: Re: [PATCH v6 2/2] LongArch: KVM: Add dmsintc inject msi to the dest
 vcpu
To: Huacai Chen <chenhuacai@kernel.org>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kernel@xen0n.name, linux-kernel@vger.kernel.org
References: <20260206012028.3318291-1-gaosong@loongson.cn>
 <20260206012028.3318291-3-gaosong@loongson.cn>
 <CAAhV-H6-dsyV+2FsYYo1ZovrKP+WxkWRqjFFkjRSxEw4m6jhYQ@mail.gmail.com>
From: gaosong <gaosong@loongson.cn>
Message-ID: <016ca8d0-9690-15ee-e37b-1d4a15172a86@loongson.cn>
Date: Mon, 9 Mar 2026 16:24:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6-dsyV+2FsYYo1ZovrKP+WxkWRqjFFkjRSxEw4m6jhYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBx68Fog65pzTBRAA--.21392S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3WrWrAr17Zr18uFWkuw47KFX_yoWfAw17pF
	9ruFs8Wr4rJr17X3s2qa90vrnxArsagr12gFy29a4Skr1qvrn5XF18Gr9ruFy5Wa1UGF4I
	v3WfGa43Za1Ut3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-
	UUUUU
X-Rspamd-Queue-Id: F2470235774
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.135];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gaosong@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73267-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

在 2026/3/5 下午3:33, Huacai Chen 写道:
> Hi, Song,
>
> On Fri, Feb 6, 2026 at 9:45 AM Song Gao <gaosong@loongson.cn> wrote:
>> Implement irqfd deliver msi to vcpu and vcpu dmsintc inject irq.
>> Add irqfd choice dmsintc to set msi irq by the msg_addr and
>> implement dmsintc set msi irq.
>>
>> Signed-off-by: Song Gao <gaosong@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
>>   arch/loongarch/include/asm/kvm_host.h    |  5 ++
>>   arch/loongarch/kvm/intc/dmsintc.c        |  6 +++
>>   arch/loongarch/kvm/interrupt.c           |  1 +
>>   arch/loongarch/kvm/irqfd.c               | 42 +++++++++++++++--
>>   arch/loongarch/kvm/vcpu.c                | 58 ++++++++++++++++++++++++
>>   6 files changed, 109 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
>> index 1d4f66996f3c..9b5436a2fcbe 100644
>> --- a/arch/loongarch/include/asm/kvm_dmsintc.h
>> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
>> @@ -11,6 +11,7 @@ struct loongarch_dmsintc  {
>>          struct kvm *kvm;
>>          uint64_t msg_addr_base;
>>          uint64_t msg_addr_size;
>> +       uint32_t cpu_mask;
>>   };
>>
>>   struct dmsintc_state {
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 5e9e2af7312f..91e0190aeaec 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -258,6 +258,11 @@ struct kvm_vcpu_arch {
>>          } st;
>>   };
>>
>> +void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu);
>> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
>> +                               struct kvm_vcpu *vcpu,
>> +                               u32 vector, int level);
>> +
>>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
>>   {
>>          return csr->csrs[reg];
>> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
>> index 00e401de0464..1bb61e55d061 100644
>> --- a/arch/loongarch/kvm/intc/dmsintc.c
>> +++ b/arch/loongarch/kvm/intc/dmsintc.c
>> @@ -15,6 +15,7 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
>>          void __user *data;
>>          struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
>>          u64 tmp;
>> +       u32 cpu_bit;
>>
>>          data = (void __user *)attr->addr;
>>          switch (addr) {
>> @@ -30,6 +31,11 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
>>                                  s->msg_addr_base = tmp;
>>                          else
>>                                  return  -EFAULT;
>> +                       s->msg_addr_base = tmp;
>> +                       cpu_bit = find_first_bit((unsigned long *)&(s->msg_addr_base), 64)
>> +                                               - AVEC_CPU_SHIFT;
>> +                       cpu_bit = min(cpu_bit, AVEC_CPU_BIT);
>> +                       s->cpu_mask = GENMASK(cpu_bit - 1, 0) & AVEC_CPU_MASK;
>>                  }
>>                  break;
>>          case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> I'm not sure but maybe this part should go to the first patch?
I'll move it to patch1.
>> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
>> index a6d42d399a59..893a81ca1079 100644
>> --- a/arch/loongarch/kvm/interrupt.c
>> +++ b/arch/loongarch/kvm/interrupt.c
>> @@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
>>                  irq = priority_to_irq[priority];
>>
>>          if (cpu_has_msgint && (priority == INT_AVEC)) {
>> +               loongarch_dmsintc_inject_irq(vcpu);
>>                  set_gcsr_estat(irq);
>>                  return 1;
>>          }
>> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
>> index 9a39627aecf0..3bbb26f4e2b7 100644
>> --- a/arch/loongarch/kvm/irqfd.c
>> +++ b/arch/loongarch/kvm/irqfd.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/kvm_host.h>
>>   #include <trace/events/kvm.h>
>>   #include <asm/kvm_pch_pic.h>
>> +#include <asm/kvm_vcpu.h>
>>
>>   static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>                  struct kvm *kvm, int irq_source_id, int level, bool line_status)
>> @@ -16,6 +17,38 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>>          return 0;
>>   }
>>
>> +static int kvm_dmsintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, int level)
>> +{
>> +       unsigned int virq, dest;
>> +       struct kvm_vcpu *vcpu;
>> +
>> +       virq = (addr >> AVEC_IRQ_SHIFT) & AVEC_IRQ_MASK;
>> +       dest = (addr >> AVEC_CPU_SHIFT) & kvm->arch.dmsintc->cpu_mask;
>> +       if (dest > KVM_MAX_VCPUS)
>> +               return -EINVAL;
>> +       vcpu = kvm_get_vcpu_by_cpuid(kvm, dest);
>> +       if (!vcpu)
>> +               return -EINVAL;
>> +       return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
>> +}
>> +
>> +static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
>> +                       struct kvm *kvm, int level)
>> +{
>> +       u64 msg_addr;
>> +
>> +       msg_addr = (((u64)e->msi.address_hi) << 32) | e->msi.address_lo;
>> +       if (cpu_has_msgint && kvm->arch.dmsintc &&
>> +               msg_addr >= kvm->arch.dmsintc->msg_addr_base &&
>> +               msg_addr < (kvm->arch.dmsintc->msg_addr_base  + kvm->arch.dmsintc->msg_addr_size)) {
>> +               return kvm_dmsintc_set_msi_irq(kvm, msg_addr, e->msi.data, level);
>> +       } else {
>> +               pch_msi_set_irq(kvm, e->msi.data, level);
>> +       }
>> +
>> +       return 0;
>> +}
> Rename loongarch_set_msi() to loongarch_msi_set_irq(), rename
> kvm_dmsintc_set_msi_irq() to dmsintc_msi_set_irq(), this makes the
> naming more consistent.
Got it .
>> +
>>   /*
>>    * kvm_set_msi: inject the MSI corresponding to the
>>    * MSI routing entry
>> @@ -29,9 +62,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>          if (!level)
>>                  return -1;
>>
>> -       pch_msi_set_irq(kvm, e->msi.data, level);
>> -
>> -       return 0;
>> +       return loongarch_set_msi(e, kvm, level);
>>   }
>>
>>   /*
>> @@ -71,12 +102,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>   int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>>                  struct kvm *kvm, int irq_source_id, int level, bool line_status)
>>   {
>> +       if (!level)
>> +               return -EWOULDBLOCK;
>> +
>>          switch (e->type) {
>>          case KVM_IRQ_ROUTING_IRQCHIP:
>>                  pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
>>                  return 0;
>>          case KVM_IRQ_ROUTING_MSI:
>> -               pch_msi_set_irq(kvm, e->msi.data, level);
>> +               loongarch_set_msi(e, kvm, level);
>>                  return 0;
>>          default:
>>                  return -EWOULDBLOCK;
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..325bb084d704 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -14,6 +14,64 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>>
>> +void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu)
>> +{
>> +       struct dmsintc_state *ds = &vcpu->arch.dmsintc_state;
>> +       unsigned int i;
>> +       unsigned long temp[4], old;
>> +
>> +       if (!ds)
>> +               return;
>> +
>> +       for (i = 0; i < 4; i++) {
>> +               old = atomic64_read(&(ds->vector_map[i]));
>> +               if (old)
>> +                       temp[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
>> +       }
>> +
>> +       if (temp[0]) {
>> +               old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
>> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
>> +       }
>> +
>> +       if (temp[1]) {
>> +               old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
>> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
>> +       }
>> +
>> +       if (temp[2]) {
>> +               old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
>> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
>> +       }
>> +
>> +       if (temp[3]) {
>> +               old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
>> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
>> +       }
>> +}
> The only caller is in interrupt.c, so rename
> loongarch_dmsintc_inject_irq() to msgint_inject_irq() (or
> dmsintc_inject_irq() if you prefer), and move it to interrupt.c, then
> we don't need to declare it as a extern function.
Got it.
>> +
>> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
>> +                               struct kvm_vcpu *vcpu,
>> +                               u32 vector, int level)
>> +{
>> +       struct kvm_interrupt vcpu_irq;
>> +       struct dmsintc_state *ds;
>> +
>> +       if (!level)
>> +               return 0;
>> +       if (!vcpu || vector >= 256)
>> +               return -EINVAL;
>> +       ds = &vcpu->arch.dmsintc_state;
>> +       if (!ds)
>> +               return -ENODEV;
>> +       set_bit(vector, (unsigned long *)&ds->vector_map);
>> +       vcpu_irq.irq = INT_AVEC;
>> +       kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
>> +       kvm_vcpu_kick(vcpu);
>> +       return 0;
>> +}
> The only caller is in irqfd.c, so rename
> kvm_loongarch_deliver_msi_to_vcpu() to dmsintc_deliver_msi_to_vcpu(),
> and move it to irqfd.c, then we don't need to declare it as a extern
> function.
Got it .
> And in addition, from Documentation/arch/loongarch/irq-chip-model.rst,
> all msi irq are triggered from "pch_msi_irq", which means it is not
> reasonable to dispatch the dmsintc/pch_msi paths in
> loongarch_set_msi(). Instead, we should dispatch the dmsintc/eiointc
> paths in pch_msi_set_irq(), this needs a rework...

longarch_set_msi() is equivalent to what you mentioned as pch_msi_set_irq(). I will correct it in the next version.

Thanks.
Song Gao

>
> Huacai
>
>> +
>> +
>>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>          KVM_GENERIC_VCPU_STATS(),
>>          STATS_DESC_COUNTER(VCPU, int_exits),
>> --
>> 2.39.3
>>
>>


