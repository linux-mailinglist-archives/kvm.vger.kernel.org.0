Return-Path: <kvm+bounces-20599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7346791A3F2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 12:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BB4F1C20E3E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 10:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E5813E3E1;
	Thu, 27 Jun 2024 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="btwmqID4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3104713BC3A;
	Thu, 27 Jun 2024 10:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719484521; cv=none; b=kxL4KaMuCMlZZvUfuzgwo3Z+f763i49XYWEd7pL6wLOggHwcEysR7vqXIDjsk2ErxQKRw0u7pxIqnJMMb40FdbIF6Wr4uEpuU7pIRr1lPKZcwxiJxZhTGd8c1JkMiHes1vnD1UN5Rcxa3kxOZzbxMEwGheGMSVO/6Tsy/vS4MDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719484521; c=relaxed/simple;
	bh=n3fTqo6NFMW3NSDHDgErXu3fhjUWB/TMDTwrHQZiNk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDd1Ull6DUncv8fXghLoWDL74UUz8x8QWuWIXKr0uxOX1xj5ak4NnJQhk4aVT7PuUXdWD9khKQe59Rd76LJEXhc6Z46jhL3LlLcsBcQK1CpW+wR2nv+YknbYeotAzP2ryqxEtOFP0LTioFSW6Kd+Ya9nHkE8QvaTAhlUWOwlLmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=btwmqID4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719484519; x=1751020519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n3fTqo6NFMW3NSDHDgErXu3fhjUWB/TMDTwrHQZiNk0=;
  b=btwmqID4rWjgL2xPewEqaqGimJKmMIWth9WcdrCQ8WgbS1eSpVZGNCqN
   H+VWLSeN3PG16AKzFn+V+E58RWONfLfiDN6P9j5tFMHyel+E7Btjdi1/+
   PToYdEk62TPrn5FhZCf9C1P10MIT10Acp3p9f9fu9Fsk+fZn7rIkftrLc
   vIT8k3oT7QCQ3jMicUPbP+hQrvsR9JEFkf1wZSXzHqU+e1ecIsem3CIqr
   F0+DQuVip+iyvz9kU7+DbWN/FLxpmHiiylpvDBuKKyGGCZAO3GcDNx7Fa
   HUeWK3kbE8yDivPUgimcZm6cXqQMw2/RLfecFNmbns4PKkoSdyljeMBw8
   A==;
X-CSE-ConnectionGUID: slNJHxn4RuO8jHWX4RKhAQ==
X-CSE-MsgGUID: oMGwQ+T7Szi2SWwPSptR/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="27291346"
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="27291346"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 03:35:19 -0700
X-CSE-ConnectionGUID: paDRu1OoTI6tUNJdOeGl2w==
X-CSE-MsgGUID: GJd7IFfETOepN/MOy1bIdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,269,1712646000"; 
   d="scan'208";a="44457060"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 27 Jun 2024 03:35:14 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sMmT9-000G7y-22;
	Thu, 27 Jun 2024 10:35:11 +0000
Date: Thu, 27 Jun 2024 18:34:29 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Luigi Leonardi <luigi.leonardi@outlook.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl
 for all vsock socket types.
Message-ID: <202406271827.aQ9ZYlCh-lkp@intel.com>
References: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 50b70845fc5c22cf7e7d25b57d57b3dca1725aa5]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Leonardi-via-B4-Relay/vsock-add-support-for-SIOCOUTQ-ioctl-for-all-vsock-socket-types/20240627-023902
base:   50b70845fc5c22cf7e7d25b57d57b3dca1725aa5
patch link:    https://lore.kernel.org/r/20240626-ioctl_next-v3-1-63be5bf19a40%40outlook.com
patch subject: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
config: i386-buildonly-randconfig-001-20240627 (https://download.01.org/0day-ci/archive/20240627/202406271827.aQ9ZYlCh-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240627/202406271827.aQ9ZYlCh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406271827.aQ9ZYlCh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/vmw_vsock/af_vsock.c:1314:7: warning: variable 'retval' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    1314 |                 if (vsk->transport->unsent_bytes) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/vmw_vsock/af_vsock.c:1334:9: note: uninitialized use occurs here
    1334 |         return retval;
         |                ^~~~~~
   net/vmw_vsock/af_vsock.c:1314:3: note: remove the 'if' if its condition is always true
    1314 |                 if (vsk->transport->unsent_bytes) {
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/vmw_vsock/af_vsock.c:1301:12: note: initialize the variable 'retval' to silence this warning
    1301 |         int retval;
         |                   ^
         |                    = 0
   1 warning generated.


vim +1314 net/vmw_vsock/af_vsock.c

  1295	
  1296	static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
  1297				  int __user *arg)
  1298	{
  1299		struct sock *sk = sock->sk;
  1300		struct vsock_sock *vsk;
  1301		int retval;
  1302	
  1303		vsk = vsock_sk(sk);
  1304	
  1305		switch (cmd) {
  1306		case SIOCOUTQ: {
  1307			size_t n_bytes;
  1308	
  1309			if (!vsk->transport || !vsk->transport->unsent_bytes) {
  1310				retval = -EOPNOTSUPP;
  1311				break;
  1312			}
  1313	
> 1314			if (vsk->transport->unsent_bytes) {
  1315				if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
  1316					retval = -EINVAL;
  1317					break;
  1318				}
  1319	
  1320				n_bytes = vsk->transport->unsent_bytes(vsk);
  1321				if (n_bytes < 0) {
  1322					retval = n_bytes;
  1323					break;
  1324				}
  1325	
  1326				retval = put_user(n_bytes, arg);
  1327			}
  1328			break;
  1329		}
  1330		default:
  1331			retval = -ENOIOCTLCMD;
  1332		}
  1333	
  1334		return retval;
  1335	}
  1336	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

