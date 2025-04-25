Return-Path: <kvm+bounces-44292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B066EA9C5A7
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5693C18875E9
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32CB23A9AD;
	Fri, 25 Apr 2025 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ylXyI8U7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AF222DFF3
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745577322; cv=none; b=GYiXKZSTsfbO4r9rB0gXSgIvz9CSffMgFE0i2ixG7rECK3V9y0Rv8ahgdhwLuAtxBmb1O5lqN5C7FqWt1JDoy8eBSnxFrzuzfv26IlBQc9kr+8a9am8EfurBwptIVtm5wgkRHbhk5wKmTphS1SXhNusT/XGJbop5s6pKg58E0GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745577322; c=relaxed/simple;
	bh=FSw2tk20MqhLM8MbR3WjROsl8FjTFxNia9RvgcNUBtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enFAdodjxr6KV4mZV4vlXMJhPWQsYl2IrtZQoZhbuCCGKcRyCtzp4mDWB8rs5VYZc2qN+yYWVr3J5m9msp84Vv/McuvZzH/Q2AiQzaRRBmcu3Un8Qk5O+sr+vit60n138SBguCv5YroKCrFOLXp3X0pw/HCiZ+0WOQG6CHaa4hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ylXyI8U7; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso23580125e9.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 03:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745577317; x=1746182117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kA0W8cd4KB8E87d1e/uyPkx8dl85yv1pXirIFdrdRs4=;
        b=ylXyI8U7RSM19+tp3KAfzl/poFFJsTPA7L5bZSgIpMY3Pyd8tHjUdpCaZ/8UNAmP54
         oBslokSxrqBXQsL4rT+C2SVmPLxdOE3e8jBwLgucPtroZC5sgTqY5ZDWUriqfCR1BoLL
         fnkc/w2YlS8jobKtBHr9JXz98GVWXqusSPe2FjSaz5MGWOr20Hz5LcMxJ1nfo/ABgjHZ
         qaaUNc4oGfPy63yl85UYN8Gg6aVj5SmV+XTom96k86axJMvQRS+L5MCk+r3wZvd3piE4
         M0P/GmKd3yLSLTKXP1w2Vqm8ttnbiwaRsmV5vN4wjvKWTJu7lr/bkWbf0uBI5DIF/nfH
         hHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745577317; x=1746182117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kA0W8cd4KB8E87d1e/uyPkx8dl85yv1pXirIFdrdRs4=;
        b=Q3EOlArZvFJ79HNu9jzrv8lKRF69ps4WTVRPuEYpEkB30lb3SYXMm5u/SzwAB11qHT
         GFj5TopcvNX8GeikiAWel8fbB9M5NaPo7ieoGWZHmZEXrtSLvTqzjm7hSynmiqoJEy6L
         sQaEvkzA4P2ftS0plk4pjJiyIxEQVY/Avgpb6DXs1zocVMCvCWMOFrHLE2b7Q0bchLHZ
         fMUr/+KmFUOg9ikLD8WGIcLyt+QrnNv02NiGgSo9L2mKbF5dsSyxU8glEFBr+s+aO3Zp
         G2qlINdZ38rhaR6GrMmDwfi+4NHnc/BRkrDDxU520TpQ+RbcouE84e3h3WhBdXrQlIiG
         WNoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQTV+LUGcJzq6ei7u0zvh6zJGU5lWudlVbnOVVPdx7kPxE+UppqvXagjfx7clhXg1ZeLM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3m+qzMMHm2OESBQCKnt9j+bQynZEFON1TFs91P4EttFoN3ejc
	MnXdZzPUXRZmmc+gqWwg2Uq1yKRpwcCziySQGAd+6thpgi63qeFW0b2mEjEN6ug=
X-Gm-Gg: ASbGnctXwnRYi35q/8qzd+Ckrc/sAN4UTqVRf6mFGzyrmiOmXUA9fTznABVKa7NZlIm
	1hToMw2N8VazUMppe1W52ZL3EOFhsB7Pm7J40WUM9Dvq1X+79ID2EjG9SUi26zMmVQuMjLjXQRT
	GScanSGr5WcDZR0hwOmIKdbyJWNOulyrjzZP91XDC3+tyo/38mzi8RiqJHYGTyHR6jw1Okv3pfv
	DQvNK1UP5/3u9xjMFVnwL7eSQeVpbWjZYbxaaZiadmVSNN3apCU+6l+beLDF0RMVP66jF4Fz2pc
	FF7Jy/XfQcQoNX2eWaQdcc0L9XphUcE8Dvf+rxS9zCX71inKjT7p2z8WURgCdp17x4XAQJvYSVB
	HP/9EXUOs
