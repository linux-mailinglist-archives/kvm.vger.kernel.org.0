Return-Path: <kvm+bounces-41451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38248A67EFC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96DA619C3BB8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE032066DD;
	Tue, 18 Mar 2025 21:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y9tCxwXj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDA5205E3E
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742334094; cv=none; b=J1sMScqi572Liv2BBd7PcV6sHDC+TxMi9tF0X2Dlj1f/BUfmNFYHIGyvwxV1mEOdAvjWUaW8GD+mdNH5x9T/DJGfoFCb9oMLQ4QRvfUpyRXkU3bKh2Qn9f/6cZ/nQkzUH4cSkTzDVw4kzwZRPEw/rnVhC/7BoIUyJUI7tctgPu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742334094; c=relaxed/simple;
	bh=UZ2Ss1/LIzHHsifOMukdTuJ8crsEqhNsluihKGrpR54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XX7UOBGcacLGF6Cp1nSw2cEkBcrN1paoK775HeQI5EtkFge2A0BdVM4lWzaljYCGKzTumTFUVU8aRn7CI2NegRVIz2j+R24t0KD8uIaWks4RTEKqFcxzEe1tDzKDWGFIoncEzuvPgTiRKTA/0rvCFLayPfL97O2mI6pDsOqqrBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y9tCxwXj; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-225e3002dffso69046375ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 14:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742334092; x=1742938892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=STjGlaJoL8peYNcrAd1LJeFiqwC5QN4avED5wEwNQ90=;
        b=Y9tCxwXjpWqhylKn5/oIHd0xpACFnleoqpz2OIxrMVu6hY/GN9ibZMWglXNms8gp6j
         hqnBc2PeaSlCMKuycReTqfbmAlsujuSGp4Xy7fdhmAbq3oGYWueU7D6CNxOjXpzwm6/1
         oi0mtIsRhdf9N6VxockWjMajiNd4du18x+ahq2QBB/ZSNKwE6nbYsKakSq9brUN3xfRC
         YX8qNghWKw2eyUvhycPEmKffnn1Dewp3KlCJorvt8H9tUqZAe30R0Gb3FLuzzEoINCPz
         CsJPTFp0tQkbbynJHDlpLfOSkEV3xMqVlDeHu0diUmdn6pd3Utnk+SlYfo580me9lFfE
         /OKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742334092; x=1742938892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=STjGlaJoL8peYNcrAd1LJeFiqwC5QN4avED5wEwNQ90=;
        b=aiW/GOMFIxq2ztQl1cGJUctRX+Ht2k/SfMgTxMh5bdCmUWOJHLs4l78kiX88VHPXUk
         n/IUkNBnV9/ULIV+bX5JC7RrDPgnHXG5w2eAJyfyq5omarB+Z5z3XbzmY/DcbS4W+4iJ
         71Hc7BRo73OwDru6iP8xblD61JZ2YitMEouXieDmfbD1ir0wQfJianAiF7skz+JH1AvU
         XjkIRQVWnRWzgz/AMLPejE+2TFrSobgogl/NFA1S/N0ZdyoHBYzRCPESDg5voI0nk1TJ
         hVAycJb+x//j+G7FiQSoOezioHM651bZh8a/OSrayNiwWkDdcsO9XNV8bHQTLBnyNFDd
         MSZg==
X-Forwarded-Encrypted: i=1; AJvYcCVBCFOF5zqhVUzkUzIMp+M8AKWh38diHeHpzxtz0/8r4aldCSAyhL78yct81cwI7hNfDwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlImoJKVvjtlveLjHNPbkQHCHh6Rhm1IY3VP42lzdEGkzTCuxB
	8DiFmM52HC0h1gmLZ3r+5kDiHnTCvf1WMAcz3HT+R7VWFSlW4G1EWguUv5Zuh6k=
X-Gm-Gg: ASbGncsvpXxqfwufgDAHjkuGkwAaVsGMtjyAbgAsGINi1l3jQ8KRpxRjKZejZ6g2xee
	Fd4tJmNWrDRwjPyX83o6etiA7G0gpafjmSiBWcY8zBOPf1oJPR1jO/FFMXNYzn5vcHUuVOMsnAS
	e/opPf/whPCrg73hsQFe3w61sLuI+c18WEpkeqfmGaEA3K2DpncSV19DTfDATdYp0dNLjDPuJjH
	8k9ryZXl5m6a1dm6ejsa1jPFUGxwwD+rgGU2Us/RVWNuuQ4yIdbHHCVdRMQ2c9s1euGObNt+2Ix
	TrxC7nQZG1lRYtRdZmCs8FOKwgkuFJGmDqSW4HRVBNSkFTUTmrELCUcS5cp7SX4ZymzCZk92pTO
	YTJYaWvk6
X-Google-Smtp-Source: AGHT+IEvjE74CFsm4MscUePIeChNuRGSVzaxg4KMJo3HjCDFURh6xUnSaRyz1CmLeVtwy7Y/lOF0tw==
X-Received: by 2002:a05:6a21:6d85:b0:1f5:64a4:aeac with SMTP id adf61e73a8af0-1fbed313382mr312364637.33.1742334092205;
        Tue, 18 Mar 2025 14:41:32 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737116944easm10408525b3a.134.2025.03.18.14.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 14:41:31 -0700 (PDT)
Message-ID: <2766725c-9287-4ba6-9e14-e84616d5fd17@linaro.org>
Date: Tue, 18 Mar 2025 14:41:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] exec/cpu-all: restrict BSWAP_NEEDED to target
 specific code
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-2-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> This identifier is already poisoned, so it can't be used from common
> code anyway.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

I'll give you a
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

because it's quick and correct.  However, there are only 8 actual uses within the entire 
tree (discounting comments), and all could be replaced by

> +# if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN


r~

