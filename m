Return-Path: <kvm+bounces-14611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 373348A4736
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 05:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BEEDB22A2E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 03:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43419179AE;
	Mon, 15 Apr 2024 03:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRivY9oO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294EA1EB3A;
	Mon, 15 Apr 2024 03:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713150847; cv=none; b=p1myvpx7MNQgmrDhEg6JabCcOGxrgb0A0qKfcCR29cYnQrJrelllIZCGpuZwUGAEkp7H8GbpOifmX01wQ2Nx3G6X0mjmiZCjVtdB/PUUhlfNl7Fz8ItlvIo+m1HhQpMwOan1W8O1ZFK/FGLGxYC55jxtso2fvvaD8RRtDhrxRQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713150847; c=relaxed/simple;
	bh=e+3BShBbd4Hhf1J3QtuaioPJSDkni4jhxtYXepyXO38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArjH1A1C1J+ClRoP7sdl3D35IjQj0bG21DuHCI5vDRBx11+eAsKVfkP+wcedcCT7hYgXCSYfILNX8AYxbLajW6U5UgK1kOKHrHUEGXgTalEUGn6WqpuXp3di/X7re+mvsVyQYuaguGppsSROCHtmLYZDGKkJCxXZTYbEV98Qdr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRivY9oO; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713150845; x=1744686845;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e+3BShBbd4Hhf1J3QtuaioPJSDkni4jhxtYXepyXO38=;
  b=GRivY9oONgel4+IE1Hw7F1v5BTpzp2nGyGYps3/+4dG96oBQc/FlmiBk
   C1xH8PH663y3lawduGs/GQPEL6V9BdF5/XGbCnsMEgMIB5HmsWiADtG8S
   O8nSI0UmQHbzdpv0Tyy6v6Kk4ewbS5YrwwAhqRPk/VHOJ2gJi3WqyWXse
   fssRRIDb5ZaH6EakXvnsDVAlEvqCYVU/qrFwbVhmTgsKeLiY+b6mcdWQ8
   2VKu0lDu9RtjNmKk/JXX+QnAVXcimHXrNcMSnGWhzLPsX+36D9EKGqnrK
   iGDuUhEItWWig9DyoIOgwO2ZcNR871aHK1oANiqr0XQkJcmoYHB00k3vA
   Q==;
X-CSE-ConnectionGUID: Qw4svMm0QFOS4IsalQudzg==
X-CSE-MsgGUID: 2dLhJ6vXSaacEsDgZgSpQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="19083804"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="19083804"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 20:14:05 -0700
X-CSE-ConnectionGUID: P8mKInsKTxmwCkoXvz1jTQ==
X-CSE-MsgGUID: Pi7qP+d5SnqA4zkfEtiF7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="26452032"
Received: from unknown (HELO 23c141fc0fd8) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 14 Apr 2024 20:13:59 -0700
Received: from kbuild by 23c141fc0fd8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rwCmu-0003wi-34;
	Mon, 15 Apr 2024 03:13:56 +0000
Date: Mon, 15 Apr 2024 11:13:24 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <202404151003.vkNApJiS-lkp@intel.com>
References: <20240412084213.1733764-10-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-10-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on kvmarm/next efi/next tip/irq/core linus/master v6.9-rc3 next-20240412]
[cannot apply to arnd-asm-generic/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/arm64-rsi-Add-RSI-definitions/20240412-164852
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20240412084213.1733764-10-steven.price%40arm.com
patch subject: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20240415/202404151003.vkNApJiS-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 8b3b4a92adee40483c27f26c478a384cd69c6f05)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240415/202404151003.vkNApJiS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404151003.vkNApJiS-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/hv/hv.c:13:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/hv/hv.c:132:10: error: call to undeclared function 'set_memory_decrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     132 |                         ret = set_memory_decrypted((unsigned long)hv_cpu->post_msg_page, 1);
         |                               ^
   drivers/hv/hv.c:168:10: error: call to undeclared function 'set_memory_decrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     168 |                         ret = set_memory_decrypted((unsigned long)
         |                               ^
