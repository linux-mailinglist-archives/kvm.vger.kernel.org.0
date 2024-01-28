Return-Path: <kvm+bounces-7283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA46183F4BB
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 10:06:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AD3CB21D48
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 09:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B47D1AACD;
	Sun, 28 Jan 2024 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AkcVwVM1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49514DDC5;
	Sun, 28 Jan 2024 09:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706432788; cv=none; b=rhtDs29gqZB31MmnwU1BDxzjR8eiDf+CpiFm/hCV+kAIVf0UXxUUAjvS2dKWhiaoU0L0o7dKlurbNOIXVYsa6KglvFxarD6OdEsSVkAa4tPo2ksT18rBwi5ziT5OyCU+i7vHLh7UO0YRsBHapE/6tZDwel+LgE92UJqJfmQPC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706432788; c=relaxed/simple;
	bh=YAWRcL+76J78dm5IBZqJe3yaGnvEhoK8TSf93uvaj/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N43hBWKWi1ap+qDTK4gUxTkVOOTLMMlOeq0baYxgURen/s0sIRrMsq9WkZdn4naQURyOHLo4bRrKQFxuBqLSgSN284ZbE/LNfFQv0JjBin3zuRakFoUqa0+0Y17gHIlGjEhPEpsnhLXBl1hVwPDU13n4u78N2EGFzkTVwLFGj4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AkcVwVM1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706432787; x=1737968787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YAWRcL+76J78dm5IBZqJe3yaGnvEhoK8TSf93uvaj/A=;
  b=AkcVwVM1IYf3lI5/vc76QUXOtxGOjEAURemyEqjZEKgtBkBowosAVzqG
   +tV41u6q8VowpPpl2LC2G+kDJeETBqm/i4Bzi/eNf1dI/lTu6hpF4z3dq
   lfDdh/hCF0U+ZgbtrSkJvNS4Dw0guDW1Oh+kdeEVey4cD2H+ewTL3gQBq
   /vLOnoKNFFD1fkvO6BWeIUnlPEOQoxh+PY/SBMFvoDMIJW5O0ZBBuzpFp
   6wD4kLDq0WracxC9UcqINq1/bDhiEYFkhoJ3GoqZ6fhByf34JTvkVDmT8
   pVGxa1TpuH6BOBH+JLhCE45Bi3vOjYY4wrxgtVqSuKsnoUaGosUXb88TP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="10139148"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="10139148"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 01:06:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="3016775"
Received: from lkp-server01.sh.intel.com (HELO 370188f8dc87) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Jan 2024 01:06:22 -0800
Received: from kbuild by 370188f8dc87 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rU17L-0003GS-1R;
	Sun, 28 Jan 2024 09:06:19 +0000
Date: Sun, 28 Jan 2024 17:05:26 +0800
From: kernel test robot <lkp@intel.com>
To: Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com,
	willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, xudingke@huawei.com,
	Yunjian Wang <wangyunjian@huawei.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
Message-ID: <202401281639.yBaJZ4Sh-lkp@intel.com>
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>

Hi Yunjian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunjian-Wang/xsk-Remove-non-zero-dma_page-check-in-xp_assign_dev/20240124-174011
base:   net-next/main
patch link:    https://lore.kernel.org/r/1706089075-16084-1-git-send-email-wangyunjian%40huawei.com
patch subject: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
config: s390-defconfig (https://download.01.org/0day-ci/archive/20240128/202401281639.yBaJZ4Sh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240128/202401281639.yBaJZ4Sh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401281639.yBaJZ4Sh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/tun.c:1298:5: warning: no previous prototype for 'tun_xsk_pool_setup' [-Wmissing-prototypes]
    1298 | int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *pool,
         |     ^~~~~~~~~~~~~~~~~~


vim +/tun_xsk_pool_setup +1298 drivers/net/tun.c

  1297	
> 1298	int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *pool,
  1299			       u16 qid)
  1300	{
  1301		return pool ? tun_xsk_pool_enable(dev, pool, qid) :
  1302			tun_xsk_pool_disable(dev, qid);
  1303	}
  1304	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

