Return-Path: <kvm+bounces-22003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84048937E8D
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 02:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3922A1F21979
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 00:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13E23FE4;
	Sat, 20 Jul 2024 00:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i9U2/AsR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B331C27
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721436116; cv=none; b=Zflu4KUfFv/+qI/T7gXZs0L+POksddp9KL0yu9bnfITxnB8XtKVZFxiGfhgS2oVvrU7GLS8m7GiCisM/wJdq/PYSHosiAyP34faot0tHiyVc3x/tEA2bITsg4kzkY3U62ZJzODgCypfGcbjD/ZCrPBB+83mh5DS25zdDfenld74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721436116; c=relaxed/simple;
	bh=99IlsR+4uA3hohBzyAVPboEZsi/F4jHWieDcLK+ZmzM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s9+RHfSLPI6nweg3PSPkmOCG1B7CRuu43JVZV04Tqe+OsmNJq49zn48d7Kn2SmWo3AKyry70pq4kmZh9qm0pxK0TaBfD5YUBgMg7Kk3z5UJLZRK8R5Y4nNsniFrsNCLpttGfP5lelIKWpKYavgqwvXHsCK/6sW+6u9tkMKNk/Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i9U2/AsR; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721436115; x=1752972115;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=99IlsR+4uA3hohBzyAVPboEZsi/F4jHWieDcLK+ZmzM=;
  b=i9U2/AsRN8cCvEbfbzqBkmQvAbsagwTXDgn+F/K/3g/Q3gyHxrONlF+B
   n9h8NqZzRF6X6wsjRXEgOmJZaHEUY/1iFQgInvIehsUo8C1ewgEvy+Bzd
   RvswSgbQNUIFbtuNe1kp+fF7R5UAhkP4viGWvk3gMYnx8q8QTs+RJAlj9
   Pp7TURD9XK3xkndHOcZjGTdefGfgXt7S2DGQWBufP+Qu9rIIzeA5kOuOq
   QpfmMtnk5c2qnI3kyUrfl4TF5tc/paZPvOcD2BWF53Pmy37fcSn77BsIH
   h7+50286Y+v2QLnp/RimeWA7vafhWCIgPKZHNdtL3WsGYyK7T9boQ9Wll
   Q==;
X-CSE-ConnectionGUID: XvfsMl9ARBii2MuxLYGL9w==
X-CSE-MsgGUID: qMEchMdsReyFqam9WqrFjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11138"; a="29733830"
X-IronPort-AV: E=Sophos;i="6.09,222,1716274800"; 
   d="scan'208";a="29733830"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 17:41:54 -0700
X-CSE-ConnectionGUID: WHKwovA4Q9aJ2rHv5NPeUQ==
X-CSE-MsgGUID: 8MjYem7XQrqSqiJ8JNLiSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,222,1716274800"; 
   d="scan'208";a="51997217"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 19 Jul 2024 17:41:52 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sUyAX-000iiA-2l;
	Sat, 20 Jul 2024 00:41:49 +0000
Date: Sat, 20 Jul 2024 08:41:27 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:queue 22/34] arch/x86/kvm/x86.c:12650:12: error: no member
 named 'pre_fault_allowed' in 'struct kvm_arch'
Message-ID: <202407200826.iiOlgVtf-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   90433378a1bea709c362a855c99b4662c92e49be
commit: ca9ddf0b7d74a71b6d71ea5355825922b89f5fd7 [22/34] KVM: x86: disallow pre-fault for SNP VMs before initialization
config: i386-randconfig-141-20240720 (https://download.01.org/0day-ci/archive/20240720/202407200826.iiOlgVtf-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240720/202407200826.iiOlgVtf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407200826.iiOlgVtf-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:12650:12: error: no member named 'pre_fault_allowed' in 'struct kvm_arch'
    12650 |         kvm->arch.pre_fault_allowed =
          |         ~~~~~~~~~ ^
   1 error generated.
--
>> arch/x86/kvm/mmu/mmu.c:4746:23: error: no member named 'pre_fault_allowed' in 'struct kvm_arch'
    4746 |         if (!vcpu->kvm->arch.pre_fault_allowed)
         |              ~~~~~~~~~~~~~~~ ^
   1 error generated.
--
>> arch/x86/kvm/svm/svm.c:4952:13: error: no member named 'pre_fault_allowed' in 'struct kvm_arch'
    4952 |                 kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
         |                 ~~~~~~~~~ ^
   1 error generated.


vim +12650 arch/x86/kvm/x86.c

 12636	
 12637	
 12638	int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 12639	{
 12640		int ret;
 12641		unsigned long flags;
 12642	
 12643		if (!kvm_is_vm_type_supported(type))
 12644			return -EINVAL;
 12645	
 12646		kvm->arch.vm_type = type;
 12647		kvm->arch.has_private_mem =
 12648			(type == KVM_X86_SW_PROTECTED_VM);
 12649		/* Decided by the vendor code for other VM types.  */
 12650		kvm->arch.pre_fault_allowed =
 12651			type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 12652	
 12653		ret = kvm_page_track_init(kvm);
 12654		if (ret)
 12655			goto out;
 12656	
 12657		kvm_mmu_init_vm(kvm);
 12658	
 12659		ret = kvm_x86_call(vm_init)(kvm);
 12660		if (ret)
 12661			goto out_uninit_mmu;
 12662	
 12663		INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 12664		atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 12665	
 12666		/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 12667		set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 12668		/* Reserve bit 1 of irq_sources_bitmap for irqfd-resampler */
 12669		set_bit(KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
 12670			&kvm->arch.irq_sources_bitmap);
 12671	
 12672		raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 12673		mutex_init(&kvm->arch.apic_map_lock);
 12674		seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
 12675		kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 12676	
 12677		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 12678		pvclock_update_vm_gtod_copy(kvm);
 12679		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 12680	
 12681		kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 12682		kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 12683		kvm->arch.guest_can_read_msr_platform_info = true;
 12684		kvm->arch.enable_pmu = enable_pmu;
 12685	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

