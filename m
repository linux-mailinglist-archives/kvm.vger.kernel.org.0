Return-Path: <kvm+bounces-58868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 282C1BA3EFF
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 15:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD4E1C042BF
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DE0199385;
	Fri, 26 Sep 2025 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bweNgKor"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE372605;
	Fri, 26 Sep 2025 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758894469; cv=none; b=dCxBZ9WyDZTdeK8IHBHM6JuPNhATvTlPkv7eJxFcsi+Owlced15Uiujfg2NoofRqSfEkVW8SdL9MHIwOjClUS/TqvMar7WU8UVetn39xSvc+jpPCHjulbOLbdton1YH3yw8gUwx4PUdWhW3lnsygwtci0qwLR924ssu5vTRcxBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758894469; c=relaxed/simple;
	bh=F5sJdFJrZExOT4Y38tlg7pfSvmXRgWle6iLVax55eVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hc5m140d0IuC6OBIWzy+fSpbhxhTbMVA0sgZetEKN8lI7Z1LTws8exBCT3sTk8O3/qhfY8qekVWv35pEwVwi94Foyj5b20jMNmVrSolj7WqMRIcNPxnXIqhvntLi8powZNbg3S/u0XijzPspsV8L3L/RwxNB7KPqZDLQqAk/KMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bweNgKor; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758894468; x=1790430468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F5sJdFJrZExOT4Y38tlg7pfSvmXRgWle6iLVax55eVY=;
  b=bweNgKorNS37gRD2btmYo3tPBCd3f0BnvIsuA5ay6WtoiN5aWChE9UIW
   ofhAKMysNVpc2RcaVyIBqWsIwkHWjbm8J2GP+tmJNbrNNBjO2lEb/oB3n
   OcvW+ob5dERrjfky78lh8it7b8N9Ws1ZMFV5UU8zDDtkXqpf3nS8noXiq
   N53+qp3fnjmjuAIP+ka9iFeG5oQ18jd4R6x3MAdP7Y45ZgVHZrNk+Jfos
   FThZu+vuWGutnsY0BK8CEYU4KcN5WWuehsyPci3F/dxrcAVzdaDwPX8jv
   5y6JAkeZJsjIgQD5VqWDw9hEKLd13NZ4zF13ShvspWDXGKlO4rn9iPJKw
   g==;
X-CSE-ConnectionGUID: /sN9Cm41Q8aXI3hQwBR2tw==
X-CSE-MsgGUID: yq/oTDwXT9mPNM62+0tqBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="71475614"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="71475614"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 06:47:47 -0700
X-CSE-ConnectionGUID: Eiyiwf9tRtaaHrguhNPjFQ==
X-CSE-MsgGUID: 1uGnwmjMRMiFXVFa9yQ7JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="181919291"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 26 Sep 2025 06:47:43 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v28nU-0006Gz-2h;
	Fri, 26 Sep 2025 13:47:40 +0000
Date: Fri, 26 Sep 2025 21:47:32 +0800
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
Message-ID: <202509262102.4AmV1Mms-lkp@intel.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Simon-Schippers/__ptr_ring_full_next-Returns-if-ring-will-be-full-after-next-insertion/20250924-180633
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250922221553.47802-9-simon.schippers%40tu-dortmund.de
patch subject: [PATCH net-next v5 8/8] vhost_net: Replace rx_ring with calls of TUN/TAP wrappers
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250926/202509262102.4AmV1Mms-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250926/202509262102.4AmV1Mms-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509262102.4AmV1Mms-lkp@intel.com/

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

