Return-Path: <kvm+bounces-24489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 254749567BB
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF3C61F22A28
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 10:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B442E15E5BE;
	Mon, 19 Aug 2024 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxw4a3vH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7761433C0
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724061702; cv=none; b=htlsvAfqIaB40nfn4oOsOhckHSA/mkI6tDKXm9JI1oYSlgaisrkdtjVNk1DPzdQaDC5QSjidey2UET9TGvA+TXqt5SRammtldmTJ5PKtr9HeLkSwCvkcm1MzIEzny5+1xXbk2dj70juAZlsUZn7IYdlnTqWTtPIfBxrOB1DEmSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724061702; c=relaxed/simple;
	bh=WKdG1NJmSVs4lziHmvLV1A1Z7PYhGzhh1oJ+XBfjdB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XdWknQmQYNzKmkVpbmfYbxqtVjBl9wbmjwlZoC6cvrlGvns1nGomXlFUgUbcZwpUYLv7SkF5y9YC6U0fC2SChW6sSyi3VdhLhTFSI/mg4z/1OvArcgwldvkncFVu2swC3YFOnOq6fP+E3jp9zbnrTbwkp5gv8B0eQePknB5h2yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxw4a3vH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-201f577d35aso1938335ad.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 03:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1724061700; x=1724666500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+/dZwR9KXDCL6u85V5/TrKH5gOthmBMTCYnjHJnT94=;
        b=gxw4a3vHC4+3DxdrMsflHcAotLDT0eajY5fNM/PnRjov0rn28a5qiJ3tbidtWvKFBW
         hQawOYidQrnnoiLuatFAzBaUVKOLmQ5e56jyhVWqadg3/V68dekmKUHzOjxcxG8TK7eZ
         sYW7SX1AOI0uHnC93i8eGRDttRHBs/fJQl07c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724061700; x=1724666500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+/dZwR9KXDCL6u85V5/TrKH5gOthmBMTCYnjHJnT94=;
        b=EpayxejzGnf+4k33sHfAM46VgBz8346y7dEWkCoQ8Bv0qZvt87XB1jPE5mA0pw2ZBl
         mHC6mfGochWrc/+faAVLHLhQZyNwVOKUa0ke4swW0BadXTidjFe7RIsZPYCh/wY6Y8JV
         kshcYxwgqNwStdukP5rLIKgb1At6Sz3g+FJUg0RNBS6o3FLSjIkTkySuEp03xQGRjarA
         5wD7qZj7XpN97DToSnS000i4kDgJ00pwXXo9shhJ9KlrqSzkhTZzvViLYFCH/H+LtQqV
         aW3I+KDf8kLKHLi47DjSMXFG0R3I1bRnS57A2H2RuH4upHhVc+dC/thsgK8i5PwIyVv+
         AMdQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/bo1sML10p8xxGt1jmpyfjDGe2Uq2082nmuY8pnMEpmgKBsKDlNxJsFaZjoUgs7RKfAzP/hzYUhtRKlq/5Cp9RK5d
X-Gm-Message-State: AOJu0YyBEjcFyt8xZUXBjB3oKlmoYawrLtFuQrjL8fLiGVAqFEHFDydJ
	R0Mfyo62xr1oxhmfShZ1dvVdkgwk8T3FJcIqEsM4TdhiUgwiPoAILh3hSpVk8KQ=
X-Google-Smtp-Source: AGHT+IEnzq1GNpBfStxJF2FcLGudBLyYQ9ABvejE0cVWJmaQbEUmA05IvPq3Sx1v384dEKKa0T1ipw==
X-Received: by 2002:a17:902:da8a:b0:1fb:1ff1:89d2 with SMTP id d9443c01a7336-20203f21a2amr74366705ad.6.1724061699544;
        Mon, 19 Aug 2024 03:01:39 -0700 (PDT)
Received: from [192.168.104.75] ([223.118.50.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03751ebsm60164145ad.162.2024.08.19.03.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 03:01:38 -0700 (PDT)
Message-ID: <59d825c8-bdaf-4077-be0e-d738b42d2dab@linuxfoundation.org>
Date: Mon, 19 Aug 2024 04:01:28 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests: kvm: fix mkdir error when building for
 unsupported arch
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kernel@collabora.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20240819093030.2864163-1-usama.anjum@collabora.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240819093030.2864163-1-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 03:30, Muhammad Usama Anjum wrote:
> The tests are built on per architecture basis. When unsupported
> architecture is specified, it has no tests and TEST_GEN_PROGS is empty.
> The lib.mk has support for not building anything for such case. But KVM
> makefile doesn't handle such case correctly. It doesn't check if
> TEST_GEN_PROGS is empty or not and try to create directory by mkdir.
> Hence mkdir generates the error.
> 
> mkdir: missing operand
> Try 'mkdir --help' for more information.
> 
> This can be easily fixed by checking if TEST_GEN_PROGS isn't empty
> before calling mkdir.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes since v1:
> - Instead of ignoring error, check TEST_GEN_PROGS's validity first
> ---
>   tools/testing/selftests/kvm/Makefile | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 48d32c5aa3eb7..9f8ed82ff1d65 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -317,7 +317,9 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
>   $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>   	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
>   
> +ifneq ($(strip $(TEST_GEN_PROGS)),)
>   $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> +endif
>   $(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
>   $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>   $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah


