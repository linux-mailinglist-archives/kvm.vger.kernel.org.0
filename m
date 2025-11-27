Return-Path: <kvm+bounces-64873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B942C8EB42
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F4133A46AA
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738D0331A72;
	Thu, 27 Nov 2025 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDKb/RE4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930593321BD
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764252242; cv=none; b=OY0dw2ufI31Xf+dyjMnHok/YChTusYvSm73+YqdXnLXwdwIFmI6jyeiyVT+vdZ1V74TmY2POagndJXbgo2aUkK82tkWMaHJ9cwT21JUApx2yeJN5JTccw7DGYW9Uvvh46VsZmqT0hfsXxDjaBIcsC//KkOyP43U1eG4/6A9igcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764252242; c=relaxed/simple;
	bh=wbIpXOHrAhUYTz4YKeYSdJQ6eJC9BtOYzZPt+wa1Bpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kjb7F1kUB33LEJOlQVcrq/viEM6G5pCsDlhOa30BzeXCBusPg5C5V+zuIx6/UyGaV+EC8kdUVRHg3w4Yj8f80ItV6LkU6alZJ8lll+s3sESPH7KThF9eu8p59DQ7xZFl09UEPL7OpuzZBK5AyBxqs6VWRIIJRY7paebTZgTyz3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDKb/RE4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764252238; x=1795788238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wbIpXOHrAhUYTz4YKeYSdJQ6eJC9BtOYzZPt+wa1Bpo=;
  b=SDKb/RE4THB9X5QVOLrV1gje9eFa/vwMPfB21sy+TfC5otUvlO4mAteu
   n13JVfFXsAUaQqrAwvWqxkhRvYGXZORGMQSOgItyTc6bsO1kpFOpcrW80
   NYPiqf1DQlhtOJ0VlvD+xNh7/atdtxi/sInsL++WXvPFTX6VPBoGd0Dcd
   KLBddReql6gzd9ZCdZfzTslMoqkR+WdRv88pnvJPOy1glqQeYo/rXRgTa
   /ce1dercpO/up4RjuP0VcOJcWnNX5zGYkb2Kenaxyq128nb3glQXRRIIZ
   SyPjFP6bE73zyLn5w1vz0cUWMTIpIoBkrVxhVwWqOa6SwXcsLIXAqL0BH
   w==;
X-CSE-ConnectionGUID: 0AIKdir2QpyaD4p6jxd4Sw==
X-CSE-MsgGUID: 2teBK7kCRZqzNLwIt08O/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76988042"
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="76988042"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 06:03:56 -0800
X-CSE-ConnectionGUID: ZiYc/Z/CSz60FVKebjEsIQ==
X-CSE-MsgGUID: ybI2bXHdSTGszpa08vP/ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="216594607"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 27 Nov 2025 06:03:48 -0800
Date: Thu, 27 Nov 2025 22:28:28 +0800
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
	Jason Wang <jasowang@redhat.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 09/27] hw/nvram/fw_cfg: Remove
 fw_cfg_io_properties::dma_enabled
Message-ID: <aShgDDow//CQsMhF@intel.com>
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

Yes,

> the 'dma_enabled' of the TYPE_FW_CFG_IO type is not used anymore.
> Remove it, simplifying fw_cfg_init_io_dma() and fw_cfg_io_realize().

but the 'dma_enabled' of the TYPE_FW_CFG_IO type is still used in
hw/sparc64/sun4u.c:

    dev = qdev_new(TYPE_FW_CFG_IO);
    qdev_prop_set_bit(dev, "dma_enabled", false);

The creation of TYPE_FW_CFG_IO is similar to fw_cfg_init_io_dma(), but
it still has little difference so I find sun4uv can't use
fw_cfg_init_io_dma() directly for now, or it may require more careful
clarification that it can use fw_cfg_init_io_dma().

So, at least we have to keep "dma_enabled" property in
fw_cfg_io_properties[].

...

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

But now all x86 machines have enabled dma, so it's still possible to
drop "linuxboot.bin".

For this, I think we could add a DMA check in the x86 common code to
guarantee DMA is enabled and then we won't need to constantly check
DMA enable in every corner.

Regards,
Zhao


