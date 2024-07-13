Return-Path: <kvm+bounces-21602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 288FC93052D
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 12:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A94E41F21E04
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 10:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C61A132133;
	Sat, 13 Jul 2024 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKZkd3Lg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD62745E2;
	Sat, 13 Jul 2024 10:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720866865; cv=none; b=WG4pAGV1S5DAzfkjRQC4iqTbkJLpC1ngjW7IUeVZTKRIps1Fmdja5AbhJ5QAueXmIMqMr1qopbTGJc7o2ld1NMN/b5u3OCNs3tWKRvh1X12t0zHzEfwM3jBZ4cAIPdSbznA3t5mn37OsMrTfNcHbElTrCYuYhw59Ly1ZZX0JJHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720866865; c=relaxed/simple;
	bh=eekrq+WPHhfQN52oa909XK53IiDji33oe6Nak6e7ZAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKJ31oOt1xUEbfM92fW97IQZDdPKG/XtsHxUG/lkpU68vhWiS7JctJDwK6BoSdJv2LHf5Kz+HvdK5XGicZ+kdW1aBEIMoKxkWyocBPtIlj8wR0eSkswPFvslDeSxS19mNylROGUEvBkusYtGUvSu+dTlOhaO7uipaFlV/0QLeUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKZkd3Lg; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720866863; x=1752402863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eekrq+WPHhfQN52oa909XK53IiDji33oe6Nak6e7ZAY=;
  b=bKZkd3LgvuBYApYriEyEmif6dGfG5HbXXD3aqo+ig4pc63vVgeOvfFh+
   EyTgK8y70Va7aDGx79fqZw0WxozXwB4J4+Cs78Shucj8GZIe04fHp6BLW
   lEC/aWBtphecU8jjnfvB6eNOxAazd7f+mxp2eEx9tqmXALbGu6LRDf+p3
   E6lWVCEbh5VyTQYv/W67L46JaU39opVxiyO2NLEMrGxmisavdwE94+R3k
   7Nw8cQaX6Psb8z/QAr+/Awrn+ukFrxb9T7MpGmBrcnRwuQNHS5Ri41PcI
   NFS67wOl8/zWXBtpgGeKfz/PwMeQiJS/u+j7sDJsvT8VvTvHDortnl+Vj
   w==;
X-CSE-ConnectionGUID: nvAwRgteTY+ryWvQGExT+Q==
X-CSE-MsgGUID: MfWl9tQLSGCSFkXHAApGkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11131"; a="28913591"
X-IronPort-AV: E=Sophos;i="6.09,205,1716274800"; 
   d="scan'208";a="28913591"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 03:34:23 -0700
X-CSE-ConnectionGUID: qRJeKVu+R4W3DHncw8ww7w==
X-CSE-MsgGUID: f0vlLECuTcCCaqHpqU4MRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,205,1716274800"; 
   d="scan'208";a="54095786"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 13 Jul 2024 03:34:16 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sSa4z-000byj-1b;
	Sat, 13 Jul 2024 10:34:13 +0000
Date: Sat, 13 Jul 2024 18:33:23 +0800
From: kernel test robot <lkp@intel.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ravi.bangoria@amd.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
	peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
	arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
	nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
	babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
	ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com,
	jmattson@google.com
Subject: Re: [PATCH v2 1/4] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
Message-ID: <202407131818.mNFDcgjd-lkp@intel.com>
References: <20240712093943.1288-2-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712093943.1288-2-ravi.bangoria@amd.com>

