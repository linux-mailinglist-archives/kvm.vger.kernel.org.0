Return-Path: <kvm+bounces-66786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49AD9CE7C71
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E28F301A1F6
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B0832B98A;
	Mon, 29 Dec 2025 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T7eLYLzi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B921E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030803; cv=none; b=RUlxAnDDPMcJsf2pSpbaxf6yoJ0U7epgENhXVYvnshX8qwdyemQShfBU+JnhC3rhpKK/rBf1F5YqO+04tn8ngMGd1O/ZBt6TNvgXJV3oo+pl6PUCN1cfpcmqS0tIz0Z+QRXV9VQrMYjRnHsLOdPUK9/XavA08YDY8vuG4/aNn04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030803; c=relaxed/simple;
	bh=9mRioX1X32Jh0rouNXGvUWzeEwBIcSxNEMx79y3tggA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rb1aB3qseLPdS0nHwV2zFVfMeXBjBO5elrsns8V9RIpxCyYLsv/cJPDDiAQyPc7+41br+I7EcC9poSRMBrgpNUimlYU6rPA5jCf2RG2MHRYbdvowCXr7JX9mqNp+cqDdS0/PSEIxFwYPvoilu7OVBK7UzzbD2CzKX7QxdAJCa84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T7eLYLzi; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7f89d0b37f0so4520452b3a.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030801; x=1767635601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xKebTEGsUkLdh5Qjx0PteMTKZhXxL5LjtYOii44DHnI=;
        b=T7eLYLziqvOAqZukCE6xUcWg52RHNpMOaInoa3GbCE25KflukBWX3vU1U/N0mCx8FH
         slSROf5k6W6wd8nsOfIAJK+GZyP7eyKLWinkxWfXp6mDF1h7gFKtjxv3rR2gVhJmYIG7
         PRhkoEtBSsazFgCHVaPAFwTi0KMCVt7007BjdWpm8yQLKfJhTT98TP7NxwpKluoZkNiT
         asucvY8RuPYJuJgk+3HWRZ+U2PSjbNGWI8RfvLbFlM3y+VqD7RvDg8ihpJtQrasOLUsr
         SYjgQLoIWH5TnofzXJQwZ8F5ZMaK4ZunUgsr3kao9AE767x5of1eXUmaZg9FQtmu/1HF
         V/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030801; x=1767635601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xKebTEGsUkLdh5Qjx0PteMTKZhXxL5LjtYOii44DHnI=;
        b=s+WpgX6ApiXmt5Ig3QXxwuNBM3hSKmCzIfjwUCmI12SZcADm+fTTopi2NJsnhjelRO
         AMPy9TMrAB0UuInasaaPKfG1cuO9ZKJ+pGjToBoqyV5N/D62x5tR1nTnp0lEEW7eb7/H
         2JeLyFzGKJZpFEDlUx/bvSIpgKwnEL+FWFeGk63qAj27TBbQArOsOVKseZsS33Op8u27
         N9x3Y6HLwrK/be3DMb000wclMr8z0j9MAwnArQ369Hqi/eZdLKkC0vKBohYHBeCqJBVT
         Ie6WvKR5SiHCVB0oUCMsrNAa10gc2TE85tffRHi4tLBIsyfxlQ+V5bmlhMh67L8nu0jZ
         43uw==
X-Forwarded-Encrypted: i=1; AJvYcCVsDFTL6VgXQw1vYKqr7n2c0kbY+aWcXNnleqmDGkzrgvYdUd3DfFtw2q6KKJNLgmcuyyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXIcdWZOwfOkWFKeSlMhCF3TGsjdNzHVICbEVAmm56LIe6oFxv
	CPsgH2op51oFkG9QhBHugTIOhgPlMAcCkLehl4GftDty0+D8DH9v+jlhwb7WCPP2R5c=
X-Gm-Gg: AY/fxX7hhcCmLJusWRkn1vtFvSZRFwQjehcZ6SSZr5HBownHvvlsdGYFQFOH/RMyEgl
	+xLQedcQVRVY4XSti23JQxBcmaIsm5iW4cjKJwikEFlxnm+ihPQTtBHmGa1IO9i7q7okKW6AgPi
	Tp2yFgs5tun3EmGjgaMqf+aQ4zBmYBYWxpJ5e+s4UN7zf0g8MnCggQX+j83sQt3cfDpN9zCvs0b
	vble5HFlIJzU56H0dChDtft4f541t/anci0G+vkutAoASNMn0M6KLH9PahSbSh4upgTc5lIbddc
	9iIECIkXRawQtS0cKxcAjDv3nQWmYy0VS8GXZp5/pKkSOedWH0wutVenFGpCD6awSK9MUbAZZkg
	ouGxDbAaScnbuVc5c4J6FsD+il8wiAtjvvd3xLc1v0WmGE2XCXCht7S6fpMJQmLZ9bbed+bN8jc
	v6Vk5v0ULGSWJgxw5o7MLXMiLVeD3US5xqWmCHwzKyG9Uw+6SuZOFOzd/tA9MJb9Wodm4=
X-Google-Smtp-Source: AGHT+IGVgzQAK/fKu5u3+Z3UqeiiRUCzfsX+fcyo5nUsypedfjWctOq/0yYO4IO5xKpzh8UtaIWt0g==
X-Received: by 2002:a05:6a20:7346:b0:36a:dbc6:2592 with SMTP id adf61e73a8af0-3769f928fb7mr31412985637.31.1767030800854;
        Mon, 29 Dec 2025 09:53:20 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79a164d0sm25942432a12.10.2025.12.29.09.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:53:20 -0800 (PST)
Message-ID: <67b6e092-f03c-4638-a72b-6871958fe31f@linaro.org>
Date: Mon, 29 Dec 2025 09:53:19 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/28] hw: arm: virt-acpi-build: add temporary hack to
 match existing behavior
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
 <20251228235422.30383-9-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-9-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> In the prior Qemu ACPI table handling, GICv2 configurations
> had vms->its=1... That's broken.
> 
> Match that assumption to match the existing ACPI tables that
> have been shipping for quite a while.
> 
> And see what to do for older releases. Likely don't
> want this to be carried around indefinitely.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt-acpi-build.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


