Return-Path: <kvm+bounces-59323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6708CBB1325
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 258E84C05C3
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8A8281532;
	Wed,  1 Oct 2025 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YC5YwdbA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AFA27F010
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334384; cv=none; b=FG8NBPN2sNkB5c/FUUczKhhLLh1GmlqvR0UhCeTaDldPjY9pXA6jFkgShqVKJ8E6G042Li6YzBQGCjpX0MrOkojEES8YJ0eWPJctFV+RqzK34Y/6Xwd0kM8xzpW0jB8T+pohNF3R8c74+/QQ8DKA7UVMvFdW7T3xSrQ2JzaprXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334384; c=relaxed/simple;
	bh=VecOrU0NTFg+HCm1x4gaVLvSgltYruizuOTodUhwXgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJ+N8s8RhLcHsiF8dC3aiVI/ZN8prjua2Uz1Ky8KB9f58AzY9Fdu9vl/j4YBkw/NUgRM7mGt2l61+VO5RUZs/P660A3Zg1elTjoSejMgwe9P73tPV9TXsXplaQcB7PIOVKmb+DQBPAwQV+6iGfAwuyhSJBKoEFg0jcXOJ8xbxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YC5YwdbA; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-79390b83c7dso632376d6.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 08:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759334381; x=1759939181; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3H7aos6A708jGSZuLPLSE070Fktbew8/eoA80ARhIUI=;
        b=YC5YwdbAObZp4mth0qvGLE3Y3c3d/in/iVP0g1bA/zmJDHQCI/s4jfvWUQ5aTDw7T8
         FJ3znz028sO9p8L+xceKwBMVUsou0xIn4bRsPVwZ7U3ZogNt3jdE3DHBqB6ONWDXnfes
         IVjUzvgTDpPIAUbG1Gaqm34AXsdex1mk1zUivCiZhzP22ApqbaxJdmnaTqL7eApCPICE
         d3sffPgaUB8vx6Qau5VPzPptp/yVwSXSzkvg+P774bDXCb7nAmu31p0rFY7o/PraQDHK
         je8/LBJ1GZipZdRdMkuY2ZxLlx7hDcZYmnrjDySmoNh/D2ARMwLFtRfx9DC1KZGrUedt
         UXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334381; x=1759939181;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3H7aos6A708jGSZuLPLSE070Fktbew8/eoA80ARhIUI=;
        b=IGVEzJ3oqtFqW+g7KursKVJ380Ce5GJtRmtrZHeHSenfXUAsxh0jiNLlywFtSQK54R
         RS7XCNEfEJZT6/fO5+ZSaOtTqVYKiDn0B60xtoo/8bY34NXDmgWSnd/ZkMEmKDtdiHWv
         DLOqQzFO9Hj5AtL1SQ6FUm3Txk53azVPNX1sNRFXPTSLu68ba2MwnFVLm5U/NAQ4sP3x
         bg3aLZWMXMOX5WEbUot0y+5ip3qYa+Ce90sEXQRxJL7dWdLS65sTrIy0z+WbszhioRNV
         G5Syr7c6PwdwIJjK0iNr7HI98U8cp0R+vVIWK+dscPXLxgMvR81vgIgchzqsUfVe4raR
         W1QA==
X-Forwarded-Encrypted: i=1; AJvYcCX2/WiMcLiKIycM7yye9+X2NXmJJrVaqW8ue5a5xdDI1+kToTUHJwx6YLY7NdHydll6EJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwuQdkBWx9L/zf1UPTaAM8Wlddr4Tb5ker571vK+zNJJaH4umu
	iTpvmfNbRpRYIP5st2ujrzFltr3H8xTeBqQL69XTmx2T5Dg/cenjfWX/a3grLY1965k=
X-Gm-Gg: ASbGncv0u273sHzjEnBXo2GelrQtiU6M1XffXWyD+G8Hl9mQHmxqvKzO/8uWEaROSts
	0XTBB9WRMhxpQEZWl3NNAx/+nVmgjBpvZjkm7NEdxzxJWULbbkXphTLMuoCL6oCSGbNi7FgnJqu
	G90kcV+xadIqIjMkl6FyuXJ/dMLoUqA6gjGANpDMF9eP70MMNDOEK/BkTfdmQ5MUtojMo3lcSPx
	lO/ttiGEJnJqVb0/EEEya9LtZBtFa/bj3HhtK47VIccvlD5lRS1pohUOaIAXrSuIrmhBlA04Tak
	PYJ9oLFPGM5bsR9HW5PfANBICog1iPxn+E6eCbqy7t14LAn1G6XFo+fLFxkzGYoW65G8fgSGWwx
	8fJRnUMoM/GcFSW8XoTm53n4GR1K2YBYN0u+wfjn4doT6w5Dt3zIkaeqagOm4O8Q0Js0AfU1wgl
	ZvqKfsujEJReqzEYPUXoskYrEVrIMuJkc=
X-Google-Smtp-Source: AGHT+IGVdskAfeNNXFR4PU+7tslHlDwSJrWZk61Zlg8p6+z91XBdxRpfUC8DJn1TrfJqCud5iIEExA==
X-Received: by 2002:ad4:5baf:0:b0:787:982:2953 with SMTP id 6a1803df08f44-8739f3c7da3mr58386356d6.29.1759334381302;
        Wed, 01 Oct 2025 08:59:41 -0700 (PDT)
Received: from ?IPV6:2607:fb91:1ec5:27b9:1bec:2e21:cc45:2345? ([2607:fb91:1ec5:27b9:1bec:2e21:cc45:2345])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bb4465cesm424136d6.17.2025.10.01.08.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 08:59:40 -0700 (PDT)
Message-ID: <2184ba65-b67f-47fd-8234-883f5d8b57fd@linaro.org>
Date: Wed, 1 Oct 2025 08:59:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] system/ramblock: Use ram_addr_t in
 ram_block_discard_guest_memfd_range
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>
References: <20250929154529.72504-1-philmd@linaro.org>
 <20250929154529.72504-5-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20250929154529.72504-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/29/25 08:45, Philippe Mathieu-Daudé wrote:
> Rename @start as @offset. Since it express an offset within a
> RAMBlock, use the ram_addr_t type to make emphasis on the QEMU
> intermediate address space represented.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/ramblock.h |  3 ++-
>   system/physmem.c          | 12 ++++++------
>   2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index e69af20b810..897c5333eaf 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -104,7 +104,8 @@ struct RamBlockAttributes {
>   };
>   
>   int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
> -int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
> +/* @offset: the offset within the RAMBlock */
> +int ram_block_discard_guest_memfd_range(RAMBlock *rb, ram_addr_t offset,
>                                           size_t length);

This isn't a ram_addr_t, it's an offset.
You can't pass the value to one of the lookup functions, for instance.
Though I suppose 80% of the ram_addr.h interface uses ram_addr_t for lots of things that 
aren't.


r~

