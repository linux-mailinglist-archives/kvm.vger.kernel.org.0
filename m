Return-Path: <kvm+bounces-30277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D4B9B8A32
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 05:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7989BB22311
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 04:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB6C13B287;
	Fri,  1 Nov 2024 04:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JCxF4zUV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D30813790B;
	Fri,  1 Nov 2024 04:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730434517; cv=none; b=LEggmDUZLAW27QC0Hm8oegruKG43HITuKNgKcOyiEIgyiHgLEEdBvQoN+D0KrmPCq4XGG+fewUGdE6wCAhbc86aw82gTyIXif+dMTEWEe08mlw3fpdPfg//8MXHGQnjTUIXUhO1n0vW1CXppcA7/wSeHjOm6ovUf7xDC7rem1h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730434517; c=relaxed/simple;
	bh=E2toS6p+Kjh05UJEGdrdnDpjoQ8I6f/jus7lC3oeKq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Md5ZdRtQqLXhFNjdnwjLTqkWphzXofttO2+UQZlrJ5ceU3DK8KSPzXwDhmlqCayReCJg3jhCPs3yFIFRm8RlV5Y4a4yif1YD54BLC5HbLlzNf00R/pU3E5RP9/rOVxWGfGii0RN2is4OAqu8KNo5LQ7U1tMdqxJOAC92yNTyNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JCxF4zUV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730434514; x=1761970514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E2toS6p+Kjh05UJEGdrdnDpjoQ8I6f/jus7lC3oeKq8=;
  b=JCxF4zUVBThdww+I45onK8XS2yrHx4HfR6tlFTX6huiIt7fhY6gDyd0t
   W/9eHepMCvwjiQ+/yCc3MHUnnygr3p9zC2ihxFwuiVtzpK3H5yKd5FoEL
   TTviTLnXPos6Acqr1MFglQP9613Pfx/O18sXIpN4tDKeDzBgIGLZAYeog
   HPt7yUHStrOueGVc3Xlv/QA0YKzGV2dfXopdKRY1x8mTvZUtKkvCmnuxq
   Vz/1XEtLOIDV0Yq861MJnKMoiiR2ScTM7ti0UJWn51/DDbdtAHEpayAqR
   ksa9HdzCeFUMPwrd7S4hlp0n/dyAp7QL+K8XMTuPDc41utuATHpESdYCP
   g==;
X-CSE-ConnectionGUID: 2SaVd1wDTpKj68akeoDk+g==
X-CSE-MsgGUID: HDyDbA8pRiOf06E2hff84Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47680062"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="47680062"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 21:15:13 -0700
X-CSE-ConnectionGUID: p0o3PYavR/aL5MPk6S2b6Q==
X-CSE-MsgGUID: +BNpXRaJRi6ey2abHeqQ7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="87623400"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 31 Oct 2024 21:15:07 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6j3w-000h7Y-1L;
	Fri, 01 Nov 2024 04:15:04 +0000
Date: Fri, 1 Nov 2024 12:14:34 +0800
From: kernel test robot <lkp@intel.com>
To: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com
Subject: Re: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
Message-ID: <202411011119.l3yRJpht-lkp@intel.com>
References: <20241031153925.36216-3-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031153925.36216-3-amit@kernel.org>

Hi Amit,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next tip/master tip/x86/core linus/master v6.12-rc5 next-20241031]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Amit-Shah/x86-cpu-bugs-add-support-for-AMD-ERAPS-feature/20241031-234332
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20241031153925.36216-3-amit%40kernel.org
patch subject: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and FLUSH_RAP_ON_VMRUN
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241101/202411011119.l3yRJpht-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241101/202411011119.l3yRJpht-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411011119.l3yRJpht-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/cpuid.c:13:
   In file included from include/linux/kvm_host.h:16:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/cpuid.c:1362:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
    1362 |                 unsigned int ebx_mask = 0;
         |                 ^
   5 warnings generated.


