Return-Path: <kvm+bounces-59471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E078BB81C4
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 22:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E262E19E0A47
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 20:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246B323AB81;
	Fri,  3 Oct 2025 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lr52Q9Np"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70216156F20
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 20:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759523832; cv=none; b=TYR9IIey56uyaztl39TQnAOY28u2cEXwc8f22PYnrCeKUbQWLNZmyfMvqwlOKAtp5eu9jHHAAi71hK1yj5bJ9TqQA9f7bg3ELKHC/zmCc0I0ibX7fYbfRZ1vB0CN0kwsuN4yBN63ABTE2MXLdm/RSki1+D3tT2DG66jr+d6t838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759523832; c=relaxed/simple;
	bh=/CES/DzmQrR5P61Zhe+S54c75VW3w6mag3CItV8d/l0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkeVIOCjkqo7L0fCAK7zmbbxk/jSPiC930nIcOANMaE4iLLBAEzuI7SDwhALmehnM2f26d0nxHBCIU33Mg75yHXqBmLWzzPMu+j0T5PXXTiGZZIW2l7ZK9K05dns+6BGg2A0e3xU/IdMsbWtZLcrCWzlDVfxpUG1gn+RwESeSng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lr52Q9Np; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso19183175e9.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 13:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759523829; x=1760128629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fNYRxXlyhDBtOijXkeyCOlrNdnjRK5t/zEM4Lt7t8/M=;
        b=lr52Q9Npvbbm3Or+n8aZdisSZ+6cBiM8FmbFJrSTg7/leScgSjBU9tF+BnILpza9fc
         +jczZYVf2NtQ/eGRtb0ZTHdSoSwdjrNh38oP5E8XKjMREn3AJkWgdNvdVGI0nnCLJIFI
         MSVfgVEVZMwfiOyWKxH53FmFUSD3VxN2RoFHPi/+s6i0BQZ6xzkCrlb5TT4nhOf9i4R2
         UzMbKM2FDfBkQKphQEv2hDWsOnKngAxG9SxxvZHT1opd8CQvTPLvKrDBzOgDgvtRjA+t
         1ll4o1pwJ88KQeUI/bmsFUjjEsb6zjs/GKShtT0vNlcMinQ9fHRQE/2tlQMTfaol82QG
         gLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759523829; x=1760128629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fNYRxXlyhDBtOijXkeyCOlrNdnjRK5t/zEM4Lt7t8/M=;
        b=LR78jX+zQ27hTzxd5lza4fH/3P4EX9kW7LliHKoglfjonqylEZW9an2BSQwrihWdaH
         iRlSNeGzRrZAlR7sjdE8mDeVNoLt4opf/cBVtlzFTpl7H3yGw510OlqYS7iu5S2V4m9U
         bfRrBZWH66rtpePOXk0UYuLVo0gCR11nlWSqdXZqmIu/tc7EbSXKjhI+cfayo2vcSkFt
         1MtdgM01xv9kDK/ycYHN01v8YuJ/H1CH+JN+wMUqlRMlrwZov4mD2ZvqJqKmYPnG/4Qt
         RE0R/ENXCHr/xkt1v4T+H+zvBzp2V7AEcpdCw1tLya1oI7vmDYBhNdL1sou/AAUbs5S8
         ATHg==
X-Forwarded-Encrypted: i=1; AJvYcCUGcm9BWnKJydOzb760LGEJ8kSnjW8JgrNS3dPr1a8Qd6bCi9uxSC8xPEqRnoNxPb8Q9/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpjNWWwNVSgAMkSfPx1vlk2P0ZvvVYaartA5Eb0EogD4uSwkp6
	zSRHTPfbdtfW6LOy8lWq8uN7Fr7FQgPZvMe9yu0n1vsshvE6z68g7F7M69lNRg7Y2zo=
X-Gm-Gg: ASbGncv+j2gnrU7mYLvbri67eb6HPnWW9ksPHUObZH0cVEy2d7k3LNDwPhhNM56/CUC
	D+xyVExgGD5+fzIVabXaFBpikJAzN8Q1POYEsF6oytDIWyT21EOax33txMvfd+HOV1GFs7lN+VE
	QbFJOGz8Q+d8g/e1qpO2Gf33OfRf6Kts3bAN64qgvExSH/ZBXw0ULOR5qnDt2obYtYgutrL/NkC
	Y6yd2MwyouRK5NCTKcfORzemDXSIRsJ06tnAnc4nKjhHquyVkyrlq2q6cN4/iAGJ7x5HpbzR5uC
	zCjKGkOpm1BqHehtv6hp1Ks0UmnlWlk9bd1RwC+f9yJgsELWDIa1exprqk25eP/JoOzl60p5V52
	6f8xibicRNK/dldlsHBMpuKpKbIlh0n/Ac0CGGWUKdTz1qE0g7jbeYXDZ0341hlInODQGZvslgy
	ibgefg8oh2I5APeScHXgPgDQirqsaO
X-Google-Smtp-Source: AGHT+IG728UvT68+4D+Tv3E6B6l6ElYPmXFRwaFbjT5iITREk+m8+c5T/kcQnUQ9F5T7TnYpk/RKMA==
X-Received: by 2002:a05:600c:4f08:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46e7608b683mr16676265e9.4.1759523828719;
        Fri, 03 Oct 2025 13:37:08 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b7e37sm140583845e9.1.2025.10.03.13.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 13:37:08 -0700 (PDT)
Message-ID: <9225c889-6f87-4571-b886-ddae24552dc5@linaro.org>
Date: Fri, 3 Oct 2025 22:37:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] system/ramblock: Sanitize header
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>
References: <20251002032812.26069-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/10/25 05:28, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (5):
>    system/ramblock: Remove obsolete comment
>    system/ramblock: Move ram_block_is_pmem() declaration
>    system/ramblock: Move ram_block_discard_*_range() declarations
>    system/ramblock: Rename @start -> @offset in ram_block_discard_range()
>    system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"

Series queued, thanks.