>> drivers/hv/hv.c:218:11: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     218 |                                 ret = set_memory_encrypted((unsigned long)
         |                                       ^
   drivers/hv/hv.c:230:11: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     230 |                                 ret = set_memory_encrypted((unsigned long)
         |                                       ^
   drivers/hv/hv.c:239:11: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     239 |                                 ret = set_memory_encrypted((unsigned long)
         |                                       ^
   5 warnings and 5 errors generated.
--
   In file included from drivers/hv/connection.c:16:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/hv/connection.c:236:8: error: call to undeclared function 'set_memory_decrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     236 |         ret = set_memory_decrypted((unsigned long)
         |               ^
>> drivers/hv/connection.c:340:2: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     340 |         set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[0], 1);
         |         ^
   5 warnings and 2 errors generated.
--
   In file included from drivers/hv/channel.c:14:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/hv/channel.c:442:8: error: call to undeclared function 'set_memory_decrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     442 |         ret = set_memory_decrypted((unsigned long)kbuffer,
         |               ^
>> drivers/hv/channel.c:531:3: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     531 |                 set_memory_encrypted((unsigned long)kbuffer,
         |                 ^
   drivers/hv/channel.c:848:8: error: call to undeclared function 'set_memory_encrypted'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     848 |         ret = set_memory_encrypted((unsigned long)gpadl->buffer,
         |               ^
   5 warnings and 3 errors generated.


vim +/set_memory_decrypted +132 drivers/hv/hv.c

3e7ee4902fe699 drivers/staging/hv/Hv.c Hank Janssen      2009-07-13   96  
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19   97  int hv_synic_alloc(void)
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19   98  {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18   99  	int cpu, ret = -ENOMEM;
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  100  	struct hv_per_cpu_context *hv_cpu;
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  101  
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  102  	/*
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  103  	 * First, zero all per-cpu memory areas so hv_synic_free() can
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  104  	 * detect what memory has been allocated and cleanup properly
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  105  	 * after any failures.
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  106  	 */
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  107  	for_each_present_cpu(cpu) {
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  108  		hv_cpu = per_cpu_ptr(hv_context.cpu_context, cpu);
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  109  		memset(hv_cpu, 0, sizeof(*hv_cpu));
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  110  	}
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  111  
6396bb221514d2 drivers/hv/hv.c         Kees Cook         2018-06-12  112  	hv_context.hv_numa_map = kcalloc(nr_node_ids, sizeof(struct cpumask),
597ff72f3de850 drivers/hv/hv.c         Jia-Ju Bai        2018-03-04  113  					 GFP_KERNEL);
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  114  	if (hv_context.hv_numa_map == NULL) {
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  115  		pr_err("Unable to allocate NUMA map\n");
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  116  		goto err;
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  117  	}
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  118  
421b8f20d3c381 drivers/hv/hv.c         Vitaly Kuznetsov  2016-12-07  119  	for_each_present_cpu(cpu) {
f25a7ece08bdb1 drivers/hv/hv.c         Michael Kelley    2018-08-10  120  		hv_cpu = per_cpu_ptr(hv_context.cpu_context, cpu);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  121  
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  122  		tasklet_init(&hv_cpu->msg_dpc,
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  123  			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  124  
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  125  		if (ms_hyperv.paravisor_present && hv_isolation_type_tdx()) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  126  			hv_cpu->post_msg_page = (void *)get_zeroed_page(GFP_ATOMIC);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  127  			if (hv_cpu->post_msg_page == NULL) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  128  				pr_err("Unable to allocate post msg page\n");
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  129  				goto err;
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  130  			}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  131  
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24 @132  			ret = set_memory_decrypted((unsigned long)hv_cpu->post_msg_page, 1);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  133  			if (ret) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  134  				pr_err("Failed to decrypt post msg page: %d\n", ret);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  135  				/* Just leak the page, as it's unsafe to free the page. */
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  136  				hv_cpu->post_msg_page = NULL;
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  137  				goto err;
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  138  			}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  139  
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  140  			memset(hv_cpu->post_msg_page, 0, PAGE_SIZE);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  141  		}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  142  
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  143  		/*
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  144  		 * Synic message and event pages are allocated by paravisor.
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  145  		 * Skip these pages allocation here.
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  146  		 */
d3a9d7e49d1531 drivers/hv/hv.c         Dexuan Cui        2023-08-24  147  		if (!ms_hyperv.paravisor_present && !hv_root_partition) {
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  148  			hv_cpu->synic_message_page =
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  149  				(void *)get_zeroed_page(GFP_ATOMIC);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  150  			if (hv_cpu->synic_message_page == NULL) {
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  151  				pr_err("Unable to allocate SYNIC message page\n");
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  152  				goto err;
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  153  			}
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  154  
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  155  			hv_cpu->synic_event_page =
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  156  				(void *)get_zeroed_page(GFP_ATOMIC);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  157  			if (hv_cpu->synic_event_page == NULL) {
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  158  				pr_err("Unable to allocate SYNIC event page\n");
68f2f2bc163d44 drivers/hv/hv.c         Dexuan Cui        2023-08-24  159  
68f2f2bc163d44 drivers/hv/hv.c         Dexuan Cui        2023-08-24  160  				free_page((unsigned long)hv_cpu->synic_message_page);
68f2f2bc163d44 drivers/hv/hv.c         Dexuan Cui        2023-08-24  161  				hv_cpu->synic_message_page = NULL;
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  162  				goto err;
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  163  			}
faff44069ff538 drivers/hv/hv.c         Tianyu Lan        2021-10-25  164  		}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  165  
68f2f2bc163d44 drivers/hv/hv.c         Dexuan Cui        2023-08-24  166  		if (!ms_hyperv.paravisor_present &&
e3131f1c81448a drivers/hv/hv.c         Dexuan Cui        2023-08-24  167  		    (hv_isolation_type_snp() || hv_isolation_type_tdx())) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  168  			ret = set_memory_decrypted((unsigned long)
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  169  				hv_cpu->synic_message_page, 1);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  170  			if (ret) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  171  				pr_err("Failed to decrypt SYNIC msg page: %d\n", ret);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  172  				hv_cpu->synic_message_page = NULL;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  173  
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  174  				/*
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  175  				 * Free the event page here so that hv_synic_free()
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  176  				 * won't later try to re-encrypt it.
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  177  				 */
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  178  				free_page((unsigned long)hv_cpu->synic_event_page);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  179  				hv_cpu->synic_event_page = NULL;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  180  				goto err;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  181  			}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  182  
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  183  			ret = set_memory_decrypted((unsigned long)
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  184  				hv_cpu->synic_event_page, 1);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  185  			if (ret) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  186  				pr_err("Failed to decrypt SYNIC event page: %d\n", ret);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  187  				hv_cpu->synic_event_page = NULL;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  188  				goto err;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  189  			}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  190  
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  191  			memset(hv_cpu->synic_message_page, 0, PAGE_SIZE);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  192  			memset(hv_cpu->synic_event_page, 0, PAGE_SIZE);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  193  		}
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  194  	}
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  195  
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  196  	return 0;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  197  
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  198  err:
572086325ce9a9 drivers/hv/hv.c         Michael Kelley    2018-08-02  199  	/*
572086325ce9a9 drivers/hv/hv.c         Michael Kelley    2018-08-02  200  	 * Any memory allocations that succeeded will be freed when
572086325ce9a9 drivers/hv/hv.c         Michael Kelley    2018-08-02  201  	 * the caller cleans up by calling hv_synic_free()
572086325ce9a9 drivers/hv/hv.c         Michael Kelley    2018-08-02  202  	 */
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  203  	return ret;
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  204  }
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  205  
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  206  
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  207  void hv_synic_free(void)
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  208  {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  209  	int cpu, ret;
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  210  
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  211  	for_each_present_cpu(cpu) {
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  212  		struct hv_per_cpu_context *hv_cpu
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  213  			= per_cpu_ptr(hv_context.cpu_context, cpu);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  214  
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  215  		/* It's better to leak the page if the encryption fails. */
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  216  		if (ms_hyperv.paravisor_present && hv_isolation_type_tdx()) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  217  			if (hv_cpu->post_msg_page) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24 @218  				ret = set_memory_encrypted((unsigned long)
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  219  					hv_cpu->post_msg_page, 1);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  220  				if (ret) {
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  221  					pr_err("Failed to encrypt post msg page: %d\n", ret);
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  222  					hv_cpu->post_msg_page = NULL;
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  223  				}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  224  			}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  225  		}
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  226  
68f2f2bc163d44 drivers/hv/hv.c         Dexuan Cui        2023-08-24  227  		if (!ms_hyperv.paravisor_present &&
e3131f1c81448a drivers/hv/hv.c         Dexuan Cui        2023-08-24  228  		    (hv_isolation_type_snp() || hv_isolation_type_tdx())) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  229  			if (hv_cpu->synic_message_page) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  230  				ret = set_memory_encrypted((unsigned long)
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  231  					hv_cpu->synic_message_page, 1);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  232  				if (ret) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  233  					pr_err("Failed to encrypt SYNIC msg page: %d\n", ret);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  234  					hv_cpu->synic_message_page = NULL;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  235  				}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  236  			}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  237  
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  238  			if (hv_cpu->synic_event_page) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  239  				ret = set_memory_encrypted((unsigned long)
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  240  					hv_cpu->synic_event_page, 1);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  241  				if (ret) {
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  242  					pr_err("Failed to encrypt SYNIC event page: %d\n", ret);
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  243  					hv_cpu->synic_event_page = NULL;
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  244  				}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  245  			}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  246  		}
193061ea0a50c1 drivers/hv/hv.c         Tianyu Lan        2023-08-18  247  
23378295042a4b drivers/hv/hv.c         Dexuan Cui        2023-08-24  248  		free_page((unsigned long)hv_cpu->post_msg_page);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  249  		free_page((unsigned long)hv_cpu->synic_event_page);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  250  		free_page((unsigned long)hv_cpu->synic_message_page);
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  251  	}
37cdd991fac810 drivers/hv/hv.c         Stephen Hemminger 2017-02-11  252  
9f01ec53458d9e drivers/hv/hv.c         K. Y. Srinivasan  2015-08-05  253  	kfree(hv_context.hv_numa_map);
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  254  }
2608fb65310341 drivers/hv/hv.c         Jason Wang        2013-06-19  255  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

