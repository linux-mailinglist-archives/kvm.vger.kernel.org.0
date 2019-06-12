Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9946B41D83
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 09:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbfFLHUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 03:20:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:11340 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731310AbfFLHUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 03:20:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 00:20:45 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2019 00:20:42 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1haxYn-000GWu-FR; Wed, 12 Jun 2019 15:20:41 +0800
Date:   Wed, 12 Jun 2019 15:20:34 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     kbuild-all@01.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        sean.j.christopherson@intel.com, xiaoyao.li@linux.intel.com,
        linux-kernel@vger.kernel.org, like.xu@intel.com
Subject: Re: [PATCH v4] KVM: x86: Add Intel CPUID.1F cpuid emulation support
Message-ID: <201906121534.YMidQsPc%lkp@intel.com>
References: <20190606011845.40223-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606011845.40223-1-like.xu@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on v5.2-rc4 next-20190611]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/KVM-x86-Add-Intel-CPUID-1F-cpuid-emulation-support/20190606-094225
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kvm/cpuid.c:430:30: sparse: sparse: incompatible types in comparison expression (different signedness):
>> arch/x86/kvm/cpuid.c:430:30: sparse:    unsigned int *
>> arch/x86/kvm/cpuid.c:430:30: sparse:    int *

vim +430 arch/x86/kvm/cpuid.c

   318	
   319	static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
   320					 u32 index, int *nent, int maxnent)
   321	{
   322		int r;
   323		unsigned f_nx = is_efer_nx() ? F(NX) : 0;
   324	#ifdef CONFIG_X86_64
   325		unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
   326					? F(GBPAGES) : 0;
   327		unsigned f_lm = F(LM);
   328	#else
   329		unsigned f_gbpages = 0;
   330		unsigned f_lm = 0;
   331	#endif
   332		unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
   333		unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
   334		unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
   335		unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
   336		unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
   337		unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
   338		unsigned f_la57 = 0;
   339	
   340		/* cpuid 1.edx */
   341		const u32 kvm_cpuid_1_edx_x86_features =
   342			F(FPU) | F(VME) | F(DE) | F(PSE) |
   343			F(TSC) | F(MSR) | F(PAE) | F(MCE) |
   344			F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
   345			F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
   346			F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
   347			0 /* Reserved, DS, ACPI */ | F(MMX) |
   348			F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
   349			0 /* HTT, TM, Reserved, PBE */;
   350		/* cpuid 0x80000001.edx */
   351		const u32 kvm_cpuid_8000_0001_edx_x86_features =
   352			F(FPU) | F(VME) | F(DE) | F(PSE) |
   353			F(TSC) | F(MSR) | F(PAE) | F(MCE) |
   354			F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
   355			F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
   356			F(PAT) | F(PSE36) | 0 /* Reserved */ |
   357			f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
   358			F(FXSR) | F(FXSR_OPT) | f_gbpages | f_rdtscp |
   359			0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
   360		/* cpuid 1.ecx */
   361		const u32 kvm_cpuid_1_ecx_x86_features =
   362			/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
   363			 * but *not* advertised to guests via CPUID ! */
   364			F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
   365			0 /* DS-CPL, VMX, SMX, EST */ |
   366			0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
   367			F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
   368			F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
   369			F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
   370			0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
   371			F(F16C) | F(RDRAND);
   372		/* cpuid 0x80000001.ecx */
   373		const u32 kvm_cpuid_8000_0001_ecx_x86_features =
   374			F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
   375			F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
   376			F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
   377			0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
   378			F(TOPOEXT) | F(PERFCTR_CORE);
   379	
   380		/* cpuid 0x80000008.ebx */
   381		const u32 kvm_cpuid_8000_0008_ebx_x86_features =
   382			F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
   383			F(AMD_SSB_NO) | F(AMD_STIBP);
   384	
   385		/* cpuid 0xC0000001.edx */
   386		const u32 kvm_cpuid_C000_0001_edx_x86_features =
   387			F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
   388			F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
   389			F(PMM) | F(PMM_EN);
   390	
   391		/* cpuid 7.0.ebx */
   392		const u32 kvm_cpuid_7_0_ebx_x86_features =
   393			F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
   394			F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
   395			F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
   396			F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
   397			F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
   398	
   399		/* cpuid 0xD.1.eax */
   400		const u32 kvm_cpuid_D_1_eax_x86_features =
   401			F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
   402	
   403		/* cpuid 7.0.ecx*/
   404		const u32 kvm_cpuid_7_0_ecx_x86_features =
   405			F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
   406			F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
   407			F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
   408			F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
   409	
   410		/* cpuid 7.0.edx*/
   411		const u32 kvm_cpuid_7_0_edx_x86_features =
   412			F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
   413			F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
   414			F(MD_CLEAR);
   415	
   416		/* all calls to cpuid_count() should be made on the same cpu */
   417		get_cpu();
   418	
   419		r = -E2BIG;
   420	
   421		if (*nent >= maxnent)
   422			goto out;
   423	
   424		do_cpuid_1_ent(entry, function, index);
   425		++*nent;
   426	
   427		switch (function) {
   428		case 0:
   429			/* Limited to the highest leaf implemented in KVM. */
 > 430			entry->eax = min(entry->eax, 0x1f);
   431			break;
   432		case 1:
   433			entry->edx &= kvm_cpuid_1_edx_x86_features;
   434			cpuid_mask(&entry->edx, CPUID_1_EDX);
   435			entry->ecx &= kvm_cpuid_1_ecx_x86_features;
   436			cpuid_mask(&entry->ecx, CPUID_1_ECX);
   437			/* we support x2apic emulation even if host does not support
   438			 * it since we emulate x2apic in software */
   439			entry->ecx |= F(X2APIC);
   440			break;
   441		/* function 2 entries are STATEFUL. That is, repeated cpuid commands
   442		 * may return different values. This forces us to get_cpu() before
   443		 * issuing the first command, and also to emulate this annoying behavior
   444		 * in kvm_emulate_cpuid() using KVM_CPUID_FLAG_STATE_READ_NEXT */
   445		case 2: {
   446			int t, times = entry->eax & 0xff;
   447	
   448			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
   449			entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
   450			for (t = 1; t < times; ++t) {
   451				if (*nent >= maxnent)
   452					goto out;
   453	
   454				do_cpuid_1_ent(&entry[t], function, 0);
   455				entry[t].flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
   456				++*nent;
   457			}
   458			break;
   459		}
   460		/* function 4 has additional index. */
   461		case 4: {
   462			int i, cache_type;
   463	
   464			entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   465			/* read more entries until cache_type is zero */
   466			for (i = 1; ; ++i) {
   467				if (*nent >= maxnent)
   468					goto out;
   469	
   470				cache_type = entry[i - 1].eax & 0x1f;
   471				if (!cache_type)
   472					break;
   473				do_cpuid_1_ent(&entry[i], function, i);
   474				entry[i].flags |=
   475				       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   476				++*nent;
   477			}
   478			break;
   479		}
   480		case 6: /* Thermal management */
   481			entry->eax = 0x4; /* allow ARAT */
   482			entry->ebx = 0;
   483			entry->ecx = 0;
   484			entry->edx = 0;
   485			break;
   486		case 7: {
   487			entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   488			/* Mask ebx against host capability word 9 */
   489			if (index == 0) {
   490				entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
   491				cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
   492				// TSC_ADJUST is emulated
   493				entry->ebx |= F(TSC_ADJUST);
   494				entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
   495				f_la57 = entry->ecx & F(LA57);
   496				cpuid_mask(&entry->ecx, CPUID_7_ECX);
   497				/* Set LA57 based on hardware capability. */
   498				entry->ecx |= f_la57;
   499				entry->ecx |= f_umip;
   500				/* PKU is not yet implemented for shadow paging. */
   501				if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
   502					entry->ecx &= ~F(PKU);
   503				entry->edx &= kvm_cpuid_7_0_edx_x86_features;
   504				cpuid_mask(&entry->edx, CPUID_7_EDX);
   505				/*
   506				 * We emulate ARCH_CAPABILITIES in software even
   507				 * if the host doesn't support it.
   508				 */
   509				entry->edx |= F(ARCH_CAPABILITIES);
   510			} else {
   511				entry->ebx = 0;
   512				entry->ecx = 0;
   513				entry->edx = 0;
   514			}
   515			entry->eax = 0;
   516			break;
   517		}
   518		case 9:
   519			break;
   520		case 0xa: { /* Architectural Performance Monitoring */
   521			struct x86_pmu_capability cap;
   522			union cpuid10_eax eax;
   523			union cpuid10_edx edx;
   524	
   525			perf_get_x86_pmu_capability(&cap);
   526	
   527			/*
   528			 * Only support guest architectural pmu on a host
   529			 * with architectural pmu.
   530			 */
   531			if (!cap.version)
   532				memset(&cap, 0, sizeof(cap));
   533	
   534			eax.split.version_id = min(cap.version, 2);
   535			eax.split.num_counters = cap.num_counters_gp;
   536			eax.split.bit_width = cap.bit_width_gp;
   537			eax.split.mask_length = cap.events_mask_len;
   538	
   539			edx.split.num_counters_fixed = cap.num_counters_fixed;
   540			edx.split.bit_width_fixed = cap.bit_width_fixed;
   541			edx.split.reserved = 0;
   542	
   543			entry->eax = eax.full;
   544			entry->ebx = cap.events_mask;
   545			entry->ecx = 0;
   546			entry->edx = edx.full;
   547			break;
   548		}
   549		/*
   550		 * Per Intel's SDM, the 0x1f is a superset of 0xb,
   551		 * thus they can be handled by common code.
   552		 */
   553		case 0x1f:
   554		case 0xb: {
   555			int i, level_type;
   556	
   557			entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   558			/* read more entries until level_type is zero */
   559			for (i = 1; ; ++i) {
   560				if (*nent >= maxnent)
   561					goto out;
   562	
   563				level_type = entry[i - 1].ecx & 0xff00;
   564				if (!level_type)
   565					break;
   566				do_cpuid_1_ent(&entry[i], function, i);
   567				entry[i].flags |=
   568				       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   569				++*nent;
   570			}
   571			break;
   572		}
   573		case 0xd: {
   574			int idx, i;
   575			u64 supported = kvm_supported_xcr0();
   576	
   577			entry->eax &= supported;
   578			entry->ebx = xstate_required_size(supported, false);
   579			entry->ecx = entry->ebx;
   580			entry->edx &= supported >> 32;
   581			entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   582			if (!supported)
   583				break;
   584	
   585			for (idx = 1, i = 1; idx < 64; ++idx) {
   586				u64 mask = ((u64)1 << idx);
   587				if (*nent >= maxnent)
   588					goto out;
   589	
   590				do_cpuid_1_ent(&entry[i], function, idx);
   591				if (idx == 1) {
   592					entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
   593					cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
   594					entry[i].ebx = 0;
   595					if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
   596						entry[i].ebx =
   597							xstate_required_size(supported,
   598									     true);
   599				} else {
   600					if (entry[i].eax == 0 || !(supported & mask))
   601						continue;
   602					if (WARN_ON_ONCE(entry[i].ecx & 1))
   603						continue;
   604				}
   605				entry[i].ecx = 0;
   606				entry[i].edx = 0;
   607				entry[i].flags |=
   608				       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   609				++*nent;
   610				++i;
   611			}
   612			break;
   613		}
   614		/* Intel PT */
   615		case 0x14: {
   616			int t, times = entry->eax;
   617	
   618			if (!f_intel_pt)
   619				break;
   620	
   621			entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   622			for (t = 1; t <= times; ++t) {
   623				if (*nent >= maxnent)
   624					goto out;
   625				do_cpuid_1_ent(&entry[t], function, t);
   626				entry[t].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
   627				++*nent;
   628			}
   629			break;
   630		}
   631		case KVM_CPUID_SIGNATURE: {
   632			static const char signature[12] = "KVMKVMKVM\0\0";
   633			const u32 *sigptr = (const u32 *)signature;
   634			entry->eax = KVM_CPUID_FEATURES;
   635			entry->ebx = sigptr[0];
   636			entry->ecx = sigptr[1];
   637			entry->edx = sigptr[2];
   638			break;
   639		}
   640		case KVM_CPUID_FEATURES:
   641			entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
   642				     (1 << KVM_FEATURE_NOP_IO_DELAY) |
   643				     (1 << KVM_FEATURE_CLOCKSOURCE2) |
   644				     (1 << KVM_FEATURE_ASYNC_PF) |
   645				     (1 << KVM_FEATURE_PV_EOI) |
   646				     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
   647				     (1 << KVM_FEATURE_PV_UNHALT) |
   648				     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
   649				     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
   650				     (1 << KVM_FEATURE_PV_SEND_IPI);
   651	
   652			if (sched_info_on())
   653				entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
   654	
   655			entry->ebx = 0;
   656			entry->ecx = 0;
   657			entry->edx = 0;
   658			break;
   659		case 0x80000000:
   660			entry->eax = min(entry->eax, 0x8000001f);
   661			break;
   662		case 0x80000001:
   663			entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
   664			cpuid_mask(&entry->edx, CPUID_8000_0001_EDX);
   665			entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
   666			cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
   667			break;
   668		case 0x80000007: /* Advanced power management */
   669			/* invariant TSC is CPUID.80000007H:EDX[8] */
   670			entry->edx &= (1 << 8);
   671			/* mask against host */
   672			entry->edx &= boot_cpu_data.x86_power;
   673			entry->eax = entry->ebx = entry->ecx = 0;
   674			break;
   675		case 0x80000008: {
   676			unsigned g_phys_as = (entry->eax >> 16) & 0xff;
   677			unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
   678			unsigned phys_as = entry->eax & 0xff;
   679	
   680			if (!g_phys_as)
   681				g_phys_as = phys_as;
   682			entry->eax = g_phys_as | (virt_as << 8);
   683			entry->edx = 0;
   684			/*
   685			 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in
   686			 * hardware cpuid
   687			 */
   688			if (boot_cpu_has(X86_FEATURE_AMD_IBPB))
   689				entry->ebx |= F(AMD_IBPB);
   690			if (boot_cpu_has(X86_FEATURE_AMD_IBRS))
   691				entry->ebx |= F(AMD_IBRS);
   692			if (boot_cpu_has(X86_FEATURE_VIRT_SSBD))
   693				entry->ebx |= F(VIRT_SSBD);
   694			entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
   695			cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
   696			/*
   697			 * The preference is to use SPEC CTRL MSR instead of the
   698			 * VIRT_SPEC MSR.
   699			 */
   700			if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
   701			    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
   702				entry->ebx |= F(VIRT_SSBD);
   703			break;
   704		}
   705		case 0x80000019:
   706			entry->ecx = entry->edx = 0;
   707			break;
   708		case 0x8000001a:
   709			break;
   710		case 0x8000001d:
   711			break;
   712		/*Add support for Centaur's CPUID instruction*/
   713		case 0xC0000000:
   714			/*Just support up to 0xC0000004 now*/
   715			entry->eax = min(entry->eax, 0xC0000004);
   716			break;
   717		case 0xC0000001:
   718			entry->edx &= kvm_cpuid_C000_0001_edx_x86_features;
   719			cpuid_mask(&entry->edx, CPUID_C000_0001_EDX);
   720			break;
   721		case 3: /* Processor serial number */
   722		case 5: /* MONITOR/MWAIT */
   723		case 0xC0000002:
   724		case 0xC0000003:
   725		case 0xC0000004:
   726		default:
   727			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
   728			break;
   729		}
   730	
   731		kvm_x86_ops->set_supported_cpuid(function, entry);
   732	
   733		r = 0;
   734	
   735	out:
   736		put_cpu();
   737	
   738		return r;
   739	}
   740	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
