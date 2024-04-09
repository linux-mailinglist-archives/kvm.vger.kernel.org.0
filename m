Return-Path: <kvm+bounces-14045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 466E789E661
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0566286F36
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DB51591F3;
	Tue,  9 Apr 2024 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CGzdr53L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88908158DCA
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706478; cv=none; b=kqV69jkH+YfnxobABp/EmfY/I9hSXJKbUx4ogQFMEGCSw4JMBz08YQVINE6rJ+gu+rNGv+o3qtHdAKi8ov1wSsxnewwBFC2K/SigIuR63fhBhouyki9MXrhcJQlGAbQ/8NgVIDTs5zuSXuiadU+oOSLMsigteoLZ3C2UgeatqCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706478; c=relaxed/simple;
	bh=fojvbkoQ1qnxHWDrD0djvFzPN586S6oM8s/o1Hodv8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iuyeimXWzuDclKETdD2f1FsJG7pnP6ZUNhYEXhi0cOlpGRjVKuA/5RJyR0FaOh3ybumnx8AkjGL0OKfojABBgTmMTHsVBgwk/W9T937Qq6NWn3u06CVUPZaFcGzbTQSLoGSo1X+nL1Y/1JSMpveYPZP98n+IhQapK7JecsoMjec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CGzdr53L; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e3e84a302eso23323105ad.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 16:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712706475; x=1713311275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RgrB4N7HIT6g2jHcT1375/VgKhsjQsjM2O3SRfcZbZc=;
        b=CGzdr53L/BP1jirwWTssnrJlHi7V45slGcUWe75K5N2dlZPc0dss4G1NK0sDE1XS3E
         bM3+PzZglaj65MEu5Kbd0/nMbZKB9wkBRQOOldCpVnXRVeyk92bs9CVGr1Svgqht/NyW
         FYhk4oBxweZdtWhnWnmn71zyXIJUqCZ74Ib0Iu5cb0M9fjBwtjpkYfxshJVSWf1KSVcK
         8idc81ym5oCJyrv4YrcwxfsZ8ZIIHfHO4rkvlahaGH6H0HeTbwmO0pKPTl/inCJuta4E
         SfR7qHEJvmRIlMs+Un6QJNNSKRjZQM5AB4LB+B1NXLevM4o2rq128+YaGjuqyQ+xDgDG
         REHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712706475; x=1713311275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RgrB4N7HIT6g2jHcT1375/VgKhsjQsjM2O3SRfcZbZc=;
        b=YgwNsxY4mOqQuPS0I++Xe74p7SHjOtVxgFNK8JnT+JAhPFKiuOVGpf3eUgw1acodMM
         0aqsUNBXJpHzijFijhfSVVd83QEByTkKB6CjeXvQJ1PdT0VSDVCTMmBUN4njLmCqO2xJ
         vh/xwFegMOPpJY5t9JZvSk7Ksex5aJ4eZfuoEIrorfhnJuz5Gc8W2MAjZQKUfD8sTFkl
         LDA6p98txiOZQ57X2ONEKhJXVOmG1Bcb8xRJJR3by7gshiW1xNEb37GhHIaePRSbgms8
         Q/KD0JvmgYlJxiZnpJrytdQvyKWyNaxY/23wE5Ze1OeWeqNxoyIW9e+AcbQcpC4C7ba6
         VZ0w==
X-Forwarded-Encrypted: i=1; AJvYcCUTAVk1qFfy75RN0x6dRhb4q0ek1fuAltvkx+Wlea3/iSh1vBH/LQYh4msHekSKjQD2XgTP/jldwbtClKvIR0IYvK+1
X-Gm-Message-State: AOJu0Yw7ap+Cvm1+rwkILwbKZfxiP+ro/XwAXsnFKYIhYiasSZDZo6tL
	VztiRsAfWzYwVHmne/azA06NejZEa3doqFwKJtPRHpYjIXCGMJdhRey3YvFsgVc=
X-Google-Smtp-Source: AGHT+IHk/q17IeOHQyGGUSgmO41DCPXIxbm368Sp4qp2GXcbAOCnlkTai/EEVXRYcJTcrtE51VHdfw==
X-Received: by 2002:a17:902:f611:b0:1e2:a7bf:5172 with SMTP id n17-20020a170902f61100b001e2a7bf5172mr1613615plg.52.1712706474847;
        Tue, 09 Apr 2024 16:47:54 -0700 (PDT)
