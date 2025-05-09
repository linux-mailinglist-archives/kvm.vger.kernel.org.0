Return-Path: <kvm+bounces-46043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B134AB0EC8
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E12D63B82F6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98389275106;
	Fri,  9 May 2025 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMk2ShAW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9802747B
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782282; cv=none; b=YknxQYTSEdiNZBXMkhUqbhrH8tMvhxrQi5FrZ4t3p1HKo4hUuMblIlZReJGyeSDibf0+FPqvBhVjYxPTI8iEN3SJJhwNZuNTGGJD77GyoYuosKMCxpLxeV00XQCUw5MdCAcOAwOTusAXtqupqE+RI6QWQmVEur380krxm3WPjEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782282; c=relaxed/simple;
	bh=h0jLMVr4wHnyYCY84J6GlAtgPWQ/rDP7k9g6E5hEDYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYOYHv23+B4omoEw3xNyde0gdWyUhjiAXS7O/u3nvipS6aisp0qwocj4YraSaLl+E4b5nAlvxlE4lG6rcceKkAg7OzbXqthjHWk30JJFD3fJ0gFgOMcyHdKW1Xe+GKl6rFsdCiMNIlk0iK115OXt8m15Bmt0+HQ4AjhIBWtSLKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMk2ShAW; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782281; x=1778318281;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=h0jLMVr4wHnyYCY84J6GlAtgPWQ/rDP7k9g6E5hEDYQ=;
  b=KMk2ShAWGk3lLyWCtlqW7Cm4/G9DFOGDat9WriAn+Xj3Bu/BK7l4jv/m
   wQWgnQpQkqrEMJzP+dk8PBJpLoaQMxFpsVNNeoxnW3SS1/AYaI69jhc9p
   agURGFsBru3pWPEYS0fiPO7N+FwkLaHXlbVQMJQOjysJcQMU3I4Tjb91b
   I9UPtSeJ60Y574FWCOUs+A7cyXP/EHJOrECbtTmgApE4dmLVNSdAkXLPG
   0XTKjD2ltCUMHNk/RybACzgpUojgLU9hIx4PDj0IbWCH84vVDuFuo1Gr6
   DJlj8BkDh5CrK9ANP43CxbBFW3Z6KUBjsKWtEr3ZyYWm6qwYW2vq7yegP
   g==;
X-CSE-ConnectionGUID: vm94ruMtRX+r8djm9GcUow==
X-CSE-MsgGUID: Bp0G48lrT3ay/+KAazZ9lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66135980"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="66135980"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:18:01 -0700
X-CSE-ConnectionGUID: PtU105OcSpyexIUEeJfEMQ==
X-CSE-MsgGUID: PXGVHxs5RDmF6e6hkLHUeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="167496453"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 09 May 2025 02:17:54 -0700
Date: Fri, 9 May 2025 17:38:55 +0800
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
Subject: Re: [PATCH v4 22/27] hw/core/machine: Remove hw_compat_2_7[] array
Message-ID: <aB3NL4k1baV0k6iu@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-23-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-23-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:45PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:45 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 22/27] hw/core/machine: Remove hw_compat_2_7[] array
> X-Mailer: git-send-email 2.47.1
> 
> The hw_compat_2_7[] array was only used by the pc-q35-2.7 and
> pc-i440fx-2.7 machines, which got removed. Remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  include/hw/boards.h | 3 ---
>  hw/core/machine.c   | 9 ---------
>  2 files changed, 12 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


