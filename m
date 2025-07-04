Return-Path: <kvm+bounces-51599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DEBDAF94E4
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 16:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F15E1CA5A44
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 14:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB72126BFA;
	Fri,  4 Jul 2025 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sy36+yml"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AB872614
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751637788; cv=none; b=o8JpCn/hZzvRcHi1h5io3tBqtJ4dq/Q5xgX1FypGry/g8ZsmYZkBBbMMUL5ySJoij8pX2nX7a1q+VJ54RfvJDxr5OA7I/u1xbJP/ctz21+82OKKOwfNuVs2gEBSfMeTc+Er+BrH2z4huFnRQK7IST07kAoa/a2SxyYFtk7dh0jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751637788; c=relaxed/simple;
	bh=XiL0inoXkiePeP4E3ibR6V4pjebRM5JWIm2EtUTsWyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oT18L3aBrjOTxz0DwJuZMQoon8LqTDR1D4AWqgm4fV6uN8oj4ItyIjJDMaZ23W/gcIlGyiD97YsL6GERl/dTYeCwkVHlIhVHSfSJql3yy6363FswhlkrUiQFATWC0IMoM4kk3Pdp3RNLErI+JThJuE/5fCqj1JcLLxvdXXaDejU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sy36+yml; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-73b0efea175so712022a34.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 07:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751637786; x=1752242586; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNq0c8GL5ZyhDYOqX8QVyvyzFsqz5xU7FqcEI7jxulc=;
        b=Sy36+ymlXCrcjacfVYOJBMAdbEiO5C3URqSfaZ36rPEKI7uA7COs82U2olyiTghOMq
         5da0O2FaVwl6DP3bs0AdHdDvxbQewvjWCWmvG2jcJjzaS6MKiF+USFxXjQxXjL0mijcX
         ALMg0IYJ48XR28MhXGVBZYGBp8paC5HG0cwmZd3JLrdxQqtmcTWElLTAF+NLxIjRN+Ar
         DKtY881VlEBABdnPShThsQUYkrLlCHTXZva4hEuUWLzgd8c3D8XLqPzmE8fBxEgC2LFv
         DoGmeRxp2JZ9EZH5vMu5jt76pmSeb1JF2c+kooC8QuR0jz67dWukf6A1cfT2ZHs+dOJx
         ZtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751637786; x=1752242586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNq0c8GL5ZyhDYOqX8QVyvyzFsqz5xU7FqcEI7jxulc=;
        b=BgldEpTFnwikhX5WSTXGYwgn+ufrE4soh9Akub99/n8KvGEBaEni7IIWDrMyxsNMLQ
         AJAKPM4gi46m9hQRtySWSy6GvxLmjy8Qwhhl71Z39Fp/J3EVAvGG/+O8ZH6DQ6gfIKPJ
         wzC5zXyBroTtWIzJeAgR4xEGZ0PVW5Y/1QgiZbmOuzvs8mclBMqarIAzPGVvmv3t6BIw
         5dxFIQbRHYRWuX+0xV3hHs1lwYN6ix13cQkGPIQsvEa2OHIaIt/WgJo8YJbqUxATK0wr
         3Z2NGQarn3/4Ps1M9ZqTUlOJr4J597iBDhl3ZBHGAOzqgQdp2nMP8F/Yeb/BIY6rcE91
         Be7g==
X-Forwarded-Encrypted: i=1; AJvYcCU1Hqh64bAhV8x/eiS7GQD635ktQGvnsS1Q7aWW7g96BDfwNsV010ajG/Vd2rQbJHI2dkc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAPGE2z3TLqimLgIVr9ez5rMDXrDKuBj9NQk+MikxS6oj9rFqV
	7i2yVffaFEsHRGpnIeOWZxBpq68T4MZAH0i4iIDQaq1TuiYafI2cqpsTYUvnTdxUJ0U=
X-Gm-Gg: ASbGncvBfZVQZG11FGh3RG+S6ER+kzQAjtMviuD0D59YAHSdTGGHvWBL2jR6CFQoK4y
	HSuQwIZk/4t8qDKm1qRMLty1Qqi0uY1TrGUlNt56XXwYjYtsoCVjbNi97oVTTzvlPZLu38KMGMS
	1srTCpG8koKbdRB98UmaSsc8MRSzkPSkdpTz6zePCGSk6YIPcoawljn1ipUa14Nh9lcF9hLe87c
	Yl+qU179s4FvBYRpRO6o/wr4whwfyCIeuMfowVD9aRreQN4SyDI5tPgvpJQ5c4I7pf5Sn3xtnsE
	bMPGNOuE2oNsXYWv4wM2mBRZ8Kei/vXtYMbhbZar6LeFG3MKXa3vm7ymLvzcUVOMOLOoPKdCCnj
	JRg8ulhQlsL0ZpXcGo+ruRjDkh+RCY41NQizYHx6i
X-Google-Smtp-Source: AGHT+IHCjZMWku2sXb4MaomGmkFzos2MmBGatOccfc0k+r2F+uBCum+atRQEn6lI9s8yQAG5RNVFtg==
X-Received: by 2002:a05:6830:4d86:b0:73a:8a8a:5151 with SMTP id 46e09a7af769-73ca66dc922mr1238051a34.17.1751637786225;
        Fri, 04 Jul 2025 07:03:06 -0700 (PDT)
Received: from [192.168.4.112] (fixed-187-189-51-143.totalplay.net. [187.189.51.143])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f735144sm388064a34.14.2025.07.04.07.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 07:03:05 -0700 (PDT)
Message-ID: <68bd424d-0249-4c74-a7a1-d0f46d46a835@linaro.org>
Date: Fri, 4 Jul 2025 08:03:02 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 38/39] accel: Extract AccelClass definition to
 'accel/accel-ops.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Warner Losh
 <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
 Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-39-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703173248.44995-39-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 11:32, Philippe Mathieu-Daudé wrote:
> Only accelerator implementations (and the common accelator
> code) need to know about AccelClass internals. Move the
> definition out but forward declare AccelState and AccelClass.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   MAINTAINERS                 |  2 +-
>   include/accel/accel-ops.h   | 50 +++++++++++++++++++++++++++++++++++++
>   include/qemu/accel.h        | 40 ++---------------------------
>   include/system/hvf_int.h    |  3 ++-
>   include/system/kvm_int.h    |  1 +
>   accel/accel-common.c        |  1 +
>   accel/accel-system.c        |  1 +
>   accel/hvf/hvf-all.c         |  1 +
>   accel/kvm/kvm-all.c         |  1 +
>   accel/qtest/qtest.c         |  1 +
>   accel/tcg/tcg-accel-ops.c   |  1 +
>   accel/tcg/tcg-all.c         |  1 +
>   accel/xen/xen-all.c         |  1 +
>   bsd-user/main.c             |  1 +
>   gdbstub/system.c            |  1 +
>   linux-user/main.c           |  1 +
>   system/memory.c             |  1 +
>   target/i386/nvmm/nvmm-all.c |  1 +
>   target/i386/whpx/whpx-all.c |  1 +
>   19 files changed, 70 insertions(+), 40 deletions(-)
>   create mode 100644 include/accel/accel-ops.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

