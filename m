Return-Path: <kvm+bounces-3969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2404E80AE78
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A770DB20BFA
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCABB5731B;
	Fri,  8 Dec 2023 21:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDW+iUMV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10C8BD
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 13:01:32 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5ddd64f83a4so24909047b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702069292; x=1702674092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cPvsp4vtrotIomPKqq2ImuA44XLC/C4iYoGwJqvn3h8=;
        b=UDW+iUMVMguW/5APKTGnpwqQEGXA9rMUhhODvl6ZNvdIXpV/NOv2sUDlaXMKbX6eGU
         7dYqiKfqlQn63lMGHIw7/a/tg/qcCE7NDLsn2Y4RhXKb2FwrCJH9estbG7Akxe4qnR74
         BVA8i0yuZ8pVdadPTx4oCdD2Lhe8TWhw/+72ysG/rcSIvJC9cdTqHhxh52DDfH6rIWCI
         +QTztE/xpFZPROxbwD2OvbEK08/ZalKqB1LPa4hMmcWNABrqKkY/bOxuLsgdIaQN8Xts
         ZQdmsIcD0CXFLuazhTa8P51TeSY9x9bjLYQ4IUp8n17Z2MXUFqGUcEGf9XFOkqCcI+NA
         PU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702069292; x=1702674092;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPvsp4vtrotIomPKqq2ImuA44XLC/C4iYoGwJqvn3h8=;
        b=Iccq76kre8HJreo5zilWqcqwIZPiwX2d7V0onZ6WqHcr4i+kuoEAvYpLORO1rZi2hD
         EgXaq0I1p2mV6JLXkxuSE2MqYIM+KQww4OdQPLC0R56yzIV7Ffg8xSXfbCxzSSnL1FLL
         hnN8Le/RXsu3Rw26wRuJAvRI9HBg1BPVCsSZ1oxZWAzX6Ot4V8CuljmdCGAAZ221a95H
         p+fVIzjJmNJrCHU2jEgVnDh7LdhhU2sXNFkLM2uHOPQXeeH5uq0bycEc+cqwDTmwk8bj
         tKxz6ATdf817PBfJYkpqaCAvV3qeoRbjcbDquSlF9pDJjwNLJa75uK7eHDkSusqlAu1C
         235Q==
X-Gm-Message-State: AOJu0YyQWPTi1Av+PLrUAFYTPSFNU2yIrjsP4FPVRqBmAkUUSnPnDFj7
	bhhjEAhIv4XqWjDzBsTdrqhcOXL4YVkT6aGTXw==
X-Google-Smtp-Source: AGHT+IE2+v2iURbPda/UkDDifecJeozbvSa31F1K3eqBpsYJtjPo/blaA3H9UAXge83pUxWRcqNIFPEBrorUs01B8g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:b94e:0:b0:db4:4df:8c0d with SMTP
 id s14-20020a25b94e000000b00db404df8c0dmr4660ybm.11.1702069291893; Fri, 08
 Dec 2023 13:01:31 -0800 (PST)
Date: Fri, 08 Dec 2023 21:01:30 +0000
In-Reply-To: <ZV4924juGGCk2cjf@linux.dev> (message from Oliver Upton on Wed,
 22 Nov 2023 17:43:55 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt7clov26t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 1/3] KVM: arm64: selftests: Standardize GIC base addresses
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Nov 03, 2023 at 07:29:13PM +0000, Colton Lewis wrote:
>> Use default values during GIC initialization and setup to avoid
>> multiple tests needing to decide and declare base addresses for GICD
>> and GICR. Remove the repeated definitions of these addresses across
>> tests.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> <snip>

>> -void gic_init(enum gic_type type, unsigned int nr_cpus,
>> +void _gic_init(enum gic_type type, unsigned int nr_cpus,
>>   		void *dist_base, void *redist_base)
>>   {
>>   	uint32_t cpu = guest_get_vcpuid();
>> @@ -63,6 +63,11 @@ void gic_init(enum gic_type type, unsigned int  
>> nr_cpus,
>>   	gic_cpu_init(cpu, redist_base);
>>   }

>> +void gic_init(enum gic_type type, unsigned int nr_cpus)
>> +{
>> +	_gic_init(type, nr_cpus, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
>> +}
>> +

> </snip>

>> -int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t  
>> nr_irqs,
>> +int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t  
>> nr_irqs,
>>   		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
>>   {
>>   	int gic_fd;
>> @@ -79,6 +79,11 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int  
>> nr_vcpus, uint32_t nr_irqs,
>>   	return gic_fd;
>>   }

>> +int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t  
>> nr_irqs)
>> +{
>> +	return _vgic_v3_setup(vm, nr_vcpus, nr_irqs, GICD_BASE_GPA,  
>> GICR_BASE_GPA);
>> +}
>> +

> What's the point of having the internal implementations of these
> functions that still take addresses? If we're standardizing GIC
> placement then there's no need for allowing the caller to provide
> different addresses.

I wasn't sure if there might be a reason for that allowance I was
unaware of since that's what the original interface was so I erred on
the side of flexibility. I'll delete it.

