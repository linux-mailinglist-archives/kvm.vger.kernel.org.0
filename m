Return-Path: <kvm+bounces-61229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7E0C11A9D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 37E4D4FD2BF
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E70C32861D;
	Mon, 27 Oct 2025 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJOmENca"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C821D011;
	Mon, 27 Oct 2025 22:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603471; cv=none; b=hdP6BhvYsswVaGakQJwK0zjZ1T2eyVqiEUWMF/9A7VlTGcpzzA2yuSEj/WruXf1iCVXWQz+S7rUwmS+dKX+6f0Q8wiFY5y8h7IEGdkbnR5bVIvFIk6ErGbgxcDAq3SENINoWQ9735QmYvO0gaQNl/2lmDQTwXHRtlIHCw9akpRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603471; c=relaxed/simple;
	bh=WXRa7oaBVwVTwfRflgF/27ocV7EMk7uNv6iVjH6SfvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjhXtK55cczy3uJgMjMOPmqecQI/82Fm9Bw1XsBD1aKX01bA9XRYuYYUiULdq92Ntq3jcIurxXMtQa3dtRwuVaYENs0pUv6Xs7CPxlaQ3/Ans5dUXvtANz6HqSqqQ+rghCpHyHhZHnbOQLxfEYRv55k4/CwdgMuaUduhsA8YuFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJOmENca; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761603469; x=1793139469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WXRa7oaBVwVTwfRflgF/27ocV7EMk7uNv6iVjH6SfvY=;
  b=oJOmENcaUCDTNzqYXrzyEwgA4BHiGdNTyqMBepsvloxKEMwbKEcYCvZh
   BbDt9/xa5If731p23PlaC/Ha+dV+rhrt32yNs+3YpGI/Q5/2StyRqvxD1
   mDxUi0cVff2V/wMWq0b7V7PP2pIqqEcS9PMQSdc8rt6mD/5L5l/JwEiwG
   wV4NQGetg0F/wqNBZ07JDxGsMP56IIme1pw/y+OFDiCoHz1bn7SIxCZQR
   3pjjphnqCdWa+Sw1xyxk4S0rgM/A0IRfsMMIAIiznmnFqzcUr57GWUi4/
   Gp0oJTdWBpaPYGyBTvdmY5SoQ2ysaLZE59jHNbRFr9HcnaI4Cf9qgw/GU
   A==;
X-CSE-ConnectionGUID: Htikv+S1SPeUxVxf6CEVmw==
X-CSE-MsgGUID: 2WJ1sUY2Ty+7gCXpIOtVjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74371075"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="74371075"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 15:17:49 -0700
X-CSE-ConnectionGUID: 8AoYJFCoQ9u3PMJjGdZLmg==
X-CSE-MsgGUID: n4B144lMSV+/ROi/cws+uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="189205240"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 27 Oct 2025 15:17:45 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDVWz-000IW7-1M;
	Mon, 27 Oct 2025 22:17:39 +0000
Date: Tue, 28 Oct 2025 06:17:06 +0800
From: kernel test robot <lkp@intel.com>
To: Nick Hudson <nhudson@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Nick Hudson <nhudson@akamai.com>,
	Max Tottenham <mtottenh@akamai.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and
 use in net.c
Message-ID: <202510280515.pRBqbq4I-lkp@intel.com>
References: <20251027102644.622305-1-nhudson@akamai.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027102644.622305-1-nhudson@akamai.com>

Hi Nick,

kernel test robot noticed the following build errors:

