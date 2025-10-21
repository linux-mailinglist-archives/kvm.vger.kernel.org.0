Return-Path: <kvm+bounces-60684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B624CBF7880
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DC7E2505460
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A5D342CA2;
	Tue, 21 Oct 2025 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cpOP321G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0589A355051
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062257; cv=none; b=MITmd2axXS+nDMEC1zWE2qSP7lZVwJ/jDi1mVGh7rVoirwjpQPOyf4ezVjCRO9dpW493xcfrVZXTT/ExWJJsxc3n8pxXWqCswNgv7oESTjKR7+tKFny2AH4phcuuT766aADHbvYqhWgCSQiE0M06IFp9+KhpnL4wTrfORnucFYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062257; c=relaxed/simple;
	bh=5DL3qKO7SAGn9UEkGYLagYr9nBg4lI0O7saxL/ly+y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfXx2jZQqFDWRRbGaPCPQ89yAPWVhkfPbe0HSlS2W+FhRchFEU+bi2qwaKxPmsffMIWmMllN/RPnZ2A7V/FWQVm8O350vlGTSL9ms1RmIj+nRxrcJAJpGoS0B6DJauvz6/xIm6fQ371SHGKObapcXcr8paBhbpSMmZJBkAvxV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cpOP321G; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so37719495e9.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761062254; x=1761667054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EmsKfQPb+phFt2HKZnH8E/xSwMnb6ZMpj9GAaYtCOVo=;
        b=cpOP321G4XwB4UdI2MWS+qzjnG3ygWMJarvy8j3b8gxGa7LMdcTMKl5uZESZBbT6XT
         yhYIalL0l9rmsYFo6oWceRBZ88SymrZABebpS4FZTojXFqXmGKmS0/ro0bhXSn+rjNq4
         IK9JH8b9NqXS/WoJKYnKuyKnYY6vKwTgnEpes7+U5qMMnMLn1ApqwZePnZYN9/ZO9z6E
         e+ppFYutNtZhIwt46lH2AiSx92IMdzD7H8J3cksmS1QIONtVm68hLCkXr5iuFhAL6rdz
         rztAA5yopUOX4g8jVq0iJEBxR7uJNiDhBusLdYlFDqfNde1NTkUzZByng+36MZOiLvLy
         yb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062254; x=1761667054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EmsKfQPb+phFt2HKZnH8E/xSwMnb6ZMpj9GAaYtCOVo=;
        b=wsvtS/dc4UtZfWRPTLHCjvFlLWYcWLr2xcPNd+7ds0o4ySMiRAcpDwJnuUGbwfzbp+
         QuLCNNjpxR7vEfUGDLy9nkiNgHSpnFvIkeRRF+PTARmVzxQQ88l9s/XSKP7HcbwE3sMf
         SPbY7CNiOir08xfoT1HdErdto5r2K4B5T/hF6JmUOQzmeaErL3xOLftJ/7werL/K0OMj
         EtMb33aZk4eap7DT6Z7WWcMyQCUqLX+ESjXzHCZTOWg+eOw466q7iWAzQLZMjrto2x6T
         n4OTSu2Ee/1Hv2FYf5GRu9Z0uNiNIflLZkgRwtlkdxQVqCI2Fp81wl4BYvWdHX0qOxsV
         2m2w==
X-Forwarded-Encrypted: i=1; AJvYcCWS+YXZPxzD+dtoHZv/OlYG6halR+b8b0GBXlLDFucaN9w4xSj4CgsR7YL5GmCjISnZiCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrOc8JM91fYnYYPdEeIdpQMe0+aYAuIzf9btmkvESwtciglocT
	AeVFPoYvnDPzVxeB+2YQc0WAq7sz6Nm2XtFHw6fNUIqFoacNaEANYUiGMI3dW2hhBd8=
X-Gm-Gg: ASbGncsNEbCShymBtCwFy9RAiYLmXvM5dogDQ0bxlHC2RCIFf2MIBmX+ylzvHWudA6n
	NuUtD02YNaVB/mD8C9nZkF97dM84N9yt3vypb+Btp7tlpe95PgoeieB0SPJ3WeV1XtQmKJVty+8
	PkFzeL8bnhgyJHlG4IBnVwWAu10JGDiCfqHCZbox+0Vx2Pbv+Q2aCjULm61I3tn+4tFh5Ffa/cX
	tW4zcb/QZyR06a3TVCy2OPfbPJaFfEBbrWYDmP8vqYqR1iD+YZyyf00Me6QNrIimwvq4HG1Ys71
	KUS4v+E673COb8EuFxAUGC7jOgDjVW8tYszISRBGbf+6p105X2Xp/pia+1I3kC1zyKmki8yrqNa
	2ymwEf2sli14n1OZ2UgP8qEQ+CcNp9VI/5PoVt52EWmXiZXQLLjPjNp//IS9QH8yYuecnR2siXH
	nRQn3QtzL5IA58DfX3ZFkQDU9XD6HeyvSI4QCW7QkGbov0m7bLZSUCgQ==
X-Google-Smtp-Source: AGHT+IF1MmWzJKWbkzi17y79YgTkCd9mQLumlvX/g6V6H92HE0rBKfrbkoNhjBpfHnwGz+8efMIeKg==
X-Received: by 2002:a05:600c:458b:b0:471:1702:f41a with SMTP id 5b1f17b1804b1-47117919f1bmr138586925e9.33.1761062254190;
        Tue, 21 Oct 2025 08:57:34 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47154d3843csm201798655e9.11.2025.10.21.08.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:57:33 -0700 (PDT)
Message-ID: <04c7e205-80f3-4f24-aa78-a68c63d2af7a@linaro.org>
Date: Tue, 21 Oct 2025 17:57:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] hw/i386/apic: Prefer APICCommonState over
 DeviceState
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-8-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-8-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:03, Bernhard Beschow wrote:
> Makes the APIC API more type-safe by resolving quite a few APIC_COMMON
> downcasts.

Nice!

> Like PICCommonState, the APICCommonState is now a public typedef while staying
> an abstract datatype.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   include/hw/i386/apic.h           | 33 +++++------
>   include/hw/i386/apic_internal.h  |  7 +--
>   target/i386/cpu.h                |  4 +-
>   target/i386/kvm/kvm_i386.h       |  2 +-
>   target/i386/whpx/whpx-internal.h |  2 +-
>   hw/i386/kvm/apic.c               |  3 +-
>   hw/i386/vapic.c                  |  2 +-
>   hw/i386/x86-cpu.c                |  2 +-
>   hw/intc/apic.c                   | 97 +++++++++++++-------------------
>   hw/intc/apic_common.c            | 56 +++++++-----------
>   target/i386/cpu-apic.c           | 18 +++---
>   target/i386/cpu-dump.c           |  2 +-
>   target/i386/cpu.c                |  2 +-
>   target/i386/kvm/kvm.c            |  2 +-
>   target/i386/whpx/whpx-apic.c     |  3 +-
>   15 files changed, 95 insertions(+), 140 deletions(-)


> -int apic_get_highest_priority_irr(DeviceState *dev)
> +int apic_get_highest_priority_irr(APICCommonState *s)
>   {
> -    APICCommonState *s;
> -
> -    if (!dev) {
> +    if (!s) {
>           /* no interrupts */

Pre-existing dubious check.

>           return -1;
>       }
> -    s = APIC_COMMON(dev);
>       return get_highest_priority_int(s->irr);
>   }

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


