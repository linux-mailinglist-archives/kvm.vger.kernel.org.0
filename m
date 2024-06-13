Return-Path: <kvm+bounces-19541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378BB9063C1
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78E6EB22F53
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AB41369B8;
	Thu, 13 Jun 2024 06:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4SbOM1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD7937C;
	Thu, 13 Jun 2024 06:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718258902; cv=none; b=WiTexwUls+7+FusSgc0MxPZVtW026/A0jlMuR9ZIMo2JccvPcerBeirxzjwL7wJON1lLR9rz4UWiSEVd6QlZcem69bJncBCxnV2EUK0+2EwFpitO6JKpvH7jnqyszMvrOq+fnoJcAM1+Ndpfvz3P3Jw4bt9yxH0tL4E/H9Fx72Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718258902; c=relaxed/simple;
	bh=Cp2n1ms44VPV1wVnQ2RgsVSScJkfyl43lwf7fGOejlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jFKomUGw+jeuPaghMZ0G4duJakmAKx7KGpQkj2CXMwL1khs5CCl2GnKRl4XHzE4KkzxSEj5T678Pwo3IdjvGkFL0ZI92L+a+7mQcpY4Px0tTCxf5HbGv1oxhlxYVavZvG0OPKtjvtAHGkJ02Bsh5/q4YNDtJ8/2qK1KVqjJCLUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4SbOM1v; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718258901; x=1749794901;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cp2n1ms44VPV1wVnQ2RgsVSScJkfyl43lwf7fGOejlU=;
  b=i4SbOM1v3hysVYmjaQ7AalTPqusdPZr/0n0wuZePFwyZEuCYDr4bS+oJ
   hgIDs386KNq0oDqTTJNMhLXe4vfdPm/JAq3RVQ0mNeWJ4ZRPYdKNl91sA
   CIQszs8TB3qLdjqr0WqSziN3DcPk2fdR2YOJlEQ7FhkbkIGBEBVw20Fcb
   iUDunILxGLVIV0WHJLbYGDrDzwDs3TE5/+eFNWsi4WNRIAW1KERipUMaQ
   zIQLkG2n5TTaIPnoKDEqb6eeb967ALhOdEuvDzvoxpQDwGLOE0il7BgG7
   KXIN/MyffX222tzGOrGH//nGHnSb8GqTWpGFN3mITuTvk42RA7Q7d68Ds
   A==;
X-CSE-ConnectionGUID: uq+wPOI5TrWL6VKYK2cwgQ==
X-CSE-MsgGUID: EdiijhlLRfeh5GRUXPGUrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15022224"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="15022224"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:08:20 -0700
X-CSE-ConnectionGUID: 5/3wytczQAulHmbtaadTCw==
X-CSE-MsgGUID: e0n0+TiqTPii1AzGUhxCEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="39952987"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:08:17 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Date: Thu, 13 Jun 2024 14:06:59 +0800
Message-ID: <20240613060708.11761-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Today "zapping only memslot leaf SPTEs" on moving/deleting a memslot is not
done. Instead, KVM opts to invalidate all page tables and generate fresh
new ones based on the new memslot layout (referred to as "zap all" for
short). This "zap all" behavior is of low overhead for most use cases, and
is adopted primarily due to a bug which caused VM instability when a VM is
with Nvidia Geforce GPU assigned (see link in patch 1).

However, the "zap all" behavior is not desired for certain specific
scenarios. e.g.
- It's not viable for TDX,
  a) TDX requires root page of private page table remains unaltered
     throughout the TD life cycle.
  b) TDX mandates that leaf entries in private page table must be zapped
     prior to non-leaf entries.
  c) TDX requires re-accepting of private pages after page dropping.
- It's not performant for scenarios involving frequent deletion and
  re-adding of numerous small memslots.

This series therefore introduces the KVM_X86_QUIRK_SLOT_ZAP_ALL quirk,
enabling users to control the behavior of memslot zapping when a memslot is
moved/deleted.

The quirk is turned on by default, leading to invalidation/zapping to all
SPTEs when a memslot is moved/deleted.

Users have the option to turn off the quirk. Doing so will limit the
zapping to only leaf SPTEs within the range of memslot being moved/deleted.

This series has been tested with
- Normal VMs
  w/ and w/o device assignment, and kvm selftests

- TDX guests.
  Memslot deletion typically does not occur without device assignment for a
  TD. Therefore, it is tested with shared device assignment.

Note: For TDX integration, the quirk is currently disabled via TDX code in
      QEMU rather than being automatically disabled based on VM type in
      KVM, which is not safe. A malfunctioning QEMU that fails to disable
      the quirk could result in the shared EPT being invalidated while the
      private EPT remains unaffected, as kvm_mmu_zap_all_fast() only
      targets the shared EPT.      

      However, current kvm->arch.disabled_quirks is entirely
      user-controlled, and there is no mechanism for users to verify if a
      quirk has been disabled by the kernel.
      We are therefore wondering which below options are better for TDX:

      a) Add a condition for TDX VM type in kvm_arch_flush_shadow_memslot()
         besides the testing of kvm_check_has_quirk(). It is similar to
         "all new VM types have the quirk disabled". e.g.

         static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)                    
         {                                                                                
              return kvm->arch.vm_type != KVM_X86_TDX_VM &&                               
                     kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);                
         }
         
      b) Init the disabled_quirks based on VM type in kernel, extend
         disabled_quirk querying/setting interface to enforce the quirk to
         be disabled for TDX.

Patch 1:   KVM changes.
Patch 2-5: Selftests updates. Verify memslot move/deletion functionality
           with the quirk enabled/disabled.


Yan Zhao (5):
  KVM: x86/mmu: Introduce a quirk to control memslot zap behavior
  KVM: selftests: Test slot move/delete with slot zap quirk
    enabled/disabled
  KVM: selftests: Allow slot modification stress test with quirk
    disabled
  KVM: selftests: Test memslot move in memslot_perf_test with quirk
    disabled
  KVM: selftests: Test private access to deleted memslot with quirk
    disabled

 Documentation/virt/kvm/api.rst                |  6 ++++
 arch/x86/include/asm/kvm_host.h               |  3 +-
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/mmu/mmu.c                        | 36 ++++++++++++++++++-
 .../kvm/memslot_modification_stress_test.c    | 19 ++++++++--
 .../testing/selftests/kvm/memslot_perf_test.c | 12 ++++++-
 .../selftests/kvm/set_memory_region_test.c    | 29 ++++++++++-----
 .../kvm/x86_64/private_mem_kvm_exits_test.c   | 11 ++++--
 8 files changed, 102 insertions(+), 15 deletions(-)

base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
-- 
2.43.2

