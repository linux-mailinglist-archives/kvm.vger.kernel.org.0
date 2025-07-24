Return-Path: <kvm+bounces-53354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EDAB1054F
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 11:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D6941CC2D87
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 09:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3537C278E6A;
	Thu, 24 Jul 2025 09:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mmKlWA48"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B07278E77;
	Thu, 24 Jul 2025 09:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753348332; cv=none; b=lcEFRy/O1khCS/mM7dbgcz3Rc3Svc+puARaRY3xfh0yk6TClSqcmZ+r+BddG02wjeIkfhJJEgs5cDhgduz4L7GCoTu0+luSVNo44QpWV//Hsc+/KTUihlL4Vut0zo3mJU+eXpw1bXZ5ApjyaUCYShKD6cmUE0iGV2L0R63P2eGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753348332; c=relaxed/simple;
	bh=2D/eWy3V/JwWoNG/RE9YfWlQJ4L8lzp60VYkFuCkQcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxCoDBSiyPKrqpLDyicqyATmpZeHoS02ifvczPV5yBb/uC7aQfapgFXxULVHeaXaPpEy0JBgVdNnuKYFetqz1LHHWo1M+E992r8tTFi0li7hmoeitXpeWytjcJLt4eEUw0zPnXWqeCH/G0HXEXEV0bxETlHplyISvcz9au2KrGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mmKlWA48; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753348328; x=1784884328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2D/eWy3V/JwWoNG/RE9YfWlQJ4L8lzp60VYkFuCkQcQ=;
  b=mmKlWA48r9vnRv4YuJ27EQ4rWpg0QvPhwvaMI68YTZeGDEuZHyvtLkM6
   ABe2eARLmGMfVw9KvbC+qtUevkWPKuqBK1La51Cs8XQMu/2BNuPq+eD6u
   ti3QbpNOyRXuBl/WcVSYfJxFFyNWurujBfEegVIoEICEq3DeymfNl7jkz
   sHj7idJQxTWQS5rORhZniaf0yrESVExklp2N72T63//h7KYQOOScQoYFR
   lGHy3gDtSLM74VCT7phiZq9EA1ZPT8Ov2oUnhBK/0XFB2EYQszhvtnndP
   TKFeO2Bb7dt2SrC2rF/xoKy4TzQU0h3BMGWoKAFPVtgI7DBsLUWm2Hz34
   g==;
X-CSE-ConnectionGUID: +2Tc+MQDTEq/e+qRWJM7gg==
X-CSE-MsgGUID: 7Lhh9Fs6Q5aAO0/jcnOOsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66349627"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66349627"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 02:12:06 -0700
X-CSE-ConnectionGUID: nHWgODuEQsqM30KDtuYtLA==
X-CSE-MsgGUID: hjW/Vu/FQrW8mJrYU/Fv+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160219169"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Jul 2025 02:12:04 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uerzd-000KGT-15;
	Thu, 24 Jul 2025 09:12:01 +0000
Date: Thu, 24 Jul 2025 17:11:28 +0800
From: kernel test robot <lkp@intel.com>
To: "Ahmed S. Darwish" <darwi@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>, x86@kernel.org,
	kvm@vger.kernel.org, x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: Re: [PATCH v4 4/4] x86/cpu: <asm/processor.h>: Do not include the
 CPUID API header
Message-ID: <202507241752.gju4meHj-lkp@intel.com>
References: <20250723173644.33568-5-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723173644.33568-5-darwi@linutronix.de>

Hi Ahmed,

kernel test robot noticed the following build errors:

[auto build test ERROR on 89be9a83ccf1f88522317ce02f854f30d6115c41]

url:    https://github.com/intel-lab-lkp/linux/commits/Ahmed-S-Darwish/x86-cpuid-Remove-transitional-asm-cpuid-h-header/20250724-014828
base:   89be9a83ccf1f88522317ce02f854f30d6115c41
patch link:    https://lore.kernel.org/r/20250723173644.33568-5-darwi%40linutronix.de
patch subject: [PATCH v4 4/4] x86/cpu: <asm/processor.h>: Do not include the CPUID API header
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250724/202507241752.gju4meHj-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250724/202507241752.gju4meHj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507241752.gju4meHj-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/svm/sev.c:2939:2: error: call to undeclared function 'cpuid'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2939 |         cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
         |         ^
   1 error generated.


vim +/cpuid +2939 arch/x86/kvm/svm/sev.c

