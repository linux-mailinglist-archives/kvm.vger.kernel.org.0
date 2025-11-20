Return-Path: <kvm+bounces-63844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2590FC7419F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 14:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 10E904E3780
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419B433A6E0;
	Thu, 20 Nov 2025 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJUhJgXq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IP9uly0r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1DB337115
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763644303; cv=none; b=ahgM42iDNwPAAjgM0Xxta2z+PP+YnAj9B6XmwqJ75UqXDzV9nnX1X47ha6FT6E8jEpNr9+axO/YRGJHjsiHZ9U5fEpzUylyfUzga2eRLB2FDBVjjeMp9Qc/BJrXVFZ/qVOHFGBcEzqQ3W4RvaockzKVCZZSW2AhTUiZtST5rv5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763644303; c=relaxed/simple;
	bh=818AFFduQR+q8eZQrbimT+9rzrOQSVtJdNUKUtqCpt0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YpA8hK+8cNCO8gvV7KSeoWcWKf2G7vGddRa6+Al6NiB2w0eIhEAcWtan4yFFlVJ0GcKHDcQjGRjCvy4Lvh55DM1BZa+b9VuRmhSXqkF3clnoxY4zw+hLObBefAOdsRqNLYhsm1KnXiljKgFV5ZSzWk/lrID7p7sm65VEJRKx3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LJUhJgXq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IP9uly0r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763644300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qyhhdzn0BYMbkUVey/n2YMFPr5fhLGbTZAGvpz5pi1c=;
	b=LJUhJgXqGxD5tIpcuxdfYFLGqBpM6A4iO2Rwo9AEXQ7TTZaPhei0Clt7eg5b11D2zUSN4Y
	39mDU2pJe2ML825VR0cOKdO1o3gbqed8fu3WN+BFuK3FgV7toVU+hjAGWLEM7LLM+bL95X
	Rg2YgZJcmQ1plzzdI9cXglp0LTcyV3c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-VLL2b1I6MRml28KJqxc6Ww-1; Thu, 20 Nov 2025 08:11:39 -0500
X-MC-Unique: VLL2b1I6MRml28KJqxc6Ww-1
X-Mimecast-MFC-AGG-ID: VLL2b1I6MRml28KJqxc6Ww_1763644298
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a60a23adso5828875e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 05:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763644298; x=1764249098; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qyhhdzn0BYMbkUVey/n2YMFPr5fhLGbTZAGvpz5pi1c=;
        b=IP9uly0rqqophwW55CDuvK/ugxK/KoMlOflhu0qRXjkFovou8ltH3SXv6VJJvTud1z
         prHjizUIUUb6kpxzBgmsLrl4x9J6xxhOBz7dgbHd1WIxoZ1E6jquwuqtWAOCgsTopipV
         8rpkuYMOWI2GrKETHnyKXDUlBxQPFEgzqUsJJKhPDCwa84UHgg/C5GwJFRqn40HmhLfh
         KLqINjBAdPPL7EJCCbHFA9/fBcojAqoS0peZmgvYh1WwzNUNqjToe0dr0BwJ0qwg+6Yb
         CtL4qdD1J+P63FtzlRZ2bgGXXSxh4Zb+rF7UPcdUgTL8rmI5NZPSjM+bfiBkoSjkzcfi
         WBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763644298; x=1764249098;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qyhhdzn0BYMbkUVey/n2YMFPr5fhLGbTZAGvpz5pi1c=;
        b=JOZbfbnwOq+ryXG4SxfUdMNJS8fJIC9QeubE5ta4hidRZnHCY0zmJjXX7pIvDjfjz/
         Jc4wwejH9ieTyj+tY4j6pzDl1Yx8pdGpphXv4QrjcfNzUlc/lWr+BBULv6uo4feqSgHA
         Q4Ul2KwkkuLYtk2FxmXQmpz93TSQaqNztVbhmkNq3U/aLEzOYOrkrOZyDluV1qwGzCsE
         GnK7b6yb4BBtVb8xx/XepF5O7jAXMlU9tlmfPgHI6Nn5IYaHZzrukTWv+eT8tvjp0a2M
         D9SDzxgPfsM7F0+GyPJYF1rQss5Vj+pb0fYwtG1sBBpLafm21OqPRnDpr1WjRxXfnP9s
         4CZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl6jIJ+5Ri55jjPFsu3UskJ0IJwe4mXTlJJsd+WgGovDfSmGoZM2xhrxKI9Pgmn0Qns6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkIquWXP445RHwl2/yaAA0j6UaJeBuRi512l2yHhzMgW1fzqiV
	si7vPihWyzr3eKRFg0/EmzNltwRBKRLEub6+45ua7yfqkiR8XITnDB4Z2oDJzgfTXK4KvdjXV3I
	X2KKEGbHFopy/zUFU8lzvZWIHs/sXQmuhynU3G3dKnfH1VV55fLehjA==
