Return-Path: <kvm+bounces-4074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDBF80D1D0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 223791F21794
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347E4FC07;
	Mon, 11 Dec 2023 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Eva8YCBl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74C399
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:32:13 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3333a3a599fso3043539f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702312332; x=1702917132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZC/Ru++AKfDAVSthl0Gn/YW8p3YyY3iWJ4FjPBiS+m4=;
        b=Eva8YCBlqYef7qnXvef0kZcGR7vV5KbclLakfYWU9iPqBctqiPUkJsq8qjjQ4w6wWL
         KKiayIIN5d+uoOcCxqbse7g2s0veyDlL07UgouRSoWLB0sTgfiaG0dRGr+Ewz9yFsNnl
         +Md0RIfQQpBXlL3OE3G9LDPU8Vw1BG1djNTrdx2RYW1JstSbrVVE6We/2l+wL4RkN+ZR
         /CQfctaeYDf9i7tz1D9MwNesAA9qzLhPbPpk9zTVXGgYZI0CqCj09dyMnbT/+ujzXhCl
         7v1yb6F9xmFB/TxWBsTlE/Uv0wZd5N4mAIgb9166r0/zjKaiz/2nZbBrjH8ZrIaKr3fr
         vOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312332; x=1702917132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZC/Ru++AKfDAVSthl0Gn/YW8p3YyY3iWJ4FjPBiS+m4=;
        b=Clbdq6TBTm9SGyJZw1v2EvLTKtDmtka9vJwyJsSE0FLQoeRF7QFOSOtTB1A8AgvvXO
         qoaq91Jzxi+Sywz9Z33yAxjGTRfnSi/zjGZv/le9VwOldeQfIchItswo3KsESJTi7rsU
         nexbEga1KBqsQOqb8jxSarkVj8Sru3SF0hAfPPyJaFhdtsklaK4st/aOrF8NhvFlACZ5
         PFcPWSyZADIh/P/CYUdWGNG+UMeaQbDlJk3rCZRibGVJUEmzCrXeZR62zVcigoiSuTPw
         yKW8XNrcrZ/AjsiEeYjC88re6rIKJA74ja8n5z202yIPQ2RZ4DsC5wpZwNKC7Osv4BmB
         A3Eg==
X-Gm-Message-State: AOJu0Yywn3/ez+BtYiwoXX9F05ABbfJeya2U3TSHVRTIAR8urYUTPadp
	JNFtmJkyPE4wk5E1Nrr1wwFjlg==
X-Google-Smtp-Source: AGHT+IHEkecFyJiUoNupMT3GCGJUuJeN3CABNN+TbWlp8hRrybeIODmqtc3ZAp/SDvGTaHa2punOvQ==
X-Received: by 2002:a05:600c:2a41:b0:40b:5e56:7b6a with SMTP id x1-20020a05600c2a4100b0040b5e567b6amr2163621wme.179.1702312332190;
        Mon, 11 Dec 2023 08:32:12 -0800 (PST)
Received: from [192.168.69.100] (cor91-h02-176-184-30-150.dsl.sta.abo.bbox.fr. [176.184.30.150])
        by smtp.gmail.com with ESMTPSA id he10-20020a05600c540a00b0040b3829eb50sm13346844wmb.20.2023.12.11.08.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 08:32:11 -0800 (PST)
Message-ID: <20efca0c-982c-4962-8e0c-ea4959557a5e@linaro.org>
Date: Mon, 11 Dec 2023 17:32:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] tests/avocado/kvm_xen_guest.py: cope with asset RW
 requirements
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
 <20231208190911.102879-7-crosa@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231208190911.102879-7-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/23 20:09, Cleber Rosa wrote:
> Some of these tests actually require the root filesystem image,
> obtained through Avocado's asset feature and kept in a common cache
> location, to be writable.
> 
> This makes a distinction between the tests that actually have this
> requirement and those who don't.  The goal is to be as safe as
> possible, avoiding causing cache misses (because the assets get
> modified and thus need to be dowloaded again) while avoid copying the
> root filesystem backing file whenever possible.

Having cache assets modified is a design issue. We should assume
the cache directory as read-only.

> This also allow these tests to be run in parallel with newer Avocado
> versions.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/kvm_xen_guest.py | 27 ++++++++++++++++++---------
>   1 file changed, 18 insertions(+), 9 deletions(-)


