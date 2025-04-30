Return-Path: <kvm+bounces-44970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD33AA5410
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 634347B353A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E398F1E8331;
	Wed, 30 Apr 2025 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qKvntsTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C603F9D2
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038882; cv=none; b=MkKFMXUS8+vmwdjHXugDLDRaU7Rq82J3+QShP8zXS1HQ47grpU/kVuHCgQLDx1uDQa529kIEuDZNGQHo2qHX+TDEhjshRkBOs9jSP8BPaLF+cRWMYcR7QyZt9VQmUFZv5RD2xr2Wh/Y9d+udQYIxSjvqfxz+nDf0DY9PpNM/XTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038882; c=relaxed/simple;
	bh=778jsJyZZtm/ZmJiF9p4pW85kOGxS3gzN5nxEifkH8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlvpjMQsaE0PAayXhUMMYSso3GMqL8zUAEx35Mlr/cIW+QJQVpXH1CNqXEmH+i9yMRDfBQblm6Ek42uZuAuG/uUDBjU+QTavrG1ZGFhj7OMbMOdZ2HHg4ljZCCD8LbzNPDArM+3Hai9Uu4XLDnHbYnbsspEf/JPoG/AHHbs4j+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qKvntsTa; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso313465b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038880; x=1746643680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6JkT8Xl1TSD2JMlrucYuTh8fIekL0brqGTy6sex4sQU=;
        b=qKvntsTaQMInZV3eUQ3xJ2rYQEjElgjNOG89Bp1XYtX+HAhOeWiRc6ApCcose2xcLZ
         MLJhm4HVaTQ2dHo0Wx4xdhUfJNJ9HVjLMwHh18g7w8G96uatf8ky8kcuIXO4/80/ZWyA
         IEmrNRm1wdPosxTbfnVKc8W/bF95eI3B+MnoHs8EuxzjdTmk4qQGGsVxsn5j+56fp2s+
         VzRTInRBU1a9krJfM5hcl5/mT3a9RlYRyxChn4UqTJ162mxviqIiIUuxj5ud59w0oAw+
         a0KD2S+sITZTqrNYPdQBcaIE0XYtZcH1GDT4n49/rNWtacZ06rp03Ciau0YGRjtGqAP2
         Yn9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038880; x=1746643680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JkT8Xl1TSD2JMlrucYuTh8fIekL0brqGTy6sex4sQU=;
        b=BIALQjnYNBWaox22QdvWdSL4CoezFadDFHcJDxc+IvGV87CMSSfZlK/4v2NidrIyST
         kJLPfMR0lcHtsrbXr8YpDX538L+CHid6+Yecc3nL1BqMdZCVngSSIEcugcXQLsxADVwy
         FZVfSSyfwHgTq9n+TEjjonUq1VebEENljL+XrIO7CUtZHM/YvXIhSWc0Zc67oqcJ1gwY
         I+JOYvT0b8sNXNnXw0JE8mo9SnNhdKF7IY/WqlYpIPj6wJEZk9h7wSAAtCriKd/TLJML
         xnEJeRGEaR8Db9th+DBE3AeChaxL+/PXpwRf9GPGX30f1wm3pzrxO/d8mKrW5zLGmKMd
         0P0A==
X-Forwarded-Encrypted: i=1; AJvYcCUOeE30MPsA840Kg5d1oNuhwzuHMvwKYLeU4Uo/Dmp7NJGfSIpciZreZGqDJoEnFoXM5vM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFPqQ9qP3yq45ZzIWFCnnA++VVvFbTUe52z/1D3i1g3lAGjmd2
	4q3FU6sMNmH+mumppKXn8XeVnUlX6CCCat4+sIRMr8zKqB5nmSGPGDj7FirOVA53eEqOJGpc2Dq
	I
X-Gm-Gg: ASbGnctU0WPKBLKtT5JHdWgJQ0V4LNLWoUYqEePI4crMFxzqRfGAs1nqF2CEPgpsf75
	OrhxI0xE4wozqG8J1G8r1UWWi44eA27ugzcg45mNgu70LOusWN/UR/zCAv72MOl2V8lok23Hj1g
	MxB3hqGv1JTLh6LU4jVxhIR64wqqFwMn4U4m7J5niwvtUgz/j/zF3BY2i92e2tg+bHqnHq2dK41
	3Ly+BFCw61eGkh3i5swP60b9V3Bgzf+XDsJMoCQAFQxCp8TYyDMm1KsyyqqNBAYDwSosvB6O9AE
	e9mgz+hQR1cnMFJi4LtjmJ7ElSWHFp1nwOF+hdoJ38qrjP3uSBldsO+oV80q7qSL3aLRkeDOF4M
	cxyrecVA=
X-Google-Smtp-Source: AGHT+IHBg+zhfXus0cSoBM1olqTbRBiyZ7d5GFmOywBPYAuNBzjBpfDak2xp1ElEStVqIw5M9m1Wjw==
X-Received: by 2002:a05:6a21:398f:b0:1f5:97c3:41b9 with SMTP id adf61e73a8af0-20ba6a2019cmr465941637.5.1746038879803;
        Wed, 30 Apr 2025 11:47:59 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15fa80fbb5sm11036284a12.55.2025.04.30.11.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:47:59 -0700 (PDT)
Message-ID: <8520456e-3e44-4028-976a-45d683610a8e@linaro.org>
Date: Wed, 30 Apr 2025 11:47:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] target/arm/cpu: remove TARGET_AARCH64 in
 arm_cpu_finalize_features
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-11-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-11-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> new file mode 100644
> index 00000000000..fda7ccee4b5
> --- /dev/null
> +++ b/target/arm/cpu32-stubs.c
> @@ -0,0 +1,24 @@
> +#include "qemu/osdep.h"
> +#include "target/arm/cpu.h"

Need license comment.  Otherwise,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

