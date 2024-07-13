Return-Path: <kvm+bounces-21604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 724879305D8
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 16:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 767371C20C1C
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 14:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FD3139597;
	Sat, 13 Jul 2024 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cNiJkYZt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4722621A1C
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720880132; cv=none; b=lRgTk16Eh91SrJkdLIYChx8cgyoNf0UU3nd0a4OPrBFyI5cPkzrLMS9TVZ3Z2mbe0+bbq863nrfhfLoapeXYUjp3J98EeEec7COJBOGr/8hX+0d6LyAkzusKIKaii9G2R7Lvng2e1BtjOZKBuVkP8XF14SFmJ0H36kiabYG88iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720880132; c=relaxed/simple;
	bh=zksOsm3xfhbU2PwSLZD99o5C2ArGToftLHN0QFQYnwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8CruJTbuIgC3Zi2FZs4O94qa4gmFSKuiYpKO1HPu0sIlFzp6DRZIXALr11Y38cOmSrZnl+jbCCGqgiIALYMf7nljzKjcV9YiMtOidNSftTENXQkUbG4+x+oIim9xQVI3u+RtI4/40O2xrmiG3yhcq8oKe89XAfsZMUBB31QJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cNiJkYZt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720880130; x=1752416130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zksOsm3xfhbU2PwSLZD99o5C2ArGToftLHN0QFQYnwU=;
  b=cNiJkYZtbyZbcx/xGZrfWVKEpg3YDumlSkCLpVk9BERn6tWDqqVMQyVA
   Wo+ABCYLPJmOZC6Uck3TjUYN8nK36GnATqzDdOtDLJ78i2c1aBoQfeWBL
   vMhAX0zeAzlTlk5NlUevPhc8m5FTtect//wmSW15FwHG/jEy/QmcrzaIl
   MIqaXumlHJkfstXBrSVkDgfv64h9mTPGpRd3K0q/CDfqumrQKhJFG5vaI
   AVILm2Nclw6gGHIYFtcetakEYZL/CWER05ceDm55r2PqENm1k1aLVLhcf
   we4DnfV4HmbBwBN4UwB07gov7SlchkkE1Lal/CY9fwnzPOVeyJLOcq6du
   A==;
X-CSE-ConnectionGUID: 1S/+FURdRFmPd52dhjZSig==
X-CSE-MsgGUID: QSRqnNnKQbOUT3SfY42ptA==
X-IronPort-AV: E=McAfee;i="6700,10204,11131"; a="29720287"
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="29720287"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 07:15:30 -0700
X-CSE-ConnectionGUID: HAu3aLSqQRaeuOMYG+535g==
X-CSE-MsgGUID: 4uwpHISHQZqe2DCNshdDvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="54366056"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 13 Jul 2024 07:15:27 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sSdX2-000cFO-0T;
	Sat, 13 Jul 2024 14:15:24 +0000
Date: Sat, 13 Jul 2024 22:15:02 +0800
From: kernel test robot <lkp@intel.com>
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, pdurrant@amazon.co.uk, dwmw@amazon.co.uk,
	Laurent.Vivier@bull.net, ghaskins@novell.com, avi@redhat.com,
	mst@redhat.com, levinsasha928@gmail.com, peng.hao2@zte.com.cn,
	nh-open-source@amazon.com
Subject: Re: [PATCH 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
Message-ID: <202407140049.CuVivD5M-lkp@intel.com>
References: <20240710085259.2125131-5-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710085259.2125131-5-ilstam@amazon.com>

Hi Ilias,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on mst-vhost/linux-next linus/master v6.10-rc7]
[cannot apply to kvm/linux-next next-20240712]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ilias-Stamatis/KVM-Fix-coalesced_mmio_has_room/20240710-222059
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240710085259.2125131-5-ilstam%40amazon.com
patch subject: [PATCH 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
config: loongarch-randconfig-001-20240713 (https://download.01.org/0day-ci/archive/20240714/202407140049.CuVivD5M-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240714/202407140049.CuVivD5M-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407140049.CuVivD5M-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/kvm/../../../virt/kvm/coalesced_mmio.c: In function 'kvm_vm_ioctl_register_coalesced_mmio':
>> arch/loongarch/kvm/../../../virt/kvm/coalesced_mmio.c:292:24: error: implicit declaration of function 'fget'; did you mean 'sget'? [-Wimplicit-function-declaration]
     292 |                 file = fget(zone->buffer_fd);
         |                        ^~~~
         |                        sget
>> arch/loongarch/kvm/../../../virt/kvm/coalesced_mmio.c:292:22: error: assignment to 'struct file *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     292 |                 file = fget(zone->buffer_fd);
         |                      ^
>> arch/loongarch/kvm/../../../virt/kvm/coalesced_mmio.c:297:25: error: implicit declaration of function 'fput'; did you mean 'iput'? [-Wimplicit-function-declaration]
     297 |                         fput(file);
         |                         ^~~~
         |                         iput


vim +292 arch/loongarch/kvm/../../../virt/kvm/coalesced_mmio.c

   278	
   279	int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
   280						 struct kvm_coalesced_mmio_zone2 *zone,
   281						 bool use_buffer_fd)
   282	{
   283		int ret = 0;
   284		struct file *file;
   285		struct kvm_coalesced_mmio_dev *dev;
   286		struct kvm_coalesced_mmio_buffer_dev *buffer_dev = NULL;
   287	
   288		if (zone->pio != 1 && zone->pio != 0)
   289			return -EINVAL;
   290	
   291		if (use_buffer_fd) {
 > 292			file = fget(zone->buffer_fd);
   293			if (!file)
   294				return -EBADF;
   295	
   296			if (file->f_op != &coalesced_mmio_buffer_ops) {
 > 297				fput(file);
   298				return -EINVAL;
   299			}
   300	
   301			buffer_dev = file->private_data;
   302			if (!buffer_dev->ring) {
   303				fput(file);
   304				return -ENOBUFS;
   305			}
   306		}
   307	
   308		dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev),
   309			      GFP_KERNEL_ACCOUNT);
   310		if (!dev) {
   311			ret = -ENOMEM;
   312			goto out_free_file;
   313		}
   314	
   315		kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
   316		dev->kvm = kvm;
   317		dev->zone = *zone;
   318		dev->buffer_dev = buffer_dev;
   319	
   320		mutex_lock(&kvm->slots_lock);
   321		ret = kvm_io_bus_register_dev(kvm,
   322					zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS,
   323					zone->addr, zone->size, &dev->dev);
   324		if (ret < 0)
   325			goto out_free_dev;
   326		list_add_tail(&dev->list, &kvm->coalesced_zones);
   327		mutex_unlock(&kvm->slots_lock);
   328	
   329		goto out_free_file;
   330	
   331	out_free_dev:
   332		mutex_unlock(&kvm->slots_lock);
   333		kfree(dev);
   334	out_free_file:
   335		if (use_buffer_fd)
   336			fput(file);
   337	
   338		return ret;
   339	}
   340	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

