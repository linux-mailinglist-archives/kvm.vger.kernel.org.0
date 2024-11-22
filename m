Return-Path: <kvm+bounces-32385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D296D9D6565
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 22:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 508AC1615EB
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 21:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B5B185B46;
	Fri, 22 Nov 2024 21:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OAr5kYXq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A8249E5
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 21:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732311212; cv=none; b=cYfCeYb1wqPLgKyGQxDS0yStKRtdOjMGxSrKziKXyh8+cXfnf7wVxBcDMvw95jhvI83AybdtrX4B+cyZTSAvpetTz3DnkUekmMVUPCJfiGoSQ/yEYVNBpIqCgQMMn6h3j94Nj2ZWmRkMBBq/Qwo91/ZuKdA0rtNlGtjHnR9Vi/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732311212; c=relaxed/simple;
	bh=UMsDGG/td31pODC2eWIaZYa3c4BOPJo4g3BIywwrwSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/2kjBtd5cARLKuT6yEO7oqLKBNk3vZ1oXu7ynhaDw1vEKFwFsruPlJoOQctd3qjPsg3R3aNr5ZmEiuzvrpESH+GVoWFWpS+uuxszq6OpmzTKJD6RbGTaI5tSD4yNU1CgP2znA9xUlSBdzpo0JIgAqeVffCmZKv1rXMZ3OP6M3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OAr5kYXq; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732311210; x=1763847210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UMsDGG/td31pODC2eWIaZYa3c4BOPJo4g3BIywwrwSU=;
  b=OAr5kYXqOoWuGQ/Nmkh2HXi2wWTOqwOueIiCp2m0QOrTgSOP3RfDNpaY
   acYyUixf8y9qOARMcJ7pacYXlgzyE9jkyPnAdUFmcwjO5wbOiwpNel1/V
   TkyFGMlQ3EFIPeRkJrGyIGTYZh+l//aJEa8DWHVGQregbnozww0oDL8pO
   rToL1trLSXznyJhus2wBfpredSc2o/JEF4AgcEMU+nNpbT/diRV2MLwrB
   OX0/0/EamFDWQzjdiSHOqZZc2OfZGvvV2KqG+5pLlv/OJhJIDiG/ieGk9
   rj1Ks0PuYRvBRUY9/6eerLdOfpxWawEn9+piuUTh0aIR43K5+l4gnhBzO
   g==;
X-CSE-ConnectionGUID: 9cSP1XPPS+iHD1HVNofvhw==
X-CSE-MsgGUID: dxOGcoieQ+aR0dFIgef7RQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="43858490"
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="43858490"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 13:33:22 -0800
X-CSE-ConnectionGUID: KHGGL0acSHWi7bGJgAy0Gw==
X-CSE-MsgGUID: Bg/FgRYCTmOGTMfbpAGiew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="91045170"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 22 Nov 2024 13:33:20 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tEbHA-0004E7-1u;
	Fri, 22 Nov 2024 21:33:16 +0000
Date: Sat, 23 Nov 2024 05:33:10 +0800
From: kernel test robot <lkp@intel.com>
To: Avihai Horon <avihaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>, Avihai Horon <avihaih@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <202411230727.abAsDI8W-lkp@intel.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121140057.25157-1-avihaih@nvidia.com>

Hi Avihai,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on linus/master awilliam-vfio/for-linus v6.12 next-20241122]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Avihai-Horon/vfio-pci-Properly-hide-first-in-list-PCIe-extended-capability/20241121-220249
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20241121140057.25157-1-avihaih%40nvidia.com
patch subject: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended capability
config: s390-randconfig-r053-20241122 (https://download.01.org/0day-ci/archive/20241123/202411230727.abAsDI8W-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241123/202411230727.abAsDI8W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411230727.abAsDI8W-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/vfio/pci/vfio_pci_config.c:24:
   In file included from include/linux/pci.h:39:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:95:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/vfio/pci/vfio_pci_config.c:24:
   In file included from include/linux/pci.h:39:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:95:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/vfio/pci/vfio_pci_config.c:24:
   In file included from include/linux/pci.h:39:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:95:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:693:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:701:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:709:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:718:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:727:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:736:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/vfio/pci/vfio_pci_config.c:322:27: error: initializer element is not a compile-time constant
           [0 ... PCI_CAP_ID_MAX] = direct_ro_perms
                                    ^~~~~~~~~~~~~~~
   drivers/vfio/pci/vfio_pci_config.c:325:31: error: initializer element is not a compile-time constant
           [0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
                                        ^~~~~~~~~~~~~~~
   12 warnings and 2 errors generated.


vim +322 drivers/vfio/pci/vfio_pci_config.c

   319	
   320	/* Default capability regions to read-only, no-virtualization */
   321	static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
 > 322		[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
   323	};
   324	static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
   325		[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
   326	};
   327	/*
   328	 * Default unassigned regions to raw read-write access.  Some devices
   329	 * require this to function as they hide registers between the gaps in
   330	 * config space (be2net).  Like MMIO and I/O port registers, we have
   331	 * to trust the hardware isolation.
   332	 */
   333	static struct perm_bits unassigned_perms = {
   334		.readfn = vfio_raw_config_read,
   335		.writefn = vfio_raw_config_write
   336	};
   337	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

