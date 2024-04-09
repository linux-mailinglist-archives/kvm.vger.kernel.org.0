Return-Path: <kvm+bounces-13940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1624589CF81
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AE821C2207B
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12015611B;
	Tue,  9 Apr 2024 00:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2Z33vHG9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3C23A6
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 00:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712623044; cv=none; b=UzCamTE4IpzbNw7vitXgGCR2ChXS4dnUXOfHmbaIzvYv+OpZ5gdRCFAaQEF8dvjSAqpMrMOkB9plemB/p+bpAIjmh5SOPQQe71qyaygm4J8k7ESzTy94VzJeEbC2K9MC5UvWwWnDY4kGARppJkonKFcEeWI7Mk3XWpFJJO54VTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712623044; c=relaxed/simple;
	bh=vZmp0bx+mzP0lPzvsYZrDCEbUdzNeE9lYo4IHZ0/+q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPhrFTnn7YhSOE1e6RnEYBOgAzWnQnP1s+y8b8Win3oi+MlJBUMruZm7da7xxcMAflC6EhWrn0PmUQA1l0K2dDclRdZjN4jCoQ9I9UZlOXj0ReRtEoMjt38XnuGsqzUY/kmbKR+vdpcx40pKVby0CPRrpatTiZbP2fMqzj5rL04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2Z33vHG9; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ecff9df447so3832834b3a.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 17:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712623042; x=1713227842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Vx/fAicKDWjQK8Xf/GodtuH9rKioxrSCP+le6IWBVk=;
        b=2Z33vHG9WuIsLbO1ynGaan8UP3Cp/6ntvCRcyDhd5exZZPgXp7yD8uKwha6HC53+sz
         vf2KpFPSSNxYapnIIGear0ReLzoQMUvo8RJo+RY9qDzR0we1PPjWohFvnTuiZHL6fo3a
         ht2q2DFX7RPY4uxbEgA7N4vaenNYJbIeTPdCAz3zS/WfK3fz9EZo4unkVoZCnObT1O2e
         X3CqyDE5AsSM30DUYqtH3hP9lf8Vs+hZRWas8Fo3NjPDtEYZD+AQOeahSKbfH0iLpMQr
         lt0rvbj0AgVqjpjSj7hH0uQUDagR8Qo+8RTujwYku1rM2S3Il0lmQqP32q5j9C6hPBqy
         49kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712623042; x=1713227842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Vx/fAicKDWjQK8Xf/GodtuH9rKioxrSCP+le6IWBVk=;
        b=AbT0V2/5q7XHnuBoeR7QxrWWIeeYtTxpe+EPnOSwdCs9JecFEq6is9lwJjx7fffS65
         JIY/1T5wIa/xnS2ton5+cjY5tRE7FaSDRVIEoQp/mWttqA90CdoQESjnZid2IUy4faUn
         VMNhI63cnT19+mnqKhnBZaTTpMGTfskz0wNmC1YU1KWuy2JQz6VrJpF+EJ2o0eUfJ7c+
         BBoju71JHVdeM1Ubi6vgcviUerQ0b9L7B2DYiU+76zYUHTLB1eqsJQlSoPAdZHOsQqsC
         hwF7N43lqmEAHwKutOJ4J8DvZGM8DpFl7zzYis2stm+qJcvzcN0+VGq5QnfLMH80TBws
         fxSw==
X-Forwarded-Encrypted: i=1; AJvYcCVnVZnupVG4TsRwvWlO5cbSHPBHsoPxHqHdSIw+HI+VsqGhS0TDgglnPwGcKJne7qj22tpe6bOhye0FhX+ceRsWY23w
X-Gm-Message-State: AOJu0YyGap8Du6fDUP+0dhCN2s7Qk05VKprnyjI3syBq5BM3URjZNBDh
	HoCjEGTDZ1BfyV1RZhYlphSO5cNsoRmTD6pTn0klVX4bpMbuQL7fK/oBwsQLf6Y=
X-Google-Smtp-Source: AGHT+IHr0Zo6nHVaV/pKfVqhANW/8W9ESaRusAuX8dauWvgSDh5Rc7uN98R5kCiiSEnkLb0cWYp8TA==
X-Received: by 2002:a05:6a20:7355:b0:1a7:1e1c:3031 with SMTP id v21-20020a056a20735500b001a71e1c3031mr13412563pzc.36.1712623041952;
        Mon, 08 Apr 2024 17:37:21 -0700 (PDT)