X-Gm-Gg: ASbGncsLoeNsC4OLDYfPsF65fdglzQL9PQiD0odvdlHiV5ykPWmzIABpuRQsiTdnAmf
	BiefOZXPnHeUZxvJdVOGknatURzwBb2uLnwaciEUFCtFydSUALq9VQu4JnFZ3mwRLS00riBOmlC
	rJVVoEAw5a02Mbqx5t9mJi+tLKumcOmDSnFTTVd1jwlR29lsgZRS1LsKADum0/qGzB2XpIr4Oj1
	sJDpgpF4iVtGb4cwDvoRTC0c0XwOGWFnZZW7qVwhjqqCB8a4SBgZsUOti/FdMzkgEZvTz+r+Vvd
	vXpnoYCf6yX9kc9vGAR2KerYwjWe2aZoU5f/TA7+wpvUm4UFsETdESG8kFLX2NaXYRqm8HRypzI
	iWeaqZi022bs4fpaLWtIP5xdKGJs8epObc3UvVdHb75cOpJcn5wxilOW/WDk=
X-Received: by 2002:a05:600c:19cf:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-477b9deb5fcmr27551025e9.10.1763644298193;
        Thu, 20 Nov 2025 05:11:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqk0rLj6ifgE7tCamOIWPRaEiyBBbqDGCq1Uha6rrPDrmf26u75w870PL6lQD0kcpOCi1brA==
X-Received: by 2002:a05:600c:19cf:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-477b9deb5fcmr27550685e9.10.1763644297761;
        Thu, 20 Nov 2025 05:11:37 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a974cdc8sm67987845e9.2.2025.11.20.05.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 05:11:37 -0800 (PST)
Date: Thu, 20 Nov 2025 14:11:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Message-ID: <8c679736-a168-0a33-e44a-4367e9e7b8d4@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com> <20251112181357.38999-3-sebott@redhat.com> <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org> <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com> <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463806286-370073406-1763644297=:54158"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806286-370073406-1763644297=:54158
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 20 Nov 2025, Eric Auger wrote:
> On 11/13/25 1:05 PM, Sebastian Ott wrote:
>> Hi Philippe,
>>
>> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>>  Provide a kvm specific vcpu property to override the default
>>>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>>
>>>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>
>>>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>>  ---
>>>>    docs/system/arm/cpu-features.rst |  5 +++
>>>>    target/arm/cpu.h                 |  6 +++
>>>>    target/arm/kvm.c                 | 64
>>>> +++++++++++++++++++++++++++++++-
>>>>    3 files changed, 74 insertions(+), 1 deletion(-)
>>>
>>>
>>>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>>  index 0d57081e69..e91b1abfb8 100644
>>>>  --- a/target/arm/kvm.c
>>>>  +++ b/target/arm/kvm.c
>>>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>>  value, Error **errp)
>>>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>>    ON_OFF_AUTO_OFF;
>>>>    }
>>>>
>>>>  +struct psci_version {
>>>>  +    uint32_t number;
>>>>  +    const char *str;
>>>>  +};
>>>>  +
>>>>  +static const struct psci_version psci_versions[] = {
>>>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>>  +    { -1, NULL },
>>>>  +};
>>>
>>>
>>>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>>                                 kvm_steal_time_set);
>>>>        object_property_set_description(obj, "kvm-steal-time",
>>>>                                        "Set off to disable KVM steal
>>>>  time.");
>>>>  +
>>>>  +    object_property_add_str(obj, "kvm-psci-version",
>>>>  kvm_get_psci_version,
>>>>  +                            kvm_set_psci_version);
>>>>  +    object_property_set_description(obj, "kvm-psci-version",
>>>>  +                                    "Set PSCI version. "
>>>>  +                                    "Valid values are 0.1, 0.2,
>>>> 1.0, 1.1,
>>>>  1.2, 1.3");
>>>
>>> Could we enumerate from psci_versions[] here?
>>>
>>
>> Hm, we'd need to concatenate these. Either manually:
>> "Valid values are " psci_versions[0].str ", " psci_versions[1].str ",
>> " ... which is not pretty and still needs to be touched for a new
>> version.
>>
>> Or by a helper function that puts these in a new array and uses smth like
>> g_strjoinv(", ", array);
>> But that's quite a bit of extra code that needs to be maintained without
>> much gain.
>>
>> Or we shy away from the issue and rephrase that to:
>> "Valid values include 1.0, 1.1, 1.2, 1.3" 
> Personally I would vote for keeping it as is

OK, thanks!

> (by the way why did you
> moit 0.1 and 0.2 above?)

Just to clarify that this is an incomplete list of possible values
that we don't have to change when a new psci version is introduced.

Sebastian
---1463806286-370073406-1763644297=:54158--


