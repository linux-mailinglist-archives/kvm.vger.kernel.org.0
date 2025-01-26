Return-Path: <kvm+bounces-36621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C370DA1CE4C
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A13F166835
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4C017BEC6;
	Sun, 26 Jan 2025 20:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Unv/lLmF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B25C188A15
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921607; cv=none; b=V+T5cTWsvAOZBMEaaYuGFaIkEPVkEjxDiNGnyYdcfDBz5MDTB/vxTSFkBg1z7rd4PRfMJbG8s+zkVvznHgBEM1pV4fbouXgzGOCEAwxeCqJ3mK1lysWNOESm7qoEoaZm8KINg55bEXdIAeus8bR5epjFsLlA/9am5toCR6IpMN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921607; c=relaxed/simple;
	bh=ElopRU/XpBEdsq6Zu40VBpF2PpQl8h8AYs/jZo3L8rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ne64VO1c/pZr0qSHFcj9jT9MOG3thWvVsYTdySp69Puts+G8zOa65Nb2jhP7ZNJ6eTkUmQnzTnhPQmVxAQs0c2JcnC7qCAVQeFTiB7tZmWq+mWWTCKai7cibQS84AiNk7RsTWv+1LXm6mlcA3bmFzoahHKzXSisuIKuVYv4AeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Unv/lLmF; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f4409fc8fdso5690155a91.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737921605; x=1738526405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvT1nOyyGXJEnkXkKCQj0Xq14BrdlE2RAOYFWR4ybQg=;
        b=Unv/lLmFcpp7EtNhR9WnXMaurFROuDoZzBhVEGEmmeis1pIMv7Nrbg+Gj82rNrhIyP
         2U0wpcAee6QgM5ZGfFLMQHCYffPlpswIB0O7p27f0oLXlIxbpT+STxiOzY6LX3Sj4JG0
         nHhmiB22mosUtn9fCDENfZPYZzWr7U+dk4nm4erHuxD0rQUopLxgVtrVHSbmKGpoWLuk
         NVVGqxokh2dML1tJBONz2imbnV3ffksDSg1+l7OH4345fS9Kr0jPI/QWf27yCw7/3SEd
         IBo67BfvU5SYN14nZwCciWZ3SnfNBRmCOo7R6IcBY7iBfKax6G6mkcsz54HmcXYgsdjr
         13lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921605; x=1738526405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvT1nOyyGXJEnkXkKCQj0Xq14BrdlE2RAOYFWR4ybQg=;
        b=hvuCaaLHqOFkv1UnSoZFuZ+ADPKlTEFVeDwtg3WlSYjhRU3TEL+d1EytnDst+XGTYc
         wk8gkzzF+3AvnDL9F1xAhHxH81IsKhfkf21/oJ13UmfhY3aIoA97+bb+TLBV7p6q+W1t
         pAZB9HLbyB914Orrp6t2zpLsG2SOBNnzvuH9F+vMibY2W1lkp/dnL4Zd2/FC25Cs5/hJ
         6bFEwy12vGjxVV2uGCVjiXSGOdNHRjugP347l0a2bmKzonz3licupZUFD0dgeweCIrWW
         pm6vKn8Up2vQsi9a6GmnuI9WLE2tB4NLuMgXj+U4ohFh5jsJoQW3Z75VNeJn5922ilxK
         wGhA==
X-Forwarded-Encrypted: i=1; AJvYcCVNbthJ7EwGCdCigaRblZ2zPIjrFopiU4rXw/PkTut7PcwzRZOXHyho7C8zESpYpcqI+NU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzalbqyzCua7exTFQv9EHmMWfcQJoKfTfaXh5DSTtaTFKBGs6bI
	hxWFog/65vntgrubtDndioRwsNuWDkZ+YZTLGBUlfdwo8MTYTMHAt2xV63YX5sg=
X-Gm-Gg: ASbGncupJq0Umul9qw2voqwdZ5eQCa7AI7l1p64VlcHhHVt+TZtWuy/8f8nYo579Av5
	ai+S+1V/O/wxc4mOBQ5gSNF0POzll5kYJSjJRayWZmj/b1wcJgtlBgqg0VC47tkcFSlBO3zz8pg
	QhI9WpGNDdmtWhOlGp685fWI8d/QscAFOnx7HiRz10ymTbbqYac+YTVUuzzR9UfHLhTmvsaHx04
	qzFtt7F5+GF+r20OWhAPY/9pqMXPYnkWmvObjVD/Tze8CyDpAcaJhty/tles8hwvRtcLafAHSR1
	SSu135ViCNxInw3umVEiNcmCtJBdGKig6h1IkJ7ApIPbEPM=
X-Google-Smtp-Source: AGHT+IEP4DwQ/u514V5B38J2P62wTL0qYp8JNncl4+5UB0i/l/G/YI+4UbX8eVL0ayMsA+c7B1DDZA==
X-Received: by 2002:a17:90a:f947:b0:2ee:8cbb:de28 with SMTP id 98e67ed59e1d1-2f7f176b184mr25848071a91.8.1737921605198;
        Sun, 26 Jan 2025 12:00:05 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffb1dc56sm6196959a91.49.2025.01.26.12.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:00:04 -0800 (PST)
Message-ID: <ba781224-7b4a-43f6-af25-acb308f11313@linaro.org>
Date: Sun, 26 Jan 2025 12:00:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/20] cpus: Keep default fields initialization in
 cpu_common_initfn()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-6-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:43, Philippe Mathieu-Daudé wrote:
> cpu_common_initfn() is our target agnostic initializer,
> while cpu_exec_initfn() is the target specific one.
> 
> The %as and %num_ases fields are not target specific,
> so initialize them in the common helper.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   cpu-target.c         | 3 ---
>   hw/core/cpu-common.c | 2 ++
>   2 files changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

