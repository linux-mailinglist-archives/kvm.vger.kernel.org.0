Return-Path: <kvm+bounces-45844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A54BEAAF946
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278044A1790
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B972253BB;
	Thu,  8 May 2025 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2JbgdHE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B222259D;
	Thu,  8 May 2025 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705661; cv=none; b=OMvpXrZF3BJ5bQp1JD96yjzy1DX3CXY6koLs8hzQjl3gDrttGl1gegbD+X7C73uMpIZkfzfVAIilt24BsBMZgPyToVW/O8H59bKkXwaG1/9LUmNb8FQcmCar5105y1dL0tc7ypKb8wRpEcgp92BdCTp47XTVAXY5DYabuR0/Afw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705661; c=relaxed/simple;
	bh=Be14sYMJgqDSXAsAhFgXHfZ88JPBtCSTFdWjm1mWUPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=us63yS++LE4NJpdqEAzY6reLFM9NIMQG3fcSuKG/w/2o8bLtC3B1dER1MbNrW8d+KkUtWymh5RLQ5x1srQFb8S3qpZhELvwkz02STE44FB0CAne6Ksi0DTcdPPywAPFD5O9hVerWRlQ6KsrY6S4l9x/y0ra73KOYuDS8SQs+D2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2JbgdHE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746705658; x=1778241658;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Be14sYMJgqDSXAsAhFgXHfZ88JPBtCSTFdWjm1mWUPg=;
  b=L2JbgdHENvDiR/qNlSFlt37syqCuXVSv5zHBGiNyqY+UEoNt0/FAauvd
   pcZlkut9TalUUIpUhP8nKBKVPHQSfe1kjCn14+wv+qm8msh+rLMf3Z1E1
   617OuaB+/67FbmN79YV0uhsCsjHYoyJY6jusBAzEJqXF3vMC6oJN259Jr
   8qGwjoS5OOxF5ARYfW6zfwV4IP+fxmD6KFQznn5n5FyzPesGBlpSdLSp4
   I5iX/IEITkwKCWIJx0NrPSTYT9TRBoooIw1bcK7VsK5Rl5sBZ/E/Nv287
   jwtUJSSAN82ufmx5JVJ3M0gT3unD6CMlCbKrdN+k/ZMk9J5C9RKqJcsFp
   g==;
X-CSE-ConnectionGUID: C9bAiwpASVe1Yz1ubvoXtA==
X-CSE-MsgGUID: Vs60Z3f9Teiq1Ixa2qfZiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="59880237"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="59880237"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 05:00:58 -0700
X-CSE-ConnectionGUID: hECwaveLTE6gYFrxQeV4jw==
X-CSE-MsgGUID: cPqddmc2T9SDuQ91hM42Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141226677"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 08 May 2025 05:00:54 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCzvn-000Aw3-2H;
	Thu, 08 May 2025 12:00:51 +0000
Date: Thu, 8 May 2025 20:00:06 +0800
From: kernel test robot <lkp@intel.com>
To: Jon Kohler <jon@nutanix.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Jon Kohler <jon@nutanix.com>
Subject: Re: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Message-ID: <202505081920.FOOj1Z0e-lkp@intel.com>
References: <20250507160206.3267692-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507160206.3267692-1-jon@nutanix.com>

