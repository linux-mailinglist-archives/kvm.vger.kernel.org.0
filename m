Return-Path: <kvm+bounces-42231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A4DA75ED8
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D0D7167A1D
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 06:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BD418A6A7;
	Mon, 31 Mar 2025 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3t52V6G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388DF2C190
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 06:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743402743; cv=none; b=oIQGzIzo2Z5B74dqJQc9sqJ3lEOm1xfzUnMSTT4EtURtbF2HcfWUMZQKxulgc4znQ7yBvDdrj+4NEacpucMl4kxRX/o/PQN22hx4Xf1S3vmDV5CC2U2UmWvvCjGlByOOxe0P4e8aFSIQQ10GsK1Yh3xSDRt2VJdTIlpIbf4ChzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743402743; c=relaxed/simple;
	bh=agaHOg60VrLLxeZkJI3T/8tAvEtzaEf2BEwlNzvFZK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gYNiDVidUBcJ5cc17Yu8YHJRPJPs4a497qKQIEBrGx4IK4WEekPg2O491NCPu58r7K2mk5RooSrxb501rlM3hAYU3Hn7uIFsoyFVePrTYEvSEP/QrZjMOpuWmrhxgtksnBAcXSG3mRbX5y562Jvkfz3llbMZA+awO87GQYg5ouU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3t52V6G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743402739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj+uPbhdX2jDRRq2LjcQpDcOcEDf1LjkYUr8tDy3SUs=;
	b=K3t52V6GgwMir4w8TLltn9pS0wcSF/KwFEa9kCM3ioE0V80I62bTCtzwzSrX7iZUgsUAoZ
	E72HpT09SZLiXqSOJwGYRyQJ92RDHoIO6wFah3H9lQ8pDu6HKx8GDwRFEafYJh3n4Gpsf6
	0Fek2afsQfecUhKf7bNrpwH4zDTPMe4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-HNU_EYEgOQusxLqD7dZBZg-1; Mon, 31 Mar 2025 02:32:16 -0400
X-MC-Unique: HNU_EYEgOQusxLqD7dZBZg-1
X-Mimecast-MFC-AGG-ID: HNU_EYEgOQusxLqD7dZBZg_1743402735
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-223f3357064so65776025ad.3
        for <kvm@vger.kernel.org>; Sun, 30 Mar 2025 23:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743402735; x=1744007535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bj+uPbhdX2jDRRq2LjcQpDcOcEDf1LjkYUr8tDy3SUs=;
        b=WfehVv9AN2ZNBSRibPx1I6MOCNdH5JVYmuXKZFhl/R4oPFkqIGBuv2ZEriXxINj2nU
         uo8S6mnAioA6KJlb8B0e2Tk4cUM4F1y1GExp7SkMfE2mr8Ld/6fKM/GOyxe15QEmb2FW
         Wkuf8Xf7d+F5qoQ6Gy3b/82YEQgbU1x87uZkdwW/iFBG/KA/8ak72xeOhdE20ej4+Cpc
         wsP1bpT2aFS5vIfcjSGhevIB6RMY55dlVcjbSk9LgMrd4FZvw+kMMSFKKHWNpIsDlWIb
         qzpB1PyNuoIlMrwk2peRLu5xLbFjmfOaDBCW3P9Cx+yl4KD7JgwFJfjItAtIsSMciLvJ
         oCug==
X-Forwarded-Encrypted: i=1; AJvYcCXV3J/r+5oeZ2G1pWZ7zyg8eNhILEps6yfeO/NuvC/8NKrhDr6g31+npGPD6grzT2454J8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/KSFPa6puiIUSf4uuXz7VUvrAVH5LrsuA8rQXBmc4LGHneJcQ
	q92OyHLB2iYnucENtuOudjT7yeDyDt58PNGgF8StNtCqxOI+Bde1APAAaW3AGKEVEUJToiAlijF
	eZ1Et+be+8t9+Pzt4Y67LpBIe/d2jHqrorbjFQhfPV55bTivZrA==
