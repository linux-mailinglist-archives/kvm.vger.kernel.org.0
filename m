Return-Path: <kvm+bounces-11418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 449E3876E30
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 414C21F21218
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98297A921;
	Sat,  9 Mar 2024 00:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Akg1Hto9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE8115C3
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 00:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709944579; cv=none; b=pet1IPGJJnl2NJ6nk9tmIliNr51OwzVAlBIz9dqGFD1QRjmOQDcFDXTZnHrF75iE1DcOR59gd/PSO6P0nT7HEN8a1doHanaJfW/gBjiAYXE1VTP+daiIOYup0lJcm3kuuQ2cvah54+ZGBkqCeIjB0Hr3h5eYpfjQdScGx9+I5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709944579; c=relaxed/simple;
	bh=o7XYyBJ/wWxSY6FlKq2b4YXRb7dNIrJaoqiuXaqbcG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqBAEmVk0vUkgoPPDJf9M9P+eAaAk/3E8VGu2p2Yuf66LV2J42XWX03or9mhJ8T62F3esnTcFXVDX1TtiKQvTRTuHa83i6ZHS74ecv03jLO6sqcUGukgF78x9l2ueGuGOYg3bK/e6nXTrKuE6hBSKTtdZcTtW3unLsBVbmPd8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Akg1Hto9; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709944578; x=1741480578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o7XYyBJ/wWxSY6FlKq2b4YXRb7dNIrJaoqiuXaqbcG8=;
  b=Akg1Hto9DSdBlparcHb0jk9gMGKM703VBBB1PqP6oFVkJgpnV09Mylui
   7aYA51WKpUn+fCkCO6mVkO3Klh5pCY4/rkYGrOz8MSPL7lvbKBUohJInU
   BvZdeQwXnxhg77wlenOGY6t/frG+Y78VfGf3P3S/KhR0gN45eQcHqBYvL
   6rn11to9MyrgRvl7YlnjJCIydZYSng0Og1Y0ycmkdcNbRccBbzquYq8Ja
   3wS3/asyrNxUqVP5oE3VzWTehTYw2eubvfNX/o8qJbHctBILTuXecOm4A
   3kfo+DvZn5a6v7+dIltWt1F6l64L5R74zxrSJIjCxBHVtxceEpUPBCXng
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="4534406"
X-IronPort-AV: E=Sophos;i="6.07,111,1708416000"; 
   d="scan'208";a="4534406"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 16:36:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,111,1708416000"; 
   d="scan'208";a="15214569"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 08 Mar 2024 16:36:12 -0800
Date: Sat, 9 Mar 2024 08:49:59 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Message-ID: <ZeuyN8Eacq1Twsvg@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <17444096-9602-43e1-9042-2a7ce02b5e79@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17444096-9602-43e1-9042-2a7ce02b5e79@linaro.org>

On Fri, Mar 08, 2024 at 05:36:38PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Fri, 8 Mar 2024 17:36:38 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
> 
> On 27/2/24 11:32, Zhao Liu wrote:
> 
> > ---
> > Zhao Liu (20):
> >    hw/core/machine: Introduce the module as a CPU topology level
> >    hw/core/machine: Support modules in -smp
> >    hw/core: Introduce module-id as the topology subindex
> >    hw/core: Support module-id in numa configuration
> 
> Patches 1-4 queued, thanks!

Thanks Philippe!