Received: from [10.0.16.226] ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id w19-20020a170902d11300b001e0501d3058sm9518174plw.63.2024.04.09.16.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 16:47:54 -0700 (PDT)
Message-ID: <4f3fa42e-eaf9-40bf-8906-6193ea21a575@rivosinc.com>
Date: Tue, 9 Apr 2024 16:47:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/22] KVM: riscv: selftests: Add a test for counter
 overflow
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
 Ajay Kaher <akaher@vmware.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Alexey Makhalov <amakhalov@vmware.com>,
 Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>,
 virtualization@lists.linux.dev,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Will Deacon <will@kernel.org>, x86@kernel.org
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-23-atishp@rivosinc.com>
 <20240405-3a20fe10d65368651c2d23fa@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240405-3a20fe10d65368651c2d23fa@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/24 06:23, Andrew Jones wrote:
> On Wed, Apr 03, 2024 at 01:04:51AM -0700, Atish Patra wrote:
>> Add a test for verifying overflow interrupt. Currently, it relies on
>> overflow support on cycle/instret events. This test works for cycle/
>> instret events which support sampling via hpmcounters on the platform.
>> There are no ISA extensions to detect if a platform supports that. Thus,
>> this test will fail on platform with virtualization but doesn't
>> support overflow on these two events.
> 
> Maybe we should give the user a command line option to disable this test
> in case the platform they're testing doesn't support it but they want to
> run the rest of the tests without getting a FAIL.
> 

Sure. I will add that option.

