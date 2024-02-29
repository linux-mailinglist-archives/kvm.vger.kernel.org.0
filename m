Return-Path: <kvm+bounces-10515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 872E786CD5C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 403BB1F23EEE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959FC7E572;
	Thu, 29 Feb 2024 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nf5pJAlJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333514A0B7;
	Thu, 29 Feb 2024 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221594; cv=none; b=AiqX+7gwW8Ugf4uoY6pAdTjJcCuu4vrs/Eh1pi54jdhzy3zQXDKlizvHmBXs3gr2Mjz4Okpk9X1Swon0PUFD1b8jm5rk20o32cvDNHdT7DkcvQWmEV8UfoB0/la91qWKvCnUFurUJXz31oiAQ4T0bQehkBQc62rLzkUmLWj1+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221594; c=relaxed/simple;
	bh=lczR1LgOcbUQlGy40uUgvgOpZit1cKPUO/BBWojFrb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYdJJZbxuXjEvpoJyAGKapLyYZ1BVPIjOexp8DyEWC25F65mGkUKQTt/XhyzV+fubhn/ff+T8+JVxw53j2CDZd3sy7ShVkqkD0qcGync5gKrlyb8hc6xb6vJo9Z+zBiQp1wX+QouLOc34gTnehSYe+n287fEDAXKP2cXAlFSc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nf5pJAlJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709221594; x=1740757594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lczR1LgOcbUQlGy40uUgvgOpZit1cKPUO/BBWojFrb8=;
  b=Nf5pJAlJ9CgYm0AEvc5pgsgqNFZlyld1kKycPaBIYewETdroyvPtSRym
   QBBIaCmgQAKKXUF9ggeBNyT09MMVG6JfU/Ry6wqtIcnkGl7q/m6HKDlls
   kOOarKMLBZnMkRc/RPTV8+jiwseFlmBLBHSRYIumnUA9HRKil17V+HYbZ
   VRGffshJsrZ5vw1sdNQHIs6oWTtXHajJWYRHJ2hFR2NOa7e3is77Fy8ek
   vi1Lj0XQqcHMrtFC/MRcv62jDBLPwBJiDijLjfMr7wReZNrZSjHpiGB8+
   YXjG+c/87yrjNAjzl46Y/R4VoR3rGDCGWEnYZzrbHKq5nrKc0g4LB5p5k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3623091"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3623091"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 07:46:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7770452"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 29 Feb 2024 07:46:29 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rfic6-000D2f-14;
	Thu, 29 Feb 2024 15:46:26 +0000
Date: Thu, 29 Feb 2024 23:44:54 +0800
From: kernel test robot <lkp@intel.com>
To: Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com,
	willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	kuba@kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
	davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	xudingke@huawei.com, liwei395@huawei.com,
	Yunjian Wang <wangyunjian@huawei.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Message-ID: <202402292345.a49gfJLj-lkp@intel.com>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>

Hi Yunjian,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunjian-Wang/xsk-Remove-non-zero-dma_page-check-in-xp_assign_dev/20240228-190840
base:   net-next/main
patch link:    https://lore.kernel.org/r/1709118356-133960-1-git-send-email-wangyunjian%40huawei.com
patch subject: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
config: microblaze-randconfig-r131-20240229 (https://download.01.org/0day-ci/archive/20240229/202402292345.a49gfJLj-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240229/202402292345.a49gfJLj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402292345.a49gfJLj-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vhost/net.c: In function 'vhost_net_buf_peek_len':
>> drivers/vhost/net.c:206:41: error: initialization of 'struct xdp_desc *' from incompatible pointer type 'struct xdp_frame *' [-Werror=incompatible-pointer-types]
     206 |                 struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
         |                                         ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +206 drivers/vhost/net.c

   198	
   199	static int vhost_net_buf_peek_len(void *ptr)
   200	{
   201		if (tun_is_xdp_frame(ptr)) {
   202			struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
   203	
   204			return xdpf->len;
   205		} else if (tun_is_xdp_desc_frame(ptr)) {
 > 206			struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
   207	
   208			return desc->len;
   209		}
   210	
   211		return __skb_array_len_with_tag(ptr);
   212	}
   213	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

