Return-Path: <kvm+bounces-25302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 939099634EA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 009B6B259F4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 22:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABDD1AE021;
	Wed, 28 Aug 2024 22:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RinDndi0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4B166F01
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724884777; cv=none; b=N1wwMY1PKVkcZoje4SzJMXT3Y/iDIMKd7yIf7RQhIN9JDFTAuj2cqN5GQejak3dExn4risi22fmYQFcx6CPca/PQhj1uknUVLcyN0Pxw8Chc3v6CTOjN/Z9FBEtQEcl0oMFj/fML0Q7RaL/+EmV68Lv4btzEJIXyEki+AqHln/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724884777; c=relaxed/simple;
	bh=9uwtz3kcfa067V39AoKxu0Wu3ZsHQ6CrZUBA48vVY6M=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=D0L+vfnHxI9Rz4hkcoBfFeqo43Q7B5O8jd1NTMhG59v8u35k/AouwcN3a95Zib8W8EVuVS4Kl9+eMwzqs5/46c8K9g6VayNaUbYQfZEmavg02EvFLD+XCiVfaqGjh38YAwpDL7L/ZXLUP6OXJrJm2rnGFbKHm3mUHN47hpFTM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RinDndi0; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-81f8489097eso7015939f.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 15:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724884775; x=1725489575; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OAsnME+1ttvFS+7fzgI3/tOYVOypFVKT5MTMnTtwz3M=;
        b=RinDndi0vtvECBi9o19azRqiBWBOGRKAj3+XMWE+vJ7sqJDNw4xy0dYnYgq+ghoQI5
         t3x1hdsYWscI/8fGXi91sg2o0nOVqBG8/5GY3FfmyeFdKNZjwp7azbZMU60F2tla9WDO
         +N74sXCVS+tmBj3NBOnDtg0j+bKAW1IZaZGnfAUZOTrq0eNZC3ubut/AnXcimquRLMRD
         n2ryNPwU0+b3hP4QQ6ZI69FP4HosOTQCwH/N36cM2I/0F0eJY60rKdWWZm+qfBidf1tf
         Lfq8u3wIISJ1kqfgRd+mhu06cM3/bKr7P43vaJkP4pIve7NvWSgo1DsHfx3Kp83TuDDV
         tbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724884775; x=1725489575;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAsnME+1ttvFS+7fzgI3/tOYVOypFVKT5MTMnTtwz3M=;
        b=HqN8vYTcAN2se7LSAy4gpbuCm7Ppd4a43wjYNbc4ZXEsKb6vWdvi2hDP/umHTAoFP6
         EQ/V2SK2BfOadtjOkvMvq+Z0X4YD+I5PFVETlO24FaHM4ZeVXJLbEuVJM1dCR6tNeuko
         XAAOqa1bYxGLgc8SosuoWtsSrSy6SlZuk3KQlLbcITwhLjD3cfZktuORkf8RFSftZ+WG
         iGCWeLHqt6HnFY2eFFeySaQDE5Z0XXTXIJxmNphl+VLxmQWXPX24yy27OXRXDB51+Got
         6SxJzYE+GepGC41tkqLuyzzD6vwdMfWAxmzP342YBW/AQeEbdjdPHc7nYIIvgtQTFPMC
         K38w==
X-Gm-Message-State: AOJu0YxvNprM2PNQ/aBtd81tNGjBt8AoMGeNx5UEkt3iPmnDVzUruyqD
	893G6LFSwxKSww3mJgw4D0UYFHYnKzaSHwXW8BepwWFYfwQC/RhPLLbf7S9SMukFLbP4TGdQVhh
	iKvSNaeca/SeskNuletzxMw==
X-Google-Smtp-Source: AGHT+IEtsGwfm3FYZRqeDe5owwNzQffvuPu3yibSqfSWXPq2y5mmZ/3/gKcqfVyxJMmNWrvr1iyAEbqEbQ0pnYUIeg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:4119:b0:4b7:c9b5:6765 with
 SMTP id 8926c6da1cb9f-4ced00565f8mr31295173.5.1724884775117; Wed, 28 Aug 2024
 15:39:35 -0700 (PDT)
Date: Wed, 28 Aug 2024 22:39:34 +0000
In-Reply-To: <Zs0FLglChWqsGa6w@google.com> (message from Mingwei Zhang on Mon,
 26 Aug 2024 22:43:58 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnth6b49srd.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 3/6] KVM: x86: selftests: Set up AMD VM in pmu_counters_test
From: Colton Lewis <coltonlewis@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org, ljr.kernel@gmail.com, jmattson@google.com, 
	aaronlewis@google.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Mingwei

Mingwei Zhang <mizhang@google.com> writes:

> On Tue, Aug 13, 2024, Colton Lewis wrote:
>> Branch in main() depending on if the CPU is Intel or AMD. They are
>> subject to vastly different requirements because the AMD PMU lacks
>> many properties defined by the Intel PMU including the entire CPUID
>> 0xa function where Intel stores all the PMU properties. AMD lacks this
>> as well as any consistent notion of PMU versions as Intel does. Every
>> feature is a separate flag and they aren't the same features as Intel.

>> Set up a VM for testing core AMD counters and ensure proper CPUID
>> features are set.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 80 ++++++++++++++++---
>>   1 file changed, 68 insertions(+), 12 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c  
>> b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> index 0e305e43a93b..a11df073331a 100644
>> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>> @@ -33,7 +33,7 @@
>>   static uint8_t kvm_pmu_version;
>>   static bool kvm_has_perf_caps;

