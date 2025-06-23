Return-Path: <kvm+bounces-50308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C1FAE3EC8
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57F4A172300
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442B3241122;
	Mon, 23 Jun 2025 11:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IHS8nH0F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F109238C07
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679968; cv=none; b=WtKjq93T1K68UhabnzeHFeifUi+R5MiBFbDZlOHZorz7mhvtbVsiAc+SVflK8sj2nlTLaPA9r3tOzB/ZRim3TBvFYqP9RX8UQsmlTJ4YwsYznpjju1irCJimKgXVRi2UsN182ZDpq3pWov5rNcH9n7BYZuDpB03ymL3oI4CJlFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679968; c=relaxed/simple;
	bh=2cdzibxcH5zCGeUFBxOzji3nLbVgfoA2vvEd6g2e4/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=drWRhH07lELCWldk/EPa4BYSGW0Cu7ep7YINL0E/he3v7b29RX/cQD1hcrM820yhXqsz6wiQtjoN5hFLhmpxpNCqBWPfHPTHbmEcyXwrrWaGGGIzsMs0l0SojM+4eIsBMX5Hh3JsiD4cv3EHi5WljPVSIYr8DFJzID98EkVjtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IHS8nH0F; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so2599891f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 04:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750679965; x=1751284765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZNl0GNUoL+pUzh6aZuBV7rBwC2JelgKVfHJY1PQe040=;
        b=IHS8nH0FXjmafV5fT6Xbfecwd5FjiYJz4uBuyV2GHGn7k4DbqPC1vYkmG/jhzDRMbS
         t3oX4bmvgEm6188w0ZNyzGwR45BAtLKm2o8A6kDtgIfAaBggXlaQKRMVzvQ21yMzcM/4
         +iCcwICvlYk3ACcId6oeKmkYMsuep9mcW8m4tu1oHl9pV3PoghyaI73XuF3CCkAguU3U
         s5iYTA2gKTy5InzppcJt64CvR6+8QWP+l7dt3vXmR3kdfTSmJ+KJjsyKyiGTsRrk2Uun
         H6ggTE1SrH+Tc75BBgCcyuu1LfMqhrLwHlWe9QLwSGvCon+meoTj6ZH/ZIJjMa9RyUbJ
         47ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750679965; x=1751284765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNl0GNUoL+pUzh6aZuBV7rBwC2JelgKVfHJY1PQe040=;
        b=UMR9mBzQ8AeIImB1tqxVdL1RAOzSo2tDd1jUKXIXU3JJAwW2BGYVhleCpBzRoaY1XW
         +MVoDWyOfeiCZgamkojvGfVJ706yczr03rq3knttK+1zp+KsJifBPwRid+tZtqIzmx/E
         zWgeXaV7oDYO51JLcmcVv+I8iRaAiCa0boELrWF5j5MK5n6jmCBY8rLPFYBU2xoFuq0g
         Hth/U4im+k+IwzIC+EIizgfyJTiaBfWzfvruUXAwPEVnWaggfewIRnnWwUD/XfGlOw2P
         ryBXME6k3/rJbK/qSW30HaQhPhJRH9tyMnEHiDKSecf//gUfa3yq9nirw7rIvvo1FlBi
         x7sA==
X-Forwarded-Encrypted: i=1; AJvYcCVpahTPQdM5/26C1wSDfXEirgcHLWjrpw5BEp2ZG7ReYYlNRhtu5A0PYgWOCjY971sMpaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYN9QkMWHC5VZG5IJ42KpAjk8tUCj64BXUHobqSopNu8zT3TPn
	ZyzcLlTGfflNhzpx7un/Jpsi3TrKzOU7OBSeobSmbZmapwuTPbOaJ4KxC2bsvkk4sMY=
X-Gm-Gg: ASbGnctaTgR3vOzn5ydLcEwM8m2QFfHPvUGkHuQiKF8JwHRuN2mLHGEekSQAo2Ay8Pc
	zQ5CRjVLdFRHKO4mgrY/68Q6knk5celD08BxScVgZebF5rZnGBfmBiB/CjDJNpl1LfFUeAzy7bx
	HlaII6XRRgNME6qwnS3lL6Bo2fWPPx+xiUULcZfl/hueW4VzuSIMwc0ICqlzmBvYGISlY4HspX6
	V/XAspL07dFhCGyCIVN8c18zPCTnI4yE5m5CbT3VE0NdE5sHg5sgxTBSXz4212y2Y/tQ9QwOBPR
	EV51DiFdLrGW9ZZicXICzLFb5nk2wbgnd0mfI0fDqYjFD76Pbh3D4+CxpGJzXYWw3gIha029uFC
	eoYmb4N+Acbjm+eTG2zGw75VOO0IpGG2sNYXzj+6o
X-Google-Smtp-Source: AGHT+IHOxtkdXSM3EMBB+rtXAYT6HLDRhKe1XTMmCY2e3R+6NO7I2w8zqwom52rHbrwAtgyuUqWVsQ==
X-Received: by 2002:a05:6000:2010:b0:3a3:598f:5a97 with SMTP id ffacd0b85a97d-3a6d2799df4mr8969438f8f.9.1750679964791;
        Mon, 23 Jun 2025 04:59:24 -0700 (PDT)
Received: from [192.168.69.167] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d128cf7asm9177773f8f.100.2025.06.23.04.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 04:59:24 -0700 (PDT)
Message-ID: <be71c7cc-a5ba-4ba5-b697-60814b712eea@linaro.org>
Date: Mon, 23 Jun 2025 13:59:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/26] tests/functional: Restrict nexted Aarch64 Xen
 test to TCG
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 "open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>,
 David Woodhouse <dwmw2@infradead.org>
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-24-philmd@linaro.org>
 <497fc7b1-dfd2-49ad-938c-47fca1153590@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <497fc7b1-dfd2-49ad-938c-47fca1153590@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/6/25 10:11, Thomas Huth wrote:
> On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
>> On macOS this test fails:
>>
>>    qemu-system-aarch64: mach-virt: HVF does not support providing 
>> Virtualization extensions to the guest CPU
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   tests/functional/test_aarch64_xen.py | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tests/functional/test_aarch64_xen.py b/tests/functional/ 
>> test_aarch64_xen.py
>> index 339904221b0..261d796540d 100755
>> --- a/tests/functional/test_aarch64_xen.py
>> +++ b/tests/functional/test_aarch64_xen.py
>> @@ -33,6 +33,7 @@ def launch_xen(self, xen_path):
>>           """
>>           Launch Xen with a dom0 guest kernel
>>           """
>> +        self.require_accelerator("tcg") # virtualization=on
> 
> What about kvm (or xen) as accelerator? Would that work?

IIUC this tests boots a nested Xen guest running at Aarch64 EL2,
and at this point we can only run EL2/EL3 on TCG. HVF and KVM
can not for now (we are working on it).

I don't know if Xen can accelerate EL2, it would need support for
such hardware (like the Apple Silicon M4). Cc'ing Xen folks to
figure it out.

