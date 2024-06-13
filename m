Return-Path: <kvm+bounces-19568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E52F9067E1
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 10:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E280D1F263BF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C593B13D285;
	Thu, 13 Jun 2024 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yB7N/KbD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A94328F1
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 08:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718269049; cv=none; b=uP+5T2M+hCryZG2MbNDoKyzNq7JMZ/fNjmqgkajkS49yG0wQxdrF6dY5KFT/Fn9n7WooEAchtKUujcuVvdOpKkfKLTQ0MJGr3+mCEhVqqGgUYgdThuqA2mqatT31p3AfnQFXQQX2iW91re4goTHXBKumMmAcL/NDIqjzwNe93nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718269049; c=relaxed/simple;
	bh=l7xfD448Qqaw5a+BKZ+6GLvQK+ABiW/Kxk5tHoTR05k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Us5Vw6492M2rWpsnBfjLFgQ+r9vdTffhf4WQqKMCPd7o393iluxDIzhlcIGpDIX9ouiyuVOWEg1v9T/lDMnoC7Dgo3sUfVpH1EgEFfwV99sIFLCT/zIrUevHXh6yGPO8xUIjuPZAe4DlUO+31lFmRwL0SifdouvuWTqn6Cj6MZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yB7N/KbD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4217a96de38so6592675e9.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 01:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718269045; x=1718873845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O/Oay0j96x/9xQhPy6qZtNnk5WwDamzkfYnPefMdxU4=;
        b=yB7N/KbDyGaJSHYLhGUHXadaMeCHUhIUGtJZNjiBlJ2kxw2fyU7oAuGJLZjqubAFLr
         AoVcr4ETVqEvGxGQu2je0MHUb/2/vbIxDZDd53ilnO0yW/5vbJx7fldYtPOAUi9cGBRa
         OJFNJuKYlaSBegT0BBDx8e/v1csRVHapEozl0D53bgtc+afJXvAbzN8ZsiAPQADsDL/h
         UiSTb9FP3TqVt75RyrXb4EOYzZkfGyKrWTn6sR7tX424d37ndH2wUYW9XB90sBU0MDHT
         hhhbavcE6QiFMpXu735kfv4+DuR4Di28KhtsMIyLmpCVw6WuWUqhOQJtAoCS1WslvQ9Z
         acSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718269045; x=1718873845;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Oay0j96x/9xQhPy6qZtNnk5WwDamzkfYnPefMdxU4=;
        b=B1llM69ZZOiBjFeDc1gPnVb4ANGiXWWwxM7NFWEDsBXc42b6H4ul1zwmXXvnh8BcQr
         HlF41p8NU3DcXtyNpf7EaSWIvq2mbs9kG5g8PnYASOicPf78pDk0qh9B5GM3f58gPS6m
         iZTsK9Q/nyX8Uwq/vrHFDIN+QXkEvMo0jEBaS311fVD5Pjf4JY64CDoP1T6tyB7Fmbmh
         8ApI4x05HqoTbZNv8Hm68CTA3KKo2QU3g6WLSp1MoG5zLHpLXAHUwPaweKQu8CBMnfXs
         XS1n7skWhFXAmBjwZj4z27VwbcfrncduZmnrp7mjUxslIxme/3jPq5dJEWRUkohtWgtM
         +mbg==
X-Forwarded-Encrypted: i=1; AJvYcCX3jQ1pKGdYPlX+/HCIx/Okxe8U+os+G0GIZJkTPgiqRIjAxB4aV4n3kT9Stkx443ts/GLmo7eblyIknHurr/XXH7fM
X-Gm-Message-State: AOJu0YyOx8aMIYdkFNzn6KuJAqV3KfN0ORkCLdQinaK6jiC1V9NpHVzU
	qRdC/xujtKAvdfitYTRWaxg/pbmx+B4IfqGsdqVkYwHMMJxvE5xmLxvl3Kk9Kq4=
X-Google-Smtp-Source: AGHT+IHqQKUydYMvnGx+8GuVXjDzbY5BbQSW9D4GkL9kXgAEi3BIQ6dHiOFa9P8ziL+HL52DDW4cpg==
X-Received: by 2002:a05:600c:310a:b0:422:5b78:1c8f with SMTP id 5b1f17b1804b1-422863a8b77mr33946525e9.8.1718269045561;
        Thu, 13 Jun 2024 01:57:25 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.148.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286fe8fb8sm53929895e9.11.2024.06.13.01.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 01:57:24 -0700 (PDT)
Message-ID: <c4d36875-c70d-4e2c-b3a8-c50459c9db0f@linaro.org>
Date: Thu, 13 Jun 2024 10:57:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] plugins: add time control API
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-9-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240612153508.1532940-9-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/6/24 17:35, Alex Bennée wrote:
> Expose the ability to control time through the plugin API. Only one
> plugin can control time so it has to request control when loaded.
> There are probably more corner cases to catch here.
> 
> From: Alex Bennée <alex.bennee@linaro.org>

Some of your patches include this dubious From: header, maybe strip?

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> [AJB: tweaked user-mode handling]
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20240530220610.1245424-6-pierrick.bouvier@linaro.org>
> 
> ---
> plugins/next
>    - make qemu_plugin_update_ns a NOP in user-mode
> ---
>   include/qemu/qemu-plugin.h   | 25 +++++++++++++++++++++++++
>   plugins/api.c                | 35 +++++++++++++++++++++++++++++++++++
>   plugins/qemu-plugins.symbols |  2 ++
>   3 files changed, 62 insertions(+)


