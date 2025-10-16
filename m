Return-Path: <kvm+bounces-60180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A9DBE4CE5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 457C235A1E8
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5432621B9DB;
	Thu, 16 Oct 2025 17:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r996UlU+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC821A453
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634946; cv=none; b=MVYELIhFfgHIsUPETtRIdTx1Xh64E5JHEOFF7HlCb0qsWLSH8E2OZZJ6LDrqFa3YZiy3HmHGCyn4a2+4uB6g/Kld9U3F1hbq4hJNOYuZpURHUm0q1crafLU1FjKncgewQgA21aN2k82zhzjTR+PHAP4cGpCdxiAdvl0wIo0zUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634946; c=relaxed/simple;
	bh=DV2Ex5C2ftxZKgUZh3IOd+jAsOU2FM14E3zyrsaNr6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QNV9aO5EzjPRH7glewZERPGcrip+4gRXVyBOa6v2jY4ltUtCDKZphfnPoWegsWcyGSf64qgndeIAML18+D+JJGBkQLCGB2tERkUos1VlLST1zBBi0O4u6WqWVNRyFWZyFtl76Xjz4G0xiLi1TNopqadavdqH3etK2XrGAj8WrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r996UlU+; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b593def09e3so704181a12.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634944; x=1761239744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uO3Yp50UwJMk/y1zHsdYq7Wk9EzSwK2Trqtqi4Eq1rA=;
        b=r996UlU+O/CDUukwp0CUBrcQWOPyZvu2HF1wbzlWTln22PnspzbPoR7YmFRXBaFqVT
         0aBzhL3D4vkrmGeMjgRufe5x4v67BtYwCmNWkLAOQuTKBQQX9yE8B7KMOaCoBZ5JaKot
         L3i/D8tsxFXnGnJrGqiqS0at5Eou+yb+jNn28AKdnAPoTDhSdeE8hiowjll+eHTqRNde
         kzQ4Z00aX7o6kUqTmJHvXqKtm/w7Arfb8nACR9hDrVaCV31/MV6smSo/sExfY6MIDk/4
         o58wWeR5QXE6boiz8moMGnpTHvdWJUXWICX4jUeUwurWR0FYgkRBCJO772uzAMUWLVjg
         eE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634944; x=1761239744;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uO3Yp50UwJMk/y1zHsdYq7Wk9EzSwK2Trqtqi4Eq1rA=;
        b=XAH0GSDCGNwTJooG+fczn3T3oaMa9zAz+8hHu+4CyjN6KQ5rHZPsfiESCFriZ7sb1t
         cnkB+dIW1sh2SFoq0ufRdqHLxM8WLOBHAqPYRSz52/Nz3uuRvh28NXEHcs4n8FaPTpvW
         uOvFW7l5j4gtMhTLJlgMMChEbOo3m6iFHsf8mZC01VHLFv5osprPOALBh2COrHms9wH6
         sPSHTSWovmS5Q62cWk2PNs6wP2tMI6zta7Y9x1hisETuYJXsEII1THz6+dh6elWXtCAT
         K8v9rKVsjffMxMdkEpNEINe8LaHxX9+0pJO3GJExFVUx1jwQr2/99v7yFAkF/oUTamjR
         8/lw==
X-Forwarded-Encrypted: i=1; AJvYcCXBLcEkHUgqsVTuW5FLOOd9KTkvKlS/sJBQlcbZgR0LC2R/Ac7ARdZoWFRMdT77Y6cTxJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmM2SXGD+qGK0WxjGObSIJOG9J/eipIFk5K8XxvZ21vgau+wUY
	OEdfzjyPTViWqOKx+jdJ5sNuaz+EOWOjOpW8nnAYnX9tp/9BIvJ6yB2VukBCzdz6PGg=
X-Gm-Gg: ASbGncs0EK2G9wCGYLllgcuDlux6pv4hPN+g5cC1Czoi4MnFUeT9Wxu0d8gk504Bc1I
	VHbT3dMypdmSwQRH/1oNdoDAIgiegfhibt3FE1aSAIZyj2Glm9w8yzWfKsEFO3KYBmAdSx+SdHy
	8ttmwYdPrgYTAGc60UTggosmY5KhPzD8dKLIF6CGMCE0pPxZZNb9g9EZPQpTrmSaHtqlM3vc17o
	D2XLbrYwiooHE/5PUMU4tMSKTFII6YV0ZtfvuhqEivMJTA/T10vCtvPm+NA7nFvWogl+YG5ocOL
	cYOiGEEYck7/fAGxoi66IuXHKlE7ZcrCL1G96q22WO0+m5kjLJ9frC6Z7mqMZyG6v9ChPSbPAo7
	5wG5S3cF4pqWGLamphBa6B2UXxAD4pb97p333FIglbDzpwMDP17g6/xvmOyvMwP9J5kervrQoLS
	dSWz9hEXyzMccXsZQlnD1ca+U=
X-Google-Smtp-Source: AGHT+IG8ntzTeyqNtRo+ruJaIAP0uFdEsIN1dMzMYvlk3+/f4KRMCNbUa4vYTIfJVgyQ+KNmV8PtSg==
X-Received: by 2002:a17:903:138a:b0:28e:c9f6:867b with SMTP id d9443c01a7336-290c9cd4adbmr7484625ad.23.1760634944303;
        Thu, 16 Oct 2025 10:15:44 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099ab474fsm35797705ad.86.2025.10.16.10.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:15:43 -0700 (PDT)
Message-ID: <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
Date: Thu, 16 Oct 2025 10:15:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/24] whpx: apic: use non-deprecated APIs to control
 interrupt controller state
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-25-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-25-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> WHvGetVirtualProcessorInterruptControllerState2 and
> WHvSetVirtualProcessorInterruptControllerState2 are
> deprecated since Windows 10 version 2004.
> 
> Use the non-deprecated WHvGetVirtualProcessorState and
> WHvSetVirtualProcessorState when available.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   include/system/whpx-internal.h |  9 +++++++
>   target/i386/whpx/whpx-apic.c   | 46 +++++++++++++++++++++++++---------
>   2 files changed, 43 insertions(+), 12 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


