Return-Path: <kvm+bounces-66466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C22ACD5559
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 10:31:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AAD73008D52
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 09:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC26331195B;
	Mon, 22 Dec 2025 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dHa/sua5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436FF38DEC;
	Mon, 22 Dec 2025 09:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766395910; cv=none; b=U03yZ/gnPEjphKYbVXRBL/sJQn6kd9CN+QpJ4jXCMcQaSMhDa0H4jW+abWy6CdqSInufTPcyzfRZdmoww+ZB9qi/zdVWmTJamHNSOqzeGAPU6l9hNOK9V175V5/c/r+Q0whrcr+msV67Dfn3SKtndPIUMgm/fdSiv9urv+ag4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766395910; c=relaxed/simple;
	bh=qnUiNv3V9dqP60e7BcGstaSV3cjRHe8pm7xhofe8Q/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h29on9U2rLrBmtF1NtCiq2A6ce08MfpqY/VSxQmGqb8AiwBLFK5WRHQFDki3iTRDAW2LGz7ZFyV14LySQAOyMQlwYuPsHi+Uv4th5sh3Z2wK5+uQRsHSKcQgRiEG3tozj+elrq/FfGWF4jw1zKcgTrVg7ee341wcTlxTocmEncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dHa/sua5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766395908; x=1797931908;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qnUiNv3V9dqP60e7BcGstaSV3cjRHe8pm7xhofe8Q/Q=;
  b=dHa/sua5wXNLndyAp61e3+8hni1LS+9rreCsDVXVxsPh+usbDL2FdGzc
   GWu1ZuewqOjzlHUimmIOQWPv4ghtn7aOt/fcArN6g0jDzzXFw914GIKW8
   dE863CFHQhwNPiBntCylQmxHeVd0KHdtOEMSpl1Gt3DeQfAyMD9Cyqj+2
   JcFDBvJjA2CqSPVcOJX6exajTRI1rwd84sBT30WICnD04yoxI6WzFOdja
   oWGLE6x+rlLLdbQ/yQoyGx4b0/rBaafvWH7JxrePaiQ/JnaBAYHVUJnjS
   +X6FLN8GSuW1me2P9WyXAR0O7iRV4e4w2ISQGDIsOPuc1f0m4lsw1u2by
   g==;
X-CSE-ConnectionGUID: gLCsEjB9QkyIQAyB7onASQ==
X-CSE-MsgGUID: EE1UlZ2jS+6Dzhsn1bFiKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="68003489"
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="68003489"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 01:31:48 -0800
X-CSE-ConnectionGUID: NDuSmUycRtWOBFruADL30w==
X-CSE-MsgGUID: EowbdjfQR3m7f3nwp1RmhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="199236189"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 22 Dec 2025 01:31:44 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXcGT-000000000KP-3M5u;
	Mon, 22 Dec 2025 09:31:41 +0000
Date: Mon, 22 Dec 2025 17:31:23 +0800
From: kernel test robot <lkp@intel.com>
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v2 5/9] sched/fair: Wire up yield deboost in
 yield_to_task_fair()
Message-ID: <202512221734.SzKNollL-lkp@intel.com>
References: <20251219035334.39790-6-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219035334.39790-6-kernellwp@gmail.com>

