Return-Path: <kvm+bounces-46332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E93D2AB5283
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27F1C164BD5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AAC2475D0;
	Tue, 13 May 2025 10:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k2QCYrv3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A6124676F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131083; cv=none; b=QpBB9hsY57l2Xx4c2cMBHDbX3NMBUmaLpr7osryIv0kKsgGhk7TG7Wql4+A/+8fag0cOAUj1vO66fWLpGKWaeib7I+qAz1Sl0uf2nWAy9uWbnOdqNJ9ip3P9MMoTUBs76bEb/wQBO+T9qOs3DRZfX9KFVaxTfrSUF7a5O3MLbTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131083; c=relaxed/simple;
	bh=kqKafGbIZsYKk8Zhbxbx0TD1p6gu+vnuK9h1UF++ZhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCjVpo3EBU0pt/CigCPAPMIVSAJZEcweQ4ikghPqdJIArmnhRar83+xPtsHWZNfvuezy88/kwjh2eOSDUi4fr39WqqsBN9ENeS3lc0YV0b8ncEs8hj2bkjAAx6yWpF+pCZIboXpfbVTg0ejmicJYBSR0Gvyc6WtDvNTY0mBqmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k2QCYrv3; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf680d351so37964955e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747131080; x=1747735880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=k2QCYrv33tPx2DhJftLbxvnTH4CKhODcBqAuJLLetTYVJGDVQAtb1u+1wSu5tytv+I
         nxUiho26pTfHICuTuXmd0G5FhmP9kX06YN0Rj4WjHJSz7AeVsRv+c2DfC/XZakga6TSs
         Z738hMC6ZHia5Y6CP8l77EZWVYADytHzyrd1gKh9YVg9aT2rPoX1XlSa9NyNi/NCfOyu
         h/QrqScIKIaZ1MqafW9LYrkveyw+s496iiYvbZpU7OHyyA4dkJQ8DSI8NmHJbIluoMIC
         gOZLcWaCLL43bH2PwrXizZHFKQUoHZ7m8b1bARYx4PIy00QwhQ17JHUyBPyJGytbXQx4
         Qi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747131080; x=1747735880;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=r3wOIs6zKKdjeN6AiGMdF6rb8bkygFYCJ2APWhs5rApbVSBNedofYTwL3WYzpJiCiS
         tbs06e2WOO6E45iK242g7J1j/9IoyesN0Ja4/Otb69hWuxggEcIlbwCEUQ+qCizDpUPM
         53Ozpijzr4EFD1cuYYeJ4TnUST5fn6IqhWXiK8M4R90Y7OtJLi2ecQW54CbX3UZyfG+k
         gFKmuAloouNxHsXkxmNRY4diDrItpcefPDpX5RptCjzV9WweiZ6DoxetDFpcwkHnGJiF
         UspIp2IzWNmJJwqvK3mrZlVeezAfxX9ibiKc07V2Hw/8/q8ycqkexVHMdskRMbvyujzf
         fLNQ==
X-Gm-Message-State: AOJu0Yy7e6otcnneVgaIRixInYFpONIiTZlif28m/rtN6+gHCHHVmKQp
	BOdtGoS9JWPkfKt+ngVQ2gsmrHz+jBmRjllcJP7fFu+T+2v+dbox3VwPjriDbPY=
X-Gm-Gg: ASbGncsP7JwS4A+Qr88p+TvvM0oW8v3JQCOvZwcYwXxCUgny9CXFEG17pRMQWZTU9tt
	LNOACIMOLN5TUJiOwSD6h1GpnHqsbzS5zgVZNiEVXDHAS8BNauMcPU2y7Pxivs0JB3uiya4RwTb
	7kBREtInEk0INK1r0ok38UTpn/8xuL7PFTgYdMHjP6bT0At4mAoTxn5xOpifxrgI2yRrb6zSTLg
	Ljwh12gPI2BtmjMbUnGBmagUA5U0dgxPG9xtgYuIUbmYkJ4IebINFfL00lYnJGnS9gor9zy246H
	8Yd0P9apXknrfM78l7hdL+NfirWvnEsabgoqoHLd2tPVpQQuAXfs50SHc2yVMFUOHKT6vuif7g+
	g+ai3xUwrPpcIOEPn952kd2HmEAhF
X-Google-Smtp-Source: AGHT+IEkcecHn0Htn5ABlcVlMJzuiyYg86vctMAyGuRrsKTB4IoF5CCoz34yObtxnuqTTVpntR6a/w==
X-Received: by 2002:a05:600c:3481:b0:439:9737:675b with SMTP id 5b1f17b1804b1-442eacba7b1mr26570885e9.7.1747131079771;
        Tue, 13 May 2025 03:11:19 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e138asm159084715e9.10.2025.05.13.03.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:11:19 -0700 (PDT)
Message-ID: <70f097b4-3870-46a5-84d2-6aa558ffd152@linaro.org>
Date: Tue, 13 May 2025 11:11:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 38/48] target/arm/machine: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-39-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-39-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


