Return-Path: <kvm+bounces-65188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 43611C9DE5A
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 07:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9BF1934384F
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 06:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0614257AD1;
	Wed,  3 Dec 2025 06:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hDGSifjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56463222565
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 06:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742303; cv=none; b=eZ/GGkcZmNZ3MRz4BzQ3uA/WExnyo282XFWoFJVHR2LJNOegctuF7uKHTAPWoqG2oBUqu23eXp2GNOWsu8w4JYR/OF+gALkYT421JLe0u0oGYI8ll0WWfKG8an7nGOFzVe88Syv7lXY1nNPDRpqeBR10bWvmC+j0uZrwT3m5jdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742303; c=relaxed/simple;
	bh=UgWNLt8d7MI9k9Zx+0y19NakKiz9CHnhq2aM+baCkjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMkv7p92o9Pb7hcZa84e/Q/jIVjU3sDjoLRzcgLy3qf/rRbBOPVNKv24qDwB91kIWFHo//j3/LjP6yVgPSZEEnokwGuye/cKQUF+SmOt4L5cIBLhyBS1z+sqXVCzLTuvvyu4c3XEwD4ymQj1nNa9WNtSbc9aVOQw5Ef0OYGaPVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hDGSifjc; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b3669ca3dso2759282f8f.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 22:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764742299; x=1765347099; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dlyYuqrBIco0T5Nx+vrsokniVf0Y0mIPJ5rNnrQW6jE=;
        b=hDGSifjcdKegxM3pnwlfC0l2GwQdXJ/28HEMmzPBSR9kL1g9L+mLpLcsf2JUdrOaIi
         oqCY0CqYm4lcka4084KpyGJgnlHeNJOvUefAE1wqnCtgO6a+yz6DNcemr70p3nUfb+Ox
         QH54sp9zRqJnDEsIk9gt9Bmiay9NMaJUa+eZI75cz6DvNvSBCKV9F3A3w+DnqR7AMuqt
         UsdYlDWbLoY39uEdINI/oC8unYmDMrmuVb0nzwarCKGld3evtzMDTmp43n+g095u2lC+
         RgNnEN9k9T2gmWS+JYMbE6SQm0/so1ETWjgl3zAwNzeUCcMftswom2Gxm0pYKE6vYiO2
         qDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764742299; x=1765347099;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlyYuqrBIco0T5Nx+vrsokniVf0Y0mIPJ5rNnrQW6jE=;
        b=O3euO7lCklOjogS/02riRF2MmOtZcoVIsQnMkLtTintxg9fGALKwPJzj1tbvsVsPRT
         z41YQKLVggbJL2MLNxpJTn5J2FKqPWtKdLTXZHWCakPNFC/T3jktrarMOx83CndECn5+
         yS2g4YqFf4xNMmKnrAcMyUoG4VrSfgfBpLlaHSUTiv/T/2Cb5vtsvKrXOjzEp0poipFN
         nTz3UbeNG7B3SgzHoIzETUteLVMTh3WNKeWZJLyWGw7595+sDilONjkc07zlpkFH5bx/
         KKpKJWvY5/98VdL4qXoPR8dwHy8m8EswmTpjR8JxR5B1T1OyrfG4E8Q52YNllmZ8P0AP
         Ytrg==
X-Forwarded-Encrypted: i=1; AJvYcCVQVQ/PYGSiutPAabl/s9aIOHD1ZmEcGP3iP7uNbSWObRKiApT+hCPgzxwIv8wAD3JdRZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxByPX9fzEz/ZmyM5dMiWAFQm5OGEY9LurYg/jgBiceKfpvq3ut
	b3CUnnHsyvsk4G7ytmy7nxHdO1WGcJWIMYeOTmcx59y02E/jYr7aVXa2nhOYsFZE8b8=
X-Gm-Gg: ASbGncsccMPMavCSMe7AJssYEHBWbkmd69vJNDHaZs59pT3EkS1IADvQg9iZFea30vi
	9+SNn8ZxT44aonF7NX4UKa1T39U8D6L/Nmnxn9icfziUfOB0BDHRmOeRljqLpl5u25VMuQIxqgK
	PJIRYHMlKa14EUwXFreterCVgCNIjx8h3dVlgxOUJE4lMIZARSAcseu0n+BEy77z+dM6Onl5Xq+
	K3ZDZyTpQxdrVauhuCOvkoYX++2PmdwM9+LS6N8SfUly6rB5jXLXOI1mbX17RioXpTWNz9q+58A
	9SMeTXLAgH270Xs1FM98GMrsvlf/eHdaC+DTLwCBANj2VKkYYbVej9WiR7971X9uwfBWB4H/DRd
	TjA40ffA891Dx9OwFY7K1x+aYQl+tQCbVbhLGK9jF7TFXhzKWQwB4a2jt2EzfSs839wXWmDhxha
	9LrDM0ef8LXda4jJAkl3wath2MjLV9nCpXsP4dJx8uxjRwaotNR7zQRjKGp07Eo6ol
X-Google-Smtp-Source: AGHT+IHvIQmfDwnTD8drf7tdAaJELXEvl7wBw+FoUcPNb0LeOYFoiFRBKneLkS5TxZ8trSwEw5E/YQ==
X-Received: by 2002:a05:6000:1ac9:b0:42b:2fc8:186 with SMTP id ffacd0b85a97d-42f731bc03amr722215f8f.46.1764742299461;
        Tue, 02 Dec 2025 22:11:39 -0800 (PST)
Received: from [192.168.69.213] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa86d0sm35622115f8f.39.2025.12.02.22.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 22:11:38 -0800 (PST)
Message-ID: <3991ece0-b49a-4c09-9309-ed0c50ce2a24@linaro.org>
Date: Wed, 3 Dec 2025 07:11:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/28] hw/i386: Assume fw_cfg DMA is always enabled
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>
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
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
 <20251202162835.3227894-16-zhao1.liu@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251202162835.3227894-16-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/12/25 17:28, Zhao Liu wrote:
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> Now all calls of x86 machines to fw_cfg_init_io_dma() pass DMA
> arguments, so the FWCfgState (FWCfgIoState) created by x86 machines
> enables DMA by default.
> 
> Although other callers of fw_cfg_init_io_dma() besides x86 also pass
> DMA arguments to create DMA-enabled FwCfgIoState, the "dma_enabled"
> property of FwCfgIoState cannot yet be removed, because Sun4u and Sun4v
> still create DMA-disabled FwCfgIoState (bypass fw_cfg_init_io_dma()) in
> sun4uv_init() (hw/sparc64/sun4u.c).
> 
> Maybe reusing fw_cfg_init_io_dma() for them would be a better choice, or
> adding fw_cfg_init_io_nodma(). However, before that, first simplify the
> handling of FwCfgState in x86.

I answered these concerns here:
https://lore.kernel.org/qemu-devel/20251203060942.57851-1-philmd@linaro.org/

> Considering that FwCfgIoState in x86 enables DMA by default, remove the
> handling for DMA-disabled cases and replace DMA checks with assertions
> to ensure that the default DMA-enabled setting is not broken.
> 
> Then 'linuxboot.bin' isn't used anymore, and it will be removed in the
> next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v4:
>   * Keep "dma_enabled" property in fw_cfg_io_properties[].
>   * Replace DMA checks with assertions for x86 machines.
> ---
>   hw/i386/fw_cfg.c     | 16 ++++++++--------
>   hw/i386/x86-common.c |  6 ++----
>   2 files changed, 10 insertions(+), 12 deletions(-)


