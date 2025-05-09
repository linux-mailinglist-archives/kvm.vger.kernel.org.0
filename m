Return-Path: <kvm+bounces-46044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CECF3AB0EC4
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF9207BD1B7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824A4274664;
	Fri,  9 May 2025 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8KrnQfP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B2420E01B
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782422; cv=none; b=J82MaS1EOhmw4KpyrFwS67VUdjk+utOM2QYXOYN5av04n6zBYhJfOf4EQ0MrdbNAeAzi/yEm0PjtFObnOmpO7mGF33MZqHkuq58JgTFpBZFPlil6C0+P7hpJwphWVRwL4CNCHwidhVfZzXGq/pt/NxXdxECXOnSPrAdpGY/BiOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782422; c=relaxed/simple;
	bh=kODIGmR2DLKrgzRZSqcJHoCc3hZ1D9APKKMi5uxaGGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSCMUDedf2ZMU/dZDmwqD68BYbrJjKdSouOn8WW8whAiJx4k1DUR0uJZn5cWxY+GgA+GjnUITOkwm2lYTXPT7uUfAnU9bhd1qAWRslgVWfBK8wgSJtqkxC5W31DtNKsdGQjCqrB+6u+PUEFIk4osFwSxv4cjlgWyHN2Nir3vYoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8KrnQfP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782421; x=1778318421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kODIGmR2DLKrgzRZSqcJHoCc3hZ1D9APKKMi5uxaGGw=;
  b=f8KrnQfPu8Gg+QwBQJJgExY0/guvhKgvXPkhEYr58iYVuw9epX960oT0
   7Q2/lz1AcqSRfXOVWmGuqJ/bRoZ3x7T/W+B5aCzf6kRxkQFeX3juN0R8T
   Z1nAPb7Fs2ZjKphQNQQUkDf7dVliR7MtzmEvaKjrz1LJrthLwpgsHVmwn
   iPEXnCRMz9udChCjAYBtmhTqo6cbn9DfmldI6nu/ZwnKXexIfW4G+x08P
   10EcTBLTm1kaPjVDsouoDpBX4i+JH0lSfKx2zKhj0tT3jL7O4yIV11+2t
   UygMVfJmmuFHJVx2xaJ/dS8iktuBOgDkyvCFKncdLRSX3r/dxokgN6QQW
   Q==;
X-CSE-ConnectionGUID: xWGH4IVYSMGO9OTx8DP+Ag==
X-CSE-MsgGUID: NiqIIA4oTJ2MgM/tHxMmMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59266544"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="59266544"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:20:20 -0700
X-CSE-ConnectionGUID: /P8mN7A2QES7gH0E8F4SHw==
X-CSE-MsgGUID: AnR6l5RYSY6VCvLDhE6wgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141668588"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 09 May 2025 02:20:13 -0700
Date: Fri, 9 May 2025 17:41:15 +0800
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
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [PATCH v4 23/27] hw/i386/intel_iommu: Remove
 IntelIOMMUState::buggy_eim field
Message-ID: <aB3Nuy3qFIhMNgas@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-24-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-24-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:46PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:46 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 23/27] hw/i386/intel_iommu: Remove
>  IntelIOMMUState::buggy_eim field
> X-Mailer: git-send-email 2.47.1
> 
> The IntelIOMMUState::buggy_eim boolean was only set in
> the hw_compat_2_7[] array, via the 'x-buggy-eim=true'
> property. We removed all machines using that array, lets
> remove that property, simplifying vtd_decide_config().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  include/hw/i386/intel_iommu.h | 1 -
>  hw/i386/intel_iommu.c         | 5 ++---
>  2 files changed, 2 insertions(+), 4 deletions(-)

This property has a good name :-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


