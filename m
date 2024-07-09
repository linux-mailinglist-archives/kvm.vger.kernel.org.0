Return-Path: <kvm+bounces-21218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B0892C237
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36D441C228F1
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 17:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B9717B047;
	Tue,  9 Jul 2024 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzGYXzu3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121C91B86CA
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720545509; cv=none; b=Q0s9Tyu7jX6/YnsPeZjATzr1bbz76H2iksPMrXpy7HjKO3FNuyPjkS4sJjaw0PZTf7Ehesr2GYsAU6EfLZh/VKF8scImR4ocGDATNOSGhyVwDNFbnFmkvqoTSjvmGjH8VoSL5m4x1+KfQwwj+LDZGyPmubClpD6ghutwEO07VxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720545509; c=relaxed/simple;
	bh=ZtMn0LRwFtGxyVO7PDTRcOf9LNpyjB1lVBEmum938wY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1J93WFO5X1YeejtLMriAYkyeIw4QHdrJ3Ccn8DN2+KbLAhYvM3EZCGXW7egdmzUfPAwyq521qC0UAxSQBAzOiyjhbCzIdF3/xV288Qpqb85OCQkgryv1B/InL7Yo6YehZ1/wsZaPuW3v8i7GSlee86tAHMEyJ844exK4a/4sP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bzGYXzu3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720545507;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txWFpwGnvOu9QFzJiCC8zu5uRGQCIBjC/kvWz1kKaQA=;
	b=bzGYXzu37bT0sr5xQXnMzPttdQbpQewsvmv9f0YTQVT0Pa3W8HJzUeMMM0eiuFsUsSSRfg
	9MgLNnrJVBLu1POR525uL7hfLtwMi71bOO0uA382UxY6R2+apn3+tpBWoRnP/DqXz5jRZp
	uJkZTO6ua7NO59oyR/HPEIrwHemgaHI=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-_J_E8AR4NkaoGC42BekAug-1; Tue, 09 Jul 2024 13:18:25 -0400
X-MC-Unique: _J_E8AR4NkaoGC42BekAug-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3d923b2fe51so3634196b6e.2
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 10:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720545505; x=1721150305;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txWFpwGnvOu9QFzJiCC8zu5uRGQCIBjC/kvWz1kKaQA=;
        b=AwS3dw7tEdBqAC41sHs5GjDlI7EIViH4uRoG6sgxdlNmErcJwxuW5qFoEe/I7RMy7P
         MaToQOzFuobjT4xYzbz3OMlJ6gDxTCt46hWuI5cKblr61eqqmH9CDPqThy2Es9M55Bbm
         XDd1Y/lFTPG5i43Yud7blTBPwoC5jGBTh3tk/I/TOg4uwhlJkPmoh+F21ivyKw/GU9er
         0ktzWYV1eXWWqRlXlEJZ9yR+2MndaEUXzYPdjIFTPAUit16dS+6UD9a30YnxFkx7BPKH
         nCK2zyRNK8ckKgE0T8IQ7K0rGtfWXXWspv+GRU1JFrBxPeLKhFm35475QmL1648mqVac
         ScRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQN4Ew1UH8ba6KEj0EX15PLAJXcDAeY8VHfIVUxR/o5StpVzMcVOPNjwJwc3snPENF7UZkCEsmIMP0+RiywJI1W3Py
X-Gm-Message-State: AOJu0Yzed+Ms3U5QLok8jDAsuEHPZ6U6dZq6sfKdH2wt+KUCvyKAgYVs
	ajhTEl+pCb4EEOoeM/tQPDVEoXBIxUd7QoZBsLDgg2sohH4hwiIa7vctdNYt+KiOs34ALtHKv5b
	a6vt/9dGdJV8KphYiJUAoqrCBTX5ZyYD8bHQxnFGoTJSE+okyUg==
X-Received: by 2002:a05:6808:140c:b0:3d9:2d9c:8aff with SMTP id 5614622812f47-3d93c085d8cmr3345133b6e.45.1720545504675;
        Tue, 09 Jul 2024 10:18:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCg8hXYGmEjThxs8qicr/EaSUtmrtO5gek2UVhqCZuwkZ1767RBJduAkyXwsp1LLvcYZ+Ylg==
X-Received: by 2002:a05:6808:140c:b0:3d9:2d9c:8aff with SMTP id 5614622812f47-3d93c085d8cmr3345103b6e.45.1720545504247;
        Tue, 09 Jul 2024 10:18:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f1902909asm114532285a.58.2024.07.09.10.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 10:18:23 -0700 (PDT)
