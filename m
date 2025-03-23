Return-Path: <kvm+bounces-41772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 838D7A6D0DF
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 323D81894550
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689C7192B90;
	Sun, 23 Mar 2025 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ehMdmZg5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB3E28E7
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759187; cv=none; b=SPCMiHYgD6Q2iMYKevn0rHhtHwuNmQnRWvFJ7/vvKBCx26a9drI2pcVopExUWBPhwTt5fXx65yFYnIGZ04MyVeUlrfpy8+2FtK1MSUorz4tIfc+LaKLjafBSRupb7qr7Ej4vvKlqA0p/6A19FVXZMNTrQeryQzNJNYBvJwrB+r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759187; c=relaxed/simple;
	bh=mulXv/hlAC3KsacqMfy0G0qV5V5uSA1DnyfnJoRghfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=amLjD0ZutLaNEtfgcroVCYCuNwtCr6Is3p2zOUj1PNA9CjD31+TO6TH09KESYhxYUk9Dt+8nUm5R42hCLSxiuHNsJjijLl6vW+oCm8uB1omeoQASjhlh1hAX+s3F77yTIVDyY16xux/MBdt8ZKR2Qq38/cYBLND2GjQh4g2sjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ehMdmZg5; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22548a28d0cso59407915ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759185; x=1743363985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=73JOrMrH0Z6OmECYIAcKVMV0A81i86UDdhTtHjzTSVw=;
        b=ehMdmZg5PMWifw/SxBf50PwwE5j+m/CD4kjjq1ijOP/KbYHdkc0tPf8e5NSOaXWAPs
         Ds56e7k+VI/3wx85MReG/AAVuEPS8FlBUPfmT8OGngMk0VVY1b+2im3Z1lWc4qIY+Nc3
         0ToQ3Lurfu/XugsAD5z3AhP9fXci+nAKXZMUNPOF05V6MtNAgvE4rG0ZcKuQ4HsuwNMP
         bYQBCalPlPQkwEsQv85GTpRA4CpuzNs7ZKmpMulbSa/0w0gGr5m/jwDr7vEVB3rdeu7Z
         ffJZwDMQVebu/8FqV/MeMTX7OOqyWvzoNUYmxAHCQLim/naW6E1g/mF1MMDKL/OoWulk
         PjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759185; x=1743363985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73JOrMrH0Z6OmECYIAcKVMV0A81i86UDdhTtHjzTSVw=;
        b=EGVEAmLtTa2cQwzcQXey7axftSJ/j6e8kxIlMmCSe3OXKzv9w6zUDL9NLHnaohjfcB
         TvsvpTzlP+BTB7ByEwzWPFJVTfa6uNaDmF6YZzS7cPuiOx6DQbQe9uAwmm5rZmiqSGKe
         XOa0wku0E+yRQleRKXffPGjp2ayVCbhUhZeaHBmLspXFHapgwHU/0yH6xwujrmwg0Xav
         RlAgErvgbDjwTGEaIfpCVg2CVw08OS3LR8P3vDau7RSwldSltVKruw7hwmMFHu7uPhtr
         vLzP4v9gF/yAyxgaQefqWRHOOl97oLBScKYSPrPMFv25TCoGH9u7dzSQ7Dp8ii9uOqWW
         w1Sg==
X-Gm-Message-State: AOJu0YwPJnlNd0WY3nMBr9YPXpPoBqCrp8sILY1QMW/YNdS8hE0NrJOW
	PM385yZq2Ix9TrNpPxcFky9cc/a81kpAkHkqyiTAiA5u54OnGKL9UmX4iaTQcGw=
X-Gm-Gg: ASbGncv+QAMw4PqgQgk6yGMe4QTQ/S0+GtXU9Wsw0rKXNmBDqN4epzRyNCA7kMFvmMJ
	podui32TI+ml3cSTx5rP3QjQd+kmr8f91Iu5Fvv5qDBT5szKahJmipx0RAmPhlANQ7Ewy5bwUCb
	Gr/GnFBbyacpoMDt4tCnk4jE0obCdiqIexjzN7/h/hYK6ikc5byDZdnJrSXh6G97x0x2/ZKAu10
	jf47TtKuKirPlcqq9qDawAaZ4/vmjqIEuZfHuZUp8mju2Fxf1enugcmwAI+IqvOkdPDVLIhOJ10
	+VShkKaUyDrVt5Vf6ZDRkSP+f7i7UzFblxrOWCLqxZ3XcNbTSLMeoEI8XNnlCaKEOAwqGFyPnfT
	JT80KAYxX
X-Google-Smtp-Source: AGHT+IEXe8eNk0NgU5CdcxMFcebpHj1eWStPLTJQqO2Dczl9u1LAA+GgRQQHbdld1zjwLLMjIng0og==
X-Received: by 2002:a05:6a00:84b:b0:730:95a6:3761 with SMTP id d2e1a72fcca58-73905955da4mr17330953b3a.3.1742759185310;
        Sun, 23 Mar 2025 12:46:25 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73905faa5d3sm6441657b3a.15.2025.03.23.12.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:46:24 -0700 (PDT)
Message-ID: <279d069c-8bad-4cf5-b673-1237eabccade@linaro.org>
Date: Sun, 23 Mar 2025 12:46:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/30] hw/arm/boot: make compilation unit hw common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-26-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-26-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Now we eliminated poisoned identifiers from headers, this file can now
> be compiled once for all arm targets.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/arm/boot.c      | 1 +
>   hw/arm/meson.build | 5 ++++-
>   2 files changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

