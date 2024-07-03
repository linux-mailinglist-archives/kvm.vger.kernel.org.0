Return-Path: <kvm+bounces-20859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D154924D7F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 921F3282F4D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA3D4C6C;
	Wed,  3 Jul 2024 02:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eU1zw5C3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1374683;
	Wed,  3 Jul 2024 02:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972642; cv=none; b=iCQDFZg1kYdppO2aW48n6lZt10LzHK8xw+R8G++doKOgwn+6WMuBGxMNxx4F8drqBqZ1Y4s047iL+l57oNnJyt/7VN8A4tF98sv+HV4NdmbDr3q/yj2BDMTcUIGzxAGbRp1jKDAnzvEjr54wPWdgJsTqiOK8P+MIpVxWaS1H7rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972642; c=relaxed/simple;
	bh=j+2F1YArlmqv4oKDkCZxtciGodZJCY5VgiWXWEJtliU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oRQEd6jrNtllvflxyYhrSQKfOI+8fxrDC0QOnggURlrVbItkUkYO0n0aM+BafVHOdN0otPbi+rxyzKROS3EvIK/QFHJfnC90AHMiNr09ba5XdBoOtUPh9WnTgysiTDllrnkVWKuRZvE4qArxbYyo/mt8POf+APeJlCtWdWD/eNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eU1zw5C3; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972641; x=1751508641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j+2F1YArlmqv4oKDkCZxtciGodZJCY5VgiWXWEJtliU=;
  b=eU1zw5C3PYpqLluA+QkCzTLCNmTjLQDGukpHoI7S/wfmJ0lGXiP12t/w
   wocEsgqbYxkUI4RMGMloWjvNEJrMnyan8NBRf3xZWicJTsglgzUuDBrKk
   57cDnKZFOdjIfBjLmvyayA2fRFKwV4LD8OI/a0og4+QL2+KxzLLQNzLle
   g95PSsXKkkmy2Zk4PFzOmfKTJ9j8/5Vq7A4KHRMZWvhxcAwcm0ESybQQI
   vqkxYHd5qYiYED5yaaLj26J7jivL66BVwlqmx5w9MRZhjkNmN/p5WamNb
   iQ5gyVKMhXB4LfTJQFNl0nJprQVqqnBJRVfVbzanO7dvap9HC6aEDWCHp
   Q==;
X-CSE-ConnectionGUID: FunKFDs1QPGCIN0R7bDAGg==
X-CSE-MsgGUID: fpQPfx5TTKmOOr9wHv2JlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17389754"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17389754"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:10:40 -0700
X-CSE-ConnectionGUID: SBWBMI4aQaeJ+8ZCciMzvw==
X-CSE-MsgGUID: PwKLGf60SzOFchBqFKzZrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="45963862"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:10:37 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/4] Introduce a quirk to control memslot zap behavior
Date: Wed,  3 Jul 2024 10:09:20 +0800
Message-ID: <20240703020921.13855-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Today "zapping only leaf SPTEs with memslot range" ("zap-slot-leafs-only"
for short) on moving/deleting a memslot is not done. Instead, KVM opts to
invalidate all page tables and generate fresh new ones based on the new
memslot layout ("zap-all" for short). This "zap-all" behavior is of low
overhead for most use cases, and is adopted primarily due to a bug which
caused VM instability when a VM is with Nvidia Geforce GPU assigned (see
link in patch 1).

However, the "zap-all" behavior is not desired for certain specific
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
moved/deleted for VMs of type KVM_X86_DEFAULT_VM.

The quirk is turned on by default for VMs of type KVM_X86_DEFAULT_VM,
leading to "zap-all" behavior.

Users have the option to turn off the quirk. Doing so will have KVM go
"zap-slot-leafs-only" on memslot moving/deleting.

KVM will always select "zap-slot-leafs-only" as if the quirk is disabled
for non-KVM_X86_DEFAULT_VM VMs for reasons explained in patch 1.

This series has been tested with
- Normal VMs
  w/ and w/o device assignment, and kvm selftests

- TDX guests.
  Tested with shared device assignment and guest memory hot-plug/unplug.

It can be applied to both kvm/queue and kvm-coco-queue.

Patch 1:   KVM changes.
Patch 2-4: Selftests updates. Verify memslot move/deletion functionality
           with the quirk enabled/disabled.

Changelog:
v1 --> v2:
- Make KVM behave as if the quirk is always disabled on
  non-KVM_X86_DEFAULT_VM VMs. (Sean, Rick)
- Removed the patch for selftest private_mem_kvm_exits_test, since that
  selftest is for VM type KVM_X86_SW_PROTECTED_VM.

v1: https://lore.kernel.org/all/20240613060708.11761-1-yan.y.zhao@intel.com


Yan Zhao (4):
  KVM: x86/mmu: Introduce a quirk to control memslot zap behavior
  KVM: selftests: Test slot move/delete with slot zap quirk
    enabled/disabled
  KVM: selftests: Allow slot modification stress test with quirk
    disabled
  KVM: selftests: Test memslot move in memslot_perf_test with quirk
    disabled

 Documentation/virt/kvm/api.rst                |  8 ++++
 arch/x86/include/asm/kvm_host.h               |  3 +-
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/mmu/mmu.c                        | 42 ++++++++++++++++++-
 .../kvm/memslot_modification_stress_test.c    | 19 ++++++++-
 .../testing/selftests/kvm/memslot_perf_test.c | 12 +++++-
 .../selftests/kvm/set_memory_region_test.c    | 29 +++++++++----
 7 files changed, 101 insertions(+), 13 deletions(-)

-- 
2.43.2


