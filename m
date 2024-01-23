Return-Path: <kvm+bounces-6701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10138837B98
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3F7D1F28ABC
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8842B14FCE1;
	Tue, 23 Jan 2024 00:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZwbK56h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FE314DB74;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969362; cv=none; b=Zq1Gt3oID4JhKRge6oR2c0lBO8h1oPQLayh1BxQ74RLtJ0U5G35ecVKTklgqtnEjj7/EqXqP4GqGKkDQoUbqxmdZsO9zOmPBOJU0lMCcXWaC9bt2YznIRUI7sM/WuHwhslvxrHbmLFh6MmIgf1C+yIkYljmC9iE1ehVi5oyD4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969362; c=relaxed/simple;
	bh=Xx29hkn+VuZzl9NNsCbqSpiFZ4s0wixGphpqZM+kOB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jgKbB/6YJ9Az5wZv0liU6GGPj/sq7Itwy5OgrMR1/UzATlUeEHiw1aorXtmuEQHcKMJH6yJWOPVyuw8nqM+n4/jIjpG9cA8mcVecy/nCMqiESI1IQQv8y3/U4kl2DIwGsEJU98F86OX+MQoH5IOyU1VD4XKJWGbxCZ76oSi8EFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZwbK56h; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969361; x=1737505361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xx29hkn+VuZzl9NNsCbqSpiFZ4s0wixGphpqZM+kOB0=;
  b=AZwbK56hVAtv8IIAo9ah8RZhFnLZpw1KDs8AqIiJKpE01vS1TEyoDkim
   4bMTyNQLMky0ia3yS05pX+6suUjdADtz/mgk1gHFt+9ja2PTQOt0LLVBM
   FzMxfiqEgluL2DDg5ZYrqvI/aAdi+3ylIL8774wEJPXK4+7Mw0Qgvscsh
   V4VaqzgV47WcnLBU+wBxPG2qKKfkuRClAvyLwcNCntLGu8MC23pl2N9S7
   MTTLrQ0nBR9hImEqO6ELxYZaqYsEx1i5MtqlbSSICj1Ucxis3HjPGiICR
   d4QGFNJVNGgf9VzG+WaTEmAj39zRVbUFUS3F0ycvMocxh3NBQ8l4uPtMG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125666"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125666"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825643"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:38 -0800
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
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 05/13] KVM: MMU: Introduce level info in PFERR code
Date: Mon, 22 Jan 2024 16:22:20 -0800
Message-Id: <3eadceecdf5e0ed2677dbcd9d0d58963f7fa038b.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.

1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.

  TD guest will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
  4KB size.

2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.

  KVM needs to honor it because
  a) there is no way to tell guest KVM maps it as 2MB size. And
  b) guest accepts it in 4KB size since guest knows some other 4KB page
     in the same 2MB range will be used as shared page.

For case 2, it need to pass desired page level to KVM MMU page fault
handler. Use bit 29:31 of kvm PF error code for this purpose.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/mmu/mmu.c          | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b83a790b01c8..3a2237ed9dba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -262,6 +262,8 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_LEVEL_START_BIT 29
+#define PFERR_LEVEL_END_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_GUEST_ENC_BIT 34
@@ -274,6 +276,7 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
 #define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_LEVEL_MASK	GENMASK_ULL(PFERR_LEVEL_END_BIT, PFERR_LEVEL_START_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
@@ -283,6 +286,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define PFERR_LEVEL(err_code)	(((err_code) & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 53eb9508cde2..971dbd9c95cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4611,6 +4611,11 @@ bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	u8 err_level = PFERR_LEVEL(fault->error_code);
+
+	if (err_level)
+		fault->max_level = min(fault->max_level, err_level);
+
 	/*
 	 * If the guest's MTRRs may be used to compute the "real" memtype,
 	 * restrict the mapping level to ensure KVM uses a consistent memtype
-- 
2.25.1


