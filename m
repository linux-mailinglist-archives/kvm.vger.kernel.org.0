Return-Path: <kvm+bounces-57340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 604E7B53991
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C834AA15BE
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D9C340DB3;
	Thu, 11 Sep 2025 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+n7/rtd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3858236453
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609213; cv=none; b=aV1ll3cBBuNfjr4SzjIeDwUvspZnvcX7cZYSL9ZWmVttF7mYKbtk8g7xOko7MM2kOth8ghSNu3xCAMRL3Iw4/x0uNR00k/J0SJ4Qh/4xmKTyVgo6Fj5QgD/feVc/8r5UvkWpTujSwCpxKNFstbpZJfbKnYFZzuNCfWHpXEoCEy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609213; c=relaxed/simple;
	bh=Qxo0B09NTnHspuzv4ArFG5GlK+5CwYc07R5WImThL94=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mb1yGmFxdCT/9q9EkBQPhrdZLIDbd+38JTPbJwADyKOJMYkRjWvIJv31VGdpokhQoorOBzb55jnvFMoPgkWKCszPjiez5msKrR6K4l1qDwOJwkCKA2JOGHHTdu0IP658Cypjv60efUBGyN/89/2gNxebfSR1We/dANQMeNwmrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+n7/rtd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757609210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NfLhSbNYEBMsg+7tun6uGQtYpAPcwFglJcubTMzrz7A=;
	b=V+n7/rtdVt1DjSLCJlfPj0ijyv+bho5gmIsFRubIpVgnpeEroDT0khehxfaChXL+M9HADC
	Wyn3TYqlx2hm9L4+5GOZFQeYmNr/f30Ukey2KpB2KRGpoI1wFOQWTFlhraE+u8XZvnlYao
	Z1j2wTs6V+uYgmIrdN0i6l8qUklncr4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-V2F-KOfnN5KJkhwM9Y1fJQ-1; Thu, 11 Sep 2025 12:46:47 -0400
X-MC-Unique: V2F-KOfnN5KJkhwM9Y1fJQ-1
X-Mimecast-MFC-AGG-ID: V2F-KOfnN5KJkhwM9Y1fJQ_1757609206
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b99c18484so4175875e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 09:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757609206; x=1758214006;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NfLhSbNYEBMsg+7tun6uGQtYpAPcwFglJcubTMzrz7A=;
        b=qx/vLECwhvbuVv1e2mi9EB1FEnEGBV+0T6LGz4qNiK1arbUf4N2jIHp30A2Q08Yafg
         jAOTyK+h/v9IOL7r5ShM4jDx3i8LDruVudSxeshmymmQ9aYg7yg5pKf2MsAoD2smZOGb
         EddM80IZnmPyjn6MSApTHde6Mt7eUCmoD+rgACrkj6y0eLTXMGNxom0tPuxsWTGaM0WJ
         rGR9Q+xElJLLoPEDQ8EGaQFxujCGKvRIhtBlzH4GrMJGYHVLqCQ5BBvS4ekOVuEeV87r
         exUffKX9xNPtR0MH6ZP9uOY43E/11RFDG/+kfs/hqZLezIZH/HuVAI0Zq0QZoQBMSsoP
         TjAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6zUC5AtNCqZIjY5VE+CbaEtDwFRpBPrYnFZG+SW/M6lYf7NyjwL7hYFrfIHXSJGTgxvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXeSCcDyF2C+v0L4cu8stvFMs3OC4eQ4xY4yN0maWnS9dtKhHp
	DHfVvYzhg6BaLoUt5tblxt1KwFlLz1WtK4V/WjankDZv+qzkFdKSlNu+ZJ/m4LYjFYE5jUA4fcK
	/oiSeGiM1ekjXkKKMkohdx+0lpR6aKXZFDgT5X8DSD4nX20XIKny6JA==
X-Gm-Gg: ASbGncvd7uOZMJHP9owFeHq6Hk7B36ahwBpi/KViOnBdE4Sca+I5CwRmfCWiv7BAyi7
	HR2KM9LI94w3VTjrHQt5IEHha25O/4d33+xQnXXJ9EMRZ8VWU65jo5tzKH4DKeYw/jEieOKDjcF
	CgSW1iu/4JNY+fHsyYwzOmDqg0liogvwd8bthRzr9NqsxxlOJZoPp9vnuiYt5f+/x86YKGfHz28
	zm3M+pXZSl7SFV3uiCT+2fpNIf8IkX5GLFb2u18mMCF1VJdhtU5/Xheeu9PbWSJC+C47Q6TgnwZ
	BdJRYRuWMinbx20RzbLvEdvEmpCSks8fenkVcQvZ2aOVX4V+MpsIAqmtUg2F54Nva0axLs23GWK
	d3VlBPwFaJOCmVQ==
X-Received: by 2002:a05:600c:83cf:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45f21207be1mr1499125e9.35.1757609206252;
        Thu, 11 Sep 2025 09:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzF7xdwiuJNiKLKdPH1FNf4ped6tYssSHKKe16I6IF6tF5/rGaCdBMHdg5t+uJppxMHK84qw==
X-Received: by 2002:a05:600c:83cf:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45f21207be1mr1498835e9.35.1757609205837;
        Thu, 11 Sep 2025 09:46:45 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e04cf2870sm13652215e9.1.2025.09.11.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 09:46:45 -0700 (PDT)
Date: Thu, 11 Sep 2025 18:46:44 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
    Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Message-ID: <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com> <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com> <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>>>>>
>>>>>> This series adds a vcpu knob to request a specific PSCI version
>>>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>>>
>>>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>>> Alternatively we could limit support to versions >=0.2 .
>>>>>>
>>>>>> Sebastian Ott (2):
>>>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>>>
>>>>> Could we have some rationale, please? What's the use case
>>>>> where you might need to specify a particular PSCI version?
>>>>
>>>> The use case is migrating between different host kernel versions.
>>>> Per default the kernel reports the latest PSCI version in the
>>>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>>>> when that differs between source and target a migration will fail.
>>>>
>>>> This property allows to request a PSCI version that is supported by
>>>> both sides. Specifically I want to support migration between host
>>>> kernels with and without the following Linux commit:
>>>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>>>
>>> So if the destination kernel is post that commit and the
>>> source kernel pre-dates it, do we fail migration?
>>
>> This case works with current qemu without any changes, since on
>> target qemu would write the register value it has stored from
>> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
>> on target to emulate that version.
>>
>>> Or is
>>> this only a migration failure when the destination doesn't
>>> support the PSCI version we defaulted to at the source end?
>>
>> Yes, this doesn't work with current qemu. On target qemu would
>> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
>> register but that kernel doesn't know this version and the
>> migration will fail.
>
> I was under the impression that trying to migrate backwards
> from a newer kernel to an older one was likely to fail
> for various reasons (notably "new kernel reports a new
> system register the old one doesn't") ?  Perhaps we should
> think about the problem in a wider scope than just the
> PSCI version...

Yes we already are ;-) See this series from Cornelia:
https://lore.kernel.org/qemu-devel/20250414163849.321857-1-cohuck@redhat.com/

And this from Eric:
https://lore.kernel.org/qemu-devel/20250911134324.3702720-1-eric.auger@redhat.com/

Both will help mitigate register differences for a backwards/downgrade
migration.

Sebastian