X-Gm-Gg: ASbGncvHJOYxM8JHS8WT0pNaFWZAvI5kO9upmWAJFMBAm4GuGOoF9U5TQWABBMCWRbA
	j0b7IVIX9V2XNB3XbDSQ80qgbPSyJD+7i7W5gISVQNjuvfvRHGOUmOukapWGcaheiejpilnO23f
	SjMsDAlizcGqIl9bVQc3dwQXfV8ALZjz1uGdQLQH4pTPCHYSCb66R9WNfeaupaVsOpYVA/uHtmU
	BJ7eeyC3gIqXqJG+NIEdpLcB0/bg5G5+09AEMiKRV6Jxv4/2AqknmBnpbZ/NmlX0ZRYz02Yt1fM
	aErKf/xfJsSpig7RUxKS
X-Received: by 2002:a05:6a00:3d12:b0:736:32d2:aa93 with SMTP id d2e1a72fcca58-73980461abfmr14103499b3a.20.1743402735288;
        Sun, 30 Mar 2025 23:32:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEs8k4qoYwtrF9LTELImaMqZINP524FfVy0bAGagmIfVaPAyGZB2LAMS2lms6/Ug9jADcTQYQ==
X-Received: by 2002:a05:6a00:3d12:b0:736:32d2:aa93 with SMTP id d2e1a72fcca58-73980461abfmr14103450b3a.20.1743402734861;
        Sun, 30 Mar 2025 23:32:14 -0700 (PDT)
Received: from [10.72.116.144] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710dd3d4sm6451950b3a.177.2025.03.30.23.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Mar 2025 23:32:14 -0700 (PDT)
Message-ID: <44dcac55-62d1-4092-9b75-5c26b6d4abed@redhat.com>
Date: Mon, 31 Mar 2025 14:32:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] accel/kvm: Support KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <2fe2a98d-f70f-4996-b04e-d81f66d5863f@redhat.com>
 <Z9zgVKtZyEx3MKuf@intel.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Z9zgVKtZyEx3MKuf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

On 3/21/25 11:43 AM, Zhao Liu wrote:
> Hi Shaoqin,
> 
> Thank you very much for testing!
> 
>> I tried your series on ARM64, but it reports error at compile time, here is
>> the error output:
>>
>> qapi/kvm.json:59:Unexpected indentation.
> 
> I guess this is caused by my invalid format and sphinx complains that,
> as Markus figured out :-(
> 
> What about the following change?
> 
> diff --git a/qapi/kvm.json b/qapi/kvm.json
> index 31447dfeffb0..b383dfd9a788 100644
> --- a/qapi/kvm.json
> +++ b/qapi/kvm.json
> @@ -54,11 +54,6 @@
>   ##
>   # @KVMPMUX86DefalutEvent:
>   #
> -# x86 PMU event encoding with select and umask.
> -# raw_event = ((select & 0xf00UL) << 24) | \
> -#              (select) & 0xff) | \
> -#              ((umask) & 0xff) << 8)
> -#
>   # @select: x86 PMU event select field, which is a 12-bit unsigned
>   #     number.
>   #
> 

This doesn't work for me.

But this works on ARM:

-#              (select) & 0xff) | \
-#              ((umask) & 0xff) << 8)
+# (select) & 0xff) | \
+# ((umask) & 0xff) << 8)


>> While I compiled it on x86, everything is ok. Could you please check why it
>> failed on ARM64?
> 
> Maybe your Arm64 environment doesn't have sphinx_rtd_theme?
> 
> You can check it by:
> 
> python3 -m pip show sphinx_rtd_theme
> 
>> By the mean time, I will review and test this series.
> 
> Thank you again! I also plan to refresh v3, in maybe 1 or 2 weeks.

Ok, Waiting for your new respin. :)

Thanks,
Shaoqin

> 
> Best Regards,
> Zhao
> 
> 

-- 
Shaoqin


