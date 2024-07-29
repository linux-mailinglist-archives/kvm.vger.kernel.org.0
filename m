Return-Path: <kvm+bounces-22507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A595393F6BB
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16DA3B209A5
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F27A148FEC;
	Mon, 29 Jul 2024 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qX40lg5c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B7A145B27
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722259921; cv=none; b=Uxwbze+LAuX+ej1PMSlH5yedERpJV/0guH7JMPXh4sHSsAeIZS+v687k5LKEzlnprxkEy+6ZChs8+HeSNg6kUKje1HNzJCFYuZEPoH73mi4Hdeh0Mqrwi2UvEJy17SWCKQu2VfeImBHXjK6VGikLltkWbiBSfW4KthcUE2fkVVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722259921; c=relaxed/simple;
	bh=8VMVCwbi02wPPgQMVbzvjSCjM46tJkYY6cVGiKmguqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ij9lcIxVqprZD471lueafB8iwHMCshYUO4aEobFUuSSSlGsnBWYFp3Wa5GCMMzd2vk228r3j2eVwYavX/GtOzNKkCcxFZidJ84VY6ieYeUYGDBo7P3obdEnc39ZWSqViqsaCWzqceJOJaeCVoCymr8V46i1CpLkHKyJ2Q2fhFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qX40lg5c; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-368313809a4so1129841f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 06:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722259918; x=1722864718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQT3T6RmZ2H5qvtEBp4V600bTpbpclW5WCf38eHwquU=;
        b=qX40lg5c6bncBxtr3GUhrpKl8pWTOO7C5JAccMqjbhEx5AQRgZYfk/GfM+6u89z+Hl
         KgblvNt4GjsE7kNYjIM/og3deH83X7o7nc6Ix2JyPHXayZIAjz+/9Wnvzm2eeUfbIAH1
         a67HLoZ7jJxhE7V7xkUnl9ekLPC0RFZ953nMU6BnAgR/HJtM1ROSfKbGGRgDCMn+LixJ
         y7WSNttu6R+itelTkLJzQKf2p/g50oZKRyZPHqRHCCf2iYGkkGGPspekKY06Mh2GOFNc
         SaGQZJmO2ORj8tyl6XdBggF8EfsL2edd4Mbl5x8usDC7rhJL0Dfm32HWUOHtvVN9fe5c
         +vWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722259918; x=1722864718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQT3T6RmZ2H5qvtEBp4V600bTpbpclW5WCf38eHwquU=;
        b=gvT1DcBBga7A/dyqh2pnRzJu+tOi879Ivgr6OQLWoWHwHSk5etDw9NjKFjmE7fZBKC
         2h48B6ltphr4tERaWDZ+1U7vOXNIz+nMz3orI0Xtou/DidI6ewGlSQF1zp4ADYSJ7taf
         Ck/jH3a8EA7LEN9CSQ7eyWqkRHC7o/P4HlvyRjVTrPDGEirtcm6g8IDd+mIdjY62Q+2U
         rpiZdTxVkl4/NdNvY9kURZGMCTJ+n+TcjsY1rj+UoslVJop/wB2yfwisApKr655OaNt/
         6tayWTxX0yi69m1McU+JXG5virRyBmKh4wgxBUezHCrhgDHzKK+IxPRIedDIDBUXBhSs
         bGGA==
X-Forwarded-Encrypted: i=1; AJvYcCUW6CmRgqXQDOmgmE1fNPhxkWNQRdAeApe0Ub4W6sn5y/OpD3oYdpLQCn1xW0lpr+AhRMAKNYFu05BdS8Ssj5jy1kxW
X-Gm-Message-State: AOJu0Yxcjphvy05AoPsFBur+78wtUKt+S3CtI2TtLrpMP8o2aVlQZg25
	Rux+UlJWN90h9gXe9P/bssBKcOdTsvXHor8MbfxO4dcl/pzaMqh+si3IHx2+WdQ=
X-Google-Smtp-Source: AGHT+IE5cgvLd+kbGwHgIBV3aDODiXIYjj1tV1CioKxN6XGbK76LVWvlf/7jgZ9nTFITZ3JFg7QiEA==
X-Received: by 2002:a5d:6508:0:b0:367:9048:e952 with SMTP id ffacd0b85a97d-36b5d7d00ccmr4827409f8f.18.1722259917619;
        Mon, 29 Jul 2024 06:31:57 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.173.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4280574b2c2sm176563135e9.28.2024.07.29.06.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 06:31:57 -0700 (PDT)
Message-ID: <64440298-8a9e-4b36-b1e2-0a9436bd5c12@linaro.org>
Date: Mon, 29 Jul 2024 15:31:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] tests/avocado: mips: add hint for fetchasset plugin
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
 <20240726134438.14720-3-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240726134438.14720-3-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/7/24 15:44, Cleber Rosa wrote:
> Avocado's fetchasset plugin runs before the actual Avocado job (and
> any test).  It analyses the test's code looking for occurrences of
> "self.fetch_asset()" in the either the actual test or setUp() method.
> It's not able to fully analyze all code, though.
> 
> The way these tests are written, make the fetchasset plugin blind to
> the assets.  This adds some more code duplication, true, but it will
> aid the fetchasset plugin to download or verify the existence of these
> assets in advance.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_linux_console.py | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>


