Return-Path: <kvm+bounces-46324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D06AB5114
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5D1E1B426E5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E39244669;
	Tue, 13 May 2025 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xDLb50Yb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63063242936
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130815; cv=none; b=mZMHPevtI5SLQ+njKVKWM45cLv6irfyavlyLVWh0elKEx3dgBi8cdwJHeg+LS4Y86/esKjHjpuvYxsgFGIQB2VWkuW3Pc9+gQvn5C5kFPTPGqlKD8yxTHNvOFl8FS+DnrN671ZfZ+T3+G6JJhmfQj4OSz4Kd//v/Te2XOC6mV6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130815; c=relaxed/simple;
	bh=ncI9KE38X7MAhpO+cOMdBOs8kWIV0snwM3OnA/l2O4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qtgk8gWS41EIjFJgbQfg7ay3CzJQnoTkDrDBRZh1oPJZp0bUFFI7vY63IeY4OX43pt+b1+H+yBhHaz9oIRSZPelhu9nzONldIJhvpO1/UcowQL01JOUF2qSq8XcJAjxm/BNjm/tqYqVBLijy6KJcUZXYY8ZkvbSWvk4bSJBsmQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xDLb50Yb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so39108775e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130812; x=1747735612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rkdCcb2R7zHmNwKVh1SyhRx36X2sK+MN/Vsql2qiJgk=;
        b=xDLb50Yb14vBGzgDPTjutzyy0z1QwHyk6m6sq/XI3XZtvEvrFgta9jfVqxr004zZ/R
         JjQz/YAsPQfEaUf6BB3Of0OMbkP8tAtgqae9SXftWnn7/Q4bhiYVbXK1YwGseLn1zqVt
         1Cf2iJLrgGZc1tpTaby5cLUrIZ4cmEIlxYmJwwAHRSmcxqxgqvqi/tWHIcaXjG1iLcPH
         z6LN2B91ptXtIsl6ATlG6WEmg5kNtp3evf0pek0ikzOzzRFYjUsIzbGcY3Sc10RTR+rP
         X3by0MlUHsVoLDf/6Boc6xPPlVFrHMiSOo1e2Zt5GnpA5Cdp2o8flagIe2eErzC9y6i2
         YHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130812; x=1747735612;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkdCcb2R7zHmNwKVh1SyhRx36X2sK+MN/Vsql2qiJgk=;
        b=pWeVU7swWtgdriaODHRctRqkMD0SFur+FuWSmxKMdsnF8sb4sLxxMF2q96D1lAeF+2
         4D0aLHHJOEvRcz+6h6Bhy6SohyhxL9fuEiwgKreMHAAza4lKVIATvjepqmmiRkPYcMpm
         0/bgLF/L+tDbYjwxR7Z2mEv2+prKFJF/tm46OwOIaxieemrERsysRhhiWF4LCccMROHa
         yaSbMkcneVdvwEOUkSGpR7RX19OI2b/w9RjpxG+BCCOvfPW7UCHrakv32y7rghLk61WC
         bueA+zcqHLcbKgTA7BrI4vkJYnmQ2kySa2Kw3WSzdPMyotj+m0m1JIQFlis2RvM6GC+q
         ASfA==
X-Gm-Message-State: AOJu0Yxr5GWQrVbcjGkqUvuUMu/8sCh57gHpbQHzRD9ifzoEGbxrGY+N
	J92z/uPMAFxsyOAkFf5bZqlGwV+TXqXAxkqZzfZqamN0jYlFxtB+N9q2MkVv1VY=
X-Gm-Gg: ASbGncsHkHyvZgXN9lTLE0ciixQg+idPoMi1YixZ2ZwkoeQt2+2vrMQzc4Ay8vWMGr7
	PmCzKApyLqr09zL/kegeV6/S20IApGLH6RETEWs0A5QPkaLD/D7VE8CXVTu/i4K/+XFdsGvYqAR
	BKDxBVtSDUwh1hzxGlBFxxuDoCfH1O+PtYmx7/4Tx5pqEWxOnZjBJ12D2p2ebNoHx8JGO+50ZNe
	JSDAmzVc950HL0j0Tc7WhY7i4L5HFgcLKD1VRMJnKqbzF9JWLlwnrBtCXUYysOd6gIO3pSQXNfL
	iWVD0ZxzR07Wq+Ti1JSf4G9euy5gFWVJELwcBPHdcoLLkREHToV7LZ8Gx2NpjzScVN7MOU+J4Ph
	Cs2ArMkUzkQQs9Xlp+alhS9e3ieYY
X-Google-Smtp-Source: AGHT+IF59XNEL81dS1oW7vVGPK6GR9EouAGp2ff4bHfb3hVB+cV5LDsiKzGWKG5GHhh+AJSeeOHVVw==
X-Received: by 2002:a05:600c:4694:b0:440:94a2:95b8 with SMTP id 5b1f17b1804b1-442d6d6b65fmr152597255e9.16.1747130811611;
        Tue, 13 May 2025 03:06:51 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67efd26sm161229615e9.23.2025.05.13.03.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:06:51 -0700 (PDT)
Message-ID: <8a01f62b-f7f7-4ef1-babe-dce4cb536700@linaro.org>
Date: Tue, 13 May 2025 11:06:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 23/48] target/arm/helper: compile file twice (user,
 system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-24-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-24-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Nice!

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


