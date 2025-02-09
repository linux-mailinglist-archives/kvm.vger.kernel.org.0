Return-Path: <kvm+bounces-37664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C62A2DFAB
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 19:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 869F71885284
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 18:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B521E0DE8;
	Sun,  9 Feb 2025 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CLVEHzPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9421DED7B
	for <kvm@vger.kernel.org>; Sun,  9 Feb 2025 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739124174; cv=none; b=bOuz9YBBD420OkI5HGnWLx+oF4IYAR11d8c4wCUdUaOW6YRjkA10PZE5cy10rlL3XAY35B28fXMtrW8N9LVjUdbLu8t3pkr9U62fG1uofiGYudfmL87VLkGSZROzLcO0XOa+XIc9DXqJKlJBr0MXml2AvPOH9fn+P2kqgwL14lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739124174; c=relaxed/simple;
	bh=1LCmIZXIonnKrHv+t++PolAORIH51AdVcrhjNhLmhlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1tYHog57x+l6aGt8lN0Tsa7hGf3KcGLF4u8zxpygrQHmkaag8IX6HAJo4MSCWOnuaIKwGZrsC4cpp8fBzONqe5SiPQQJVtzaHv/WHPuo2Rx38kduXUGHFcC/7skYNMO/qUOPFuuVoLv28QXti/V/SjS2+qo/WZYH1PIbrr4cEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CLVEHzPF; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38633b5dbcfso3597862f8f.2
        for <kvm@vger.kernel.org>; Sun, 09 Feb 2025 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739124170; x=1739728970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yMwisbLTZPQf9B0UjycOC84zuSN1/wB/sdDRvv6Iq/k=;
        b=CLVEHzPFtEoiJWry1FGU0PpZqqkbuMXzhSchMoDT5zLSuSO81pTk9pyK+qjkkZEaF5
         oIIZ5x8Fgy3IGJ2hsih7Scm8r9BoAG4Hs9IQ2O43QU8UcQv2Sq1yzKG6jAM8JjU4+Hxx
         R1YJqUOZWFvv1HOWc6111sA+gwcvrUACSoNMOAO5ZEasPP3v9WMg0KvL5/jb0oeAvi+g
         ES7oEBxVur+dR17sSxtxSMd4eAIUkux9eMjrdSbquwSR3A/BBJSgeuRKSDjqeZb69Zuf
         baPq9qsmQSPca52b3jFgnBt5Zg4usYh/qM1OASETe1SUvd1PyVqiW+Xb5PwjdRG7to/o
         N4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739124170; x=1739728970;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMwisbLTZPQf9B0UjycOC84zuSN1/wB/sdDRvv6Iq/k=;
        b=o7oSZb6KGDEE0eG2KXvMz9xfNJ3uL5Bb7+W9eSF9la6dVqeVMHY0k1AuOk5qrUMx6d
         KOTssVsahwy34yLilC44SFIA6x2Ys9cxjBGFE0tGG5qrDSWzptFF/IjhmDfhGbSiLgwg
         Ui20P9yuxAZergxk++o40Uxky70cFN/gW3mQnz7HAcTrd3l+uBXiMpL4494vDIGL2FeX
         YvbfPiAbA997dNgGVf1RB5d+4oyL/51JH+Koi66QPVTZ38J3T/QC8OWJ/Zwjibi9TGl6
         7xjZ6h3jSRKr70DrVG0lrTzI0guIr0AZTmEcXDFW10rBmITpFTf4ZcxlF4THlW3uwjTK
         p5Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUtQCmkDcR4zDTTYrKYAHzme+0P0sWnAoujW2egAT/SBFN+P3l6+N+2kmODRfaTrwWJJ0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYP4LG5ZHSANu9sRxXMXgQP7AhmJSKieshbHtL1g4EYfZR275s
	v7U1QT1qywlLC8Puu2tTDvFbtJrOvR0sjGGojUOBoTxakcfTSS+L5j5bO/FXh8M=
X-Gm-Gg: ASbGncuyQSjEJRw7tFEJnLY1fZUy9FGbyL7esyq59xj50uajbXpMMeFlCbFm1aXb5aj
	iCsvgFBlgszghTLxw1TW4gQXdKL/jLFwR2paulxTIzCL4AmoXctEey2rMQsTlMh8LTBnOq4+kh2
	VQeULW16XcNHlYDBzQVvettzT/kfYNOpchPiRQeiPUobCuEYPAQb+Z0CNDLvixbanm1NtsAlxpr
	sLhv3l0r4lfFBUWaIaUoIfseCSeFDC9cXG/EQb6hmcvtrAjqbM4KFMqm18V+Wn/Ase51xS2xbLa
	hLwaVoRtq38uoBP6XkyZqvw13zHMJb3TrtreqFDjAABrtSkNaF0iA+RYMkQ=
X-Google-Smtp-Source: AGHT+IGQAbR2qXKi7lBuL1ts9BW05beiKW59LHIBwlHBnwy0LTo/WOjbcF3qbr05V0K7c73uEWrw4g==
X-Received: by 2002:a05:6000:144d:b0:38d:df21:a51a with SMTP id ffacd0b85a97d-38ddf21a881mr718786f8f.16.1739124170374;
        Sun, 09 Feb 2025 10:02:50 -0800 (PST)
Received: from [192.168.69.198] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dd2750829sm5198821f8f.7.2025.02.09.10.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2025 10:02:49 -0800 (PST)
Message-ID: <b75deca5-43e4-4b8e-878a-55e4a2373c80@linaro.org>
Date: Sun, 9 Feb 2025 19:02:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] accel: Only include qdev-realized vCPUs in global
 &cpus_queue
To: Igor Mammedov <imammedo@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250207164540.0f9ac1d7@imammedo.users.ipa.redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250207164540.0f9ac1d7@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 16:45, Igor Mammedov wrote:
> On Tue, 28 Jan 2025 15:21:43 +0100
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
>> Hi,
>>
>> The goal of this series is to expose vCPUs in a stable state
>> to the accelerators, in particular the QDev 'REALIZED' step.
> 
> I'll take some of your patches (with Richard's feedback fixed),
> and respin series focusing mostly on realize part.

Great, thank you for helping!

> (and drop wire/unwire parts, reshuffling cpu code instead)
> 
>>
>> To do so we split the QTAILQ_INSERT/REMOVE calls from
>> cpu_list_add() / cpu_list_remove(), by moving them to the
>> DeviceClass::[un]wire() handlers, guaranty to be called just
>> before a vCPU is exposed to the guest, as "realized".
>>
>> First we have to modify how &first_cpu is used in TCG round
>> robin implementation, and ensure we invalidate the TB jmpcache
>> with &qemu_cpu_list locked.
>>
>> I'm really out of my comfort zone here, so posting as RFC. At
>> least all test suite is passing...
>>
>> I expect these changes to allow CPUState::cpu_index clarifications
>> and simplifications, but this will be addressed (and commented) in
>> a separate series.
>>
>> Regards,
>>
>> Phil.


