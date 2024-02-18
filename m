Return-Path: <kvm+bounces-8987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0423985967A
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 11:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C618B213CD
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 10:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201DB4EB46;
	Sun, 18 Feb 2024 10:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RqziBjHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778828DA7
	for <kvm@vger.kernel.org>; Sun, 18 Feb 2024 10:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708253710; cv=none; b=ay6eT3MMgUHwxNr+7zIM1F1m8GjPhq6bVgzFiVKnqQnsTUalhymuOFPBTw6e2n3exViYEG+qcxW+Xgi+JMGC/wkKF8xVSOPo1NIrR1CeboPaUX3Q98I5anLVlLBH1jLNepItPZW7rwpM79q8LJCZrSYAklPYmjG/GempCCnQ37E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708253710; c=relaxed/simple;
	bh=hEBffOIHI+615Msc0rfQBi25CsyhyujYu3ofryxyX0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s5e0cHDwNo8Lk48iIKuAfoColYqu3uANG8H9/IqQwUR3WaREitDfjuaj9Uiq4swIdDQTeyKRkb7cVQSd6L5lycSLM1Pwp7NrusX4bau9hgxzFOjmVEl3//LurJPvcpYt6FVGPQOSu/dbKvH7nDjrcKwzjLyJWqxB5G6xl1mAEJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RqziBjHE; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3394bec856fso2527319f8f.0
        for <kvm@vger.kernel.org>; Sun, 18 Feb 2024 02:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708253707; x=1708858507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ipmxV3nOdx3h3F+O2aehFEDYqn1bKUDQSXjhDvzGmQ=;
        b=RqziBjHEUnLKrcDLbt0EbxuIvqWllvIUwU4o8WDMDKjqv662+1XnOdLhpShZrKXFOd
         8XJZubrrOPKeNV0QWL5c8nihUhE810SWz37NDEX1Wyedsqxmhib+nkEh9x8PtzzSvIy5
         KH3el9uhtp6vTs+E2c/xj1Ut0RKx5nppvk5pyKeqYG5/Iv3bmshcE/RSD+wpI6EwXBPs
         B+77HtLTVMwROGn/5T+YwxGVszRaGjx2Uq3GsktgCQt+tDvDX3bGdxWkPm+uI2Fj/KQY
         vM+wt9LqvYcVxZu/z0jYgwBJbmY226oD8j9n/I7uEWN8eWxbj2frhPvk9abPuHJdn4x6
         nHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708253707; x=1708858507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ipmxV3nOdx3h3F+O2aehFEDYqn1bKUDQSXjhDvzGmQ=;
        b=eHTtrmmtv/zDi7cIqZelBQT8nLzMxml0pHbFDWw1ggb8qinkHQi8TCG3pw0DqwtIan
         p0YbUB/lWZN+C1b7AmmGxfEaje9MAQlZXdEmRCIlvzjHPsCalZYGygKYLZL+NMrtzTMT
         ZvmCa9ptVvIR61JgE0VvT9SodxLxc2uPsHl+zYZjF2jrp8z4N1b1C+rPr7rPpuOczQeT
         +zIXYJ258wSBoEwCC/715fFHICNjrRHsKtsEaw9/2XTA/j30z4GsnHOOy30ZSB+TAGqY
         okjaAdDZhaKlK5pvvA+ueF5jFeQFBoYesqivqrx1CrvXnGPhZe1nAD3W8iuXd1pb6KB2
         i34Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFU2jYHog9MKieE+L4dqrSqtUXE48sgxRXtgYLOLlNRAWmLxOP7hVq2zKpvpVlSQQumQ8T5cHyblZjNKlkVnOl/n7M
X-Gm-Message-State: AOJu0Yxzj1WPfuwgYQwNyli7nhFOS3ynZa8vCJ83/N359r0H7F88EnZ4
	PIIYPuyvTGJEMJT4+JMqVGKDvgGmcJ4Md5rL47CQSzoQgOFtx7z8XTvwl+Q807k=
X-Google-Smtp-Source: AGHT+IEas+CP8+InFVGmuhiJckrz36ZDMP2ocbFZYBXqWWlVI4bd/PiPTd+zi5lrzUNPjOUWRSt3kg==
X-Received: by 2002:adf:e448:0:b0:33c:e728:c88b with SMTP id t8-20020adfe448000000b0033ce728c88bmr7813308wrm.24.1708253706791;
        Sun, 18 Feb 2024 02:55:06 -0800 (PST)
Received: from [192.168.69.100] ([176.176.153.199])
        by smtp.gmail.com with ESMTPSA id a7-20020adfeec7000000b0033b483d1abcsm7035765wrp.53.2024.02.18.02.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 02:55:06 -0800 (PST)
Message-ID: <6e82c46c-1523-4902-bf68-f47abe2dfede@linaro.org>
Date: Sun, 18 Feb 2024 11:55:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hw/sysbus: Inline and remove sysbus_add_io()
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
References: <20240216150441.45681-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240216150441.45681-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/2/24 16:04, Philippe Mathieu-Daudé wrote:
> sysbus_add_io(...) is a simple wrapper to
> memory_region_add_subregion(get_system_io(), ...).
> It is used in 3 places; inline it directly.

Rationale here is we want to move to an explicit I/O bus,
rather that an implicit one. Besides in heterogeneous
setup we can have more than one I/O bus.

> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/sysbus.h | 2 --
>   hw/core/sysbus.c    | 6 ------
>   hw/i386/kvmvapic.c  | 2 +-
>   hw/mips/mipssim.c   | 2 +-
>   hw/nvram/fw_cfg.c   | 5 +++--
>   5 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
> index 3564b7b6a2..14dbc22d0c 100644
> --- a/include/hw/sysbus.h
> +++ b/include/hw/sysbus.h
> @@ -83,8 +83,6 @@ void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr);
>   void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
>                                int priority);
>   void sysbus_mmio_unmap(SysBusDevice *dev, int n);
> -void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
> -                   MemoryRegion *mem);
>   MemoryRegion *sysbus_address_space(SysBusDevice *dev);


