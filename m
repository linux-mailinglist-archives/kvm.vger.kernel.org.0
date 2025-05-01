Return-Path: <kvm+bounces-45135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA94AA615F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D35389C0696
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560081DB54C;
	Thu,  1 May 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rCs6f93s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255A520D51A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116709; cv=none; b=DPJw94RbqKPsv+ZXdlkFrDYQB+8QH2JsiqaYOAX48J5dpZwbJebBnHBk5UbSXKSHKjAGO37QVs+pNwuKdEfbGDJbmPrMe8JFLZjk++eCKz0jumXRLiUrZBs4peb1mKVypvtDaFsXZQhE33qBC04gdbcbdcXtArwMm/iBiPPp5+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116709; c=relaxed/simple;
	bh=4W8b9CyFBMT6p8aApfH5MHo4UoDls57aeihj35ASKRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TENxit7zQUqAaC+2jlVCS+zCn1OOCkdP21rVBk+UywN28AAykTiBxszeZR1bGDFZHt3t4x9cxU/OGMHaIQmGTEDSXXe5fxQ6igmxXs7ft2baOd8vZPQFIWwENfkBDatZmBCXh62p2MfaXfF2We4erdsXIyJs+e1WET5i5yaapjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rCs6f93s; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-739525d4e12so1225627b3a.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746116707; x=1746721507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=rCs6f93sKQs1CCjJv2RzvM90Nfi0r51uyQyvWf5u68ulBLJQyLc0oS0sOTtr6Tcq/T
         qhJxCv3gX5f/gSvmPUcb1qs0VssXGIS2qlnY2k8O2MfH4XZIn1Ya6hLCVkcpzBBNvYRF
         29Srxz+dhQJhktlTljN6YRe5ALpEyw9AyaFxKNcla12SqFref7gMLnDud0lwSTRLmmWD
         /uJ4zsEIloFL6C6BiMDo5cVOCICdJ7P1a+c6W5IpaqVnWE+1yAeZ0D1YJe1cPlYuIfn0
         mmWeHM1gkH342dcpdY1LNz0D/49DlQ1WIdYUEf/rWimrQXJyRy8w7/3BY7uZaysX+f7r
         5cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116707; x=1746721507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNk59ZUe6VB2+qVVwcJX9X+M3hgSClHFSRBg0Eem0Gs=;
        b=BzMoAWFD/KAdylg6kSxV8iBob9m67ZrumvuKCng2fdHbrLuwDdbZrnCjm4+srEyyFH
         dSqTAu2lRGLFiELWrusupbut91d6lD2PPH9cM+eBg7AImyv2mkStYwDC3eos0jgxPBeR
         gWPaTsicEyEL5eABdTLIBtVu099MexnQbYvhUiFgdYUW73yvJtc7ZcYCH3HC3VX2I8aA
         A+qFqBXBaEvmC5VdwDmxNMWtnbU+8aAVLwjldi0Nh0EprxxHqyvzwIP4vS0C3RKACktI
         b8px4/5YC/SGnTuguaL37zRZV2229mnqfET3N4Ink17irAAWRcI6Ql/Q/M7kQ/6/LmCC
         tIaA==
X-Forwarded-Encrypted: i=1; AJvYcCVc0h//gyrQGnT2EpBYpL/FFIU6B/lEjw9E7Y0h1MSIOJ54m2cwHexiVzCRNQg7GaIk174=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSzvUYEZVgD33Bjq/xlyRfka8uPSMbLYiKU3Vz0W60Dv4NPYxs
	A2ipv9IwLt8INoTr6oW/ykUh69FsoyjAdtlPgca0aULghwT6qV6kS8fS/YHpZGs=
X-Gm-Gg: ASbGnctsdOvytwAt9ZMG5BvuOg69PISOgHLm5do+u0WLe2SMkBss7OUE9w/3JzmCG5O
	9IqBbpBkO9HsJ/fzONzEWqmsJEmcSIrzDRE7kx4RXZaXc5T+NkBRS/Pp5ckjYcxXUbVAEpA6DFx
	xdI2zAc+GGyV+pyvCiv0FDRfEqg+B/dX/+rF+5OQkbcnpJsKhW047PvesfFahVOxlLSa1PbzL+T
	1SPXmRACzY3MudnFh8qaMyehv/qreGGt+84xULxxV524qaNTtLSYc9ZuDhfXRWl+RqllttPUaMy
	r84xbcgE2tzd1UAdZUh/RYe2s3Hfn82YubLC1KO5/KilxpX2E1mOpq3IJe7Pk7Rn8FwmznMtcKV
	49mI1z4s=
X-Google-Smtp-Source: AGHT+IHYs10iloHYrQh2kjmtAsUkB8MQeuBbK00pRi5XkfUmMDFdDqej7kPqvmBATt7xswRBv62qAQ==
X-Received: by 2002:a05:6a00:2405:b0:73d:fefb:325 with SMTP id d2e1a72fcca58-7404918322amr3877125b3a.5.1746116707417;
        Thu, 01 May 2025 09:25:07 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404ef14af1sm1005693b3a.48.2025.05.01.09.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 09:25:07 -0700 (PDT)
Message-ID: <59320c42-466c-4c23-8da6-91aaacf48f59@linaro.org>
Date: Thu, 1 May 2025 09:25:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 33/33] target/arm/kvm-stub: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-34-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-34-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

