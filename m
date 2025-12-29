Return-Path: <kvm+bounces-66788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BC1CE7C7D
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A78DB30022F4
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6A432B9A7;
	Mon, 29 Dec 2025 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LDtyeRSP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253601E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030867; cv=none; b=NrW61tYflO1ubzt7kVq5Dm+eYWeMTqZWJ2HyKoWDp3irFQ9f4DYlGyEg7SlqA/ReMiwDMTsL63yrfLqMMbRCS9PmTfH1JvMGlUwgIs6IWcoCnws5IGu3iNXLvMyI8FMQEyY4RVU/L3trJmSZO3+/y8NlS+3bC9ENU22AxIkb3Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030867; c=relaxed/simple;
	bh=ZfudRRrjxmfozq2Wd6dQzmYi4utdaQaZ1iCsn7CUmuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jm8HsnTPnHFnWD151jVo6CLnq5sykoL77nCHzoYMvfFQLQZzJzTo85C3/QMA5KKPaDfcEBWPmjSpknW6rapsh0HEoVQQL/sK2DKR0FutVgvPstHPgrwMIX7uXr55uQ2kSocbFV38IchXeyt3aEP8uHeY5PqcxSswnGMyYj/5LwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LDtyeRSP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7f216280242so2844599b3a.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030865; x=1767635665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5mESAwMIaZhTqkXM52ikDUvB0G0HmjkijOpwFN/LSz0=;
        b=LDtyeRSPGSrwCW3zR+DktoN+47r8crCNMTY+iLuvTL6soQLW4QS1SFUhfQIIiicj2G
         KFuXfm7ly5qXhJL8rkAKirlxcw9vuACvsVei51B68A4Vc7rgRkmYCnf40Ji/4SVspYkf
         DSBmjhij9g7jBzdfwqL1q4mdJphFCen/GfLjqP1+FF12EEqL/atUSmAGZZYQbUZQ1MsP
         h7yLbcA4DTQeC6tWrn9fc4J7cnoI5FIdEYNRsJzaSE868JOXy/UPu61iCoDOaynDkSHq
         Grk9UbGJ+g1nBbUR5CUU3DGls+z+9IUFqzoyJYVhjM+Yu6XjO2NwV2FP4ugftp8thwSS
         SxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030865; x=1767635665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mESAwMIaZhTqkXM52ikDUvB0G0HmjkijOpwFN/LSz0=;
        b=br6jFhuCRKlsuJaxnI3DHIPCHQbeKstA41FfSvZKMlKb1z9a3kwYNDBZ+UNcPw0d1g
         n2GDdheVSOp/lM6FyhkaaFUR+Kq1+ulLxwVq6G0xA32z0G6ho4lfdqivZ0Ivh3EA8Nfx
         hV8s1blY+/+eaKYY+YZADsvvI447d7+SJaRv+s9deGza2cYz45RYmsbFpQqDmCJ5pMQb
         RW4ID3rwyVUGw1NFrFU2uSNbu3PKf+QHij6JTyJU4F/zPbUdwaV2SIePWlxFbYf1ZEyV
         yDtlGDsGhKQ2Ixl9hMWjFzgd63jbH5qsN2j1AxfHd6jjXXdCtYSHdcNETKxmjrFMWmjS
         uUug==
X-Forwarded-Encrypted: i=1; AJvYcCWSpWMARZfYAZ8Fy8tPRdjvUsGY38dzJnZV6GH0vCq02mi9UuqKCxgpEp2zvRjrHKDoItM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJSH1k4oMcjWt1wAfQnwP+3sBgKbHl0rtHmuWed3xfwZjxHO04
	PN1og9/YIkhlChcZAKCmbsdZQwzGGhhDe1H9kBzCboykREN1K3WbSAgm9ub+Q55dUZs=
X-Gm-Gg: AY/fxX5H1ZXTtAEpYLpyDOW5Gk/VL9woayqKf/WmcpVeMsv7VQjkaVO2mCqvTqBBI8w
	6jrP56fLSkgXcUsc6pfprDYkaeNbmzY1z2W+TB/M4KFtdXN8mXpXo8ZYwzctGPS+Uu1cZEalwIO
	Q7ZawR8CldlrR6n/R+zFBHQ60e3nB1Vy8XIp/8GFre8KDhwXv40hhxWgsgY2G4fdFSzg/x+1jLA
	aOuouxz8RSaJGybKX6a2ls5TCoMoPnmaLXQjDE60UHQ2f8G2I4YYCkHC5jqgruZCQxQ+hmhUnnK
	YTau9lvR4/t4HnWN+sPpLFlaFVVRB1NzY9xfvA0H+BAhcwI3Wd+vR+/d4WehQYy2d9PsALld1qT
	xdTYmhosxyfxgODgfL9XSmKQ6dQuqbzmIP0YJ2vBYtOTaqRcQx2H5IzALoIpFC3UX6L5pn7wLPj
	mniGzbY2aSWqpifmg4jLo/EnG3tmSWxObaXDsaOMxqpg0XIZfl1YsXCHoPoS9lwyS9510=
X-Google-Smtp-Source: AGHT+IHQ8yYvue4jDg7JeE3lH+Gt+4MdRjzYLTmvkOUCJGp4EE3jFYwbcLmUa8MKW1PV9cUvFd421Q==
X-Received: by 2002:a05:6a21:99aa:b0:366:14b0:4b17 with SMTP id adf61e73a8af0-3769ff1ba96mr30143190637.34.1767030865328;
        Mon, 29 Dec 2025 09:54:25 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c147943sm26110508a12.26.2025.12.29.09.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:54:24 -0800 (PST)
Message-ID: <6f75cae4-817f-495d-98ec-c7af210db9db@linaro.org>
Date: Mon, 29 Dec 2025 09:54:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 14/28] hw, target, accel: whpx: change
 apic_in_platform to kernel_irqchip
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-15-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-15-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Change terminology to match the KVM one, as APIC is x86-specific.
> 
> And move out whpx_irqchip_in_kernel() to make it usable from common
> code even when not compiling with WHPX support.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   accel/stubs/whpx-stub.c        |  1 +
>   accel/whpx/whpx-accel-ops.c    |  2 +-
>   accel/whpx/whpx-common.c       | 10 +---------
>   hw/i386/x86-cpu.c              |  4 ++--
>   include/system/whpx-internal.h |  1 -
>   include/system/whpx.h          |  5 +++--
>   target/i386/cpu-apic.c         |  2 +-
>   target/i386/whpx/whpx-all.c    | 14 +++++++-------
>   8 files changed, 16 insertions(+), 23 deletions(-)  

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


