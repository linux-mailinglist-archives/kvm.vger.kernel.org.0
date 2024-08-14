Return-Path: <kvm+bounces-24214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E579525EF
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68D41C2154D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6441614B06E;
	Wed, 14 Aug 2024 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JDVnkeRG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A273143888
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675422; cv=none; b=qM4djjHSrYbMAJ9POz4wJroLoMniDcFsl8lJ49sOb3m6/Pkdmh1bT+9Mgjb/yAo8w2Fob6PpzpTEhhuMEitr+ArA5bBmsw03x80up+QiC7IKbelvF9l0x8Q+Tr840YP3jCqNs1IJszxlhPfZQ33i02uPMRiTmmm/HFxHoDd9wWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675422; c=relaxed/simple;
	bh=pezeU3C0tkafaqUrC5spbpvY0LXzHjVjudK4drrZetM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDkk6Ix6TVUkIuyHXZE1QexxdT+3CvOQxjbY5Uvmy8tJ1BwDcFnX1R8AubJh+WVjUADTUA35hJa7BMZ/8DTRCn+fBEVMpLoN+2wVGDgajQlAe/iy2wFqFDLyGsfTmFwd3LOHQGtHtWKjWNv3LL7pPApb6i/UQouAIknRbz3TWEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JDVnkeRG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fec34f94abso3902115ad.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675420; x=1724280220; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tvlP5kjU4m+y1iPTKUYsmqaU0kZYy62iadM9RfDvfhg=;
        b=JDVnkeRGaOmKQc9aFXIZGtpuWGgJpVcJdJPLzxwiBrjjpPTiHxMxGMFVFSP5tA0GCs
         287eAxq/706tA+dwejqlHyDoSew9mc4LYlQrO/zWmKuG67Us+epqedWPgqX2lCky+CFI
         OMT5+I5HgFE5gg5FMKf4TPfdcDyjFC4V1CZYCvWhRxb6XgegiqqPioxoIS+jw4i+eS2N
         RZkpcGerEAiyONqEzDACdEtJ+xbWUzNw7YtDCUhPETC6BjFL1H3t95g2pCW//+ktu56c
         ddPRbpZFOOxjzjpbq761Nu7+elYX4YHXS3IT5m9hxZCpyo5DG6vM5dS/9jGpRF9wppV5
         QHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675420; x=1724280220;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvlP5kjU4m+y1iPTKUYsmqaU0kZYy62iadM9RfDvfhg=;
        b=rdoDepIovfbvV8ygXF2FxBzWOBuQxfTa5soaDB7vPD/3S4vLX8l781dOuNrSMugbF9
         SZF33/3fAWDgCvgxzm+Ge/x/JnXJeckDFgA69YBJWyPgr8tLFwvNBMVLt44A1IPakxs4
         cEwMiAmnzkZaB+BuHyRejyzQz/r9PE6jf1GOMeLC7RpyAt8tNF/i15JaYIgbGD8Eo3oG
         1c/901gv9BzoN5Uz3bfnvq4YW3gkPgtqt4iiOSRjbZU4g+rDvX6A+TPxRVbZ5QnV7Fav
         TByleGDV2DB4HsnzP9pT5BO/bjQxKWL/OEw3mRuMgVS0Xe9oKYKCLu2D5ODk4hbMYqH7
         35jA==
X-Forwarded-Encrypted: i=1; AJvYcCWquUU6sBhkYNL89AQnJ2X0J0DMLyVbbZx9z8hLV74jkABELs0yXwawlTjAIhx7qD+Y4ix2HTNleNowI1HrO+myJgJa
X-Gm-Message-State: AOJu0Ywobsr3UL+UcmmWOjdZJGBwkeGxEixVrOHN+6HcGAztsrMBc+Ks
	VolZb78dwx9fsjpoEQuaahKxuXbeo3T8B3oUpq9zBwMfdipUFklz/Hs5fMB+Nss=
X-Google-Smtp-Source: AGHT+IEkctpY4qxf1n2O9muf9zJIH1Fln9uS5JpJVLgs7XwqDu3bjYUe3TE6kknjb+G/Oq+w+9g78Q==
X-Received: by 2002:a17:902:d2c5:b0:200:8d3f:bb65 with SMTP id d9443c01a7336-201d6398005mr54522975ad.9.1723675420387;
        Wed, 14 Aug 2024 15:43:40 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00:5b09:8db7:b002:cf61? ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038d453sm1266175ad.224.2024.08.14.15.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 15:43:40 -0700 (PDT)
Message-ID: <d674006e-96ca-48c2-a11f-bb0574beefe5@linaro.org>
Date: Wed, 14 Aug 2024 15:43:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] build qemu with gcc and tsan
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Beraldo Leal <bleal@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
References: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sent v2 (forgot to signoff commits).

On 8/14/24 10:11, Pierrick Bouvier wrote:
> While working on a concurrency bug, I gave a try to tsan builds for QEMU. I
> noticed it didn't build out of the box with recent gcc, so I fixed compilation.
> In more, updated documentation to explain how to build a sanitized glib to avoid
> false positives related to glib synchronisation primitives.
> 
> Pierrick Bouvier (4):
>    meson: hide tsan related warnings
>    target/i386: fix build warning (gcc-12 -fsanitize=thread)
>    target/s390x: fix build warning (gcc-12 -fsanitize=thread)
>    docs/devel: update tsan build documentation
> 
>   docs/devel/testing.rst       | 26 ++++++++++++++++++++++----
>   meson.build                  | 10 +++++++++-
>   target/i386/kvm/kvm.c        |  4 ++--
>   target/s390x/tcg/translate.c |  1 -
>   4 files changed, 33 insertions(+), 8 deletions(-)
> 

