Return-Path: <kvm+bounces-16800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 085BC8BDC7F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3998A1C2210D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 07:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7CB13BC30;
	Tue,  7 May 2024 07:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="okYY+CPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA44A07
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 07:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715067188; cv=none; b=CMRTb4VMXPgPGgMH8ficd5uN6ITshtAgv8JwW3oWXts+xqEwnrWflNOW3FI2o1G6YGelM7X1MBCpdr4iS+XcknHPBeCQyEvG1BhWg0HFQJK3ImPEXKSzDvnvmQDs9ID6zZqg9ABFL+g7MVkpgsx0Vees/HB15ZuA4RH/SK0ulS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715067188; c=relaxed/simple;
	bh=W0bnsSy2aRSrOOMhj8dy6YV24J2sygiFy3abzP8tcZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFLJepzqtzwoZZYLt/XgTw+Fb+BT89OfvvEwkF8u4CPyBW1xmXcDi7wRAmDx+CUBxtVY0vtIAdVOC5Dh1qYulhWnEEvJUEgkqCl979siZsJkz4hWWGbu5C8bNIYopGUIpEHGu7Qz1tWIwawiR72rTrJ5UYVGMJcpylkA7Jc/oVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=okYY+CPN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41b21ed19f5so19408045e9.2
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 00:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715067185; x=1715671985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzGnp97rSg7gvT8i0eSN9694T1KbqRaIo97BDou6Y0E=;
        b=okYY+CPNgEHlVCB93qVstPmZiaUUPjXZlYMcaH4GuvFOACv0kRj3ezBfj9cxQyt26D
         gP3Zh2co2XWqj2CEampqvJrQUxv6+PJGfMVsSMXGs3Fa3+EUgaPXDppkrj1pt2CFVUQt
         mZRmwquyiTJMVtLPcpvifdzeYFXPt28lIkCFLY5aPjg4xdF6NoqwsWbTW7JSRImMmofx
         Uoq+L3qgDbvRYH8gRQO2pnDjCtTbLcL1iD8F7TewZ10gZwxotS14PVsmRtl+w3SXsAwp
         eEJBn85pK/wXrJC2pATkHzeNIT3fd/5UTnjSIxpq9ZtpGlOIm7Rg/kVcZkQTMVctsh0O
         Ij7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715067185; x=1715671985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzGnp97rSg7gvT8i0eSN9694T1KbqRaIo97BDou6Y0E=;
        b=PMO68bdoSWXXHpLFX8HDBhy8T+MixyF3SZOsis1D7Y7A3pQn3Rvs1rwtQNWRng0AIn
         1gNmouSjGPkGdoDf8SIPI5GU4My4MUYBb4aEnfUvFrGXxJ2tBYhjDxMSEBxOdYkHS6hM
         yTt/u0EU2+M8eN4YLKfZwYABkiDvjJ53KR/XwiveNquVrqpmksEZHLRJ7JaZ+l6b4fOy
         nOXTNjMCP/YMniUabiQniO3DG2DxLZQ2/W8rLuJtnm0DC2PJH5zU/Cg49J7tCc2fbEos
         mczo+cJV9n3JzLeYPpk3rnqslEQliFfbd8+aLydCg/jlNj7pkku1UEQDmswfYY0Hihg0
         ER9A==
X-Forwarded-Encrypted: i=1; AJvYcCUl78S60CrinRTMTyvIm93l7JKU8hNqj+TzHKiHYEAzqoDMDPI4k8k1Uh6HEsthf5ufl/R2QTBshvpQ76Zs3gSJb0nI
X-Gm-Message-State: AOJu0YzbZbDZki/xxNlil3yQKFl2oel39+S68F8oXHaKl7w3bg3zRSHH
	1ELWmI/w93UVgfDqMym/V5MfWu3jdsEl/YYeuTmTWyHjASRh5BdFmn/bpG0LXc0=
X-Google-Smtp-Source: AGHT+IGn0qF4uRtQiRnhtEPfMf4s6NVaFQdttfYrdycNvc8M66l8tTiN5yfnXzbpSL3Bwnmz4sQOEg==
X-Received: by 2002:a05:600c:45cd:b0:419:d841:d318 with SMTP id s13-20020a05600c45cd00b00419d841d318mr9377437wmo.29.1715067185193;
        Tue, 07 May 2024 00:33:05 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.243])
        by smtp.gmail.com with ESMTPSA id t12-20020a05600c198c00b0041becb7ff05sm18310233wmq.26.2024.05.07.00.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 00:33:04 -0700 (PDT)
Message-ID: <ef6df20a-04c9-46bd-95b4-b5bc553364ab@linaro.org>
Date: Tue, 7 May 2024 09:33:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] accel/kvm: Fix segmentation fault
To: Masato Imai <mii@sfc.wide.ad.jp>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20240507025010.1968881-1-mii@sfc.wide.ad.jp>
 <20240507025010.1968881-2-mii@sfc.wide.ad.jp>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240507025010.1968881-2-mii@sfc.wide.ad.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Masato,

On 7/5/24 04:50, Masato Imai wrote:
> When the KVM acceleration parameter is not set, executing calc_dirty_rate
> with the -r or -b option results in a segmentation fault due to accessing
> a null kvm_state pointer in the kvm_dirty_ring_enabled function. This
> commit adds a null check for kvm_status to prevent segmentation faults.
> 
> Signed-off-by: Masato Imai <mii@sfc.wide.ad.jp>
> ---
>   accel/kvm/kvm-all.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c0be9f5eed..544293be8a 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2329,7 +2329,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
>   
>   bool kvm_dirty_ring_enabled(void)
>   {
> -    return kvm_state->kvm_dirty_ring_size ? true : false;
> +    return kvm_state && kvm_state->kvm_dirty_ring_size;

I missed the previous iterations of this patch. I disagree
with this approach, we shouldn't call kvm_dirty_ring_enabled()
if kvm_state is NULL, this is a bad API usage. So I'd rather
assert(kvm_state) here and force the callers to check for
kvm_enabled() before calling.

>   }
>   
>   static void query_stats_cb(StatsResultList **result, StatsTarget target,


