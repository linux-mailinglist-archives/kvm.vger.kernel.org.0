Return-Path: <kvm+bounces-41700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67320A6C1FA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 445747A6047
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB5222E41B;
	Fri, 21 Mar 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QjqkOJzn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFA422B8BD
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580077; cv=none; b=jNy5P8TU5gQOYSaX6YxW3wqYZa89AlqEZokoLfhzpzrlg+bXovNKXkZPc+4ASNDgh1/T/TUF4B+6HXcy75eCmjxI7NS2xndrqruu1Qe99mh/vlfJguWwbIgw8Z0vA9yMjDrHVKxjtBLYDkziMTeSn+8mi7UN/eDnE1+8wD+q3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580077; c=relaxed/simple;
	bh=RI7Xelxk0GKaJWmQfxy6GnFAfAENKZ2Z/icmRFbvKG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kG/q3t8CXIdeMZA9PrsNEeeaGhor69cdRI0xr9usu5I7+s/zER9V7fP0FQD8VG1LmqophtgM+u6Q5E+aSk7RJhly+KXVccU4EvXH1xhtQtURfzDX6qren0sAxVhWwbeVPrP03APQ+WobtOrm3GeYend/nNz1qehuCGHzVTVDkz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QjqkOJzn; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22403cbb47fso46488875ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580075; x=1743184875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvO9Cxq0zExKjE4A3JJ2r35XbqlYJiJsGb+VZu5umiQ=;
        b=QjqkOJznmQxLC8LW4L6gy3WRDU/cXYcBFKfe/qAymvMGnqB0gtUV6s7jiPkzUNcc1R
         sWg9L2mN1uoFb4jqu6IHx/OW5dcC6lDA7HjH1f+PVazZ2gEW8L32nK9jHgOyqw0u593M
         pnq6I5x4zxMzWwla2EA074BLx/bCpmIPxAtve7Iosy7gxMmh6Z7cQ9Lq6agVvxa9c8TZ
         o8oX8pcahd+Ht56fKQHPJ36TouvfmFCTEeezS01wTQ2Bz8T15oen4WXyUza2qc4ndC3c
         SJjWaeWae92e7k75nHi6TQmWNcrBJCxLWEptGobs/gS3CwkjIFBA/W738/Kv7yaSBRa6
         lJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580075; x=1743184875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvO9Cxq0zExKjE4A3JJ2r35XbqlYJiJsGb+VZu5umiQ=;
        b=UttWgWIm0i6ZM0bFhpelFJECxZqmetzAN9rOF7XFGgoeKOffoDRzGF0DIXAN1qf7ar
         DaBVWdTYro+WsQdU/C42p8LJddHP+jF7lY5vLnugS38EUg8Tj+tulS5y1tdioAWZibxO
         8sj9W7cLAGU7cumBUE9uvpsKU5IJRrUdKre/9x8A8FCR1Xyn+a0tHTLUDSxbK+oScE80
         +j1K+k1ol3GoR5403NlvGTdEBTcQkiyPqoaQgH5Llrb7XR8rI/+vL5RAPkRlRF9cJjjq
         mII9iUBi6gAZugf1VpUM8N1Y7Xhr503dTURjZmJxZvVI4oePfEHKmuDgB4WLwFkT+TYn
         4jrw==
X-Gm-Message-State: AOJu0YyhOMffgjsg2BUcTZoDr7ST6tI3FI0eEiAUeMfJ53r1/ALqspgW
	Ql8bAju4+HvQWLw3MwEwr0z2pr3zqRDZ66b3TP3Cc2LSyxZcSXaEmGRhszZ0N8g=
X-Gm-Gg: ASbGnctcHtUPN1ZomOjY6lZjMO9sNTKG2BE4PezwyXoBC9XbUygYnIXEYKlOOk8hZHK
	cM74wxYoyFCWorH+vbQhF3zN7HewIgDs7pbmnoC4K5no4O2S0aWiOFN+Qx2FFi5C89rZ69qvmoA
	ZPFzu+jIqjMYxAx15Oy1hGlAK/TpvDoqu+gWj744GjuZ25o+3r6cLzHSqDLo5pqOuPqSflOQV0s
	pL6KxUdX7kaKaTa/1TfPSrxoMM8osfoqeN9XaCWxrvfU2Lo4nbd7BEEKRiQHEdeO2+bx4iFh+IW
	bfCXkQZaDifbDMDGYHA74VEv7WwcK5GZuy6KrfiJfdHCL88z7SFNL90XXSpifnZrOgHO1L6uE1S
	AXhzRh/tV
X-Google-Smtp-Source: AGHT+IEVQBUewn2vltOJjnD3ER07wbBMzpAhk+4Mm4mpvnSWKKtf7uMQAJ10PBB7+PuIE2/DxZNccA==
X-Received: by 2002:a17:903:188:b0:220:e338:8d2 with SMTP id d9443c01a7336-22780d83b25mr69121915ad.21.1742580075407;
        Fri, 21 Mar 2025 11:01:15 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811bd143sm20164975ad.150.2025.03.21.11.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:01:14 -0700 (PDT)
Message-ID: <0c0197de-ac97-4acb-ac67-ae6011e6f9ad@linaro.org>
Date: Fri, 21 Mar 2025 11:01:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/30] accel/tcg: fix missing includes for
 TCG_GUEST_DEFAULT_MO
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-13-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> We prepare to remove cpu.h from cpu-all.h, which will transitively
> remove it from accel/tcg/tb-internal.h, and thus from most of tcg
> compilation units.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   accel/tcg/internal-target.h | 1 +
>   include/exec/poison.h       | 1 +
>   accel/tcg/translate-all.c   | 1 +
>   3 files changed, 3 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

