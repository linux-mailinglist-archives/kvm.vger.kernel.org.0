Return-Path: <kvm+bounces-46013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C91AB0A63
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 880344C8EA2
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6085F26A1AC;
	Fri,  9 May 2025 06:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NsIkG/V5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4A326A09A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746771383; cv=none; b=LfQd4+GA6HFKAZCVu5ialw+wxy0V6Zq+S2TkHwghDlMXGig9ebYVl/cwvY6vxCEmHumuDSdLabmaRR5Jy1Dj+p946eZyZY0xXkouhqJy3ghRIBRXZadXunpIcl2rnfbBdzC4H1SUZimz5d7my8bMW0pev67WmcL+4O3I2Mk4gmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746771383; c=relaxed/simple;
	bh=ggqJ1IiHFWvnWutr4RX9vZ4PtcAAvKkNUvCBk+pjK5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxsaHjCQ+KsbH5BMendEqB57RMrj2Xf1SlwkNTJOP2VJFdRKL0hFCZa5sQnyOEUwXiz11D/uc7S1NBPJmYJod2TcsJ4LhSaYCTXd7YgNg5rHqvnCyrTii9LOiB0c+eciKUJzsvcIp3mxLY1g0LYPSpXUeRr7IkHZSbWAXzjfLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NsIkG/V5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746771382; x=1778307382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ggqJ1IiHFWvnWutr4RX9vZ4PtcAAvKkNUvCBk+pjK5I=;
  b=NsIkG/V5I6mqbpDQnvasYozaIcdUaVaX4KjyI0ZdGID8bEr1DSkVIbP8
   yv9np0kLPXNi7XWlhSxID/VweeNKXmIIKuWaFTkBbZpG3Of3dNZlRRnmA
   bO4j3ZfGPK4CKwtflkuGXrYqdAfYMAyPdzxvlQUyERcvL1OV9Uu9kSSDY
   2zxpUCgGI6ADX8dXzZw0ICQEc4yAQT5y7Gq7kMuMlghPtSJhUAL4aDtwS
   wrOAvr186ar3Vi7YmpSq6XTQ6SFqvogtHD26m23IwJzilLmvLGtNq+f5r
   cvV2KwiKiQtJezW5ERAIw0X1KhjTGtPDhSOsM9j+kuj9t7VzYn7Wd7k45
   Q==;
X-CSE-ConnectionGUID: Z7JX5FOGRtWM2PraEMf8FQ==
X-CSE-MsgGUID: 36WhjvCQTsSIqhbwfpHYFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66119790"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="66119790"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:16:20 -0700
X-CSE-ConnectionGUID: EShOvyRJSeCCU7P6Wp2LEQ==
X-CSE-MsgGUID: a3tZ14YNSzus0U3OwlV/+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="137043614"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 08 May 2025 23:16:13 -0700
Date: Fri, 9 May 2025 14:37:15 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 09/27] hw/nvram/fw_cfg: Remove
 fw_cfg_io_properties::dma_enabled
Message-ID: <aB2imx1sp9sgMs3c@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-10-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-10-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:32PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:32 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 09/27] hw/nvram/fw_cfg: Remove
>  fw_cfg_io_properties::dma_enabled
> X-Mailer: git-send-email 2.47.1
> 
> Now than all calls to fw_cfg_init_io_dma() pass DMA arguments,
> the 'dma_enabled' of the TYPE_FW_CFG_IO type is not used anymore.
> Remove it, simplifying fw_cfg_init_io_dma() and fw_cfg_io_realize().
> 
> Note, we can not remove the equivalent in fw_cfg_mem_properties[]
> because it is still used in HPPA and MIPS Loongson3 machines:
> 
>   $ git grep -w fw_cfg_init_mem_nodma
>   hw/hppa/machine.c:204:    fw_cfg = fw_cfg_init_mem_nodma(addr, addr + 4, 1);
>   hw/mips/loongson3_virt.c:289:    fw_cfg = fw_cfg_init_mem_nodma(cfg_addr, cfg_addr + 8, 8);
> 
> 'linuxboot.bin' isn't used anymore, we'll remove it in the
> next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/i386/fw_cfg.c     |  5 +----
>  hw/i386/x86-common.c |  5 +----
>  hw/nvram/fw_cfg.c    | 26 ++++++++------------------
>  3 files changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index 5c0bcd5f8a9..1fe084fd720 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -221,10 +221,7 @@ void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg)
>       * of the i/o region used is FW_CFG_CTL_SIZE; when using DMA, the
>       * DMA control register is located at FW_CFG_DMA_IO_BASE + 4
>       */
> -    Object *obj = OBJECT(fw_cfg);
> -    uint8_t io_size = object_property_get_bool(obj, "dma_enabled", NULL) ?
> -        ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t) :
> -        FW_CFG_CTL_SIZE;
> +    uint8_t io_size = ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t);
>      Aml *dev = aml_device("FWCF");
>      Aml *crs = aml_resource_template();
>  
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index 27254a0e9f1..ee594364415 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -991,10 +991,7 @@ void x86_load_linux(X86MachineState *x86ms,
>      }
>  
>      option_rom[nb_option_roms].bootindex = 0;
> -    option_rom[nb_option_roms].name = "linuxboot.bin";
> -    if (fw_cfg_dma_enabled(fw_cfg)) {
> -        option_rom[nb_option_roms].name = "linuxboot_dma.bin";
> -    }
> +    option_rom[nb_option_roms].name = "linuxboot_dma.bin";
>      nb_option_roms++;
>  }
>  
> diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
> index 51b028b5d0a..ef976a4bce2 100644
> --- a/hw/nvram/fw_cfg.c
> +++ b/hw/nvram/fw_cfg.c
> @@ -1026,12 +1026,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
>      FWCfgIoState *ios;
>      FWCfgState *s;
>      MemoryRegion *iomem = get_system_io();
> -    bool dma_requested = dma_iobase && dma_as;
>  
> +    assert(dma_iobase);

Maybe a rebase nit? In v3, it is:

assert(dma_iobase && dma_as);

Others are fine for me.


