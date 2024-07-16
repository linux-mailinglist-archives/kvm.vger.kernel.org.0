Return-Path: <kvm+bounces-21678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E6D5931E6B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 03:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8AE41F217CD
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 01:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEAA5227;
	Tue, 16 Jul 2024 01:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TFyzdLiu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F94A1D;
	Tue, 16 Jul 2024 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721092968; cv=none; b=FyLs1p4w2ejmYceN/N3A9TJVShxNC7HH/B3mJbaVfCKAAFsKo+Pty7EwlseEAMZ75QSjyZYKkiKYHlgMP4rAQj1hrrtjXGtaW528d/oVLj4ai8zI9K6kTFGVIeIzj0sGDtq73RA8CcvrQswRXwLQ6unUmT4/BCDinvBUZs03c0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721092968; c=relaxed/simple;
	bh=K86S4bf5U2cLcQRyNVwiFpzDVU6RQnfUaqq81mNIPt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eXUsIzZegMb1H9mn2yI4zpZb9xpwNO4vy6E9o1nkTf3Djc0cfMekHts/Q1ofj9WTZ9kk+pHMjqR7c3R/H3soUocERWX2JHDXP/YtRZ5PvMzTUJOpOXJkRpjK+QAAAbajxE5d7a07XO9yqMb0Bh3E6pxSV6UfVsVbhLTDLL7apG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TFyzdLiu; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721092966; x=1752628966;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K86S4bf5U2cLcQRyNVwiFpzDVU6RQnfUaqq81mNIPt8=;
  b=TFyzdLiuOIUgwO7vE+svNFQ/xQreBoVTgxtakhqa7NvlEqfrIXd8t+F0
   ztYVmGkLUfzguadIQqwXesHJNaSJYhJ9HRNNy49eMjiOdpUV10e4k1F2K
   tHxEQgQuu1GMocMCQqLA/NkJQV2wkbIyC/Nea692dnXZOqf8UiEoBa0Ob
   KSZbqu/eVt7uP57JL3W5R0LQFKd+o5xgKnBphNLD9jNw3uz2DT1E1xwGr
   piTBMIWQo9NAt1cC5QJ4PPKGsU+ljH3yPPbqyh3FMxnkptP9gHZAbKo83
   dWauKAbKn47Iv/A8HunmM1SH5/pvsdv3thhnMp5iYYdT3jHg6G9ACAHea
   A==;
X-CSE-ConnectionGUID: tfqSE57/S4eF703qW0I15w==
X-CSE-MsgGUID: 9MwolGKeSl6tmiSYuzGPig==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18214690"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18214690"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 18:22:45 -0700
X-CSE-ConnectionGUID: V1XNNhHJTnGte1BUDUyPvg==
X-CSE-MsgGUID: ZFI1LB1+SeSaQXyG0jZB5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="80502885"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 18:22:45 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Add GPA limit check to kvm_arch_vcpu_pre_fault_memory()
Date: Mon, 15 Jul 2024 18:22:39 -0700
Message-ID: <f2a46971d37ee3bf32ff33dc730e16bf0f755410.1721091397.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add GPA limit check to kvm_arch_vcpu_pre_fault_memory() with guest
maxphyaddr and kvm_mmu_max_gfn().

The KVM page fault handler decides which level of TDP to use, 4-level TDP
or 5-level TDP based on guest maxphyaddr (CPUID[0x80000008].EAX[7:0]), the
host maxphyaddr, and whether the host supports 5-level TDP or not.  The
4-level TDP can map GPA up to 48 bits, and the 5-level TDP can map GPA up
to 52 bits.  If guest maxphyaddr <= 48, KVM uses 4-level TDP even when the
host supports 5-level TDP.

If we pass GPA > beyond the TDP mappable limit to the TDP MMU fault handler
(concretely GPA > 48-bits with 4-level TDP), it will operate on GPA without
upper bits, (GPA & ((1UL < 48) - 1)), not the specified GPA.  It is not
expected behavior.  It wrongly maps GPA without upper bits with the page
for GPA with upper bits.

KVM_PRE_FAULT_MEMORY calls x86 KVM page fault handler, kvm_tdp_page_fault()
with a user-space-supplied GPA without the limit check so that the user
space can trigger WARN_ON_ONCE().  Check the GPA limit to fix it.

- For non-TDX case (DEFAULT_VM, SW_PROTECTED_VM, or SEV):
  When the host supports 5-level TDP, KVM decides to use 4-level TDP if
  cpuid_maxphyaddr() <= 48.  cpuid_maxhyaddr() check prevents
  KVM_PRE_FAULT_MEMORY from passing GFN beyond mappable GFN.

- For TDX case:
  We'd like to exclude shared bit (or gfn_direct_mask in [1]) from GPA
  passed to the TDP MMU so that the TDP MMU can handle Secure-EPT or
  Shared-EPT (direct or mirrored in [1]) without explicitly
  setting/clearing the GPA (except setting up the TDP iterator,
  tdp_iter_refresh_sptep()).  We'd like to make kvm_mmu_max_gfn() per VM
  for TDX to be 52 or 47 independent of the guest maxphyaddr with other
  patches.

Fixes: 6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e0e9963066f..6ee5af55cee1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4756,6 +4756,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	u64 end;
 	int r;
 
+	if (range->gpa >= (1UL << cpuid_maxphyaddr(vcpu)))
+		return -E2BIG;
+	if (gpa_to_gfn(range->gpa) > kvm_mmu_max_gfn())
+		return -E2BIG;
+
 	/*
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.

base-commit: c8b8b8190a80b591aa73c27c70a668799f8db547
-- 
2.45.2


