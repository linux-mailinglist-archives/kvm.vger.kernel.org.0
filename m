Return-Path: <kvm+bounces-15915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C4B8B2259
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8D7A1C20F93
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B5C149C4F;
	Thu, 25 Apr 2024 13:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJHabgTx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75DA1494B4
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714050972; cv=none; b=TAskce6zl+Jtam80fMVX4A+n8FiCPHEYXZEUBTPoYazhF2EcJLcTauNbI2PbuWYWHDzM56bHSKFzxgtRzG+LjFAOolHIn2N1QomUvNo9B0sfKiF+LoBrBnMdJgBIA9QC1q0V7Z2LNv/ia6LpEj+jfScUgm/CAg/SFrSRz0ZS0GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714050972; c=relaxed/simple;
	bh=A7f0OsES/K/K9v4IClIZ7cqsYibhqcI2JSwwGXJ6xNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWoi6dogdz14DnWMKeR9ktXNJE5WxoqagCBnWxDKbmdZ7rxJd3sTaWM4dn3HGNl+nYw/E8Xrhy4s5ZU8I7ZPC21dLdLFEL+LOfnfxLxHhbDPZkXOqtGOkMIRBokboerJReqYfAAfqxQRA+qx4IPdzWHy+Aeng6RBbQ6gry3UybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJHabgTx; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714050970; x=1745586970;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=A7f0OsES/K/K9v4IClIZ7cqsYibhqcI2JSwwGXJ6xNw=;
  b=lJHabgTxovAshpT1NnDmiMjuM9m1drNxdTJjN0V62aGW35ye2cXHo1jL
   fVlb1QiX7fU9Pi40oTao7svfluXDrCs0Z967xmQYwjrZ/TaTKmqcAl5bp
   ctWwnfhhbhxhtfMYZ/w7UDNhaClW/3Cmj2yNOn80BBt7jbx8JcdNfKzwd
   oBRJbmskJGeQLQ+DTzcjPli33Xbe3vMESrVnch5qrEdPLDBsEWBeJnpQ/
   2bJ/PfpOgi7T/U3dlk9uCOYP0u4ZQTY/jhDHtvdmEmr0OYBClWuX1C4MZ
   Yyrrw1CjaRb5ErXlE8dVwmP2guZs1rRiu9ui8oA+KkbnUS1LKaUgjspog
   Q==;
X-CSE-ConnectionGUID: TYblhQjsRBmyMGBr+Ir/LQ==
X-CSE-MsgGUID: J9c2jd/6SFCchbWeobRZgQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="20348992"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="20348992"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 06:16:09 -0700
X-CSE-ConnectionGUID: fguQEXsaRAWXjkNkDjn9yA==
X-CSE-MsgGUID: OLHVs+TySlWYQflJ8I97Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25017696"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 25 Apr 2024 06:16:05 -0700
Date: Thu, 25 Apr 2024 21:30:11 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v11 00/21] i386: Introduce smp.modules and clean up cache
 topology
Message-ID: <Zipa4+Hc3WS51sGB@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
 <a76a987f-3ea2-4c48-bc02-74ab42fd3c01@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a76a987f-3ea2-4c48-bc02-74ab42fd3c01@linaro.org>

On Thu, Apr 25, 2024 at 10:06:11AM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu, 25 Apr 2024 10:06:11 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v11 00/21] i386: Introduce smp.modules and clean up
>  cache topology
> 
> Hi Zhao,
> 
> On 24/4/24 17:49, Zhao Liu wrote:
> 
> > ---
> > Zhao Liu (20):
> >    hw/core/machine: Introduce the module as a CPU topology level
> >    hw/core/machine: Support modules in -smp
> >    hw/core: Introduce module-id as the topology subindex
> >    hw/core: Support module-id in numa configuration
> 
> To reduce this series size, I'm taking these 4 patches to via
> my hw-misc tree.
>

Thanks Philippe! Will add module level test in tests/unit/test-smp-parse.c.

Regards,
Zhao


