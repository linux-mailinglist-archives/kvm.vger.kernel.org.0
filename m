Return-Path: <kvm+bounces-46007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2792AB0826
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 05:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E0C59E0482
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 03:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB60238178;
	Fri,  9 May 2025 03:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QuGeqwhu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97717D2
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 03:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746759785; cv=none; b=f0ReVYNRiOEBLGfyEh6ohmIADMEUUhPEwY2tmp3uvfh8FJj5iACc2byFkSi1hojAT31hAGo7m/MD7cChCVmybrtm9jFYacWuR6FfqEWGMn/i/m4ycvdtw0zKzQamcwMIml/WRBD3wMdGY/EJvriXOE6XhC5MZDo4QDAo8MdJOcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746759785; c=relaxed/simple;
	bh=Evm2J5jDfYE7GIyMM2IniSVLpb9smCtUzVppmg7PfJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emiE4o/tgvtDRxCR6kUJAm1s9lnVbT9AfwrT/P3SMt1njSS0Sqm6TDoRSsHWvPHtff/33rS71T4FXR1Imji8XC7HIvPKAIzIWRhTQcOcMn/VYb0A4O3vzbqMmqYGj5uhLaXo2hv/nnP8qceoUqf5fSXYzaoeCzJMYb0DwcPz1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QuGeqwhu; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746759782; x=1778295782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Evm2J5jDfYE7GIyMM2IniSVLpb9smCtUzVppmg7PfJI=;
  b=QuGeqwhuvlmjO2TWvhYuJg5LgHARa/+OsHdd2xpVhDKnJDlFIRBkAgCZ
   cTUZT8JEiP921buhDsdw15T6QhI+hPvGYaEt/7mvwAgqiMwG/H3Dsnen7
   XfevQd81ft0tIBB4y0tqRwxCUJfdDU+xA5p1kbaovqW2KU69XYAwPIsGv
   RBJUBiAfIoH/4k+ca3tGQ1+XKpIfZG5kqeyc0vF/XbSoqYXNHDi4lBxt9
   pVCyZZoxtAJNylV11m7N+hZKS/cCBsp0TGkBax88qDLxBdOMCk43hjxSL
   OuRLfd1wmO/CwSehWFrUjf/O+jn+FhoJnq/bKCx9uqJHEjJSXNqu4bSlq
   A==;
X-CSE-ConnectionGUID: 0iJSOThvSRqV2zKXkAGl5A==
X-CSE-MsgGUID: +2hJUiExS0imvxG/oYPCzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="65982960"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="65982960"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 20:03:01 -0700
X-CSE-ConnectionGUID: BB81EqziTsGr7DeDt8s0eg==
X-CSE-MsgGUID: e4s10DfvSBGLndm3FDAgqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="173657918"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 08 May 2025 20:02:55 -0700
Date: Fri, 9 May 2025 11:23:56 +0800
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
Subject: Re: [PATCH v4 07/27] hw/i386/x86: Remove
 X86MachineClass::fwcfg_dma_enabled field
Message-ID: <aB11TGrQO9xmx+u1@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-8-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-8-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:30PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:30 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 07/27] hw/i386/x86: Remove
>  X86MachineClass::fwcfg_dma_enabled field
> X-Mailer: git-send-email 2.47.1
> 
> The X86MachineClass::fwcfg_dma_enabled boolean was only used
> by the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
> removed. Remove it and simplify.
> 
> 'multiboot.bin' isn't used anymore, we'll remove it in the
> next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/hw/i386/x86.h | 2 --
>  hw/i386/microvm.c     | 3 ---
>  hw/i386/multiboot.c   | 7 +------
>  hw/i386/x86-common.c  | 3 +--
>  hw/i386/x86.c         | 2 --
>  5 files changed, 2 insertions(+), 15 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


