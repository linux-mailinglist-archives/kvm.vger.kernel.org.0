Return-Path: <kvm+bounces-58533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B43F3B962AC
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBFEE4A261E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8B5238C08;
	Tue, 23 Sep 2025 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ww+7q0V/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E755F2036ED;
	Tue, 23 Sep 2025 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636890; cv=none; b=ZeUcswWPIZruAS6f2r7O04n7AFRgoDGKMZNW6g+mRwXlZN2lXc1sRUcfV46fTnge7G0p4Z1TleLSaaY1L7BdJWYzvWCOLbEVs07QuYs2jEvgB4oie/thH8TbjGZZK2TehWNQ5qEYTD07SdHGUBuk52vkel5k4qF/yFMd8e/Di4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636890; c=relaxed/simple;
	bh=+H9zJ9ZnJh5XdjSEpBwdWNCOzZuIf/K/RLNBOxUxrx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjnpKZUhTfaqHS+3E/X36ZDm5d77hFwd0bVPg1PUdujPfbHzSMN3FwnxFG6Q7vl1ZVf8tP78a4157dYDVxkdh9Q5xnnkuTIv9dsSkuHwmfWtIpGeLMXtvL36guuoEU2Kgu0kQs9is6JXAIUwD0N/PvAaMt3P5YJJhNUOd6cdEGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ww+7q0V/; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758636889; x=1790172889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+H9zJ9ZnJh5XdjSEpBwdWNCOzZuIf/K/RLNBOxUxrx0=;
  b=Ww+7q0V/UUe+4zKbAIwk745wJ/rtlZi59yq0UYa5M+VghJ76KFnnU025
   ihWhnJTANpICEi8dp8lDh6+baGTr3kXtPEABbEawt3Y+rS9aFZb0Dm+q8
   ul1zqRcz/RjcwyOvgmdDIRCx+zmZyrOmPaM72Z5ML9/JeiR4B8oWFT0fO
   v/KDlXHM2QKcSTgKRCb/FrXEEJi23BSWOHKVVlMpfD1kHBLhsnoQLuhrx
   WH0wmouJuZjG0s3ihtomZ2EDX97gk4O5CBCDkE/iXezzXfB707JZy3Iwz
   e3ILve4l/4Z69ruhdGVoZOU6CGniRNuMblzyxaKGnhP5vvEWhKN8kouUK
   A==;
X-CSE-ConnectionGUID: JRB6lzdeQLGcwAfAz1SRWQ==
X-CSE-MsgGUID: fAp0oqWDTBeOOOJsO/RWVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="86353231"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="86353231"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:14:21 -0700
X-CSE-ConnectionGUID: hi4LmZPgTA2uLR2Pk1F+Zg==
X-CSE-MsgGUID: h4fxs8c9Q++r6fENoG5wpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="176369709"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 23 Sep 2025 07:14:18 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v13ma-0003Av-0n;
	Tue, 23 Sep 2025 14:14:16 +0000
Date: Tue, 23 Sep 2025 22:14:05 +0800
From: kernel test robot <lkp@intel.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>,
	willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	mst@redhat.com, eperezma@redhat.com, stephen@networkplumber.org,
	leiyang@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Simon Schippers <simon.schippers@tu-dortmund.de>,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 8/8] vhost_net: Replace rx_ring with calls of
 TUN/TAP wrappers
Message-ID: <202509232113.Z0qRJQHs-lkp@intel.com>
References: <20250922221553.47802-9-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922221553.47802-9-simon.schippers@tu-dortmund.de>

Hi Simon,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Simon-Schippers/__ptr_ring_full_next-Returns-if-ring-will-be-full-after-next-insertion/20250923-062130
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250922221553.47802-9-simon.schippers%40tu-dortmund.de
patch subject: [PATCH net-next v5 8/8] vhost_net: Replace rx_ring with calls of TUN/TAP wrappers
config: i386-buildonly-randconfig-003-20250923 (https://download.01.org/0day-ci/archive/20250923/202509232113.Z0qRJQHs-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509232113.Z0qRJQHs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509232113.Z0qRJQHs-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vhost/net.c:197:3: error: expected expression
     197 |                 WARN_ON_ONCE();
         |                 ^
   include/asm-generic/bug.h:111:34: note: expanded from macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                         ^
   1 error generated.


vim +197 drivers/vhost/net.c

   178	
   179	static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq,
   180			struct sock *sk)
   181	{
   182		struct file *file = sk->sk_socket->file;
   183		struct vhost_net_buf *rxq = &nvq->rxq;
   184	
   185		rxq->head = 0;
   186	
   187		switch (nvq->type) {
   188		case TUN:
   189			rxq->tail = tun_ring_consume_batched(file,
   190					rxq->queue, VHOST_NET_BATCH);
   191			break;
   192		case TAP:
   193			rxq->tail = tap_ring_consume_batched(file,
   194					rxq->queue, VHOST_NET_BATCH);
   195			break;
   196		case IF_NONE:
 > 197			WARN_ON_ONCE();
   198		}
   199	
   200		return rxq->tail;
   201	}
   202	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

