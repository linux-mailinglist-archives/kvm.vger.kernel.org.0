Return-Path: <kvm+bounces-60871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F09BFF5AD
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 08:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9F7B134E8F6
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 06:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2DD279784;
	Thu, 23 Oct 2025 06:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sJu3QNiM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E775125A0
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 06:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761201205; cv=none; b=sY4xjMHp6auW24zKtu27xLb49ob1cLvljWx372wm3tdPR2GhEluDqjt/jzZd/Q7L9X4qvPksHWGFLHwRqNwmLmMwLBfeXfdk57a1k24JAoSRwf+BJFG7mhTOfp6jVWHVARBLk+uq5TCBJU0JNG3N0+4Mxqy7TmXovvMq10gqTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761201205; c=relaxed/simple;
	bh=u4jO3gJdpOGMK8QVDLp5d3+5Gi2WQZCXcBounBSEMAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwXvO/zyHrHXLoMV18Ufd6RTIneqqW5u+pXYzTWAtbGURut7MghmPUwT3LkQb6E9yxQuUJ4MkgMiMMFI6yUfd83QUOoT+XuT33tccC7OhmVx2R7Z/o1YQt1JHF8uFxz9PvaMjza9z9egNpxySrb6utclE94DX+kmnri4qcF91uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sJu3QNiM; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-471193a9d9eso4231775e9.2
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 23:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761201201; x=1761806001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ff7PfSQ0wkoWpNQv4p5aLpKLKdu8ewPoFgQTZ2hoY8=;
        b=sJu3QNiMiDvOubLC1OsTqOMlEyn7MBWxpq4BDnVqHPvtDLeDV7mDOmbOY1Qecp95OS
         QVBxeWjXNMbwUzjY+1Kt+BHTt2E33VDZeH85LHbIXAlvcXNds4FAf+eV2fRM+FgvQQD5
         GbpjIYor/MJv3f+RaQZYG8FbkX4MQ1cMRYoYe83VuExnjGP3BicLlUAqOVGQAomjEyTE
         Qjbw42Pvo6vmMCOX56zVzVemXxS9U8JXWGGTR5ikXlsq8cKh8ECV+ybdaafW2mG2b3Pd
         mvI1J9KDPgxnzVw/URrOFBh+y4mEP9lquBkYx9hR15dSrdL3tr+52xyw0tXxFIVbT4oR
         4aEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761201201; x=1761806001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ff7PfSQ0wkoWpNQv4p5aLpKLKdu8ewPoFgQTZ2hoY8=;
        b=HAWzNp99+mYv29gyX4/vRyBZmCBfPwB7mEBCLg1fIrUJHOu1aiVCO7sh8mUn8nqHsa
         S75JyC4dU/FD70/9qsTb1L1jvUBDu8DdTqfT17TAGIWU+ngpyWfY0xuJUyjw97VMipF7
         ab4RBCIdM3CM4mRHa4yTkarSHR/fRNJGng7JzaOq4KIo4tsor1LViCpFjZ/3iDW4Mf3a
         4fFrMAs/Hjb6HB+VejxgpE1d4tgpUJcVyRC2xrbc+mQunYpIuuOOmyPue4F8hsS9n4Lw
         k0XPBZcuuOOv0AfkjVyso2vab9/SDsz3BvZnwsaltc1EdDzAX0etdWzGta/13yJXV845
         E6Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXMRYai/H84DF16isCmCqv8LqAp09nB+x7NYnignXZoPKWGAj9mi/2pU+XtOea9A8zYeT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJoAsnStr0uJkj0aAnsWjfZiJnG4IqJ4WbP3noJNdDFzRqRhTi
	Ybt9VOE7qrAxzaQyasa4XX5mqnLLioZmEUSw9rhNK3gv09l+SM5xAyqFx2naFBRsA2s=
X-Gm-Gg: ASbGnctXstUe/08CTXUiGngzzAW/klr/xELbkFsjtNOGkZe0TdYO+IFgSQvGr9aKAcp
	ALAIhMU37/OcYm+D6o1kwE/myYCtEfw3aehfFKVd3tMDnauD7MhiwWl43TJe6ci73By7337pHLt
	OCLVWC0zpx7yLVtAP/uI/vilC6VOVzk5Spkd8S8lo1tgWYifko5Oc+qBtIWskrqWRUVNSJDla9N
	lveE95imsUAIDcYKkAxFHRBVfy2kH2G6hAoS5pFLTJ2eiDibaK2MbwWpnyxWAv4VZyxvny14NHh
	M3i3j3OwcUHTYxkKls3P38Z4nIPTB+cGr7foZ/tmYOCkYoGJCPQnKCCcgwvFaGICOAdtMah+MHF
	fHFKc5QwA5f6IVhkklufYQR0iupb5KXYyI7kaQbxajiUKy+bCb036scwMwm40qytXOVOkCzmjS9
	Q8lYNiMti6eomUn3fahk5pzMPx8ZgpyJRj9TeT4yIraYc=
X-Google-Smtp-Source: AGHT+IGbq5fb4QT+zslQbG5MqZR8ogFfVH4hjbhlhQ6lk6rqp/EFinhN1cNJguTTIBijZ7hLFbrecw==
X-Received: by 2002:a05:600c:1d9b:b0:471:1702:f41c with SMTP id 5b1f17b1804b1-4711791fa29mr175099395e9.35.1761201201567;
        Wed, 22 Oct 2025 23:33:21 -0700 (PDT)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496c14a26sm52354695e9.4.2025.10.22.23.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 23:33:20 -0700 (PDT)
Message-ID: <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
Date: Thu, 23 Oct 2025 08:33:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/24] whpx: apic: use non-deprecated APIs to control
 interrupt controller state
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
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
 <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
 <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/10/25 12:27, Bernhard Beschow wrote:
> 
> 
> Am 16. Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick.bouvier@linaro.org>:
>> On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>>> WHvGetVirtualProcessorInterruptControllerState2 and
>>> WHvSetVirtualProcessorInterruptControllerState2 are
>>> deprecated since Windows 10 version 2004.
>>>
>>> Use the non-deprecated WHvGetVirtualProcessorState and
>>> WHvSetVirtualProcessorState when available.
>>>
>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>>> ---
>>>    include/system/whpx-internal.h |  9 +++++++
>>>    target/i386/whpx/whpx-apic.c   | 46 +++++++++++++++++++++++++---------
>>>    2 files changed, 43 insertions(+), 12 deletions(-)
>>
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> Couldn't we merge this patch already until the rest of the series is figured out?

OK if you provide your Tested-by tag (:


