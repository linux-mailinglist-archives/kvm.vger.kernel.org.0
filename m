Return-Path: <kvm+bounces-51346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F848AF6412
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0CD21C459A6
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1980D23C50F;
	Wed,  2 Jul 2025 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DI/z7Z2t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA42DE705
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751492152; cv=none; b=siqk8nlv2vTWU2v8T3CUp3uqfNIQL3JI+hZ7u6yhQDJIiqIaLES8/xGXxA0rYrk2kOfJm72IdszoBKejQLyEEYcbD4Sd77H731lCdFQ8mM2X0UvtCKomn7p9oomVWatf5yxQcVNNEBrYtnNWr8HOLDjLv57p69H5clLZx6gde+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751492152; c=relaxed/simple;
	bh=8rFtqsimAf0/WSk9GmsOXrlWRArmgdm8S+qKYlJBbP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uroxH87oL3Fnmjc9yuKdcem7IgTkoH9cgvVIl07QKM3TbLE+Io8+WQneU8eG6R3212zWi+xrz1jf98W/bdnF0pwdo0NjQUDBFgkqzGtk0lf/PdWhJg3p+NjGUZsCLWxIg0vXyC4KcDG1Qie4jHgvdPFdsqsRlD62Qq6hG5iu/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DI/z7Z2t; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235ef62066eso93470685ad.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 14:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751492150; x=1752096950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hg0qj/WAsIhSzKk50qSOHcs9sPB5yADg/xMC/cighLg=;
        b=DI/z7Z2tum+2pvoanJ15+pbICC8NsKeAjcUhdocW3Qc6ZhFTqNX2aWI1sr/hcn//g+
         1vowhKxrCV5gf9yth0oy5ubLDWcTmJRIPNGz2lbpkbiKvDQCRfvGhMjfgH9rHQZhQv3r
         c3KhW5onrovWCDIUTtPb10cCMdRRl+xbFDAAT2rEWT8MtLnmUWvtFbKPaHTWrU8Kuti7
         kVpZ6TtOdLnRzfP03uSaW0ZqXVvUZJHHZIFjoCoA3iu1gCRwPGwE2MIxIjy7G+eZgYpp
         xsB2QR/9FiJ8szribTzjCIO4zD6T7jxhEPY3cJiydZYDGWhZGQvr5sWSnfcN9hfEFoFP
         rH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751492150; x=1752096950;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hg0qj/WAsIhSzKk50qSOHcs9sPB5yADg/xMC/cighLg=;
        b=gYtAnKrngyHJU5F07uZ3Mphxaqc0FPkiDefzA+DTXIrrnw2vhR+HYjUxUZg0r+ROre
         B5nuSqy7IaaylAgKm9K/SJycBSLX95IFSDmSfAu60w5/ECJW6IGS3dKrOiM2urmJV/P0
         IhW4Mz5tkImK5Og+esIRHyCKuCK2odDWPUnE6WoqGkUG28dshC7vh1r6gUjGO4r0gM6O
         G3fbYsXKAd5wj/3N0P7KaZH2EeWEQntsvtd3no5wwjs+JHyd/Kqo6Jgcuwo1QMqU6gsR
         MrlQ7JrhPSgWUQq5iyQc4W0X0y+glHhfk88pKKkg/xeHLbvfsbdhmgrjEWPMw3wEQWBM
         9XbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrWOuu7vwshYz2jV5dfhhs7MbjENPAgs9bwpqBLB5KJ5dtNLBiES6v6HzQSk0qR9F/OZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ+k/4wafFx2oY1O56ClPMro2T0B2dIE6EKFexUSo31QVdpru3
	6/OYpneiYfyXWRXNBYzO6trwZr4SQ6JQa5n8PmK+rQ8DpGcyJJiTXeYS2GhL3nAzB0Y=
X-Gm-Gg: ASbGncvu5jaxw4Upj5AxlRK6krU+Y7veytpoiV8055gDrsnhnPyx2yesQqPG2Ygg4fK
	15cfEE4Ry2lSRR4DyfrtF+DeSbv4+FJBvekKmSuP9H6l1ku669sDmrwX+x8sz17P3ZIpHBBeSe0
	OoQxqEH+56rf7YgTUmSeY8sIXiEh/bKGrcqAwVnjElFNlz5mui6iYtEAL+hwztor3HxuRR425Q8
	7x9pmZISeEc4/04MLywtiXgC2g8CrlQV5k6KU00HQadXcEh5w3EjQerbSMwrT+fH+CoXQXXp0S2
	QKN6S2/Joghy59QTNvIqEnib+NsSU94AbvFk1pNaANPPsw6YzICmHY6g1dd/YV/inFgjg5w2NU4
	=
X-Google-Smtp-Source: AGHT+IGpscWHzvkBGYWVvFV40B4JDIxA1z+rgMXJn4WUCElOgiG44deUfbMutc97UiUsHwDJJULrfg==
X-Received: by 2002:a17:903:b8d:b0:233:ab04:27a with SMTP id d9443c01a7336-23c6e5f389emr81341945ad.53.1751492150010;
        Wed, 02 Jul 2025 14:35:50 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39b93fsm136116685ad.119.2025.07.02.14.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 14:35:49 -0700 (PDT)
Message-ID: <0ab88797-7466-4b83-95d8-efdb04369664@linaro.org>
Date: Wed, 2 Jul 2025 14:35:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 59/65] accel: Always register
 AccelOpsClass::get_virtual_clock() handler
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-60-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250702185332.43650-60-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::get_virtual_clock(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/accel-ops.h        | 2 ++
>   accel/hvf/hvf-accel-ops.c         | 1 +
>   accel/kvm/kvm-accel-ops.c         | 1 +
>   accel/tcg/tcg-accel-ops.c         | 2 ++
>   accel/xen/xen-all.c               | 1 +
>   system/cpus.c                     | 7 ++++---
>   target/i386/nvmm/nvmm-accel-ops.c | 1 +
>   target/i386/whpx/whpx-accel-ops.c | 1 +
>   8 files changed, 13 insertions(+), 3 deletions(-)

Seeing the pattern in last 3 commits, I have a question regarding QOM.
Is that possible to get a constructor called for parent type 
(TYPE_ACCEL_OPS), where all default values would be set, and so every 
child class (specialized accelerator) would just need to override the 
field they want with their own method?

It would be more easy than explicitely setting default values in all sub 
classes, but maybe QOM design is limited to that.

