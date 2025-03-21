Return-Path: <kvm+bounces-41674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB296A6BE71
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DC75465C44
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA481E22FA;
	Fri, 21 Mar 2025 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WuzeIq3t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E782AE84
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571767; cv=none; b=KsnX3XX1KyYLgZj1/slVQ+dWzbPZ9vTT/Ooo1gk0pJwtwgR7wVgWl1O7Dd2KjxZBE/UqAZ6nF8Ia1IfxpAP2gnQAUWORc+976qHz3pEAVm4zRCgy37ewzeguU2Nb/6RfKCgk/YODpcRcFeiwy4c3oy2GnuaJSNVFoGv4bdLJ138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571767; c=relaxed/simple;
	bh=W+UvwLhUjS5OqX/vU8vzJn8TKUp8wcIKyWTiNCIG5tE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NaSHz6bVFhcWJolp/OWs5sYVehPmxI8pI6owNdLNrC3AZIMSHo1vAwpmBivhUcEcouGhAOJyh+q/0+DWvXorH2nVsXwfT39fMim7RBoj5Vauz4eU4Ri954bAVzUCSs/yIGr8qSTsN7MT3mXBPOnHtGHbqOai4BqwfGPHA+mjmpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WuzeIq3t; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2240b4de12bso10474695ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 08:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742571765; x=1743176565; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yPv0x3Z1/HPbUhKDoJiJ7eKUBEGCPwgiGSQ1X1h313g=;
        b=WuzeIq3tBkjQ6zVhWWBevLoES1jm8UQ9tXDijXYrVBznzNH/nz1cjdxKYkt5LFFN80
         UxYJ8TUzszxJvMpr8z//N8+j8wMlRk3aL59DXUtxsSc6nkIDRSSZy4Gj0JKEFsAZTf14
         rEBk2QMVMobmBKB8VtpD8xUFaya3kIRd1MU6kKHRUNnirAA6JnnkF7zAP79enmcAF4eb
         G4bFXgQHii9fDI5XMruSsI92izYMbA+hOmVgX/0/GbKgQWFWPJL5CDxt6zo+eC3se0RG
         WsIAplmXzFtePz8QDB4s9z2zHGCMmZ1HkCQRikuQXqz1+NAbeiBQDlRF1tfj0cbpCEDs
         s/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742571765; x=1743176565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yPv0x3Z1/HPbUhKDoJiJ7eKUBEGCPwgiGSQ1X1h313g=;
        b=K0rBkdAX6zKk4teyhhu0V8MhC+4TS9ggpsgMLMwAsMHeQ6wtnh3UMEtIIBJVjiASEA
         Z7gEzVmpu2R7uaGVuj6nBAyzR+m/bVSqyev7BAol/uLdS0ABmrhkspPJ72VM2g+r7R58
         1H6nTTiap9L7qqWmqQSzpOBK4ccFx0xBDVC1O6LYNMr5d8zPKS/CvnB0UtpkkLeV/ndl
         ioh+qNi7BSi0us9Z27jG1D/aRnyRHrRv9Sgr8KWg7EgEQiFQJ+z/WU2qC89pyF3tCVXa
         DUsNTFXPsiT6tolU46iyviU/bBgpNPVbn8wElh63/DFf+Dq5W6Mh3FNXee5TiRIjIoxE
         e7LA==
X-Gm-Message-State: AOJu0YxXZcGti2Sol3twn5WM7zrAU6PZsf0NjlSSNqDqPfDHA9f5Spmw
	uy6xfWIldkfWMlR8AxtLocvFc2nOISog9whfmDwWH96Wi8f6oRDoldOxRMgFuFo=
X-Gm-Gg: ASbGncvC8y+Mo6cShtOYJ4I/hQRBX8JFFTcWyaec6+XDHV1oGF7UlvRW//zdoAWZSxG
	luYjE0bVYZVHaXBt0+4ygzFCwkW2ipX8r7dJllDtNwA8SeK165VGLei3+dhRIt7ecz0BNnNFZg3
	q0wF9kp7e0yvrGg6P/i/gEvZ4WtDVYgjBUwFu77W2vI+espEodPxqJR2F94cGpZa2gwhcKVKO6R
	MCrTwY2zFFoKRosDryycwt4PXAW41dxRTjORtt48KflUiyxszcHQ3gwuOU/6D2cIwaWJJzMGeg1
	1Ii8TMgmrrjUqgWM+jOpufWPoDLUpuHNmLrFgqqCIysdd4sMEREbBGmhR6JMHYyYKc0/AMpjzhr
	NOHXqap3dNt7JDEdOvM0=
X-Google-Smtp-Source: AGHT+IEJWPCbapPvGinlQxgYSSIe5Y2Y267EQ5fu6sUpIbsI0Qm2IeL2lKtJmthiaWExNJRDxAa+bw==
X-Received: by 2002:a17:903:2350:b0:21f:74ec:1ff0 with SMTP id d9443c01a7336-22780e14e77mr61853175ad.32.1742571765209;
        Fri, 21 Mar 2025 08:42:45 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf63610asm6221455a91.44.2025.03.21.08.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 08:42:44 -0700 (PDT)
Message-ID: <dfd1d8d2-9d08-49aa-8f74-50394e20378f@linaro.org>
Date: Fri, 21 Mar 2025 08:42:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/30] include/exec/cpu-all: move compile time check
 for CPUArchState to cpu-target.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 4 ----
>   cpu-target.c           | 4 ++++
>   2 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

