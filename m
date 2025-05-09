Return-Path: <kvm+bounces-46036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCB8AB0E4D
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA8D9E3148
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D71427511F;
	Fri,  9 May 2025 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPPwu0oZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36008201266
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746781833; cv=none; b=M6rC6T5ALU0mbZew2wGFFfqjobSCN4/aDcIIf1xAh8VxIou8Y6x0TuDkcvKLjriJKgIBM+i5snT/wSvE0YoFdTY/DHCPKnuQ4eKLGCNT1v8Vae6xyVMSG6X0MrimAtvZGs5aj4hyk3AyhhpoiIRUmGl1AEPo0PlZ5FHnHHZzwGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746781833; c=relaxed/simple;
	bh=OJ/sh/VtJoFNwUXpYSmxCGdbslcUwkfuu8I5VXJHUnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MP4P+4CPSsS9McA2HrgCLxTwm8+NypGK6WMZN1E5CZxHUo2IAfORp2nGUOM9Ou8CQ5/n/8xkfSaBy71LeModHNPcA2RSEFmUCRSrn7lPpPVHXvXxW6lUwCoVxxsEUuc2t0tI1eiocPvx80qt5mWTkHBOsvarIijbkQ7J+cyfL5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPPwu0oZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746781832; x=1778317832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OJ/sh/VtJoFNwUXpYSmxCGdbslcUwkfuu8I5VXJHUnM=;
  b=EPPwu0oZTvspSvU2PsYKlE6JKcxTAXUpV1cu61Q934sQh0ERuzFXXTVB
   2bdX/unw6UwVT/bbb3vkkdzV7WioYCb9kOoBN2S2MBtKGDQM77dHDq1/2
   wQfJMJDPT+cOTtEaqVjPDbrmKYspydPxnrMIN8m4wK/txerfMCplxd3Gk
   2Tu/AvVAmSakhj+RPWgDN/pMFCZP/gyi1UH5q0KYQazy1CSjkijKZrXWs
   XHJtLgQnTb2l2MVHBKT+eGWZQybrvvvHNGgIQ4v6gFjoIybEzrCM8AOW+
   HNHxaCBGO/UzFC5vsFrm1TSYB9HbbQXVDnyiOHRjwt+kn0rafhSDErNXf
   A==;
X-CSE-ConnectionGUID: fpL0OAfQTdyQkqq9S3YmeQ==
X-CSE-MsgGUID: UwLYwknvR2eRMdBmjZGt8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48757935"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48757935"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:10:31 -0700
X-CSE-ConnectionGUID: krxuoSxmQbWwFC7YTaR4ng==
X-CSE-MsgGUID: iKwOz92dRZmPDyuOT9YhGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136448402"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 09 May 2025 02:10:24 -0700
Date: Fri, 9 May 2025 17:31:26 +0800
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
Subject: Re: [PATCH v4 15/27] hw/core/machine: Remove hw_compat_2_6[] array
Message-ID: <aB3Lbk88E+YzKsWc@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-16-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-16-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:38PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:38 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 15/27] hw/core/machine: Remove hw_compat_2_6[] array
> X-Mailer: git-send-email 2.47.1
> 
> The hw_compat_2_6[] array was only used by the pc-q35-2.6 and
> pc-i440fx-2.6 machines, which got removed. Remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/hw/boards.h | 3 ---
>  hw/core/machine.c   | 8 --------
>  2 files changed, 11 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