vim +1362 arch/x86/kvm/cpuid.c

   940	
   941	static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
   942	{
   943		struct kvm_cpuid_entry2 *entry;
   944		int r, i, max_idx;
   945	
   946		/* all calls to cpuid_count() should be made on the same cpu */
   947		get_cpu();
   948	
   949		r = -E2BIG;
   950	
   951		entry = do_host_cpuid(array, function, 0);
   952		if (!entry)
   953			goto out;
   954	
   955		switch (function) {
   956		case 0:
   957			/* Limited to the highest leaf implemented in KVM. */
   958			entry->eax = min(entry->eax, 0x24U);
   959			break;
   960		case 1:
   961			cpuid_entry_override(entry, CPUID_1_EDX);
   962			cpuid_entry_override(entry, CPUID_1_ECX);
   963			break;
   964		case 2:
   965			/*
   966			 * On ancient CPUs, function 2 entries are STATEFUL.  That is,
   967			 * CPUID(function=2, index=0) may return different results each
   968			 * time, with the least-significant byte in EAX enumerating the
   969			 * number of times software should do CPUID(2, 0).
   970			 *
   971			 * Modern CPUs, i.e. every CPU KVM has *ever* run on are less
   972			 * idiotic.  Intel's SDM states that EAX & 0xff "will always
   973			 * return 01H. Software should ignore this value and not
   974			 * interpret it as an informational descriptor", while AMD's
   975			 * APM states that CPUID(2) is reserved.
   976			 *
   977			 * WARN if a frankenstein CPU that supports virtualization and
   978			 * a stateful CPUID.0x2 is encountered.
   979			 */
   980			WARN_ON_ONCE((entry->eax & 0xff) > 1);
   981			break;
   982		/* functions 4 and 0x8000001d have additional index. */
   983		case 4:
   984		case 0x8000001d:
   985			/*
   986			 * Read entries until the cache type in the previous entry is
   987			 * zero, i.e. indicates an invalid entry.
   988			 */
   989			for (i = 1; entry->eax & 0x1f; ++i) {
   990				entry = do_host_cpuid(array, function, i);
   991				if (!entry)
   992					goto out;
   993			}
   994			break;
   995		case 6: /* Thermal management */
   996			entry->eax = 0x4; /* allow ARAT */
   997			entry->ebx = 0;
   998			entry->ecx = 0;
   999			entry->edx = 0;
  1000			break;
  1001		/* function 7 has additional index. */
  1002		case 7:
  1003			max_idx = entry->eax = min(entry->eax, 2u);
  1004			cpuid_entry_override(entry, CPUID_7_0_EBX);
  1005			cpuid_entry_override(entry, CPUID_7_ECX);
  1006			cpuid_entry_override(entry, CPUID_7_EDX);
  1007	
  1008			/* KVM only supports up to 0x7.2, capped above via min(). */
  1009			if (max_idx >= 1) {
  1010				entry = do_host_cpuid(array, function, 1);
  1011				if (!entry)
  1012					goto out;
  1013	
  1014				cpuid_entry_override(entry, CPUID_7_1_EAX);
  1015				cpuid_entry_override(entry, CPUID_7_1_EDX);
  1016				entry->ebx = 0;
  1017				entry->ecx = 0;
  1018			}
  1019			if (max_idx >= 2) {
  1020				entry = do_host_cpuid(array, function, 2);
  1021				if (!entry)
  1022					goto out;
  1023	
  1024				cpuid_entry_override(entry, CPUID_7_2_EDX);
  1025				entry->ecx = 0;
  1026				entry->ebx = 0;
  1027				entry->eax = 0;
  1028			}
  1029			break;
  1030		case 0xa: { /* Architectural Performance Monitoring */
  1031			union cpuid10_eax eax;
  1032			union cpuid10_edx edx;
  1033	
  1034			if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
  1035				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1036				break;
  1037			}
  1038	
  1039			eax.split.version_id = kvm_pmu_cap.version;
  1040			eax.split.num_counters = kvm_pmu_cap.num_counters_gp;
  1041			eax.split.bit_width = kvm_pmu_cap.bit_width_gp;
  1042			eax.split.mask_length = kvm_pmu_cap.events_mask_len;
  1043			edx.split.num_counters_fixed = kvm_pmu_cap.num_counters_fixed;
  1044			edx.split.bit_width_fixed = kvm_pmu_cap.bit_width_fixed;
  1045	
  1046			if (kvm_pmu_cap.version)
  1047				edx.split.anythread_deprecated = 1;
  1048			edx.split.reserved1 = 0;
  1049			edx.split.reserved2 = 0;
  1050	
  1051			entry->eax = eax.full;
  1052			entry->ebx = kvm_pmu_cap.events_mask;
  1053			entry->ecx = 0;
  1054			entry->edx = edx.full;
  1055			break;
  1056		}
  1057		case 0x1f:
  1058		case 0xb:
  1059			/*
  1060			 * No topology; a valid topology is indicated by the presence
  1061			 * of subleaf 1.
  1062			 */
  1063			entry->eax = entry->ebx = entry->ecx = 0;
  1064			break;
  1065		case 0xd: {
  1066			u64 permitted_xcr0 = kvm_get_filtered_xcr0();
  1067			u64 permitted_xss = kvm_caps.supported_xss;
  1068	
  1069			entry->eax &= permitted_xcr0;
  1070			entry->ebx = xstate_required_size(permitted_xcr0, false);
  1071			entry->ecx = entry->ebx;
  1072			entry->edx &= permitted_xcr0 >> 32;
  1073			if (!permitted_xcr0)
  1074				break;
  1075	
  1076			entry = do_host_cpuid(array, function, 1);
  1077			if (!entry)
  1078				goto out;
  1079	
  1080			cpuid_entry_override(entry, CPUID_D_1_EAX);
  1081			if (entry->eax & (F(XSAVES)|F(XSAVEC)))
  1082				entry->ebx = xstate_required_size(permitted_xcr0 | permitted_xss,
  1083								  true);
  1084			else {
  1085				WARN_ON_ONCE(permitted_xss != 0);
  1086				entry->ebx = 0;
  1087			}
  1088			entry->ecx &= permitted_xss;
  1089			entry->edx &= permitted_xss >> 32;
  1090	
  1091			for (i = 2; i < 64; ++i) {
  1092				bool s_state;
  1093				if (permitted_xcr0 & BIT_ULL(i))
  1094					s_state = false;
  1095				else if (permitted_xss & BIT_ULL(i))
  1096					s_state = true;
  1097				else
  1098					continue;
  1099	
  1100				entry = do_host_cpuid(array, function, i);
  1101				if (!entry)
  1102					goto out;
  1103	
  1104				/*
  1105				 * The supported check above should have filtered out
  1106				 * invalid sub-leafs.  Only valid sub-leafs should
  1107				 * reach this point, and they should have a non-zero
  1108				 * save state size.  Furthermore, check whether the
  1109				 * processor agrees with permitted_xcr0/permitted_xss
  1110				 * on whether this is an XCR0- or IA32_XSS-managed area.
  1111				 */
  1112				if (WARN_ON_ONCE(!entry->eax || (entry->ecx & 0x1) != s_state)) {
  1113					--array->nent;
  1114					continue;
  1115				}
  1116	
  1117				if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
  1118					entry->ecx &= ~BIT_ULL(2);
  1119				entry->edx = 0;
  1120			}
  1121			break;
  1122		}
  1123		case 0x12:
  1124			/* Intel SGX */
  1125			if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
  1126				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1127				break;
  1128			}
  1129	
  1130			/*
  1131			 * Index 0: Sub-features, MISCSELECT (a.k.a extended features)
  1132			 * and max enclave sizes.   The SGX sub-features and MISCSELECT
  1133			 * are restricted by kernel and KVM capabilities (like most
  1134			 * feature flags), while enclave size is unrestricted.
  1135			 */
  1136			cpuid_entry_override(entry, CPUID_12_EAX);
  1137			entry->ebx &= SGX_MISC_EXINFO;
  1138	
  1139			entry = do_host_cpuid(array, function, 1);
  1140			if (!entry)
  1141				goto out;
  1142	
  1143			/*
  1144			 * Index 1: SECS.ATTRIBUTES.  ATTRIBUTES are restricted a la
  1145			 * feature flags.  Advertise all supported flags, including
  1146			 * privileged attributes that require explicit opt-in from
  1147			 * userspace.  ATTRIBUTES.XFRM is not adjusted as userspace is
  1148			 * expected to derive it from supported XCR0.
  1149			 */
  1150			entry->eax &= SGX_ATTR_PRIV_MASK | SGX_ATTR_UNPRIV_MASK;
  1151			entry->ebx &= 0;
  1152			break;
  1153		/* Intel PT */
  1154		case 0x14:
  1155			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
  1156				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1157				break;
  1158			}
  1159	
  1160			for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
  1161				if (!do_host_cpuid(array, function, i))
  1162					goto out;
  1163			}
  1164			break;
  1165		/* Intel AMX TILE */
  1166		case 0x1d:
  1167			if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
  1168				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1169				break;
  1170			}
  1171	
  1172			for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
  1173				if (!do_host_cpuid(array, function, i))
  1174					goto out;
  1175			}
  1176			break;
  1177		case 0x1e: /* TMUL information */
  1178			if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
  1179				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1180				break;
  1181			}
  1182			break;
  1183		case 0x24: {
  1184			u8 avx10_version;
  1185	
  1186			if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
  1187				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1188				break;
  1189			}
  1190	
  1191			/*
  1192			 * The AVX10 version is encoded in EBX[7:0].  Note, the version
  1193			 * is guaranteed to be >=1 if AVX10 is supported.  Note #2, the
  1194			 * version needs to be captured before overriding EBX features!
  1195			 */
  1196			avx10_version = min_t(u8, entry->ebx & 0xff, 1);
  1197			cpuid_entry_override(entry, CPUID_24_0_EBX);
  1198			entry->ebx |= avx10_version;
  1199	
  1200			entry->eax = 0;
  1201			entry->ecx = 0;
  1202			entry->edx = 0;
  1203			break;
  1204		}
  1205		case KVM_CPUID_SIGNATURE: {
  1206			const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
  1207			entry->eax = KVM_CPUID_FEATURES;
  1208			entry->ebx = sigptr[0];
  1209			entry->ecx = sigptr[1];
  1210			entry->edx = sigptr[2];
  1211			break;
  1212		}
  1213		case KVM_CPUID_FEATURES:
  1214			entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
  1215				     (1 << KVM_FEATURE_NOP_IO_DELAY) |
  1216				     (1 << KVM_FEATURE_CLOCKSOURCE2) |
  1217				     (1 << KVM_FEATURE_ASYNC_PF) |
  1218				     (1 << KVM_FEATURE_PV_EOI) |
  1219				     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
  1220				     (1 << KVM_FEATURE_PV_UNHALT) |
  1221				     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
  1222				     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
  1223				     (1 << KVM_FEATURE_PV_SEND_IPI) |
  1224				     (1 << KVM_FEATURE_POLL_CONTROL) |
  1225				     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
  1226				     (1 << KVM_FEATURE_ASYNC_PF_INT);
  1227	
  1228			if (sched_info_on())
  1229				entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
  1230	
  1231			entry->ebx = 0;
  1232			entry->ecx = 0;
  1233			entry->edx = 0;
  1234			break;
  1235		case 0x80000000:
  1236			entry->eax = min(entry->eax, 0x80000022);
  1237			/*
  1238			 * Serializing LFENCE is reported in a multitude of ways, and
  1239			 * NullSegClearsBase is not reported in CPUID on Zen2; help
  1240			 * userspace by providing the CPUID leaf ourselves.
  1241			 *
  1242			 * However, only do it if the host has CPUID leaf 0x8000001d.
  1243			 * QEMU thinks that it can query the host blindly for that
  1244			 * CPUID leaf if KVM reports that it supports 0x8000001d or
  1245			 * above.  The processor merrily returns values from the
  1246			 * highest Intel leaf which QEMU tries to use as the guest's
  1247			 * 0x8000001d.  Even worse, this can result in an infinite
  1248			 * loop if said highest leaf has no subleaves indexed by ECX.
  1249			 */
  1250			if (entry->eax >= 0x8000001d &&
  1251			    (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
  1252			     || !static_cpu_has_bug(X86_BUG_NULL_SEG)))
  1253				entry->eax = max(entry->eax, 0x80000021);
  1254			break;
  1255		case 0x80000001:
  1256			entry->ebx &= ~GENMASK(27, 16);
  1257			cpuid_entry_override(entry, CPUID_8000_0001_EDX);
  1258			cpuid_entry_override(entry, CPUID_8000_0001_ECX);
  1259			break;
  1260		case 0x80000005:
  1261			/*  Pass host L1 cache and TLB info. */
  1262			break;
  1263		case 0x80000006:
  1264			/* Drop reserved bits, pass host L2 cache and TLB info. */
  1265			entry->edx &= ~GENMASK(17, 16);
  1266			break;
  1267		case 0x80000007: /* Advanced power management */
  1268			cpuid_entry_override(entry, CPUID_8000_0007_EDX);
  1269	
  1270			/* mask against host */
  1271			entry->edx &= boot_cpu_data.x86_power;
  1272			entry->eax = entry->ebx = entry->ecx = 0;
  1273			break;
  1274		case 0x80000008: {
  1275			/*
  1276			 * GuestPhysAddrSize (EAX[23:16]) is intended for software
  1277			 * use.
  1278			 *
  1279			 * KVM's ABI is to report the effective MAXPHYADDR for the
  1280			 * guest in PhysAddrSize (phys_as), and the maximum
  1281			 * *addressable* GPA in GuestPhysAddrSize (g_phys_as).
  1282			 *
  1283			 * GuestPhysAddrSize is valid if and only if TDP is enabled,
  1284			 * in which case the max GPA that can be addressed by KVM may
  1285			 * be less than the max GPA that can be legally generated by
  1286			 * the guest, e.g. if MAXPHYADDR>48 but the CPU doesn't
  1287			 * support 5-level TDP.
  1288			 */
  1289			unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
  1290			unsigned int phys_as, g_phys_as;
  1291	
  1292			/*
  1293			 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
  1294			 * the guest operates in the same PA space as the host, i.e.
  1295			 * reductions in MAXPHYADDR for memory encryption affect shadow
  1296			 * paging, too.
  1297			 *
  1298			 * If TDP is enabled, use the raw bare metal MAXPHYADDR as
  1299			 * reductions to the HPAs do not affect GPAs.  The max
  1300			 * addressable GPA is the same as the max effective GPA, except
  1301			 * that it's capped at 48 bits if 5-level TDP isn't supported
  1302			 * (hardware processes bits 51:48 only when walking the fifth
  1303			 * level page table).
  1304			 */
  1305			if (!tdp_enabled) {
  1306				phys_as = boot_cpu_data.x86_phys_bits;
  1307				g_phys_as = 0;
  1308			} else {
  1309				phys_as = entry->eax & 0xff;
  1310				g_phys_as = phys_as;
  1311				if (kvm_mmu_get_max_tdp_level() < 5)
  1312					g_phys_as = min(g_phys_as, 48);
  1313			}
  1314	
  1315			entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
  1316			entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
  1317			entry->edx = 0;
  1318			cpuid_entry_override(entry, CPUID_8000_0008_EBX);
  1319			break;
  1320		}
  1321		case 0x8000000A:
  1322			if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
  1323				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1324				break;
  1325			}
  1326			entry->eax = 1; /* SVM revision 1 */
  1327			entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
  1328					   ASID emulation to nested SVM */
  1329			entry->ecx = 0; /* Reserved */
  1330			cpuid_entry_override(entry, CPUID_8000_000A_EDX);
  1331			break;
  1332		case 0x80000019:
  1333			entry->ecx = entry->edx = 0;
  1334			break;
  1335		case 0x8000001a:
  1336			entry->eax &= GENMASK(2, 0);
  1337			entry->ebx = entry->ecx = entry->edx = 0;
  1338			break;
  1339		case 0x8000001e:
  1340			/* Do not return host topology information.  */
  1341			entry->eax = entry->ebx = entry->ecx = 0;
  1342			entry->edx = 0; /* reserved */
  1343			break;
  1344		case 0x8000001F:
  1345			if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
  1346				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1347			} else {
  1348				cpuid_entry_override(entry, CPUID_8000_001F_EAX);
  1349				/* Clear NumVMPL since KVM does not support VMPL.  */
  1350				entry->ebx &= ~GENMASK(31, 12);
  1351				/*
  1352				 * Enumerate '0' for "PA bits reduction", the adjusted
  1353				 * MAXPHYADDR is enumerated directly (see 0x80000008).
  1354				 */
  1355				entry->ebx &= ~GENMASK(11, 6);
  1356			}
  1357			break;
  1358		case 0x80000020:
  1359			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1360			break;
  1361		case 0x80000021:
