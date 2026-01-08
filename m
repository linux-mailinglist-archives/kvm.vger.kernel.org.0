Return-Path: <kvm+bounces-67350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 173ECD01373
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 07:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 77B1F3002176
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 06:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C181329E43;
	Thu,  8 Jan 2026 06:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRxuyV4n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IHCRGS1a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC3F1BF33
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 06:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767852655; cv=none; b=mNvRBUU57ga2PHVuzIquVDSMYaiREJswZp0V+xcfRsjtNP31M5cogAatGgdQcGzjAWzXqY0DSAaM3oUn7rZv5IND3/IKEu0TMAbihjOuZZIKX/ikcXPsEyTeDqVG2cqLTzaltRgJIP2hOG8L8NZNUl3WmrMCckvjoNFypo2+710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767852655; c=relaxed/simple;
	bh=TriolJYhpgO34OvPdh/503uwBYw64GFr4RLpuk/Kvn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IiwAH0Xma8+cw2Rs2XfvoU+vtdiyyud8nIBYOxxVUKFAikMJQFBXF9Oln0s1rBpwjd1THjJ6eQKnFcyUJgOCgtWf4dkQKKkJfMarxBu7LTCeXmCjXHF5hFTSBQlXhJCjMpXjSoWyiQSKgXFzcCWKeZcEHEMPxIahILqicNNWWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRxuyV4n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IHCRGS1a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767852652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GqqoIUnlcs+Zjb3qCkKwSMLUW1dKlhjaUAgjxZyVoPI=;
	b=dRxuyV4nu2QHKDyrDb/YbUPxkkaH+tAOa90RvOIfjQXAFgnPmjrk6PtXGmhdaJl930kVen
	BeTsyEffMFMgeoeR5qneJphgtyKMX8kOs6ZsOqJxjxwmWCiwoqZdWN1vj1K68wxA7jdRsG
	jHmHYte5D2PFUyjYGpaXubA2/Pbq0Mk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-Wgw-K5z9NL6wPi8BBVaKgg-1; Thu, 08 Jan 2026 01:10:50 -0500
X-MC-Unique: Wgw-K5z9NL6wPi8BBVaKgg-1
X-Mimecast-MFC-AGG-ID: Wgw-K5z9NL6wPi8BBVaKgg_1767852649
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b844098867cso344760566b.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 22:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767852649; x=1768457449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GqqoIUnlcs+Zjb3qCkKwSMLUW1dKlhjaUAgjxZyVoPI=;
        b=IHCRGS1aBGVbnRbZDFfTqsrzmSuwI8ZvR/H59XZU4tgAp8nSaghHihGGG5RrmBKOYR
         nAHAjH5dS3LebnyT8F7BsmGGYC1NllbnoEwSLIYMT+EOIlVZ2PBvZFjASxT58HE0Q21S
         oPdUZsvYdGiarR99MnQrdOI0NNvacaFzin3PujXfQu0vvpxnva8vF8cBiNNMCZfkwoox
         84zTs2I+lQy34UXUI7WS0pxDcXVEShduvPda/9itfE469RGK7uknQPnncCrb91Kbxuuz
         KrQmz1uCneXrF5+/9vOS2T8LBjtfj40UWCxT0gaLx0Cjnq2s8reDSd04rI0CbVK2vHyW
         OXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767852649; x=1768457449;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqqoIUnlcs+Zjb3qCkKwSMLUW1dKlhjaUAgjxZyVoPI=;
        b=b6ii7AoZxBmlXWBoj1OexLJYt0+/iVZCgHs9EG4D0dSBbMxIfP/fn0z+R9u91X48fh
         i6IqWfiBiJGUhLQt0cwvK/lMnM3Tri8IXlg6OpjNSTjtZBIegi4WeBMjQIMU5WavfXjV
         uHfWv+3pMjz8nPm/wGzSMmmiO7IZWPaNdqqw7OnPjHKG2ggB+JhQY8KKV7ZmviTcJQYy
         FTf1a828RcskS8zJAVIH8pgQgQIlcXo3UO5+aywXGozjL7/w4eSZyQNLrbIk6dJZ9EET
         kF5hdYz300Y0AR6D1qgsY35pWafhnwfaJ8BzOd4q8zBeJ5UuUzkceUQJD7LqcoAiVZ4m
         HGEg==
