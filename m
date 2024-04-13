Return-Path: <kvm+bounces-14598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C758A3FA1
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 01:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE70B28210D
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 23:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199F058AA5;
	Sat, 13 Apr 2024 23:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BFyQpKOw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4E12901;
	Sat, 13 Apr 2024 23:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713051920; cv=none; b=SN1oAV+qgujOe3Q3LzncQqn08UyoCTFyhLjnXMYkiPKvLw96X7QwFFioqDGlAeAywe5tP9qjl4abs8ARh9bjQSrBGrRN/AMGv39Vm2Av6WPZzl/Wn6ChSeuWQ0f171Hla59cv6tLkxI36G/QGaCzfgNQhZMd0f2uk5+8rzeYB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713051920; c=relaxed/simple;
	bh=9hm8OrAg2N/WUuvSJDeD6ZbYkByijmv/zU3TAtzN+Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9GCJzC6z64OX6bdC4i0lBB9Hgr6C6eRMC/qahAT3d8WJYShpFeeN+QSCrQA7Hfu4i4xkSFOPaYtCLP3D6TxMZkaOmUS6QQm7ogT+FkXavTRPfrVKM2PfPBuNyXEFIFdgYXcXzJe3fQkjZJkpBpgj/tBq5P43CKIpluYPGJORAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BFyQpKOw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713051917; x=1744587917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9hm8OrAg2N/WUuvSJDeD6ZbYkByijmv/zU3TAtzN+Tw=;
  b=BFyQpKOwy1tbvjIshOkqUgB7Iu4UyP+pohepX12wm5EPAQ8UNhlQCHCX
   7WarOLsok24OFdG++BfRQ1oCgODrZKD3e0G5UjmWSsPeoe+ggU88Oh6j+
   ZY/ghYfOSgvMN+m2ac0dcAXGwBQHJ+IfqTfJHwy8th+VZl6avdanu42TW
   VOPjJ/JucKDvyGvAJtm1LJE0cni9/uFxlfRu4OxAiD9ECjbiXtzAYldLl
   npmUQ0zMWCWl0zpmXz2Qe+6An/2o/3Y23HLvjCgLGj97FNUhKa9uB722Q
   BgCBex4zBK1TA55rKfEv7gxcljCnTIRNAHi5C30/ERX8uYrNpCQrxN+yh
   w==;
X-CSE-ConnectionGUID: 8qEQHBqiQTOgXtxgtJisOw==
X-CSE-MsgGUID: EUIC1ngkQV+vWnRwG/rQ9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11043"; a="19191134"
X-IronPort-AV: E=Sophos;i="6.07,200,1708416000"; 
   d="scan'208";a="19191134"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2024 16:45:17 -0700
X-CSE-ConnectionGUID: r8838oHTSYyRFb6qMs8paw==
X-CSE-MsgGUID: NsndFaTgRmm+2Be0y8gB7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,200,1708416000"; 
   d="scan'208";a="22134469"
Received: from unknown (HELO 23c141fc0fd8) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 13 Apr 2024 16:45:12 -0700
Received: from kbuild by 23c141fc0fd8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rvn3V-00036q-1w;
	Sat, 13 Apr 2024 23:45:09 +0000
Date: Sun, 14 Apr 2024 07:44:36 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm
 guest
