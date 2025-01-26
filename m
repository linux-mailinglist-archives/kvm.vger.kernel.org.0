Return-Path: <kvm+bounces-36619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A82A1CE3F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF4E01887C41
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9E0175D4F;
	Sun, 26 Jan 2025 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gNLsiWah"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4CD15DBA3
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921341; cv=none; b=nPfKcKki7zOkbjreU97jEXgrmWFDN+mWUTNxgnozfFsN6NPDYPF0A8CELakAkHbrfJ8cbWndHv1K6jSWe01mkAJlQ4E1R94tfSbNZau5MxBrpki88DkpxyqDhguHzNthwUj0k0eNHvt0Z1Gd66z7TX6t3Iw35q8uu7bVLlFX9WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921341; c=relaxed/simple;
	bh=KkPHVCPfa8QluRIbtmZskqH3lMwnoIRVpXoMoM3Jlgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdEqiyq6S2tJuqVP8io9JQa/BWC7cYmJ7Ja8vBi95P5U5HwAerqeh+w8B5hNbSUUAOfvZ6n8ex6zvzp4DGJVY2Aa4CnTdzcHSQQE1Sj+RwLvVUjLx8knnWZgbooynTw4JhK+Hl4AFBy46di4cIoGgYGDWlqIKxZMEgr/NjRqUC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gNLsiWah; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ef72924e53so6530711a91.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 11:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737921339; x=1738526139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k/VcBzCgSZMRn5BGbBxU096iXq4FkgwntnoR7v0hF60=;
        b=gNLsiWahucsAN+oKpT8rXLbCqywiYF6Uri8cGfZdecm7py/dPDKZGoUEvOtGYHJsW5
         LgN34taq18WJwEN0H5515dMwAoh9/KevjKGR2niQdCYc/AaP8RXiTftWCneH3vP/YPh9
         HWhpgvBtVYmRaU1Me9ukQKtvsIXmWjVeRmgzOJBoa/ubcpUyOAZzkD8IgxZLIJ8dJ7uB
         DWn8EkKAts5QQRt8hE/toz+PLE0pFCPncxOP0Jul+ZDwSISNlmiphMJcq7PeQ6LW1R/D
         CxAkYOp72caFLTuF954qIbYcyz9g2Xm21BJooganWsGSQzlxi2IOEjc/3uY5ZAJcYmWU
         eaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921339; x=1738526139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/VcBzCgSZMRn5BGbBxU096iXq4FkgwntnoR7v0hF60=;
        b=gT+8764kVTTU3G17xCcNv6BYGmeBEzhRmklOC1I9+ulLi7OONX1To9IjESzfmPTmeL
         qRoUUvcVZKs6GYKy/gTgGkYvBvbEAEfYiBR898wUMGk6lhQMqZtrvhU+JC8c77uNZDMY
         Zn11Cf3NCyU/VQYaCZK0R9C+1sTAO2AZVBgmLGegMCX4G1LwtBZTe53c9Jog/LqBiYTL
         iVO1IagiAdds/924hcRGM7p0q7QSzxlJufIA4B5ahmuKZJDRy2MviFh2Y9tELqN4phb5
         0FzNLDpS2zt8HzF6TXvBFyEXezDPKsMewdCRRsWkJd+2l2xsoklAJYkRrG4EDL1nJ+u8
         iCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5InJRpX/1JllXt+ZYalS6u5cveY/zclpTpTvx2JKkQNJkEDtdC62lVF8DLsN9WcaD7Ms=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0uGs/Q/5r1e6lfD9xm57LnQ1SH7UJs4KozvW1qprS4hAZ7xy0
	4943NjXLCZrPGYkCmwigH7i1PR7XMGdwjVZKA26Lkitl/Q0LxElSkczLqRlhFQU=
X-Gm-Gg: ASbGncv7NnqHLhwsdZuh1/tmIcDtT9p9deBXezWKCIyrSDSMH6V00lJVqArBLbeu/at
	zSmnibc7binMeZ43inck5PihJMbXlPTSdHmdfRLNAnEMn74yxzoynTXjYfbYsjAi+gzDfLuqPJZ
	sR+3Crm8dTldbMfVPPlIIIjVSBciV9+RBbDiMIrUE/M9aidtTbLxRLvNZ3BR8gFYXiuye4dRgxu
	ZJON3ohV0vt5WjHe6TRj5irjPqnhuMs7LCbojeGOw7sxa4GlmIezV8iM0ZZmkYg1pK/kBNI955J
	Y29AYky+J/jXOhxTnbItgopuX77xm3V1YhsiW8eTz4JRvCm/40P96sfjfA==
X-Google-Smtp-Source: AGHT+IHkPOqmTCjp5vaq/+XEVF4ezQ8MyiAJ8YKEj+eBpJYARUzB5sl2GUtr7fAvVdhnF62+x0fMUA==
X-Received: by 2002:a05:6a00:a09:b0:72d:80da:aff with SMTP id d2e1a72fcca58-72daf9c1dfcmr48758529b3a.9.1737921339455;
        Sun, 26 Jan 2025 11:55:39 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a77c4ecsm5519455b3a.121.2025.01.26.11.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 11:55:38 -0800 (PST)
Message-ID: <ea6edd46-f1f6-40b0-bf89-c7f6f68bee87@linaro.org>
Date: Sun, 26 Jan 2025 11:55:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/20] user: Extract common MMAP API to 'user/mmap.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-3-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:43, Philippe Mathieu-Daudé wrote:
> Keep common MMAP-related declarations in a single place.
> 
> Note, this disable ThreadSafetyAnalysis on Linux for:
> - mmap_fork_start()
> - mmap_fork_end().
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   bsd-user/qemu.h        | 12 +-----------
>   include/user/mmap.h    | 32 ++++++++++++++++++++++++++++++++
>   linux-user/user-mmap.h | 19 ++-----------------
>   3 files changed, 35 insertions(+), 28 deletions(-)
>   create mode 100644 include/user/mmap.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

