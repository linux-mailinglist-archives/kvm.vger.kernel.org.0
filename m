Return-Path: <kvm+bounces-62902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA28C53BB1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:40:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C9B95541A76
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7992343D79;
	Wed, 12 Nov 2025 17:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5b6uVFW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvWuxy3s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420F340277
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762968055; cv=none; b=kcY5EzOI2eWCpAJFGb5q7AnzcIIT2a3ySYqBNQMI1VP8ElcUqtSCdNkmEO6zZTYrj3v/DLOZebdxy11sfYjxgODAlQ27b94fveglqtSOKf5GowWiom1/fl8hcN9dV8TJuyylO+Cn2565CAEGD1LmbPX6BWYdBybQPbDnPZnUI3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762968055; c=relaxed/simple;
	bh=zJTdw02ZMR3CZwXE3qzjXwrbZ0YYx/7A2oWWe0tCmMU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Kisu16S09hOX/Ij3IEFGgsdZcRy0s+6DxnMOHa+3rKsNNJYWJ0XJxVnRmDaZjS6BcLlyWLHl7X3of7Q/bXfN3gdpi9DRMjjb18+C/8lv9zES3oRmd8QhT2745qN+eX0oE/jnEKFcdBIEjLX2VZUI4bGAgL/xxtvldJT24hECkYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5b6uVFW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XvWuxy3s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762968051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMxVuvAqoApe1n3kwx4U0GfXYBdIm/dWnshoZeslIHg=;
	b=R5b6uVFWQYeR+nk0uOXuWZ1rlIXyAwvAt/L8Ygp6M1wdBQ2bkHugCqmuH+xT14iDghKNt/
	pcYGjxgXQpzu0YM1LlYTtsC7lAKuV2KXJO4/gXgM94wq8F5093g5lORaw3BV7p/kK+J3uW
	BxV8BxQbDCaFiHr/rtLFp8mOfWo4ZvM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-ieBpK47vPbKn5E2k_RR67A-1; Wed, 12 Nov 2025 12:20:50 -0500
X-MC-Unique: ieBpK47vPbKn5E2k_RR67A-1
X-Mimecast-MFC-AGG-ID: ieBpK47vPbKn5E2k_RR67A_1762968049
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475e032d81bso7279885e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762968049; x=1763572849; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yMxVuvAqoApe1n3kwx4U0GfXYBdIm/dWnshoZeslIHg=;
        b=XvWuxy3s1Iw223TRsaB8cZ5H+qRoiZBgDPwMjT6q4MO4VOx5bBfEj1EJWmr70RHA4d
         TKyW1oYnJm3R3hHjYvKYBrGdMZ6ZRMv5BWmedYl0bhuydXVUKGJnYje7thvZTeSeeKYi
         uo3B8zdF481FXr76cCP8SY1lGHad2O0TnqlLuTSg7W6tfLv/bMtsj4BH7TCbpy213ID7
         kZugGBhHrudWfFUF5qnFxgofTUy+Zlht6Vd7saIgU4lYNNnkTmI58kczYL4FrrWIsZpl
         knoJSI174SA+ywOQ9eRT2WhdQ6FycVj47dxHqmdgVaw2QpPreqZoqvg5hycNHDugD3zn
         UE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762968049; x=1763572849;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yMxVuvAqoApe1n3kwx4U0GfXYBdIm/dWnshoZeslIHg=;
        b=aFpdfLt9DkUDX7OrbJHAAjxQrsvCteZCZTFQ5fZi3yenmxasHitIxHR19EMkGUteJk
         hxFw+xD4P4Mw9D/wdTiZNDQi7TXnTcsTyXW2ZGFXIlcGpsjektT+cNmKcsiUqOtHuEEj
         kMcHU2musJlOwBGmRTYicjfbcAAColPp+ObuETLZPNsUbJJXOX72gHqk2QgJKIE5+jcA
         7J71cShf7nsSi3wFLHucwpqjq57SEK1mGlz5tQdXJfYVqf9WYB1Knlv/IZhHa6f7gNa6
         09skSkL2i2KmFSMGZZmevf+vsp/2FDadMR07BNssgiMaVx297mGafE0FC4EcWldRRlGi
         2xhw==