Message-ID: <202404140723.GKwnJxeZ-lkp@intel.com>
References: <20240412084309.1733783-34-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084309.1733783-34-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvmarm/next]
[also build test ERROR on kvm/queue arm64/for-next/core linus/master v6.9-rc3 next-20240412]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/KVM-Prepare-for-handling-only-shared-mappings-in-mmu_notifier-events/20240412-170311
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
patch link:    https://lore.kernel.org/r/20240412084309.1733783-34-steven.price%40arm.com
patch subject: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm guest
config: arm64-randconfig-r064-20240414 (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 8b3b4a92adee40483c27f26c478a384cd69c6f05)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404140723.GKwnJxeZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kvm/arm.c:9:
   In file included from include/linux/entry-kvm.h:6:
   In file included from include/linux/resume_user_mode.h:8:
   In file included from include/linux/memcontrol.h:21:
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
>> arch/arm64/kvm/arm.c:1115:13: error: no member named 'irq_level' in 'struct kvm_pmu'
    1115 |                         if (pmu->irq_level) {
         |                             ~~~  ^
>> arch/arm64/kvm/arm.c:1117:5: error: call to undeclared function 'arm_pmu_set_phys_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1117 |                                 arm_pmu_set_phys_irq(false);
         |                                 ^
   arch/arm64/kvm/arm.c:1224:4: error: call to undeclared function 'arm_pmu_set_phys_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1224 |                         arm_pmu_set_phys_irq(true);
         |                         ^
   5 warnings and 3 errors generated.


vim +1115 arch/arm64/kvm/arm.c

  1044	
  1045	/**
  1046	 * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  1047	 * @vcpu:	The VCPU pointer
  1048	 *
  1049	 * This function is called through the VCPU_RUN ioctl called from user space. It
  1050	 * will execute VM code in a loop until the time slice for the process is used
  1051	 * or some emulation is needed from user space in which case the function will
  1052	 * return with return value 0 and with the kvm_run structure filled in with the
  1053	 * required data for the requested emulation.
  1054	 */
  1055	int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
  1056	{
  1057		struct kvm_run *run = vcpu->run;
  1058		int ret;
  1059	
  1060		if (run->exit_reason == KVM_EXIT_MMIO) {
  1061			ret = kvm_handle_mmio_return(vcpu);
  1062			if (ret)
  1063				return ret;
  1064		}
  1065	
  1066		vcpu_load(vcpu);
  1067	
  1068		if (run->immediate_exit) {
  1069			ret = -EINTR;
  1070			goto out;
  1071		}
  1072	
  1073		kvm_sigset_activate(vcpu);
  1074	
  1075		ret = 1;
  1076		run->exit_reason = KVM_EXIT_UNKNOWN;
  1077		run->flags = 0;
  1078		while (ret > 0) {
  1079			bool pmu_stopped = false;
  1080	
  1081			/*
  1082			 * Check conditions before entering the guest
  1083			 */
  1084			ret = xfer_to_guest_mode_handle_work(vcpu);
  1085			if (!ret)
  1086				ret = 1;
  1087	
  1088			if (ret > 0)
  1089				ret = check_vcpu_requests(vcpu);
  1090	
  1091			/*
  1092			 * Preparing the interrupts to be injected also
  1093			 * involves poking the GIC, which must be done in a
  1094			 * non-preemptible context.
  1095			 */
  1096			preempt_disable();
  1097	
  1098			/*
  1099			 * The VMID allocator only tracks active VMIDs per
  1100			 * physical CPU, and therefore the VMID allocated may not be
  1101			 * preserved on VMID roll-over if the task was preempted,
  1102			 * making a thread's VMID inactive. So we need to call
  1103			 * kvm_arm_vmid_update() in non-premptible context.
  1104			 */
  1105			if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
  1106			    has_vhe())
  1107				__load_stage2(vcpu->arch.hw_mmu,
  1108					      vcpu->arch.hw_mmu->arch);
  1109	
  1110			kvm_pmu_flush_hwstate(vcpu);
  1111	
  1112			if (vcpu_is_rec(vcpu)) {
  1113				struct kvm_pmu *pmu = &vcpu->arch.pmu;
  1114	
> 1115				if (pmu->irq_level) {
  1116					pmu_stopped = true;
> 1117					arm_pmu_set_phys_irq(false);
  1118				}
  1119			}
  1120	
  1121			local_irq_disable();
  1122	
  1123			kvm_vgic_flush_hwstate(vcpu);
  1124	
  1125			kvm_pmu_update_vcpu_events(vcpu);
  1126	
  1127			/*
  1128			 * Ensure we set mode to IN_GUEST_MODE after we disable
  1129			 * interrupts and before the final VCPU requests check.
  1130			 * See the comment in kvm_vcpu_exiting_guest_mode() and
  1131			 * Documentation/virt/kvm/vcpu-requests.rst
  1132			 */
  1133			smp_store_mb(vcpu->mode, IN_GUEST_MODE);
  1134	
  1135			if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
  1136				vcpu->mode = OUTSIDE_GUEST_MODE;
  1137				isb(); /* Ensure work in x_flush_hwstate is committed */
  1138				kvm_pmu_sync_hwstate(vcpu);
  1139				if (static_branch_unlikely(&userspace_irqchip_in_use))
  1140					kvm_timer_sync_user(vcpu);
  1141				kvm_vgic_sync_hwstate(vcpu);
  1142				local_irq_enable();
  1143				preempt_enable();
  1144				continue;
  1145			}
  1146	
  1147			kvm_arm_setup_debug(vcpu);
  1148			kvm_arch_vcpu_ctxflush_fp(vcpu);
  1149	
  1150			/**************************************************************
  1151			 * Enter the guest
  1152			 */
  1153			trace_kvm_entry(*vcpu_pc(vcpu));
  1154			guest_timing_enter_irqoff();
  1155	
  1156			if (vcpu_is_rec(vcpu))
  1157				ret = kvm_rec_enter(vcpu);
  1158			else
  1159				ret = kvm_arm_vcpu_enter_exit(vcpu);
  1160	
  1161			vcpu->mode = OUTSIDE_GUEST_MODE;
  1162			vcpu->stat.exits++;
  1163			/*
  1164			 * Back from guest
  1165			 *************************************************************/
  1166	
  1167			kvm_arm_clear_debug(vcpu);
  1168	
  1169			/*
  1170			 * We must sync the PMU state before the vgic state so
  1171			 * that the vgic can properly sample the updated state of the
  1172			 * interrupt line.
  1173			 */
  1174			kvm_pmu_sync_hwstate(vcpu);
  1175	
  1176			/*
  1177			 * Sync the vgic state before syncing the timer state because
  1178			 * the timer code needs to know if the virtual timer
  1179			 * interrupts are active.
  1180			 */
  1181			kvm_vgic_sync_hwstate(vcpu);
  1182	
  1183			/*
  1184			 * Sync the timer hardware state before enabling interrupts as
  1185			 * we don't want vtimer interrupts to race with syncing the
  1186			 * timer virtual interrupt state.
  1187			 */
  1188			if (static_branch_unlikely(&userspace_irqchip_in_use))
  1189				kvm_timer_sync_user(vcpu);
  1190	
  1191			kvm_arch_vcpu_ctxsync_fp(vcpu);
  1192	
  1193			/*
  1194			 * We must ensure that any pending interrupts are taken before
  1195			 * we exit guest timing so that timer ticks are accounted as
  1196			 * guest time. Transiently unmask interrupts so that any
  1197			 * pending interrupts are taken.
  1198			 *
  1199			 * Per ARM DDI 0487G.b section D1.13.4, an ISB (or other
  1200			 * context synchronization event) is necessary to ensure that
  1201			 * pending interrupts are taken.
  1202			 */
  1203			if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
  1204				local_irq_enable();
  1205				isb();
  1206				local_irq_disable();
  1207			}
  1208	
  1209			guest_timing_exit_irqoff();
  1210	
  1211			local_irq_enable();
  1212	
  1213			/* Exit types that need handling before we can be preempted */
  1214			if (!vcpu_is_rec(vcpu)) {
  1215				trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
  1216					       *vcpu_pc(vcpu));
  1217	
  1218				handle_exit_early(vcpu, ret);
  1219			}
  1220	
  1221			preempt_enable();
  1222	
  1223			if (pmu_stopped)
  1224				arm_pmu_set_phys_irq(true);
  1225	
  1226			/*
  1227			 * The ARMv8 architecture doesn't give the hypervisor
  1228			 * a mechanism to prevent a guest from dropping to AArch32 EL0
  1229			 * if implemented by the CPU. If we spot the guest in such
  1230			 * state and that we decided it wasn't supposed to do so (like
  1231			 * with the asymmetric AArch32 case), return to userspace with
  1232			 * a fatal error.
  1233			 */
  1234			if (vcpu_mode_is_bad_32bit(vcpu)) {
  1235				/*
  1236				 * As we have caught the guest red-handed, decide that
  1237				 * it isn't fit for purpose anymore by making the vcpu
  1238				 * invalid. The VMM can try and fix it by issuing  a
  1239				 * KVM_ARM_VCPU_INIT if it really wants to.
  1240				 */
  1241				vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
  1242				ret = ARM_EXCEPTION_IL;
  1243			}
  1244	
  1245			if (vcpu_is_rec(vcpu))
  1246				ret = handle_rme_exit(vcpu, ret);
  1247			else
  1248				ret = handle_exit(vcpu, ret);
  1249		}
  1250	
  1251		/* Tell userspace about in-kernel device output levels */
  1252		if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
  1253			kvm_timer_update_run(vcpu);
  1254			kvm_pmu_update_run(vcpu);
  1255		}
  1256	
  1257		kvm_sigset_deactivate(vcpu);
  1258	
  1259	out:
  1260		/*
  1261		 * In the unlikely event that we are returning to userspace
  1262		 * with pending exceptions or PC adjustment, commit these
  1263		 * adjustments in order to give userspace a consistent view of
  1264		 * the vcpu state. Note that this relies on __kvm_adjust_pc()
  1265		 * being preempt-safe on VHE.
  1266		 */
  1267		if (unlikely(vcpu_get_flag(vcpu, PENDING_EXCEPTION) ||
  1268			     vcpu_get_flag(vcpu, INCREMENT_PC)))
  1269			kvm_call_hyp(__kvm_adjust_pc, vcpu);
  1270	
  1271		vcpu_put(vcpu);
  1272		return ret;
  1273	}
  1274	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

