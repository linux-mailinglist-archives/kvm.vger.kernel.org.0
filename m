Return-Path: <kvm+bounces-52104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABC9B016D1
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB61565E30
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C596620D50B;
	Fri, 11 Jul 2025 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="HY3500yC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921357DA6C
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223871; cv=none; b=QhXxFPXIKIo4NTRSfOksjyJZfP/a3BQV6s0d4adjK+NKJfAoH7brEcZh2Sdtt7NkClOMkVs9IsvPie/k97y9cEtaQDepG24KKqrvERIggHxLD07oYqBiXv5JFHdGy+cXAbmcZWYmKrbMnnN4aiQTN1aNpZUkbcA9rQ5InDOMa6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223871; c=relaxed/simple;
	bh=cOpNarnP8xkXyeK+wQK9G4fFwvShV2VHZ7nxWSLkzcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W37vDGSIts8W4WaARTyQwLcSg7dEFgHWOqqU2DKHhQ4fEhjOcT0y0Yeykyj6tyiO0xUpz9BbuiQTVYKVr3ykYkbvP+ElHuqS/SXWWpU7Iu2Z8g3GRR2VSXtajsx4xNdXMFU9I3WCuMjqAOvekmJ7o6/57SSRsLAPlP4PbS/MI6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=HY3500yC; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a507e88b0aso1484099f8f.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1752223868; x=1752828668; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHN7XafE/fMpmcgKsOaKWbjbKNouI94+9r5jalF8gic=;
        b=HY3500yCV2FLXS7VD/SwmTAq1FTxLYegnbtSl1xsFkePhRTCz+z1Wutqy4Y3QOngPQ
         fjQGxDDVmy7b0FikJaRNKg+mj+nZ0vVcMIQB1PC3G2m36gQ3MmgBBsOv2lTsNfxxsCqi
         r5Jv+Oh2Ve7w4cdAZxexvKOSMLxZS3+cc+Dh7z7jF5XtdBWg2zjx5hduOsmbc4IDGKrB
         U8RcIfFpE/OjejOrOhxlmODMoSI479KNLwZUvuC08OfcyXAfHuRY6i7gI/0s0EL4+/Xm
         saG6GlsX7h+lgxKtFMqawHX6z6eojrHHFbkxJIV31X3MNqFJQ10p86PMQr7jttoLwNQE
         Perw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752223868; x=1752828668;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHN7XafE/fMpmcgKsOaKWbjbKNouI94+9r5jalF8gic=;
        b=sHU+zZwXXNQioRlAB/OUp5r+vMIQuUfd+Rj/umJ6xUnfjw45vajGWpuIIa/PP+00a2
         8742b3F7oI/kkfw+zjwewpWwtSwLlkLedjE6FWQaRn8fTuP6tHIodXsMg0DxlZvtS0Wr
         yYLV9X9g4dJjiM25IkKIyzESS9P0xbzkeH5UgtuorXy24YVr5NrgMsgdedcmKniqYSo6
         9+cSSvZmwHgVHyZvOLzGFNV2MYMkjrylSCNGZvBU5b16XmPlUd0RcYuA/j2GxDEAkvuG
         pTDO+U/7XiBjBiSN/jpPhPTjbIZxY2NFhJJsnGVe/B/FSJlCSE8OsOx38Kymne79MH7+
         QUog==
X-Forwarded-Encrypted: i=1; AJvYcCVlgCNzTtO9aCpleGjbheLzKWQ0AoXUSe+8otOjDnG+WMKgUuGkSstpVqoi6a/Rzlt852c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn1NfUMWtKyR9zHHpeNrmIQktw8OKHufqciz3l1FLohh8egGXa
	4a08orXiqAhGRNjbiWitXTFBAiraS360wXpIUFePrX7AodGgf0xz/ohgEIvqkdbe+Uw=
X-Gm-Gg: ASbGncsz7DJy8l0AKSWA2bbOThm3QxLYBAQtcikBOmflcUXp0YT4jSJXhMrBfZA9GMT
	Kuf4/FiqOhy3lP4TNWLpnIWdIe0nkYkpvOSeI8Ptq4+yqB7gGmM9lG+8HHTmG2MUfbPQbg4L7Ll
	z+14AdRB43T4tDsqxiMRJa4M1XhqndvSSTnR8C/JSQBjqD485D3rardkec6E1l00nQdJkDykBKh
	OL3EL0YIchGeKOCWis/pMWBAXaqOosjT7c8UfnIXrteHZpCM0UyJ0QknJS5EHNCz1NsumADfNrY
	L/C2yAlG6zQnXanVll0VHYa4FMLG46XGIJGp+3czwgMsA4hLB1dCAt1sdLqVrMeQA/SDNU1oFO6
	u0/7hJFHM+GN01odZSCdEYzY7nOe6a1M5NMp8KdPybKTwMjAeVa086Wc73v/Kouzz0gbXjTrYBI
	JpAx84DwKZtgqG0pMIUg9GBZi0mMypKRUzfTV+Ih2wYm/runAaavv+XnU=
X-Google-Smtp-Source: AGHT+IFXJvqvX01k/W5kDJShrT6YxUQWrdXsoUCYkg+dY7uSsRQsDJkzZUdDI9BHWXS6CsQdrL3hTA==
X-Received: by 2002:adf:b601:0:b0:3a5:1240:6802 with SMTP id ffacd0b85a97d-3b5f18fbaf2mr1885034f8f.57.1752223867760;
        Fri, 11 Jul 2025 01:51:07 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e02csm3888846f8f.73.2025.07.11.01.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 01:51:07 -0700 (PDT)
Message-ID: <e5377f36-bc19-4b16-bbbe-884951fb414b@grsecurity.net>
Date: Fri, 11 Jul 2025 10:51:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 08/13] x86: cet: Validate CET states
 during VMX transitions
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>,
 kvm@vger.kernel.org
References: <20250626073459.12990-1-minipli@grsecurity.net>
 <20250626073459.12990-9-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250626073459.12990-9-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26.06.25 09:34, Mathias Krause wrote:
> [...]

> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index a2b351ff552a..d07f65b6b207 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -427,6 +427,13 @@ arch = x86_64
>  groups = vmx nested_exception
>  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
>  
> +[vmx_cet_test]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_cet_test"
> +arch = x86_64
> +groups = vmx
> +timeout = 240
> +
>  [debug]
>  file = debug.flat
>  arch = x86_64

This needs the following fixup since commit a7794f16c84a ("scripts: Add
'test_args' test definition parameter"):

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ec07d26b7016..a814bfacf052 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -455,7 +455,8 @@ check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y

 [vmx_cet_test]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "vmx_cet_test"
+test_args = "vmx_cet_test"
+qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx
 timeout = 240

I can fold it into a respin if you want me to.

Thanks,
Mathias