X-Forwarded-Encrypted: i=1; AJvYcCWJHPBu/5VRUF9AkQQUIzkbsJ8s7buhheCN1T9fOZC55dIdcPZcqwtwa3vxy/UaPYAJa54=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1iYyjppZf08y3X8DDE+8m/YNcAan9tCEeYWOGuAIXc1IKj85d
	5ZEOdqA3/HOom727hskOdn0Nj13PQMja71eo0EMF8fy7ST/+x7F6FdQxXfsWNX7p7St2QrQSZtK
	kyATeOsx7C72+C+Y2yu0kYFy+8+QYHXXGYXIIH18Vn/O5cevpT+89BQ==
X-Gm-Gg: ASbGncvJHUD47U/CVZmbchvbK16wWlZw/QkS1qrqyk7oDMpNJ8IJDQ3xb8VXx/gBTAL
	JDWrPI1So9wu1sz6cqkS+6AQIJSZpVFNiHEN03BDmArLLHHNU9kdzeWprSHt/BuaoVv+0jy3Vt4
	5KO5neDRU71k3meS4g5F6AwYk0/ZJrF1rAET4te8FNQVzyzC/MieLbkeBiEx5zyaY5rdpFAgCZo
	7X+mP1TaQjY9PM5d/EjlI3RQqGpU3jKflGZfRUR2NfgTiAyVQA7yDflD0jGuxhKudj/aNzmvEC1
	vqBR9wAnL1HlXogTJVSqpjQWCPDq9J12mwH8mC6LV+3F8Pu4En6/nyhXuixUD00ZQufz7e16xCq
	dUHZeltgGjhdLuzLhQAt/SbbvTJJNduw2tfvEk840gyR0Df5l
X-Received: by 2002:a05:600c:6305:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-477870a99d9mr38482855e9.31.1762968049289;
        Wed, 12 Nov 2025 09:20:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEegzjrPUmLH9up7bKJ2Gnf4SouhSesuQw86AewfqbDWeqLNOhar2BDeK/AVLyrimDmRdJciA==
X-Received: by 2002:a05:600c:6305:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-477870a99d9mr38482625e9.31.1762968048885;
        Wed, 12 Nov 2025 09:20:48 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e3a656sm46533675e9.2.2025.11.12.09.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 09:20:48 -0800 (PST)
Date: Wed, 12 Nov 2025 18:20:47 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Message-ID: <cff8ff25-f4a6-6b90-8b90-10b8da7972ac@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com> <20251030165905.73295-3-sebott@redhat.com> <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 11 Nov 2025, Eric Auger wrote:
> On 10/30/25 5:59 PM, Sebastian Ott wrote:
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
[...]
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const struct psci_version *ver;
>> +
>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>> +        if (ver->number == cpu->prop_psci_version)
> I still have the same question/comment as on v1. In case the end user
> does not override the psci version I think you want to return the
> default value, retrieved from KVM through KVM_REG_ARM_PSCI_VERSION and
> which populates cpu->psci_version. So to me you should use
> cpu->psci_version instead

Sry, I didn't get your question the first time and double checked that the
VM uses the default/most recent version when the property is not set.

I just found out how to actually call this function (via qom-get) and
you're right: the VM uses the correct version but we report something
different here - and in this version even trigger the assertion. Ouch.

[...]
>> @@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>      if (cs->start_powered_off) {
>>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>>      }
>> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
>> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> I don't understand what this change stands for. Please document it
> through both a comment and a commit msg explanation

The explanation is in the cover letter - I'll move it to this patch.

Thanks,
Sebastian


