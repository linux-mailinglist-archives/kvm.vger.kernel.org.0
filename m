Return-Path: <kvm+bounces-6207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB5982D57E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2410AB21282
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A95F9D7;
	Mon, 15 Jan 2024 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjR9PC2Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48F4F9C2
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 09:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705309439; x=1736845439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HyJu5yarjkyKHlLX2cZ2bsFPyxagMaNvDegqFE9ermc=;
  b=KjR9PC2Qe9rXKgOXPfIyqLtgPj3yCeKq2ZmKVR0SeIqh2bNaiZG7zch8
   UVbdVXd1H5KRpyHK0a4fyTuzpY8Zc7PuW7dXBnszZy6bw87p8RhCqzr/Q
   awR16wV2cj21Q37iR/SYyFd8IGYqRwNFiia/HlQUNIm33rxDB4l5u1aLh
   UrsCArjFWdMzY1QK5p0+MSUVD1es9/SZuLKItDHJipEL+9juHjNey+WXg
   N5CCceHp+pz8MU8ggsKdbQuUFQLm9uSj5HpPiW2M5hb+oTxPFtyT5k+P2
   CN56/+n/3seyWSZ4zvwrOvoqvZJ+2buAk5ji7k7ao+Obnwmz48J7YrN74
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="485730001"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="485730001"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 01:03:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="927062702"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="927062702"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jan 2024 01:03:54 -0800
Date: Mon, 15 Jan 2024 17:03:53 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
Message-ID: <20240115090353.cgcjwwwuwvcxiuvd@yy-desk-7060>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
 <20240115052022.xbv6exhm4af7kai7@yy-desk-7060>
 <ZaTOpCFZRu6/py/J@intel.com>
 <20240115065730.ezwpd3sjoycc57rm@yy-desk-7060>
 <ZaTcxVGHhQtLC/Ki@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaTcxVGHhQtLC/Ki@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 15, 2024 at 03:20:37PM +0800, Zhao Liu wrote:
> On Mon, Jan 15, 2024 at 02:57:30PM +0800, Yuan Yao wrote:
> > Date: Mon, 15 Jan 2024 14:57:30 +0800
> > From: Yuan Yao <yuan.yao@linux.intel.com>
> > Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> >
> > On Mon, Jan 15, 2024 at 02:20:20PM +0800, Zhao Liu wrote:
> > > On Mon, Jan 15, 2024 at 01:20:22PM +0800, Yuan Yao wrote:
> > > > Date: Mon, 15 Jan 2024 13:20:22 +0800
> > > > From: Yuan Yao <yuan.yao@linux.intel.com>
> > > > Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> > > >
> > > > Ah, so my understanding is incorrect on this.
> > > >
> > > > I tried on one raptor lake i5-i335U, which also hybrid soc but doesn't have
> > > > module level, in this case 0x1f and 0xb have same values in core/lp level.
> > >
> > > Some socs have modules/dies but they don't expose them in 0x1f.
> >
> > Here they don't expose because from hardware level they can't or possible
> > software level configuration (i.e. disable some cores in bios) ?
> >
>
> This leaf is decided at hardware level. Whether or not which levels are exposed
> sometimes depends if there is the topology-related feature, but there is no clear
> rule (just as in the ADL family neither ADL-S/P exposes modules, while ADL-N
> exposes modules).

I see, thanks for your information!

>
> Regards,
> Zhao
>

