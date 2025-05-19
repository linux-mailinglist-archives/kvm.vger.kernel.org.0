Return-Path: <kvm+bounces-47003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FE4ABC509
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 333AF7A1351
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CD628852B;
	Mon, 19 May 2025 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X/WwM9nd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A8A286D65;
	Mon, 19 May 2025 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747673872; cv=none; b=OPuPjGESZm8vXYa5zUujfAyuSlgdrC3Hs5ZYCO9PgYt3RY8C84p2rRiXqO6CIXl7er5wuukBOI2oAtK8xazht0BuT/nSL8hHHQHVNqR5KCbi9Z9uPL3svytteF0fF5EKaM+L3AtmkDmUQDDIJjMVKXATOGgOSLRUULpHaL/kNu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747673872; c=relaxed/simple;
	bh=LWf9idZ0qXyqCW25uLT23OoOR3Z0Os+s3Ij3RQTKcT4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=f3WpVo21G4rO1tOyIbW/wxw2Lrw020nrX6UBhKTww5LF6NI3CjBsuqd/7puUhsDcHTCpXgCzTr4i4zswRzwfKZ2JuBX8DeOjbCyyLvInKf6xvm7Di3djWX0HCexnJIL0XyvShpol/Y8/e34X8FboqUVH4fShtnEqPEJw37GItwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X/WwM9nd; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747673870; x=1779209870;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=LWf9idZ0qXyqCW25uLT23OoOR3Z0Os+s3Ij3RQTKcT4=;
  b=X/WwM9ndZSRCr24xNc468bALCIlpacFDYOYJ+FuOG6qauKhjyrz1Cdb+
   FBmEQVnqnUlCq8k71A5NHYBnshuUx8PqY2GcBu5OHbSuPnSvIGjB0kXQA
   J28E9DNeWlWo9XaFHWnAt6lt0zJinyQ/UmEqSFVy0stCUqnyElYPWT/6n
   y7xmFXq/+n/dZbk9UQeVMkwbSoJe03CE7pgelP/uFKQcGPcZBIGwjj6qj
   /3JOutJxkA6nQKEukx763HyejOpXVG16pGnFZGAplzFWZsfRWSktm7keE
   ig+oL1gRn5Jm7/R0QfzgW5iGxlLV/F9q+YChPvuLYFZtWjz9SQaKqOBca
   A==;
X-CSE-ConnectionGUID: 0Td0YRrJS7aYZbiC8Wxl7A==
X-CSE-MsgGUID: Vn+8ukubT7al6R1Lbbtwdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="48836493"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="48836493"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:57:49 -0700
X-CSE-ConnectionGUID: AxitDLj5Qk2PjQrNMper8g==
X-CSE-MsgGUID: kZP2DSLDRHW6yOWHR4wafw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="162709571"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 19 May 2025 09:57:48 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uH3o9-000Li9-38;
	Mon, 19 May 2025 16:57:45 +0000
Date: Tue, 20 May 2025 00:57:12 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Wang <jasowang@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [mst-vhost:vhost 29/35] drivers/virtio/virtio_ring.c:2103:22:
 sparse: sparse: symbol 'packed_ops' was not declared. Should it be static?
Message-ID: <202505200015.m6vjyLRy-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   f640220b1e149add1dff0be2978905c5df628eaf
commit: 92ec21878c59083a95c9fcf1a10f86d29350ce1b [29/35] virtio_ring: introduce virtqueue ops
config: arc-randconfig-r132-20250519 (https://download.01.org/0day-ci/archive/20250520/202505200015.m6vjyLRy-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 10.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250520/202505200015.m6vjyLRy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505200015.m6vjyLRy-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/virtio/virtio_ring.c:2103:22: sparse: sparse: symbol 'packed_ops' was not declared. Should it be static?

vim +/packed_ops +2103 drivers/virtio/virtio_ring.c

  2102	
> 2103	struct virtqueue_ops packed_ops;
  2104	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