Hi Jon,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Jon-Kohler/vhost-net-align-variable-names-with-XDP-terminology/20250507-233429
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250507160206.3267692-1-jon%40nutanix.com
patch subject: [PATCH net-next] vhost/net: align variable names with XDP terminology
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250508/202505081920.FOOj1Z0e-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250508/202505081920.FOOj1Z0e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505081920.FOOj1Z0e-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vhost/net.c:681:28: warning: operator '?:' has lower precedence than '+'; '+' will be evaluated first [-Wparentheses]
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:51: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:49:41: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                            ^
   drivers/vhost/net.c:681:28: note: place parentheses around the '+' expression to silence this warning
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:51: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:49:41: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                            ^
   drivers/vhost/net.c:681:28: note: place parentheses around the '?:' expression to evaluate it first
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:51: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:49:41: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                            ^
>> drivers/vhost/net.c:681:28: warning: operator '?:' has lower precedence than '+'; '+' will be evaluated first [-Wparentheses]
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:47: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                  ^~~~
   drivers/vhost/net.c:681:28: note: place parentheses around the '+' expression to silence this warning
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:47: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                  ^~~~
   drivers/vhost/net.c:681:28: note: place parentheses around the '?:' expression to evaluate it first
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:47: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                  ^~~~
>> drivers/vhost/net.c:681:28: warning: operator '?:' has lower precedence than '+'; '+' will be evaluated first [-Wparentheses]
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:58: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                             ^~~~
   drivers/vhost/net.c:681:28: note: place parentheses around the '+' expression to silence this warning
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:58: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                             ^~~~
   drivers/vhost/net.c:681:28: note: place parentheses around the '?:' expression to evaluate it first
     680 |         headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     681 |                                   vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
         |                                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/skbuff.h:256:33: note: expanded from macro 'SKB_DATA_ALIGN'
     256 | #define SKB_DATA_ALIGN(X)       ALIGN(X, SMP_CACHE_BYTES)
         |                                 ~~~~~~^~~~~~~~~~~~~~~~~~~
   include/vdso/align.h:8:38: note: expanded from macro 'ALIGN'
       8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
         |                                 ~~~~~~~~~~~~~~~~^~~~~~~~
   include/uapi/linux/const.h:48:66: note: expanded from macro '__ALIGN_KERNEL'
      48 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
   include/uapi/linux/const.h:49:58: note: expanded from macro '__ALIGN_KERNEL_MASK'
      49 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
         |                                                             ^~~~
   3 warnings generated.


vim +681 drivers/vhost/net.c

   661	
   662	static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
   663				       struct iov_iter *from)
   664	{
   665		struct vhost_virtqueue *vq = &nvq->vq;
   666		struct vhost_net *net = container_of(vq->dev, struct vhost_net,
   667						     dev);
   668		int copied, headroom, ret, sock_hlen = nvq->sock_hlen;
   669		struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
   670		struct socket *sock = vhost_vq_get_backend(vq);
   671		size_t data_len = iov_iter_count(from);
   672		struct virtio_net_hdr *gso;
   673		struct tun_xdp_hdr *hdr;
   674		void *hard_start;
   675		u32 frame_sz;
   676	
   677		if (unlikely(data_len < sock_hlen))
   678			return -EFAULT;
   679	
   680		headroom = SKB_DATA_ALIGN(VHOST_NET_RX_PAD + sock_hlen +
 > 681					  vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0);
   682	
   683		frame_sz = SKB_HEAD_ALIGN(headroom + data_len);
   684	
   685		if (frame_sz > PAGE_SIZE)
   686			return -ENOSPC;
   687	
   688		hard_start = page_frag_alloc_align(&net->pf_cache, frame_sz,
   689						   GFP_KERNEL, SMP_CACHE_BYTES);
   690		if (unlikely(!hard_start))
   691			return -ENOMEM;
   692	
   693		copied = copy_from_iter(hard_start + offsetof(struct tun_xdp_hdr, gso),
   694					sock_hlen, from);
   695		if (copied != sock_hlen) {
   696			ret = -EFAULT;
   697			goto err;
   698		}
   699	
   700		hdr = hard_start;
   701		gso = &hdr->gso;
   702	
   703		if (!sock_hlen)
   704			memset(hard_start, 0, headroom);
   705	
   706		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
   707		    vhost16_to_cpu(vq, gso->csum_start) +
   708		    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
   709		    vhost16_to_cpu(vq, gso->hdr_len)) {
   710			gso->hdr_len = cpu_to_vhost16(vq,
   711				       vhost16_to_cpu(vq, gso->csum_start) +
   712				       vhost16_to_cpu(vq, gso->csum_offset) + 2);
   713	
   714			if (vhost16_to_cpu(vq, gso->hdr_len) > data_len) {
   715				ret = -EINVAL;
   716				goto err;
   717			}
   718		}
   719	
   720		data_len -= sock_hlen;
   721		copied = copy_from_iter(hard_start + headroom, data_len, from);
   722		if (copied != data_len) {
   723			ret = -EFAULT;
   724			goto err;
   725		}
   726	
   727		xdp_init_buff(xdp, frame_sz, NULL);
   728		xdp_prepare_buff(xdp, hard_start, headroom, data_len, true);
   729		hdr->buflen = frame_sz;
   730	
   731		++nvq->batched_xdp;
   732	
   733		return 0;
   734	
   735	err:
   736		page_frag_free(hard_start);
   737		return ret;
   738	}
   739	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

