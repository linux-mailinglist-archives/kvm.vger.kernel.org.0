Return-Path: <kvm+bounces-51819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B49AFDB24
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 00:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A55A01AA6FDB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5486B25E44D;
	Tue,  8 Jul 2025 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q61I2oqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25CB25A2AB
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752014079; cv=none; b=HSVO2t4wN7TcGIakcOtoHjwNHVy7QBFxGxXzf1DkV8EoRjxRxdhWcYFXpJ1zxr4ePut6k0+VJHRyIjFzZArK0Lz6T6jbZv2usZYdMXcdTDdgh03D8NOaOdZYITggY3FtApxjBwJbHTDZ67aYya45eOJHTmrQfIp908oSGbJvPXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752014079; c=relaxed/simple;
	bh=02xDzJQPlhBq0RU8lcHj/2RG+qyIWz4nKYd1naozQns=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ALyB0HzeF6RqEXlHFd49dpOPi07donrGdC5XAuDEDEZ4xRz/vJKCkJxqXrNRI7lLJ6jrA2CeyoP/+VtMPkc42QhZKN//yKrm6Bd7x9omLz8urn4SmnXUghFjb496Al0+h7+9FEvY7xqpYWOFxF3eux8sVZY+gfTf4Af3iCha8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q61I2oqU; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddba1b53e8so60843445ab.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752014077; x=1752618877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/9FFTs3Hz/7yNjDy98C2EAojjbwb0TEz5q962JZJd0=;
        b=q61I2oqU6t7TlFUuejfBAlRXMpmAZ7Y88nYyFUVvwWgUfS3spZQ2M3X/95is9uC3+z
         LMVKgQMD+NWwSknrYWq3Rb4UkPk/AVRK7pobaKLfJTAd6nsi0fsG/u5BNhNmAbKPv8+V
         z4zz+OjLynPwAnrqvFrbctC2wLfX0R1HhIr8reyxMY6Xouf15IZbHSrGQAIVZGHnyBwh
         VyOnDUis/7wVtVVBA03qPFwrv9jK8ie/ji/brym+HWEu1LcZqz/ZJ1J4CtdPqujSRKO1
         s/CzBthoM+bGlLDFUxJMKHqNfGH11HITo55nDTazdXlhPkJxBAn+iWWriAd/rvl/dSsz
         ZQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752014077; x=1752618877;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/9FFTs3Hz/7yNjDy98C2EAojjbwb0TEz5q962JZJd0=;
        b=HhJETX7HGMnS/hwECIYX4+w64TtADelIo4lQuyOcEVWARUJQHGUm165KZkK/UTpJTU
         2TRGb5Oi5n7HFF/P1P6XJjtmNV/CKkWt7TCeY7ItUm+lh8ayZ4GuJBQVgD5szcBS7PV+
         zN/X12PUoW0lQcfHqgKvL6Wh9y8ml81IYDwVh1S8GRTpSr5tSU3TE/MtF3XuFivxwbWj
         8p46DyRabUFpHmQOc9jHN1+znOzw0PycOJirO88P/R6syEnLgcXr1nyLoHaqBHW4HDEE
         fcufRG9kMvndn/4d5nmCceWssniVzHKwT+pD2jVTDOUltmt7Y/ZhADsrCZ0smxGMk4L6
         3qGQ==
X-Gm-Message-State: AOJu0YxWG4NswTl3P+zSaL8hOo5MaURuFhLguTMkcohc2dExbObZHFZp
	LhJHln7ohkm3znRnE2UXIPtc26WElMNc3dFzVw/CyjSXf7En0uXKcEnPPywS46YyINJnrAdnJSX
	1fM5PLErLKgKNUJi/TOZWG18vXA==
X-Google-Smtp-Source: AGHT+IHW+RfduRT7VliGk050iQEqjU318xPGArkYZW5dZzAyyRBuwQAaT6oV8zuk0wkHYQ4WnuckwA/hmtfDS9hyaw==
X-Received: from ilfg10.prod.google.com ([2002:a05:6e02:198a:b0:3df:30df:d2c4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:339f:b0:3e0:4564:4ef9 with SMTP id e9e14a558f8ab-3e166ffbeb5mr5390855ab.4.1752014077049;
 Tue, 08 Jul 2025 15:34:37 -0700 (PDT)
Date: Tue, 08 Jul 2025 22:34:35 +0000
In-Reply-To: <aGvwLIAN8rhxtA_V@J2N7QTR9R3> (message from Mark Rutland on Mon,
 7 Jul 2025 17:05:00 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt34b61fd0.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 01/22] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Mark Rutland <mark.rutland@arm.com> writes:

> On Thu, Jun 26, 2025 at 08:04:37PM +0000, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

> I agree it's appropriate to mark ID_AA64DFR0_EL1.HPMN0 as an
> UnsignedEnum. It follows the usual ID scheme per ARM DDI 0487 L.a
> section D24.1.3, and zero means not present, so it must be unsigned.

> Likewise, the value renames (UNPREDICTABLE => NI and DEF => IMP) look
> fine to me.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> I have one minor nit below, but either way:

> Acked-by: Mark Rutland <mark.rutland@arm.com>

Thank you Mark

>> ---
>>   arch/arm64/kernel/cpufeature.c | 8 ++++++++
>>   arch/arm64/tools/cpucaps       | 1 +
>>   arch/arm64/tools/sysreg        | 6 +++---
>>   3 files changed, 12 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/kernel/cpufeature.c  
>> b/arch/arm64/kernel/cpufeature.c
>> index b34044e20128..73a7dac4b6f6 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -548,6 +548,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
>>   };

>>   static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
>>   	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>> @@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities  
>> arm64_features[] = {
>>   		.matches = has_cpuid_feature,
>>   		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>>   	},
>> +	{
>> +		.desc = "FEAT_HPMN0",

> Minor nit, but we can drop the "FEAT_" prefix here, for consistency with
> other features (e.g. E0PD, FPMR).

> Mark.

Will do.

>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_HPMN0,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>> +	},
>>   #ifdef CONFIG_ARM64_SME
>>   	{
>>   		.desc = "Scalable Matrix Extension",
>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>> index 10effd4cff6b..5b196ba21629 100644
>> --- a/arch/arm64/tools/cpucaps
>> +++ b/arch/arm64/tools/cpucaps
>> @@ -39,6 +39,7 @@ HAS_GIC_CPUIF_SYSREGS
>>   HAS_GIC_PRIO_MASKING
>>   HAS_GIC_PRIO_RELAXED_SYNC
>>   HAS_HCR_NV1
>> +HAS_HPMN0
>>   HAS_HCX
>>   HAS_LDAPR
>>   HAS_LPA2
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 8a8cf6874298..d29742481754 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -1531,9 +1531,9 @@ EndEnum
>>   EndSysreg

>>   Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
>> -Enum	63:60	HPMN0
>> -	0b0000	UNPREDICTABLE
>> -	0b0001	DEF
>> +UnsignedEnum	63:60	HPMN0
>> +	0b0000	NI
>> +	0b0001	IMP
>>   EndEnum
>>   UnsignedEnum	59:56	ExtTrcBuff
>>   	0b0000	NI
>> --
>> 2.50.0.727.gbf7dc18ff4-goog


