Return-Path: <kvm+bounces-36805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38291A2135B
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 758B9188983F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49621E7C10;
	Tue, 28 Jan 2025 20:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z1zrNPPt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABFE1B413D
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097867; cv=none; b=ZVlKtETu1qpWkpiDXWL092HMWQecM+4YPOEUlxQwi3leDYF3d6DL+5Dgcm7IO7Pm0fd1cYcMfhEaWQInGvsDpREh5W/5fO79jlYkZo6DUVQby0f6DTD1yGV5JMe4JIR5ZWuYMbWysXwvqXt2fmRQAJYQyPvgRf6PsU6ma+/pfkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097867; c=relaxed/simple;
	bh=u8thISGT2mmeeWQgPouuhF6GQoeDJTzziwaWofUt17s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQHQQaz4W/OGXFtUtR/ismcBxy37gHAQL+KxiFwrI2+ZQRFMOKdCIEH3psjwFEG3AgwucRIrFk9moItEQ27+km+ppgAeyYou5LuqcsETs9Kysc6FdE1N36fEmeHHvRWErw5eVlG7PhQALjl8S4e4O1ipIbr7w/UG8gUx4o1+hYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z1zrNPPt; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-216634dd574so74354725ad.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097865; x=1738702665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e/j3djX5P7cTMr4TvLlyKKfeb806Lm/X7E899vHrlsk=;
        b=z1zrNPPtrwBuxC0XK9k05G9DzIoWOrgkAo7nkAojMBLyLh55bNUat0/ZXVJb/EYL+G
         7sl2qzq4jc/jOSFqKvq0C1Gj/EogrIJEBaTjOdHkxbesx6ON9qXCD54Ld91DjtXM/Bsv
         WOmY+GAzxNhRn82yy+1gNvKrdYwmbDLZvHW5w16+T2VwGD3OiUQignHPt5klGxTLyT9d
         S79sGi00RgsPEzjz7eqz63+6RZI0YqCXeaF4q/JlHYarCScPjegPtNohyL+J44ugvHZV
         Jteolc+6cuexKtL9TSTOVi9nYAIytKGHQ30gBGdzAePWD59E9Z8feRuwuBpeB+g2Ts8D
         necQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097865; x=1738702665;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/j3djX5P7cTMr4TvLlyKKfeb806Lm/X7E899vHrlsk=;
        b=iQx9aye8M/3kBmrv5lT6zxqcwln44RLG0Q95wMJHHUL3Yv+7yD2oeCWKL0xUhkyg56
         xYZ0AByTvyjafShbT+/YQQelEEA1UM2ozqCFm46Ay45TCXxDeQj2Lv7CPN46EiAsFelS
         DuO8keAa80iysxVEIFWGzBzPVgD8fqBDk/HQYOnd775ZmsRU0l/w1sRjmNFRn/Hh/DB0
         EmMFnO1fXI98mcaZWlrWX3Y3GNLplzajPCEQVJn8JwqI+vk0J2+5TJQTiti+SRubPdlc
         bVZ8s9IP12lEj9pNkqlkt0IotnZbaSOMt2fHqiLDa3qkV8wD/HZWkS5XjlV6UyGM0SNu
         nZIw==
X-Forwarded-Encrypted: i=1; AJvYcCUmG4/cEEUTAeVbgkqlI7xc74dii7UxUIjiO96mH0qQ0nJJmcRKuc7RlE3/VMHFHaUOgxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKx7UMzd1zBqYXhpYZc7t/Da2BM1oWp9OCuDDtMSthKUMVF3Ec
	QdltNffhD2QJ2XviSCfoLXPv76O0u7NnQRonMEBbmDmkK4fvXg17kKuX1S4bvCw=
X-Gm-Gg: ASbGnctQ815W5DTSFQ+ZlWQG0fANDWIW5WPie39QObZ58uiEqD2mRB3m0ckzZhxfpBz
	Lwt4XhxHkYD7qvDAgF9AyAFGuVCxQettWXlCjoGxR91QSIRZAdRu/LP1W6pHpEWDptRqydq7DSy
	MhWdNmvq+0JZevk4dvGV0oEP/RXJRx/iIJqm2YusAw6RjV45P0UXo/3nRk1VxI+oMPjufv3R+pL
	4gZPp7TLahAvtyioMvedFURDBCWSgrTKgf2w0GViTeK6UieKbO2yrp260UVIQj1drajknrTkPmY
	Z3RbbJfWG/m1uDJDddrXxwfFLFkvqLw36ouoXLbm3+KuAbc0nKckiwD6jA==
X-Google-Smtp-Source: AGHT+IGQmS1U5TkD55lT94xgjJt77H1Ps9AbI7rFVFqB9Sq1Vn3WnMDmHybZ62mb6aXiObb2eeAIHg==
X-Received: by 2002:a05:6a00:10d4:b0:72d:8fa2:99ac with SMTP id d2e1a72fcca58-72fd0c14853mr796959b3a.13.1738097864710;
        Tue, 28 Jan 2025 12:57:44 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b52f9sm9647208b3a.72.2025.01.28.12.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:57:44 -0800 (PST)
Message-ID: <964bc905-40e2-4394-9470-4950d1a3b887@linaro.org>
Date: Tue, 28 Jan 2025 12:57:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] accel/kvm: Assert vCPU is created when calling
 kvm_dirty_ring_reap*()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-9-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-9-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Previous commits made sure vCPUs are realized before accelerators
> (such KVM) use them. Ensure that by asserting the vCPU is created,
> no need to return.
> 
> For more context, see commit 56adee407fc ("kvm: dirty-ring: Fix race
> with vcpu creation").
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/kvm/kvm-all.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

