Return-Path: <kvm+bounces-25381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBB6964A9E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 978E2283D7A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3531B5808;
	Thu, 29 Aug 2024 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NImxa3nI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C861B3F01;
	Thu, 29 Aug 2024 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946634; cv=none; b=Ic45sy5IAED0xTym3ETj7qs85B1+QAzsRB1lZiOfZnFHtMc7kMqtnkYHi18fnK8JsHX8o6gw8w5k40rTqtKhh7oC620kCw3pYFqmf2r9lpVeTagU7TfNNpfSeSYL3esQ3lodsX4OAhff8vnq0vSgzu7RwcBh7BDz22Ft7sgxbSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946634; c=relaxed/simple;
	bh=Xwa41nPWXFk5ZvYn4P/GOc574DpMq9cTCMistG6DV14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxtKFKUe8pdDHxBFCKyexWGue+MR51yPgMGLjxptcR2tDd267diAi/67f/rN1L7u9c6oUkaxdS7zam61Vy/9ihcnBU0DF66zb0lUZRf9rTeKHlvP3vkrrSOAdzqiSF11tvd7euZGme7RcDh3Iy5vvmHVRlkL6HSeTXAXiMg/Oro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NImxa3nI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724946632; x=1756482632;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xwa41nPWXFk5ZvYn4P/GOc574DpMq9cTCMistG6DV14=;
  b=NImxa3nIClo/jpMESSCQs4KUQCd5g84rNliAtgA8w5YPwwWRN5EAt2mD
   lr4nwcVXFDffaQhxM7kBXg38WvAlU1IQXYsIm9pRGCQApYX46XbN6XMNa
   3VoOKtqGEPbB5YLtQHh67mJ4Tx7TW+47tllnJncZtcr3eaQRE+x6nUCde
   VVxd2l6yqi9ASq5FEBfkPxRDROf6/OkHAOD0O9iASd1iLUrdXQuIPjPw6
   nVTNzu2lcx3N/dtB5XYY+P6lKi2DWwpXvyZxPdDW9Ih7JuMA97V4EPv0U
   poMZdOSYiQ7W16Y7s+CMM+RkJsbslKu4+mkTEVIun+op7xJioOaRjQMkE
   w==;
X-CSE-ConnectionGUID: 7pi13zxGTWWoHw0gMzPEFg==
X-CSE-MsgGUID: aNqwDa/ETqK4inqegAX0ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34958255"
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="34958255"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 08:50:31 -0700
X-CSE-ConnectionGUID: SqhaKlPuSoS/Ppr9Z5wcWA==
X-CSE-MsgGUID: caMfL994RjyUJRCwpirnWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="101129077"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 Aug 2024 08:50:28 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sjhPl-0000Q4-0p;
	Thu, 29 Aug 2024 15:50:25 +0000
Date: Thu, 29 Aug 2024 23:50:07 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, hpa@zytor.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, michael.roth@amd.com,
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Message-ID: <202408292344.yuQ5sYEz-lkp@intel.com>
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827203804.4989-1-Ashish.Kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.11-rc5 next-20240829]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/x86-sev-Fix-host-kdump-support-for-SNP/20240828-044035
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240827203804.4989-1-Ashish.Kalra%40amd.com
patch subject: [PATCH] x86/sev: Fix host kdump support for SNP
config: x86_64-buildonly-randconfig-002-20240829 (https://download.01.org/0day-ci/archive/20240829/202408292344.yuQ5sYEz-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240829/202408292344.yuQ5sYEz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408292344.yuQ5sYEz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/svm/avic.c:28:
>> arch/x86/kvm/svm/svm.h:783:13: warning: 'snp_decommision_all' declared 'static' but never defined [-Wunused-function]
     783 | static void snp_decommision_all(void);
         |             ^~~~~~~~~~~~~~~~~~~
--
   In file included from arch/x86/kvm/svm/svm.c:50:
>> arch/x86/kvm/svm/svm.h:783:13: warning: 'snp_decommision_all' used but never defined
     783 | static void snp_decommision_all(void);
         |             ^~~~~~~~~~~~~~~~~~~


vim +783 arch/x86/kvm/svm/svm.h

   763	
   764	static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
   765	static inline void sev_vm_destroy(struct kvm *kvm) {}
   766	static inline void __init sev_set_cpu_caps(void) {}
   767	static inline void __init sev_hardware_setup(void) {}
   768	static inline void sev_hardware_unsetup(void) {}
   769	static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
   770	static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
   771	#define max_sev_asid 0
   772	static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
   773	static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
   774	static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
   775	{
   776		return 0;
   777	}
   778	static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
   779	static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
   780	{
   781		return 0;
   782	}
 > 783	static void snp_decommision_all(void);
   784	#endif
   785	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

