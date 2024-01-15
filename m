Return-Path: <kvm+bounces-6192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7142982D414
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96E111C21099
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C226105;
	Mon, 15 Jan 2024 06:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kWb8WPx8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CD35380
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 06:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705298847; x=1736834847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yO6y4061mOMOBuAjTQimWEv3SWvQ0lvROuG9u3xeD1w=;
  b=kWb8WPx8tBYYaJMHj3La8Wgmixa9tYYtT9ldmCT9E2jUqXxy1be+BRqo
   etCF8yDU1F/Qt3Igvt8WmB/9JeYqbmlyHXIVYdl/ekVSRP3i6+szpueA6
   GW+LLxW0c3+Hrai7H/xLMQ1Z8TbAHBPPEHnBaroiXNCLRKKDOJb3RCdF4
   TZNImMn557wy0K0RR13GF/k9cXXHnlr4AzCqpP9nm7u8OcdA7gn2fF0UA
   8dWdF/GnMwDWfnm+Dfa5hYZVZbQ7FuInaKGJ2ffkK150wqaq6sHZ1r5lH
   hRIHYsV6ENSAI73iSI6L0+L1/uFwg7691MLiNv6GddD0jwYQwbSD5f3er
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="485701523"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="485701523"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 22:07:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="853898393"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="853898393"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jan 2024 22:07:22 -0800
Date: Mon, 15 Jan 2024 14:20:20 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
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
Message-ID: <ZaTOpCFZRu6/py/J@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-9-zhao1.liu@linux.intel.com>
 <20240115032524.44q5ygb25ieut44c@yy-desk-7060>
 <ZaSv51/5Eokkv5Rr@intel.com>
 <336a4816-966d-42b0-b34b-47be3e41446d@intel.com>
 <20240115052022.xbv6exhm4af7kai7@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115052022.xbv6exhm4af7kai7@yy-desk-7060>

On Mon, Jan 15, 2024 at 01:20:22PM +0800, Yuan Yao wrote:
> Date: Mon, 15 Jan 2024 13:20:22 +0800
> From: Yuan Yao <yuan.yao@linux.intel.com>
> Subject: Re: [PATCH v7 08/16] i386: Expose module level in CPUID[0x1F]
> 
> Ah, so my understanding is incorrect on this.
> 
> I tried on one raptor lake i5-i335U, which also hybrid soc but doesn't have
> module level, in this case 0x1f and 0xb have same values in core/lp level.

Some socs have modules/dies but they don't expose them in 0x1f.

If the soc only expose thread/core levels in 0x1f, then its 0x1f is same
as 0x0b. Otherwise, it will have more subleaves and different
values.

Thanks,
Zhao


