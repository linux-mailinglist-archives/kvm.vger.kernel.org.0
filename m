Return-Path: <kvm+bounces-40463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D1EA574F7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 386D9179117
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10BC257AF7;
	Fri,  7 Mar 2025 22:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fykoFe2K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFEA664C6
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387075; cv=none; b=UvsLr6axFFTTji2gDbXlXU5la7EMQWs4uob3XRX11AcD9jQeEVGkqi4IOR3iUJohUzWT+0id7G4eLNqMcWrU+I6nkf6sZ0ArtksVHJQOCQLJ1O+OKk7TJg041h/HxX1gtuWfmLhKU4ZEd6wrbYkqeAjPq8RKKwrx9QUlLeZDCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387075; c=relaxed/simple;
	bh=+DIrq+7dfG2S5vjan2gaMyjBzW1VHS/k54JF3oJE1Hw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W76p0FU0HVayssKxYAp5mSDPV/LfwGMVXcDNqpIK/+NGLBn+vTyI18cbFShS+jl42s07bXtAf3WgZsJgx59D9U3INPVqVkndsNOXFrNZ28aRuVIRhI4s9sM0ApZ3uyFL1yRTibAyTSB9Zbn5BBqbZM6P+tDpxx05DkyPBxqyB2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fykoFe2K; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43bc6a6aaf7so18410015e9.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 14:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741387072; x=1741991872; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e4rleLc94EIeJq/5s9DmHx8jo6DISQiC04wrdGtPmL8=;
        b=fykoFe2KzQUjV3A2RuM4y7rGpGiBkoPoCRi5uBSE3Sgt1b/hDs9y8TnevRVwQGZr4G
         npxDPTgGMskkALV4A9xShvamOn9o3HKkGYXV2TKXqRrIB7sUTy0cLP54LaKSnCmuWjLL
         yfStbNARVNAP4N+IaFJNnHwZnBT/3xJZI50k4bDqQQDPGKv6E4ggtk+J+7yDkvJHZdxy
         LSNMAcRYckzGau+lnpgrk+JE6jKBl+wJ7r9GpwuBZ3QIhvAQ6UiCAe/sw3kFmS4qHhJM
         7+Xa0Sip9sO+VkKQaq7dCdkugChzN1+zy4MQQESrMdXLEseSgk3v2kQQaOVMbUCZpXul
         GZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741387072; x=1741991872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4rleLc94EIeJq/5s9DmHx8jo6DISQiC04wrdGtPmL8=;
        b=kLtchmHNaOw3Hgy2JBKCyTdnr293sbWY1pcQ8nuYDKln7sSjs00Pd4xpsUkqQqM5EA
         0XYdR4NtW0x74e4HtjMX9X5IkIWHldodpfRPCgKw8b3HC3X2JVUW8qDHbsx3Nh9gvbS2
         sjYGZg33T6Yosu70zQvgdl3sNUswQ4cGKTOR4BYw1y96ZhWN8VAoyAH9UbJfKOFVK6vQ
         vzar5v+VVAp87HrKMeVsKW0B0XAynbPZpya1Vhg4xk1imGA2p69cWrHl1mOzfiuz70Ut
         ssU4yPqRR8M5wpB0QqKRkpkkGVUyM8kp9zckCCY0I4vO251xlfcalaTFw221i013oIOa
         w4sg==
X-Forwarded-Encrypted: i=1; AJvYcCXwM6ebXCTzFl5fb99x63I/fGyl6y/NdX6XgXxoDnor69I8FWetom59IPqElZyPHjXNDt4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN5OwFyK8I7evYMydsPPHYwamac/bFbBpNkNuDXEbozhD9UYDW
	a6WWDShHdeUJFyTUmXkGmMg0D9lHJ4sFx7H2jQTKFVgx+Jf3XOyJyNTweYFRs7w=
X-Gm-Gg: ASbGncsjbGzzrCWY3t9X0/OdecPdsBwXYyniAtH5lfx6O2IIE7FXuS/nCesgPIl8wd4
	3KdZOGTj4YlexkhdnnrO5oOKRVW69ewsEo4F/olrWzWFLSTjnkQeHct1z4eWywbebz0N9XMWAWA
	A7NksQIjWS7K71AYfpkd68ExccoKVVC99OF+AIFSuiSe7UAtf9gK38LvNQ4IeGZikn6zxAOQAry
	MhYWWcNy2v9E83j2hQ/LFeac/VCXWKNN4nPsRrDm4I9CLc6FbKPiASHiWcol2Qm4bcvE1PAMPoH
	st+ummaOGEuf76CPlJU+JVE+U8j2J5CGCw54J6/cSFZzJyBbTSDmXuiaUVMgiiEAc2dGcFqzg35
	38T+0nriQyIDQ
X-Google-Smtp-Source: AGHT+IGm6i4jn7/777fdWMH9irN0kdXHGTTez+ymNzVtUCzZNfBnC94C/cJUt846w13DX8FWoIrTzA==
X-Received: by 2002:a05:6000:2cb:b0:391:2da8:6e26 with SMTP id ffacd0b85a97d-39132dc402cmr3675207f8f.52.1741387072341;
        Fri, 07 Mar 2025 14:37:52 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01de21sm6778385f8f.59.2025.03.07.14.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 14:37:51 -0800 (PST)
Message-ID: <df3f78ab-5d47-4c11-8a4e-062b2bd47085@linaro.org>
Date: Fri, 7 Mar 2025 23:37:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-devel@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, richard.henderson@linaro.org,
 manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
 <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 23:31, Maciej S. Szmigiero wrote:
> Hi Philippe,
> 
> On 7.03.2025 23:25, Philippe Mathieu-Daudé wrote:
>> Hi Maciej,
>>
>> On 7/3/25 22:56, Pierrick Bouvier wrote:
>>> Work towards having a single binary, by removing duplicated object 
>>> files.
>>
>>> Pierrick Bouvier (7):
>>>    hw/hyperv/hv-balloon-stub: common compilation unit
>>>    hw/hyperv/hyperv.h: header cleanup
>>>    hw/hyperv/vmbus: common compilation unit
>>>    hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>>>    hw/hyperv/syndbg: common compilation unit
>>>    hw/hyperv/balloon: common balloon compilation units
>>>    hw/hyperv/hyperv_testdev: common compilation unit
>>
>> If you are happy with this series and provide your Ack-by tag,
>> I can take it in my next hw-misc pull request if that helps.
> 
> There's nothing obviously wrong in the patch set,
> but if we can defer this to Monday then I could do
> a runtime check with a Windows VM too.

Thanks, no rush on my side :)