X-Google-Smtp-Source: AGHT+IGIumkJchFpnhxDOvoTMJn12J1D7niYkd5KDfOajooMuqxtsNhZGAxrQuS7jdm7hB+3Fb8ALQ==
X-Received: by 2002:a05:6000:1a88:b0:39d:724f:a8a0 with SMTP id ffacd0b85a97d-3a074fae1damr1251690f8f.58.1745577317346;
        Fri, 25 Apr 2025 03:35:17 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073c8c7a4sm2030455f8f.14.2025.04.25.03.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 03:35:16 -0700 (PDT)
Message-ID: <fa6f20a9-3d7a-4c2d-94e5-c20dbaf4303e@linaro.org>
Date: Fri, 25 Apr 2025 12:35:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
To: Zhao Liu <zhao1.liu@intel.com>, Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Michael Roth <michael.roth@amd.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcelo Tosatti <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>,
 Alexander Graf <agraf@csgraf.de>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-2-zhao1.liu@intel.com> <878qo8yu5u.fsf@pond.sub.org>
 <Z/iUiEXZj52CbduB@intel.com> <87frifxqgk.fsf@pond.sub.org>
 <Z/i3+l3uQ3dTjnHT@intel.com> <87fri8o70b.fsf@pond.sub.org>
 <aAnbLhBXMFAxE2vT@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <aAnbLhBXMFAxE2vT@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Zhao,

On 24/4/25 08:33, Zhao Liu wrote:
> Hi Markus,
> 
>>> This is for security purposes, and can restrict Guest users from
>>> accessing certain sensitive hardware information on the Host via perf or
>>> PMU counter.
>>>
>>> When a PMU event is blocked by KVM, Guest users can't get the
>>> corresponding event count via perf/PMU counter.
>>>
>>> EMM, if ‘system’ refers to the QEMU part, then QEMU is responsible
>>> for checking the format and passing the list to KVM.
>>>
>>> Thanks,
>>> Zhao
>>
>> This helped some, thanks.  To make sure I got it:
>>
>> KVM can restrict the guest's access to the PMU.  This is either a
>> whitelist (guest can access exactly what's on this list), or a blacklist
>> (guest can access exactly what's not this list).
> 
> Yes! The "action" field controls if it's a "whitelist" (allow) or
> "blacklist" (deny).
> 
> And "access" means Guest could get the event count, if "no access", then
> Guest would get nothing.
> 
> For example, if we set a the whitelist ony for the event (select: 0xc4,
> umask: 0) in QEMU:
> 
> pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"x86-select-umask","select":196,"umask":0}]}'
> 
> then in Guest, this command tries to get count of 2 events:
> 
> perf stat -e cpu/event=0xc4,name=branches/,cpu/event=0xc5,name=branch-misses/ sleep 1
> 
> Since another event (select: 0xc5, umask: 0) is not on whitelist, its
> "access" is blocked by KVM, so user would get the result like:
> 
>   Performance counter stats for 'sleep 1':
> 
>              348709      branches
>                   0      branch-misses
> 
>         1.015962921 seconds time elapsed
> 
>         0.000000000 seconds user
>         0.015195000 seconds sys
> 
> The "allowed" event has the normal output, and the result of "denied"
> event is zero.
> 
>> QEMU's kvm-pmu-filter object provides an interface to this KVM feature.
> 
> Yes!
> 
>> KVM takes "raw" list entries: an entry is a number, and the number's
>> meaning depends on the architecture.
> 
> Yes, and meaning also depends on format. masked-entry format has special
> meaning (with a flag).
> 
>> The kvm-pmu-filter object can take such entries, and passes them to
>> straight to KVM.
>>
>> On x86, we commonly use two slightly higher level formats: select &
>> umask, and masked.  The kvm-pmu-filter object can take entries in either
>> format, and maps them to "raw".
>>
>> Correct?
> 
> Yes, Markus, you're right! (And sorry for late reply.)
> 
> And "raw" format as a lower level format can be used for other arches
> (e.g., ARM).

Since you provide the ability to use a raw format, are we sure other
accelerators will never be interested in such PMU filtering?

I'm pretty sure HVF could benefit of it (whether we implement it there
is another story).

What do you think about adding this as a generic accelerator feature.
If a particular accel doesn't support it and we ask to filter, we simply
report an error.

