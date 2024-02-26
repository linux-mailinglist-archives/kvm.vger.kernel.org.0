Return-Path: <kvm+bounces-9642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE724866C5A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89560281170
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C69B54900;
	Mon, 26 Feb 2024 08:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMOlfcli"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E452F86;
	Mon, 26 Feb 2024 08:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936071; cv=none; b=R6Aa9mkw1JpWzjiUe2uXibZkGAZPmyve59edPLs7j4I6G5YtZpK3Ek+xN2suoonvQsmS90JoZXcAjuPETJr2qnGCEYopEzkQoyr1JWvIdjUbuDthDAHkYXt4hDyaxQz4DmYm+IPMiLUr9n9w0skKA8nj2F9Fj7L6I9kuPMmgCGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936071; c=relaxed/simple;
	bh=gBqTh0BqhczjXbWb42Bx3PUV8vhAtv81RcTY6rA0AfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lcw8/OpnX710CDmEjSFFsHdxh5RbdrZqdMxmgjjGf43kXpqjME2oRa9QzM7f5Z0EMYKc//QbjybRu5oW6HeA4U7hG2eqUDJ8AKmOv9P1SSO6S5XB4iB1LL2ZrUUvmHtxCnnLfxAPQZ7M8a7xOje6lkfvVJtfYUHC33oFoyGOpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMOlfcli; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936069; x=1740472069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gBqTh0BqhczjXbWb42Bx3PUV8vhAtv81RcTY6rA0AfQ=;
  b=bMOlfcliAAiavUwFuqQ/8EYVSX9Bw85QWmgmZtz2Y0YLLhWdHzxLE4Ty
   bVSo+sXPebCbjIRlH8Xc+Qcz6bocvFRS2HQwJXGSxMCNVH0WUYCiJ3REL
   0c8BeK/TlmcAnCb6YeWARBEcuV1MFk8uLPBWQkhLqI/TDz1VQ8d1QyQFp
   XQ1SirVMLA3O5gs7Wg42zdOv02vTTwJDRtSMZ9H9APN3Yx9kECtnMXEFc
   1FAr7OpZ4iHNZY3x78/ErLUX3ASOQU9sFWSRlm6rdsoZvorA+R35TDJvz
   OWhfgSWBaYKJtAZiDBSXPiv/LVlED8zvlVWDhoukWNWCe1f11UqDjLMNh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631502"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631502"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474353"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:44 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Date: Mon, 26 Feb 2024 00:25:20 -0800
Message-Id: <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

TODO: Drop this patch once the common patch is merged.

When memory slot isn't found for kvm page fault, handle it as MMIO.

The guest of TDX_VM, SNP_VM, or SW_PROTECTED_VM don't necessarily convert
the virtual MMIO range to shared before accessing it.  When the guest tries
to access the virtual device's MMIO without any private/shared conversion,
An NPT fault or EPT violation is raised first to find private-shared
mismatch.  Don't raise KVM_EXIT_MEMORY_FAULT, fall back to KVM_PFN_NOLSLOT.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Added slot check before kvm_faultin_private_pfn()
- updated comment
- rewrite the commit message
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ca0c91f14063..c45252ed2ffd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4342,6 +4342,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	bool force_mmio;
 	bool async;
 
 	/*
@@ -4371,12 +4372,21 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	/*
+	 * !fault->slot means MMIO for SNP and TDX.  Don't require explicit GPA
+	 * conversion for MMIO because MMIO is assigned at the boot time.  Fall
+	 * to !is_private case to get pfn = KVM_PFN_NOSLOT.
+	 */
+	force_mmio = !slot &&
+		vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM &&
+		vcpu->kvm->arch.vm_type != KVM_X86_SW_PROTECTED_VM;
+	if (!force_mmio &&
+	    fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
 
-	if (fault->is_private)
+	if (!force_mmio && fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
-- 
2.25.1


