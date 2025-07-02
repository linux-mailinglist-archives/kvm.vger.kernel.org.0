Return-Path: <kvm+bounces-51342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 808B1AF63D5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 447593B34B8
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24780239E90;
	Wed,  2 Jul 2025 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MYmffz+J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C402C2DE700
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751491193; cv=none; b=RavrZiRoHhcrQO6G3QFOPXYu/ubTfYCXdqr0j662061XvJ3m37EAdNWPbQQxTfCQb3vK1P9DJ9QJ/wXIzHT5A2DlyrpJT4bHt4MaS2X57FN+OSKNSa+u/vky+M6XSgPu4Dmob223I1SPk3z4mS2UneBWnCJhFE6dDcxJXuMQNHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751491193; c=relaxed/simple;
	bh=0riy5ykMfBvdlp5wjLxpHeiICspjKTS2e49IyHnkS8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhDdeZkBzm41DmlCQs8xhTZWML/rhZlxNMbjZ2TygND7j4MTWEkHbjLPP0NnB1GniiQhJIqhXjFu73m6vTYyolLs7o1F+y7rnFvsJdyTa0mT0wvdZTs5+OHrbwtmq7jQKvpPOLODmq34+HKCTBc/hnh8iPR0tY8uxDvVrYEUdbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MYmffz+J; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-236192f8770so2123255ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 14:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751491191; x=1752095991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z2oLpuDzuhdHiQaMDk9scXG+1ZBfQnlbCx000gNoXhE=;
        b=MYmffz+JO++7X3bNKO2PoemyxEJsfcUKSyGBMHe0D7ul0kqXllDTaq4RP8IeaOLJ/G
         Q22JGgnjV03CXFIaGju3OVpEpYwxOGUwDP6KYEyRMbMJeCtOziLHjoDF4oHanbtcDZdm
         A8o4e6592y1pAHqktEzS7zzgpVXJTRVOQaJGPiGHqX0nhO/CeqBk+nEYjfCt+8+b+oLR
         O/XLvZ9U5QlAH+RM/R8hUHnJSOqvJY/Q30EpJXdpJqbg0ImOYl2QjnK3xiXVuDg1mhKV
         dJ2pi/s0tDq9AQ9SnuFP4B0izuTLHrvXaWqRCvqACPAtZCiOZuMwsHaRDvoTfqDpZAyR
         Sphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751491191; x=1752095991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2oLpuDzuhdHiQaMDk9scXG+1ZBfQnlbCx000gNoXhE=;
        b=Ba6g+nU1yY9+mMla/HTBQQpAfEu3vukugnzT8eClBPBF4Y15hrBKyXWZ3JEzxWL4jS
         YsRxwk5uM9UL7RgMr/Ql3ikaEWUzUDU2QWgGS8PH3ALkc5uW1q5ctg8GOtuiZTpxtgAE
         cFqcIdjRvTcPcQQaanaV/pcQqDsWEZnOLIf0dmR45rtGczdZm6vbrYzpQ9IuQYOvLfsK
         6XDbmw49+zpQBZCIyeS8S4HviKlPG9k17X0aNETgjJ1Q3ZxBaZ6R1XTwkfY+8Q2NjfH3
         XakfbS0ruHYPJu6hUA+h9y0M6PfEEqGush9sm7Z8h0HPfS0/DjSoXbjPh3uJ5xwvoEA3
         PpYg==
X-Forwarded-Encrypted: i=1; AJvYcCXKMcANKBaFFIFBwSVVw6aGMW+pP10skOIYgu1AOZaXiYwIAuKeLqgi3XqbPK3PCMfq/Ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrXKbubIn7T0w6DczAgz/KuU4nv/ANorHHuTzWlzVKAIWQJkuZ
	5wNk2/NEyjcyTZF4MIR6NF6V99pW5/FERIEAvOq2BhhmiA2CEeWZdl2isqL5VVfONZs=
X-Gm-Gg: ASbGncvEbyKQiR0uhHQXLRM/SaBXKIG68Q8wYiFRkvk4y4VOkN4BY3JL9fNOtKCSJu5
	MRfnaiOg2DsYtk2U69DLEbpipJTQnbSQckmm/Xp9l1o1k4jERHR0HG+FtigksLzVSPLZCmirPE7
	QCcGNNt46eLm/gxb86L1zXZYbeGO1opnC4mwFr0gInukwAwXLAbFH3JLSW36UfbI4I5DP3cq3q8
	iXTQagsRki5MnW90cgwDzHHwdZD9kgWYss0ktWlHzuAnUSKTQDMYsLY/sQBRQ7z8cSNrDMSUF7U
	YGvlEt72xRoRGPTaQS1k9oj+XpcKjfzIEQCghxg4nDQqpj0F/srzP+ddqE4s22+uLgwVqctjatk
	VjjlK/LQH+w==
X-Google-Smtp-Source: AGHT+IEveK9a4pLkComAd6bEMhUh5nd/K1YH+GcPSFUDBL56X19TYihBZ8kJjOvEoyFIVMBoN6XXAg==
X-Received: by 2002:a17:902:f690:b0:221:1497:7b08 with SMTP id d9443c01a7336-23c7942d9b2mr15121325ad.23.1751491190998;
        Wed, 02 Jul 2025 14:19:50 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39b95csm142670205ad.139.2025.07.02.14.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 14:19:50 -0700 (PDT)
Message-ID: <f456a9b8-5e6c-4ed9-aa94-0bb6350052f5@linaro.org>
Date: Wed, 2 Jul 2025 14:19:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 56/65] accel: Expose and register
 generic_handle_interrupt()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-57-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250702185332.43650-57-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::handle_interrupt(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::handle_interrupt() mandatory.
> Expose generic_handle_interrupt() prototype and register it
> for each accelerator.
> 
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/accel-ops.h        | 3 +++
>   accel/hvf/hvf-accel-ops.c         | 1 +
>   accel/kvm/kvm-accel-ops.c         | 1 +
>   accel/qtest/qtest.c               | 1 +
>   accel/xen/xen-all.c               | 1 +
>   system/cpus.c                     | 9 +++------
>   target/i386/nvmm/nvmm-accel-ops.c | 1 +
>   target/i386/whpx/whpx-accel-ops.c | 1 +
>   8 files changed, 12 insertions(+), 6 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


