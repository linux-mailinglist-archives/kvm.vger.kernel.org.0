Return-Path: <kvm+bounces-10475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCD386C6DB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F16E1F22743
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4627A64CEC;
	Thu, 29 Feb 2024 10:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QpMSc+op"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B454F64CC0;
	Thu, 29 Feb 2024 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709202372; cv=none; b=rwGTgXk8hF/ehuGaNitKG6rkOR3az78WuKOsnQJx21x1Gc5+2Bc5G6BuMpnevqEjo5QGpEmW+c3s82VHOWBf+01xwbQw8ZabEskglLSf3RgVTqj0xZlI7/Oy159bBQ8ZAlNXJFjH3Yu/tIX54qbQfBTYD2YagqMysfbNW1CPjeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709202372; c=relaxed/simple;
	bh=YWOWrb13iLVWmU3eCgGMRsxQVEI8HkV4cWq2o6HncYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAcSP1yCPHuJVQbJOpZSwl9HmAq/HkCxkrOHJzfVc3rY97rvioxEVgd3KmID8coTf6V1w6e4hspCMl7UBGC9PVhH70R3Z3io3SKYLmQ0AdBjaYUvkp2FgaENpZVk9NltwQgtyFsbITNANxcod8y35r/psiCta7Q+g9DhEwsH4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QpMSc+op; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709202370; x=1740738370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YWOWrb13iLVWmU3eCgGMRsxQVEI8HkV4cWq2o6HncYE=;
  b=QpMSc+op0021pfNZpbuhiSxjWR3gcgJIfsnJbO9BtBhslYBGQI9rCLjH
   af+KjrNK6LxehkwZPUTrT0mRKah2ms75FaLIl0DRcR6KaeoJPqrxIrUu1
   OPsjQ3L9M6h6I0SMDdPZ2VjS3bSC/CN/FgcGOqUYvBOEXTz2OAVDW93m6
   3UPjrl6Kify23tWGOvjcIiWA+/SHx+4b7n1jzUWYJRD4ixyzsf1biYgmb
   1Wza6g00XqEeshKwTAAth+HAC/0VQ0TlSuKW7ryXgqDpKmNTzTbgNtLcl
   jv7ygRenf/ctDod2PcVpNoefWzlRxzGB9mqg2uq70YXbi2wZzzCkpwLgA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3518803"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3518803"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 02:26:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12348112"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 29 Feb 2024 02:26:06 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rfdbf-000Crf-1q;
	Thu, 29 Feb 2024 10:25:49 +0000
Date: Thu, 29 Feb 2024 18:24:46 +0800
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
Message-ID: <202402291828.G9c5tW50-lkp@intel.com>
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
config: i386-randconfig-012-20240229 (https://download.01.org/0day-ci/archive/20240229/202402291828.G9c5tW50-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240229/202402291828.G9c5tW50-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402291828.G9c5tW50-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vhost/net.c: In function 'vhost_net_buf_peek_len':
>> drivers/vhost/net.c:206:27: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
      struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
                              ^~~~~~~~~~~~~~~~~~~
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

