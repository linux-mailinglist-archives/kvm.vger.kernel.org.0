Return-Path: <kvm+bounces-21926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3BB937638
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 11:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE43B1F25D5C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 09:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DB082D9A;
	Fri, 19 Jul 2024 09:55:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F5442076;
	Fri, 19 Jul 2024 09:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382956; cv=none; b=UK3IjU2vuFhjCdBMfO+TcnllALrjjUabp2aUBmEz9fksukko0ZDaDL3O8FSwjWrUL3omTgyWtPVLMqQZXn9LJqskSdr3k60pEQ854tzax5qlqXSyDAHCvQDy8gi727I3Fk+/hDEH/oMM/UMccsfkwdHBRNojpcx3Jg2bKUQQ+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382956; c=relaxed/simple;
	bh=ZN/JHwD665FnTQXmckmZYHrhRvmVopiclH3cF2kyc/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P5Kl4VOz4OOvGucoAx3looOXqtiKpI3Wg743aGWLiCo/xeAswCQpPi+suVjccBQ0vyO5VXw/KP0maGHep/5VtjS5Vc5Zm5GQuPxNCPqloT0SLRtyaN8RkK5eih4YMFRm5oJ5/4iSpRfpI887g5Mg7tNaqERfDCU77ZexLwhDM6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.218] (unknown [121.237.44.107])
	by APP-01 (Coremail) with SMTP id qwCowAB3fMgaOJpmVhxMBA--.3012S2;
	Fri, 19 Jul 2024 17:55:38 +0800 (CST)
Message-ID: <2dc4c5bb-57b0-415a-87e9-f738062e1d29@iscas.ac.cn>
Date: Fri, 19 Jul 2024 17:55:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] riscv: KVM: add basic support for host vs guest
 profiling
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org
References: <cover.1721271251.git.zhouquan@iscas.ac.cn>
 <fbf8a9fcca05a1b554ac0d01b0c46fbb6263c435.1721271251.git.zhouquan@iscas.ac.cn>
 <20240718-f39bdec648fc285ffe46cc3e@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20240718-f39bdec648fc285ffe46cc3e@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAB3fMgaOJpmVhxMBA--.3012S2
X-Coremail-Antispam: 1UD129KBjvJXoWxArW3KFy7Cr4UKr4fuw4xtFb_yoWrAFy5pF
	Z8CFs8Cw4rtryxKa4Svr1v9r4Fqrs5Kw13Zry8CFy5Jrs8Kry8Jr4vg34DCr98AF40qF1I
	yFy8KF13uwn8J3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07jY89tUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAgDBmaZ9QP4jgABs-


On 2024/7/19 01:09, Andrew Jones wrote:
> On Thu, Jul 18, 2024 at 07:23:51PM GMT, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> For the information collected on the host side, we need to
>> identify which data originates from the guest and record
>> these events separately. This can be achieved by having
>> KVM register perf callbacks.
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>   arch/riscv/include/asm/kvm_host.h |  6 ++++++
>>   arch/riscv/kvm/Kconfig            |  1 +
>>   arch/riscv/kvm/main.c             | 12 ++++++++++--
>>   arch/riscv/kvm/vcpu.c             |  7 +++++++
>>   4 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>> index d96281278586..b7bbe1c0c5dd 100644
>> --- a/arch/riscv/include/asm/kvm_host.h
>> +++ b/arch/riscv/include/asm/kvm_host.h
>> @@ -285,6 +285,12 @@ struct kvm_vcpu_arch {
>>   	} sta;
>>   };
>>   
>> +/* TODO: A more explicit approach might be needed here than this simple one */
> 
> Can you elaborate on this concern?
> 

Can we determine if a PMU interrupt occurs in the guest solely based on 
whether the vcpu is loaded?

In the kvm_arch_vcpu_ioctl_run while loop, when the guest exits, 
host-side interrupts should be handled in local_irq_{enable/disable}. 
Should we add a flag here (referencing x86) to further determine if 
"this is a host interrupt triggered while the guest was running, rather 
than when the host is running". Doing so might further reduce the 
likelihood of perf incorrectly identifying "PMI in host" as "PMI in 
guest," but it may not completely eliminate it.

Have I misunderstood any points here?

Thanks,
Quan

>> +static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
>> +{
>> +	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
>> +}
>> +
>>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>>   
>> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
>> index 26d1727f0550..0c3cbb0915ff 100644
>> --- a/arch/riscv/kvm/Kconfig
>> +++ b/arch/riscv/kvm/Kconfig
>> @@ -32,6 +32,7 @@ config KVM
>>   	select KVM_XFER_TO_GUEST_WORK
>>   	select KVM_GENERIC_MMU_NOTIFIER
>>   	select SCHED_INFO
>> +	select GUEST_PERF_EVENTS if PERF_EVENTS
>>   	help
>>   	  Support hosting virtualized guest machines.
>>   
>> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
>> index bab2ec34cd87..734b48d8f6dd 100644
>> --- a/arch/riscv/kvm/main.c
>> +++ b/arch/riscv/kvm/main.c
>> @@ -51,6 +51,12 @@ void kvm_arch_hardware_disable(void)
>>   	csr_write(CSR_HIDELEG, 0);
>>   }
>>   
>> +static void kvm_riscv_teardown(void)
>> +{
>> +	kvm_riscv_aia_exit();
>> +	kvm_unregister_perf_callbacks();
>> +}
>> +
>>   static int __init riscv_kvm_init(void)
>>   {
>>   	int rc;
>> @@ -105,9 +111,11 @@ static int __init riscv_kvm_init(void)
>>   		kvm_info("AIA available with %d guest external interrupts\n",
>>   			 kvm_riscv_aia_nr_hgei);
>>   
>> +	kvm_register_perf_callbacks(NULL);
>> +
>>   	rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>>   	if (rc) {
>> -		kvm_riscv_aia_exit();
>> +		kvm_riscv_teardown();
>>   		return rc;
>>   	}
>>   
>> @@ -117,7 +125,7 @@ module_init(riscv_kvm_init);
>>   
>>   static void __exit riscv_kvm_exit(void)
>>   {
>> -	kvm_riscv_aia_exit();
>> +	kvm_riscv_teardown();
>>   
>>   	kvm_exit();
>>   }
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 17e21df36cc1..c9d291865141 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -222,6 +222,13 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>>   	return (vcpu->arch.guest_context.sstatus & SR_SPP) ? true : false;
>>   }
>>   
>> +#ifdef CONFIG_GUEST_PERF_EVENTS
>> +unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.guest_context.sepc;
>> +}
>> +#endif
>> +
>>   vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>>   {
>>   	return VM_FAULT_SIGBUS;
>> -- 
>> 2.34.1
>>
> 
> Otherwise,
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


