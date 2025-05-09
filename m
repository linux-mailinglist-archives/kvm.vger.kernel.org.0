Return-Path: <kvm+bounces-46037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3B4AB0E5A
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 900951BC47D4
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE7E274FDC;
	Fri,  9 May 2025 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OX0Stlqs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA45A73477
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746781934; cv=none; b=B1mxtdXTMLopgNCbzmDhl5K3L3+lOAHqrxsS/ZRSSIr1fmbtbCqqboBSV1TbQiQxw2I4GylAbq2UfA/w1Gtn9fYPCG1U7wywnC6gY5QUsWfh33ELOq23bFDH1teiQgLKjI8XpUCB0ZiRiz/XkLo7ex6FUxFbNEf2egblCkybuuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746781934; c=relaxed/simple;
	bh=nmrKnlOEX78ELVod8mBSRtwJoP3ob0jMqB36+cCphAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5+1b20L9qS/mGC5yRwZyvUSmq+qBcKmMeVNNnjriiWSbqzbbDhkxvdVJFuzPWcv6HxIOUtdoeoQlbzuT7Ds6WSYRURtJTAXOexJaY2ZR7hXf8oGEgwxamOiq02IFJnSYEgGtd0NWgt1UspzzB2lrflS0NHnLQJsttSXJklxdIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OX0Stlqs; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746781932; x=1778317932;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=nmrKnlOEX78ELVod8mBSRtwJoP3ob0jMqB36+cCphAk=;
  b=OX0StlqslP5CysLMbEH0UwTaZrEXeSZQ4mnkJtvavzhcrEVZAn21aZFs
   I+zvcs0vKf6mKnD6koJgjGL5AQvGE+baTsxPY2lRo+2fKxl0a04/26cVC
   Qz4XVobm6d6oW+w18g/05sijVoNOWagBOB7Gm0A1Sigkehp7oJDMS8M53
   xSTbMF6iIUsMaUPj3ybHBZRqIylT7qa9rJrvvi2xBXtYSRQwi8gBw7zBj
   +tdbuW3jwNtgkYY2TzeoKLc6pXexR80uLk2VY+HC97KdiBbm0I4xOh8SS
   RlyLm7Hjtv99NjCtfZhhan1Vtxe5arHeWeEn9FbnGQBg4R8cZ+os0oKb+
   w==;
X-CSE-ConnectionGUID: 77rjKxDASOqxugMBAhFoUQ==
X-CSE-MsgGUID: LtxSkiyIRAyP3yNLTuulHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59599637"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="59599637"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:12:12 -0700
X-CSE-ConnectionGUID: 0Jcea1UdTqOmGLCfiai26Q==
X-CSE-MsgGUID: hBfDipe6RE6+zWv5spsNiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="167640216"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 09 May 2025 02:12:05 -0700
Date: Fri, 9 May 2025 17:33:07 +0800
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
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 16/27] hw/virtio/virtio-mmio: Remove
 VirtIOMMIOProxy::format_transport_address field
Message-ID: <aB3L0wT5OkcfIrSe@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-17-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-17-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:39PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:39 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 16/27] hw/virtio/virtio-mmio: Remove
>  VirtIOMMIOProxy::format_transport_address field
> X-Mailer: git-send-email 2.47.1
> 
> The VirtIOMMIOProxy::format_transport_address boolean was only set
> in the hw_compat_2_6[] array, via the 'format_transport_address=off'
> property. We removed all machines using that array, lets remove
> that property, simplifying virtio_mmio_bus_get_dev_path().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/hw/virtio/virtio-mmio.h |  1 -
>  hw/virtio/virtio-mmio.c         | 15 ---------------
>  2 files changed, 16 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


