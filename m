Return-Path: <kvm+bounces-20634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4031B91B6DB
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 08:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C127C282692
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 06:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E05A55898;
	Fri, 28 Jun 2024 06:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKO05Pcs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87554278;
	Fri, 28 Jun 2024 06:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719555378; cv=none; b=m3JdQqozjplqsj19z7vIkzW8MwfBwUE9lh6FFXbRuk77lmk3T06Mb3S0hOCz3jXuMPLap/hqQCURiYeb+4FAUZ8DIRSp11ACqKJgSEAW+ZjedsHOWAE9sh2adwAT1IghHJiaiFNRv0wNwRXYpyL4CDBAv41gqK4Z0Zko64c/P9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719555378; c=relaxed/simple;
	bh=VHivx3TXk6rbGD53jPWHJbhtFADdjRmAebTMKel3LII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QONk+iqQ1nihFFXC/VauK26iNxKin1B7Q2vDtA0groFwsy4w0DDXE/zvvABz30RCDUeGTVVMsWmH5lAD9JSSBZ5kGRXPux+YWi1QCriHLJw9QZtZsVOsCKhEOER3zi0Z67Po4IYPxCeVvbepUP42EvfFUu9XOlh3F3jzdqRg/Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKO05Pcs; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719555377; x=1751091377;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VHivx3TXk6rbGD53jPWHJbhtFADdjRmAebTMKel3LII=;
  b=fKO05Pcs/ho9TK8Zlhv4JaJKS72QKEnVRBJXXQDY03MpnChX5xQxa5v5
   OBRqy9y3npWi+/3SgfCIHFjIKSUZw64m9F/vUHjkmFAGNmi6KCs1KHSgM
   qFbtgpZehF0umLMIVrthQoq2/2CB0WkGzChq3TsSWgJxgRXtv7LSklcbn
   NF7CKuyIXFkBSsDVCRMYtmw9/O3msPQv6/prrJ/U2sphJhmn79U2T1Q7j
   fAZ3Xc7T4lbL5hWqszd6c59+6ZVWqbjh16w8T6YSo4sL0CKPiwFYBC8AB
   CJXmMYUYL94IL75jxKMkYvIWCtcROwZWGoCzl182V8xO7HnV4vrtZv3t0
   g==;
X-CSE-ConnectionGUID: WGG2NTRHRySHc3rhQMS4Cw==
X-CSE-MsgGUID: 4JAUWHoUTnaRMTCXH1Q38g==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="28118913"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="28118913"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 23:16:15 -0700
X-CSE-ConnectionGUID: 1Db3jF/gRaSXKeo8tyf+bA==
X-CSE-MsgGUID: LPQGGceOT/GqBxTXASLnug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44548736"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 27 Jun 2024 23:16:08 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sN4ty-000Gs2-0m;
	Fri, 28 Jun 2024 06:16:06 +0000
Date: Fri, 28 Jun 2024 14:15:45 +0800
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
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Luigi Leonardi <luigi.leonardi@outlook.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl
 for all vsock socket types.
Message-ID: <202406281355.d1jNVGBc-lkp@intel.com>
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
config: i386-randconfig-141-20240628 (https://download.01.org/0day-ci/archive/20240628/202406281355.d1jNVGBc-lkp@intel.com/config)
compiler: gcc-8 (Ubuntu 8.4.0-3ubuntu2) 8.4.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406281355.d1jNVGBc-lkp@intel.com/

smatch warnings:
net/vmw_vsock/af_vsock.c:1321 vsock_do_ioctl() warn: unsigned 'n_bytes' is never less than zero.

vim +/n_bytes +1321 net/vmw_vsock/af_vsock.c

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
  1314			if (vsk->transport->unsent_bytes) {
  1315				if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
  1316					retval = -EINVAL;
  1317					break;
  1318				}
  1319	
  1320				n_bytes = vsk->transport->unsent_bytes(vsk);
> 1321				if (n_bytes < 0) {
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

