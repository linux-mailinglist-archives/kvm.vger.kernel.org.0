Return-Path: <kvm+bounces-45074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35771AA5D0E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 12:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2847C1BC5CB5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF66122D4E5;
	Thu,  1 May 2025 10:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FlY9hr/P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C2F224240
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746094305; cv=none; b=IEJUeVYMkuAfEc5+UspCLqXFeb/d1Pz2umZ5DfpQUrK62IOTsI8i4POsGbj+yfETbu4okrAGaLqdyMdW788JuiP+k5zgWP9NmzhYVncvGF/f76UTsmVt+1w/sc5gix7byeHhjD+9EcujwvPXBmQYvXEQ5ULk6HFu9LpuTNDX7MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746094305; c=relaxed/simple;
	bh=dxneAx6cI3IFpADOLFOssD5GBtmaUHCHg8pPx5RmHF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsSIyJvkel5bUgalwjFYR3IJQdBWoRZFlSbQBWmrm6B7yLpwt/NFkE4DHljX9KvVZL2ZzafU7NxutJJijpv0G5I8HU2iCUi8Fg3GrS09IvZiRHfXohGlEk4TWas3oq7D9ngMMavBmcsNKRHF7vzkl3EBkyPhvngriz0p3EBwdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FlY9hr/P; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746094304; x=1777630304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dxneAx6cI3IFpADOLFOssD5GBtmaUHCHg8pPx5RmHF4=;
  b=FlY9hr/PS8QBJDcumu9nrPRZEjv7cvq/FWI+Jr5m5xANBCPvcawBe7Ai
   RPwE35h3S7akl0BtDj/yfA37k3SXCXwk+A+jzn6qSxiaV6Zij5mae6+jo
   fnmRBatfBQdomFymEW3F+4Y8I0jKSQ9ard3TOlO/voYDkUCfUz8Enhw6u
   x27/LieR2sw/gWNiwmQCamAkG3dX75jXUWo7LM4MqCNNijFXU7qEGVKca
   pmzV+HmZPHUnKhfK9Gv2mxQaGUnSGT49IYuI6sJ2/Yiz12Rq3sceRBenW
   3JsML51fYvW08m1fYAKtSHy7EhRvMqWTNNZcg7gWTI8yoE4NFsi8qDmhj
   w==;
X-CSE-ConnectionGUID: Ru9Y2M9+TwyIg/lSK8Z1+g==
X-CSE-MsgGUID: Djd58ln7TMq/h2cn467NQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51586275"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="51586275"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 03:11:43 -0700
X-CSE-ConnectionGUID: 2gFzeo5SSrKfvo7agMSFBQ==
X-CSE-MsgGUID: aNItNEOWSquxVxQwR8d4zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="134875143"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 01 May 2025 03:11:40 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uAQtF-00046H-2A;
	Thu, 01 May 2025 10:11:37 +0000
Date: Thu, 1 May 2025 18:11:02 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, mst@redhat.com, jasowang@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH] vringh: use bvec_kmap_local
Message-ID: <202505011754.RqgPPZa9-lkp@intel.com>
References: <20250430140004.2724391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430140004.2724391-1-hch@lst.de>

Hi Christoph,

kernel test robot noticed the following build errors:

[auto build test ERROR on mst-vhost/linux-next]
[also build test ERROR on linus/master v6.15-rc4 next-20250430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/vringh-use-bvec_kmap_local/20250430-220531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20250430140004.2724391-1-hch%40lst.de
patch subject: [PATCH] vringh: use bvec_kmap_local
config: arm64-randconfig-003-20250501 (https://download.01.org/0day-ci/archive/20250501/202505011754.RqgPPZa9-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250501/202505011754.RqgPPZa9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505011754.RqgPPZa9-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vhost/vringh.c:1332:36: error: incompatible pointer types passing 'struct bio_vec *' to parameter of type 'struct page *' [-Werror,-Wincompatible-pointer-types]
    1332 |                 __virtio16 *to = kmap_local_page(&ivec.iov.bvec[0]);
         |                                                  ^~~~~~~~~~~~~~~~~
   include/linux/highmem.h:96:50: note: passing argument to parameter 'page' here
      96 | static inline void *kmap_local_page(struct page *page);
         |                                                  ^
   1 error generated.


vim +1332 drivers/vhost/vringh.c

  1304	
  1305	static inline int putu16_iotlb(const struct vringh *vrh,
  1306				       __virtio16 *p, u16 val)
  1307	{
  1308		struct iotlb_vec ivec;
  1309		union {
  1310			struct iovec iovec;
  1311			struct bio_vec bvec;
  1312		} iov;
  1313		__virtio16 tmp;
  1314		int ret;
  1315	
  1316		ivec.iov.iovec = &iov.iovec;
  1317		ivec.count = 1;
  1318	
  1319		/* Atomic write is needed for putu16 */
  1320		ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
  1321				      NULL, &ivec, VHOST_MAP_RO);
  1322		if (ret < 0)
  1323			return ret;
  1324	
  1325		tmp = cpu_to_vringh16(vrh, val);
  1326	
  1327		if (vrh->use_va) {
  1328			ret = __put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
  1329			if (ret)
  1330				return ret;
  1331		} else {
> 1332			__virtio16 *to = kmap_local_page(&ivec.iov.bvec[0]);
  1333	
  1334			WRITE_ONCE(*to, tmp);
  1335			kunmap_local(to);
  1336		}
  1337	
  1338		return 0;
  1339	}
  1340	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

