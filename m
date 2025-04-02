Return-Path: <kvm+bounces-42447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7DDA7873D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DB387A50AD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73ED230D3D;
	Wed,  2 Apr 2025 04:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S39IRO3A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36191230BF9
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743567826; cv=none; b=PGyqivmrqWQnypbqe0CqbYJNSdLpawrc6htDLvHu72rinfLCQCo4iatuFZkTVF34qksVa+czGfZYYPSBcSAyc1KWfff0iPxKPNH8D+M4K8O9uHBdC93Vnapb6Szogh4ZPeUOFW/4RqJPMrmeb1CwlEz5VYcWNbnyX8/nVJXB2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743567826; c=relaxed/simple;
	bh=uk+jCp/FuYXV7XyCCDRWAs858M7p/r7TeKVlBYXv6ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Fsz6Q1nJKFcz6NsZu9ZUA2i86aV3jJjw4QuH1Sq35F5MZdw1K98n1St4siTEfR58v3EgAFWAskAHSUt5RI2+CD90wZsHuIrLnhn9o+veBic1n9dRsH9hu7o+MDtCHCPqSevEvykVZyos1fxD4cx3zT1cCw4fS6uz8bUcZ4q1i9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S39IRO3A; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743567824; x=1775103824;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uk+jCp/FuYXV7XyCCDRWAs858M7p/r7TeKVlBYXv6ZQ=;
  b=S39IRO3A9ESB3vwMxGBpG2PiEGUHyyJCxkmHBlEVAkF0KguQWbiRYPYq
   SY63kz27lRE+gV/+42O763wF2ke2Um/wQVk7FLbU+sWk90jJa94TEFEK2
   yDDnPBtFVc5j3+h+33zrzWINadY/pULp/SFVtUNChUGFAgj4v6x8HVaM0
   AAEeSBR7iaBT5an6iqDed1AHPOrVs8dkCk2A03eydeV8uexTmpAsLlsFp
   jYQZqC0vzVVtTsdtMJakz4frpF2thVSW7bagGA3F9Zzii7H2Xkpwyrng2
   ODTC7WtDqe/RwfA04yQr/8RY2QCvGZkFlO31kmkqo1oLhe315jPq/lGGe
   w==;
X-CSE-ConnectionGUID: Ic9ZjyX3QsyOREql3ih1ew==
X-CSE-MsgGUID: Pn+KTSJ/TUm0CaBVV/zYUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="56280097"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="56280097"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 21:23:43 -0700
X-CSE-ConnectionGUID: wAbpNMTFTPWsb+vc4b+HPg==
X-CSE-MsgGUID: cy35nKcVTMe3J5HTUsyGZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="126828673"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 01 Apr 2025 21:23:42 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzpdc-000AT8-0A;
	Wed, 02 Apr 2025 04:23:40 +0000
Date: Wed, 2 Apr 2025 12:23:16 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 58/62] arch/x86/kvm/lapic.c:1327:37: error:
 incompatible pointer types passing 'atomic_t *' to parameter of type
 'volatile unsigned long *'
Message-ID: <202504021219.U3GWMel8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git planes-20250401
head:   73685d9c23b7122b44f07d59244416f8b56ed48e
commit: 08db55297a7b060909a0121cb4ce6abbc3e6b2ea [58/62] KVM: x86: handle interrupt priorities for planes
config: i386-buildonly-randconfig-006-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021219.U3GWMel8-lkp@intel.com/config)
compiler: clang version 20.1.1 (https://github.com/llvm/llvm-project 424c2d9b7e4de40d0804dd374721e6411c27d1d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021219.U3GWMel8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021219.U3GWMel8-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/lapic.c:1327:37: error: incompatible pointer types passing 'atomic_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
    1327 |         if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
         |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bitops/instrumented-atomic.h:68:79: note: passing argument to parameter 'addr' here
      68 | static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
         |                                                                               ^
   1 error generated.
--
>> arch/x86/kvm/x86.c:11745:23: error: incompatible pointer types passing 'atomic_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
    11745 |                 clear_bit(plane_id, &plane0_vcpu->arch.irr_pending_planes);
          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bitops/instrumented-atomic.h:39:72: note: passing argument to parameter 'addr' here
      39 | static __always_inline void clear_bit(long nr, volatile unsigned long *addr)
         |                                                                        ^
   1 error generated.


vim +1327 arch/x86/kvm/lapic.c

  1313	
  1314	static void kvm_lapic_deliver_interrupt(struct kvm_vcpu *vcpu, struct kvm_lapic *apic,
  1315						int delivery_mode, int trig_mode, int vector)
  1316	{
  1317		struct kvm_vcpu *plane0_vcpu = vcpu->plane0;
  1318		struct kvm_plane *running_plane;
  1319		u16 req_exit_planes;
  1320	
  1321		kvm_x86_call(deliver_interrupt)(apic, delivery_mode, trig_mode, vector);
  1322	
  1323		/*
  1324		 * test_and_set_bit implies a memory barrier, so IRR is written before
  1325		 * reading irr_pending_planes below...
  1326		 */
> 1327		if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
  1328			/*
  1329			 * ... and also running_plane and req_exit_planes are read after writing
  1330			 * irr_pending_planes.  Both barriers pair with kvm_arch_vcpu_ioctl_run().
  1331			 */
  1332			smp_mb__after_atomic();
  1333	
  1334			running_plane = READ_ONCE(plane0_vcpu->running_plane);
  1335			if (!running_plane)
  1336				return;
  1337	
  1338			req_exit_planes = READ_ONCE(plane0_vcpu->req_exit_planes);
  1339			if (!(req_exit_planes & BIT(vcpu->plane)))
  1340				return;
  1341	
  1342			kvm_make_request(KVM_REQ_PLANE_INTERRUPT,
  1343					 kvm_get_plane_vcpu(running_plane, vcpu->vcpu_id));
  1344		}
  1345	}
  1346	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