> 1362			unsigned int ebx_mask = 0;
  1363	
  1364			entry->ecx = entry->edx = 0;
  1365			cpuid_entry_override(entry, CPUID_8000_0021_EAX);
  1366	
  1367			/*
  1368			 * Bits 23:16 in EBX indicate the size of the RSB.
  1369			 * Expose the value in the hardware to the guest.
  1370			 */
  1371			if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
  1372				ebx_mask |= GENMASK(23, 16);
  1373	
  1374			entry->ebx &= ebx_mask;
  1375			break;
  1376		/* AMD Extended Performance Monitoring and Debug */
  1377		case 0x80000022: {
  1378			union cpuid_0x80000022_ebx ebx;
  1379	
  1380			entry->ecx = entry->edx = 0;
  1381			if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
  1382				entry->eax = entry->ebx;
  1383				break;
  1384			}
  1385	
  1386			cpuid_entry_override(entry, CPUID_8000_0022_EAX);
  1387	
  1388			if (kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
  1389				ebx.split.num_core_pmc = kvm_pmu_cap.num_counters_gp;
  1390			else if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
  1391				ebx.split.num_core_pmc = AMD64_NUM_COUNTERS_CORE;
  1392			else
  1393				ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
  1394	
  1395			entry->ebx = ebx.full;
  1396			break;
  1397		}
  1398		/*Add support for Centaur's CPUID instruction*/
  1399		case 0xC0000000:
  1400			/*Just support up to 0xC0000004 now*/
  1401			entry->eax = min(entry->eax, 0xC0000004);
  1402			break;
  1403		case 0xC0000001:
  1404			cpuid_entry_override(entry, CPUID_C000_0001_EDX);
  1405			break;
  1406		case 3: /* Processor serial number */
  1407		case 5: /* MONITOR/MWAIT */
  1408		case 0xC0000002:
  1409		case 0xC0000003:
  1410		case 0xC0000004:
  1411		default:
  1412			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1413			break;
  1414		}
  1415	
  1416		r = 0;
  1417	
  1418	out:
  1419		put_cpu();
  1420	
  1421		return r;
  1422	}
  1423	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