[auto build test ERROR on mst-vhost/linux-next]
[also build test ERROR on linus/master v6.18-rc3 next-20251027]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nick-Hudson/vhost-add-a-new-ioctl-VHOST_GET_VRING_WORKER_INFO-and-use-in-net-c/20251027-182919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20251027102644.622305-1-nhudson%40akamai.com
patch subject: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and use in net.c
config: arm-randconfig-001-20251028 (https://download.01.org/0day-ci/archive/20251028/202510280515.pRBqbq4I-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project e1ae12640102fd2b05bc567243580f90acb1135f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251028/202510280515.pRBqbq4I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510280515.pRBqbq4I-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vhost/vhost.c:2403:3: error: use of undeclared identifier 'worker'
    2403 |                 worker = rcu_dereference_check(vq->worker,
         |                 ^~~~~~
   drivers/vhost/vhost.c:2403:34: error: use of undeclared identifier 'vq'
    2403 |                 worker = rcu_dereference_check(vq->worker,
         |                                                ^~
   drivers/vhost/vhost.c:2403:34: error: use of undeclared identifier 'vq'
    2403 |                 worker = rcu_dereference_check(vq->worker,
         |                                                ^~
   drivers/vhost/vhost.c:2404:30: error: use of undeclared identifier 'dev'
    2404 |                                                lockdep_is_held(&dev->mutex));
         |                                                                 ^~~
   drivers/vhost/vhost.c:2403:34: error: use of undeclared identifier 'vq'
    2403 |                 worker = rcu_dereference_check(vq->worker,
         |                                                ^~
   drivers/vhost/vhost.c:2405:8: error: use of undeclared identifier 'worker'
    2405 |                 if (!worker) {
         |                      ^~~~~~
   drivers/vhost/vhost.c:2406:4: error: use of undeclared identifier 'ret'
    2406 |                         ret = -EINVAL;
         |                         ^~~
   drivers/vhost/vhost.c:2410:11: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
    2410 |                 memset(&ring_worker_info, 0, sizeof(ring_worker_info));
         |                         ^~~~~~~~~~~~~~~~
         |                         print_worker_info
   include/linux/workqueue.h:637:13: note: 'print_worker_info' declared here
     637 | extern void print_worker_info(const char *log_lvl, struct task_struct *task);
         |             ^
   drivers/vhost/vhost.c:2410:39: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
    2410 |                 memset(&ring_worker_info, 0, sizeof(ring_worker_info));
         |                                                     ^~~~~~~~~~~~~~~~
         |                                                     print_worker_info
   include/linux/workqueue.h:637:13: note: 'print_worker_info' declared here
     637 | extern void print_worker_info(const char *log_lvl, struct task_struct *task);
         |             ^
   drivers/vhost/vhost.c:2411:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
    2411 |                 ring_worker_info.index = idx;
         |                 ^~~~~~~~~~~~~~~~
         |                 print_worker_info
   include/linux/workqueue.h:637:13: note: 'print_worker_info' declared here
     637 | extern void print_worker_info(const char *log_lvl, struct task_struct *task);
         |             ^
   drivers/vhost/vhost.c:2411:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union
    2411 |                 ring_worker_info.index = idx;
         |                 ~~~~~~~~~~~~~~~~^~~~~~
   drivers/vhost/vhost.c:2411:28: error: use of undeclared identifier 'idx'
    2411 |                 ring_worker_info.index = idx;
         |                                          ^~~
   drivers/vhost/vhost.c:2412:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
    2412 |                 ring_worker_info.worker_id = worker->id;
         |                 ^~~~~~~~~~~~~~~~
         |                 print_worker_info
   include/linux/workqueue.h:637:13: note: 'print_worker_info' declared here
     637 | extern void print_worker_info(const char *log_lvl, struct task_struct *task);
         |             ^
   drivers/vhost/vhost.c:2412:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union
    2412 |                 ring_worker_info.worker_id = worker->id;
         |                 ~~~~~~~~~~~~~~~~^~~~~~~~~~
   drivers/vhost/vhost.c:2412:32: error: use of undeclared identifier 'worker'
    2412 |                 ring_worker_info.worker_id = worker->id;
         |                                              ^~~~~~
   drivers/vhost/vhost.c:2413:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
    2413 |                 ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
         |                 ^~~~~~~~~~~~~~~~
         |                 print_worker_info
   include/linux/workqueue.h:637:13: note: 'print_worker_info' declared here
     637 | extern void print_worker_info(const char *log_lvl, struct task_struct *task);
         |             ^
   drivers/vhost/vhost.c:2413:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union
    2413 |                 ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
         |                 ~~~~~~~~~~~~~~~~^~~~~~~~~~~
>> drivers/vhost/vhost.c:2413:46: error: call to undeclared function 'vhost_get_task'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2413 |                 ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
         |                                                            ^
   drivers/vhost/vhost.c:2413:46: note: did you mean 'vhost_get_desc'?
   drivers/vhost/vhost.c:1581:19: note: 'vhost_get_desc' declared here
    1581 | static inline int vhost_get_desc(struct vhost_virtqueue *vq,
         |                   ^
   drivers/vhost/vhost.c:2413:61: error: use of undeclared identifier 'worker'
    2413 |                 ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
         |                                                                           ^~~~~~
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.


vim +/vhost_get_task +2413 drivers/vhost/vhost.c

  2352	
  2353		/* You must be the owner to do anything else */
  2354		r = vhost_dev_check_owner(d);
  2355		if (r)
  2356			goto done;
  2357	
  2358		switch (ioctl) {
  2359		case VHOST_SET_MEM_TABLE:
  2360			r = vhost_set_memory(d, argp);
  2361			break;
  2362		case VHOST_SET_LOG_BASE:
  2363			if (copy_from_user(&p, argp, sizeof p)) {
  2364				r = -EFAULT;
  2365				break;
  2366			}
  2367			if ((u64)(unsigned long)p != p) {
  2368				r = -EFAULT;
  2369				break;
  2370			}
  2371			for (i = 0; i < d->nvqs; ++i) {
  2372				struct vhost_virtqueue *vq;
  2373				void __user *base = (void __user *)(unsigned long)p;
  2374				vq = d->vqs[i];
  2375				mutex_lock(&vq->mutex);
  2376				/* If ring is inactive, will check when it's enabled. */
  2377				if (vq->private_data && !vq_log_access_ok(vq, base))
  2378					r = -EFAULT;
  2379				else
  2380					vq->log_base = base;
  2381				mutex_unlock(&vq->mutex);
  2382			}
  2383			break;
  2384		case VHOST_SET_LOG_FD:
  2385			r = get_user(fd, (int __user *)argp);
  2386			if (r < 0)
  2387				break;
  2388			ctx = fd == VHOST_FILE_UNBIND ? NULL : eventfd_ctx_fdget(fd);
  2389			if (IS_ERR(ctx)) {
  2390				r = PTR_ERR(ctx);
  2391				break;
  2392			}
  2393			swap(ctx, d->log_ctx);
  2394			for (i = 0; i < d->nvqs; ++i) {
  2395				mutex_lock(&d->vqs[i]->mutex);
  2396				d->vqs[i]->log_ctx = d->log_ctx;
  2397				mutex_unlock(&d->vqs[i]->mutex);
  2398			}
  2399			if (ctx)
  2400				eventfd_ctx_put(ctx);
  2401			break;
  2402		case VHOST_GET_VRING_WORKER_INFO:
  2403			worker = rcu_dereference_check(vq->worker,
  2404						       lockdep_is_held(&dev->mutex));
  2405			if (!worker) {
  2406				ret = -EINVAL;
  2407				break;
  2408			}
  2409	
  2410			memset(&ring_worker_info, 0, sizeof(ring_worker_info));
  2411			ring_worker_info.index = idx;
  2412			ring_worker_info.worker_id = worker->id;
> 2413			ring_worker_info.worker_pid = task_pid_vnr(vhost_get_task(worker->vtsk));
  2414	
  2415			if (copy_to_user(argp, &ring_worker_info, sizeof(ring_worker_info)))
  2416				ret = -EFAULT;
  2417			break;
  2418		default:
  2419			r = -ENOIOCTLCMD;
  2420			break;
  2421		}
  2422	done:
  2423		return r;
  2424	}
  2425	EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
  2426	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

