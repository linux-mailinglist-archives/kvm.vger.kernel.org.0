Return-Path: <kvm+bounces-41240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B948EA65700
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791DE882CEF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948B8189912;
	Mon, 17 Mar 2025 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9T9QisA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0107C17A314
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742226739; cv=none; b=g5+LGfICOMsN8ojVba7Rh6AbwABgIxjmRRzLfrhYWNikxdVxiDLTuEizzHEWKiB1qNYMMucjrfcKARe+jif+t6rZT/YH25CX/lMGF9wpx1zxc0ut7fkLrWBfTw0tw3yZHiF/pzXAuCFcAq3F1/SU03C5D6DBwBayKbUzRtSSErc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742226739; c=relaxed/simple;
	bh=BDkGF3gdekFUEYPruR/JnPdpUyizDM1XRBVdBW1Gy5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBRmvdwW1GiPAV2DrfrBTX/kEA9N2OMKPkpDvAEce+LV6VFzneQEeuJobQ8rbf1KIISEILpBjy3eBetVLjAU2csLZz+BSAxrxu30cYYqv+WliV5QehE/PzuDxiuxmcyCkB1xBdqvLvzULaBHjMnZj3ogJtM4TWabCNEWiVrLNWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9T9QisA; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43d07ca6a80so11020125e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742226736; x=1742831536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xiXPoAKkwFpGzY8cUM/UBfoM1Sb/wB5ZKQOj7uhRCw=;
        b=Z9T9QisA0Vsn/Bl1V20xWkJheOgjM334XnGiiTOP5XP8B8rYvbVBjFqlwnRcQBRN2m
         C7xeYPyTpRm2Ld1CfSLkyv2GdrKqP70ZOwnatkVKVG/Go8AbOM7LtWZht9j3UWV6PZwL
         H40jkS23322/09DmoOLMhWnhRnI1jsy+UVp1l8dGMOFMkmkeSrbATE41Zf6Bql9oaXbF
         FWK9Cs1fNPZqWfIZmXcs2dohT+dj0o6QigS6rh2qbOkC6x0m1YbmEcqf7N5QAEC0mGaL
         WJLqQr7ItGcpItVRJv6DmlmGJV31aDgi0clZkebSIWhn0QBQeFkU4l1k5Dl30S+eeMLX
         E2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742226736; x=1742831536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7xiXPoAKkwFpGzY8cUM/UBfoM1Sb/wB5ZKQOj7uhRCw=;
        b=ROIeH84KpIDF5dWsL72VDlzEzuwc4DET8V9TgsIFs5c1KGBWrTtXljPO2vTP0kFuTH
         GlPVZH2IrHMYU54V1eZCgVR2gqWigXgq6sQc1x3mThIf203tAzYSR20jKIVfco1j/UIC
         GTL9oAYCfpmJg8U6yYTH9Bdw9KqN/17Y938X8hdyq1cA23fHWa3ctEyL7yQ1V0HQBbJJ
         jT2Wabo+hFDW6yBVNPTSz+U1Pm3S1v1wdqSJijkUakVhj+B4x5/5xswju4/36ozguSKI
         PJRfrQf2Fetri7jQwzo/Bx85Ois0WXX2ocBchDkJkRnbv+xpzVDYiC3FNBG01eYl4+0f
         +ciQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8a8/tfTNbWd6y66iFsRTuTrFp6Ewt1uWCNK1tPaKOoSZjoSbFqR4QPlZeDlkeNuh3Uqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB0xmHLXSJdO7vzDcg/2/15aY3x25fSzFU+/+7G3E2XAFOXBT/
	4Ac4R1Stbu0EvAgaiqgLpF+Z0D/LwVguoaNWyJ+YUCo1zdVC8FcWN7A3doWDZbY=
X-Gm-Gg: ASbGncvOTl784sBwE3pmLDA0M4+hWvXppVYDPlFUC3fbzi3rqd5zQCcfyz6HEWnLGlE
	2+jLF3ah0bpuB0d8CWWMxl9CS4vcJxkGJ5bKc6XnBodkjLrhubr7ulZNVpWry7+OfrVVw0Bi/Dl
	lG6LVWnl9fG/YwAC8as+mEIKhRwrfTGsyeRYmOxerThYtjnwDcTcMim1ifGxfdFkUIsGj6/YJqq
	E/33OCjDo0HiLLFD12OjMEMeYnCe1vI5RSi0wK9I9G+c6x4Xs1KnFNuv9V1nyLELQ6Cfp7SaVxj
	Dd/YEN+bpU/VDr4FYOnGUIKdSCfIdjRrHK5Toqugj5tlh/XoCCiprhjX+u5W5xduyuamkQHQFtk
	f1JLRPMv4HYq3njl3LAyl
X-Google-Smtp-Source: AGHT+IFpt8KideQTGA4uKhjvZxuTIzGsP3DM5t9jXqk82vnIbb3xkl9IyoVgYgeOQux+EakZvkLZoQ==
X-Received: by 2002:a05:600c:4ed2:b0:43d:cc9:b0a3 with SMTP id 5b1f17b1804b1-43d1ed000fdmr111360435e9.22.1742226736253;
        Mon, 17 Mar 2025 08:52:16 -0700 (PDT)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fdbc4cesm81462315e9.0.2025.03.17.08.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 08:52:15 -0700 (PDT)
Message-ID: <0f6a945b-b3f7-4602-8c17-db07123026a9@linaro.org>
Date: Mon, 17 Mar 2025 16:52:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/17] include/exec/memory: move devend functions to
 memory-internal.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-16-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250314173139.2122904-16-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/3/25 18:31, Pierrick Bouvier wrote:
> Only system/physmem.c and system/memory.c use those functions, so we can
> move then to internal header.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/memory-internal.h | 19 +++++++++++++++++++
>   include/exec/memory.h          | 18 ------------------
>   2 files changed, 19 insertions(+), 18 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