Received: from ?IPV6:2601:647:4180:9630::e8c1? ([2601:647:4180:9630::e8c1])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902784700b001dd578121d4sm7786884pln.204.2024.04.08.17.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 17:37:21 -0700 (PDT)
Message-ID: <976411ab-6ddf-4b10-8e13-1575928415ce@rivosinc.com>
Date: Mon, 8 Apr 2024 17:37:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/22] KVM: riscv: selftests: Add SBI PMU selftest
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
 <20240403080452.1007601-21-atishp@rivosinc.com>
 <20240405-d1a4cb9a441a05a9d2f8b1c8@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240405-d1a4cb9a441a05a9d2f8b1c8@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/24 05:50, Andrew Jones wrote:
> On Wed, Apr 03, 2024 at 01:04:49AM -0700, Atish Patra wrote:
> ...
>> +static void test_pmu_basic_sanity(void)
>> +{
>> +	long out_val = 0;
>> +	bool probe;
>> +	struct sbiret ret;
>> +	int num_counters = 0, i;
>> +	union sbi_pmu_ctr_info ctrinfo;
>> +
>> +	probe = guest_sbi_probe_extension(SBI_EXT_PMU, &out_val);
>> +	GUEST_ASSERT(probe && out_val == 1);
>> +
>> +	num_counters = get_num_counters();
>> +
>> +	for (i = 0; i < num_counters; i++) {
>> +		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i,
>> +				0, 0, 0, 0, 0);
>> +
>> +		/* There can be gaps in logical counter indicies*/
>> +		if (ret.error)
>> +			continue;
>> +		GUEST_ASSERT_NE(ret.value, 0);
>> +
>> +		ctrinfo.value = ret.value;
>> +
>> +		/**
>> +		 * Accesibillity check of hardware and read capability of firmware counters.
> 
> Accessibility
> 

Fixed it.

>> +		 * The spec doesn't mandate any initial value. No need to check any value.
>> +		 */
>> +		read_counter(i, ctrinfo);
>> +	}
>> +
>> +	GUEST_DONE();
>> +}
>> +
>> +static void run_vcpu(struct kvm_vcpu *vcpu)
>> +{
>> +	struct ucall uc;
>> +
>> +	vcpu_run(vcpu);
>> +	switch (get_ucall(vcpu, &uc)) {
>> +	case UCALL_ABORT:
>> +		REPORT_GUEST_ASSERT(uc);
>> +		break;
>> +	case UCALL_DONE:
>> +	case UCALL_SYNC:
>> +		break;
>> +	default:
>> +		TEST_FAIL("Unknown ucall %lu", uc.cmd);
>> +		break;
>> +	}
>> +}
>> +
>> +void test_vm_destroy(struct kvm_vm *vm)
>> +{
>> +	memset(ctrinfo_arr, 0, sizeof(union sbi_pmu_ctr_info) * RISCV_MAX_PMU_COUNTERS);
>> +	counter_mask_available = 0;
>> +	kvm_vm_free(vm);
>> +}
>> +
>> +static void test_vm_basic_test(void *guest_code)
>> +{
>> +	struct kvm_vm *vm;
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>> +	__TEST_REQUIRE(__vcpu_has_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_PMU),
>> +				   "SBI PMU not available, skipping test");
>> +	vm_init_vector_tables(vm);
>> +	/* Illegal instruction handler is required to verify read access without configuration */
>> +	vm_install_exception_handler(vm, EXC_INST_ILLEGAL, guest_illegal_exception_handler);
> 
> I still don't see where the "verify" part is. The handler doesn't record
> that it had to handle anything.
> 

The objective of the test is to ensure that we get an illegal 
instruction without configuration. The presence of the registered 
exception handler is sufficient for that.

The verify part is that the test doesn't end up in a illegal instruction 
exception when you try to access a counter without configuring.

Let me know if you think we should more verbose comment to explain the 
scenario.


>> +
>> +	vcpu_init_vector_tables(vcpu);
>> +	run_vcpu(vcpu);
>> +
>> +	test_vm_destroy(vm);
>> +}
>> +
>> +static void test_vm_events_test(void *guest_code)
>> +{
>> +	struct kvm_vm *vm = NULL;
>> +	struct kvm_vcpu *vcpu = NULL;
>> +
>> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>> +	__TEST_REQUIRE(__vcpu_has_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_PMU),
>> +				   "SBI PMU not available, skipping test");
>> +	run_vcpu(vcpu);
>> +
>> +	test_vm_destroy(vm);
>> +}
>> +
>> +int main(void)
>> +{
>> +	test_vm_basic_test(test_pmu_basic_sanity);
>> +	pr_info("SBI PMU basic test : PASS\n");
>> +
>> +	test_vm_events_test(test_pmu_events);
>> +	pr_info("SBI PMU event verification test : PASS\n");
>> +
>> +	return 0;
>> +}
>> -- 
>> 2.34.1
>>
> 
> Thanks,
> drew


