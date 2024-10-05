Return-Path: <kvm+bounces-28019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FB89917EA
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 17:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98D781C214C8
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 15:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF1D156F28;
	Sat,  5 Oct 2024 15:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOXF97Wa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A600D156228;
	Sat,  5 Oct 2024 15:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728143001; cv=none; b=Txhkc8UopU1ogFFt9YrA6bsft1XbuTvkVPZPM0YwCAJL4OQukzKCzhwp2XTeoMN/Q5I2fLlcDnEgLqhqpTqkUzJtewD+Qbv5Nz7kCHuSTtXdmRNwsFwZ2Q3yVNpcCNrBPvNVL3FQQO9Fg7CCk1fjn7pQyWSoh+ylri8+qzgItNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728143001; c=relaxed/simple;
	bh=lE5QibUYsKzAyO9poiE6OnCcKvzWQz2/KHWAeEPn714=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=my8UTNQ+wlbrb6VTI0KPK9Otjo+OglrpDP6sP5z4SBNE8k5gI2KtDl3dKyTaxrouBj32Wm+6dNesTsktoE9e+oPw1u4ZiHFdc8rgEE0PLTV23pIBDOXEy2RHWGzfx1dXc54VAxoL7B+oexXr35WdTneUTv6NIVG+QgvQXgHDrsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOXF97Wa; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728143000; x=1759679000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lE5QibUYsKzAyO9poiE6OnCcKvzWQz2/KHWAeEPn714=;
  b=kOXF97WaJP2KDFZeGOQgOZxiKWXFz7VRH3VN8fY2x0lRtA/Bp2qazd/d
   tYLdtTPf+x2dUSw02bhnnwnfq0QGFv1d/sYr7ttz5wu0G45tJvcCX/9YG
   2r7El+w4dXaMrNyB1bkLkPvTtQMp5gmLoCxgpd3W1DjHME2DRl6aCKt6N
   dNIKjj5kjWyJrmyAzV8lguC4mbDcky3+8o3+WUQjbeH2c7kcOxd/qhRXM
   OEAvx3SvlqqpHWSzkEjIDNRBeuQWrvN93ATIv1/1z304N0fHa+JaehXhb
   ONsKkkYXexuH0ney5AJOE2kWHhMcjhl+pQlB5NjofLPL6kcUjxf5SpRmM
   A==;
X-CSE-ConnectionGUID: a12J9uIXRiKPQ440aFkhPg==
X-CSE-MsgGUID: prFhEFOoQ8G5j9twJHJN7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11216"; a="31050211"
X-IronPort-AV: E=Sophos;i="6.11,180,1725346800"; 
   d="scan'208";a="31050211"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2024 08:43:20 -0700
X-CSE-ConnectionGUID: rfvIPsBNStO9nylfdgJL9w==
X-CSE-MsgGUID: 9GUcaUHKTuio/s9HEg3f8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,180,1725346800"; 
   d="scan'208";a="79772874"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 05 Oct 2024 08:43:14 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sx6w3-00034g-1e;
	Sat, 05 Oct 2024 15:43:11 +0000
Date: Sat, 5 Oct 2024 23:42:49 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Sami Mujawar <sami.mujawar@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Message-ID: <202410052337.YQFmvTFu-lkp@intel.com>
References: <20241004144307.66199-11-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004144307.66199-11-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on linus/master v6.12-rc1 next-20241004]
[cannot apply to efi/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/arm64-rsi-Add-RSI-definitions/20241004-225034
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20241004144307.66199-11-steven.price%40arm.com
patch subject: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for realms
config: arm64-randconfig-004-20241005 (https://download.01.org/0day-ci/archive/20241005/202410052337.YQFmvTFu-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241005/202410052337.YQFmvTFu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410052337.YQFmvTFu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/virt/coco/arm-cca-guest/arm-cca-guest.c:27: warning: Excess struct member 'len' description in 'arm_cca_token_info'


vim +27 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

    15	
    16	/**
    17	 * struct arm_cca_token_info - a descriptor for the token buffer.
    18	 * @granule:	PA of the page to which the token will be written
    19	 * @offset:	Offset within granule to start of buffer in bytes
    20	 * @len:	Number of bytes of token data that was retrieved
    21	 * @result:	result of rsi_attestation_token_continue operation
    22	 */
    23	struct arm_cca_token_info {
    24		phys_addr_t     granule;
    25		unsigned long   offset;
    26		int             result;
  > 27	};
    28	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