Message-ID: <f36223a9-3db4-41be-81ef-b472cd34b607@redhat.com>
Date: Tue, 9 Jul 2024 19:18:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection
 test if missing
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, pbonzini@redhat.com,
 drjones@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com, maz@kernel.org,
 Anders Roxell <anders.roxell@linaro.org>,
 Andrew Jones <andrew.jones@linux.dev>, "open list:ARM"
 <kvmarm@lists.linux.dev>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org> <Zoz7sQNoC9ePXH7w@arm.com>
 <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
 <87ed82slt8.fsf@draig.linaro.org> <Zo1RvCdNDhaZHKMb@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zo1RvCdNDhaZHKMb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 7/9/24 17:05, Alexandru Elisei wrote:
> Hi,
>
> On Tue, Jul 09, 2024 at 03:05:07PM +0100, Alex Bennée wrote:
>> Peter Maydell <peter.maydell@linaro.org> writes:
>>
>>> On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>> Hi,
>>>>
>>>> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Bennée wrote:
>>>>> The test for number of events is not a substitute for properly
>>>>> checking the feature register. Fix the define and skip if PMUv3 is not
>>>>> available on the system. This includes emulator such as QEMU which
>>>>> don't implement PMU counters as a matter of policy.
>>>>>
>>>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>>>> Cc: Anders Roxell <anders.roxell@linaro.org>
>>>>> ---
>>>>>  arm/pmu.c | 7 ++++++-
>>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>>> index 9ff7a301..66163a40 100644
>>>>> --- a/arm/pmu.c
>>>>> +++ b/arm/pmu.c
>>>>> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>>>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>>>>
>>>>>  #define ID_DFR0_PMU_NOTIMPL  0b0000
>>>>> -#define ID_DFR0_PMU_V3               0b0001
>>>>> +#define ID_DFR0_PMU_V3               0b0011
>>>>>  #define ID_DFR0_PMU_V3_8_1   0b0100
>>>>>  #define ID_DFR0_PMU_V3_8_4   0b0101
>>>>>  #define ID_DFR0_PMU_V3_8_5   0b0110
>>>>> @@ -286,6 +286,11 @@ static void test_event_introspection(void)
>>>>>               return;
>>>>>       }
>>>>>
>>>>> +     if (pmu.version < ID_DFR0_PMU_V3) {
>>>>> +             report_skip("PMUv3 extensions not supported, skip ...");
>>>>> +             return;
>>>>> +     }
>>>>> +
>>>> I don't get this patch - test_event_introspection() is only run on 64bit. On
>>>> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
>>>> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fails if
>>>> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result, if
>>>> test_event_introspection() is executed, then a PMUv3 is present.
>>>>
>>>> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than the cycle
>>>> counter)?
>> The other option I have is this:
>>
>> --8<---------------cut here---------------start------------->8---
>> arm/pmu: event-introspection needs icount for TCG
>>
>> The TCG accelerator will report a PMU (unless explicitly disabled with
>> -cpu foo,pmu=off) however not all events are available unless you run
>> under icount. Fix this by splitting the test into a kvm and tcg
>> version.
> As far as I can tell, if test_event_introspection() fails under TCG without
> icount then there are two possible explanations for that:
>
> 1. Not all the events whose presence is checked by test_event_introspection()
> are actually required by the architecture.
>
> 2. TCG without icount is not implementing all the events required by the
> architecture.
>
> If 1, then test_event_introspection() should be fixed. I had a look and the
> function looked correct to me (except that the event name is not INST_PREC,
> it's INST_SPEC in the Arm DDI0487J.A and K.a, but that's not relevant for
> correctness).
>
> From what I can tell from what Peter and you have said, explanation 2 is the
> correct one, because TCG cannot implement all the required events when icount is
> not specified. As far as test_event_introspection() is concerned, I consider
> this to be the expected behaviour: it fails because the required events are not
> implemented. I don't think the function should be changed to work around how
> QEMU was invoked. Do you agree?
>
> If you know that the test will fail without special command line parameters when
> accel is TCG, then I think what you are suggesting looks correct to me: the
> original test is skipped if KVM is not present, and when run under TCG, the
> correct parameters are passed to QEMU.
This looks sensible to me too

Eric
>
> Thanks,
> Alex
>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>
>> 1 file changed, 8 insertions(+)
>> arm/unittests.cfg | 8 ++++++++
>>
>> modified   arm/unittests.cfg
>> @@ -52,8 +52,16 @@ extra_params = -append 'cycle-counter 0'
>>  file = pmu.flat
>>  groups = pmu
>>  arch = arm64
>> +accel = kvm
>>  extra_params = -append 'pmu-event-introspection'
>>  
>> +[pmu-event-introspection-icount]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +accel = tcg
>> +extra_params = -icount shift=1 -append 'pmu-event-introspection'
>> +
>>  [pmu-event-counter-config]
>>  file = pmu.flat
>>  groups = pmu
>> --8<---------------cut here---------------end--------------->8---
>>
>> which just punts icount on TCG to its own test (note there are commented
>> out versions further down the unitests.cfg file)
>>
>> -- 
>> Alex Bennée
>> Virtualisation Tech Lead @ Linaro