>>
>> Reviewed-by: Anup Patel <anup@brainfault.org>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>>   .../selftests/kvm/riscv/sbi_pmu_test.c        | 114 ++++++++++++++++++
>>   1 file changed, 114 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
>> index 7d195be5c3d9..451db956b885 100644
>> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
>> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
>> @@ -14,6 +14,7 @@
>>   #include "test_util.h"
>>   #include "processor.h"
>>   #include "sbi.h"
>> +#include "arch_timer.h"
>>   
>>   /* Maximum counters(firmware + hardware) */
>>   #define RISCV_MAX_PMU_COUNTERS 64
>> @@ -24,6 +25,9 @@ union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
>>   static void *snapshot_gva;
>>   static vm_paddr_t snapshot_gpa;
>>   
>> +static int vcpu_shared_irq_count;
>> +static int counter_in_use;
>> +
>>   /* Cache the available counters in a bitmask */
>>   static unsigned long counter_mask_available;
>>   
>> @@ -117,6 +121,31 @@ static void guest_illegal_exception_handler(struct ex_regs *regs)
>>   	regs->epc += 4;
>>   }
>>   
>> +static void guest_irq_handler(struct ex_regs *regs)
>> +{
>> +	unsigned int irq_num = regs->cause & ~CAUSE_IRQ_FLAG;
>> +	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
>> +	unsigned long overflown_mask;
>> +	unsigned long counter_val = 0;
>> +
>> +	/* Validate that we are in the correct irq handler */
>> +	GUEST_ASSERT_EQ(irq_num, IRQ_PMU_OVF);
>> +
>> +	/* Stop all counters first to avoid further interrupts */
>> +	stop_counter(counter_in_use, SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT);
>> +
>> +	csr_clear(CSR_SIP, BIT(IRQ_PMU_OVF));
>> +
>> +	overflown_mask = READ_ONCE(snapshot_data->ctr_overflow_mask);
>> +	GUEST_ASSERT(overflown_mask & 0x01);
>> +
>> +	WRITE_ONCE(vcpu_shared_irq_count, vcpu_shared_irq_count+1);
>> +
>> +	counter_val = READ_ONCE(snapshot_data->ctr_values[0]);
>> +	/* Now start the counter to mimick the real driver behavior */
>> +	start_counter(counter_in_use, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_val);
>> +}
>> +
>>   static unsigned long get_counter_index(unsigned long cbase, unsigned long cmask,
>>   				       unsigned long cflags,
>>   				       unsigned long event)
>> @@ -276,6 +305,33 @@ static void test_pmu_event_snapshot(unsigned long event)
>>   	stop_reset_counter(counter, 0);
>>   }
>>   
>> +static void test_pmu_event_overflow(unsigned long event)
>> +{
>> +	unsigned long counter;
>> +	unsigned long counter_value_post;
>> +	unsigned long counter_init_value = ULONG_MAX - 10000;
>> +	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
>> +
>> +	counter = get_counter_index(0, counter_mask_available, 0, event);
>> +	counter_in_use = counter;
>> +
>> +	/* The counter value is updated w.r.t relative index of cbase passed to start/stop */
>> +	WRITE_ONCE(snapshot_data->ctr_values[0], counter_init_value);
>> +	start_counter(counter, SBI_PMU_START_FLAG_INIT_SNAPSHOT, 0);
>> +	dummy_func_loop(10000);
>> +	udelay(msecs_to_usecs(2000));
>> +	/* irq handler should have stopped the counter */
>> +	stop_counter(counter, SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT);
>> +
>> +	counter_value_post = READ_ONCE(snapshot_data->ctr_values[0]);
>> +	/* The counter value after stopping should be less the init value due to overflow */
>> +	__GUEST_ASSERT(counter_value_post < counter_init_value,
>> +		       "counter_value_post %lx counter_init_value %lx for counter\n",
>> +		       counter_value_post, counter_init_value);
>> +
>> +	stop_reset_counter(counter, 0);
>> +}
>> +
>>   static void test_invalid_event(void)
>>   {
>>   	struct sbiret ret;
>> @@ -366,6 +422,34 @@ static void test_pmu_events_snaphost(void)
>>   	GUEST_DONE();
>>   }
>>   
>> +static void test_pmu_events_overflow(void)
>> +{
>> +	int num_counters = 0;
>> +
>> +	/* Verify presence of SBI PMU and minimum requrired SBI version */
>> +	verify_sbi_requirement_assert();
>> +
>> +	snapshot_set_shmem(snapshot_gpa, 0);
>> +	csr_set(CSR_IE, BIT(IRQ_PMU_OVF));
>> +	local_irq_enable();
>> +
>> +	/* Get the counter details */
>> +	num_counters = get_num_counters();
>> +	update_counter_info(num_counters);
>> +
>> +	/*
>> +	 * Qemu supports overflow for cycle/instruction.
>> +	 * This test may fail on any platform that do not support overflow for these two events.
>> +	 */
>> +	test_pmu_event_overflow(SBI_PMU_HW_CPU_CYCLES);
>> +	GUEST_ASSERT_EQ(vcpu_shared_irq_count, 1);
>> +
>> +	test_pmu_event_overflow(SBI_PMU_HW_INSTRUCTIONS);
>> +	GUEST_ASSERT_EQ(vcpu_shared_irq_count, 2);
>> +
>> +	GUEST_DONE();
>> +}
>> +
>>   static void run_vcpu(struct kvm_vcpu *vcpu)
>>   {
>>   	struct ucall uc;
>> @@ -451,6 +535,33 @@ static void test_vm_events_snapshot_test(void *guest_code)
>>   	test_vm_destroy(vm);
>>   }
>>   
>> +static void test_vm_events_overflow(void *guest_code)
>> +{
>> +	struct kvm_vm *vm = NULL;
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>> +	__TEST_REQUIRE(__vcpu_has_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_PMU),
>> +				   "SBI PMU not available, skipping test");
>> +
>> +	__TEST_REQUIRE(__vcpu_has_isa_ext(vcpu, KVM_RISCV_ISA_EXT_SSCOFPMF),
>> +				   "Sscofpmf is not available, skipping overflow test");
>> +
>> +
> 
> extra blank line here
> 

Fixed.

>> +	test_vm_setup_snapshot_mem(vm, vcpu);
>> +	vm_init_vector_tables(vm);
>> +	vm_install_interrupt_handler(vm, guest_irq_handler);
>> +
>> +	vcpu_init_vector_tables(vcpu);
>> +	/* Initialize guest timer frequency. */
>> +	vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency), &timer_freq);
>> +	sync_global_to_guest(vm, timer_freq);
>> +
>> +	run_vcpu(vcpu);
>> +
>> +	test_vm_destroy(vm);
>> +}
>> +
>>   int main(void)
>>   {
>>   	pr_info("SBI PMU basic test : starting\n");
>> @@ -463,5 +574,8 @@ int main(void)
>>   	test_vm_events_snapshot_test(test_pmu_events_snaphost);
>>   	pr_info("SBI PMU event verification with snapshot test : PASS\n");
>>   
>> +	test_vm_events_overflow(test_pmu_events_overflow);
>> +	pr_info("SBI PMU event verification with overflow test : PASS\n");
>> +
>>   	return 0;
>>   }
>> -- 
>> 2.34.1
>>
> 
> Other than the command line option idea,
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Thanks,
> drew


