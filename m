Return-Path: <kvm+bounces-6707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4968E837BB9
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62E561C251F0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624E01534E3;
	Tue, 23 Jan 2024 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K6mCCVX0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9072E14E2CF;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969368; cv=none; b=pYaRKxyYE+XUjJ06ARitPwf4flTqFD4UOR7pwwBQQ8ALSEmLzuKilv3Wx7ktjDNoABtW54EWwsbQMdHK3Rx/QanApptRQaz0beEx8v98oM+q8/aBWug6r4Cqqx7F54ujI66P/cHq1urCx1KCPCBvTjxi7shzSUWHYMD6mWUAqv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969368; c=relaxed/simple;
	bh=anTVTNUztn2JGpPeY0WJZiZzHDCKn+UgMrVUKZCXJiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pvbfWwmixfNAJZpAl/u/wYsSZw9fiMf6moUdYwGnrISzyYRfxfHADgzQc69awjGeH9JyBUzRc/iZdtxKOD1Z9wcnHjc38XxJEKegYmFUrOhU86JPVIBxolwfYIwcGUdSZaD95Q1hEZ5ecCKk/TuVBEefzTfR55fywj/s3YBKQq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K6mCCVX0; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969361; x=1737505361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=anTVTNUztn2JGpPeY0WJZiZzHDCKn+UgMrVUKZCXJiY=;
  b=K6mCCVX0Lu9qNP9SUzPl92iaDHZKsthce1L9m30oZzHbGeRmiakmXEsE
   v8Unt1gfFkJVra4FYFRfH+TXll92F9re0X5K0rhPNEN6mwSzP2XT9/2wJ
   Wu7UXbbqSUg1ikTQsLffcWeQhrrYE4QQvLd6KAXWn1vP7IxRJnWRnkvpC
   21PX+/cwuGTcBt66GHuIKVuZwSTPOgs6wc2ZoiPLkuNqVEqsefYRnSpyY
   Ln5hLAdqX1J4TgsOLHBRJyBxgV+6Z3TqGk9xZjnS6eDaMItghlMWKjxcL
   IVQQQEe0oZLZJDVKiECsocC+MIESO7NsgT4WmnFAZivsSt04Y+PtAiDRb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125670"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125670"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825647"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:39 -0800
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
Subject: [PATCH v7 06/13] KVM: TDX: Pass desired page level in err code for page fault handler
Date: Mon, 22 Jan 2024 16:22:21 -0800
Message-Id: <d1bf6ba80d7dbe259316633bd8382c183438ec81.1705965958.git.isaku.yamahata@intel.com>
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

  TD geust will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
  4KB size.

2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.

  KVM needs to honor it because
  a) there is no way to tell guest KVM maps it as 2MB size. And
  b) guest accepts it in 4KB size since guest knows some other 4KB page
     in the same 2MB range will be used as shared page.

For case 2, it need to pass desired page level to MMU's
page_fault_handler. Use bit 29:31 of kvm PF error code for this purpose.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/common.h   |  6 +++++-
 arch/x86/kvm/vmx/tdx.c      | 22 ++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx_arch.h | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c      |  2 +-
 4 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 027aa4175d2c..787f59c44abc 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -67,7 +67,8 @@ static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 }
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
-					     unsigned long exit_qualification)
+					     unsigned long exit_qualification,
+					     int err_page_level)
 {
 	u64 error_code;
 
@@ -90,6 +91,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (kvm_is_private_gpa(vcpu->kvm, gpa))
 		error_code |= PFERR_GUEST_ENC_MASK;
 
+	if (err_page_level > PG_LEVEL_NONE)
+		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e2a0d521f806..747152af0882 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1858,7 +1858,20 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
+	union tdx_ext_exit_qualification ext_exit_qual;
 	unsigned long exit_qual;
+	int err_page_level = 0;
+
+	ext_exit_qual.full = tdexit_ext_exit_qual(vcpu);
+
+	if (ext_exit_qual.type >= NUM_EXT_EXIT_QUAL) {
+		pr_err("EPT violation at gpa 0x%lx, with invalid ext exit qualification type 0x%x\n",
+			tdexit_gpa(vcpu), ext_exit_qual.type);
+		kvm_vm_bugged(vcpu->kvm);
+		return 0;
+	} else if (ext_exit_qual.type == EXT_EXIT_QUAL_ACCEPT) {
+		err_page_level = tdx_sept_level_to_pg_level(ext_exit_qual.req_sept_level);
+	}
 
 	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
 		/*
@@ -1885,7 +1898,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
-	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual, err_page_level);
 }
 
 static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
@@ -2752,6 +2765,7 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx_init_mem_region region;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	u64 error_code;
 	int idx, ret = 0;
 	bool added = false;
 
@@ -2809,7 +2823,11 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
 				     (cmd->flags & KVM_TDX_MEASURE_MEMORY_REGION);
 
-		ret = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+		/* TODO: large page support. */
+		error_code = TDX_SEPT_PFERR;
+		error_code |= (PG_LEVEL_4K << PFERR_LEVEL_START_BIT) &
+			PFERR_LEVEL_MASK;
+		ret = kvm_mmu_map_tdp_page(vcpu, region.gpa, error_code,
 					   PG_LEVEL_4K);
 		put_page(page);
 		if (ret)
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 0207cce72b27..eb62b8804cb4 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -227,6 +227,25 @@ union tdx_sept_level_state {
 	u64 raw;
 };
 
+union tdx_ext_exit_qualification {
+	struct {
+		u64 type		:  4;
+		u64 reserved0		: 28;
+		u64 req_sept_level	:  3;
+		u64 err_sept_level	:  3;
+		u64 err_sept_state	:  8;
+		u64 err_sept_is_leaf	:  1;
+		u64 reserved1		: 17;
+	};
+	u64 full;
+};
+
+enum tdx_ext_exit_qualification_type {
+	EXT_EXIT_QUAL_NONE = 0,
+	EXT_EXIT_QUAL_ACCEPT = 1,
+	NUM_EXT_EXIT_QUAL,
+};
+
 /*
  * Global scope metadata field ID.
  * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 79f031b2b727..695e4ad022d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5752,7 +5752,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, PG_LEVEL_NONE);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1


