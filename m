Return-Path: <kvm+bounces-47012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 173A4ABC6E9
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A76FD189ABAA
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E31288C3F;
	Mon, 19 May 2025 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPUgYP57"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64B2B67F;
	Mon, 19 May 2025 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747678200; cv=none; b=fHyEd2PVSORcpv16iEbCenBIechjj46peeR7JT4kWgPp7jiF8ysvLzqI0LVQ4TBHf97DixLlweoNJJmXsDRn09ALU1iU9Y+A2SX90OTAkwZsfyFD1VmKkY3aL9t9+0ztfngGEA70iwNGvn+EI4a3KgT2q91ZYb0IVDv+vFB0ChI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747678200; c=relaxed/simple;
	bh=Ujm3qC0orBzqYk5UGsJndf74AenQ037h15KGkkJwDGg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rCMyLLXnc1hVaU03WIviIE00lr/SiYFFKQ8vFroYFKoPLrMKlLwPBmDv7gBInV3CmOrQV71H1iUuMGbxlqqwUK7nt9Ep7UY1EmlpL2sjPWovEzkHKU2547FCLCy8Hb59nJNmJDNMc+5Ibq+lRxN1Kdyxa0bejDH9iwtrAURIeGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPUgYP57; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747678198; x=1779214198;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ujm3qC0orBzqYk5UGsJndf74AenQ037h15KGkkJwDGg=;
  b=MPUgYP57FX+NhVkguIAL6X5HW1twSE0Bx0U2IUpXBxkZnRjVmP1PA4CC
   duRxrpoSDzBpvncjmmAnW3z2eNXyZeI36BM9ooxHnbYUng1bIA6bP/cx/
   gccj0hygeWcpzevG1UnXxQ1otcvtUcSIDz20Tz1XBsd8YLB1cwup3fDSB
   k/tK9CF/JxDG081YpIG6CG42xmTunAFq/TMrHRlnq7Ck0Y1TLhldKR6Dp
   nPWRMEMceJxp0WHHFdVG6pEKtFLY1bByGdh+NlfCtsPm231ueVvAw9Akn
   2Z+wT2lRyRk779DUOVuXbnK0sO5+3Odlz1kFfNp6nKhrYsoyy5B7gCrJm
   g==;
X-CSE-ConnectionGUID: 7oympGOmRwuIPK96S0U3Bg==
X-CSE-MsgGUID: wbOtU69tTv635jxHxbjAmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49727479"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="49727479"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 11:09:57 -0700
X-CSE-ConnectionGUID: tiLWmR9IROypzZN0IeVY/w==
X-CSE-MsgGUID: QUqYULJsRK+M1Mr/7+CgYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="143444590"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 19 May 2025 11:09:55 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uH4vv-000Lko-1i;
	Mon, 19 May 2025 18:09:51 +0000
Date: Tue, 20 May 2025 02:08:57 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Wang <jasowang@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 35/35] drivers/virtio/virtio_ring.c:1281:22:
 sparse: sparse: symbol 'split_in_order_ops' was not declared. Should it be
 static?
Message-ID: <202505200227.usDCH63W-lkp@intel.com>
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
commit: f640220b1e149add1dff0be2978905c5df628eaf [35/35] virtio_ring: add in order support
config: arc-randconfig-r132-20250519 (https://download.01.org/0day-ci/archive/20250520/202505200227.usDCH63W-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 10.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250520/202505200227.usDCH63W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505200227.usDCH63W-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/virtio/virtio_ring.c:1281:22: sparse: sparse: symbol 'split_in_order_ops' was not declared. Should it be static?
   drivers/virtio/virtio_ring.c:2510:22: sparse: sparse: symbol 'packed_ops' was not declared. Should it be static?
>> drivers/virtio/virtio_ring.c:2511:22: sparse: sparse: symbol 'packed_in_order_ops' was not declared. Should it be static?

vim +/split_in_order_ops +1281 drivers/virtio/virtio_ring.c

  1279	
> 1280	struct virtqueue_ops split_ops;
> 1281	struct virtqueue_ops split_in_order_ops;
  1282	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

