Return-Path: <kvm+bounces-23918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5DD94FA02
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07C6AB22DAA
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32681A38CA;
	Mon, 12 Aug 2024 22:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0cR/LLX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346451A0B07;
	Mon, 12 Aug 2024 22:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502931; cv=none; b=hHosPBkW9+9Yq7nWV0oC6p8oTosJ1YC5hMGg7D3bfeXaaHwhkUMdgFSkWwdU2Exmf/+yGmKEZOA2AVdvBqtcuHkIWGnwUUukJAkiYkW+MRFkOiiL6INgKugY/hSlmEgtx4VDsWoXZyIPqMHDEKV8dvog7lhMkIIQcPkn0mt0STM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502931; c=relaxed/simple;
	bh=XIFhgsS6zqe720LVooXdtdZp14vJaW+49JUGtZO8bOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cexOirSYH1HQZakd5LoFkIzR+vLqhVohZizExaSidK1VrW8WapJzr8ULPi7TjunjEqt+SUbDiChyDckMh6YUVtSEGa7IC9fQeKCPamMmb6hPRuxWxwzMFvID26a9DUsn8EgjbNiFoxNmOtl+aODaEyF+9b7Tl/kvcJJ70nGMi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0cR/LLX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502929; x=1755038929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XIFhgsS6zqe720LVooXdtdZp14vJaW+49JUGtZO8bOk=;
  b=L0cR/LLXyV7xRFjJNjQanA4iNxt+67DASd2lrdfL0ibEHUf68GGG1hXH
   4CEO203C6ZxEuWAxgQ2fb6EV7p3I6bjHTzEZx7AVo6WpRln4lYK63aH39
   rpbCUFPrbtc1HM4LhC+Nl3FRNPe6TsPlfENByzZgjExSE7w0ivHCxQpEh
   JzTG53U0Y380icn+QMA0kOLnEGbWEGQEH6oy/JDWaT9vRTC7uBIoNFgG6
   wPP67JduVu3YpHIMIg5uSD409UqsLiH2w+Q+hqus6uuYasPQHLdf98N3m
   LttQWAX4cg0oYHprEFArD55oyKfjuNm8omX+UuaAWgV874z/lFUGKUFeZ
   A==;
X-CSE-ConnectionGUID: 5klYzvdsTrKM3jkoeDoThg==
X-CSE-MsgGUID: S9uIeY88R3W1EEDMhlkgbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041493"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041493"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:39 -0700
X-CSE-ConnectionGUID: ELLNTBYTRyyvtYnyJzUYbQ==
X-CSE-MsgGUID: lpPzjbA7Q5KmpR7IK7doCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008458"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:39 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 23/25] KVM: x86/mmu: Taking guest pa into consideration when calculate tdp level
Date: Mon, 12 Aug 2024 15:48:18 -0700
Message-Id: <20240812224820.34826-24-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

For TDX, the maxpa (CPUID.0x80000008.EAX[7:0]) is fixed as native and
the max_gpa (CPUID.0x80000008.EAX[23:16]) is configurable and used
to configure the EPT level and GPAW.

Use max_gpa to determine the TDP level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/kvm/cpuid.c   | 14 ++++++++++++++
 arch/x86/kvm/cpuid.h   |  1 +
 arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 499479c769d8..ebebff0dbd3b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -423,6 +423,20 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 	return 36;
 }
 
+int cpuid_query_maxguestphyaddr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000000);
+	if (!best || best->eax < 0x80000008)
+		goto not_found;
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
+	if (best)
+		return (best->eax >> 16) & 0xff;
+not_found:
+	return 0;
+}
+
 /*
  * This "raw" version returns the reserved GPA bits without any adjustments for
  * encryption technologies that usurp bits.  The raw mask should be used if and
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 5cc13d1b7991..2db458e4c450 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -39,6 +39,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 u32 xstate_required_size(u64 xstate_bv, bool compacted);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
+int cpuid_query_maxguestphyaddr(struct kvm_vcpu *vcpu);
 u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu);
 
 static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3a00bf062a46..694edcb7ef46 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5440,12 +5440,20 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
+	int maxpa = 0;
+
+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
+		maxpa = cpuid_query_maxguestphyaddr(vcpu);
+
+	if (!maxpa)
+		maxpa = cpuid_maxphyaddr(vcpu);
+
 	/* tdp_root_level is architecture forced level, use it if nonzero */
 	if (tdp_root_level)
 		return tdp_root_level;
 
 	/* Use 5-level TDP if and only if it's useful/necessary. */
-	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
+	if (max_tdp_level == 5 && maxpa <= 48)
 		return 4;
 
 	return max_tdp_level;
-- 
2.34.1