Hi Ravi,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/master]
[also build test ERROR on next-20240712]
[cannot apply to tip/x86/core kvm/queue linus/master tip/auto-latest kvm/linux-next v6.10-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ravi-Bangoria/x86-split_lock-Move-Split-and-Bus-lock-code-to-a-dedicated-file/20240712-175306
base:   tip/master
patch link:    https://lore.kernel.org/r/20240712093943.1288-2-ravi.bangoria%40amd.com
patch subject: [PATCH v2 1/4] x86/split_lock: Move Split and Bus lock code to a dedicated file
config: i386-buildonly-randconfig-002-20240713 (https://download.01.org/0day-ci/archive/20240713/202407131818.mNFDcgjd-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240713/202407131818.mNFDcgjd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407131818.mNFDcgjd-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kernel/cpu/bus_lock.c:219:16: error: no member named 'reported_split_lock' in 'struct task_struct'
     219 |         if (!current->reported_split_lock)
         |              ~~~~~~~  ^
   arch/x86/kernel/cpu/bus_lock.c:222:11: error: no member named 'reported_split_lock' in 'struct task_struct'
     222 |         current->reported_split_lock = 1;
         |         ~~~~~~~  ^
>> arch/x86/kernel/cpu/bus_lock.c:250:6: error: redefinition of 'handle_guest_split_lock'
     250 | bool handle_guest_split_lock(unsigned long ip)
         |      ^
   arch/x86/include/asm/cpu.h:42:20: note: previous definition is here
      42 | static inline bool handle_guest_split_lock(unsigned long ip)
         |                    ^
>> arch/x86/kernel/cpu/bus_lock.c:292:6: error: redefinition of 'handle_user_split_lock'
     292 | bool handle_user_split_lock(struct pt_regs *regs, long error_code)
         |      ^
   arch/x86/include/asm/cpu.h:37:20: note: previous definition is here
      37 | static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
         |                    ^
>> arch/x86/kernel/cpu/bus_lock.c:300:6: error: redefinition of 'handle_bus_lock'
     300 | void handle_bus_lock(struct pt_regs *regs)
         |      ^
   arch/x86/include/asm/cpu.h:47:20: note: previous definition is here
      47 | static inline void handle_bus_lock(struct pt_regs *regs) {}
         |                    ^
>> arch/x86/kernel/cpu/bus_lock.c:401:13: error: redefinition of 'sld_setup'
     401 | void __init sld_setup(struct cpuinfo_x86 *c)
         |             ^
   arch/x86/include/asm/cpu.h:36:27: note: previous definition is here
      36 | static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
         |                           ^
   6 errors generated.


vim +219 arch/x86/kernel/cpu/bus_lock.c

   213	
   214	static void split_lock_warn(unsigned long ip)
   215	{
   216		struct delayed_work *work;
   217		int cpu;
   218	
 > 219		if (!current->reported_split_lock)
   220			pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
   221					    current->comm, current->pid, ip);
   222		current->reported_split_lock = 1;
   223	
   224		if (sysctl_sld_mitigate) {
   225			/*
   226			 * misery factor #1:
   227			 * sleep 10ms before trying to execute split lock.
   228			 */
   229			if (msleep_interruptible(10) > 0)
   230				return;
   231			/*
   232			 * Misery factor #2:
   233			 * only allow one buslocked disabled core at a time.
   234			 */
   235			if (down_interruptible(&buslock_sem) == -EINTR)
   236				return;
   237			work = &sl_reenable_unlock;
   238		} else {
   239			work = &sl_reenable;
   240		}
   241	
   242		cpu = get_cpu();
   243		schedule_delayed_work_on(cpu, work, 2);
   244	
   245		/* Disable split lock detection on this CPU to make progress */
   246		sld_update_msr(false);
   247		put_cpu();
   248	}
   249	
 > 250	bool handle_guest_split_lock(unsigned long ip)
   251	{
   252		if (sld_state == sld_warn) {
   253			split_lock_warn(ip);
   254			return true;
   255		}
   256	
   257		pr_warn_once("#AC: %s/%d %s split_lock trap at address: 0x%lx\n",
   258			     current->comm, current->pid,
   259			     sld_state == sld_fatal ? "fatal" : "bogus", ip);
   260	
   261		current->thread.error_code = 0;
   262		current->thread.trap_nr = X86_TRAP_AC;
   263		force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
   264		return false;
   265	}
   266	EXPORT_SYMBOL_GPL(handle_guest_split_lock);
   267	
   268	void bus_lock_init(void)
   269	{
   270		u64 val;
   271	
   272		if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
   273			return;
   274	
   275		rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
   276	
   277		if ((boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
   278		    (sld_state == sld_warn || sld_state == sld_fatal)) ||
   279		    sld_state == sld_off) {
   280			/*
   281			 * Warn and fatal are handled by #AC for split lock if #AC for
   282			 * split lock is supported.
   283			 */
   284			val &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
   285		} else {
   286			val |= DEBUGCTLMSR_BUS_LOCK_DETECT;
   287		}
   288	
   289		wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
   290	}
   291	
 > 292	bool handle_user_split_lock(struct pt_regs *regs, long error_code)
   293	{
   294		if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
   295			return false;
   296		split_lock_warn(regs->ip);
   297		return true;
   298	}
   299	
 > 300	void handle_bus_lock(struct pt_regs *regs)
   301	{
   302		switch (sld_state) {
   303		case sld_off:
   304			break;
   305		case sld_ratelimit:
   306			/* Enforce no more than bld_ratelimit bus locks/sec. */
   307			while (!__ratelimit(&bld_ratelimit))
   308				msleep(20);
   309			/* Warn on the bus lock. */
   310			fallthrough;
   311		case sld_warn:
   312			pr_warn_ratelimited("#DB: %s/%d took a bus_lock trap at address: 0x%lx\n",
   313					    current->comm, current->pid, regs->ip);
   314			break;
   315		case sld_fatal:
   316			force_sig_fault(SIGBUS, BUS_ADRALN, NULL);
   317			break;
   318		}
   319	}
   320	
   321	/*
   322	 * CPU models that are known to have the per-core split-lock detection
   323	 * feature even though they do not enumerate IA32_CORE_CAPABILITIES.
   324	 */
   325	static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
   326		X86_MATCH_VFM(INTEL_ICELAKE_X,	0),
   327		X86_MATCH_VFM(INTEL_ICELAKE_L,	0),
   328		X86_MATCH_VFM(INTEL_ICELAKE_D,	0),
   329		{}
   330	};
   331	
   332	static void __init split_lock_setup(struct cpuinfo_x86 *c)
   333	{
   334		const struct x86_cpu_id *m;
   335		u64 ia32_core_caps;
   336	
   337		if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
   338			return;
   339	
   340		/* Check for CPUs that have support but do not enumerate it: */
   341		m = x86_match_cpu(split_lock_cpu_ids);
   342		if (m)
   343			goto supported;
   344	
   345		if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITIES))
   346			return;
   347	
   348		/*
   349		 * Not all bits in MSR_IA32_CORE_CAPS are architectural, but
   350		 * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT is.  All CPUs that set
   351		 * it have split lock detection.
   352		 */
   353		rdmsrl(MSR_IA32_CORE_CAPS, ia32_core_caps);
   354		if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
   355			goto supported;
   356	
   357		/* CPU is not in the model list and does not have the MSR bit: */
   358		return;
   359	
   360	supported:
   361		cpu_model_supports_sld = true;
   362		__split_lock_setup();
   363	}
   364	
   365	static void sld_state_show(void)
   366	{
   367		if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
   368		    !boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
   369			return;
   370	
   371		switch (sld_state) {
   372		case sld_off:
   373			pr_info("disabled\n");
   374			break;
   375		case sld_warn:
   376			if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
   377				pr_info("#AC: crashing the kernel on kernel split_locks and warning on user-space split_locks\n");
   378				if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
   379						      "x86/splitlock", NULL, splitlock_cpu_offline) < 0)
   380					pr_warn("No splitlock CPU offline handler\n");
   381			} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
   382				pr_info("#DB: warning on user-space bus_locks\n");
   383			}
   384			break;
   385		case sld_fatal:
   386			if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
   387				pr_info("#AC: crashing the kernel on kernel split_locks and sending SIGBUS on user-space split_locks\n");
   388			} else if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT)) {
   389				pr_info("#DB: sending SIGBUS on user-space bus_locks%s\n",
   390					boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ?
   391					" from non-WB" : "");
   392			}
   393			break;
   394		case sld_ratelimit:
   395			if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
   396				pr_info("#DB: setting system wide bus lock rate limit to %u/sec\n", bld_ratelimit.burst);
   397			break;
   398		}
   399	}
   400	
 > 401	void __init sld_setup(struct cpuinfo_x86 *c)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