179a8427fcbffe Ashish Kalra          2025-05-12  2904  
916391a2d1dc22 Tom Lendacky          2020-12-10  2905  void __init sev_hardware_setup(void)
eaf78265a4ab33 Joerg Roedel          2020-03-24  2906  {
7aef27f0b2a8a5 Vipin Sharma          2021-03-29  2907  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
6f1d5a3513c237 Ashish Kalra          2025-03-24  2908  	struct sev_platform_init_args init_args = {0};
1dfe571c12cf99 Brijesh Singh         2024-05-01  2909  	bool sev_snp_supported = false;
916391a2d1dc22 Tom Lendacky          2020-12-10  2910  	bool sev_es_supported = false;
916391a2d1dc22 Tom Lendacky          2020-12-10  2911  	bool sev_supported = false;
916391a2d1dc22 Tom Lendacky          2020-12-10  2912  
80d0f521d59e08 Sean Christopherson   2023-08-24  2913  	if (!sev_enabled || !npt_enabled || !nrips)
e8126bdaf19400 Sean Christopherson   2021-04-21  2914  		goto out;
e8126bdaf19400 Sean Christopherson   2021-04-21  2915  
c532f2903b69b7 Sean Christopherson   2022-01-20  2916  	/*
c532f2903b69b7 Sean Christopherson   2022-01-20  2917  	 * SEV must obviously be supported in hardware.  Sanity check that the
c532f2903b69b7 Sean Christopherson   2022-01-20  2918  	 * CPU supports decode assists, which is mandatory for SEV guests to
770d6aa2e416fd Sean Christopherson   2023-10-18  2919  	 * support instruction emulation.  Ditto for flushing by ASID, as SEV
770d6aa2e416fd Sean Christopherson   2023-10-18  2920  	 * guests are bound to a single ASID, i.e. KVM can't rotate to a new
770d6aa2e416fd Sean Christopherson   2023-10-18  2921  	 * ASID to effect a TLB flush.
c532f2903b69b7 Sean Christopherson   2022-01-20  2922  	 */
c532f2903b69b7 Sean Christopherson   2022-01-20  2923  	if (!boot_cpu_has(X86_FEATURE_SEV) ||
770d6aa2e416fd Sean Christopherson   2023-10-18  2924  	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)) ||
770d6aa2e416fd Sean Christopherson   2023-10-18  2925  	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
916391a2d1dc22 Tom Lendacky          2020-12-10  2926  		goto out;
916391a2d1dc22 Tom Lendacky          2020-12-10  2927  
44e70718df4fc2 Sean Christopherson   2025-02-10  2928  	/*
44e70718df4fc2 Sean Christopherson   2025-02-10  2929  	 * The kernel's initcall infrastructure lacks the ability to express
44e70718df4fc2 Sean Christopherson   2025-02-10  2930  	 * dependencies between initcalls, whereas the modules infrastructure
44e70718df4fc2 Sean Christopherson   2025-02-10  2931  	 * automatically handles dependencies via symbol loading.  Ensure the
44e70718df4fc2 Sean Christopherson   2025-02-10  2932  	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
44e70718df4fc2 Sean Christopherson   2025-02-10  2933  	 * as the dependency isn't handled by the initcall infrastructure.
44e70718df4fc2 Sean Christopherson   2025-02-10  2934  	 */
44e70718df4fc2 Sean Christopherson   2025-02-10  2935  	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
44e70718df4fc2 Sean Christopherson   2025-02-10  2936  		goto out;
44e70718df4fc2 Sean Christopherson   2025-02-10  2937  
916391a2d1dc22 Tom Lendacky          2020-12-10  2938  	/* Retrieve SEV CPUID information */
916391a2d1dc22 Tom Lendacky          2020-12-10 @2939  	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
916391a2d1dc22 Tom Lendacky          2020-12-10  2940  
1edc14599e06fd Tom Lendacky          2020-12-10  2941  	/* Set encryption bit location for SEV-ES guests */
1edc14599e06fd Tom Lendacky          2020-12-10  2942  	sev_enc_bit = ebx & 0x3f;
1edc14599e06fd Tom Lendacky          2020-12-10  2943  
eaf78265a4ab33 Joerg Roedel          2020-03-24  2944  	/* Maximum number of encrypted guests supported simultaneously */
916391a2d1dc22 Tom Lendacky          2020-12-10  2945  	max_sev_asid = ecx;
8cb756b7bdcc6e Sean Christopherson   2021-04-21  2946  	if (!max_sev_asid)
916391a2d1dc22 Tom Lendacky          2020-12-10  2947  		goto out;
eaf78265a4ab33 Joerg Roedel          2020-03-24  2948  
eaf78265a4ab33 Joerg Roedel          2020-03-24  2949  	/* Minimum ASID value that should be used for SEV guest */
916391a2d1dc22 Tom Lendacky          2020-12-10  2950  	min_sev_asid = edx;
d3d1af85e2c75b Brijesh Singh         2021-04-15  2951  	sev_me_mask = 1UL << (ebx & 0x3f);
eaf78265a4ab33 Joerg Roedel          2020-03-24  2952  
bb2baeb214a71c Mingwei Zhang         2021-08-02  2953  	/*
bb2baeb214a71c Mingwei Zhang         2021-08-02  2954  	 * Initialize SEV ASID bitmaps. Allocate space for ASID 0 in the bitmap,
bb2baeb214a71c Mingwei Zhang         2021-08-02  2955  	 * even though it's never used, so that the bitmap is indexed by the
bb2baeb214a71c Mingwei Zhang         2021-08-02  2956  	 * actual ASID.
bb2baeb214a71c Mingwei Zhang         2021-08-02  2957  	 */
bb2baeb214a71c Mingwei Zhang         2021-08-02  2958  	nr_asids = max_sev_asid + 1;
bb2baeb214a71c Mingwei Zhang         2021-08-02  2959  	sev_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
eaf78265a4ab33 Joerg Roedel          2020-03-24  2960  	if (!sev_asid_bitmap)
916391a2d1dc22 Tom Lendacky          2020-12-10  2961  		goto out;
eaf78265a4ab33 Joerg Roedel          2020-03-24  2962  
bb2baeb214a71c Mingwei Zhang         2021-08-02  2963  	sev_reclaim_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
f31b88b35f90f6 Sean Christopherson   2021-04-21  2964  	if (!sev_reclaim_asid_bitmap) {
f31b88b35f90f6 Sean Christopherson   2021-04-21  2965  		bitmap_free(sev_asid_bitmap);
f31b88b35f90f6 Sean Christopherson   2021-04-21  2966  		sev_asid_bitmap = NULL;
916391a2d1dc22 Tom Lendacky          2020-12-10  2967  		goto out;
f31b88b35f90f6 Sean Christopherson   2021-04-21  2968  	}
eaf78265a4ab33 Joerg Roedel          2020-03-24  2969  
0aa6b90ef9d75b Ashish Kalra          2024-01-31  2970  	if (min_sev_asid <= max_sev_asid) {
7aef27f0b2a8a5 Vipin Sharma          2021-03-29  2971  		sev_asid_count = max_sev_asid - min_sev_asid + 1;
106ed2cad9f7bd Sean Christopherson   2023-06-06  2972  		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
0aa6b90ef9d75b Ashish Kalra          2024-01-31  2973  	}
916391a2d1dc22 Tom Lendacky          2020-12-10  2974  	sev_supported = true;
eaf78265a4ab33 Joerg Roedel          2020-03-24  2975  
916391a2d1dc22 Tom Lendacky          2020-12-10  2976  	/* SEV-ES support requested? */
8d364a0792dd95 Sean Christopherson   2021-04-21  2977  	if (!sev_es_enabled)
916391a2d1dc22 Tom Lendacky          2020-12-10  2978  		goto out;
916391a2d1dc22 Tom Lendacky          2020-12-10  2979  
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2980  	/*
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2981  	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2982  	 * instruction stream, i.e. can't emulate in response to a #NPF and
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2983  	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2984  	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2985  	 */
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2986  	if (!enable_mmio_caching)
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2987  		goto out;
0c29397ac1fdd6 Sean Christopherson   2022-08-03  2988  
916391a2d1dc22 Tom Lendacky          2020-12-10  2989  	/* Does the CPU support SEV-ES? */
916391a2d1dc22 Tom Lendacky          2020-12-10  2990  	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
916391a2d1dc22 Tom Lendacky          2020-12-10  2991  		goto out;
916391a2d1dc22 Tom Lendacky          2020-12-10  2992  
d922056215617e Ravi Bangoria         2024-05-31  2993  	if (!lbrv) {
d922056215617e Ravi Bangoria         2024-05-31  2994  		WARN_ONCE(!boot_cpu_has(X86_FEATURE_LBRV),
d922056215617e Ravi Bangoria         2024-05-31  2995  			  "LBRV must be present for SEV-ES support");
d922056215617e Ravi Bangoria         2024-05-31  2996  		goto out;
d922056215617e Ravi Bangoria         2024-05-31  2997  	}
d922056215617e Ravi Bangoria         2024-05-31  2998  
916391a2d1dc22 Tom Lendacky          2020-12-10  2999  	/* Has the system been allocated ASIDs for SEV-ES? */
916391a2d1dc22 Tom Lendacky          2020-12-10  3000  	if (min_sev_asid == 1)
916391a2d1dc22 Tom Lendacky          2020-12-10  3001  		goto out;
916391a2d1dc22 Tom Lendacky          2020-12-10  3002  
7aef27f0b2a8a5 Vipin Sharma          2021-03-29  3003  	sev_es_asid_count = min_sev_asid - 1;
106ed2cad9f7bd Sean Christopherson   2023-06-06  3004  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
916391a2d1dc22 Tom Lendacky          2020-12-10  3005  	sev_es_supported = true;
1dfe571c12cf99 Brijesh Singh         2024-05-01  3006  	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
916391a2d1dc22 Tom Lendacky          2020-12-10  3007  
916391a2d1dc22 Tom Lendacky          2020-12-10  3008  out:
179a8427fcbffe Ashish Kalra          2025-05-12  3009  	if (sev_enabled) {
179a8427fcbffe Ashish Kalra          2025-05-12  3010  		init_args.probe = true;
179a8427fcbffe Ashish Kalra          2025-05-12  3011  		if (sev_platform_init(&init_args))
179a8427fcbffe Ashish Kalra          2025-05-12  3012  			sev_supported = sev_es_supported = sev_snp_supported = false;
179a8427fcbffe Ashish Kalra          2025-05-12  3013  		else if (sev_snp_supported)
179a8427fcbffe Ashish Kalra          2025-05-12  3014  			sev_snp_supported = is_sev_snp_initialized();
179a8427fcbffe Ashish Kalra          2025-05-12  3015  	}
179a8427fcbffe Ashish Kalra          2025-05-12  3016  
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3017  	if (boot_cpu_has(X86_FEATURE_SEV))
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3018  		pr_info("SEV %s (ASIDs %u - %u)\n",
0aa6b90ef9d75b Ashish Kalra          2024-01-31  3019  			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
0aa6b90ef9d75b Ashish Kalra          2024-01-31  3020  								       "unusable" :
0aa6b90ef9d75b Ashish Kalra          2024-01-31  3021  								       "disabled",
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3022  			min_sev_asid, max_sev_asid);
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3023  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3024  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
800173cf7560e0 Thorsten Blum         2024-12-27  3025  			str_enabled_disabled(sev_es_supported),
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3026  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
1dfe571c12cf99 Brijesh Singh         2024-05-01  3027  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
1dfe571c12cf99 Brijesh Singh         2024-05-01  3028  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
800173cf7560e0 Thorsten Blum         2024-12-27  3029  			str_enabled_disabled(sev_snp_supported),
1dfe571c12cf99 Brijesh Singh         2024-05-01  3030  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
6d1bc9754b0407 Alexander Mikhalitsyn 2023-05-22  3031  
8d364a0792dd95 Sean Christopherson   2021-04-21  3032  	sev_enabled = sev_supported;
8d364a0792dd95 Sean Christopherson   2021-04-21  3033  	sev_es_enabled = sev_es_supported;
1dfe571c12cf99 Brijesh Singh         2024-05-01  3034  	sev_snp_enabled = sev_snp_supported;
1dfe571c12cf99 Brijesh Singh         2024-05-01  3035  
d1f85fbe836e61 Alexey Kardashevskiy  2023-06-15  3036  	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
d1f85fbe836e61 Alexey Kardashevskiy  2023-06-15  3037  	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
d1f85fbe836e61 Alexey Kardashevskiy  2023-06-15  3038  		sev_es_debug_swap_enabled = false;
ac5c48027bacb1 Paolo Bonzini         2024-04-04  3039  
ac5c48027bacb1 Paolo Bonzini         2024-04-04  3040  	sev_supported_vmsa_features = 0;
ac5c48027bacb1 Paolo Bonzini         2024-04-04  3041  	if (sev_es_debug_swap_enabled)
ac5c48027bacb1 Paolo Bonzini         2024-04-04  3042  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
eaf78265a4ab33 Joerg Roedel          2020-03-24  3043  }
eaf78265a4ab33 Joerg Roedel          2020-03-24  3044  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

