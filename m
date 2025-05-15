Return-Path: <kvm+bounces-46650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F79BAB7FB7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28BFF1639E7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF442882D1;
	Thu, 15 May 2025 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBHAw892"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4327CCF6
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747296277; cv=none; b=BwS7OLahwgm//jAyp7UzvG3oGZrRblb8TfHlp+4nUgUoD8fBEEpgCV2wwpt9qGBJVzy8dtEtt5kwZfAntamMaNZkeRiTEdWI4WrI4pbn4Fl/SriWRkYZ7KDaCHyzo3Vb/Xwu7u++VvVk6hUzGpGbTnR7WGDaMMpjId0wQFOeMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747296277; c=relaxed/simple;
	bh=x2mLUxA+et8iwA9rDXZwVtIWILZ108fGO+5QLFn1iKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sd7qoL8rzP7UWu8XxvkWkqPfSnwkzENhXoCU++0vqGU6dH86EIPr+IdOLx+YYKZ0SiiRlXxq4gcutKpIREUPQX9HEiTDRtMPkiv/jxrM7CmQ/KzaLw40mOXnG5IyKtAc6tSOdHmtetFHiwtTXwpxiFkUNMA96sbqA6j5PcQtiLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBHAw892; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747296276; x=1778832276;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x2mLUxA+et8iwA9rDXZwVtIWILZ108fGO+5QLFn1iKw=;
  b=IBHAw892gCZnrxRRqINBYitySTrPslB7S7Akgk9XP3PFzMYI9uOKWPck
   qg0uYGRk3QCrfZXoWgod32BW83nwu2H+Rri6RAU5milTdqlr872zkyP/1
   k5EYVQ1mHW/jD4YgokGSWjJDLLRs3Ycox2sgrJhxWUmlYhUxWhLilZAc/
   kq9DZFT0F824Lk8lOVW+pbDbkCa8W9Xi9Fepg6cWYr8y0Gpo2Fq2gWnXN
   8pP+dsBDxJbFgT41qauZDY3PvJ2d3crSMaolil6ueDyZilGxT2W8Xi5OA
   QuLjh7cg4AmDSDTzAmAnqpiTY6FeqM2b8N8D0NhAhNvAbEx3OmZ3m8yUk
   g==;
X-CSE-ConnectionGUID: jZX7NdLbTgm0rIP6KfiOvQ==
X-CSE-MsgGUID: 4In3MX+JShOUlO9+EcwYNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60230374"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="60230374"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:04:35 -0700
X-CSE-ConnectionGUID: i46b0jPrQnaeMMhU2eB1pw==
X-CSE-MsgGUID: ax5soz81Qsezcgk15CnXCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="138177647"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:04:27 -0700
Message-ID: <1c347ea7-1e33-420e-a666-cd02573d9089@intel.com>
Date: Thu, 15 May 2025 16:04:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with
 '_nodma' suffix
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Sergio Lopez <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
 Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
 Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
 Ani Sinha <anisinha@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-4-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250508133550.81391-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/8/2025 9:35 PM, Philippe Mathieu-Daudé wrote:
> Rename fw_cfg_init_mem() as fw_cfg_init_mem_nodma()
> to distinct with the DMA version (currently named
> fw_cfg_init_mem_wide).
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/nvram/fw_cfg.h | 3 ++-
>   hw/hppa/machine.c         | 2 +-
>   hw/nvram/fw_cfg.c         | 7 +++----
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
> index d41b9328fd1..d5161a79436 100644
> --- a/include/hw/nvram/fw_cfg.h
> +++ b/include/hw/nvram/fw_cfg.h
> @@ -307,7 +307,8 @@ bool fw_cfg_add_file_from_generator(FWCfgState *s,
>   
>   FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
>                                   AddressSpace *dma_as);
> -FWCfgState *fw_cfg_init_mem(hwaddr ctl_addr, hwaddr data_addr);
> +FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
> +                                  unsigned data_width);
>   FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
>                                    hwaddr data_addr, uint32_t data_width,
>                                    hwaddr dma_addr, AddressSpace *dma_as);
> diff --git a/hw/hppa/machine.c b/hw/hppa/machine.c
> index dacedc5409c..0d768cb90b0 100644
> --- a/hw/hppa/machine.c
> +++ b/hw/hppa/machine.c
> @@ -201,7 +201,7 @@ static FWCfgState *create_fw_cfg(MachineState *ms, PCIBus *pci_bus,
>       int btlb_entries = HPPA_BTLB_ENTRIES(&cpu[0]->env);
>       int len;
>   
> -    fw_cfg = fw_cfg_init_mem(addr, addr + 4);
> +    fw_cfg = fw_cfg_init_mem_nodma(addr, addr + 4, 1);

It does additional job to replace 
fw_cfg_data_mem_ops.valid.max_access_size with a hardcode 1.

It needs clarification at least in commit message that doing it is safe 
that fw_cfg_data_mem_ops.valid.max_access_size is not changed by other code.

It's even better to put this in a seperate patch.

For the pure rename part:

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>       fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, ms->smp.cpus);
>       fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, HPPA_MAX_CPUS);
>       fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, ms->ram_size);
> diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
> index 54cfa07d3f5..10f8f8db86f 100644
> --- a/hw/nvram/fw_cfg.c
> +++ b/hw/nvram/fw_cfg.c
> @@ -1087,11 +1087,10 @@ FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
>       return s;
>   }
>   
> -FWCfgState *fw_cfg_init_mem(hwaddr ctl_addr, hwaddr data_addr)
> +FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
> +                                  unsigned data_width)
>   {
> -    return fw_cfg_init_mem_wide(ctl_addr, data_addr,
> -                                fw_cfg_data_mem_ops.valid.max_access_size,
> -                                0, NULL);
> +    return fw_cfg_init_mem_wide(ctl_addr, data_addr, data_width, 0, NULL);
>   }
>   
>   


