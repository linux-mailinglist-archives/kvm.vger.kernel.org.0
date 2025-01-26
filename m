Return-Path: <kvm+bounces-36633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B73C4A1CEC1
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBF1D1883AE7
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB38617C20F;
	Sun, 26 Jan 2025 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yIrZwl87"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9A6A33B
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926221; cv=none; b=l4/U/P2TVdm7JwIpHtwCDdTrB8W8ScxAusDxHgc210hjtYjTWgiYa9G9bkwrvRPeAsuWThiP88n+NlX6zy9HnaoZM396OqGRVnfFkDedwZSpe7n9OvyXhZ1VpOxkefcdyyb/zShUKbil6eENjJW5rYraUAbXBHQDNMribME/U48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926221; c=relaxed/simple;
	bh=S6rPE1WS+w3/fig+GQczMdHML8VIFJ87nY9qu+RsQJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ywl9mMj0CLWzaDsHTDbtWJ52gmyPkc7EDXxyZuJyW25AJMKm2yzhN7jyc3NcP6TR2G/iK5peKnJuloced2FD6UWEVoyISoo7qnRz01Jbq5E51vFb1A7gV4ncQChM3y/oF3Md1m6JIa7lQLwfS+9zAJGT1dliBWIgY8TUo1hXFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yIrZwl87; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2efded08c79so5226432a91.0
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737926219; x=1738531019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMRLOGE6yrO6E+licLk956mV4oo4UqHJMRzU5NR3n4c=;
        b=yIrZwl87t7+CUvV2zMaan+a3qqayl5PDBbFR90oTEIYL/PFGSVUBdcsWZXcjmqsTeO
         SIEZttxIe4gR+o1pwCABdr4brR94mYa7GilmTS2+m5eejtks6Y7Uz61bMR2W1IsaMQEg
         hWJ8fYjuRWco6z0NPTPK34J4Ws6qo/tto/FO5DBFOlNRrmtptdK1ua0VYtCmWaw2ifqe
         w4c9vyOGinUZri9kvPzRLDZ6JEJ5MAONB36BRhnQFdLn/mo+I/YpU4H4zoiDKaxSC80f
         PPDQqfYtUveLJgwg/wPLZZnSjP1zfLjVVPEeqJwlhNrfG1qML5wASEFF9MQKmDmWiJwT
         dpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737926219; x=1738531019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMRLOGE6yrO6E+licLk956mV4oo4UqHJMRzU5NR3n4c=;
        b=dyxKVcigTRBNf0UVy9VeQitgxAOTxh1thGH0d3pAgZMCC4+uZBb8h7gLhP/csg12Gd
         KM5KCko/v9y5e/U00/HVRdLVuRXkZLK1VeXlTDz2KBX4kcmw5Q2fny6c6RWsYE4nccVo
         H5+ny1o3Hl/yjKyB87oN+S1nEEylMi8Ip3JLWVSZPb6sOIyU8z8+fZGxPLPgfsKyL++W
         iauvYGdXBazFwYjIM7GvYjiqO/sArKBEwr+Nw9Uzn1y6mZ0U+6NrK2xXl+qnFU/MPe3r
         RAJpficQzQWZwti52bCkQR62fr8Bd1ffPd2Z2Rud9+KRPG/W3FTgBC4Awpfx4B3kFjyX
         2y1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRXngVgTWvmLocq+76DrEDOHgkRNFaYbPz7ohx6JL0i3bZFzpCt/telWqpm/smEse5ehg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEyR/V/wjPdIlQrJICQX7n8iXpUwX7z6qIzbrCS2OvaLgiNMTU
	G7OwC5iU7LB3lFvVixwOR7rs+RskdnrsTFxj7FhVtT7XsGAfnu5l9LfMCm9jMQI=
X-Gm-Gg: ASbGncts6R0L4FXr7qVNm8AUCAsI8y5P5fSoV1HQ37eiNJRMrkDPF5o7zzUalSfswZn
	8JBYIj3yuJgHM4s1yMcB4VmNy6A4LaRJna2VVecHiq+27hdEhR3R3NrS8Isvi0/UjBvLN+Ap1my
	TX0cvRBN0RzMsDkFnNLjtRJ3rdWWpsjetndwtA/9lvOTa8pNqtIben9+L3mddnMIOK7HsrWq1q9
	nEx7OCUD/xQPlmTrPzFSrA/qWpLmneHdtkBHbUu0vW5JBZEjIcdOY0cZd3M5B6vzNh+FqO42NCr
	gsy72c3fJpgI3RIRCe7/3BOpxJ9mHioCXj4cUwxWKDZo9Zc=
X-Google-Smtp-Source: AGHT+IFBHji7Q02DuNHRJzVlNXhJjAx8HDsMis8mrPSUngwfhLK6I5AlZnoO5BvEYdWLX8kF5J4JkA==
X-Received: by 2002:a17:90b:2243:b0:2ee:e961:303d with SMTP id 98e67ed59e1d1-2f782d9ee8emr55346160a91.35.1737926218792;
        Sun, 26 Jan 2025 13:16:58 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa75bafsm5669849a91.31.2025.01.26.13.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:16:57 -0800 (PST)
Message-ID: <e52485c5-122a-4a95-928f-08fcd17cd772@linaro.org>
Date: Sun, 26 Jan 2025 13:16:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/20] cpus: Restrict cpu_common_post_load() code to TCG
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-17-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-17-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> CPU_INTERRUPT_EXIT was removed in commit 3098dba01c7
> ("Use a dedicated function to request exit from execution
> loop"), tlb_flush() and tb_flush() are related to TCG
> accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   cpu-target.c | 33 +++++++++++++++++++--------------
>   1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/cpu-target.c b/cpu-target.c
> index a2999e7c3c0..c05ef1ff096 100644
> --- a/cpu-target.c
> +++ b/cpu-target.c
> @@ -45,22 +45,27 @@
>   #ifndef CONFIG_USER_ONLY
>   static int cpu_common_post_load(void *opaque, int version_id)
>   {
> -    CPUState *cpu = opaque;
> +#ifdef CONFIG_TCG
> +    if (tcg_enabled()) {

Why do you need both ifdef and tcg_enabled()?  I would have thought just tcg_enabled().

Are there declarations that are (unnecessarily?) protected?


r~

