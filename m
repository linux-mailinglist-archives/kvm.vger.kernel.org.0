Return-Path: <kvm+bounces-21607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEE293074D
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 22:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6F4F2830C8
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 20:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2317143C5F;
	Sat, 13 Jul 2024 20:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CoecKU7F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A6B43ADE
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 20:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720903731; cv=none; b=iYlmqpORRjpoWJdI4NY0F+lo2hoCKeEFHzV7E7qLJxhVWp8WhY9k1WGA/LYT1onhitzG/qcFeM+4FnlYIfa/lo+GzvO/sgqwk8wTeMgo8ObHtm/J+7IAOna4oGBeAfXbnVuramnoZtoYgXGnKwyv2obeX9b9uwDnhgHH8H5yRdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720903731; c=relaxed/simple;
	bh=BicwkrVOLPBY6se3kJ7XEizY2jq32jf56dGNqJ2rjQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXi1e/vl+zO0qInwpfKnoS4SJsxDoAd5KdWhyRlGL5CXxRejPnoiPbgCrNaj+oHZKZUVohPtyqcoLpccsNsY4WFpI2wIrPYZE1+xJndzptlAFSd0xy8X63FDIE4pTB3ad5NNGb3FZ/OjfaJpBlNyTqnMkrRuKsN8Js0EWBh2tsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CoecKU7F; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720903729; x=1752439729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BicwkrVOLPBY6se3kJ7XEizY2jq32jf56dGNqJ2rjQI=;
  b=CoecKU7F6Ti2VBiD2iyhf70EYPI/KXqkjWJD4jGiydMYsVggZkDELiTm
   T2uzVfhf1RhO39gE5CylxnZfMw4D42IU0GBuAw5pX9HCbqxC5oyvUPgLz
   Mxop80z6CPgwXxkHQwCj3KjLxbhMDjv8Jw0bz9aXe3iDDncHEjZEHqssn
   CJhHOLmti++4IjI9XiWg5yPo+q89Zp1/SKsAhvg/kUO/p4BVviK1AOR1A
   jGMc28G1FjZJFLZzYijJpBp5oyKLojwysZCOI7klBRKsdfBEpXrYOLpKd
   Y2JraOrmyy3OWW06gM5ELcu/PkZsGwloYbl28B0OsYTGYEXNCvT4RWFyz
   g==;
X-CSE-ConnectionGUID: sNKaPjUuSY+e1122SzJ/2g==
X-CSE-MsgGUID: J+zGOdWeTcuhMMoJCBLQHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11132"; a="18439776"
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="18439776"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 13:48:48 -0700
X-CSE-ConnectionGUID: BGMBZsA2TDuXPnacFo0pSA==
X-CSE-MsgGUID: EDzWgHx1SQOsc8Dbi2PLiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="54062844"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 13 Jul 2024 13:48:45 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sSjfe-000cjC-2w;
	Sat, 13 Jul 2024 20:48:42 +0000
Date: Sun, 14 Jul 2024 04:48:36 +0800
From: kernel test robot <lkp@intel.com>
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, pdurrant@amazon.co.uk, dwmw@amazon.co.uk,
	Laurent.Vivier@bull.net, ghaskins@novell.com, avi@redhat.com,
	mst@redhat.com, levinsasha928@gmail.com, peng.hao2@zte.com.cn,
	nh-open-source@amazon.com
Subject: Re: [PATCH 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
Message-ID: <202407140405.VJSETXg3-lkp@intel.com>
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
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20240714/202407140405.VJSETXg3-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240714/202407140405.VJSETXg3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407140405.VJSETXg3-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/kvm/../../../virt/kvm/coalesced_mmio.c: In function 'kvm_vm_ioctl_register_coalesced_mmio':
>> arch/powerpc/kvm/../../../virt/kvm/coalesced_mmio.c:292:24: error: implicit declaration of function 'fget'; did you mean 'sget'? [-Wimplicit-function-declaration]
     292 |                 file = fget(zone->buffer_fd);
         |                        ^~~~
         |                        sget
>> arch/powerpc/kvm/../../../virt/kvm/coalesced_mmio.c:292:22: error: assignment to 'struct file *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     292 |                 file = fget(zone->buffer_fd);
         |                      ^
>> arch/powerpc/kvm/../../../virt/kvm/coalesced_mmio.c:297:25: error: implicit declaration of function 'fput'; did you mean 'iput'? [-Wimplicit-function-declaration]
     297 |                         fput(file);
         |                         ^~~~
         |                         iput


vim +292 arch/powerpc/kvm/../../../virt/kvm/coalesced_mmio.c

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

