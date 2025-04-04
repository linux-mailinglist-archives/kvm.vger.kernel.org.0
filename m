Return-Path: <kvm+bounces-42630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA415A7BA91
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E51F189BB9C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040061B0439;
	Fri,  4 Apr 2025 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnFiT1sw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90470186295
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743761953; cv=none; b=DnHfVj+4F/L3wXWb/XQbaj0fabUgW+dMQC5iz3WU9SDkoLR0Cyg1T3/tIPGL6i2GnMGgRjvXiV8dTUikAwpifqL4Qv4prdA8brlUAthRrfEy5S2Vft6iEORackGg3ZAiL9Zy2nV9sgW/4PNTUzwU6RFVL79xR2cUESJK18tMtVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743761953; c=relaxed/simple;
	bh=DjanWa9dOaDgsh8G7LbaIX5NtQ8DUhKP5nXFfr/Smmo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AF7PFgAllHLnZFiDyYUKled39qyjazG7hfOGaNnbdqdkqH3xGvEgScsdY8CaVm54/EgrjRa6fQZqAIcLKiTg1y2P38rPeMdi5lWUCfGBoayBXKLkTMGR+TY68HVLQUowDYtGlFMYBAKaiXpvdvMTl/xlBn7D55gFheU8GHNurqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnFiT1sw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743761950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1h31gPbZBLLsuTR5n1snPscX7w6OFOorG4D3qCNodmc=;
	b=GnFiT1swGNdsy6eXHHDKCSBAGR0MbB9Os4LhlzSt3y2/wpkdm5qjA5Sz85Get/grTm5mOi
	TE0FPZgUgmPPhCd+SHC7utnwQRz4sbVoXF2/regsheFemq3yNSsQsUisajRXt/Eldq7rJz
	+LpGz999eHQsS1XlWoppVceUaAo1+lU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-wYKMRPgTNHOPar3pdD1uyQ-1; Fri, 04 Apr 2025 06:19:09 -0400
X-MC-Unique: wYKMRPgTNHOPar3pdD1uyQ-1
X-Mimecast-MFC-AGG-ID: wYKMRPgTNHOPar3pdD1uyQ_1743761948
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e82390b87fso1686100a12.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743761948; x=1744366748;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1h31gPbZBLLsuTR5n1snPscX7w6OFOorG4D3qCNodmc=;
        b=O/ebUgokImf98dUx05oHmyKDyHBHMK3+4mQxGzntt5bL5skDVKzem45bC1SjAU5HGA
         NTf4fi/EgCSBIQjjajMosi5j01awMx+yTxWZcP7DczwSGHo3xwGtGQnHZklste0ZoVYl
         NS/q95M3kt3E9tJy923/wyvqweuYKm97oyli2cBxx/p5Lo2TX1plbdhRFuVurh83ON36
         16jsGV3up1CPhH4MUF9ZyHNP2y6FJAo6n+f7cUV198BzVi6KOs901BLiZic3UMNYLKNq
         c1El0nb1ROsnAXJswA5I8yu1Xm+rW+Osh5pT6Xs9zZdhoaGpEklRgbltm3G/rF2wAe2V
         kbIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7MDlQpDgKN9I8jXux0a1rkiWDQukAas9qlr+mDNVsD1X9ywoORHjukmDN+fGHxlfx3XM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFyJNtaPd9xazA9ydGjDW+FGH5qFyGYksTbR1WmR647YItO7bQ
	3GaWRMlNVMrrGL4HBkIvfYMq0EOHMuePELHb//MZhlaXUc/j2WerFQFqFiiuzTIxC0UJ7g5j3Um
	8u2V1vcHGsg9lDJinF0t3M+GwC0RWGgsjEzxCmENPHNjHhtY7Cw==
