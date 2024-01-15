Return-Path: <kvm+bounces-6183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA1882D393
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 05:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1C5D1F2129C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A76D1FDC;
	Mon, 15 Jan 2024 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AN1bldyH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3367F187F
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 04:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705291423; x=1736827423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/MFU4KndePGatERa5ixuaNGOAGWr2giyESDMuy9NiZs=;
  b=AN1bldyHDefWlKtL1DKbmxGQDsnFTNqgksd+MYesw5t7SO5ccwecpHAI
   8ehHxalGUj0yc/DMGAFQC3OB+GoZ/ngsdYtfWxsLfAHpwjDii+pQdTwRY
   g37nzns9WEpUqfeLmLA2tyqCPvFDclWJHOpWLE7ISI6gIfYEZnUxiZY2n
   rN7pV0+vdrGQ4ft3HSLWmtgfcoUw1n4wRG5rrlAW3lVuSYmKOaLgPNtB8
   FVaYJdQ4glE+VHqlPglsWob+KpIJxL+btLlRwOaLLhHAn04T2SJuh504H
   mU51DghS8UM+r2I+l0+vmsiJ0nOd1FtfVovD2s93mOfHjEiXpsIXqeKPF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6624473"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6624473"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 20:03:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="25659780"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 14 Jan 2024 20:03:38 -0800
Date: Mon, 15 Jan 2024 12:16:36 +0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
 topo in CPUID[4]
Message-ID: <ZaSxpFKonLQ7hbCY@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-3-zhao1.liu@linux.intel.com>
 <f5202ebd-6bc8-44b1-b22b-f3a033e0f283@intel.com>
 <ZZ+qGfykupOEFPA2@intel.com>
 <93492d11-ca58-43b1-afeb-56fe7da4c45d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93492d11-ca58-43b1-afeb-56fe7da4c45d@intel.com>

Hi Xiaoyao,

On Mon, Jan 15, 2024 at 11:51:05AM +0800, Xiaoyao Li wrote:
> Date: Mon, 15 Jan 2024 11:51:05 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
>  topo in CPUID[4]
> 
> On 1/11/2024 4:43 PM, Zhao Liu wrote:
> > Hi Xiaoyao,
> > 
> > On Wed, Jan 10, 2024 at 05:31:28PM +0800, Xiaoyao Li wrote:
> > > Date: Wed, 10 Jan 2024 17:31:28 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
> > >   topo in CPUID[4]
> > > 
> > > On 1/8/2024 4:27 PM, Zhao Liu wrote:
> > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > > 
> > > > Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
> > > > CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
> > > > nearest power-of-2 integer.
> > > > 
> > > > The nearest power-of-2 integer can be calculated by pow2ceil() or by
> > > > using APIC ID offset (like L3 topology using 1 << die_offset [3]).
> > > > 
> > > > But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
> > > > are associated with APIC ID. For example, in linux kernel, the field
> > > > "num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID.
> > > 
> > > And for
> > > > another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
> > > > matched with actual core numbers and it's calculated by:
> > > > "(1 << (pkg_offset - core_offset)) - 1".
> > > 
> > > could you elaborate it more? what is the value of actual core numbers on
> > > Alder lake P? and what is the pkg_offset and core_offset?
> > 
> > For example, the following's the CPUID dump of an ADL-S machine:
> > 
> > CPUID.04H:
> > 
> > 0x00000004 0x00: eax=0xfc004121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000000
> > 0x00000004 0x01: eax=0xfc004122 ebx=0x01c0003f ecx=0x0000007f edx=0x00000000
> > 0x00000004 0x02: eax=0xfc01c143 ebx=0x03c0003f ecx=0x000007ff edx=0x00000000
> > 0x00000004 0x03: eax=0xfc1fc163 ebx=0x0240003f ecx=0x00009fff edx=0x00000004
> > 0x00000004 0x04: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> > 
> > 
> > CPUID.1FH:
> > 
> > 0x0000001f 0x00: eax=0x00000001 ebx=0x00000001 ecx=0x00000100 edx=0x0000004c
> > 0x0000001f 0x01: eax=0x00000007 ebx=0x00000014 ecx=0x00000201 edx=0x0000004c
> > 0x0000001f 0x02: eax=0x00000000 ebx=0x00000000 ecx=0x00000002 edx=0x0000004c
> > 
> > The CPUID.04H:EAX[bits 31:26] is 63.
> >  From CPUID.1FH.00H:EAX[bits 04:00], the core_offset is 1, and from
> > CPUID.1FH.01H:EAX[bits 04:00], the pkg_offset is 7.
> > 
> > Thus we can verify that the above equation as:
> > 
> > 1 << (0x7 - 0x1) - 1 = 63.
> > 
> > "Maximum number of addressable IDs" refers to the maximum number of IDs
> > that can be enumerated in the APIC ID's topology layout, which does not
> > necessarily correspond to the actual number of topology domains.
> > 
> 
> you still don't tell how many core numbers on Alder lake P.
> 
> I guess the number is far smaller than 64, which is not matched with (63 +
> 1)
> 

There're 8 P cores (with 2 threads per P core) + 4 E cores (with 1
thread per E core) for this machine (ADL-S).

Thus this field only shows the theoretical size of the id space and does
not reflect the actual cores numbers.

Thanks,
Zhao


