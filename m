Return-Path: <kvm+bounces-3965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 392E780AD78
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCCB7281984
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BCA56B91;
	Fri,  8 Dec 2023 20:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ot5BWO+W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C4E11D
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 12:03:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-54f4f7e88feso1351444a12.3
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702065802; x=1702670602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YwnbFYwpV3LUVIj6IokP8OukY70Ms4xhebL0+HoyxDw=;
        b=ot5BWO+WIsNaZO9KKYol+U8Skdw1+Shsof952XKipaWxTOUk7wqKKjSaoOpAxsCzDn
         ljBG3JiCHPQgW7SsE227zay6s0dARaYeV/p9jfhWy7dJipWm0BD7bSjtPx7zybe8sc0F
         lk5FDeRNpqCeHwkRm5n7zuZ3o8UpRw+IM/Nuivk5lrQK0W2ld5wNmGzbMvZvydtLmi4Y
         ekN3/+kjBPD8ALClzk0ZqyI8Vhyl0WCB37bk32AuLmFONSRL9l9OD+aEcx+B09NUFJ3a
         30XWYreGCoM/JF6EUBUjk3viRHnge3ZCvkwz0uTGsV//38d/wo2q/iCkUsH6lHk4+BGa
         YbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702065802; x=1702670602;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YwnbFYwpV3LUVIj6IokP8OukY70Ms4xhebL0+HoyxDw=;
        b=LuAA5w8sne6KuoKugRSlkdDxO3l9DwHJq2Dt2ZO/fZAbNwrO9YCKn4xmTCfCO6CWc8
         7IV8Cnni9fqOUm0jdMHvynGDxayC8DlUQe1C2Pnoj9foVpL+oR7oOLZZgd+S0g9SFLfu
         q8yUzMS2g7PxJcqGE4abWVbfLPTBwHuo6Cu8mzdjwqKidb55l9ynlni67H033McfMqgM
         ZjIdrbCvMhyeX+jB5HaRxUVaG60okZbRchLRv/Uh49YV2yiGj3wsqh3K/C5JYWiRJEv2
         HU7b1CBcMXgbP2LlNd4gpGFtn8tViPjabP0a8trdwISXQtFArluwyr0ILgHJBJnmSgcV
         v/Tw==
X-Gm-Message-State: AOJu0Yx5ek5pnkvHP80H4DAKbMmkuEIRaZqzqstxcpIMKTVZt93ZFV7k
	FF9RsMYXl7Q7oGfQ2A3CjnkEmA==
X-Google-Smtp-Source: AGHT+IHiBMv5Qcs8uwg/olNKskwGDaAfdVabppOUwYMzz64eFH3pWfXjLgRZqoQpcDstHTtDsCpEAg==
X-Received: by 2002:a05:6402:2313:b0:54c:4837:a640 with SMTP id l19-20020a056402231300b0054c4837a640mr416396eda.45.1702065802371;
        Fri, 08 Dec 2023 12:03:22 -0800 (PST)
Received: from [192.168.200.206] (83.21.112.88.ipv4.supernova.orange.pl. [83.21.112.88])
        by smtp.gmail.com with ESMTPSA id a4-20020a509e84000000b0054ccc3b2109sm1087187edf.57.2023.12.08.12.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 12:03:21 -0800 (PST)
Message-ID: <2972842d-e4bf-49eb-9d72-01b8049f18bf@linaro.org>
Date: Fri, 8 Dec 2023 21:03:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] tests/avocado: machine aarch64: standardize
 location and RO/RW access
Content-Language: pl-PL, en-GB, en-HK
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-5-crosa@redhat.com>
From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Organization: Linaro
In-Reply-To: <20231208190911.102879-5-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

W dniu 8.12.2023 o 20:09, Cleber Rosa pisze:
> The tests under machine_aarch64_virt.py do not need read-write access
> to the ISOs.  The ones under machine_aarch64_sbsaref.py, on the other
> hand, will need read-write access, so let's give each test an unique
> file.
> 
> And while at it, let's use a single code style and hash for the ISO
> url.
> 
> Signed-off-by: Cleber Rosa<crosa@redhat.com>

It is ISO file, so sbsa-ref tests should be fine with readonly as well.

Nothing gets installed so nothing is written. We only test does boot works.