Hi Wanpeng,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next tip/sched/core peterz-queue/sched/core tip/master linus/master v6.19-rc2 next-20251219]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wanpeng-Li/sched-fair-Add-rate-limiting-and-validation-helpers/20251219-125353
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251219035334.39790-6-kernellwp%40gmail.com
patch subject: [PATCH v2 5/9] sched/fair: Wire up yield deboost in yield_to_task_fair()
config: i386-randconfig-003-20251222 (https://download.01.org/0day-ci/archive/20251222/202512221734.SzKNollL-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221734.SzKNollL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221734.SzKNollL-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: kernel/sched/fair.o: in function `yield_deboost_calculate_penalty':
>> kernel/sched/fair.c:9213:(.text+0x278d): undefined reference to `__udivdi3'


vim +9213 kernel/sched/fair.c

9a700d273608de Wanpeng Li 2025-12-19  9176  
9a700d273608de Wanpeng Li 2025-12-19  9177  /*
9a700d273608de Wanpeng Li 2025-12-19  9178   * Calculate vruntime penalty for yield deboost.
9a700d273608de Wanpeng Li 2025-12-19  9179   *
9a700d273608de Wanpeng Li 2025-12-19  9180   * The penalty is based on:
9a700d273608de Wanpeng Li 2025-12-19  9181   * - Fairness gap: vruntime difference between yielding and target tasks
9a700d273608de Wanpeng Li 2025-12-19  9182   * - Scheduling granularity: base unit for penalty calculation
9a700d273608de Wanpeng Li 2025-12-19  9183   * - Queue size: adaptive caps to prevent starvation in larger queues
9a700d273608de Wanpeng Li 2025-12-19  9184   *
9a700d273608de Wanpeng Li 2025-12-19  9185   * Queue-size-based caps (multiplier of granularity):
9a700d273608de Wanpeng Li 2025-12-19  9186   *   2 tasks:  6.0x - Strongest push for 2-task ping-pong scenarios
9a700d273608de Wanpeng Li 2025-12-19  9187   *   3 tasks:  4.0x
9a700d273608de Wanpeng Li 2025-12-19  9188   *   4-6:      2.5x
9a700d273608de Wanpeng Li 2025-12-19  9189   *   7-8:      2.0x
9a700d273608de Wanpeng Li 2025-12-19  9190   *   9-12:     1.5x
9a700d273608de Wanpeng Li 2025-12-19  9191   *   >12:      1.0x - Minimal push to avoid starvation
9a700d273608de Wanpeng Li 2025-12-19  9192   *
9a700d273608de Wanpeng Li 2025-12-19  9193   * Returns the calculated penalty value.
9a700d273608de Wanpeng Li 2025-12-19  9194   */
9a700d273608de Wanpeng Li 2025-12-19  9195  static u64 __maybe_unused
9a700d273608de Wanpeng Li 2025-12-19  9196  yield_deboost_calculate_penalty(struct rq *rq, struct sched_entity *se_y_lca,
9a700d273608de Wanpeng Li 2025-12-19  9197  				struct sched_entity *se_t_lca,
9a700d273608de Wanpeng Li 2025-12-19  9198  				struct task_struct *p_target, int h_nr_queued)
9a700d273608de Wanpeng Li 2025-12-19  9199  {
9a700d273608de Wanpeng Li 2025-12-19  9200  	u64 gran, need, penalty, maxp;
9a700d273608de Wanpeng Li 2025-12-19  9201  	u64 weighted_need, base;
9a700d273608de Wanpeng Li 2025-12-19  9202  
9a700d273608de Wanpeng Li 2025-12-19  9203  	gran = calc_delta_fair(sysctl_sched_base_slice, se_y_lca);
9a700d273608de Wanpeng Li 2025-12-19  9204  
9a700d273608de Wanpeng Li 2025-12-19  9205  	/* Calculate fairness gap */
9a700d273608de Wanpeng Li 2025-12-19  9206  	need = 0;
9a700d273608de Wanpeng Li 2025-12-19  9207  	if (se_t_lca->vruntime > se_y_lca->vruntime)
9a700d273608de Wanpeng Li 2025-12-19  9208  		need = se_t_lca->vruntime - se_y_lca->vruntime;
9a700d273608de Wanpeng Li 2025-12-19  9209  
9a700d273608de Wanpeng Li 2025-12-19  9210  	/* Base penalty is granularity plus 110% of fairness gap */
9a700d273608de Wanpeng Li 2025-12-19  9211  	penalty = gran;
9a700d273608de Wanpeng Li 2025-12-19  9212  	if (need) {
9a700d273608de Wanpeng Li 2025-12-19 @9213  		weighted_need = need + need / 10;
9a700d273608de Wanpeng Li 2025-12-19  9214  		if (weighted_need > U64_MAX - penalty)
9a700d273608de Wanpeng Li 2025-12-19  9215  			weighted_need = U64_MAX - penalty;
9a700d273608de Wanpeng Li 2025-12-19  9216  		penalty += weighted_need;
9a700d273608de Wanpeng Li 2025-12-19  9217  	}
9a700d273608de Wanpeng Li 2025-12-19  9218  
9a700d273608de Wanpeng Li 2025-12-19  9219  	/* Apply debounce to reduce ping-pong */
9a700d273608de Wanpeng Li 2025-12-19  9220  	penalty = yield_deboost_apply_debounce(rq, p_target, penalty, need, gran);
9a700d273608de Wanpeng Li 2025-12-19  9221  
9a700d273608de Wanpeng Li 2025-12-19  9222  	/* Queue-size-based upper bound */
9a700d273608de Wanpeng Li 2025-12-19  9223  	if (h_nr_queued == 2)
9a700d273608de Wanpeng Li 2025-12-19  9224  		maxp = gran * 6;
9a700d273608de Wanpeng Li 2025-12-19  9225  	else if (h_nr_queued == 3)
9a700d273608de Wanpeng Li 2025-12-19  9226  		maxp = gran * 4;
9a700d273608de Wanpeng Li 2025-12-19  9227  	else if (h_nr_queued <= 6)
9a700d273608de Wanpeng Li 2025-12-19  9228  		maxp = (gran * 5) / 2;
9a700d273608de Wanpeng Li 2025-12-19  9229  	else if (h_nr_queued <= 8)
9a700d273608de Wanpeng Li 2025-12-19  9230  		maxp = gran * 2;
9a700d273608de Wanpeng Li 2025-12-19  9231  	else if (h_nr_queued <= 12)
9a700d273608de Wanpeng Li 2025-12-19  9232  		maxp = (gran * 3) / 2;
9a700d273608de Wanpeng Li 2025-12-19  9233  	else
9a700d273608de Wanpeng Li 2025-12-19  9234  		maxp = gran;
9a700d273608de Wanpeng Li 2025-12-19  9235  
9a700d273608de Wanpeng Li 2025-12-19  9236  	penalty = clamp(penalty, gran, maxp);
9a700d273608de Wanpeng Li 2025-12-19  9237  
9a700d273608de Wanpeng Li 2025-12-19  9238  	/* Baseline push when no fairness gap exists */
9a700d273608de Wanpeng Li 2025-12-19  9239  	if (need == 0) {
9a700d273608de Wanpeng Li 2025-12-19  9240  		if (h_nr_queued == 3)
9a700d273608de Wanpeng Li 2025-12-19  9241  			base = (gran * 15) / 16;
9a700d273608de Wanpeng Li 2025-12-19  9242  		else if (h_nr_queued >= 4 && h_nr_queued <= 6)
9a700d273608de Wanpeng Li 2025-12-19  9243  			base = (gran * 5) / 8;
9a700d273608de Wanpeng Li 2025-12-19  9244  		else if (h_nr_queued >= 7 && h_nr_queued <= 8)
9a700d273608de Wanpeng Li 2025-12-19  9245  			base = gran / 2;
9a700d273608de Wanpeng Li 2025-12-19  9246  		else if (h_nr_queued >= 9 && h_nr_queued <= 12)
9a700d273608de Wanpeng Li 2025-12-19  9247  			base = (gran * 3) / 8;
9a700d273608de Wanpeng Li 2025-12-19  9248  		else if (h_nr_queued > 12)
9a700d273608de Wanpeng Li 2025-12-19  9249  			base = gran / 4;
9a700d273608de Wanpeng Li 2025-12-19  9250  		else
9a700d273608de Wanpeng Li 2025-12-19  9251  			base = gran;
9a700d273608de Wanpeng Li 2025-12-19  9252  
9a700d273608de Wanpeng Li 2025-12-19  9253  		if (penalty < base)
9a700d273608de Wanpeng Li 2025-12-19  9254  			penalty = base;
9a700d273608de Wanpeng Li 2025-12-19  9255  	}
9a700d273608de Wanpeng Li 2025-12-19  9256  
9a700d273608de Wanpeng Li 2025-12-19  9257  	return penalty;
9a700d273608de Wanpeng Li 2025-12-19  9258  }
9a700d273608de Wanpeng Li 2025-12-19  9259  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

