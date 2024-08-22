Return-Path: <kvm+bounces-24808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 976C095ADD3
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31803B21266
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 06:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B5113C3CD;
	Thu, 22 Aug 2024 06:43:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE7813B2B0;
	Thu, 22 Aug 2024 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308992; cv=none; b=gWd1ejzwSV1SMdJLyMhG69vmyuHPGxSBfe5dMzND58kiyqYtv4cBjRJFkLbYmV5nBDa0u6rNbcNPev3Ll/DNLjZR0tGRHsj/SE323AUA+wKlggNnsrCQZfKaSJ/lG2AfYK4vn9VCklJJ/OigLvdSVgvf8AkpOvHCIZ8GIkwNlm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308992; c=relaxed/simple;
	bh=X29w5xt9nJTkUZs2UHTC9nuFtNbz6aHwGbv9Bg3+R9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTap1inpldlC5b2VKS/FiOSilTcombu3ShpNX9GHhU1zO2dEWiYuMviYWf+m9kv+gXJBSrq7Od4oc395SYAAlMdUCUAemNCJD1VGatqRSySIeq6uaLw2FigbY5TZQ5J2ErHZA3XB2R6eRvfg3tcGpRA26+vysoOHocIUwtZMJuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.218] (unknown [121.237.44.107])
	by APP-01 (Coremail) with SMTP id qwCowADHz8Pt3cZmsJgfCQ--.23985S2;
	Thu, 22 Aug 2024 14:42:54 +0800 (CST)
Message-ID: <3e5e4ba4-acb6-4cea-96f8-b16886bb6285@iscas.ac.cn>
Date: Thu, 22 Aug 2024 14:42:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] riscv: KVM: add basic support for host vs guest
 profiling
To: Andrew Jones <ajones@ventanamicro.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org
References: <cover.1723518282.git.zhouquan@iscas.ac.cn>
 <7eb3e1a8fc9f9aa0340a6a1fb88a127b767480ea.1723518282.git.zhouquan@iscas.ac.cn>
 <20240821-5284bf727abbb08a379e1d06@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20240821-5284bf727abbb08a379e1d06@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowADHz8Pt3cZmsJgfCQ--.23985S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw47uF1DXr47Zr43GFy3Arb_yoW5KFWDpF
	Z8CFs5Ca1rtryxGa4Svr1v9r4FgrsYgw1a9ryUCFy5Ar4DKry8Jr4vg34DCryDJF48XF1I
	kFy0gF13uws8t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_GF1l42xK82IYc2Ij64vIr41l4I8I3I
	0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
	GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
	0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
	rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
	4UJbIYCTnIWIevJa73UjIFyTuYvjxUxwZ2UUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAcRBmbGjC-49gABsQ


On 2024/8/21 20:51, Andrew Jones wrote:
> On Tue, Aug 13, 2024 at 09:24:10PM GMT, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> For the information collected on the host side, we need to
>> identify which data originates from the guest and record
>> these events separately, this can be achieved by having
>> KVM register perf callbacks.
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>   arch/riscv/include/asm/kvm_host.h |  5 +++++
>>   arch/riscv/kvm/Kconfig            |  1 +
>>   arch/riscv/kvm/main.c             | 12 ++++++++++--
>>   arch/riscv/kvm/vcpu.c             |  7 +++++++
>>   4 files changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>> index 2e2254fd2a2a..d2350b08a3f4 100644
>> --- a/arch/riscv/include/asm/kvm_host.h
>> +++ b/arch/riscv/include/asm/kvm_host.h
>> @@ -286,6 +286,11 @@ struct kvm_vcpu_arch {
>>   	} sta;
>>   };
>>
> 
> Let's add the same comment here that arm64 has unless you determine
> that 'any event that arrives while a vCPU is loaded is considered to be
> "in guest"' is not true for riscv.
> 

Ok, i will add this comment to clarify the point.

Thanks,
Quan

>> +static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
>> +{
>> +	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
>> +}
>> +
>>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>   
>>   #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
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
>> index 8d7d381737ee..e8ffb3456898 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -226,6 +226,13 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
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
> Thanks,
> drew


