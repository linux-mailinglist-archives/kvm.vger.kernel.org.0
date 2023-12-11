Return-Path: <kvm+bounces-4073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF9C80D1C1
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD0B61C21319
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2102207E;
	Mon, 11 Dec 2023 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="esS1RkJi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AD395
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:30:09 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3360be874d4so2694984f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702312208; x=1702917008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgQR+tJfnuE8VGMsbC6FBzjJNNEawrH+S2egV7A6WNM=;
        b=esS1RkJiRREA1EzCVKaN5rAgK4+tjQyqi1hiPDxt31eL9Cq4Ee+w6jLjMQvHZ4Z+ZH
         E5kwxRSLecPwyerAd7d8ZgkQlAHb1+GB2NZmyN28oVN9MDtbM/4DVR4azJAsGQPR9JvF
         gNJDv5bFxppQz6H674utL7eOhPIVpk3lzrPaN3q0wbEDo9zTJXMcZ73LDmirgKNHmW8W
         tXwA5mn4yEoDOWhJlzuRu6YvOOnym2vxKvNsJEzd76tL0ENpsIKkt7yHKrflCqaZFHce
         9EBHtkdmBdKQHb7lsQqkjhUgaRGwnHkaciAGydXaT1C+6QWRg1HMKc88WJGzB+Emp6by
         J17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312208; x=1702917008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgQR+tJfnuE8VGMsbC6FBzjJNNEawrH+S2egV7A6WNM=;
        b=cCysfdgyMJS1xLIdaSCaNpDVAVedXKIjR+M9JK0aFMSqzRcymcTeHeujt3WxR/hbMs
         AUdSWhskocY59AXlLwMZV7RGJD59YhF8hzJPEZjR6kQwVAAfvg7WGNp2YnydndgpS47b
         qyhHc5MqSAdb1t3YIGay4HKu8gEkafGgjrQejiBjLfvoEKgOn8WF/zmbgwcQHn6JGeFX
         adY1G0sKHUv/6aGDHD0BAdKEJa1ZeMCoVaVo6tuiSZkTB+ss0ERL8f+IyMu9L0Kamup+
         GmV8O2es25SnZcTjs++JVm8a1R8d0oug+azwEmIVgaPE/KTjNt0zzCz0pqcFe9/RY0Mo
         HkBA==
X-Gm-Message-State: AOJu0YzbckURTuEvT58qdD5b+ms9LByLscszDQ6se8uPd/TaBbWUDLt7
	IPmO06PlUbh7YNepAsyJ3mEO+A==
X-Google-Smtp-Source: AGHT+IFF9z/AOavNKv+0kQtxOnDAqtkj0yCuOY2JfT0TH7m9BaUGBEvIuEABRk5HwMgaIUjH3vYADw==
X-Received: by 2002:a5d:6685:0:b0:333:2fd2:51e5 with SMTP id l5-20020a5d6685000000b003332fd251e5mr2649904wru.94.1702312208133;
        Mon, 11 Dec 2023 08:30:08 -0800 (PST)
Received: from [192.168.69.100] (cor91-h02-176-184-30-150.dsl.sta.abo.bbox.fr. [176.184.30.150])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6807000000b0033334625bdbsm8962950wru.13.2023.12.11.08.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 08:30:07 -0800 (PST)
Message-ID: <bfa79c34-629b-474d-ba38-d73af157e25c@linaro.org>
Date: Mon, 11 Dec 2023 17:30:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] tests/avocado: use more distinct names for assets
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
 <20231208190911.102879-6-crosa@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231208190911.102879-6-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/23 20:09, Cleber Rosa wrote:
> Avocado's asset system will deposit files in a cache organized either
> by their original location (the URI) or by their names.  Because the
> cache (and the "by_name" sub directory) is common across tests, it's a
> good idea to make these names as distinct as possible.
> 
> This avoid name clashes, which makes future Avocado runs to attempt to
> redownload the assets with the same name, but from the different
> locations they actually are from.  This causes cache misses, extra
> downloads, and possibly canceled tests.

Could it be clever to use the content hash for asset location?

> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/kvm_xen_guest.py  | 3 ++-
>   tests/avocado/netdev-ethtool.py | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)


