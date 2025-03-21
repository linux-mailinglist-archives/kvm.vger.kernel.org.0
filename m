Return-Path: <kvm+bounces-41684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1214FA6C01C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D56B17A2F24
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684BF22CBF6;
	Fri, 21 Mar 2025 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z4UlL0mV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BD522CBE5
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575027; cv=none; b=EtIwcVdUhXOcaFjrYSBBGsqap4gdkhiuxAwd0SuiIUR4AYovTF1HTshUCFmNNAiVfLX61bEtFZqydz+2zjsiahP7rlwCNaD2qPKHGnmRXo7UMRv5RN2D77N5BoW+ZcSYiT/9Gd0aLeJl6GTAfhNnr1os4Q65wsMC4Ph/9c6KZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575027; c=relaxed/simple;
	bh=IwQKcMjy3UdwuxcXRkXyQuU4INC2QTPj2Eh2ITCDM4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB2W14LhQKhYYKPaPuuROn16vTXzV7DAlQQWbSsYudZLpU0jsupPEkqOXp/k3k+m4F3+jfIQIgJ0r2hpRRATvAWf7KQdxSuuZsCcQRVIsKORwEmA5WXgHQOs4q7kx+geebLJ8T2zOgyBGmQvc+Gy313n9zTl29Oe+AHWCHMvUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z4UlL0mV; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223a7065ff8so13618265ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 09:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742575025; x=1743179825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wd8JQPF6330iFbrfqEOHPqzvf3WyiSqrdPORWZKD/hg=;
        b=z4UlL0mVBEmDb9dQ2eCVCFx1c7hmcKjPskEjLo3hOPB6DymAYxDHraokfWhhBjE7Fo
         Au1r2OQJGy4uEFEFrjqumxA3dq/IBcypbUPaO+NbX9x+xCrRJbMpJhP69H/lyqibwHHY
         yC6QNbPB+thAj7H1d1rhZXwCzOK/HYQfOs5WaVBXaOQjqhXjkD34R6lxmInwyPX2RqhM
         xnCzt0cNW7DEDpXGbGSJnz9c3sRUfU6aBSgXLc9ZuX0NVdbqSHB3sByH37JJrUDYJeDd
         RvzAQPsHcRz54JQeTeviAxdgXc6YH1+Ik3BBqkuoQE6oBSFfnvSXFGH9pXAScMpTo/VK
         gbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575025; x=1743179825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wd8JQPF6330iFbrfqEOHPqzvf3WyiSqrdPORWZKD/hg=;
        b=eStCtNrgltR4byaacW8Szpw+YVUFxwFtBEF4gU80Elwbig5qeNpi0gq7Zt68bxOa60
         Z3ApzdAEbbeyAeIcPQdCyypskGB5Hje4dHtJ7MU78gEYgGWVj/sh9HFD7YOZu1Y7lkyt
         +nU6W+nk+mMsFe9zUNhWiKfkwkwz470xhiu8/7LuoRtDW0hCiCVG6Es0itjwrCGlmjwl
         HmsnMPfO9hfAUSMbqDE6oM0M7SSfcexoIqz5RRauV4uEvyZLJcBxZ8EPgcyO9monDp0N
         Yt1QY1x3Zw1dGxVJD8wXZCL9ifkWOEnRztw9tuQd/1PnKuxfZb0xbEG0OigZhWdRbBLH
         3N0g==
X-Gm-Message-State: AOJu0Yw1Wesg8uo3VX6jxWxPhYP2jrHmAySTTWt3wWE1j3E3xT2t0j7g
	WwdehoNlZvAJBLV/5G+eFXi4c9ftTrd1rMx5i9oRcnqvxgyCKyAJo5g0RedvONg=
X-Gm-Gg: ASbGnct0Mk1OD+uGGhpvHKD5NiubfOEOqZS+rYcGKjSJogKU3J8ugfEwsj5YUukcWMV
	dkrEIu3kgtTP4rBNP6mC7ZTXoFfMs9X6/ooAd1+FAudM/n53HQSTPYGT4afzfc9m9qFXX3CMKnB
	GiegfrrAce9X19KySZ1UWLvUlDkDklloTYiwmCj7c1amB0mXcr1rXFarE7+RELb6Y193NmHHufp
	dKNK00W2ktK4do98iggd3ZirFQzrtAM7SzG6OsD4mijnleXwzivxHTM5fDtPDuiLUjs3HqJxTyZ
	8h7X+HNCJWagHT6N0jDO0eJMZcxRxwMzl7hIS8+9n+VWBjB5SDgXSxyPVzOo50X6Uf0Im3UkO/n
	uvYAiWb+I
X-Google-Smtp-Source: AGHT+IH312/S8AbQMYSlnowN41JPgfjb2YW1tfawXIKSwpgCXNTMnxdSiRZRFkLJzTfeH40cXjqH8Q==
X-Received: by 2002:a05:6a00:22cf:b0:736:a638:7f9e with SMTP id d2e1a72fcca58-739059667f0mr7619951b3a.8.1742575025097;
        Fri, 21 Mar 2025 09:37:05 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73906158066sm2143401b3a.150.2025.03.21.09.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 09:37:04 -0700 (PDT)
Message-ID: <ebeaab45-ea1b-479e-8250-b263acb05cf2@linaro.org>
Date: Fri, 21 Mar 2025 09:37:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/30] exec/cpu-all: remove exec/page-protection
 include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-7-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-7-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

