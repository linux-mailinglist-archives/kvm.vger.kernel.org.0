Return-Path: <kvm+bounces-45161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D57AA6367
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4D737AB379
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B6D224B15;
	Thu,  1 May 2025 19:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Kbeosacb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCA2236FA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126279; cv=none; b=or9yqP3tTT7PTChGGDLxfLxZYOn9XBccHrGeD/Hg7rhOoKcZ00kl9QhEOyqk+4Qxu9FNxrUmEZs8yEAIvUMtSupcewS0IKBKtAtylUvBbjv/+Ac0kpX4FPtv93vR4d5l6yfYVAvVtSxXv/pXkOEPS0Ng6+/mFx2GcHe77NmqQ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126279; c=relaxed/simple;
	bh=9u+mntl83gDNLJbDIOdvJGh/tzTMpiUiIyIKKjhp5AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lnR1ETryrqUf6G8ctoRrg1dYD6C1QTEh/RBq4qe5UwiB33i4YAMJ8WzPAJpJNFt5LxVr3jE4sQeLPDt7X5zQ9Hen5UwF9zWGZrwpAeEVFK5sfBrae25Q5ZdV5YN7flcORli2PXcbIVvWRh7sbe6WkBjPEEGtRPletzmRElsOXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Kbeosacb; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8644aa73dfcso48013339f.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746126276; x=1746731076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K4YDmSyud6q/pard33P/Y1HZdOYsUvHM646Z9mKyr3s=;
        b=Kbeosacbbx59EpfW4/ftav9CkCtFCswkbPFfZHOu64XhLpwqgTSlY1GQ35+VIYezlP
         gZBkVwTU16cOYp6X7Dmis46sOujiFUoVsZwcq/t7t1G/7Uq4Qr3wFRn1C9DOMYQ5qHus
         7cXlbNfwQZFRMt53Eq3aU1X9s03Dm8SpXT5vf04asniAAPKgqINydFYbkM62yeIFJkZo
         8ZYnKkGAZY03t66811HyEbeYfC7sLYBaIR/hH8DhLuRARPAPK0DrpUaMnV5y9vcZ5NXS
         J8CT0JEf8hFMAOc2AmIeiYvgCVneGsm5qAqnNWF3rw0TqAV2XP/zHBA8BMXGJ2rtGlhr
         cvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746126276; x=1746731076;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4YDmSyud6q/pard33P/Y1HZdOYsUvHM646Z9mKyr3s=;
        b=IhM22NbWFqHzFMO53CSyD3BmcbH4Lsz+GI+EbGEKzOXNQniQ/2oP6TjmNMoFFOLt/H
         IwtsahEUwtel2cnSLQEd0jTZhLsPLoJsm0VS62o0FDuuE4gDKEoTUgfoljAoH+cSWp5K
         Btb2OzCatzKIeq/lFiIwUMSEZOzEmVKK5iMj07z1hFuvRj7hr29i4MrQzOGLg42rovOb
         8TNbYrS3riOuBSLXiqSdejsDKwdTsMTEWbLEffVUpTQtvspkwHKerp3+wJaRCRZpJkNV
         v8vBp8T28cC35dV5qq+c9mqu/aWaKDxG0RhrHT0JYM7ameZ0TKxSgFB0zEyUfQqqRd0n
         Lz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1ertMCixEaJzTaQY2aueIvRXDOmR5IBpzSo5Iol0BytAA86bzERESilTRQbg/KU9obQk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3gXwYsCIWItkUNTt0KrdQAYRBpbqB6QWEoTGf6yNpr7xd0WpN
	ee3xiyFWB0OUylws3vAqs1/HOrc9XJnuGyTrml9qY4/aeAfld5QSfGLE74qcWMM=
X-Gm-Gg: ASbGncsCIrv7o2B5eUlYzP4R7o44q2u55SKEQCFyy3VvU/RNJP7kEA7Xxh/zkAdX5Ns
	RluySgOJTGnEVo3DaJsXI2UiM+OEQvyhyYBawS0TNuE7aU6uWiRMwbAGgnac7o+8ISdkETPKbfB
	+A//6Ck2wSy2j5PtpEQVz4CxD4X6PPFTll3WpyrybeH2zYwskUewHKyp2P4lMowbScHDxLyApf6
	i4xxxdGmHM96OTeUC+XsDsbYGHjC21b7wNd6CrEaAT2+jtT/lUfWr61u0iD4lf0RYSY0/LpVxuE
	aJY7dg6YXK56pK59QlpXAZTYnYGRpr0JIPQ66S15SH6oNTLnqYHJ+xHYaphS/0lktgMeJPsofPW
	F5ya3g2kcp64Kog==
X-Google-Smtp-Source: AGHT+IES7gfo924cu6NmC6Fpw1p44/31nhllgml6j8ZZP/Q+e4X6+bk0kLicbSEp6P9W/EBJ6lnsOw==
X-Received: by 2002:a05:6602:401b:b0:85b:3677:fa8b with SMTP id ca18e2360f4ac-866b424e060mr41003939f.13.1746126276702;
        Thu, 01 May 2025 12:04:36 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a8cda94sm3393173.18.2025.05.01.12.04.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:04:36 -0700 (PDT)
Message-ID: <e8976a2f-b050-415b-912d-3f2231f20fa8@linaro.org>
Date: Thu, 1 May 2025 21:04:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/33] target/arm/cpu: move arm_cpu_kvm_set_irq to
 kvm.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-7-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-7-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

(why?)

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h  |  2 ++
>   target/arm/cpu.c      | 31 -------------------------------
>   target/arm/kvm-stub.c |  5 +++++
>   target/arm/kvm.c      | 29 +++++++++++++++++++++++++++++
>   4 files changed, 36 insertions(+), 31 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


