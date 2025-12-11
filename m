Return-Path: <kvm+bounces-65691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A350CB4926
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 03:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9666C3014596
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 02:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084CA283FF1;
	Thu, 11 Dec 2025 02:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hh36LieE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A664215667D;
	Thu, 11 Dec 2025 02:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765420814; cv=none; b=M86WDoGHsnDn0fkS7HEKDUNCtPDDHUUIFU7ux1d2bvR1fMDxUzfAl22Zc2T4LPpiNQ5Yu5ZrRPviN2iJI3Jw3MLS02ASuFOd0dDpP/7YdUI3/zj1q7GIQb9ZYmTfpjMH73pvjwJ+qcLUBlTDVSYQdcOnLxcnrKOeXFOH8WXMGPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765420814; c=relaxed/simple;
	bh=6QD2viyx6U1qsI41mGl3b7+HlcpJvmqCvETGSxqL0u8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WHJf4AtoNvus1WzY9hOAWUZPRn5IbGOCLu9UrC360F2LGD/WuKVBZZFJPVljniBO4d+pI4ab9mLzmehtl26uzb5rQJJfn6UNcMO83nv6QGNBQlnqAperDC193DPvYMF7pyN+9LPGPMQsk7Lw2BQHmz98ZBlx4B65RpJ6X5usfSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hh36LieE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765420812; x=1796956812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6QD2viyx6U1qsI41mGl3b7+HlcpJvmqCvETGSxqL0u8=;
  b=hh36LieEAWosIjQZvA7qr5mDiz1OkDhBKSSQ6PQZnTfIF7EeTVWblR51
   ITVDvisgZS5BjpTvuw83UcnuyDJOgZSb83XVEcEehwCQo9qlOjyUJyOTx
   B8HDdql9wyPyONKwKpmZtA4gOIP+dJOLMgkJOhFlzkUwL+O0XIKnbzcnv
   75lnlfrRazRcLQONOCwFe1biVv8aHRwDfVm+eHmqjf2QUyJUtl5S77+C6
   DfT0H+nQzzlDUwdPq8iT//+RbhH7q5sDL/Qp2enI6BBT2pkH13HdLeutm
   yrQfw1VvfbNNI2Sv1OwrGog0LDWcvXSxNs0sjYFdNeFRBNfhsIbQ/J4fr
   Q==;
X-CSE-ConnectionGUID: cmNa9MW0SNOJmlEA/M6LTA==
X-CSE-MsgGUID: QI0xq1Q3SAeZ1PZ4gIRwAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="71265098"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="71265098"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:40:12 -0800
X-CSE-ConnectionGUID: QlzuGHqoTqaad+2ApG7+Sw==
X-CSE-MsgGUID: ELhU9mAlRlSLlcm15Qurfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="195763886"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa006.jf.intel.com with ESMTP; 10 Dec 2025 18:40:11 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xiaoyao.li@intel.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH] KVM: x86: Don't read guest CR3 in async pf flow when guest state is protected
Date: Thu, 11 Dec 2025 10:29:35 +0800
Message-ID: <20251211022935.2049039-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't read guest CR3 when setting up the async pf task and skip comparing
the CR3 value in kvm_arch_async_page_ready() when guest state is protected.

When KVM tries to perform the host-only async page fault for the shared
memory of TDX guests, the following WARNING is triggered:

  WARNING: CPU: 1 PID: 90922 at arch/x86/kvm/vmx/main.c:483 vt_cache_reg+0x16/0x20
  Call Trace:
  __kvm_mmu_faultin_pfn
  kvm_mmu_faultin_pfn
  kvm_tdp_page_fault
  kvm_mmu_do_page_fault
  kvm_mmu_page_fault
  tdx_handle_ept_violation

This WARNING is triggered when calling kvm_mmu_get_guest_pgd() to cache
the guest CR3 in kvm_arch_setup_async_pf() for later use in
kvm_arch_async_page_ready() to determine if it's possible to fix the
page fault in the current vCPU context to save one VM exit. However, when
guest state is protected, KVM cannot read the guest CR3.

Check guest_state_protected to avoid calling kvm_mmu_get_guest_pgd() to
read guest CR3 in async page fault flow:
 - In kvm_arch_setup_async_pf(), use dummy 0 when guest state is
   protected.

 - In kvm_arch_async_page_ready(), skip reading CR3 for comparison when
   guest state is protected.

Reported-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
For AMD SEV-ES and SNP cases, the guest state is also protected. But
unlike TDX, reading guest CR3 doesn't cause issue since CR3 is always
marked available for svm vCPUs. It always gets the initial value 0,
set by kvm_vcpu_reset(). Whether to update vcpu->arch.regs_avail to
reflect the correct value for SEV-ES and SNP is another topic.
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5..03be521df6b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4521,7 +4521,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
 	arch.gfn = fault->gfn;
 	arch.error_code = fault->error_code;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
-	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+	arch.cr3 = vcpu->arch.guest_state_protected ? 0 :
+		   kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, fault->addr,
 				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
@@ -4543,7 +4544,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
+	    (vcpu->arch.guest_state_protected ||
+	     work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu)))
 		return;
 
 	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,

base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.43.0


