Return-Path: <kvm+bounces-45117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0438AA60A2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DB047AE64F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C871F8EEF;
	Thu,  1 May 2025 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DU7vwgHM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4311EDA39
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112778; cv=none; b=YCtCB/luZNlgGzpFCoOftH2oI2q9aLo4bvie5c6Ejokcf+HMPi2cCrNpw67IYBq4e5aXxSedapdOdpeQdiRxuAkXTSjjAmhkZC7aDp/0K7/8/g98ZhSmhjAmxFXjvUxmgw0fgad2ahzJUVbTNVRO5aSkl5STDZ6FWH2R2Q+bFBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112778; c=relaxed/simple;
	bh=4W8b9CyFBMT6p8aApfH5MHo4UoDls57aeihj35ASKRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cm3RYiM6J3DD5W2pcpN1VTsJg0HPLNa4L2FhipZ3lwymq1vfgVjTXH3Kc7JeSkT9WU5dHWord6uiFNYAAAvmRYjxvnrkADck1ND8K3aSoQ7SqN4etaJ5PR2pZY6P2KMtsIUn1MgGcJyN0RoXJB9GvCbvNpK3ASExFB+0MV+5uxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DU7vwgHM; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2254e0b4b79so16335775ad.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112776; x=1746717576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=DU7vwgHM5dNBv0SrYVfw/bPYHVF7PeJMfYaaRWr65tU3DSxeeK+fYeVuSfX5065I3O
         XIbMdcdn9+G/Fls31msm9owLwldcdPOPmEAy1vK5xVSSOzxN48kjnvPLX8VGQzR6JwyB
         xg7/dYTLnocyFWyrLFbrqWPLhE9GbcuBw2Hss/ZHzU9kQoVchsNWFZbdAqj3nDUhA5qC
         Zs83Mipo7nnfPISRcw0zHtKoWX2evwB6/wvZdZ+A5NvD0/NU9kyRfS/OFg+EQOY+KsXL
         yWdRfs8Rqrx2ZSsfPBJ/lBqm6tb8R6n4kAFCiQfeTCiQb8jKyE3LvYVYIO/dxzJR9gW3
         QmMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112776; x=1746717576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=v3Faz/BAb3PpxLzos70e13JJW7FD0rcLxji+nL7Cq+bBpvA4ayZlu0HduzDwgQfden
         8IBRYd/w57KpFVean+PZwuGtXuibTw8Ajhdo4P8z4W2C0KPoUowLQlvgH3i5fVNw2Y9m
         NAY29vHPkEhkHTgqWKclXW33L+Ss2RSghwcf9tV8KqzvZhFUFnI5pt29ujiAqqfUcXBv
         EytxuaOL/gZkajEbTky4MKBlI2DrkvTrn+kwe01fCZfxOiDm/+6P+Zjkxpj+XkjK1J5k
         +lzkFUpNL+EhSFNLd0mODuXpGxALXhqBAO5gaDP/VSqAk6L02NPXxvzmuho5NePmpnC5
         wePA==
X-Forwarded-Encrypted: i=1; AJvYcCWHUZgX5jMB0h+mWF3sbErOkija1OsjU7mBUDoqBPZOncWuC8BY4Gp4UA8SJvrfZnLKNE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHJRPWveC1mvr3b4pYnsQgKiuVuGf+4KXvDQjo8uzu+iS8dK5V
	piyhpOdyJKT5c3HWUysG3qo8UI+N4hAtNZM8KCaG/LvIwCANBIaVwE0hsVCzDKE=
X-Gm-Gg: ASbGncuZqBWfYYpn+GM2EsnbY+hX1Rx/GitzVEFW0bkhI4GVrxuaf5xus3Uwg+rG2jd
	FUxzL36af3gz1l2GLIV09yp6CfcpRXX9ezhTNQE5fHT702NKOh4EhrD+oT3uw1bzo9LmQaFsCbD
	S/+N6u64/Qb53ICUd+Dl72A+Ax4NjmBAQX2dD8AS2NF5XnG6sHiCDN8Y4DpGCgmeibSHOH7i/wL
	OxId8UqMTBFFBkZk2cCQKatYY8Bi8nJIml2SNJtY6mR2ThB0TqvuQivTIDRA0Qh8JYioe4Y+Sz6
	1uz2EWdaxTR06mfy27dlGd0d2RV0HmY7jfuEbK441A/usnSp9uhJ6Vk26qlROs29LbOt9OHJFmZ
	NLHXaM0U=
X-Google-Smtp-Source: AGHT+IFiodq2dkzmVTJTMEgLtvCWG8RgNPy29GZm5v093C6tYwxz1yLGHlH2+5H29iUlSMv3iqh/fw==
X-Received: by 2002:a17:903:1247:b0:223:f408:c3f7 with SMTP id d9443c01a7336-22e08429b98mr46957485ad.16.1746112776216;
        Thu, 01 May 2025 08:19:36 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc6d4e2sm7796945ad.149.2025.05.01.08.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:19:35 -0700 (PDT)
Message-ID: <f3b1cd1c-3ef5-4d63-a2d3-96bbd186ff3e@linaro.org>
Date: Thu, 1 May 2025 08:19:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 23/33] target/arm/helper: compile file twice (user,
 system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-24-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-24-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

