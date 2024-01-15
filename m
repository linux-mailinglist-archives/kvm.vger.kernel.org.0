Return-Path: <kvm+bounces-6248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1F682DB8E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 243E1282DA0
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 14:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F4A17BC1;
	Mon, 15 Jan 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ILsYB2zn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137DD17BBA
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705329671; x=1736865671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dYq5hCN/W92Lv1KF8iPcuma+25eA944dTTBO5eMCGgo=;
  b=ILsYB2znj0hmoxgP9bWhFnrlViPcfJPuVB0sa9VdvJJbsWodUzxdXjuE
   MVcBVfnpwUYBw1+cgi522IMUrbquHLxnaoBnnHcpwVRd37HKjMDcwnjqj
   tcgpAR9jbLxcnFQolLsNe4wrK6bXS8eeoJJXczT7bXLp7scQuwrHm5tpW
   zNHWx21quObBMDF5GgalpvBHCQ6YWnENuhAwWyC/PgAiTyK8Kl3InCO3T
   KD0BhLT+DlcMpkAspndIe1D0zwX/YsPzrFiBasJ7mxzSpSZRyufCvEYbV
   twL55vgarAtb7t9HADeNu8nh7NM/c+9xHNj/Yok+cPwAHFHTCLZlKGnYp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="403389820"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="403389820"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 06:41:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="907072525"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="907072525"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga004.jf.intel.com with ESMTP; 15 Jan 2024 06:41:05 -0800
Date: Mon, 15 Jan 2024 22:54:03 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 15/16] i386: Use offsets get NumSharingCache for
 CPUID[0x8000001D].EAX[bits 25:14]
Message-ID: <ZaVHC4WwWQAB8pRu@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-16-zhao1.liu@linux.intel.com>
 <599ddf2d-dc2e-4684-b2c2-ba6dfd886f32@intel.com>
 <ZaSrKB3y9TEJZG5T@intel.com>
 <23c5eb57-d086-4e51-bfdf-a3019aad1c29@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23c5eb57-d086-4e51-bfdf-a3019aad1c29@intel.com>

Hi Xiaoyao,

On Mon, Jan 15, 2024 at 12:27:43PM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 12:27:43 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 15/16] i386: Use offsets get NumSharingCache for
>  CPUID[0x8000001D].EAX[bits 25:14]
> 
> On 1/15/2024 11:48 AM, Zhao Liu wrote:
> > Hi Xiaoyao,
> > 
> > On Sun, Jan 14, 2024 at 10:42:41PM +0800, Xiaoyao Li wrote:
> > > Date: Sun, 14 Jan 2024 22:42:41 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH v7 15/16] i386: Use offsets get NumSharingCache for
> > >   CPUID[0x8000001D].EAX[bits 25:14]
> > > 
> > > On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > > 
> > > > The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
> > > > for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
> > > > the number of sharing threads directly.
> > > > 
> > > >   From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
> > > > means [1]:
> > > > 
> > > > The number of logical processors sharing this cache is the value of
> > > > this field incremented by 1. To determine which logical processors are
> > > > sharing a cache, determine a Share Id for each processor as follows:
> > > > 
> > > > ShareId = LocalApicId >> log2(NumSharingCache+1)
> > > > 
> > > > Logical processors with the same ShareId then share a cache. If
> > > > NumSharingCache+1 is not a power of two, round it up to the next power
> > > > of two.
> > > > 
> > > >   From the description above, the calculation of this field should be same
> > > > as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
> > > > APIC ID to calculate this field.
> > > > 
> > > > [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
> > > >        Information
> > > 
> > > this patch can be dropped because we have next patch.
> > 
> > This patch is mainly used to explicitly emphasize the change in encoding
> > way and compliance with AMD spec... I didn't tested on AMD machine, so
> > the more granular patch would make it easier for the community to review
> > and test.
> 
> then please move this patch ahead, e.g., after patch 2.
>

OK. Thanks!
-Zhao


