Return-Path: <kvm+bounces-17340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 015408C45D2
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFBF3282B42
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A5521342;
	Mon, 13 May 2024 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXQC96iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DD21CFB2
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620549; cv=none; b=eiZrRnOYG9qE3IY/c1RS+S4qySo4pfVBVeSOPExnBG/97w+p1UeCQd+DOBP2Tkki5WUC91xQt2crnFb/HyQfmO9M99Vh4Ii4WvZS6pdUYVFntTLQkVHcHiHDjiTiM6liZSoVT7XA9BskNbYhhUFACr/D0ICZZ42qqrr30BlJIlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620549; c=relaxed/simple;
	bh=Kpqsl0XSnFWNY3VT/3iCR1YsNFUYLpITGe1YGMB5gWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K29psEfDfAW81prG7kMglMiGLENdRRWh6ipuUm0iz451AZcwg776aCL8FbejXvxY0HV8OrAGeMp/QbyyQZNZ9MOdJPJGi7cix4fORw4t5AjarQXdTL6AEZQ+OW19l7mg3Epf1SipoSq1bXYWQNSiEp7kzt8m3kjnAP2+O2Oj6vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXQC96iq; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7e1b8606bfdso24893339f.3
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 10:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715620547; x=1716225347; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dkhS35s9f4IrzQ+xDWVyzbK3FS+T/wMMOlTPXDBz7SM=;
        b=PXQC96iqmBFhpewiiaLtUIx131w4X7zkSiQZxwfApKEPDJEQEtsPPmCIcvbdbP2wYa
         us10KJPxTokfHPdI9HRhhdpBvIDR2uQo5FP6rhS6lZHpf9YqMIy4B+DsJubBXBC55R1v
         tgI34GZ7lmdKolCGMIlKVzmuaG/JIWgkUJwtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715620547; x=1716225347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkhS35s9f4IrzQ+xDWVyzbK3FS+T/wMMOlTPXDBz7SM=;
        b=O1/G6yZw1q7OInuvdILiB5kzXNEevXuofyJ6hkO8sPBjkBb1sIZjF8+cBBP1Tn9ez/
         F2ts4uHvOwRxY3d3fFCBdDO9WP8Emgx+jjLrNJmxwF6jLHZUtXM3YovarYt4zGiAXScq
         +fbq9TyaodyxeisFGwRYHDpw+7BhLMJQ/62PB+R8xYkPa/7YR8KrWnOwHohdwOhiTzKk
         wsP1faLD6Tk386ri99lbOwCKQLfDPS2csJl41uVsOwCZ8WNDQL6CaKQnd2o49YARaeNf
         PH4t9L5RDsC2ASd9QdGIZgCAYXoJrmzJxp4WDGhhUcJv9tg0ErPnjhhLx/FDZoadfqBP
         PBLg==
X-Forwarded-Encrypted: i=1; AJvYcCVWMPubZqUmLYbdjUv8sSNVuPzycf0VixgNnUYpg33jwphjCwQCVA4FXpW97kUtnEP7jB+xQwLygWDQOlTQ8YIF4VIK
X-Gm-Message-State: AOJu0YyrrTq7Ofevc4LqIha9GI3kamddgvl4rQqnjs0p9xSp0ekIYuB/
	xRqL5x8TLlNX8D9z3JE93QxiBS/us2RK+H/xFsUmr4Jrup4MwdQ9h5yN8gUbRd4=
X-Google-Smtp-Source: AGHT+IEsUUvesNSzDOZXBVwOpH/mJvxScDlUqihZEzqBcc1/za2BRTRLILpTeNLwc1aaK6xtRTtPOg==
X-Received: by 2002:a6b:5007:0:b0:7de:b4dc:9b8f with SMTP id ca18e2360f4ac-7e1b5238e16mr1143476539f.2.1715620547263;
        Mon, 13 May 2024 10:15:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4893714d92esm2559667173.75.2024.05.13.10.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 10:15:46 -0700 (PDT)
Message-ID: <6016b316-d266-48cf-aca9-127c72f9681b@linuxfoundation.org>
Date: Mon, 13 May 2024 11:15:45 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] Kselftest fixes for v6.9
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
 Brendan Higgins <brendanhiggins@google.com>,
 Christian Brauner <brauner@kernel.org>, David Gow <davidgow@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
 Kees Cook <keescook@chromium.org>, Mark Brown <broonie@kernel.org>,
 Ron Economos <re@w6rz.net>, Ronald Warsow <rwarsow@gmx.de>,
 Sasha Levin <sashal@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Shengyu Li <shengyu.li.evgeny@gmail.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Will Drewry <wad@chromium.org>,
 kernel test robot <oliver.sang@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 shuah <shuah@kernel.org>
References: <20240512105657.931466-1-mic@digikod.net>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240512105657.931466-1-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/12/24 04:56, Mickaël Salaün wrote:
> Hi Linus,
> 
> Without reply from Shuah, and given the importance of these fixes [1], here is
> a PR to fix Kselftest (broken since v6.9-rc1) for at least KVM, pidfd, and
> Landlock.  I cannot test against all kselftests though.  This has been in
> linux-next since the beginning of this week, and so far only one issue has been
> reported [2] and fixed [3].
> 
> Feel free to take this PR if you see fit.

Thank you - I totally missed the emails about sending these up for 6.9 :(

I see that these are already in Linux 6.9

thanks,
-- Shuah


