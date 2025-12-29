Return-Path: <kvm+bounces-66787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 957F7CE7C77
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 866BD3010AA8
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC80E32B98A;
	Mon, 29 Dec 2025 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mLE4FTj6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F581E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030833; cv=none; b=DupbtiP5092J4yxTVNwZdbRZS+DNMoiq9/BiTVI644C8MnK0DX9kZ+gAeHbtYAvpOGojje2Nu2o5lIIwEyX+dN/2VxLpkcR9RkkWwjTzfBdDuYaT/mres65Hmbi64UCd6b8zj8v/16ZOSaa7Uj0zFcGyOQfq5rzunqhJp3CZWIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030833; c=relaxed/simple;
	bh=cGtU268PVyKbIb6Ku1262dj4d03/RfJVQM9jAVXb5qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWsE6r+TpLSCBfzzMtIcVaEjNLVXU/W59aalLFyv7umakM9Bpaa42MkS/+oqx0Mp5nsD7wWPbqAAiPvP38yyja7+eSNXo94uJoobVwcQJ57NaWn4Ch0It4/VOq48U2lLErvG1ukwaQaE3VsdGAnRrtGjNzwXPePa2v235Mh5pYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mLE4FTj6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29efd139227so122484575ad.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030831; x=1767635631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lky3eRWjNVZKS+mrPVmhhZW7nvQlMJxhyck2GcA5NUA=;
        b=mLE4FTj6sWch/fPsCZdzaRHnX2iwWhQQCPm8pOvGmy1YElwKxpXzXG3o2Gi5piJGIP
         aQjTjReF3XP/7Fw0QHLuG56ODlcHdPfprsqy4ePGC07cCn2nW/EMkRTj8CMXq+52EIzj
         Bj2X3JjiUVCYzDW2Ic/nC5HyR6Kf+OsuU6DZ3RTwfaRYUAKT2DDVvA4R2fe/ANNFwVxc
         3pJQz2uNqgfvYt+in0C8mzGsSIo4rPzb38LnheSgat0g1gvbdbQ+ETK5zysaheraHrLk
         auaYjrQkR8EIVDQHWzvm0b/UqrMztQKlCzJLOy53Xff67NPO2/Oleus3eFBygoqgv0ry
         hnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030831; x=1767635631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lky3eRWjNVZKS+mrPVmhhZW7nvQlMJxhyck2GcA5NUA=;
        b=kwwvCd3FazIkEdHbQhVY3P5y4pcZCikWIHEBkxL6OpXa9anYd3JtANVf3sx88QW3Ya
         Lp9Vuf9d/pXQ7bmIS7ylYNlQUMlqJ6yMhFFdugXXgygEaOmmZPGfiV/MI8RwgKULh3rC
         xPq9c7ytdyVwcOZ51VDAHbvVWyWtH7k4+cBkXmjfI3h7GskFjNB2xbdcgMH2wUNM3+ou
         rGLqnmMcThzyH2KoDZT5g+tRfSFVUa+0I9ETQ3lfwMP/gGZdsAKmBF9t337+GcY5OfBa
         H6Jjilv3/ZgK2CXWWaCjjBovfpjXhPKyHDQ8f0jltkSvCFa8PdBvZHwH8ESIR5wcOgAq
         rw1A==
X-Forwarded-Encrypted: i=1; AJvYcCVUHvSU3LabMnYFKdEg+4xOd23N+cGRCDtdKgDFRvNkcLr1juMvGfibWUpWyt4+Xb9rghQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO92WDFXqzyTEZ0745tgvJI71bIdcnTw6FZQEpX5mCAIVaRyAh
	tPmjLDFy2V2hIHT51gbwKjbYhF7Tu74k9ZZg55rDy0OhLVkXFtgJJPL6u7IzALKTj2U=
X-Gm-Gg: AY/fxX6n4I7NbZIaECKETL2exsK22uZG4y8L3ECS8KwOROfIuPIoAErVS8rm303Caa9
	5wqq7QDRc74MMad5/HCJsU8sxyOqFhJLs4TKnBVRiuWNUlwUkYblTVCKttsiDYiVCoZHN07dDe2
	UqZ+Zeh4w0IVSFDat5CRwXfc2klq+iDjWBgLt9TD1JWDfrIHIW5iBKOFz25c1RWspBOgrOsOK6A
	2cYZjbpfXlu1s5qF1yI75yRi4ZyvLE/rquLRoRQ7SGgJ4EJiVwULFGDz012ZcC3tjk3R/tnO9Ej
	eQw9uPzXAxhOFeOhWm0A82Z/w9ND6g+/DRLdMAyv+dVDUQOXE3u7F4TA6X8t9fQ/SAP14y4f/SA
	+uFQr8pJpr9fBuO4s72V/UMrQDIa192mRzo4JRsqUiC3EhTXondBMGi3sGv19sj7tAlxGjJhnMS
	MHBAIR9Dcyj4B5clwz1hhQ/R70I8Y3exs/3/WCRspkuwQL9KsqHtSyfKyc0XDZ0MR9YgQ=
X-Google-Smtp-Source: AGHT+IF3q1WBxBVC8iD6QACtpbZ43a201nZhMCGmysPIkpzipaQ8LOlenvNFJc0//WIB7MVZ2DNQXg==
X-Received: by 2002:a17:902:daca:b0:295:5dbe:f629 with SMTP id d9443c01a7336-2a2f21fc4c9mr274162615ad.8.1767030830730;
        Mon, 29 Dec 2025 09:53:50 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4d858sm282363275ad.57.2025.12.29.09.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:53:50 -0800 (PST)
Message-ID: <e5607e7b-3523-4d75-b0b6-d134c7c5d1cf@linaro.org>
Date: Mon, 29 Dec 2025 09:53:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 09/28] docs: arm: update virt machine model
 description
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
 <20251228235422.30383-10-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-10-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Update the documentation to match current QEMU.
> 
> Remove the mention of pre-2.7 machine models as those aren't provided
> anymore.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   docs/system/arm/virt.rst | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


