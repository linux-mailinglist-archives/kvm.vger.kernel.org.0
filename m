Return-Path: <kvm+bounces-45134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BDFAA615C
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B07F4C5219
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C835120DD51;
	Thu,  1 May 2025 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bGXF82Ah"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1E18DB16
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116697; cv=none; b=a9gH/tmo3uDxxVCqpaWX5HxwwIjdqc03GUd+D9iZLTBWruRrz9msJk4WNuR63c99GydIszH3FvMT13ED97EW//YMmHoTy10WmVv2k3p7Py+zhnOgbMCXXbKrDdTWrhGYjgjyLQ9nlPFEmPTF02kqBwS9OejVP3LWWJXteBEO0QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116697; c=relaxed/simple;
	bh=1b2s3XKuZC+zF6cgg4bdf7045eTpgob9QNDNCUfxGzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nVlvmpxb+DYntYtbzpqwHmlqNbLnp747oWuoeKOk+aq0XgxtYDv3vr4whSIp/iemuEsmRtI+4Ae7FL1lXu3oKi7pYQe8LeIxmVO0e0c0AbIROr97N0tQmO/k56yLeocEVQm4EgeERD97z1iBEdx2hBY173lfWrOMTxnAwjlY16U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bGXF82Ah; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2255003f4c6so13391385ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746116695; x=1746721495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cIv3SYpt0KGIULJLpRzPxVIXo1I4QvmLyk6TDaXK/TU=;
        b=bGXF82AhZDn/wMRiryJn6zj/1XObn0uibmrksBlbXJEex0JJQQ3OkB6ef40t/Qzq8o
         707y8kgWwZj3bioL7iQlx+NSR5sQCLAJE3XuEdjgQyugwfV1PEy2Ao3lWa2WWjygh/hE
         rLelkJHoupaYkAiM/0EpvmbT/kAseYT8Mv9CfUceJhHikiaUbTnpFRbS5K1ETgj/jXMl
         N3BKBNG8G6ohOAXmdz/aJZFXjXCeUitV8sqxWI03U/3dXJ2DHaiIp3UxXfpEM7ifTdAk
         LVq6WTcRCYkCkChq5rk3pYLxrLxOvYaItBChK0Nr0i2pTZUP0PGukyA+w4qotgkbUC5u
         6snA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116695; x=1746721495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIv3SYpt0KGIULJLpRzPxVIXo1I4QvmLyk6TDaXK/TU=;
        b=prYlPYopNliM2x7L6TXoXAY3pTvrJ/2s4E3C1OAX1S/r9wbdZLzN2IejKRd+3ZFTJL
         x76q9//NvmTauMFv0ZajPD1ptOIDGV3LKn9e/tDqN0XmaXrBpGwla1GwbITvb+SaJyuT
         uq8TJ+pI3hJsZrS421HP0WKjXBS3oFXS7h6b1nHjKXA+Lv6FOoKb//O0odksmJ2K74bf
         UiL33ug8QozwYXzWReVB/KZFI/G3McMF7Y5T5GuWArAIcCYACUZkZHks9w77mLouyNRX
         jLFbunAVdEXLCCPoc9oKu87yACcT5F2OUQijuf56i4nqAiKpP4yPCFIG61CHFWwIjGAX
         pxmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh8kLq09RydtlZPPtUjkCtaWWU6N3eX+zSvdEHPM0Wvau7duIanJiOmYsyCFRF8nasCio=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg7IhguZMFQNYN7kHEuHwoxVhbst9DmMIk5Dm7g/aGyeE5HvL6
	UbiCZSoZqVxv+h/FIeNA75fG7HWJ6FamPvmXfl6e66npIwB7sGrIX+DvwNj7Fro=
X-Gm-Gg: ASbGncvf3fr+FhW1Pqruf8ZMfVKszpokLmVgWDN103XKRDeER3FomtRB+Q4oPSG6rv3
	PbQ2DLPc5jOs/g751H7zX2bZPrwThoffqDVZR3TZn3oyPJxEWZjs+MHUWEJEVaFuVUctVVesgaW
	Y4j9Apt8V3Ut/G00DJRnfS2PDFLDqI44ukz83X1roLdsqxvDEwwlNAqxlBpXzdn5ubTJPXjJHaw
	Z6PvNOIDzSh6qh1yl9lIlbPGGFDzocfD6BOUJlwDF/jLhFkX5gMJs4Xx998RYLNkpKke5Bv6aDo
	KZzOAdhqy9AW/G77BuUlA43ZV1LSwyIyw6vI0fopIDhKXsFXPloLQdk2h8GGsQ9y8X1HbRleaR0
	Rp9dyjMQ=
X-Google-Smtp-Source: AGHT+IGAKwM6RcxOtOkzEFIhOkFLa/b5bn90FuBPHURkl0wMDnKUkk3rI7DC/t+lusoNb8z3Bd9w2w==
X-Received: by 2002:a17:902:ccc1:b0:224:1c41:a4cd with SMTP id d9443c01a7336-22e0832d6f8mr50408735ad.3.1746116694875;
        Thu, 01 May 2025 09:24:54 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc6dab4sm8608535ad.141.2025.05.01.09.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 09:24:54 -0700 (PDT)
Message-ID: <59d1bbbe-7f39-4022-80a6-945484508ce1@linaro.org>
Date: Thu, 1 May 2025 09:24:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 32/33] target/arm/meson: accelerator files are not
 needed in user mode
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-33-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-33-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

