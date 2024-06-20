Return-Path: <kvm+bounces-20109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2779109FF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CE77284B97
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB8F1B011D;
	Thu, 20 Jun 2024 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wBeYZUie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157731ACE94
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718897799; cv=none; b=LUshWiWYRf8I2LVwfoYbECjIpAlKEB1Xe1Cbs6Kryn4lpFc0Ho9ZgAMWjR/d7l6XR407E/nUeYA5/W5/XJVUBlYPoHzrdDsJzKWAC6vlp7b9NkLNZj4eeIUxxii5F7Ml+tt8BQycluMUt9tt50FHfJXXwQBruDzl0ZxdlNmxLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718897799; c=relaxed/simple;
	bh=LkzUBhogip5hygn4Ief05bQerPAzpF9foMoM76RINVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIMZ9TvWd+Ag1NVfIePVE+kkCrwfwg1z/oql+DzpMSMAyDr/4Ssil7peZ4/KCBCecmGgDhfGp96goXf/4MM4ZN+7SiMxeTzQGlH0IGko4Gm7ML3EIiZAR4ygx8wdmN6IDDW/k9wFh5Ze4CTuFzT+xe6bZ+91j08saNeDgeJZ9rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wBeYZUie; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-421bb51d81aso9841325e9.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718897796; x=1719502596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBelHbT28/Diop473YxP3LQrHyerXnAYSm6Ciyy6cC8=;
        b=wBeYZUiewRaUyQsNv0rvvzg0PYp1COT7ZkMH9KwZ4GSJeXDcRRqDiPv2SxA4NNW9Tx
         9jV2wfQxqyPhFuev6unaVwv7Pp22NooQJ3w9wEf0bHTEKG88CZBJKVbOms4x95vgWo9U
         7PLnd1zHzTBsfbCVUUsaauF8SLrZSWUL+LIX32Bs8SKOxM4pLl7TS56odhq35w3jbq6b
         85M21juWBsms/FM6C4oAIJwUWHmzjgIr0RCo3XPJq1v86sbfcV1MunB5N6OxVxpBTRjU
         w4e2LMS5S3Vun669wfSbYX5TPsSfKeyVR0Cl0KUZQENxJxoHnyUTFFBDAeRL1IMSQ5ew
         MDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718897796; x=1719502596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBelHbT28/Diop473YxP3LQrHyerXnAYSm6Ciyy6cC8=;
        b=MM4yTqDYpDGKxJMSIZLQiHAkE8zD6U+CiFm127LrBP8OECSKheSpnIFdw3rZ/B8yue
         dT2hMIcb/2uzjTLhUBvblyHNQIZuntavlNVIgsC+gKa2/z8LmBjDUj5NM+Ds74Z++TcZ
         sqRUoQYzNQKlkXVEwFbbrrQLux2NV3JhfqXiDQ+S73yoEcZfb6ypC2jD030GxQdQn1ic
         FC/zuTZwuXNwtNDdtkyQA28A9UZsptVjQgngsuTLgn65+fzA0ch+a+5HNzL1ACBV4Yz4
         2Kw66wEFR/11xX+hXLPR5XfAzxjbwLvcqrl8W9Zmo6kqptzUBttIRrJuP1kh5IAstuOp
         mtbw==
X-Forwarded-Encrypted: i=1; AJvYcCWo3ZGl0UzVzhArmREMJ6xRbDS6w2hzjZ2vcrE605Y5dQAnGXZHNUIMvOq81lZJ7EpC7B1yTA3ydn04IBccyM8Tw/8J
X-Gm-Message-State: AOJu0YyGVgF6q1hCZsFDl5u19D/ENqXY/0munkt815XGt3DO24/4aZlz
	fXOe/7mbrHnvT0GaW19tB2XoUqA9wjodSnHDIbqVNepLTOI/8rPFWopZEtacjug=
X-Google-Smtp-Source: AGHT+IESuhZFJcdm5hes+a066GEweTu8SnfStPf1hkxE4lrjoWZg84KFkN5dQa5LfuOSsL3U9/ThLA==
X-Received: by 2002:adf:edd1:0:b0:35f:b03:bf45 with SMTP id ffacd0b85a97d-363175b92f4mr4438519f8f.24.1718897796372;
        Thu, 20 Jun 2024 08:36:36 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.151.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-365a20d9b13sm551183f8f.85.2024.06.20.08.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 08:36:35 -0700 (PDT)
Message-ID: <37f2ce0f-b4a8-44dc-bc94-e706eeab6663@linaro.org>
Date: Thu, 20 Jun 2024 17:36:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] accel/tcg: Avoid unnecessary call overhead from
 qemu_plugin_vcpu_mem_cb
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jamie Iles <quic_jiles@quicinc.com>,
 David Hildenbrand <david@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-arm@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Halil Pasic <pasic@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Nicholas Piggin <npiggin@gmail.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Max Chou <max.chou@sifive.com>,
 Frank Chang <frank.chang@sifive.com>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-13-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240620152220.2192768-13-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/6/24 17:22, Alex Bennée wrote:
> From: Max Chou <max.chou@sifive.com>
> 
> If there are not any QEMU plugin memory callback functions, checking
> before calling the qemu_plugin_vcpu_mem_cb function can reduce the
> function call overhead.
> 
> Signed-off-by: Max Chou <max.chou@sifive.com>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Frank Chang <frank.chang@sifive.com>
> Message-Id: <20240613175122.1299212-2-max.chou@sifive.com>
> ---
>   accel/tcg/ldst_common.c.inc | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


