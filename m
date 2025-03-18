Return-Path: <kvm+bounces-41462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A23A67FE4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 315B6423109
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004C62066D4;
	Tue, 18 Mar 2025 22:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BC7I9tUX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CF02063C7
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337624; cv=none; b=RYsY/9ZWA7Uuwc1SQtBaSv2KEPZ8QPRXc2MLSwu/bBe8zkg2/LSjwFhgouowOCbaVRW+P9C3kZlgHKlCq2Tq/bINnFJIfzjpVBVKmLEa7ABgdAeU8ecnU/ZjRQFxlcf7vezu/P3PXRMhbn0c4z14QAMLgtzeZcfChxXuxUIu3Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337624; c=relaxed/simple;
	bh=KeNLQ5JPtLoGjDjosJ4dQLDoUm1AG0KYspFF6P3GVPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKEa9II+RUXWU9t2GmHJYl20qvnmSLjkYtQL1p+893WztfTDRblmbqgmcgcsTyq5sE4OcoLZ3tE40PJK7j/rIPI5En6MzdbtszFrhwLPHv/RSdnruZ200xMs+BcQARJh6F3yZ6oWM7mrWEuOGOwYLeULstNn5Rq5C23snCuFlGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BC7I9tUX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2254e0b4b79so17491225ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742337622; x=1742942422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2UPpQLFKR1qr5/RvZ9zNkJfGHI2MCRLeltsmk729qU=;
        b=BC7I9tUX12MNRYdiKsQ2cG2xzIVenYmPjnEp6AvT+iUERTjXq80cAekOGZZG877ZTS
         /wT8IV64WIWB9tzo2w3Jl3sU3DW+xL7h9O2N8tYWlRTcYeJxRV4ugHM7OCja92h5io3t
         369jooF4qIdG01TYA4QvutGL3DrqrVSPXXHwwMxqG14t9uASY0EGyqa3Iryi2zA5tKSX
         dBLsZMuO7pALpnaOlvmxo2iTmI8JxyZatgrJB8vuMgh9JO4P+4pyWVYFhc6ykKx0TFI2
         wog8pOUt2zcsu1pdfLemkylR5uKnePmn6V+/02jmsci17G94qXqTjxXr/uYhvNnMXuzT
         FGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742337622; x=1742942422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2UPpQLFKR1qr5/RvZ9zNkJfGHI2MCRLeltsmk729qU=;
        b=fYl9LXY6FJK9P8FO8qpQ4Xm2MsdK9+MSaAh77bJmfqEOXW7v8Kqgu4MSPTf2pnva3Q
         RSz/XgF0tCEy3qeHmrR1DZKu+riLWVTwDn+j3xWfpayrj0NhDCx7t9Dt1VbDnRHNE0mJ
         V/qiUHBLr93c0lrUHqfqrXgsLhSX0pGuh5xxvvf188RFAUESIfWSybiVdUlNCrpEVEJM
         ek+Zxcvef9N+jgu3EWCLIf37EimJjXwT8jSfdnWVVVdn/Drwti1Jlu/qaKYltYAJPNnF
         aWOF9cD6Gr/V/3JMk4xNJ3Tl7sMED2pwzelX9Ddfkqa8SGGT9LvD3kaflvQyiifaK4p8
         W8Qg==
X-Forwarded-Encrypted: i=1; AJvYcCVyXObT73qJ4tsi2JBpyl56luVp3MDQRglvLQsVFbrYcvE6SFkJGW8TSQyasif9h13RJy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPg0tNPRM/qvgRlMpVjJQbLUBiUbzIs3HhjlgrvGuvV1Wni36H
	mVDQHRdGzFETbKPniXSnlQ0cmeEeUStZf7r0op/XvT2IcCrcPsmUqmgK/lUcndc=
X-Gm-Gg: ASbGnctLqCXjFePwiuML16Syaa+FxoEaEUoW0e1XmghbmGCueN9LnxcPg2b36utdNrB
	Ys/xzwOu5zkcusDN/R+kKL9BM1wv4R1tzfaA8am1lskF2NR9rUIVSmcY3vIQh4BoYLFUY9X4B7L
	mxi1juqdKlkhQ8pidYiAbAVBZv42ooyAKfhE6Qqc1PvcTxwoaW9D5Y0+BymqE1XXiUMj76cOcXo
	aOXOxlzPFqh170w3VxBYhN2+DZU8w2mag89IihXW6msO24vxG9AS3Mc171/a0Ty16IZkFd2DITw
	8GCHSABYWFhl6/DWA43CUNJu3KA8U/CRV5E/NTc6K7s/8ocYOASpmuDyiBNskG2otF2+vKdqjCl
	sJNMP+eCOa8WEk2HBjKs=
X-Google-Smtp-Source: AGHT+IHhbx4zrSFVC9Erry5Z56X+U/eo+aBTKB3hU0AYmsuCxAbdXsclAmXZcf+supeAECu7ukRqHQ==
X-Received: by 2002:a05:6a00:80c:b0:736:ff65:3fd0 with SMTP id d2e1a72fcca58-7376d6ead4dmr711477b3a.16.1742337621894;
        Tue, 18 Mar 2025 15:40:21 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711529531sm10202523b3a.2.2025.03.18.15.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:40:21 -0700 (PDT)
Message-ID: <9556c183-c103-403c-b400-0942d42785d7@linaro.org>
Date: Tue, 18 Mar 2025 15:40:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] target/arm/cpu: flags2 is always uint64_t
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-9-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-9-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> Do not rely on target dependent type, but use a fixed type instead.
> Since the original type is unsigned, it should be safe to extend its
> size without any side effect.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h        | 2 +-
>   target/arm/tcg/hflags.c | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

We can also remove the comment lower down about cs_base being
based on target_ulong, since that was changed some time ago:

exec/translation-block.h:    uint64_t cs_base;



r~

