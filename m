Return-Path: <kvm+bounces-17265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FEB8C3499
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 00:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A2181F21BF9
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 22:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB0E3FB0F;
	Sat, 11 May 2024 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aulYneye"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFDD17BA8;
	Sat, 11 May 2024 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715468192; cv=none; b=KM+i6AsRzm2BSiSz0ywbpS0QmDC/Rrk1N/eCUE5Y0cB82Eo4r8oy8g7sPmFQks4TJPdaJPmLf1Sn26GTN5UY2SqM1hy0AYJDV56+oS0tTmAcdpFmDRJU6H6XOgUkp2xpl6InCzIE/mEELDfz0otKBxMCoEzcaNCJ/wVo7OUghmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715468192; c=relaxed/simple;
	bh=M2lNWYotTn+V6B62NM9AJg/hLTmfkjAe5ZJGudVrO6s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mijZHRq57FOj3/d5pWDTQwqOx5HxiUlnN0b3+ITA5UzAtPK35D/wdyAADVw28z3eIEW+ZByMRnxIBs9c21870AoZ+E62VhzSQprq7MgjRRSRVvz0TA2MkR3BJNuk48iZZF3yvyvNB3EkybdmGbpjCAvKc9trqxmJiAxn6M3aCVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aulYneye; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715468191; x=1747004191;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=M2lNWYotTn+V6B62NM9AJg/hLTmfkjAe5ZJGudVrO6s=;
  b=aulYneyeiDaSjK85A1yO8ZEyAaWksgwwLFzezL700GFRjIqeaGZYjEhx
   k2hnPFDgLQ0eM0BpN5oOo4wQKEq5WJREStkRjf1F6e9WSzH+Isq9BV08t
   NX90TBNdLlUfsHbD9vOlgOm+5hiboC3WFqp6hVZ5pyC22GGqYK7rSwKQd
   zlOeOp3zkZzwq4BKZTdSPsSW4VFvNVq1K3LZOAx0ZzvdZX6gTWo8q38eP
   Y5OSWXj8p+IJ36JzRgi027v54HxBR1yPDfdMH9GfE4mk7Qn7EfTVPAWA0
   LG1w8489wJE3AoYuywbC+IfgO7de3g0kRzuRVuI7BlJc6xUqToXkah1On
   Q==;
X-CSE-ConnectionGUID: l/lj/+KAQguB4XttyRER5A==
X-CSE-MsgGUID: Y55EIaV5RYK+neCU7/Pj9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11070"; a="22586001"
X-IronPort-AV: E=Sophos;i="6.08,155,1712646000"; 
   d="scan'208";a="22586001"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2024 15:56:30 -0700
X-CSE-ConnectionGUID: uL3m4BpASfqm6pqUQ8q49Q==
X-CSE-MsgGUID: XrBiXpF/TRevXQOe/xUsCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,155,1712646000"; 
   d="scan'208";a="34841426"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 11 May 2024 15:56:27 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s5vdg-0007uh-2Y;
	Sat, 11 May 2024 22:56:24 +0000
Date: Sun, 12 May 2024 06:55:58 +0800
From: kernel test robot <lkp@intel.com>
To: Srujana Challa <schalla@marvell.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Vamsi Attunuru <vattunuru@marvell.com>,
	Shijith Thotton <sthotton@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>
Subject: [mst-vhost:vhost 54/54]
 drivers/vdpa/octeon_ep/octep_vdpa_main.c:538:25: error: implicit declaration
 of function 'readq'; did you mean 'readl'?
Message-ID: <202405120615.TTwouGSU-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   0a0b17725dd921ed0364cd217a100ed0ed85c8c1
commit: 0a0b17725dd921ed0364cd217a100ed0ed85c8c1 [54/54] virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20240512/202405120615.TTwouGSU-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240512/202405120615.TTwouGSU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405120615.TTwouGSU-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/vdpa/octeon_ep/octep_vdpa_main.c: In function 'get_device_ready_status':
>> drivers/vdpa/octeon_ep/octep_vdpa_main.c:538:25: error: implicit declaration of function 'readq'; did you mean 'readl'? [-Werror=implicit-function-declaration]
     538 |         u64 signature = readq(addr + OCTEP_VF_MBOX_DATA(0));
         |                         ^~~~~
         |                         readl
>> drivers/vdpa/octeon_ep/octep_vdpa_main.c:541:17: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
     541 |                 writeq(0, addr + OCTEP_VF_MBOX_DATA(0));
         |                 ^~~~~~
         |                 writel
   cc1: some warnings being treated as errors
--
   In file included from include/linux/device.h:15,
                    from include/linux/pci.h:37,
                    from drivers/vdpa/octeon_ep/octep_vdpa.h:7,
                    from drivers/vdpa/octeon_ep/octep_vdpa_hw.c:6:
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c: In function 'octep_hw_caps_read':
>> drivers/vdpa/octeon_ep/octep_vdpa_hw.c:478:60: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     478 |         dev_info(dev, "common cfg mapped at: 0x%016llx\n", (u64)oct_hw->common_cfg);
         |                                                            ^
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:478:9: note: in expansion of macro 'dev_info'
     478 |         dev_info(dev, "common cfg mapped at: 0x%016llx\n", (u64)oct_hw->common_cfg);
         |         ^~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:479:60: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     479 |         dev_info(dev, "device cfg mapped at: 0x%016llx\n", (u64)oct_hw->dev_cfg);
         |                                                            ^
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:479:9: note: in expansion of macro 'dev_info'
     479 |         dev_info(dev, "device cfg mapped at: 0x%016llx\n", (u64)oct_hw->dev_cfg);
         |         ^~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:480:57: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     480 |         dev_info(dev, "isr cfg mapped at: 0x%016llx\n", (u64)oct_hw->isr);
         |                                                         ^
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:480:9: note: in expansion of macro 'dev_info'
     480 |         dev_info(dev, "isr cfg mapped at: 0x%016llx\n", (u64)oct_hw->isr);
         |         ^~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:482:18: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     482 |                  (u64)oct_hw->notify_base, oct_hw->notify_off_multiplier);
         |                  ^
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:481:9: note: in expansion of macro 'dev_info'
     481 |         dev_info(dev, "notify base: 0x%016llx, notify off multiplier: %u\n",
         |         ^~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:514:54: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     514 |         dev_info(dev, "mbox mapped at: 0x%016llx\n", (u64)mbox);
         |                                                      ^
   include/linux/dev_printk.h:110:37: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vdpa/octeon_ep/octep_vdpa_hw.c:514:9: note: in expansion of macro 'dev_info'
     514 |         dev_info(dev, "mbox mapped at: 0x%016llx\n", (u64)mbox);
         |         ^~~~~~~~


vim +538 drivers/vdpa/octeon_ep/octep_vdpa_main.c

   535	
   536	static bool get_device_ready_status(u8 __iomem *addr)
   537	{
 > 538		u64 signature = readq(addr + OCTEP_VF_MBOX_DATA(0));
   539	
   540		if (signature == OCTEP_DEV_READY_SIGNATURE) {
 > 541			writeq(0, addr + OCTEP_VF_MBOX_DATA(0));
   542			return true;
   543		}
   544	
   545		return false;
   546	}
   547	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

