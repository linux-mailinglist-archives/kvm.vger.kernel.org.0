Return-Path: <kvm+bounces-46319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11979AB50E6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD32E188CF88
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0FE2417C3;
	Tue, 13 May 2025 10:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vo9OhF10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53B823C4EC
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130615; cv=none; b=nN4UDXeWzd2755svXSlVp9RkRUBtNXmdVE49peyl98OLYSCeW4BSLEa8y1623yI67CjArYT1pkNQ2rU1uo5nHcjIY8vgj+qpB57H1AcZPUoxfFwPfxyd3n8JlK8O8YLCY+TA6gm8f71E0x14X17cIith9a9K6BTmtRVMKdNPG7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130615; c=relaxed/simple;
	bh=6U6SRB4kd6AgUNoRMuK7z47rr1DdLesfdIjENADZ3d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=crRTVugqsNdnyTz611LBWXYNNX6yq/xQY5j8XDULkFnv+5hDBHRI9NxXHIwfXLxEQiYFYVJMr9PN1cgBZlt9J1PnhG0slrY8ZLKpH/a1G/3yVQSNWiziM+bqDWHV9xxOcJk/vgjjkjNdioXd7S3v1m9ylFgoU05v8ZYpOcub1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vo9OhF10; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a0b9625735so2830797f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130612; x=1747735412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L/LxQMLiirTAwzHHf55PiXQBKZGHg6X4mycHe1m+VHw=;
        b=vo9OhF10bc11zhoug9pTZB94TaOy/cy/ehIknxUJq8snSLPBiGpBBARsIzytpM8Lfq
         sI/x9m0Kdq8ChKbbpxUy3eHyQFMh0sqvN3lsvjd6NUWlJNczWDed9pRFe51omMrzy3PL
         2Xe93Qiw/VlzQ3Jk64XI68ga/Kka3CQV0/TcOcAXeLKBNizSeZETOvlDUPj7RSFK9cVn
         hxaU8yzL8GQItyhwUrLD2O5Z8koTnPkTHg4y0WTtJMNzUtBzqL4lUb46QpHC092UgAGF
         ZmBZrjYYc58MU0kEm3eq3fH1LxAsPsAe3oxSCb92Ya8/Ev2ZqjbFYb/UGgIZr33HGBx5
         Qgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130612; x=1747735412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/LxQMLiirTAwzHHf55PiXQBKZGHg6X4mycHe1m+VHw=;
        b=dcn+BZ0C8JAylXR4xJyLjgrKt1LBUNiJgAdjUeseJ0DXEcHI7fxMy3hgRlJUFS3mB5
         BwNI4HMPMYYqj/MODzvqKqsYkXxd/RPAJIeARSEwG/99/FI5Wb5IYAWV2f5KQLUsehqw
         LQSpMoF7x1vta2ZuxZCshCP3OYhAl7UH59K3dpVb4EClKjJpkV2Ud7M4jeR2oiWgUGnM
         b3C1RsK1qWTI/Xwwv6XBI7BNAAwF3jNu61GZcaUZZbApqN67VLXNZYZp0YIej7TedpRl
         9OjTfRTHzuBOZ+pHQVtrkXX83feIDY/DReaTXYr1fjxZssjB/oJiMPPuVroDjN9WvrBI
         HadQ==
X-Gm-Message-State: AOJu0YyXcuo2vH1Tylq9q6ElsdmwHGDfq4SQoFrQWOPutOAJovA3ksGc
	1suk+tzbnCpQdUEO+xXuS86JCvc8gE/yUojQ9UzbSffBHFuwzXBL/qQBlpLUb6A=
X-Gm-Gg: ASbGncsO/m/vCnOjogoNEEx84kngLRH6EjX+cPCIDDDlG6PiecLxR4EMAnfZfsRrhXX
	8bz1uMVQPZjXJxGxY8gRkvBb6dQ9NARbIcA3z89ocr7vtIJhOzE3RGdA76nUzIPBxv8XUAzpgKz
	LG5zX/n/t3JupK3Rj7Iz98m9mPScGloIONsPGA4EsrdSbbPvNq88VyJvVzn8LbOOrplWX0xsNBk
	T+XGA6I3Z48ZkYLjK2CthXtsBxxfBqpxsxHd/nAX8qkVEk0pPoQgiZRTnXSctbAY+PoQsxxxUj7
	F170ApUy0q8jPuy5ydAA1RIPd4KUm0DBnBTVxwpBBawB5hu/LfFlOHzQ51oYnzImNI1uHL0ecxU
	F8J3bWBIVeYrOdamw+WQRAQR7TnnH
X-Google-Smtp-Source: AGHT+IHeMZpbCe6AjNqaTchvt3/JWTGthyYrXrKkltYuFRy8/cgx7qSRFjSrBA5eKOd4J++UmxSKMQ==
X-Received: by 2002:a05:6000:430d:b0:3a0:ac96:bd41 with SMTP id ffacd0b85a97d-3a1f643c6a4mr13835068f8f.27.1747130612050;
        Tue, 13 May 2025 03:03:32 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4d0dbsm15336725f8f.88.2025.05.13.03.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:03:31 -0700 (PDT)
Message-ID: <f18e1932-12e7-4a31-ae82-f6c4c11a0d9e@linaro.org>
Date: Tue, 13 May 2025 11:03:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/48] tcg: add vaddr type for helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-13-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Defined as an alias of i32/i64 depending on host pointer size.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/tcg/tcg-op-common.h    |  1 +
>   include/tcg/tcg.h              | 14 ++++++++++++++
>   include/exec/helper-head.h.inc | 11 +++++++++++
>   tcg/tcg.c                      |  5 +++++
>   4 files changed, 31 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