X-Gm-Gg: ASbGncsUHnCi11j7e1Eg+UCTXE+w2t7gVaLyzY8K4WxoptxMw5N31OoQmHSlKBduqhU
	Ql3DLNAKG+43nnTk9Nd8PXo9eHgJftxCrUZbCjz1skUgR4CqnkRCgwPNZsGzkmn7UzuBY5B4g9u
	bLE8xZ6qTFqSrsuyVDcBfrC+OdCBV65qZDi1fY62ZupkeKgFpOVxeUJKFvOGul0J0BSjNBr/Db4
	kmKbf+ZdCAUslrOTFv/ZzlnxT1dm/+a3Hxi7qpGoGtoKnp98Xb/bm3srZXix09SAiptV3aJiQLO
	lxifMEttZwYtYcGXoAn4
X-Received: by 2002:a17:907:7290:b0:ac7:81b5:7724 with SMTP id a640c23a62f3a-ac7d1776fdfmr271651166b.19.1743761948042;
        Fri, 04 Apr 2025 03:19:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrTRWP+6K5kxfZ4+YFYFIue1ZMYy6QaIsh1VgjubCYm9AMB6wPqUXbqRLuGZE+MJfrmIwlZQ==
X-Received: by 2002:a17:907:7290:b0:ac7:81b5:7724 with SMTP id a640c23a62f3a-ac7d1776fdfmr271650066b.19.1743761947643;
        Fri, 04 Apr 2025 03:19:07 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.230.224])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac7bfe9be51sm232805666b.50.2025.04.04.03.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 03:19:06 -0700 (PDT)
Message-ID: <c8573ad2-2865-4e67-afd2-3c4d272ac548@redhat.com>
Date: Fri, 4 Apr 2025 12:19:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: kvm: revamp MONITOR/MWAIT tests
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: seanjc@google.com
References: <20250320165224.144373-1-pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250320165224.144373-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 17:52, Paolo Bonzini wrote:
> Run each testcase in a separate VMs to cover more possibilities;
> move WRMSR close to MONITOR/MWAIT to test updating CPUID bits
> while in the VM.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Queued now.

Paolo