>> -static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu  
>> **vcpu,
>> +static struct kvm_vm *intel_pmu_vm_create(struct kvm_vcpu **vcpu,
>>   						  void *guest_code,
>>   						  uint8_t pmu_version,
>>   						  uint64_t perf_capabilities)
>> @@ -303,7 +303,7 @@ static void test_arch_events(uint8_t pmu_version,  
>> uint64_t perf_capabilities,
>>   	if (!pmu_version)
>>   		return;

>> -	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
>> +	vm = intel_pmu_vm_create(&vcpu, guest_test_arch_events,
>>   					 pmu_version, perf_capabilities);

>>   	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
>> @@ -463,7 +463,7 @@ static void test_gp_counters(uint8_t pmu_version,  
>> uint64_t perf_capabilities,
>>   	struct kvm_vcpu *vcpu;
>>   	struct kvm_vm *vm;

>> -	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_gp_counters,
>> +	vm = intel_pmu_vm_create(&vcpu, guest_test_gp_counters,
>>   					 pmu_version, perf_capabilities);

>>   	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
>> @@ -530,7 +530,7 @@ static void test_fixed_counters(uint8_t pmu_version,  
>> uint64_t perf_capabilities,
>>   	struct kvm_vcpu *vcpu;
>>   	struct kvm_vm *vm;

>> -	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
>> +	vm = intel_pmu_vm_create(&vcpu, guest_test_fixed_counters,
>>   					 pmu_version, perf_capabilities);

>>   	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
>> @@ -627,18 +627,74 @@ static void test_intel_counters(void)
>>   	}
>>   }

>> -int main(int argc, char *argv[])
>> +static uint8_t nr_core_counters(void)
>>   {
>> -	TEST_REQUIRE(kvm_is_pmu_enabled());
>> +	const uint8_t nr_counters =  
>> kvm_cpu_property(X86_PROPERTY_NUM_PERF_CTR_CORE);
>> +	const bool core_ext = kvm_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
>> +	/* The default numbers promised if the property is 0 */
>> +	const uint8_t amd_nr_core_ext_counters = 6;
>> +	const uint8_t amd_nr_core_counters = 4;
>> +
>> +	if (nr_counters != 0)
>> +		return nr_counters;
>> +
>> +	if (core_ext)
>> +		return amd_nr_core_ext_counters;
>> +
>> +	return amd_nr_core_counters;
>> +}
>> +
>> +static void guest_test_core_counters(void)
>> +{
>> +	GUEST_DONE();
>> +}

>> -	TEST_REQUIRE(host_cpu_is_intel);
>> -	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
>> -	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
>> +static void test_core_counters(void)
>> +{
>> +	uint8_t nr_counters = nr_core_counters();
>> +	bool core_ext = kvm_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
>> +	bool perf_mon_v2 = kvm_cpu_has(X86_FEATURE_PERF_MON_V2);
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;

>> -	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
>> -	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
>> +	vm = vm_create_with_one_vcpu(&vcpu, guest_test_core_counters);

>> -	test_intel_counters();
>> +	/* This property may not be there in older underlying CPUs,
>> +	 * but it simplifies the test code for it to be set
>> +	 * unconditionally.
>> +	 */
>> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_NUM_PERF_CTR_CORE,  
>> nr_counters);
>> +	if (core_ext)
>> +		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_PERF_CTR_EXT_CORE);
>> +	if (perf_mon_v2)
>> +		vcpu_set_cpuid_feature(vcpu, X86_FEATURE_PERF_MON_V2);

> hmm, I think this might not be enough. So, when the baremetal machine
> supports Perfmon v2, this code is just testing v2. But we should be able
> to test anything below v2, ie., v1, v1 without core_ext. So, three
> cases need to be tested here: v1 with 4 counters; v1 with core_ext (6
> counters); v2.

> If, the machine running this selftest does not support v2 but it does
> support core extension, then we fall back to test v1 with 4 counters and
> v1 with 6 counters.

This should cover all cases the way I wrote it. I detect the number of
counters in nr_core_counters(). That tells me if I am dealing with 4 or
6 and then I set the cpuid property based on that so I can read that
number in later code instead of duplicating the logic.

I could always inline nr_core_counters() to make this more obvious since
it is only called in this function. It was one of the first bits of code
I wrote working on this series and I assumed I would need to call it a
bunch before I decided I could just set the cpuid property after calling
it once.

>> +
>> +	pr_info("Testing core counters: CoreExt = %u, PerfMonV2 = %u,  
>> NumCounters = %u\n",
>> +		core_ext, perf_mon_v2, nr_counters);
>> +	run_vcpu(vcpu);
>> +
>> +	kvm_vm_free(vm);
>> +}
>> +
>> +static void test_amd_counters(void)
>> +{
>> +	test_core_counters();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	TEST_REQUIRE(kvm_is_pmu_enabled());
>> +
>> +	if (host_cpu_is_intel) {
>> +		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
>> +		TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
>> +		kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
>> +		kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
>> +		test_intel_counters();
>> +	} else if (host_cpu_is_amd) {
>> +		/* AMD CPUs don't have the same properties to look at. */
>> +		test_amd_counters();
>> +	}

>>   	return 0;
>>   }
>> --
>> 2.46.0.76.ge559c4bf1a-goog


