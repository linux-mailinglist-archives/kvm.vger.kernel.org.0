Return-Path: <kvm+bounces-46002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 973ACAB07E7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 04:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCB231890130
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30405242D9A;
	Fri,  9 May 2025 02:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YHTEaQwL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F198242D6D
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 02:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746757702; cv=none; b=nd8YHX0EFOWY8+OFFYII3IROsi0yzYwXIc/HDB7WOCafqkmrSAFcOzlk8tEIo9Io3yTugIHOar/gZyKSDF3O7YOo82AlXeN/igtAPRSvU+VgVk1aFJ1ezCyWjSwoEzyHAapjagQE+EQBmgmgXEsMJ5n8N1sSxFoWWRst2yc53Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746757702; c=relaxed/simple;
	bh=HbeDO7ZVXvOmx4YVzsa4pjo9QCbE4vkbbC4HZsiYVtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yc26HHS8EvbPlSj/kGyDdHeVihg5qb1nRbBVw0oZkjdf7nRy/16c06U66SM54E71UkbUEYp8MvKJ5luAkpFb2o4RlBVbdk0+76CEB+anLdd7Mh+7LlTFJMnvEIyvpFOwxfF4mHHWnwThZ15N2PRqSvVwBzHu6V4MjYlV+0T4eu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YHTEaQwL; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746757700; x=1778293700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HbeDO7ZVXvOmx4YVzsa4pjo9QCbE4vkbbC4HZsiYVtQ=;
  b=YHTEaQwLrXQRz6XHbn54+T0VfgKuicU/yRsNdwUgvbln5jXK4IMiQHvi
   JcLVmqEbntaH7xS1EcTnCGsYpQTdJyl48ydx+3FUphxXZM0q8L9mCLcou
   lI4KAXB2mGvnCwaKt/CSFAyW3pp8qbNopOSnnnY9RBjn5SfbGoJadMgKq
   dF26a8v07daPHrNLDKOMJWTKZLMa2s3tDUQw1YCpMPhWWvq42oDYKY84V
   mWchj/qXQIUu54BynQnxfwDtvDGGKgLX7oBgTzTb8uknBwKttq8L59Bxi
   egG+OInBh0n7LFw+9RpvwfWizg8AaHnuicAwlNjz+hwT1meP1s6+DcxTJ
   A==;
X-CSE-ConnectionGUID: ce5VFJ4TQoOnilFsI7C31w==
X-CSE-MsgGUID: bAcMQFdpROieo4hHGlGTtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="47827602"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="47827602"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 19:28:19 -0700
X-CSE-ConnectionGUID: tXMqZeFxRrOJzvCFF6Qm8A==
X-CSE-MsgGUID: wBhidVKCTveefVXArIqFKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141686752"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 08 May 2025 19:28:12 -0700
Date: Fri, 9 May 2025 10:49:14 +0800
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
Subject: Re: [PATCH v4 03/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with
 '_nodma' suffix
Message-ID: <aB1tKnGs4slN5AEi@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-4-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-4-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:26PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:26 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 03/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with
>  '_nodma' suffix
> X-Mailer: git-send-email 2.47.1
> 
> Rename fw_cfg_init_mem() as fw_cfg_init_mem_nodma()
> to distinct with the DMA version (currently named
> fw_cfg_init_mem_wide).
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/hw/nvram/fw_cfg.h | 3 ++-
>  hw/hppa/machine.c         | 2 +-
>  hw/nvram/fw_cfg.c         | 7 +++----
>  3 files changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


