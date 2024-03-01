Return-Path: <kvm+bounces-10662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C9286E743
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 088822829FF
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2307538FAF;
	Fri,  1 Mar 2024 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Da//ITgG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07DC1118E;
	Fri,  1 Mar 2024 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314188; cv=none; b=JBgAJC890n2x7tgx85x9QtJPMCfPInPHcCsdt6/HluR94h9Agqhy2L7XCJFvhC6cWrlkoQ5HAEg4jqXkO5yqadQ2ju66u5WCQ8I7B4LpNr8JLuhePT9fdFUxBBAtFR4VBK4oGmxgMx251cOEV4NYUVlf4WyU+KUmNSKcwV8bUrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314188; c=relaxed/simple;
	bh=zO7tKEhbr1x5xw4j54wsZXmRlpVUaAL+sOxG9bhlihY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RAuerpOvfoK711Dm7bjBKxOVQDTWCUEuXGTpbw8D84RiNT6paswUOIb8qXEEKv8IiKO98ZpAWKJpYPbVM7aGawGkh5SrBOIhW50I8vPtsLql3WBwmTbKqwpaUQcL/ZLN0nWULlcE+l5dXekY5qhf1srb3tjdxBIZy1hCwz6IrNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Da//ITgG; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314186; x=1740850186;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zO7tKEhbr1x5xw4j54wsZXmRlpVUaAL+sOxG9bhlihY=;
  b=Da//ITgG9Fvc3kqtCludp5oiuHMcWDYgdPEyI+8tqBNa/M3sf9BIwAXU
   UDpQsQ3uYwOkLcKpgqGhW4eynrai+8teOdUrqbaYh6LD3FnmICcLiSud3
   Fj5S5gA+Pq+j5LauPTCAD3+i6UXZqbmvUPSdwFIpTkagT+pXlPqmAOMi9
   K+p9YjcFtheuRYodeKzd945f/YwxRDb3ovFwJbLyEEUI6PqB/isn0Uj2/
   cybQZ8Q1eQf1lZMCLqjmxi7cZb/lp/H58ih0ri7zPmB2dljLUKYnoAT3A
   f2ZJJh/ya4et/P8Ln9J4J07ndWLjQHB4z4H/IlXl9zxgpz4vHTwbk6toQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812409"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812409"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946553"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:25 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 4/8] KVM: x86/mmu: Factor out kvm_mmu_do_page_fault()
Date: Fri,  1 Mar 2024 09:28:46 -0800
Message-Id: <291c6458504aee05af8d6323a6eafbbd155590df.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For ioctl to pre-populate guest memory, factor out kvm_mmu_do_page_fault()
into initialization function of struct kvm_page_fault, calling fault hander,
and the surrounding logic of error check and stats update part.  This
enables to implement a wrapper to call fault handler.

No functional change intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 72ef09fc9322..aac52f0fdf54 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -302,6 +302,24 @@ enum {
 	.pfn = KVM_PFN_ERR_FAULT,						\
 	.hva = KVM_HVA_ERR_BAD, }
 
+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu,
+					  struct kvm_page_fault *fault)
+{
+	int r;
+
+	if (vcpu->arch.mmu->root_role.direct) {
+		fault->gfn = fault->addr >> PAGE_SHIFT;
+		fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+	}
+
+	if (IS_ENABLED(CONFIG_RETPOLINE) && fault->is_tdp)
+		r = kvm_tdp_page_fault(vcpu, fault);
+	else
+		r = vcpu->arch.mmu->page_fault(vcpu, fault);
+
+	return r;
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch, int *emulation_type)
 {
@@ -310,11 +328,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 							  KVM_MAX_HUGEPAGE_LEVEL);
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
-		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
-	}
-
 	/*
 	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
 	 * guest perspective and have already been counted at the time of the
@@ -323,10 +336,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
-		r = kvm_tdp_page_fault(vcpu, &fault);
-	else
-		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+	r = __kvm_mmu_do_page_fault(vcpu, &fault);
 
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
-- 
2.25.1


