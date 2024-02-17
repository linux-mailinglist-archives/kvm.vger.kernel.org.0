Return-Path: <kvm+bounces-8976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 240448592CF
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5499283FDE
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9028F6A024;
	Sat, 17 Feb 2024 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wp5cBP3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB91D6A4
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708202720; cv=none; b=r+xvvzk+hdvdmVqXSyAx4ykTjS1LEA6PyrFlpPM7r28hbmpgrBnR6wCcZ49DCLUgQbZT6nUNSI3ouar0LGqQVPu/cDtw9mB0lK9nLAga/sailOlTqxxSNin1JiUmvaT9H+TKS496CLfLe9dFqTuEwkFS3HNTPqVyycLMJX6wiiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708202720; c=relaxed/simple;
	bh=pO8xZ0rI0pc0M1GAuuS3lTFs6lnX1hiAnV0is0a9PM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pIRJ21oOuADjYy9DyL5WBYmY7kNY8k8zc5wJYu9TWJG1iFC6SXBx9WDFAzqsRW4etzAZzEFfZb0PQdkspxM3bNdGpkpwiT+klIK7kABBmyAEIaEY49FWYizy9C9hhNJsQh23Ma9SkTtKUoMjOwMdNoKqIVLpLBhTT6JEnrGqh+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wp5cBP3G; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-290b37bb7deso2624918a91.0
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708202718; x=1708807518; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jxx3yRy+wPdldh3Xc5l49IHo+DQaWnfCOpLIPykHwyo=;
        b=Wp5cBP3GJIDJD3ZqLhdtZr3R+E2osSe2iknfGwqAkYAn553sIWOy5kDqqXC/fRo24a
         KvuXuB8A1MzxZtOHm1r9wKKjrABMSy0yeM4mGJOonC+c7kt95koSOy09BIkJsCt9jqJh
         fJyqnHMlqyYRANa280jW+07ilKjs1gxH78nLFNsTc000fiHBQGGMslxs9t9pEF8+CfKy
         08YpXf1JRxU5AQLjKGXG1ZksFMl/PH6yFSHf5hUVCjpTpW42iaMJuJa2BkZpY143JE+q
         a0tY8HX9w8xBIvG6sr16nouT/eSDKuWzAzUDwR3d0KRlFmmC4WJfq9WjgAIuALbFPrl0
         1TjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708202718; x=1708807518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxx3yRy+wPdldh3Xc5l49IHo+DQaWnfCOpLIPykHwyo=;
        b=pfv6GAK1ocwomgfmu6n7LBnBAIxncNkWZZHAJHj3JTtxS9TwB02FyvCOLdKUDU+Zaq
         4ES/Zt0Z+tAd+71Z534UNlT+fp3SbHNnHpLi0XIhhRntynFbVyGAjW9OwMMRfu3a8F0+
         RXWBiCNAvMZrCMVt5ut+51xPkl/Du6cU8wY9C1UbCPwJDqetb+LzU9ob+nB/2QZ5U2it
         jZirnFssOf+/qg4fKUiLpVWCtUcynDLTHHKn78Pa8nQqRKizVEyoJzGx+ddhbCORBHMV
         LLkz+JDDJDLeTBBUcVS+t/3FivUFvdDTMfwI3p0zqVU9NstGgDa38K5IP6cYWK73CSJg
         DbOw==
X-Forwarded-Encrypted: i=1; AJvYcCVp3NvTtDuUX0Cu8FRgscxffBarOvU2pJZwQ7WLeVYMI3LTX6ZflDlRrwUdLhZClqwHMrICb1VUGsU3gX+GiWs/IID2
X-Gm-Message-State: AOJu0Yxi2MmzkE2Z8IuF6em6ujC1RD6Qo5eNmWqFLiwhRDcTRZJbYtH8
	bIaxsp2kN4pmKOBBBbPAZKpX/qt/0nEwEpg1yyEPAHSgeYMP2zQVoEA98MdhPnw=
X-Google-Smtp-Source: AGHT+IFKSRClkZKYyR3HbMJvBS92BRGuLIZ1xyWpSzzVfELVWTdFq+ZxRlJswl4xgizAW5FBIXhdGg==
X-Received: by 2002:a17:90b:30d0:b0:299:5579:33af with SMTP id hi16-20020a17090b30d000b00299557933afmr1744510pjb.20.1708202718170;
        Sat, 17 Feb 2024 12:45:18 -0800 (PST)
Received: from [172.20.1.19] (173-197-098-125.biz.spectrum.com. [173.197.98.125])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090aca8400b00296f2c1d2c9sm2227236pjt.18.2024.02.17.12.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 12:45:17 -0800 (PST)
Message-ID: <7979b6d3-6340-4fd3-8daf-d3a9715e097b@linaro.org>
Date: Sat, 17 Feb 2024 10:45:15 -1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] hw/i386/kvmvapic: Inline sysbus_address_space()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-6-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240216153517.49422-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 05:35, Philippe Mathieu-Daudé wrote:
> sysbus_address_space(...) is a simple wrapper to
> get_system_memory(). Use it in place, since KVM
> VAPIC doesn't distinct address spaces.
> 
> Rename the 'as' variable as 'mr' since it is a
> MemoryRegion type, not an AddressSpace one.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/kvmvapic.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