X-Forwarded-Encrypted: i=1; AJvYcCVo+PXBe3bDeVyTkaYQZWluAl9R1Ul0+M5TPAIflcAz7MZchvZu5zNjBkU+yF5UsH5QMJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvDdusTTHtXz4u/cxnQpbP65HDe2Nk51TusoOePHWghU6JD8G7
	eTZZbr8bqB0u4GBfWYZlLsyRenklbDT2X30w29jL7SDFRGCuuXPjQ6kzVl7jfEuhnxZoPeZ192S
	OxsWvxegf1OhTU1qK8+eGyFjZfsfeDMg3Q1kcyronTqdHe90fJTiHxA==
X-Gm-Gg: AY/fxX69/u3GXI2A7BmxXM25c3tV5Ewk4cQDQeOjau3BATVY58i8c3MLv4fWz1I/t5L
	7rGQsMxoHPaKS4oQ/u9BUVtTotxqFnml9du9Wduzx70uM306DB8OXOoqfmKTSpfAV9B7UN6NDqj
	dkP26j2X71iJR0H8/4A8/q6HINPVDJwHfEXT54X3FDB40llQYPiaa793qW9g8kpt50ncsGFVj3H
	AitF9xMRoTGu0oXxv/DlSM23X9RWVMY0OLjIyqI810Ps4SZjwfzpXj856QULmPvICAE5zU4SpwS
	RvrgWUm5JUBPq8/aIVZkVhGTTIyimQT8ytw1EzAWoaV2leYBwDTOvePFknPq7SCG9Su+/etoBWp
	ny0S3JHE=
X-Received: by 2002:a17:907:3da0:b0:b83:95c7:e984 with SMTP id a640c23a62f3a-b84453ab79emr460305066b.49.1767852649337;
        Wed, 07 Jan 2026 22:10:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYdqj39oEPTJdzVEMg8TkaPsz+8ATfse0lKQJoqTGKvMVG2VGHcHoGM4ob2+mdqAIIhK9ksA==
X-Received: by 2002:a17:907:3da0:b0:b83:95c7:e984 with SMTP id a640c23a62f3a-b84453ab79emr460299266b.49.1767852648854;
        Wed, 07 Jan 2026 22:10:48 -0800 (PST)
Received: from [192.168.0.9] ([47.64.114.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a51577bsm702015666b.56.2026.01.07.22.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 22:10:48 -0800 (PST)
Message-ID: <bc31cc25-ce64-4954-b896-ba9f30c041ac@redhat.com>
Date: Thu, 8 Jan 2026 07:10:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/27] hw/i386: Remove linuxboot.bin
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: qemu-devel@nongnu.org, devel@lists.libvirt.org, kvm@vger.kernel.org,
 qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Sergio Lopez <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Amit Shah <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 BALATON Zoltan <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>,
 Jiri Denemark <jdenemar@redhat.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
 <20260108033051.777361-16-zhao1.liu@intel.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260108033051.777361-16-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/01/2026 04.30, Zhao Liu wrote:
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> All machines now use the linuxboot_dma.bin binary, so it's safe to
> remove the non-DMA version (linuxboot.bin).
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>   * Update commit message: not only pc, but also microvm enables
>     DMA for FwCfgState (in microvm_memory_init).
> ---
>   hw/i386/pc.c                  |   3 +-
>   pc-bios/meson.build           |   1 -
>   pc-bios/optionrom/Makefile    |   2 +-
>   pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
>   4 files changed, 2 insertions(+), 199 deletions(-)
>   delete mode 100644 pc-bios/optionrom/linuxboot.S

Reviewed-by: Thomas Huth <thuth@redhat.com>


