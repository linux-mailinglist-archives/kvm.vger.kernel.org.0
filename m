Return-Path: <kvm+bounces-61291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 354DAC14449
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 12:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0AA0850249E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 11:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85D529CB3C;
	Tue, 28 Oct 2025 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FWNvgPli"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181F25487C
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 11:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761649262; cv=none; b=RJ3mLZMCuCQYeza7ofXANi9a7csaaGEnbWGOGjHw1VDJ6rU2vOXRmZKC2HA9UzVlGkj34HDik2eguVRml2TI1BI6EFNAovSwaED2O7MFUYR4dHHwjK4ZuEyUBcAacEqEvaGRDuv6aYku8QsHsBCBlAKKOtZl9H4ZEFdVL+n1hKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761649262; c=relaxed/simple;
	bh=TBcCwBBiRefOxaueoN9Psch/bKtJhqoQamxX5KSEkKc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cUxIwVakgtQPYB2FtSciDvnQQoFvjgzj7h3I/oHTWJ2JQuU2eg7EkWefHDA9HXRDwzfbWGe0lwSNggp4D6eU5jXVHf2b/Xu4d4rVb80luCotutVzZta9KncfNRzsN9DBeMBzkQ6KfJTshALUWQPbD+lUpBHgxM/O9TD0hHPGQzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FWNvgPli; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761649258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nxmOHwHxmZMLpzf1uqdrSlEJ/+f2PvodAb00eauIdqA=;
	b=FWNvgPliNF8hT2bz4EErciy+Ut2e2xSlNLwvwvA7/vgkkn05ahfUD6+YwcJpwz+egHxB8A
	MOoQQAEQ2U6PJnJH+jourZsxy0cft8K1atjR1ZHJiM5ZhncPSBAXsrS/UGMQU6IFlxDf1P
	1cdP/sIkWGt0NUU9x/01Ws6Di+KXnkM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-gEfz0QNJNcWZLhKKDAssBg-1; Tue, 28 Oct 2025 07:00:57 -0400
X-MC-Unique: gEfz0QNJNcWZLhKKDAssBg-1
X-Mimecast-MFC-AGG-ID: gEfz0QNJNcWZLhKKDAssBg_1761649256
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-475dd9906e1so16767085e9.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 04:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761649256; x=1762254056;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxmOHwHxmZMLpzf1uqdrSlEJ/+f2PvodAb00eauIdqA=;
        b=BUNZr02AEtp2LF0U/5HtylWPIVuq5I6r11x+DRVxsTV4aMqM2ou1DOpkqjRLd+pqpC
         X7yeJgyaacYFHOh6tIBuoEIIAYlkuJYvwaQ7SgqlXkX2WcBku/PaWroo9rjPJU6BX73Q
         +ay7z5bVn9THLxSMfODNf+CorHrJ6j7/bdLCuiW9vCawawvCrpfG6AhgN03E41GTDwrL
         q4j44ExkJXkk266w917MyMRmkXPaJSc9mLLJWXdrGwCAR0O9yJOCpIFPQwm5j2T80IPQ
         roauwHyhQNq00xvpjwVRCx0kQxuS9KLQEw+7mjaYvANuCNolPFoWU2cVbmx8PVOOxQe9
         fjPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXHNdMD+8btLqWO2MbnWGn/Gji+iim3pVspYCK7qFJY4NVCLExKE7t3gzDTftMQt3sBq4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyddUsSQ9N4QcNTYp3L2ePaztRFfLvFsQ6hVEsgArIYNAFHk2+
	4FE5OVw+stWVHuHx3d4zxngfJGDWseqVL9QN8DxmmZk7UEC13k0BeH9W5XAY79wu1fxvl3+hbHT
	jFJVcOyZrpbmgNDyhPlwuJRWpqayQ/yRSyVNnpH8wS8x2sxVYnEbSTXv/nnDgug==
