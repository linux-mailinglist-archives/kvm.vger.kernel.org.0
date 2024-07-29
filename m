Return-Path: <kvm+bounces-22496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7899A93F4A1
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D98F281E20
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 11:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A82B146580;
	Mon, 29 Jul 2024 11:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iaUpb2eh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AE9146015
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 11:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722254091; cv=none; b=bubgFDlx+4tOZz77T/8LlBW55Ok5PS398YD6EZ1g+HufEje+qyio6xeSvgZcesKwxsgttDFfr9ecuwygM6ZZkzQwVp/9SCxr8RNgdcfdLmzfDMv+HnxdVa3yhi4XfeH2/36VXE4KsTixu+lieU66rDNCTgVKgZIEUC6yPTfynh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722254091; c=relaxed/simple;
	bh=gc/0V0fUm0Tkzh2r1n11XAWUxafhXD3tmuEOWcFT43s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tEOg1QmsakoS2o+Nba+RIpgDbVmJ2q8MIK3SRJZZgqJ0yxAMrhl2wWAJpIQ5V7mIKCUwLf2pDe80UXt3fumVQxIXiR371swn5Z8ih9CtDoRWmEW7Tz/7+BjQvqSyxC4HvKDn0Ecg2W4eEEfLoQAyhoimAXEJKv3h3pk1LX+1vEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iaUpb2eh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-428101fa30aso15859045e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 04:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722254088; x=1722858888; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ui2GzqOyf53+BduT2bZbxvFiRlJThGLjySYkf4II08=;
        b=iaUpb2eh/dD1XYTA0vPchqJY675om7bN1u24W7wR37OHf1+7coYIvlnaq7bDCeH0gD
         mIwrdlpmDNHRamSQi2JrndsMDO50EW0WXakdT7Z52xiTKzBtRR0IHCiddI+eo+82cLK1
         NXmGJPeSXluimFGciQ34ubtVcTwhZcj6QBpsNSO0HoskLhnIDzCT94Di/VULvic4j2XI
         Hf1TZjYSpoE9OjttDksOjmFvC237mACzyVYug11WMcVyM59jxEmETUZPi2EwTnQeEtHM
         AZ7SLwjAefLQTctIfq7I0r8Cq42YcwzHgoD8qJEXSy/tNrf6mT9sVkZEaxBDuBpma1t3
         POBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722254088; x=1722858888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ui2GzqOyf53+BduT2bZbxvFiRlJThGLjySYkf4II08=;
        b=NvfNuKSpDkZiFyaZPQ58Gdq4YvP+o1T18RUsjo/dn1jSAVmvaplqqg78bYUWRtlJRW
         DQ0laK0w1ahDSRMZyaiDEV41bsYM2n1ivNngcQNjAHo2h0Ka7Ip4HZLh5ZcWvLyLwfc0
         w44POZyzj8lOiQao11xCHa2ZCF3ckaeAqDl5KPfa/iVtLD9jWtdWVDz7dv+SNIcC9RwD
         +OW2YOxMkAR/X4xM/o9DKEb9EtrzlNQkJ4OUXCnNmwLqwirBW15e5NHtyBtJTV59y4pg
         xjdHi78j/fmMfZMZ8yvcN018YDcQfHtNJbhQPAks8P2uc4FhpqFRU10FyI159pJpcu1h
         fmkw==
X-Forwarded-Encrypted: i=1; AJvYcCX2iAxzD36YjnNNEnJnbUS4FcpQZFUxQb63ACo7dsmFaOtFwQPDI6q86q/Rp3ld/vgnPgTGSGxy/COx/hLirpRJ/4+I
X-Gm-Message-State: AOJu0YxCpJtz0NDZiE7CeF7kfA67STPmD6KECuz8wAKK1FmBPsqTG9ny
	Agie/jybO5Zuir1Pqwp5zjlOyL3uTmg6HRy5tn5XcX7/yMyYBxD8D7b+j4o5T9M=
X-Google-Smtp-Source: AGHT+IHj863gKHFZgln/0mHvZ8mw+pDVh0OE4eOA7e5u0e+MLLV5z5cTOwDpSkbnpDIjyWAJw7qzlQ==
X-Received: by 2002:adf:ea10:0:b0:367:9c12:3e64 with SMTP id ffacd0b85a97d-36b5d073efemr5511758f8f.46.1722254087783;
        Mon, 29 Jul 2024 04:54:47 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d98aasm12089148f8f.30.2024.07.29.04.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 04:54:46 -0700 (PDT)
Message-ID: <6dbc898d-be8a-497c-87bb-d13d956cd279@linaro.org>
Date: Mon, 29 Jul 2024 13:54:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/13] tests/avocado: use more distinct names for assets
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-7-crosa@redhat.com> <ZqdzqnpKja7Xo-Yc@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ZqdzqnpKja7Xo-Yc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/7/24 12:49, Daniel P. Berrangé wrote:
> On Fri, Jul 26, 2024 at 09:44:31AM -0400, Cleber Rosa wrote:
>> Avocado's asset system will deposit files in a cache organized either
>> by their original location (the URI) or by their names.  Because the
>> cache (and the "by_name" sub directory) is common across tests, it's a
>> good idea to make these names as distinct as possible.
>>
>> This avoid name clashes, which makes future Avocado runs to attempt to
>> redownload the assets with the same name, but from the different
>> locations they actually are from.  This causes cache misses, extra
>> downloads, and possibly canceled tests.
>>
>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>> ---
>>   tests/avocado/kvm_xen_guest.py  | 3 ++-
>>   tests/avocado/netdev-ethtool.py | 3 ++-
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
>> index f8cb458d5d..318fadebc3 100644
>> --- a/tests/avocado/kvm_xen_guest.py
>> +++ b/tests/avocado/kvm_xen_guest.py
>> @@ -40,7 +40,8 @@ def get_asset(self, name, sha1):
>>           url = base_url + name
>>           # use explicit name rather than failing to neatly parse the
>>           # URL into a unique one
>> -        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
>> +        return self.fetch_asset(name=f"qemu-kvm-xen-guest-{name}",
>> +                                locations=(url), asset_hash=sha1)
> 
> Why do we need to pass a name here at all ? I see the comment here
> but it isn't very clear about what the problem is. It just feels
> wrong to be creating ourselves uniqueness naming problems, when we
> have a nicely unique URL, and that cached URL can be shared across
> tests, where as the custom names added by this patch are forcing
> no-caching of the same URL between tests.

I thought $name was purely for debugging; the file was downloaded
in a temporary location, and if the hash matched, it was renamed
in the cache as $asset_hash which is unique. This was suggested
in order to avoid dealing with URL updates for the same asset.
Isn't it the case?


