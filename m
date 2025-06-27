Return-Path: <kvm+bounces-50950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02201AEAF1A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB7A67AA0D1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E20B215779;
	Fri, 27 Jun 2025 06:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UUDep40g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130E62F3E;
	Fri, 27 Jun 2025 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751006537; cv=none; b=AUEdBm1E1+8yaX/+0RHrFjcFZbV0TJkyhZ0rHPlTzwolku7s/fsGXnRmx6VY/BCoqAIU95tZJKX6Hx2I2ea6HVvIRZTTsKdtF4HispUEeEOfeIc8qAHEXgRZgWk5BFssTBCeWXJUntxcvpbaEEZHqBzEarRJnzgaMIkuEtOxlxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751006537; c=relaxed/simple;
	bh=vxdzXCA6uv6ITMEmQeBZBJbpf7EQ+8bixtqN/sPot0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBbGyJwnarKXnhLvnbfFWg0UrQdCZaD+pwhVJqZH/87t7QfOlpdGwBrJmWYjFIVtEhhUhBJBpaEveFr9yYxNcviPXwdiWXD6X3B2Lgef0ydi+zm7Cb3xfyhdXi4+LWTr2Gyv/Ikvr9yPpO9IXM929HVBmvRb2axSpQZvqF/SIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UUDep40g; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751006536; x=1782542536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vxdzXCA6uv6ITMEmQeBZBJbpf7EQ+8bixtqN/sPot0o=;
  b=UUDep40gQbBTHVnYkfA9a/sPJlQRNTgUGSOPPjmnONtJ9qKSDPDZmCHp
   zEJ3mCPhXXcHLQ991oIgEoBzjPLBf9TjwX9/c/poQznMsMT7Gc2NWzfa9
   wH1kRiqpYTlLJf1G9g8ERYj26orefpXsFlYBTjBIBFuQ/GLsFjoKK3dS0
   RpxMU/pCNkyD5REOu2Q98ka7ZoKXYgIZzNWQQivAgUOQG/LW2O5hXGqIQ
   3P0juFSs2yAwKyqqZkFbhK9KdJr6doDuxmpDmQycZmJ1MBRKjvgWuEatk
   faUhTi3QmS08T8dGiecBDTf+C46yzMv3+OSAOH8aFagaY30vF1VHfP5XH
   w==;
X-CSE-ConnectionGUID: lccl08yoTQOPXw1LkASIkA==
X-CSE-MsgGUID: mJuH6Y7dRlCO3MxgLyhX7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63913850"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="63913850"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 23:42:15 -0700
X-CSE-ConnectionGUID: O441FA8cQuiHFmr0hGjU4A==
X-CSE-MsgGUID: OOenNMkkTAWhitkwCCiBEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="152243449"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 26 Jun 2025 23:42:12 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uV2mm-000VsI-2z;
	Fri, 27 Jun 2025 06:42:08 +0000
Date: Fri, 27 Jun 2025 14:41:58 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended
 features
Message-ID: <202506271443.G9cAx8PS-lkp@intel.com>
References: <23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni@redhat.com>

Hi Paolo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/scripts-kernel_doc-py-properly-handle-VIRTIO_DECLARE_FEATURES/20250624-221751
base:   net-next/main
patch link:    https://lore.kernel.org/r/23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni%40redhat.com
patch subject: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended features
config: csky-randconfig-001-20250627 (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506271443.G9cAx8PS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/uaccess.h:12,
                    from include/linux/sched/task.h:13,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs.h:34,
                    from include/linux/compat.h:17,
                    from drivers/vhost/net.c:8:
   arch/csky/include/asm/uaccess.h: In function '__get_user_fn.constprop':
>> arch/csky/include/asm/uaccess.h:147:9: warning: 'retval' is used uninitialized [-Wuninitialized]
     147 |         __asm__ __volatile__(                           \
         |         ^~~~~~~
   arch/csky/include/asm/uaccess.h:187:17: note: in expansion of macro '__get_user_asm_64'
     187 |                 __get_user_asm_64(x, ptr, retval);
         |                 ^~~~~~~~~~~~~~~~~
   arch/csky/include/asm/uaccess.h:170:13: note: 'retval' was declared here
     170 |         int retval;
         |             ^~~~~~


vim +/retval +147 arch/csky/include/asm/uaccess.h

da551281947cb2c Guo Ren 2018-09-05  141  
e58a41c2226847f Guo Ren 2021-04-21  142  #define __get_user_asm_64(x, ptr, err)			\
da551281947cb2c Guo Ren 2018-09-05  143  do {							\
da551281947cb2c Guo Ren 2018-09-05  144  	int tmp;					\
e58a41c2226847f Guo Ren 2021-04-21  145  	int errcode;					\
e58a41c2226847f Guo Ren 2021-04-21  146  							\
e58a41c2226847f Guo Ren 2021-04-21 @147  	__asm__ __volatile__(				\
e58a41c2226847f Guo Ren 2021-04-21  148  	"1:   ldw     %3, (%2, 0)     \n"		\
da551281947cb2c Guo Ren 2018-09-05  149  	"     stw     %3, (%1, 0)     \n"		\
e58a41c2226847f Guo Ren 2021-04-21  150  	"2:   ldw     %3, (%2, 4)     \n"		\
e58a41c2226847f Guo Ren 2021-04-21  151  	"     stw     %3, (%1, 4)     \n"		\
e58a41c2226847f Guo Ren 2021-04-21  152  	"     br      4f              \n"		\
e58a41c2226847f Guo Ren 2021-04-21  153  	"3:   mov     %0, %4          \n"		\
e58a41c2226847f Guo Ren 2021-04-21  154  	"     br      4f              \n"		\
da551281947cb2c Guo Ren 2018-09-05  155  	".section __ex_table, \"a\"   \n"		\
da551281947cb2c Guo Ren 2018-09-05  156  	".align   2                   \n"		\
e58a41c2226847f Guo Ren 2021-04-21  157  	".long    1b, 3b              \n"		\
e58a41c2226847f Guo Ren 2021-04-21  158  	".long    2b, 3b              \n"		\
da551281947cb2c Guo Ren 2018-09-05  159  	".previous                    \n"		\
e58a41c2226847f Guo Ren 2021-04-21  160  	"4:                           \n"		\
e58a41c2226847f Guo Ren 2021-04-21  161  	: "=r"(err), "=r"(x), "=r"(ptr),		\
e58a41c2226847f Guo Ren 2021-04-21  162  	  "=r"(tmp), "=r"(errcode)			\
e58a41c2226847f Guo Ren 2021-04-21  163  	: "0"(err), "1"(x), "2"(ptr), "3"(0),		\
e58a41c2226847f Guo Ren 2021-04-21  164  	  "4"(-EFAULT)					\
da551281947cb2c Guo Ren 2018-09-05  165  	: "memory");					\
da551281947cb2c Guo Ren 2018-09-05  166  } while (0)
da551281947cb2c Guo Ren 2018-09-05  167  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

