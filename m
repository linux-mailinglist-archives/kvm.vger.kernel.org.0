Return-Path: <kvm+bounces-64874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7910CC8EB69
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 15:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FEDF3AAA5F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4ACB3328E5;
	Thu, 27 Nov 2025 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="izx21jyj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA41A9F97
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764252591; cv=none; b=DoWtgE/fF1wCsaOQI924m8RmvsWJlLInlIOdymkPc0LBuUK/+yNRbR8dHoYEae7mnZo7r6foO5ifKbpMdSougevtf05uoLou9J8QeV1I24i53+1f7RuUt7TGFyems/YdpvFD2JeDCAD0DBtmYzP/a1LKSXS0yssY6+r3xeufuxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764252591; c=relaxed/simple;
	bh=bQdYilWGa9Wi2rdUzt6QN0o4fezK94Yfgc3qXyRYmE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+bZcHHh8CCrP73opyVyPvzJZCBrPFXMc1VuuSSTRNdVLH+fAh2wft8ohFvDXv8dFwTuWsJqKoMI8kTA9VHOfmlh2xNQ3FniYnacFfXfOeoeM3wrjVM/ndh+pjymanOLSzF1S7Re5/8DzwEM9w0QhW22p3x2n5dwivg1gL6zZoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=izx21jyj; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764252590; x=1795788590;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bQdYilWGa9Wi2rdUzt6QN0o4fezK94Yfgc3qXyRYmE0=;
  b=izx21jyjQnneM965um7Fv/WopYJjNO/WZD2VH+feHnvf4Q1FkD7vlcIC
   SiYBRfcyAad5uYphQF9dzMxfnk1bfIaQgAgsnJ4qt9ZavUBbh4xeBdX+c
   zjIdhf+tlimTmH+KrMrxrfaXwk08oWnMC34kf84sl+xH/HKJZdjfS5B0A
   nZ8zpyahKrZe7IFdaFD2uf6+QszANFCwch4Gvmmd2rkDzD5/duUfKLnXI
   B8AHBiXgQJipdWN6dlLFqaUzbN8X+Ng6eRxq1wgSSK3yaFLsm1Qvy62i2
   AzkBn4+V0LzFQponMXZlwDqn/SqBxffzHjozf9Btaen97Rox59zPwkkPM
   A==;
X-CSE-ConnectionGUID: 4RpmdYv3RJevwY8y2MwGmw==
X-CSE-MsgGUID: 6CPZ4Am/RQeAkIne8E6gpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="77402708"
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="77402708"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 06:09:49 -0800
X-CSE-ConnectionGUID: H8ufkZXVQg67BZP6Ctky/g==
X-CSE-MsgGUID: 2bH9/39aR9GF4XcDljhEyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,231,1758610800"; 
   d="scan'208";a="193042281"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 27 Nov 2025 06:09:42 -0800
Date: Thu, 27 Nov 2025 22:34:22 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
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
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
Message-ID: <aShhbuuW/CVsoLvP@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-11-philmd@linaro.org>
 <20250509180411.10f6e683@imammedo.users.ipa.redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250509180411.10f6e683@imammedo.users.ipa.redhat.com>

On Fri, May 09, 2025 at 06:04:11PM +0200, Igor Mammedov wrote:
> Date: Fri, 9 May 2025 18:04:11 +0200
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
> 
> On Thu,  8 May 2025 15:35:33 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
> > All PC machines now use the linuxboot_dma.bin binary,
> > we can remove the non-DMA version (linuxboot.bin).
> > 
> > Suggested-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> > ---
> >  hw/i386/pc.c                  |   3 +-
 
(After a long interval, more of a note.)

> linuxboot.bin is referenced in a few more files:
> 
> hw/i386/x86-common.c:    option_rom[nb_option_roms].name = "linuxboot.bin";

this case is removed in previous patch (which considerred x86 machines
all have DMA enabled).

> hw/nvram/fw_cfg.c:    { "genroms/linuxboot.bin", 60 },

this case is removed in commit 6160ce208419 ("hw/nvram/fw_cfg: Remove
legacy FW_CFG_ORDER_OVERRIDE").

Regards,
Zhao


