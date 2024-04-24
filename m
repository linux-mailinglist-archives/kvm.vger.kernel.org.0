Return-Path: <kvm+bounces-15880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 083F28B1724
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 01:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87C821F2149D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D4316F0F9;
	Wed, 24 Apr 2024 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUkFi/JU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABCC16F0DD;
	Wed, 24 Apr 2024 23:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714001619; cv=none; b=MCzVjkQens6/dWvDKqY7YlfC2xcT07ALX2qtGXIq6y+/E/w0Q8+yG+gS64Pid9p2VSlbZtzXYgps0Oig8+Y7uZilYua183cN1RAmvOgzMDFuOnvn6H7X+xamWh0aKdTp8p97txa64wYaID2fugVlqGoCGUxElgTkmqECJd9PB10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714001619; c=relaxed/simple;
	bh=RIgE5n3pL6jeQnQkBJoRkDShHjgY8jnKMIghJf4yJ2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euFkU1pikNmEWFnxtW7s5MTbhLBBbTcyS7spOcbsM2olbOdo+3oD5w/6Zd9Gr/TeBZRYuqQXSYLtLKvquq2V6Kt2PLBfkiFlKSTseJlBTv4YfkYBEvx1phvJsSf59WZ8n7xqJ00rhE5QWwyfm30uVKH6m30GS/jmAXB7/NEzG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUkFi/JU; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714001618; x=1745537618;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RIgE5n3pL6jeQnQkBJoRkDShHjgY8jnKMIghJf4yJ2s=;
  b=nUkFi/JUqd5/lhtVtjLzNNRvAoG+uVUwZG/SNhQ2JpYy9E0qG3L8Dy+D
   7CJSTxz/75+AlMe5aFlPhciXij8cSRjRgwmzUf2wfKwOBLG00E+yo9Ehm
   aJX0mUDIihqPkZfSzukYVg/Pfgv6nDilOQGh0U4T2nEELWOzJpjQSyfPl
   7iVQOcAwsxT9rz81x3zO5Ve4lD7W2vBWyMB77F+0yz+1Bob6UpuUoRTi3
   W7DsPAKHHkLJISgMoe5VOxoLgaYNUU/tFwJjQQ+dOAxSAkUZxyEQRMj9S
   Wi6gUryWCBYQYWHudxhKulF2yzG89e9tuYpv/X4+j/qtvHjg6TCt/C0bG
   Q==;
X-CSE-ConnectionGUID: O1b7S63XRrKvmSQBY4+7NQ==
X-CSE-MsgGUID: zAY3AF7yThqdWRjByzBiRA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9589678"
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="9589678"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 16:33:37 -0700
X-CSE-ConnectionGUID: 4g0UrdBoQrilGb7Ep/RgRw==
X-CSE-MsgGUID: K1w0tqhpQZ+bEtHASv2FDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="24916325"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 24 Apr 2024 16:33:35 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rzm7I-0001m2-0t;
	Wed, 24 Apr 2024 23:33:32 +0000
Date: Thu, 25 Apr 2024 07:32:49 +0800
From: kernel test robot <lkp@intel.com>
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
	jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxarm@openeuler.org, liulongfang@huawei.com
Subject: Re: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Message-ID: <202404250711.4mzD3Fe0-lkp@intel.com>
References: <20240424085721.12760-5-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424085721.12760-5-liulongfang@huawei.com>

Hi Longfang,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on linus/master v6.9-rc5 next-20240424]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-extract-public-functions-for-container_of/20240424-170806
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20240424085721.12760-5-liulongfang%40huawei.com
patch subject: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20240425/202404250711.4mzD3Fe0-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 5ef5eb66fb428aaf61fb51b709f065c069c11242)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240425/202404250711.4mzD3Fe0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404250711.4mzD3Fe0-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:9:
   In file included from include/linux/hisi_acc_qm.h:10:
   In file included from include/linux/pci.h:38:
   In file included from include/linux/interrupt.h:21:
   In file included from arch/riscv/include/asm/sections.h:9:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:46: error: too few arguments provided to function-like macro invocation
    1370 |         dev_err("mailbox cmd channel state is OK!\n");
         |                                                     ^
   include/linux/dev_printk.h:143:9: note: macro 'dev_err' defined here
     143 | #define dev_err(dev, fmt, ...) \
         |         ^
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:2: error: use of undeclared identifier 'dev_err'; did you mean '_dev_err'?
    1370 |         dev_err("mailbox cmd channel state is OK!\n");
         |         ^~~~~~~
         |         _dev_err
   include/linux/dev_printk.h:50:6: note: '_dev_err' declared here
      50 | void _dev_err(const struct device *dev, const char *fmt, ...);
         |      ^
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:2: warning: expression result unused [-Wunused-value]
    1370 |         dev_err("mailbox cmd channel state is OK!\n");
         |         ^~~~~~~
   6 warnings and 2 errors generated.


vim +1370 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

  1345	
  1346	static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
  1347	{
  1348		struct device *vf_dev = seq->private;
  1349		struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
  1350		struct vfio_device *vdev = &core_device->vdev;
  1351		struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
  1352		struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
  1353		u64 value;
  1354		int ret;
  1355	
  1356		mutex_lock(&hisi_acc_vdev->enable_mutex);
  1357		ret = hisi_acc_vf_debug_check(seq, vdev);
  1358		if (ret) {
  1359			mutex_unlock(&hisi_acc_vdev->enable_mutex);
  1360			return ret;
  1361		}
  1362	
  1363		value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
  1364		if (value == QM_MB_CMD_NOT_READY) {
  1365			mutex_unlock(&hisi_acc_vdev->enable_mutex);
  1366			dev_err(vf_dev, "mailbox cmd channel not ready!\n");
  1367			return -EINVAL;
  1368		}
  1369		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> 1370		dev_err("mailbox cmd channel state is OK!\n");
  1371	
  1372		return 0;
  1373	}
  1374	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

