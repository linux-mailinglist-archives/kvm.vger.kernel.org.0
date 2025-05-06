Return-Path: <kvm+bounces-45605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08155AAC7FA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59911464CF0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8E32820C6;
	Tue,  6 May 2025 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pRrAP42p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0942248864
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541769; cv=none; b=rDWTctAIV8RonMlbh89bHyHhGuR/3EoarPxLoHjfRTBP4FaVz/hJ3vvwy1xgcebnfrro2JhunErIzosb60K1OKhxW2dBhDs4Rw2Mymfb8ChsRVujC1OwTVcoOkznTvVUDL6r06Vz5fXxwamjpPSZWQOVOcYFdSpEDlckKDcwp4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541769; c=relaxed/simple;
	bh=lMq3RiKCLgU17u0VJPbdBy8f51hnVHV/q24qWf0Cnj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THn2Uy1PIrgDdXxI2xXUS7dLHryiYs9dkSBCBsT6Zy2FKb5pGDotID7zOeVtcJNxkiyqBanZ9xStDGx7q2afdlA5DGxAkoN5xRckTHU8sI7RmdAU9jD2dEmAPMzr7Weu3uxi31MIRfPlqUwtuO9jEDmCfZnUGjQ6Dw3N/olh+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pRrAP42p; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so5178266a91.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746541767; x=1747146567; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+xINvCp1yuSIZKDy1B49HDPT1i1nZ7m9pEHLuJnqbng=;
        b=pRrAP42prjPzm9q4hXtTqaDLHhAkxT4L11kVnxqnKZKujewECL+6DCv+N8wobXJZdY
         hgOibRDE42J0CdHAcA4lIzT/vHy9jFIfOehqoJK1RuoaeWrL4NFROoAVop+WYwPM5AVP
         LU9WrJI41to7dkDrZRF3T+ViSnshN/IQEnyQAeowDqHwPrj1HAxZcNNE+siy4pCkPd/6
         bhOBxKY49oguM+/xP8fjXL3/vMKHQtgiDx4eE5H4V3OxhFRbsKrgH/mMuWRqJsiSdR+n
         LrNoMmYKYLK2aw0kDQXEXJBFFpklzKhi3o5WOAaEb9Xtf+luddCA8rxS2DIyKL81lerb
         bjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746541767; x=1747146567;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xINvCp1yuSIZKDy1B49HDPT1i1nZ7m9pEHLuJnqbng=;
        b=V1r3b5TNezV3MmeTBvIfnQbqbUDgO/Ex9dB15u8USiBvZbpfWzfQhwiOtJMUD/YZsf
         DD2eBV6z6kLvnErRlFIaewh9Oja2327m63PCrhtl1rwByI0mbolZjyUkt4u1QflvwV+U
         3RifN1EPLZ2UTO4Ckkh60HGCSg3wZISluE/FiobL/pW0sgQUpa8Op9+sXT0e2OSMP1Dk
         OKkG5g3PgGNoxmlXYH2Gp6jBo25Hnw+74FdNE4Pr5STdKoOBoCZkbIK5hQ8KgP4uUzKr
         ndGBHpIjFtpq/ptU7CfElf0IDScDG69Xu8nW1NiD2my8rLiqfLGEeZgrVehLeA5JAGxI
         Masw==
X-Forwarded-Encrypted: i=1; AJvYcCUIlZhiJL37fA3JPq1l55ovCcZS35f8l6QUKitWCq3loP4V0pyItdsbPKfb0s9PpdIOYog=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwInb02no1LMiksAwb38WtOA45A7hwJlx+uXAENTbVQDJDrb93
	1vdrnLJIXSD/qWerqrYUo5ln9X232c76L1EIhqOUQcTgQSfFLCxVlV+BJWnJWJQ=
X-Gm-Gg: ASbGncu5KL7KUji393vdgnVS+1gU1ITdPqdEDT0ps3rs4NFWMTaw8H//mjIh7Wz7R/e
	e0F2nYEIV4lRtMgnwiRwFzfp9GOQVgtCzX+I00RUAbC9Ie6VpgRneWJKVGhZUgynLbWy3sMVrNZ
	T7yjuamt7k3X95Omi6UcNvzOSiwNZvdrTXRrvSF87CuuV7Uhha8zQL3hMmHupQrxpAhw8cK1FZ3
	XWWsGISuOHBRA9ql2hFX4oLUyElFQjHOrfRJ3AD0l9W55I8nhP7EZdFqvpVvL7J0A5I52QemN3/
	59IcuyY1s5JoPB8LnpY0fWjon6+gky5z9YIiyqP5nXWy2yjbHs5YR+elILA2RFRSNvkIGIw2820
	m8F814TNa4+fH20pzOA==
X-Google-Smtp-Source: AGHT+IEDUi/EnB86qhU+JzPrafWvDcjWRRJ/9Iulngyz+jMQjHs0VsEnY8G6lGAoNiN5TVAYA9PJ9Q==
X-Received: by 2002:a17:90b:2f10:b0:2ff:4e90:3c55 with SMTP id 98e67ed59e1d1-30a7f32ccc5mr4172774a91.27.1746541767000;
        Tue, 06 May 2025 07:29:27 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a892edbe0sm940979a91.1.2025.05.06.07.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 07:29:26 -0700 (PDT)
Message-ID: <c374415e-8c32-4ad9-b003-aa9064bc239a@linaro.org>
Date: Tue, 6 May 2025 07:29:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 50/50] target/arm/tcg/vfp_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Peter Maydell <peter.maydell@linaro.org>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
 <20250505232015.130990-51-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505232015.130990-51-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 16:20, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/vfp_helper.c | 4 +++-
>   target/arm/tcg/meson.build  | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

