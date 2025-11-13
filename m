Return-Path: <kvm+bounces-63010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E8EC57558
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D2976341AC1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 12:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6297834D38A;
	Thu, 13 Nov 2025 12:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DqyrN580";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bs10BSpL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D1F21348
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035549; cv=none; b=Dkp0eFRwRj/C1w3zMgH/9VtdTlu5fiNmSR9dz51PQxNLubZQ971FrzYa/fzoUedPTxOi2THfkQBtHVrRu/8MPDSKekFEseVfRn5QSefCQl+5Joxa52iDoqZvgeqEeojUGDveSI1EzwVlvQ4zZ9sg3HcQiGe4F6lRagbYm/K782k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035549; c=relaxed/simple;
	bh=94BURugg/MQ5M20T3CsuvIMe9pNv4ndJk6pUBYNEZz4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lcJOkA06Zl4wCeeJHvxwBCOkjAYHHSfQk4OmnYnNhIWefTVZ0ZkHo6h0QqZDxHqefdSDqFR2gzyFhUfqGm9Y6LI2oKzZwAhFjUXN7ONuLe7nlwsXeiTSY7RDuh90H5hpJFpAsEKr4TprW6NU9lyivI/GU98USpiB0E2DDVkmBk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DqyrN580; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bs10BSpL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763035545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tI2/OYtW6mgwxijeu2yFHVnaEg8ys2MTvM8mvkzh7dM=;
	b=DqyrN580ANHWKRLwiMr6e14BStI5Q4lurZhTdK+42r+nrqySaBndtjnIJ9dnqzWyW0JEd/
	gp+GcYKo8NHjfw7oPMCGgOR27jMKiNikFR/6c1BP1Zd9Ii5WUgcK9URvKDHXprDh65MjDl
	aHlt+eRbzJI+JNPDSmBeXs6OzxDhstw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-wx-ocCs6OsiIJPuZ2cOafw-1; Thu, 13 Nov 2025 07:05:42 -0500
X-MC-Unique: wx-ocCs6OsiIJPuZ2cOafw-1
X-Mimecast-MFC-AGG-ID: wx-ocCs6OsiIJPuZ2cOafw_1763035541
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3ed2c3e3so691023f8f.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 04:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763035541; x=1763640341; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tI2/OYtW6mgwxijeu2yFHVnaEg8ys2MTvM8mvkzh7dM=;
        b=bs10BSpL4V928O+qSzpFsC4DVx9MqhIPx4LUyzoxjLijghD8M8BmW50zmm0MJOsjJK
         OTL+LkhtRXXktJPlN1DNIz0ufACaVjp4hjWHvXNVpIunsLeZLUj9chZV2NKip/mUkntL
         pESx9T60Pz3xLOZA0P0ay/s3GNbbdgeoOyjqUm1dLMnhc01bpqoLfdM2XPF4EAY+LKED
         mxT48atgJgcfl2kq0tU7SuVCpUbAKl/CACikLfG5LJ32SIgGd1O+wjhb1HQgc5eFydCD
         jep0er4UMuQIZiTDQe/RfhhBVyaM6uzgCOidH/Ctyxdl2KqEUrG32AVFpOlgXAhOXk8g
         hfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035541; x=1763640341;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tI2/OYtW6mgwxijeu2yFHVnaEg8ys2MTvM8mvkzh7dM=;
        b=u0/481pB6G7ei9ZmJ7kWlwzs7ah1xXKkdEdz8BlqzU8u7PxCbZjxCXqwPjuw92LQ4/
         cdXypfuvtHPof8GOFuU0X3HUOIny7K5Q3Tg9XYQSkdRY9qs06Poo0tAtx8iVGDT1zRCN
         0avL6eMYEzeldeeKU7fNt1MSrMCZVoPJfd63cUv9TGLsc3FdTAi5dYnoNfB1LgvrT6x9
         1hEE2l8y3BhbILaaXHM8ex+Ctxef20uUnBktVa+LxIXEDiYnEiBVC1B5rK0cGnZ+9PXl
         /S3VIYk8VYs6R+xo8Nhizhulkdqg8ZTSqZwJ+3wFBAbAhs1pJsnYZVeQ0/yerFcEF3YJ
         nZ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5G7NND1t3MaEnHL+MqkTPKF30LtHJXBhyO/GEqVcrzIA+3y5uElI14F1dUtRbPyP8oV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkS5OnxxYd5pmCFKASth4oX45LRttCNpeaa1mSK2Pd+OIyDotz
	F9C9IOCZx0ysskrhIINUpU8JkYf9wAq7Dl1PtaM2L2KcsVtlci9uXLvwPv80JwtYVunz9HRRbIp
	3wisqm4RGwM5pnO1xBuuTQ6Ipy6ryVdgdvoBclWNgNj1TJza4aDqssQ==
