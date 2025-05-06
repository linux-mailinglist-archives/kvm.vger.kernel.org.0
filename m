Return-Path: <kvm+bounces-45604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 464B8AAC7F0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C92B18901C3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD482820BF;
	Tue,  6 May 2025 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aqgSRyTz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6145E248864
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541719; cv=none; b=j7AXxKXtDPSSBYJNKX5qlQDh78U8TE9juS2f4ZZIm81e8A59eBil2MnRIDFtqTNehDsLV/qHW5rf/WiY0HULqWv4Ilcryoj+A1Vt8mM2gLP2SFdaMMyvujoE8tXyyEkAaIPIxq70H60HLzlLCPEHQ6v2tJaLDYbdgfupmYxj+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541719; c=relaxed/simple;
	bh=xWevHeiJnpfslsrhp7MccgtFp5BuOQbJph+ICnshTLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5ZTlEFcazrHinlZe6HOP+3iXnpdUQkURs5up4cdbmGViJi48tbuM1uNUSqPXSu8Ijfq9EvOcHeNzqiMSfmtGauUHXAwBWty7sE3knNN6bqKNjrcWOVoQZEC5NclThygOoNQ7lS0N0qu6PH8pzizHYvKmCHiocd6FxoNN3JC+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aqgSRyTz; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736c3e7b390so6595467b3a.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746541717; x=1747146517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bMPyqqctJRKXmx6qPaaZNnXEXcsZ3fgKNTkMa1UTq/0=;
        b=aqgSRyTzL8pvtHjCaJYAXrMuphBSnInzSoyKMm0fmhbhrx0n/6y2VOKeagaG5fncby
         bSYpZDUstc5dbESughciW1fdwayDnBeA1V/tjSAWn/caz+0Aff7pk2E2A1FkETOizTl+
         QlvehINzDfXXD5d5vX7q3+/HvyhqLJp2HXIqHQo71WBkPArrlwThK9NeWNyj12tR4Evl
         WNebQtjxg8mXf+9kCErSMxZGz8fpMybzLefhaKrODtMX1NenpN9OyKgv45XfhvUKQalj
         p7xDOUpzZ85nRBx4qcLDPaLJNoEfy5Eqrm/R2GU1OzC32GYZ3ushZBpAUg4ppF/gQPyn
         flJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746541717; x=1747146517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bMPyqqctJRKXmx6qPaaZNnXEXcsZ3fgKNTkMa1UTq/0=;
        b=m0TBx9tUW+FeoYsvOGdGhQehwttzIDpcTasnt1xdMCxf/QspDzq5ROYf9paEKDpOI/
         46c25PMBIkYhezXIiGp/rTf5oCJOz6FHvLUGUwLxZ22bwYZyBNcGiRWWVhpIbz1IjVlm
         Hcl4ME1UqxTeATy1khC5yJV4BymwmF1NR+a429B6DMlm4vhrrv7+xjbm4pUQjXpYiIyu
         DL60oBPKKOseBKRHrPikjBg6UBurU/RvII90M8T7Px5KK2hbTHQukFCZ62TKRp06tLJm
         uysMjG+c1dbguqNta2LWZLOwZ4Ao/UCxtFufWsHIWJbGwjM9lRH302vEJRqmKnV0yGJP
         tzEw==
X-Forwarded-Encrypted: i=1; AJvYcCXlfmVLVPpLn/mMsZh3nHLK4B9rc+XoN+GKGYxrU3XHyXNX9FeS6VjK43Dmzomjccqbb6k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz70DijoJGZXZW6OG50XEY4G3vGG1ERjUAxeYIAPYh/DB6Ms1jd
	fE7UR8hb1kg4PNzfE+LNKicRD/93VlpFjFVq6nKVqh3+fvFUTROQJ5wo9JUWkII=
X-Gm-Gg: ASbGncs7sxHGhInKkVyEcoAgqv6ARfCG/9UNUvpTOqDH7n4fq8f5ulvbDUQSGwpCfRh
	aXlZ4uE+BOq0ZPty59oAxY/lMWBvJswz90Qx0fw3GrEkAU8Wc6+Gd2lD5RgOucla3Lr53e6SD2c
	AZFlRqXjXmy3KE4Be+fPV+SLyAwizyeU/EqLKpPyo6vBIbBrbGELhLguyAO0LvluRlzFBNMt8EK
	FuNBi3mVivefFyeIJfoPeAy1LTWbaQAMWTYzFFTKAQU5GmwDGWrlX7kpXTa5mcpi33R0BIaH4rm
	IZU85JJ39NBBTaysAVRttyIYFFbgpDf6AQJlL/dB/UTS3ST19CplcJnV/JhHyS/sHNfOf8f1qvx
	dQt55raM=
X-Google-Smtp-Source: AGHT+IFkACUswVWWtARWPDjK+IX4zNVwmBH/D5cmtDpJYn2aeM1KH+eEZ8Js0pT9+YQ9kx8GApJ7cQ==
X-Received: by 2002:a05:6a21:9981:b0:1f3:33c2:29c5 with SMTP id adf61e73a8af0-20e962fa3b8mr15015753637.7.1746541717650;
        Tue, 06 May 2025 07:28:37 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df2a6csm8979563b3a.81.2025.05.06.07.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 07:28:37 -0700 (PDT)
Message-ID: <c57928b4-e6db-43e3-85e2-02f055ed77b8@linaro.org>
Date: Tue, 6 May 2025 07:28:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 47/50] target/arm/helper: restrict define_tlb_insn_regs
 to system target
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Peter Maydell <peter.maydell@linaro.org>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
 <20250505232015.130990-48-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505232015.130990-48-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 16:20, Pierrick Bouvier wrote:
> Allows to include target/arm/tcg/tlb-insns.c only for system targets.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

