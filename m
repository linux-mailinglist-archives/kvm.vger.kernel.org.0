Return-Path: <kvm+bounces-41777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52CEA6D0EF
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 013CB3AC6D7
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6692319ADBA;
	Sun, 23 Mar 2025 19:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qJBRZzbq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F2928E7
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759513; cv=none; b=S5JjMmGNG6h1FwP4fMLOefN/nNjCcQ1MRV6IfLNtLwiKzN7ago0wIVAti6eI+u9FteNAwWNjFC5Us6tG9KDp0DzvUWEKYPUtn2caLoIMOSFlldianPPoCId07s8CGQNSVas6T+pmIBAhHzq1cr1G4oIA7bZpaM1ns2NEE9uiBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759513; c=relaxed/simple;
	bh=xKsoSUEpg1T4HF8xIGHF3sgKSSLZzX0SURca5o9CygA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PeDNcMHLlvn6pxpwsesBBrCNU2wkWu1aPbfQVjDn2c57NhjSE7xv3r3Ut/SwnV1NnYwrRWGZg6gnt80Kd7FnnOmkDL4xulnPQMqv8dFGMGOSvv6/8uqsOJQDp37a6DDwdx+Hk14gVwQo2baRK8icbhj22rb5SZjPDKEw2hIeysU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qJBRZzbq; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224191d92e4so67094175ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759511; x=1743364311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i0LHmMxcfXYfBbwN2Vn1ZoEDENU5Th0R4oTKC+bgm1U=;
        b=qJBRZzbqBHBy36jXiLn5EPWrmN+heyfahF6YLNLoRC1oO8opXEZBVVVQyfFZ3glIMO
         rQfxfA2hOzNZY9I9tfep/2sAYWYzN1cYsmp9BUXbEWu4J2aGdP/ybFbYl3CPTlAZhdGa
         jPUbXthB1Ls8yCZqxZbDEAFXLPjZFgAZ3dg/CtZesLWstU4EaZ5r/BstgdW+ox2nAGkw
         7PBiBKtvZrFJheo9Rl/TtR83pYJJnNvNSX+5M4s9t0S6qlf30kQPOkfYchC0ND0NvodW
         BIF4g/QY7XZL3AUY/p8hpbAX0dHCZLRjU710KM9UyZdVxMDS+aJ4dalmBMO5LZM7Olxd
         lxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759511; x=1743364311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0LHmMxcfXYfBbwN2Vn1ZoEDENU5Th0R4oTKC+bgm1U=;
        b=RUWJgvQeNPgCUTVCE0+4Vc0ncR5B4qwA3mwVNEIwCwF9m18DdwnmjxUSBVqDSkijr7
         4zBAaG0y6k2V0BA81jzQxfPnFgxfruBZW1ouy52jWKPCj/CrYK2h2igWQs0NIM5t+41a
         /u+O+tiZ0RS7m/6TUnklYfwq+7WinWB6Vh2ILsbwjOmA/khTllBWM8pIsLutvFT37gfo
         kAS/e/xDDEH1Q7OCJcfIsvgYNOs6DbrCV3ZBFKW0pSZi9CE2a5Mp3UbRLtfhFpMTgt0y
         J+aE1k5c6mFN/aq5byxBih2fyRbXq5pnh0zHvRN39DOG7Am+2GIowjG/9q+GB6XWcN+m
         eSBA==
X-Gm-Message-State: AOJu0YylCfGwAqup0TZfOfq6DE2NAsRi5HKaeesKCgwBWeKTXr2kMCNr
	qNOKChkzvuMvqGCqBTSke3lXtkawVZR5UQ3UKG789jAeXKU5BsXs4mnZecfYoykkkcIlhZtbB/g
	m
X-Gm-Gg: ASbGncs7sKws3l1IlgGfn73U+dGtFSIwtyBbdrWpKdTHQrf3T5Ymcg16jtW2VbWP36/
	FJCrGvC+rhLp8fSBloRHFfLwEc1vF62bmmpCl7is/Lsw/4B9OvOo/9cjWdtzdCJdlgryZE6Jm2Q
	PU7dGXAmvtk00nQ53uh781z4XZVPvWt8lMLCpxkbMTtCNQecYkWhhjrT2Bpuoah0qakj6Y8vv3n
	GTmlAVqiZf9/W+k2spxMOeY2ctG4dWlKFG5qlGD8dydZ+whbLtUNiKEGypsbIe82VfYHaPnAWOh
	/iYxZlJyzMJwUXvjpHS4cI9x0LqacKB/DjcNvmxH+19nDFnLFfdbaJ758OwwM4u0dlvCDifNSuB
	dllWxrWJe
X-Google-Smtp-Source: AGHT+IGo0frLMbZ3TBKUd7+4E2Js6IRd5u5loZ8jKeTUJjaEuSwwRFZnGgYkJGT64JaP8+5JDD++Lg==
X-Received: by 2002:a17:903:8cc:b0:224:2384:5b40 with SMTP id d9443c01a7336-22780db251amr198184305ad.24.1742759511499;
        Sun, 23 Mar 2025 12:51:51 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f397e6sm55330195ad.46.2025.03.23.12.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:51:51 -0700 (PDT)
Message-ID: <0edf7841-2e45-4e1c-b521-1f166a8eec81@linaro.org>
Date: Sun, 23 Mar 2025 12:51:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/30] hw/arm: make most of the compilation units
 common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-31-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-31-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:30, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/arm/meson.build | 112 ++++++++++++++++++++++-----------------------
>   1 file changed, 56 insertions(+), 56 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