X-Gm-Gg: ASbGnctBe+PL3FN70s/as0QEL6aZbSSQ3RyYWf4BCytIVr73xghM/ZjorLqGKj5X5jT
	zZHaJwZjn/uhpo6K9CFyb2gvNxEepiUD71QsApOa7ztCxmc+a+aMW03pAnYhAJFNPkXUevGDPm1
	/Lr/kQ4XXkhW+AzJyT4J7rfn6mSaMOBpnqNQgOEqQ9x8vX4Vk2D/xjyIKlhvIgCR5aRlmy2MCxl
	mdysLsCLcXAOVRw+7zUUkzeSHH4gIRI+nvz8yUtTVN+GS/HUOK923VMa0tsBpq6w/JajzVe1yHP
	7Kr8oEsGZU+cZtWcW4jW38z8naO1Qj7FuDeYJOSsk+gET4WySmIzTC66k3cow8UJ1IOz79e07EH
	UtzG8hdXEWBWbTa5qE2WV57S6COGwkd176up5BMMxTWmAn5QH
X-Received: by 2002:a05:6000:1885:b0:42b:3680:3567 with SMTP id ffacd0b85a97d-42b4bb91b2cmr5895238f8f.18.1763035541149;
        Thu, 13 Nov 2025 04:05:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3IIBIBt8q03GbcoIy980NO1o7f47Eyz3eGrQw/lEHfvAJ2mJpS0tJ8SI1nFL6EYhPZo1J9g==
X-Received: by 2002:a05:6000:1885:b0:42b:3680:3567 with SMTP id ffacd0b85a97d-42b4bb91b2cmr5895217f8f.18.1763035540713;
        Thu, 13 Nov 2025 04:05:40 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f23a1asm3522001f8f.45.2025.11.13.04.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:05:40 -0800 (PST)
Date: Thu, 13 Nov 2025 13:05:39 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Message-ID: <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com> <20251112181357.38999-3-sebott@redhat.com> <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463806286-853068444-1763035540=:13840"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806286-853068444-1763035540=:13840
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Philippe,

On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
> On 12/11/25 19:13, Sebastian Ott wrote:
>>  Provide a kvm specific vcpu property to override the default
>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>  ---
>>    docs/system/arm/cpu-features.rst |  5 +++
>>    target/arm/cpu.h                 |  6 +++
>>    target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>>    3 files changed, 74 insertions(+), 1 deletion(-)
>
>
>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>  index 0d57081e69..e91b1abfb8 100644
>>  --- a/target/arm/kvm.c
>>  +++ b/target/arm/kvm.c
>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>  value, Error **errp)
>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>    ON_OFF_AUTO_OFF;
>>    }
>>
>>  +struct psci_version {
>>  +    uint32_t number;
>>  +    const char *str;
>>  +};
>>  +
>>  +static const struct psci_version psci_versions[] = {
>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>  +    { -1, NULL },
>>  +};
>
>
>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>                                 kvm_steal_time_set);
>>        object_property_set_description(obj, "kvm-steal-time",
>>                                        "Set off to disable KVM steal
>>  time.");
>>  +
>>  +    object_property_add_str(obj, "kvm-psci-version",
>>  kvm_get_psci_version,
>>  +                            kvm_set_psci_version);
>>  +    object_property_set_description(obj, "kvm-psci-version",
>>  +                                    "Set PSCI version. "
>>  +                                    "Valid values are 0.1, 0.2, 1.0, 1.1,
>>  1.2, 1.3");
>
> Could we enumerate from psci_versions[] here?
>

Hm, we'd need to concatenate these. Either manually:
"Valid values are " psci_versions[0].str ", " psci_versions[1].str ", " ... 
which is not pretty and still needs to be touched for a new version.

Or by a helper function that puts these in a new array and uses smth like
g_strjoinv(", ", array);
But that's quite a bit of extra code that needs to be maintained without
much gain.

Or we shy away from the issue and rephrase that to:
"Valid values include 1.0, 1.1, 1.2, 1.3"

Since the intended use case is via machine types and I don't expect a
lot of users setting the psci version manually - I vote for option 3.

Opinions?

Sebastian
---1463806286-853068444-1763035540=:13840--


