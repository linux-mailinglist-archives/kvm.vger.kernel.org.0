Return-Path: <kvm+bounces-22941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F56944BE1
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001F71C24150
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56A21A073F;
	Thu,  1 Aug 2024 12:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NbiQxnB7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420461A0726
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722517054; cv=none; b=FG1dvsaAb3lKhh5dv01kQBI6ZcQKu57xHjUNLHf8SLY3p/gEQOateWb6FPYBIp6hvm8P3XXc8ZcUdTyr2i1LqcL0pHj5vCoGTsVAn/LkSSC7YHY8uz7Cbnq0k+k/R+r4sp1U7ilZuHT1eePVZNIDnZk4CW/zORr4IZh1BVj1uMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722517054; c=relaxed/simple;
	bh=WnMdQKS0zLIjFghBfus3/g9BtdJVkAYlzcHb2nOO4QM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBwOJLB3/VXIoM38O13mnfEHYe9fdNlaYVzYPRKu/6ECrSLSKMRN4d3eqhxZYL9TbYBZd2wHAtqOF/3bPoQlQpuzoJVxx61SakQgjtVLwBaNBgKlx6RGtsWAB4vyknjdaUM06gMDKkd3UqWkmwzjtiwIGJ4vcZRBGZDCp26CGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NbiQxnB7; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3684e8220f9so1142926f8f.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 05:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722517049; x=1723121849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W9BTOh2poU6JigM03HRrC0PUte6Uu+QGv/OjvnAPoog=;
        b=NbiQxnB7SUOQtfE4cST5II8tbQYTmgkDKnwypqJHzAZRmyV/KzN56Igk8xXHmCwdCK
         3CVZwGxQ8V6RvYKY+R5l5Ro40CKIrxKHKNAridczfBc1k6kEerRroOmwlIOOJrMAMZgg
         fX/ZjGGw7UCT7zUQiC8upVnGuYfQ5bZO0/N/uiQI9eEKS3BmOvOpESINRru7rdWaFahp
         iUjNTvx8Im7bQ2qKqrtoq9UVNyAabSw3Q9F9I6cc4q74KLTKZL0ypSW+rkE9Mi6KJdZp
         BEIaMBZyqh90BjH+LeENlUY4kzLNVYNnAKjIxykWaPuWvXnwq/2OZFtaOJNfWNYJ9nQA
         aEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722517049; x=1723121849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W9BTOh2poU6JigM03HRrC0PUte6Uu+QGv/OjvnAPoog=;
        b=uFOFkvnwy8bB/2FwUiCfqKgrNaYl8bkTsFnr7H5k7+KQLg5NVzT5BTHp1cCj8wOdHC
         Tt5eDnrx3lMnoZbDkwhCzInggLqUjYfpVGmugEPzNGLalOK+ySJRPi5srTZOCtmho82p
         pT/DFXJi0ZAhd5Yei5ewgzLcBzOVxtvpBJMwQdhMztkGLFmYjAiD/mx5uIUQEkHemACE
         O3MF40aY1nKG9i4ZLqVrNQhVmvBbaQuFW6FKxOAtU1qWKsGU7NVnYEVvQePBM/IGfHgR
         eUadxPHHVJGsUmLoc5/VPSPhCCsOpSRN0uCB7Lu7v/Z9wx5bICnkEDCnYa8nomLPQGvE
         OXJg==
X-Forwarded-Encrypted: i=1; AJvYcCXeTbmg5aS8f4o8oNeU02Yzbu2/WFderWaR0jq9o5PKAPhltG3Bdzp0T8Mkd1EtvKQBsRQZxFG1TanPGpghuf+hEUA6
X-Gm-Message-State: AOJu0YxCXngNvVWZDooMbPUhbNhsWzDRaSHJnJ1oXkxyzK4SsWkb64CV
	PZ9R//ZuJVU5oWHr8GfO5OyArEvnfa7C8z3C/zZmW38Sw1D6QDzuFSq2ECI8Dec=
X-Google-Smtp-Source: AGHT+IFff809S2Cleb/DVo+qwAck9cEgo3thORGHzF3ijxw5uiish8tFPFDDeHTT4mwpcGte0MOZtw==
X-Received: by 2002:a5d:6509:0:b0:362:4679:b5a with SMTP id ffacd0b85a97d-36bb35c1044mr1423393f8f.16.1722517049398;
        Thu, 01 Aug 2024 05:57:29 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.130.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d95dfsm19358613f8f.35.2024.08.01.05.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 05:57:28 -0700 (PDT)
Message-ID: <a3b0ebf6-47ca-4aad-9489-16458ffd6ff3@linaro.org>
Date: Thu, 1 Aug 2024 14:57:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] tests/avocado/kvm_xen_guest.py: cope with asset RW
 requirements
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-7-crosa@redhat.com>
 <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org>
 <CA+bd_6K5S9yrD6hsBsTmW4+eJpPsquE8Ud9eHZzptUwDrHcpeQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CA+bd_6K5S9yrD6hsBsTmW4+eJpPsquE8Ud9eHZzptUwDrHcpeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/24 05:30, Cleber Rosa wrote:
> On Mon, Dec 11, 2023 at 11:32 AM Philippe Mathieu-Daudé
> <philmd@linaro.org> wrote:
>>
>> On 8/12/23 20:09, Cleber Rosa wrote:
>>> Some of these tests actually require the root filesystem image,
>>> obtained through Avocado's asset feature and kept in a common cache
>>> location, to be writable.
>>>
>>> This makes a distinction between the tests that actually have this
>>> requirement and those who don't.  The goal is to be as safe as
>>> possible, avoiding causing cache misses (because the assets get
>>> modified and thus need to be dowloaded again) while avoid copying the
>>> root filesystem backing file whenever possible.
>>
>> Having cache assets modified is a design issue. We should assume
>> the cache directory as read-only.
>>
> 
> I agree those files should not be modified, but I wonder if you
> thought about any solution to this? Given that the same user writes
> (downloads) those files, do you think setting file permissions between
> the download and the use of the files should be done?

We want to share a cachedir on development hosts with multiple
developers. OK to alter a downloaded file before adding it to
the cache; but then once a file is added/hashed it shouldn't be
modified IMO.

So far this directory is group=RW but we like the ability to track
a read-only directory (like owned by a particular user) and adding
missing assets to current user cachedir, to avoid duplication of
files and waste of network transfer.

> That can make the management of the cache (such as pruning it) either
> require undoing the restriction or being done by a super user.
> 
> Anyway, just curious.
> 
> Regards,
> - Cleber.
> 


