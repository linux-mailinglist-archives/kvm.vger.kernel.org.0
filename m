Return-Path: <kvm+bounces-41857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 712C8A6E4BE
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B5BB16A171
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 20:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D0B1DDC37;
	Mon, 24 Mar 2025 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ExwuBYu6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276A1C84A7
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 20:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742849694; cv=none; b=TahxzeQsaDGvIUSyK3f18mSteEc9dGBcTL1Fg6yN6x2HWSpR67q/QJWxTApjEQvc+k/YNOCh9m78JiZdFQCP1nJ8K6u3vRtv2kiCWudCsljbJEMx0eRU79FGpfn44mWgFd0XxzyykO31WlfUCfNDMiaYcXdTRqi3xa7i3TOd3f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742849694; c=relaxed/simple;
	bh=/WbA1YpQFFLroHO8xChvgfJkRX+I/7xoP44Ad1PNZzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ox9riu1fDryEyeE6PCfLQU1Rt/mVwgAuwdSpkapyTiuciy45KxLKrD/sRg9nRr/ZMttMduMWxM2pAnXIgqV/MBV7kMZz4EzouOKdiQ+9D7eiVKrT6yDIL/ZNLlcqzsxkIqYg864nj+fm05YO+hNggChjeCvyW418e7rnb3e7V1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ExwuBYu6; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-227b828de00so30121295ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 13:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742849692; x=1743454492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IjcUgPK06/izKZfVvH05gncc+9DrDMjLcc2e2JeXhy0=;
        b=ExwuBYu6FXT23T+CfJJYh67v79pht8EoRcTNurcKzO1IrfXAMhYIs5fGdjT8JbLB7a
         8NJrAdHbDV5sEDuhWmN4eE7PpLY2O3dj0lVvnl0FJwRUbCelFLYHxBQKd2SosUt+iDRl
         bmF42CKoENZj4cRaTY2XgXIFQbK15NLSiRql3UKqVnw9wAnvjaXf3XoCVU+r7mpRNou4
         3wGM+WYktXH5uAp7AYaIlhu0FjQ+D++UsS7ktLtr9uakdYZ3xReOJdQT7KJWgp8DJ8Li
         NDpzkys0P9Rj25A3LzTzX5C2B/t/L2sImxIzDRJmMf19EUDMO9iPYh0g79vz7es8rh/t
         OJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742849692; x=1743454492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjcUgPK06/izKZfVvH05gncc+9DrDMjLcc2e2JeXhy0=;
        b=gWjCSp2ilrg/Qi2MnjEbk2LJE6DvD/psk7EcHkjBkVa9t256h4LL4CTjAxtqlemrSG
         ZGGs3XcCZXWlhcu1DUVpskRyNDf0Gu4gAz01/Mt1GOi1BJU0V8l3K1X6YjtGrZnWtthJ
         /MDpD/51amUj7ESJ7qSSHfeOUcsf7GASbcFzyyBpEWSvsTnw+w183dYHljvDVhtaLCle
         vYlKWtFRezgO7xTnIagekDPeUJQQqHgU2T5gk1Iit8g2/98yszj8bA4KMqdRMjdDZfQt
         63CkK3Md5NzbPd4APDkGz4ziPtqJkcgEXHa9+Z5r611BYrVgc3/qOVZkDNbMdM4ZoS5o
         M5QA==
X-Gm-Message-State: AOJu0Yy0T0wnV6LG6COreb6AnFZepHIpJZsvpg6Q4aJ7Vd332DqAqSiB
	g9LzPCISvpEp7Tbgfsb24m91zZuKEz8SC9ekw4dxgF9SAlfjySAweRowg4qrQsA=
X-Gm-Gg: ASbGncsRGHS5F9O+6/d6YW7Do/y7Itm0bAC2EJ+7vdwC+7ip05eh9Jo47nqNPhRo2oI
	75Jk2fiIAvS/+2Hjj34FZFwEh92KU3n2360Co6Kp6EeHicqsVozXbBtQblH50W4gPbRmCGo2vNc
	pEbQ5RDg4QmcJ2Jk2WeePSbafaNM+vHVrjSny4rn7hEPSzWSEVUJbSymZAZHOT19FZksYFlj68x
	OcSnD3uHbadixtfAWIXZAhtl9hfbMgGS69t3XAPZjjURVvgkyVRuXnKaxQ75tfavNW+pZuvrMBh
	T6YkgFclTLo03qGVYjPWpkCRjqs/fWSihCOHMw/bArDMiZ6yNEZLNxS4L5GubNtanSTN
X-Google-Smtp-Source: AGHT+IGJzNx9IZ5b2eNR9WIGYzP1pk30sz3PbrZFL+zU4w+xOKfS1nIh78+kz3DyaBP6HUlThar6YQ==
X-Received: by 2002:a05:6a20:c901:b0:1f3:345e:4054 with SMTP id adf61e73a8af0-1fe42f32676mr25724414637.14.1742849692427;
        Mon, 24 Mar 2025 13:54:52 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a27db8e5sm7724126a12.14.2025.03.24.13.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 13:54:51 -0700 (PDT)
Message-ID: <6a3f794d-3403-4e80-8fd4-9449a78a4ceb@linaro.org>
Date: Mon, 24 Mar 2025 13:54:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/30] exec/cpu-all: remove BSWAP_NEEDED
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-2-pierrick.bouvier@linaro.org>
 <61f1bc3a-abcd-4cf5-9d56-1132c8fc3ba7@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <61f1bc3a-abcd-4cf5-9d56-1132c8fc3ba7@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/25 12:26, Richard Henderson wrote:
> On 3/20/25 15:29, Pierrick Bouvier wrote:
>> This identifier is poisoned, so it can't be used from common code
>> anyway. We replace all occurrences with its definition directly.
>>
>> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
>> ---
>>    include/exec/cpu-all.h    | 12 ------------
>>    linux-user/syscall_defs.h |  2 +-
>>    bsd-user/elfload.c        |  6 +++---
>>    hw/ppc/mac_newworld.c     |  4 +---
>>    hw/ppc/mac_oldworld.c     |  4 +---
>>    hw/sparc/sun4m.c          |  6 +-----
>>    hw/sparc64/sun4u.c        |  6 +-----
>>    linux-user/elfload.c      |  8 ++++----
>>    8 files changed, 12 insertions(+), 36 deletions(-)
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> r~

For information, this patch was already merged (by Paolo who cleanup 
bswap_needed from hw/*).

