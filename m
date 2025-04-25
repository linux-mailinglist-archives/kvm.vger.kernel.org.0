Return-Path: <kvm+bounces-44296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A03CA9C6BB
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 13:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDF6E3A3EE3
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90AC23FC49;
	Fri, 25 Apr 2025 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9spxGOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141B3183CC3
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745579450; cv=none; b=iabsKN4/GT39f3Yq8d7Huccp09UgWpTMA4eGaGZRNSLaQXGIhMvAHiaGXwyIqioaGdhmJ5/gy25jFe/lv1W4pb/Jn9Xv3HD8i9QB0SOG+lIdL8KwIHC33K8UQAdq0ekfwDoe+lBVwZvy/fOywugUVONJNe5ZD+Rpa711g2nSet4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745579450; c=relaxed/simple;
	bh=uc0xDVLSlTrQ/SKqn0RlNyVHTNqkF1kFdiYvrcfnSig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtpiHL1Xgy4kPofQRivF3poSb0aP3lwyC94au35Pt974V5P5htqdV8cKxJb7JYVp4BWT2LJ2z32vLsIsP/fgip/21VCs8zW/8E131hJm3VfRCROPBFmQYJHSBgg+bwgEpUrmJatCVBHtj9P8XIWkWgkgRuQkySTLg+gLE3oqiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9spxGOv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so15384495e9.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 04:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745579447; x=1746184247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Czb1fB+t7BDXhuauxEc7uGKN7eHSq5cxbtZ3MG9H3uI=;
        b=Z9spxGOv1OepwgBZfQ6PC8JNFiXRN+dCuvLNJaFEuHavzBPpMvO2r3C1axg7zeHbUf
         CALrNZtepVkzwtbMi3E7FjB6ltNHydgabglCa1q2DGSNxi9u9gKQ0ZqJjBjfw7aP8oGn
         cc5kBhddwx8mQfeFTtkif5eNjBSuNZWcBpFNvqY3SWQ6BcMftMgYVvWAYo/85oEZ8HqL
         UssCGVTmiCoxE57WO7teF4w5f/8LDslk3djM1LqCPIV5lYp5PJQxPSTuVbA0ywwPuqYZ
         4hQiI2n4J1L1nmBcvrBzQakE7OnTM7zS2UGd4kVWg/EDJDQ3tfsngLHZGlNf5qInLpTB
         bibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745579447; x=1746184247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Czb1fB+t7BDXhuauxEc7uGKN7eHSq5cxbtZ3MG9H3uI=;
        b=sopo0t/Lds82VSvI9W7Z9LBFZ0+DKCxYVHySLhCItMJaQvCg+BhPy90feQFvVzwwEx
         am/yaNgFj7mlyZjOuQBxsXK3kpJHqkfY9y9jlTSEZHEZPCXWe/mWjwAX8wJEIEy03OKQ
         RBgHqWPhBwosToo7JT/DANfDW4vqKiKAf654RN+5vH3hZaVFTRVSr9zcp/E5dvl57PxD
         fZ8qD1XtQ6xfxanUj35Pr0j5XqxOH9NzfV12M7DpUqBXifW3GVWm4vAcSoAsHgYkZvkx
         Nu22OsX9iDRHyoBbMaItYUk6Sa5yNck7sheWI9qKro6JKWoWuCMt+vjMPJ/KaDP0dvfx
         2D1A==
X-Forwarded-Encrypted: i=1; AJvYcCVbJWFW9DeOfWSLxQJ81PGiuvXNnA88iVCassVcCBbNXOrNLPHvJEhhVj3CLa5vX875HnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+VVkrIVz3nBs4YDZS/GfgPCzosS365goj/LL5ka+3fhpmeYvq
	2y96hnpvZLJnMsi8zcUy+mK8F0Uwe0wxFjQy7c1T45G5Now5KqIehu7Pttr3j30=
X-Gm-Gg: ASbGncu1yORQqM3sDBm+EFM932d0vS5TVLBuLDY0+w/9DoWPn3SDT2aYm1BSMZtqwb1
	2Nf0zdhQpt/0XSAQq3oKrvT63bKiSkRDZWlaZcO/OPO+aTZ8ZJXzwEYzYtRn0m0Fccc9c9vlzST
	WXD2HA3VS0lzTcpiCU7Pi/GoHeMhMrZcaZ/KKJTa95JUGyTxgrxxTJr7X/eVgBrZQfTbRf+XM+n
	L68uESisQ/ejtsxPsGBjTHT99HgXPAqkCmmfMXNoxYgMDeKziimCiSdG3yInM2e4m1DAEQrF8oq
	fChDxqGJciOCl2wcTPbF93wL40QGa2mCoslJtXlQwCzIQOaEdrge7RcYJUTEECGKVj3asIUK7AI
	9NrllWE+rzoOF9+jz56Y=
X-Google-Smtp-Source: AGHT+IGPLCdantGvN2kLmQ4oiLR7ub0/ZDCsIBZwSSx18FUmBnRE+wzPAUpKZNnWVG4NUAZut3f1ZA==
X-Received: by 2002:a05:600c:5252:b0:43d:abd:ad1c with SMTP id 5b1f17b1804b1-440a65b6f77mr13819495e9.6.1745579447214;
        Fri, 25 Apr 2025 04:10:47 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5c68esm1990779f8f.82.2025.04.25.04.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 04:10:46 -0700 (PDT)
Message-ID: <876e517f-acea-4fca-8735-ba8c732bab98@linaro.org>
Date: Fri, 25 Apr 2025 13:10:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] include/system: make functions accessible from
 common code
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org,
 kvm@vger.kernel.org, manos.pitsidianakis@linaro.org,
 richard.henderson@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
 <20250424232829.141163-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250424232829.141163-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/4/25 01:28, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/system/kvm.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


