Return-Path: <kvm+bounces-39948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE8CA4D0C5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 02:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCB661740DA
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7DD14386D;
	Tue,  4 Mar 2025 01:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eL+8r5Xy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C02C6A33B
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 01:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741051571; cv=none; b=oSh958elxWImol39EgTRT9kRJhn/O7cXdCZbTETIBK6kfVHdgYWbfZf9EhzcB+6R5/QBhrq0L4PqS8MP41Z/vQYDY69wcWs6F000cZwVGl6hwUD031iAd1AdzsETVR0lUkKklbAZy7KkE1HFbSgRmcvRcuzY55kZBQsWXlEYcIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741051571; c=relaxed/simple;
	bh=YiZaoiok5I5oPdwlFn37HPnRMfwWP7zPxdm2K7b6Fag=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DJvRjbkJC/FVqQRwDLMaBopQq3bgXLZ88SdbhIFBJfSqbOL9z631lD5mKcTY33RqpyLe2Fb7MFjREHswbjKsCCQzjeL5X3mtSEDD8GAoi3NFUEljZtflCpQUSHlvRYHzeC+OnWRnUTP7ySeJ/YIr/zJvV/tFlos8m0wuI2vVEPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eL+8r5Xy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741051570; x=1772587570;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=YiZaoiok5I5oPdwlFn37HPnRMfwWP7zPxdm2K7b6Fag=;
  b=eL+8r5Xyqa6/orDyaIlFnC6QMjq1Xzv5CbfOCQHsuH+EbBSudPRXLeRo
   EIT/GvRKITtGjj5QwTdCMxhjwJUPoLtZeda5nnQ0V+v9gunofqazprxus
   H7pNrOtJbeVjoce9jrSjc3+PTgPCtUZzoCV7A8EOLrhPgF38KcNk1g4UR
   Xkyqw2m14AYDzOG4Wu5HWCF7udH50OyZ0fd+93AQlx5zAt4NK5RTurf6O
   xpQZuXsQFWRDgf53bG5PCyqHbY8hWDQVDI+lmsOrIQI4Q6f83bhWXhlKP
   +gKN0gqaOkzx3YVoOQgMgVH1T3ZwfWsdnUFA4B2SY8wi8SIVgIR+L/ZdT
   g==;
X-CSE-ConnectionGUID: p4DGpBovT4eGQqmMsbEn7Q==
X-CSE-MsgGUID: 5pTSBWvfTd6byXW2+zUBIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="53345454"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="53345454"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 17:26:09 -0800
X-CSE-ConnectionGUID: VlVOrw4iS3inpz+wPeb0/A==
X-CSE-MsgGUID: vJy85qGARLOfTxMvzsEMwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="117953050"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 03 Mar 2025 17:26:07 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tpH2r-000J7O-0B;
	Tue, 04 Mar 2025 01:26:05 +0000
Date: Tue, 4 Mar 2025 09:25:22 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [kvm:kvm-coco-queue 115/127] ERROR: modpost: "tdx_has_emulated_msr"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503040911.EFn6ARad-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   9fe4541afcfad987d39790f0a40527af190bf0dd
commit: 45906ac7d5845667e6d37f2f4b86034ca1c5fbd2 [115/127] KVM: TDX: Implement callbacks for MSR operations
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250304/202503040911.EFn6ARad-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250304/202503040911.EFn6ARad-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503040911.EFn6ARad-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "tdx_interrupt_allowed" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_disable_virtualization_cpu" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_has_emulated_msr" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_create" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_free" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_reset" [arch/x86/kvm/kvm-intel.ko] undefined!
WARNING: modpost: suppressed 24 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

