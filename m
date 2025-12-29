Return-Path: <kvm+bounces-66782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D45C6CE7C4A
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74D523019BE1
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D67D32A3C5;
	Mon, 29 Dec 2025 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dT+yuqg4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4041E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030601; cv=none; b=SKkiMUqfG+JlQ9mrxq3j/Q9PJX0D3V0h9W/YhbXwvccI19oGdLpoJzyD4oma9FMxXMHcLG7ts5TZxoaJV4vvRj2I93B7UqQ71Fbzilq0X1U1FQ8myf7qr24qvR22iFkTD+HZQ/tDcaejELujXY0eamQTHeLzRyunhLzOMDZThuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030601; c=relaxed/simple;
	bh=evOcPYr79NXvjH6UwclLIxxp8CxThbuJiZTQo2IiL3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kx3wjF66Rgeo8N9vZR+TX8uiVpv1B0MnZ8xFvGjULcOQ1+qK8Ua1FJSlWmTYqneGAVetunKn+d/ax7MI04EF6vaRqGc5pkIYiVM/Hbx3bZq0fAFAGkQoX7ow6I04KxCvbWVUj1EKS78/AyvjHJTw8IWQSW/q96ixYvwq6encJtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dT+yuqg4; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7fbbb84f034so6254652b3a.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030599; x=1767635399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EcAbgDXHVxo//9dE/opdwDSUstPmjyc3Gle9ozu/kak=;
        b=dT+yuqg4c4sc3to+VgCbsUUoqcblypyZDsuyQuqbw4nveRuDaZBd3lUuB9iwSfunXy
         sI6AM4lwUrTsxHp+rdoWEeA1xDGRhfNdMn7NerCJc/gY2rm6C0f5B8y8ROhSuY2fBBb8
         FaMorfou0jkZ6tARBVFcyXA0ZCLfowMNZ96BItBr0kxtPnFysVxdcRmw0BSytck3eGRL
         5tHxJYw+iEhLO4fipCzohLtf248T7WYDO9FJ2VGoRSDO1q3hYPYFuYbLorQN0nJFaxza
         jMhD+UFXwgoASuyWGqlapROF3ziH/ju0ae2/kwmBXwbm7gJtpVPxFzDIJOfQOjkxWtFe
         +Q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030599; x=1767635399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EcAbgDXHVxo//9dE/opdwDSUstPmjyc3Gle9ozu/kak=;
        b=uw+TWTPNEZiZefn+ID3dnd301y6/IjR4c+eaMx0sQ+GeniVScIRHRe0kcEffSjfWPf
         NSNnbDLtU+2rLDlGUXnYuZlR0Z8tzW6cwTHkctRe2jp2D/S3yEFCSu1K4e6qrzd3bpec
         XQy5bv5nEFh2/YvM4m8yva1TQEhkykx20zk30Y8JM9wkcPcq+37hZCRZCLIGR4HGxWOT
         2zsiV9oyKTJAWuftXHRMm2hmKfcchfPNmWDzMJJ2j6HFi6dYGPxQfBXuoTkZJDMFrybf
         Wpd4pmonS8wkUIiEGtwE14+DIPhHCRJfzf5J/3UGOtIStdPihW09AInJkJQE3VzD4jQP
         1NjA==
X-Forwarded-Encrypted: i=1; AJvYcCUe3SGjwWxKdw7vH7lG0mAv5hgHOMlGm9TRY1EzFwWRGPK8fuIX1cVj+HCbSwWNakEXdiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYMTXf2RSlqu1sQpGdp4QGFvXsJLBzBe6/4s94VC4uTZdiXKn/
	jH9OjFgBYhwf2ES75Ce2nGoP9JMuUsaK9LGQZ45VOcr5UWNl0YmZxGfu0PA6C5ikyag=
X-Gm-Gg: AY/fxX5G1YIclHgnqnTVafYPKjBvIyJ/3o3ISkGMfUXS1WxcoFXbhdQvSUtzuKyYXNi
	opvpdhkcoFgkHX0ldB92dxwL8sfpDWNHoBFffARX08dgGqN6KEL7YyTq8cPx00KKeSuX8FOYd1d
	s7FYeWh01Ee5oeA49bsSUmFAcilH4dEXSAavIMHth0WC7ieThgw+FOxeadBzNsHs7HS+0hQC9Hx
	diK8cAMx8RUBbs33YKZJNup6YL6tlbfb1O9ydOptryK4tfNNSTjCuxLydEfy1ZK8Ur8JYGhwbgr
	cWqZQczJpXkfB3eb5AMkILmlhfAFEoPQFKVwmaZEiJ/T16VsGR9ZeVAva6rJwMbMWNszIuiVQx+
	qSFKf2dxQ/maLg2ZPDjPMqUJ0DIhxn8klNI0BcadGISrFc6AAvdJ7y84WooxfaWm4PuoydcG+mV
	H57BQcQp3jYt9UAkv50M457KrGrBsuFLLr6TM6XXQiaWhHp9oNE3Qch3jl
X-Google-Smtp-Source: AGHT+IGHkY0NPJFlofxy7Lt+4zSf3MOYzItOPAg2JidTI0ZvomHj5KR6VtjPsNPyzYiGIk6cD5T2YA==
X-Received: by 2002:a05:6a21:33a0:b0:350:66b2:9723 with SMTP id adf61e73a8af0-376a9acee6emr27007930637.43.1767030599142;
        Mon, 29 Dec 2025 09:49:59 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bd61b4csm26034630a12.18.2025.12.29.09.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:49:58 -0800 (PST)
Message-ID: <322e53ba-4b89-48df-95b0-98c2a72d174a@linaro.org>
Date: Mon, 29 Dec 2025 09:49:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/28] accel/system: Introduce hwaccel_enabled()
 helper
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-3-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-3-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/28/25 3:53 PM, Mohamed Mediouni wrote:
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> hwaccel_enabled() return whether any hardware accelerator
> is enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   include/system/hw_accel.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


