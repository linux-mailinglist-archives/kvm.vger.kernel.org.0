Return-Path: <kvm+bounces-46046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34947AB0ED6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FBBC17CB71
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1CD275110;
	Fri,  9 May 2025 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDfTGuVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E551E1DEF
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782549; cv=none; b=sLg6Phe4A/Yt/Q6Vt6H5dW9M+2LDdyD8FbCEuQljJseLxM0o9z0VI85+zxfkdS/4GpGSJpP+A65bCBrdmx0t4yF9cVJfcdwfad9l5VLgJXK2Igu4AuRoA1duvpNYaEr1e0mB20+9fmKVKihZaDLyPcVf6EHyo7VY1JbZh773pJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782549; c=relaxed/simple;
	bh=pK0MRCpboYH5wkNukEQTQmvUhKc3QXbmX6Rg6q2PgnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGeg2CeQFbarlSHbuHo1euQNKYcVI9sfaCyz20Q3t8+elA6sbFqMQDNy1Hug6fb8chYgu8VjjHYIUVEXoLlDLA5rckTRS0mjktfMCX4sH4tcxINuOzbx3dtXDtj0XxSNo17oO1Q2XFCB2p79sdmj+EYhj0YHCW8xw1my8jz4e88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDfTGuVn; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782547; x=1778318547;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=pK0MRCpboYH5wkNukEQTQmvUhKc3QXbmX6Rg6q2PgnY=;
  b=DDfTGuVn5wjfStvBamCM5lwILGXUTJo0qiYvpW5BIsYLre7TYuhiZdU+
   InYKB85cLIvlR2YKRH+LXYdpmBlV4pykMgOJp+/I4pS0mXRs9QmtXftNd
   rLN2eHusTkfVsR9HnesYyKJSQGok4Uk8yWr215IsWWnQlwFT+UMpyYdyW
   K811mw8WUD6voRm1ZRWHYBw4nsfkPNJKUll8Li8yteWoR6eIw5vmF2Qe7
   TxcE1cJgRmO8Op6vxL7EVAw1e9d/SWzARRxkjKORaaBoo5f7dg+++appq
   4Z5A7YuiUVvea4lDEFr2QnyKAQhNo5QO3zeLAO8rTHcv1o9r/JalTFJ9a
   A==;
X-CSE-ConnectionGUID: oOFmRF6SQm6zbGPIvHuHmg==
X-CSE-MsgGUID: 98ygbn47S5SMzwnI46Srag==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52412005"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="52412005"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:22:26 -0700
X-CSE-ConnectionGUID: oujKs89KQHyOonwfNYOIAw==
X-CSE-MsgGUID: S11cSzFJSrWGygNDjVH6hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="137498001"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 09 May 2025 02:22:20 -0700
Date: Fri, 9 May 2025 17:43:21 +0800
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
Subject: Re: [PATCH v4 25/27] hw/virtio/virtio-pci: Remove
 VirtIOPCIProxy::ignore_backend_features field
Message-ID: <aB3OOSI/NGUARoMZ@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-26-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-26-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:48PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:48 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 25/27] hw/virtio/virtio-pci: Remove
>  VirtIOPCIProxy::ignore_backend_features field
> X-Mailer: git-send-email 2.47.1
> 
> The VirtIOPCIProxy::ignore_backend_features boolean was only set
> in the hw_compat_2_7[] array, via the 'x-ignore-backend-features=on'
> property. We removed all machines using that array, lets remove
> that property, simplify by only using the default version.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  include/hw/virtio/virtio-pci.h | 1 -
>  hw/virtio/virtio-pci.c         | 5 +----
>  2 files changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


