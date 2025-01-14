Return-Path: <kvm+bounces-35395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FBCA10BEC
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:12:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB051645DD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 16:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB02C1AA1DC;
	Tue, 14 Jan 2025 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wyc48MKF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5F1ADC6E
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736871169; cv=none; b=deiwlkG32WCqXw8AISxCobp0kk8ftNjV8bOBvu43iuEO8IrYhUSRrEqwQMoPB37S+estFq59UZtja/ATd/70iqoxmpK+3wyyJmggVDUV0CgTcjnatacwwqFy/ox1AjbcUyk/LwsDca3W0DobDkjtsmahGLEZiNhTOCkazYVIGpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736871169; c=relaxed/simple;
	bh=DPxSBXYj5+Cie9FQhV3urqAbzP460lDWuePHUdfwhY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlBgmG2WzZb0WkLXBIQZraX2+SVHf5M6vYEXrA7WZuC2A9boCrLHSBy0zzX6+exxOKesnS5WVM8c5wNqxspYMp32/J/ZiVD4cqcoOqUUb8FTA/si52oxKSfxDWfecHQWT0OZCZvjJGPYvYI/muIExJsY4riRbdSB8mSm+WBc8Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wyc48MKF; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so42315955ab.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 08:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736871167; x=1737475967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V1ez0Y9/qkSWPKaIZfJ3AgE1cJ4EV6MroSfCc0eODCI=;
        b=Wyc48MKFtppSHCN2MBVE9SVMi/vgJYflyiVqUGKS6guUyRjTtPo1+emnG/Jo8GYNfF
         s9PMU7ONi4XoU93LYUSPCyRGoRrPkzjMIf8HK1MUeYLqEux5mU+JcdhpMPNkps157K03
         ZjqAgTX+NlAY/4tJGpitGdwBEyZW7F/k/Ngv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736871167; x=1737475967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1ez0Y9/qkSWPKaIZfJ3AgE1cJ4EV6MroSfCc0eODCI=;
        b=V2UwCcDmymI7tqqNbD0JqcUl173YI8DSfpbDzChT9kMfmFcRcKwngP89xwBeInipug
         A6j/V7j15FSRC+dafId6qp5kdAKk81v9hnPLiidQat8HeHlHXHVeHzK4QqfsHwno7DFu
         bY4SDDju+2FJpP17Y73OSn4V1eVu8zGA+VNhQIdXNL+76qfUYopgpCOUqqT8f1X5pEt1
         G5b2h7cwPLDUXeEC7deyuQhPF3ikdc+g60RiOZZHdvt6Q4BIgGlG+AvSTaNjx7/eYlPy
         82LbB5EDHlKJGaBjvgbo+4GMyO+vAeVBxejioWS/DXvvCHM1C+/ETF2GquNc/QUdeLA0
         X1bA==
X-Forwarded-Encrypted: i=1; AJvYcCUyfD2N2j8kQ1Y9r0jB/Eoq/nMoHsrLOyYAkUnmrgvvIGLqBfMyNeNf/OcuFXgtbPL/lI8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg6R9hs9TpU6aFBQIK4dxg3Q5gPchq6JJgpMWffoa14c4NJKAE
	8dd4EzQyPBdkJ60tFkI45teFhB3eLelCTlQTAzSqmI6je7ulBXjLXOeKjHPX9iA=
X-Gm-Gg: ASbGncsFvIT4Nbta9l7TqQDB7GvATszybWQ7GOjfUQcJb4D2NvJeQrnZOUR1pOQvqOD
	YfacdbpZ0a65poAlIIb78KcUP3eNGcXmddlARCViLzppK2WVbU39rR/t8EgdtE/aMt+taHi9LD6
	AqirvvTJguiS2BmGfa6uBwjIE5vA/gRJUVtf5vVygdThGyoP8S96ZL4lmBJYwq+DVMAprKgRuyD
	JQdVW8nERmior3imUY9JN4CjhhxqpHwJ+iNfI/v3lwDBLolEjbDeRFOvNsHnCxSM2g=
X-Google-Smtp-Source: AGHT+IHrpXsovA0TmTlCENO3wBEAm5DshEtDzJ+tfCxG67zi2dsgrXWeJ08LvJG3WrXCFjZLz5iriQ==
X-Received: by 2002:a05:6e02:114f:b0:3ce:7cca:7c0d with SMTP id e9e14a558f8ab-3ce7cca7c40mr17669525ab.12.1736871167110;
        Tue, 14 Jan 2025 08:12:47 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce7d9d720esm3366995ab.70.2025.01.14.08.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:12:46 -0800 (PST)
Message-ID: <af9577f7-71fb-4760-9bd6-c3fc43aa0f30@linuxfoundation.org>
Date: Tue, 14 Jan 2025 09:12:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/rseq: Fix rseq for cases without glibc support
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241210224435.15206-1-rananta@google.com>
 <15339541-8912-4a1f-b5ca-26dd825dfb88@linuxfoundation.org>
 <291b5c9a-af51-4b7a-91de-8408a33f8390@efficios.com>
 <fbfe56d9-863b-4bf4-868c-bc64e0d3e93a@efficios.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <fbfe56d9-863b-4bf4-868c-bc64e0d3e93a@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 07:27, Mathieu Desnoyers wrote:
> On 2025-01-14 09:07, Mathieu Desnoyers wrote:
>> On 2025-01-13 18:06, Shuah Khan wrote:
>>> On 12/10/24 15:44, Raghavendra Rao Ananta wrote:
>>>> Currently the rseq constructor, rseq_init(), assumes that glibc always
>>>> has the support for rseq symbols (__rseq_size for instance). However,
>>>> glibc supports rseq from version 2.35 onwards. As a result, for the
>>>> systems that run glibc less than 2.35, the global rseq_size remains
>>>> initialized to -1U. When a thread then tries to register for rseq,
>>>> get_rseq_min_alloc_size() would end up returning -1U, which is
>>>> incorrect. Hence, initialize rseq_size for the cases where glibc doesn't
>>>> have the support for rseq symbols.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 73a4f5a704a2 ("selftests/rseq: Fix mm_cid test failure")
>>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>>> ---
>>>
>>> Applied to linux_kselftest next for Linux 6.14-rc1 after fixing the
>>> commit if for Fixes tag
>>
>> Hi Shuah,
>>
>> I did not review nor ack this patch. I need to review it carefully
>> to make sure it does not break anything else moving forward.
>>
>> Please wait before merging.
> 
> I am preparing an alternative fix which keeps the selftests
> code in sync with librseq.
> 

Sorry for the mixup. I will go drop this now.

thanks,
-- Shuah

