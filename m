Return-Path: <kvm+bounces-4078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE7A80D217
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DD4BB20E8C
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6400F2207E;
	Mon, 11 Dec 2023 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xy9r4W9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC1E95
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:38:13 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-54cb4fa667bso6777473a12.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702312692; x=1702917492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+dVE4T5CJKL2zc1mU/JUkrygd/A6khW5COf8KfD0PM=;
        b=xy9r4W9w9gIZEsjjda/KNfZyIWqxXERvWUJYjLNUiggfDaSn39SlHJlR8Ok2+4mXHg
         NGSl1TyRZnLh6lBvWaBV8uMRpwD+lH8L5aO8UrKBiaUzCXf49M6oNIhclAkhgNGEVRts
         28luFRBd+riUSjxprySbY8tsvTIgZSwVs8CLdMNFWK5XQHlehHOM0AwaLXkQXw/31qUq
         UfHWK7rPMBXesDblCWiEA/4G5UNTnjs3Xs1apA6UWd3iADTxQPTu0uivBjN+iLHN+QJy
         PCfcPTfjdklwSHUkG0S+q9+omOFnnzpnXc240G2zM+585b+qTmu8qunD8e4nP6oM2sCZ
         r4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312692; x=1702917492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+dVE4T5CJKL2zc1mU/JUkrygd/A6khW5COf8KfD0PM=;
        b=iVcldcD08m1PApcOH/hIizdTKT1suVtJSZcatRu+DFA3K3dqcuKbEYW9gMlKQwUAcZ
         CvcO2p4dTmUDNXEF9UE5pizdXNBRtQ+ettZgnST/utpXZWVTBEL8wwf4O7XfWzZzs282
         qE2SojV24SP/gSCbQ4bXMD1erW6eexxDy1h32cS8/Sm03KhzcTNYqiFrHWYqNb+6c1i9
         8CFsjnSiLe3hf4vYLPBNFLnge2Dhrooecl5Cw6UAqtLN1dxg7KgmBMAmIhaN0yfzW/fA
         gqtlbA80Q6LqmIkgaDYfK7gY2Pw9lxL5hebv9QDkF7OmtcNBhNNw/f7jhjkNF/c3Wp3x
         If2g==
X-Gm-Message-State: AOJu0YxiwVjXgEOCnysRq4YUaypxgPcDa3S9L4ALwcRePEWbvKNnnlx5
	TTGG/xI2tbY/5BcoEPNRgE32lQ==
X-Google-Smtp-Source: AGHT+IEQ8W9Vm2+c85+H62mp9eZzxAoWOI3l+4PtdLhvJbr135OX6k8KiDy5Xcu45FvNSYJ8/sDKag==
X-Received: by 2002:a17:907:350e:b0:a1f:705b:3de7 with SMTP id zz14-20020a170907350e00b00a1f705b3de7mr2260838ejb.140.1702312692455;
        Mon, 11 Dec 2023 08:38:12 -0800 (PST)
Received: from [192.168.69.100] (cor91-h02-176-184-30-150.dsl.sta.abo.bbox.fr. [176.184.30.150])
        by smtp.gmail.com with ESMTPSA id rd12-20020a170907a28c00b00a097c5162b0sm4995159ejc.87.2023.12.11.08.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 08:38:12 -0800 (PST)
Message-ID: <f3b4c270-c03f-44c3-b868-3c68efadc37c@linaro.org>
Date: Mon, 11 Dec 2023 17:38:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] tests/avocado/boot_xen.py: use class attribute
Content-Language: en-US
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-11-crosa@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231208190911.102879-11-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/12/23 20:09, Cleber Rosa wrote:
> Rather than defining a single use variable, let's just use the class
> attribute directly.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_xen.py | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


