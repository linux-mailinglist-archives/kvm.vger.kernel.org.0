Return-Path: <kvm+bounces-22510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2295593F86A
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 16:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 398EA1C21E40
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AED154C0C;
	Mon, 29 Jul 2024 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rHeOSwkx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DB2823A9
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722264044; cv=none; b=qbl6pECP/VIviNeYY3DuDBEo3qyXF1v5jvyxIYE+RWnf3+lI+tBI1YM6KheTYfwjZ3MtnANF7QHEx2Z5HL7qq4d5Uufkr0hr4nr8lRHCE4E4BOU6bTOTjC4kb4MpvoONqld/3hdEFuUbU9LG9uEQobpQQdVezDOHPoRaB2Y7cp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722264044; c=relaxed/simple;
	bh=6bjoV/ER2hwd59NQd7xL22j/A+2to88V1KRZae1xzbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JDCVuEI8CgDt6LsAyinIEu6rNhZtu9gUyYhHA2EAOKCdEfWxJgH592gGzZYrv5kiJmyseOjces3MN+8gNI9Qh4SpX9xSbBr3zSSFwo/2xs9ZU7lmDR0XW/CaiArT+Ci3OFGAUUiM4nBsg5q8a0/6ZNwUJ5lvLs93+syPhh1PEFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rHeOSwkx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42809d6e719so17485305e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 07:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722264040; x=1722868840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3e9b1ZbsCUPjFEgRqJ+hwXbs28Kkpn08+Yw7FV+otA=;
        b=rHeOSwkxaFnHZu97KXVcWjc5aNYaQLh/2XhcWlJuuhOKixE+B/6Z392EkRjUC/ySfz
         gBU+Tjqhv+YqlXjL+qhsHmoduk59hbM8nc9d0PP0WohW5Uq/lF5bPBPBOkdMGoLYRu6a
         2sli5WrUmuvXNFiPhr5BGC5lvYBu1hrYgI/7m2rK9h5wTpVcLOR8cjZUZN+rX1utAwBC
         l7GX30A0bJgMqTim8rWIoQHOTQkBJ7rNidHPQyOld9ZBjpRMj63R56qgfeyMbiA+Q6FO
         bdPkpxnDHEBRohustt2o0/Z/zIP/c8PqqVrmrZhR+lXOoWTIwp5w2sDkUOTjX+IcKdwH
         oPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722264040; x=1722868840;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3e9b1ZbsCUPjFEgRqJ+hwXbs28Kkpn08+Yw7FV+otA=;
        b=ImmmUmbMEhgQfEMEi9GpTD63WgZsKtlNfOmHaEEt2SOtD+9bIdUqxm7Uy/9mUd1GnU
         lFTSoOarumVtOWGKUvToyJmyb2n5k0++QVI4tJHMTH/Qd50Gv0va1q7y0QR1Bcc4CDY7
         iBxB9U+Zeu/G8FOW6qWOlt6u6qgVCDWAv1pvg+XvAwzXr/v4hqjYoyVKAfEY72k2gKlg
         1s9nRBNyoPN2bwhOYqXqzXDhoHNPye5h2py5269dnv/VpN+/Yv77nvplO2MO/9mC2JI9
         X70YXR9LlF+makFLXCZ7ekBuIvazkP2twpvz++n98ysj1Eld+sGt/P5bYXG9wNCjj1jW
         waLw==
X-Forwarded-Encrypted: i=1; AJvYcCVixyEwmk6+xdi4nBwUaaeEEBgDDGAo51k/TDOPGLSbyDID9mC9zWinWVQIiJYs50GmLZJJUGR4Lfpy52ZCIdWKXBtW
X-Gm-Message-State: AOJu0Yz85GxaqKQDZylmjyIOyvK+d89kCOKf5kLHVdoZHp8nqnxk8d9w
	KvO1ZP1QKlDKv8V9uMTSUiqQQHYkkghi73OWZt1Qb4IuLpA6zP44oHdyKYUu5PM=
X-Google-Smtp-Source: AGHT+IFHgcVZBSsqx+kJWyuBFGP6dDtPg8rYuEWdm5awfdO3TlQSRElWHr7IrKK+DGDGkjwxVHIITg==
X-Received: by 2002:a05:600c:3ba6:b0:426:6667:bbbe with SMTP id 5b1f17b1804b1-42811d89a5bmr62687045e9.9.1722264039627;
        Mon, 29 Jul 2024 07:40:39 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428218a3934sm2651625e9.45.2024.07.29.07.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 07:40:39 -0700 (PDT)
Message-ID: <0977da6d-53c9-4ea4-a099-531d76258dfd@linaro.org>
Date: Mon, 29 Jul 2024 16:40:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] Bump Avocado to 103.0 LTS and update tests for
 compatibility and new features
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240726134438.14720-1-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/7/24 15:44, Cleber Rosa wrote:

> Cleber Rosa (13):
>    tests/avocado: mips: fallback to HTTP given certificate expiration
>    tests/avocado: mips: add hint for fetchasset plugin
>    tests/avocado/intel_iommu.py: increase timeout
>    tests/avocado: add cdrom permission related tests
>    tests/avocado: machine aarch64: standardize location and RO access
>    tests/avocado: use more distinct names for assets
>    tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
>    testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
>    tests/avocado/boot_xen.py: fetch kernel during test setUp()
>    tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
>    tests/avocado/machine_aarch64_sbsaref.py: allow for rw usage of image
>    Bump avocado to 103.0
>    Avocado tests: allow for parallel execution of tests

Queuing patches #1, #2 and #8. Unfortunately #10 depends on Avocado
101.0 so can't be merged at this point.

