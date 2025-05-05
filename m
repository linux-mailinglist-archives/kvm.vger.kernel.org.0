Return-Path: <kvm+bounces-45444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E86AA9BBE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67CBB17B497
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2BB26FD8B;
	Mon,  5 May 2025 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z8Lj+afZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8225DAE9
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470517; cv=none; b=q8ObUYbvN2sOT3L+dnzrT7cBGd2iH8/FyqRThgO6814yOe+9tK3He/z0bYeb1fIAaPS6L1T1EbVBq69ZAN6TsTgrHpFaj4IpLOFFNjUNxTIAcejQhqnMBbSb8tiCw2OGeAXQ/scDthz9nfrvjoAsUizIHMHdOkYAJeK1fmy3vF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470517; c=relaxed/simple;
	bh=wGX6pd4ViH1Q7FNnH/U4YJV0fr/UUOWOR7a3xlsJquk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSIk/MQw1gbL68V8Mh9DFtL6rtdjDUlf2wCNWXpNgXCwhUMelqPP7ONsQ6v09tPRb19ZfsJgaDBeS5+O2qxVD4BJwMt7PUwHC8/9hX8GUq2fY0FkRAH6JfgOHbsoU6phAUZxxZ+8k1P3LAySxCGXNyLecnM+o+bS2QE/hTL8Lck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z8Lj+afZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e15aea506so40155785ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470515; x=1747075315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hz3YfAN/v/roHV/d/6p4A5MsxD0Hnsa3hZReJcliBIk=;
        b=Z8Lj+afZjNcgy9sVjFtz29Pzc85LiYBr3/nJQOohEDOuiZKZRZn8TaVlD8opN1CHOp
         aofL+WjYJW6ub5Ki+hEFSvOWA0/q+mEb4u4+Hyrhqn3my7/uUWyMEP9MulQS1a3fFhgh
         4d32Sl6hkfWBGPP4xm/gJ7edczNZ2A8nKwEc3OeLiczUw81wNuBjuwYI7tiRJfb5zSJo
         IMZ0DsnnnU0CFkfFIAZAl2bdwVLhBQN/evX2yhdt72BW3tuoRWQkNyU/x5IQXBmZKogE
         JdDw0IXLwOBMWgNXJAl1s19YmRP4O7R2Czw4H8eFlq0deLzMr/EL2H4jmBkeIXOmkYoP
         OZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470515; x=1747075315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hz3YfAN/v/roHV/d/6p4A5MsxD0Hnsa3hZReJcliBIk=;
        b=RjJrbyL+PKlianOekKASZodCqXjnvSqV4toPEf8Tjz8FtHFAX77ERRLSIpUq+CXPQU
         GYKc6p7rLFEBkcoVltEZpW3xYPglEcDj3ko3O38GD8ubGDt0koS0YdYjtdfiJ/N+b57y
         JzkN77Cwl3MHvltW6NfunzCTjnkouYLQlbV2XGhwUcZTYdtmAu//N0J/SJyAGp9cFtR/
         P5r2TNlE4WaRjoh3hNQUTXujv54IHDUtIR6mQQJCahrRiWqhjkAu4LDnYXNPSLdiuVw1
         UB63RQ2qX3I1/zM2BaTahanM0L7ifvxzg+UvhFRmja7dGgTz42go+7Uthz8HXhJBajim
         EuWA==
X-Forwarded-Encrypted: i=1; AJvYcCUCOBPCTmwTbltP+VY5KbTz9Uw8m7Gjms78Q4FzF201zeJZaW1CYmCmHm2ZRlWF/GqkK0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvfGvRmRP1Y2UXMTByzJ/JI5BvD2QPJlC03QVTRGDQijbwkT0Y
	QB6A4v0LWKHBktghrtXQu9cqYxN7cJqUQIzJBMxD+SV8esJ+2fKdl+Qf8TZl2xM=
X-Gm-Gg: ASbGncvDbC7RwZOq7jYJN7Y8b5yAqopZPjeyFB7rkfFltrUfxH/U0uqiM0GfjmbrHtx
	nWStVGORlhJR+PvOkv22T3BsvBXLIZYp3ngnoFK3HaLSAktQaBQIMuQgzGnjBtjxIcQ7cDRadhj
	lWMLr8ttpCKymCVV7Fh5/4/5MfQv8xys0j7v9W30FXvQRTp+V3dNsP2d06+MjB1+36LgcNwF2cB
	aRTEcOf3AskJ5e4h18KBu7GqimD/poKFfqZ3QkhP/9VZWuyq/kRjFHwVDCQQqXMnbyDF7kBTls3
	F+3w8t6SJMRPxo2x5wDOdOI2k5VPAl26zu6rfoO9PxKTiaKd5UEnuC91lIu6cA4alTGDVbDWTGe
	7V9Ltn55jxdDtXpn2Bw==
X-Google-Smtp-Source: AGHT+IGp9Lyl8EaufIN5bAJEVq5LU8JhfWf77OkXZf4gRl0aZ+kGddzDwCFSLhDMEOK/vgzcuYc6kA==
X-Received: by 2002:a17:902:dacf:b0:224:24d5:f20a with SMTP id d9443c01a7336-22e1eaeecf4mr154391995ad.48.1746470515597;
        Mon, 05 May 2025 11:41:55 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905cf4asm7415678b3a.135.2025.05.05.11.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:41:55 -0700 (PDT)
Message-ID: <cc6d8613-e0de-4b70-acc1-22bb30549ff8@linaro.org>
Date: Mon, 5 May 2025 11:41:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 42/48] target/arm/tcg/hflags: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-43-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-43-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/hflags.c    | 4 +++-
>   target/arm/tcg/meson.build | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

