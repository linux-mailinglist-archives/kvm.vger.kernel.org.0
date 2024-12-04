Return-Path: <kvm+bounces-32983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB839E328E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 05:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DDAD283B57
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 04:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEE917A597;
	Wed,  4 Dec 2024 04:08:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFFA415098F;
	Wed,  4 Dec 2024 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733285293; cv=none; b=FyDN/T+A/ArbVY+InCxLHhGjpB/mFv2gMqldIBxwbX5uSmRc+WB5uojl6OkP7tsMl0qaPXdWeFrxE4ubmnmyZ9myR7dFhV9wbOY9TduYdSgxUvG7PvDyECd4IYuM97Zh6lfR08xRmRU1ErtfZZM16zgyc9TBC6K7r92mwXFWTTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733285293; c=relaxed/simple;
	bh=0Rpc7llVEiAcCOfdXSEaBpkfJ8u8QDAIAV9PHFagg88=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EwUMOuss/AT+T0WTq+CYtA6cFcgzX43uaP+JwIR3HEy/QYHprb/qPSsf/h1vqnTHlUmUrYU5mOHqtJ/ALlqx+n18I5354HrqvbNPkBpDZxvvjGQuQTp/TgSxiZ6p+a0FpU9cQrvKvhE/q1KTkyZgElcTneBver2lKb45mXp9Ljk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxDeOn1U9nVmVQAA--.24041S3;
	Wed, 04 Dec 2024 12:08:07 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxjkek1U9n9AR1AA--.58910S3;
	Wed, 04 Dec 2024 12:08:07 +0800 (CST)
Subject: Re: [RFC 1/5] LoongArch: KVM: Add vmid support for stage2 MMU
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241113031727.2815628-1-maobibo@loongson.cn>
 <20241113031727.2815628-2-maobibo@loongson.cn>
 <CAAhV-H5PoitK=a_snYA=PjDoZxWT5QcbrJfnMe3DJGXN=J0tZA@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <6fa4fc4c-22f7-7e9c-4571-14dce6b36f4d@loongson.cn>
Date: Wed, 4 Dec 2024 12:07:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5PoitK=a_snYA=PjDoZxWT5QcbrJfnMe3DJGXN=J0tZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxjkek1U9n9AR1AA--.58910S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWw18WFWfKF15JFy3Ww4kuFX_yoW7Jr1DpF
	yDAF4kWr48Kr1kAa4qq3s5Wr4UX3yDKw1aga1xAFyFyr12qr1UJrykCryDuFy5Jw4rAF4I
	vF9Yya9FvF4Ut3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
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



On 2024/12/3 上午10:46, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Nov 13, 2024 at 11:17 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> LoongArch KVM hypervisor supports two-level MMU, vpid index is used
>> for stage1 MMU and vmid index is used for stage2 MMU.
>>
>> On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
>> may separate from vpid. If vcpu migrate to different physical CPUs,
>> vpid need change however vmid can keep the same with old value. Also
>> vmid index of the while VM machine on physical CPU the same, all vCPUs
>> on the VM can share the same vmid index on one physical CPU.
>>
>> Here vmid index is added and it keeps the same with vpid still.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h | 3 +++
>>   arch/loongarch/kernel/asm-offsets.c   | 1 +
>>   arch/loongarch/kvm/main.c             | 1 +
>>   arch/loongarch/kvm/switch.S           | 5 ++---
>>   arch/loongarch/kvm/tlb.c              | 5 ++++-
>>   5 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index d6bb72424027..6151c7c470d5 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
>>          unsigned long host_tp;
>>          unsigned long host_pgd;
>>
>> +       /* vmid info for guest VM */
>> +       unsigned long vmid;
> vmid is a member of kvm_vcpu_arch, no of kvm_arch?
As patch 3, there is such line
+       vcpu->arch.vmid = vcpu->kvm->arch.vmid[cpu] & vpid_mask;

It is the same. Adding a member in kvm_vcpu_arch is easy to
access kvm_vcpu_arch data structure in kvm context switch assemble
code. When switching to VM, vmid should be set. And vmid should be zero 
when resume to host.
 >> -       csrrd           t1, LOONGARCH_CSR_GSTAT
 >> -       bstrpick.w      t1, t1, CSR_GSTAT_GID_SHIFT_END, 
CSR_GSTAT_GID_SHIFT
 >> +       /* Set VMID for gpa --> hpa mapping */
 >> +       ld.d            t1, a2, KVM_ARCH_VMID
 >>          csrrd           t0, LOONGARCH_CSR_GTLBC
 >>          bstrins.w       t0, t1, CSR_GTLBC_TGID_SHIFT_END, 
CSR_GTLBC_TGID_SHIFT

> 
>> +
>>          /* Host CSRs are used when handling exits from guest */
>>          unsigned long badi;
>>          unsigned long badv;
>> diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
>> index bee9f7a3108f..4e9a9311afd3 100644
>> --- a/arch/loongarch/kernel/asm-offsets.c
>> +++ b/arch/loongarch/kernel/asm-offsets.c
>> @@ -307,6 +307,7 @@ static void __used output_kvm_defines(void)
>>          OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
>>          OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
>>          OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
>> +       OFFSET(KVM_ARCH_VMID, kvm_vcpu_arch, vmid);
>>          OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
>>          OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
>>          OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index 27e9b94c0a0b..8c16bff80053 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -212,6 +212,7 @@ static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
>>
>>          context->vpid_cache = vpid;
>>          vcpu->arch.vpid = vpid;
> I think vpid should also be:
>             vcpu->arch.vpid = vpid & vpid_mask;
yes, vpid should be similar with vmid. Will modify it in next round.

Regards
Bibo Mao
> 
> Huacai
> 
>> +       vcpu->arch.vmid = vcpu->arch.vpid & vpid_mask;
>>   }
>>
>>   void kvm_check_vpid(struct kvm_vcpu *vcpu)
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> index 0c292f818492..2774343f64d3 100644
>> --- a/arch/loongarch/kvm/switch.S
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -72,9 +72,8 @@
>>          ldx.d   t0, t1, t0
>>          csrwr   t0, LOONGARCH_CSR_PGDL
>>
>> -       /* Mix GID and RID */
>> -       csrrd           t1, LOONGARCH_CSR_GSTAT
>> -       bstrpick.w      t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
>> +       /* Set VMID for gpa --> hpa mapping */
>> +       ld.d            t1, a2, KVM_ARCH_VMID
>>          csrrd           t0, LOONGARCH_CSR_GTLBC
>>          bstrins.w       t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>>          csrwr           t0, LOONGARCH_CSR_GTLBC
>> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
>> index ebdbe9264e9c..38daf936021d 100644
>> --- a/arch/loongarch/kvm/tlb.c
>> +++ b/arch/loongarch/kvm/tlb.c
>> @@ -23,7 +23,10 @@ void kvm_flush_tlb_all(void)
>>
>>   void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>>   {
>> +       unsigned int vmid;
>> +
>>          lockdep_assert_irqs_disabled();
>>          gpa &= (PAGE_MASK << 1);
>> -       invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
>> +       vmid = (vcpu->arch.vmid << CSR_GSTAT_GID_SHIFT) & CSR_GSTAT_GID;
>> +       invtlb(INVTLB_GID_ADDR, vmid, gpa);
>>   }
>> --
>> 2.39.3
>>