> ---
>   .../selftests/kvm/x86/monitor_mwait_test.c    | 108 +++++++++---------
>   1 file changed, 57 insertions(+), 51 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
> index 2b550eff35f1..390ae2d87493 100644
> --- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
> +++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
> @@ -7,6 +7,7 @@
>   
>   #include "kvm_util.h"
>   #include "processor.h"
> +#include "kselftest.h"
>   
>   #define CPUID_MWAIT (1u << 3)
>   
> @@ -14,6 +15,8 @@ enum monitor_mwait_testcases {
>   	MWAIT_QUIRK_DISABLED = BIT(0),
>   	MISC_ENABLES_QUIRK_DISABLED = BIT(1),
>   	MWAIT_DISABLED = BIT(2),
> +	CPUID_DISABLED = BIT(3),
> +	TEST_MAX = CPUID_DISABLED * 2 - 1,
>   };
>   
>   /*
> @@ -35,11 +38,19 @@ do {									\
>   			       testcase, vector);			\
>   } while (0)
>   
> -static void guest_monitor_wait(int testcase)
> +static void guest_monitor_wait(void *arg)
>   {
> +	int testcase = (int) (long) arg;
>   	u8 vector;
>   
> -	GUEST_SYNC(testcase);
> +	u64 val = rdmsr(MSR_IA32_MISC_ENABLE) & ~MSR_IA32_MISC_ENABLE_MWAIT;
> +	if (!(testcase & MWAIT_DISABLED))
> +		val |= MSR_IA32_MISC_ENABLE_MWAIT;
> +	wrmsr(MSR_IA32_MISC_ENABLE, val);
> +
> +	__GUEST_ASSERT(this_cpu_has(X86_FEATURE_MWAIT) == !(testcase & MWAIT_DISABLED),
> +		       "Expected CPUID.MWAIT %s\n",
> +		       (testcase & MWAIT_DISABLED) ? "cleared" : "set");
>   
>   	/*
>   	 * Arbitrarily MONITOR this function, SVM performs fault checks before
> @@ -50,19 +61,6 @@ static void guest_monitor_wait(int testcase)
>   
>   	vector = kvm_asm_safe("mwait", "a"(guest_monitor_wait), "c"(0), "d"(0));
>   	GUEST_ASSERT_MONITOR_MWAIT("MWAIT", testcase, vector);
> -}
> -
> -static void guest_code(void)
> -{
> -	guest_monitor_wait(MWAIT_DISABLED);
> -
> -	guest_monitor_wait(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
> -
> -	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
> -	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED);
> -
> -	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
> -	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
>   
>   	GUEST_DONE();
>   }
> @@ -74,56 +72,64 @@ int main(int argc, char *argv[])
>   	struct kvm_vm *vm;
>   	struct ucall uc;
>   	int testcase;
> +	char test[80];
>   
> -	TEST_REQUIRE(this_cpu_has(X86_FEATURE_MWAIT));
>   	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
>   
> -	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> -	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
> +	ksft_print_header();
> +	ksft_set_plan(12);
> +	for (testcase = 0; testcase <= TEST_MAX; testcase++) {
> +		vm = vm_create_with_one_vcpu(&vcpu, guest_monitor_wait);
> +		vcpu_args_set(vcpu, 1, (void *)(long)testcase);
> +
> +		disabled_quirks = 0;
> +		if (testcase & MWAIT_QUIRK_DISABLED) {
> +			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS;
> +			strcpy(test, "MWAIT can fault");
> +		} else {
> +			strcpy(test, "MWAIT never faults");
> +		}
> +		if (testcase & MISC_ENABLES_QUIRK_DISABLED) {
> +			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
> +			strcat(test, ", MISC_ENABLE updates CPUID");
> +		} else {
> +			strcat(test, ", no CPUID updates");
> +		}
> +
> +		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
> +
> +		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED) &&
> +		    (!!(testcase & CPUID_DISABLED) ^ !!(testcase & MWAIT_DISABLED)))
> +			continue;
> +
> +		if (testcase & CPUID_DISABLED) {
> +			strcat(test, ", CPUID clear");
> +			vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
> +		} else {
> +			strcat(test, ", CPUID set");
> +			vcpu_set_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
> +		}
> +
> +		if (testcase & MWAIT_DISABLED)
> +			strcat(test, ", MWAIT disabled");
>   
> -	while (1) {
>   		vcpu_run(vcpu);
>   		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
>   
>   		switch (get_ucall(vcpu, &uc)) {
> -		case UCALL_SYNC:
> -			testcase = uc.args[1];
> -			break;
>   		case UCALL_ABORT:
> -			REPORT_GUEST_ASSERT(uc);
> -			goto done;
> +			/* Detected in vcpu_run */
> +			break;
>   		case UCALL_DONE:
> -			goto done;
> +			ksft_test_result_pass("%s\n", test);
> +			break;
>   		default:
>   			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> -			goto done;
> +			break;
>   		}
> -
> -		disabled_quirks = 0;
> -		if (testcase & MWAIT_QUIRK_DISABLED)
> -			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS;
> -		if (testcase & MISC_ENABLES_QUIRK_DISABLED)
> -			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
> -		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
> -
> -		/*
> -		 * If the MISC_ENABLES quirk (KVM neglects to update CPUID to
> -		 * enable/disable MWAIT) is disabled, toggle the ENABLE_MWAIT
> -		 * bit in MISC_ENABLES accordingly.  If the quirk is enabled,
> -		 * the only valid configuration is MWAIT disabled, as CPUID
> -		 * can't be manually changed after running the vCPU.
> -		 */
> -		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED)) {
> -			TEST_ASSERT(testcase & MWAIT_DISABLED,
> -				    "Can't toggle CPUID features after running vCPU");
> -			continue;
> -		}
> -
> -		vcpu_set_msr(vcpu, MSR_IA32_MISC_ENABLE,
> -			     (testcase & MWAIT_DISABLED) ? 0 : MSR_IA32_MISC_ENABLE_MWAIT);
> +		kvm_vm_free(vm);
>   	}
> +	ksft_finished();
>   
> -done:
> -	kvm_vm_free(vm);
>   	return 0;
>   }


