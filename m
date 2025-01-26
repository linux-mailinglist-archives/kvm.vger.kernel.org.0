Return-Path: <kvm+bounces-36635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B12D5A1CEC8
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DD49166D17
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD2817C21B;
	Sun, 26 Jan 2025 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LdyN/ubZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34206A33B
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926494; cv=none; b=jcdJktSiR5hZuEcL9v705h5hup5bRr4YQtkLrDweFvVNO+n6sPFO4lq05F4Hl3k6Y3+zrgzNNqAIkmpYClcl5TObVJX+sYOziOrJaQDdy134A7yGON5QqOBa+A1ZAx6tjOsKMxpwjXh/WhA+EwWjO6VKgPDup4Qnxj9cireDCmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926494; c=relaxed/simple;
	bh=wAxtQeBDN+yaAUTm+5i7te5ydIKrj4KwmP0g3toDI/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=erQlSSwpa1fdEZXmNWdmB5tFyPIij3VCiBcCPr1aaEKHMtasSXu7X8O9gqiSdvjF3/ssCgYtcWzxKqBITtOiaXCUF/jzrKvA55Z+boV4WHa02m5B7sGdcz47/ckvnPx9veD7a45m5qhjKZ5H3SfaHDU4WPlGzqJXRc6SpGhPPNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LdyN/ubZ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-216426b0865so60967345ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737926492; x=1738531292; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QYxKemM/xZvwRVD9aoAgaA6gwfgdoNiv4c107IIPZT4=;
        b=LdyN/ubZwdaDItHOpJlt7P34p8/0aOrKawCsB3N9LJ9eA37tT6amvGWkpGuYvx5D7z
         STE+7yUZ4aD4lmKCu7XGWStZWw/nJsnIxvbEd4OPe3LohRFoubteIH0M0L7MRVArR8mD
         /7pLodGeCMpiCQSEhfbzlx4EDMIU8GVOpnfk6zyJflrWfGWKS1YF8u64IEamnNa+brJ/
         Rkf1vVKaO51EOK7JooeSk5trbcRIX/e5vskzJUnb2YucWOONweBkrO1t/2trszTCbxnU
         XeC6YyvMGyYtlIMJrNR3uC4hjDHeAo8vadWK/P2G9zNQn6SerVBURC/tJVpYACqqa+UM
         uP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737926492; x=1738531292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QYxKemM/xZvwRVD9aoAgaA6gwfgdoNiv4c107IIPZT4=;
        b=R70OrK/wwC48t38CtNudJecUVZhVdtkiErmFiDRHvTs8Ogq2OHVpx/zEZTi+aWqCZb
         H/Ce7WIb+R+FFCEgNx5npFVYZOnSEkiQd0ufjKFpdZHePn6OHhXlO6uM+hgorCJewmF/
         GKLEAklytvxNNhg9pdP5vIt/vjn+q/XuP7EU06kg4Vwqu8m5+QziZ+lgQJWoGUuy2DM5
         w1cIwjIMPNuJ8LZuKksyRAnUHXEUrxh7hXgNJDA96fZv230UricwObUH/NuWZvc9VhFM
         NfdUWf+P0RQM6IGY1lQgLH8rAXrIybutc2Ji6niO3SyNWIBk06RF4euiEaELDvzREN46
         IBOA==
X-Forwarded-Encrypted: i=1; AJvYcCUfdxgrV4uzvsPiTBZdATwdCFtZm4subXNPDkAl8PUJ3EofRkAOwZGoMYBk3p75moDbjQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyxTbVsHX45Y+cJczVwwXmSAxT6xNFXRvw8OGvY3OmyLOvJxwK
	5hMKeHdOlXFLccl3CMlupBp/4ir/GgjIx3O0pMk3H1Varvo+6YZUQoeM/I+7i8I=
X-Gm-Gg: ASbGncua7EFz1nBGYDok5ZJ3sweQpFRLahJZjTkucisQL2YgUbxlmm/OUS2ER4Qr+/9
	zd6n3WXab32lWml7WfP/rF7z/murFGQZJ4KiKNGxFErxguBKsxUKjP4qWUt2OAfAmUhFnZAr8Uf
	D/RbSk6+9SucG6Jv3bBbD0/L003SE+uXYIHc1DEkGIF/Mx6ROrIwGBNsgd4dsV+K+NAtEWgRKZG
	lsROEGt0qBnFmt3eoy1wxROiVsZJtYTZnFu1rob9jTKI4+UvJboOd+V0+LEt+EBJgAH9C4C/iMC
	g4+GmDg8UfKpoWdDmcjFk2GX4eWREaSSKB1wIzUCau8atWk=
X-Google-Smtp-Source: AGHT+IEK/IDwjYTfcGC9vytnhg57Unum7j14HBhQ+TRt9SQk9fY2DLtXa4M3MfHh3b7yHzuy9lAQFA==
X-Received: by 2002:a17:902:c951:b0:216:5268:9aab with SMTP id d9443c01a7336-21c355e832amr552530105ad.46.1737926491907;
        Sun, 26 Jan 2025 13:21:31 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da4141e2dsm50143635ad.124.2025.01.26.13.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:21:31 -0800 (PST)
Message-ID: <6fcaa7b1-ba43-4a3f-a560-5d05a57cdc7c@linaro.org>
Date: Sun, 26 Jan 2025 13:21:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/20] cpus: Have cpu_exec_initfn() per user / system
 emulation
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-19-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-19-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Slighly simplify cpu-target.c again by extracting cpu_exec_initfn()
> to cpu-{system,user}.c, adding an empty stub for user emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
> Good enough for now...
> ---
>   cpu-target.c         | 9 ---------
>   hw/core/cpu-system.c | 7 +++++++
>   hw/core/cpu-user.c   | 5 +++++
>   3 files changed, 12 insertions(+), 9 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

