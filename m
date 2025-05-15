Return-Path: <kvm+bounces-46653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A62FEAB8021
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30C9117EB31
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2E327FB16;
	Thu, 15 May 2025 08:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuWb2r7D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155A1ADFFE
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297072; cv=none; b=Wj7oj6gxlNOF/mZO+CuUfPbg/xpzIql9YftzHrxyZWCCx8Bc8u91wAGDKVQEYVTV4Fyhp2DPuGN9Q4s9vUj+tKMZAPSU41RQGvGRB6mF6cIYWS4OMWeVjnPckc5pSckmD40tUWqVULXlWrKD3ldp/b+2fYC+2k0IDz6D843JEqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297072; c=relaxed/simple;
	bh=J0d7qIZ0wAM9NtgBW44TtLkYeQrux0sEamdBuRSRMrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SZRnJ5oDbqMHVYc3ifAn0yKgOeEcaF8+vuln/kqCylgRlNovsKuScYzK5IYRATJxsBvrouL8lSeD2s+6SQYxM5hxGtFRZuSQOqeKZiwYBozMxH+Kti4LbWXKNPqpLqxdrs1uawLwtGX83O2HmglEXHeI+kfzgiOQAPrrMHpn2Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuWb2r7D; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747297071; x=1778833071;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J0d7qIZ0wAM9NtgBW44TtLkYeQrux0sEamdBuRSRMrc=;
  b=PuWb2r7DjruTEwCGwqMjGlqWT+2s/BgZT4o9+eQtnoYDZCn1/HcR/9eo
   ncBF8GhB24oZtuEp80dyhKgwslS/Us/dYgm0MAxz1ftR+fC1TdlE0WDMC
   GYJw1Cdv3NP9S1dzJ/I1TGiA2N4hasZt2C77lI3Ii4JzQzru8Uwz9CH7V
   VPn4jYIGJnipLzLClTskfRRr9kX3LE3GEIKCXFEbhWb3JBPDMzJrIJemc
   mx1mQ1H4PbdmFVDT/e1FDgzCy0GmvxQXoiZI4S+j6RhzFy+0p6vqkGktW
   Y+AR4xIdnFUWoeszv/zLUkkfautGeYmWeQ6DjN50z3WfrKjSyLSVRB4WC
   Q==;
X-CSE-ConnectionGUID: jyOlCT8oQ4OT0vCGWbkNKA==
X-CSE-MsgGUID: RG3jERnuTfyFu7bZvE8+tQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49089793"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="49089793"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:17:50 -0700
X-CSE-ConnectionGUID: hqga7r+1R4WuaPQz4z97Ew==
X-CSE-MsgGUID: w3HeNXTfQGigkpkjZsqihg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="169367933"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:17:42 -0700
Message-ID: <0805f8a8-1680-4962-80e3-6b43a6e344b6@intel.com>
Date: Thu, 15 May 2025 16:17:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide()
 -> fw_cfg_init_mem_dma()
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
 <20250508133550.81391-7-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250508133550.81391-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/8/2025 9:35 PM, Philippe Mathieu-Daudé wrote:
> "wide" in fw_cfg_init_mem_wide() means "DMA support".
> Rename for clarity.

PS: at the time when fw_cfg_init_mem_wide() was first introcuded,
'wide' was exactly for data_width. see commit 6c87e3d5967a.

> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

with the usage in hw/loongarch/fw_cfg.c fixed,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/hw/nvram/fw_cfg.h | 6 +++---
>   hw/arm/virt.c             | 2 +-
>   hw/nvram/fw_cfg.c         | 6 +++---
>   hw/riscv/virt.c           | 4 ++--
>   4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
> index d5161a79436..c4c49886754 100644
> --- a/include/hw/nvram/fw_cfg.h
> +++ b/include/hw/nvram/fw_cfg.h
> @@ -309,9 +309,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
>                                   AddressSpace *dma_as);
>   FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
>                                     unsigned data_width);
> -FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
> -                                 hwaddr data_addr, uint32_t data_width,
> -                                 hwaddr dma_addr, AddressSpace *dma_as);
> +FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
> +                                hwaddr data_addr, uint32_t data_width,
> +                                hwaddr dma_addr, AddressSpace *dma_as);
>   
>   FWCfgState *fw_cfg_find(void);
>   bool fw_cfg_dma_enabled(void *opaque);
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9a6cd085a37..7583f0a85d9 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1361,7 +1361,7 @@ static FWCfgState *create_fw_cfg(const VirtMachineState *vms, AddressSpace *as)
>       FWCfgState *fw_cfg;
>       char *nodename;
>   
> -    fw_cfg = fw_cfg_init_mem_wide(base + 8, base, 8, base + 16, as);
> +    fw_cfg = fw_cfg_init_mem_dma(base + 8, base, 8, base + 16, as);
>       fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)ms->smp.cpus);
>   
>       nodename = g_strdup_printf("/fw-cfg@%" PRIx64, base);
> diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
> index 4067324fb09..51b028b5d0a 100644
> --- a/hw/nvram/fw_cfg.c
> +++ b/hw/nvram/fw_cfg.c
> @@ -1087,9 +1087,9 @@ static FWCfgState *fw_cfg_init_mem_internal(hwaddr ctl_addr,
>       return s;
>   }
>   
> -FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
> -                                 hwaddr data_addr, uint32_t data_width,
> -                                 hwaddr dma_addr, AddressSpace *dma_as)
> +FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
> +                                hwaddr data_addr, uint32_t data_width,
> +                                hwaddr dma_addr, AddressSpace *dma_as)
>   {
>       assert(dma_addr && dma_as);
>       return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_addr,
> diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
> index be1bf0f6468..3ddea18c93e 100644
> --- a/hw/riscv/virt.c
> +++ b/hw/riscv/virt.c
> @@ -1266,8 +1266,8 @@ static FWCfgState *create_fw_cfg(const MachineState *ms)
>       hwaddr base = virt_memmap[VIRT_FW_CFG].base;
>       FWCfgState *fw_cfg;
>   
> -    fw_cfg = fw_cfg_init_mem_wide(base + 8, base, 8, base + 16,
> -                                  &address_space_memory);
> +    fw_cfg = fw_cfg_init_mem_dma(base + 8, base, 8, base + 16,
> +                                 &address_space_memory);
>       fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)ms->smp.cpus);
>   
>       return fw_cfg;


