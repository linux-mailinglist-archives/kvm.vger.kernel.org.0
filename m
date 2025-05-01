Return-Path: <kvm+bounces-45079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36975AA5D92
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F733BF3AC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 11:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4262222DB;
	Thu,  1 May 2025 11:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gFazGlYA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D2801
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 11:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097503; cv=none; b=DKRqYYjM9sz7t0wgdG7P2EhIxfrQBBfCL6oM6CFHPW+ZfKp85ctLQz085OPAsCYjg1JnTrKUHjtQe8XyRs11QWeZmPXJ6qgf7Rp6/o++EIVhSWhQTSnEa38kEL0wC0jucnqDx2rVcI6tKPc14etbFm1GuyjmTKxdI6UDXbi3qQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097503; c=relaxed/simple;
	bh=PC0vtiX0GT1uwQT6asx3Blf1TqWaPL5MDGahxMgwRGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9fJjRI1n+injbMz2kMLo3PGmlg7b+L/ckHr/twH92C1lajdGrdckG3UNmnr8Xx7nVxveh83CQk+tXiRqeyk4DtfNztLAjQSoNaagvBKZWujQlH2spgZi7rmre+4vuFkD4TQCvcziyuCm5TsfGhsXYlhoveL06hTAEQQpDAyKKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gFazGlYA; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746097501; x=1777633501;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PC0vtiX0GT1uwQT6asx3Blf1TqWaPL5MDGahxMgwRGY=;
  b=gFazGlYAs2bMATA/Cz4aeE5/gUtfkvdV/qK27k5P2FVWPJoi0H8eKMaA
   TEsroy5UWk0F5Mfg30z6GP5cdnH15pADBGVqL1pKw/LBpp0VXcwnZB0eY
   AHLFDnu6oEJ6ZVGDVebiAkpOABYS2Tw1QPmmygStCdTPv6dQ0XZQ6a0je
   omMuWXeUX1RNGvDIc0Ps0/PW1RYkEROOmBGktMYjLKIT8EUxWAc+tf6Ep
   qdkT8uGKYjsTkY4cd+rOBABSAzDW7wUsO+lsoatxJTQHL16HsSqfz05QV
   tYruviJBI77ye9ovn95Eyk5wBH5eZWo6DqctnXSBM0U+8RhV1kGX8L9+5
   Q==;
X-CSE-ConnectionGUID: Io82LgyKRyuiHTvvq3BsXQ==
X-CSE-MsgGUID: 7cOIdelEQQu2MusQQwJ3jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="46878739"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="46878739"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 04:05:00 -0700
X-CSE-ConnectionGUID: 2yq+2HkeT1ePwddbLQ4SCQ==
X-CSE-MsgGUID: fMCX0tuUQ1+73EH9Ndbllg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="135325506"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 01 May 2025 04:04:58 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uARiq-00047N-0B;
	Thu, 01 May 2025 11:04:56 +0000
Date: Thu, 1 May 2025 19:04:53 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, mst@redhat.com, jasowang@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH] vringh: use bvec_kmap_local
Message-ID: <202505011849.E2H9cM7C-lkp@intel.com>
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
config: arm64-randconfig-002-20250501 (https://download.01.org/0day-ci/archive/20250501/202505011849.E2H9cM7C-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250501/202505011849.E2H9cM7C-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505011849.E2H9cM7C-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vhost/vringh.c: In function 'putu16_iotlb':
>> drivers/vhost/vringh.c:1332:36: error: passing argument 1 of 'kmap_local_page' from incompatible pointer type [-Werror=incompatible-pointer-types]
      __virtio16 *to = kmap_local_page(&ivec.iov.bvec[0]);
                                       ^
   In file included from include/linux/highmem.h:14:0,
                    from include/linux/bvec.h:10,
                    from drivers/vhost/vringh.c:17:
   include/linux/highmem-internal.h:178:21: note: expected 'struct page *' but argument is of type 'struct bio_vec *'
    static inline void *kmap_local_page(struct page *page)
                        ^~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/kmap_local_page +1332 drivers/vhost/vringh.c

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