X-Gm-Gg: ASbGncs1TroYRQiVTYz8p0Bpab31Shb3IMvNK1yJ9gqOsWMP/6qakRJfTQFXPJKGtsf
	j7sI7Sbw267pwLlkdzAuZKV6Zk0IebzYh9aqSL5b01isMlJRe6qPHeZF/Rz6nWjZUV0Swr77n2S
	ebzuI97RRAntL8fIrNkBm0Uscj09KUqAjDCc80JDnVZfiVPKwdNUSGavLD/X576/30UrJ+4m2Wp
	ucV/J8gI0aU9Sco9ch8PYoLP9FKBTJHXnEwl5HKQVmgb4pA8f6ZB10AwGNmNfGDVXpMD7YQbaD8
	cO/iQfial2dZK1LAk0w1mccPOMT90f/wURrV0lKZafqjucw4Jc/pDF2wzu+bt/PjPBLQ7S64s6c
	t6xlEjwCB08XiJFB5g7qzBBB3XFEFPmtWXj+gR7zUv0tRyb6W
X-Received: by 2002:a05:600c:3493:b0:46f:b42e:edce with SMTP id 5b1f17b1804b1-47717e67cd3mr23267015e9.39.1761649255553;
        Tue, 28 Oct 2025 04:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFVAEQZBrj6XxR1esAB3vvNknSrAGxc5wuX0loLWB2sKQiYoi+ajmuIkxNcYXcTJ8iSZx7ug==
X-Received: by 2002:a05:600c:3493:b0:46f:b42e:edce with SMTP id 5b1f17b1804b1-47717e67cd3mr23266575e9.39.1761649255026;
        Tue, 28 Oct 2025 04:00:55 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd48942dsm192647185e9.4.2025.10.28.04.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 04:00:54 -0700 (PDT)
Date: Tue, 28 Oct 2025 12:00:53 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Message-ID: <ba03c952-e567-eb2b-f4c8-b1818ee127d6@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <20250911144923.24259-3-sebott@redhat.com> <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 27 Oct 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst |  5 +++
>>  target/arm/cpu.h                 |  6 +++
>>  target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
>>  3 files changed, 80 insertions(+), 1 deletion(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index 37d5dfd15b..1d32ce0fee 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>>    the guest scheduler behavior and/or be exposed to the guest
>>    userspace.
>>
>> +``kvm-psci-version``
>> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
>> +  PSCI version emulated by the kernel. Current valid values are:
>> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>> +
>>  TCG VCPU Features
>>  =================
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index c15d79a106..44292aab32 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -974,6 +974,12 @@ struct ArchCPU {
>>       */
>>      uint32_t psci_version;
>>
>> +    /*
>> +     * Intermediate value used during property parsing.
>> +     * Once finalized, the value should be read from psci_version.
>> +     */
>> +    uint32_t prop_psci_version;
>> +
>>      /* Current power state, access guarded by BQL */
>>      ARMPSCIState power_state;
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 6672344855..bc6073f395 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>>  }
>>
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const char *val;
>> +
>> +    switch (cpu->prop_psci_version) {
>> +    case QEMU_PSCI_VERSION_0_1:
>> +        val = "0.1";
>> +        break;
>> +    case QEMU_PSCI_VERSION_0_2:
>> +        val = "0.2";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_0:
>> +        val = "1.0";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_1:
>> +        val = "1.1";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_2:
>> +        val = "1.2";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_3:
>> +        val = "1.3";
>> +        break;
>> +    default:
>> +        val = "0.2";
>> +        break;
>> +    }
>> +    return g_strdup(val);
>> +}
>> +
>> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    if (!strcmp(value, "0.1")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
>> +    } else if (!strcmp(value, "0.2")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
>> +    } else if (!strcmp(value, "1.0")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
>> +    } else if (!strcmp(value, "1.1")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
>> +    } else if (!strcmp(value, "1.2")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
>> +    } else if (!strcmp(value, "1.3")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;
>
> We already have six values here and it's not implausible
> we might end up with more in future; maybe we should make the
> mapping between string and constant data-driven rather
> than having code written out longhand in the get and set
> functions?

Yes, sure. I'll send out a V2.

Thanks!
Sebastian


