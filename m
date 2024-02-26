Return-Path: <kvm+bounces-9761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC18D866DD5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ECD0B265D4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8305E2C868;
	Mon, 26 Feb 2024 08:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Je6Xy/OQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B7E1CD37;
	Mon, 26 Feb 2024 08:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936190; cv=none; b=jxB0qX+tkd7nreW2kXK6MQ9cevEtNisp725WjvCvXiaq0LqhzedSheXk0m77b97nljdlZQft+xCsK0hwXnHRfYLpYx4ajtwHGDeHYvbCmdeMOuON/p0Ad2Rgdq0quoz2rkb8cExADhLFjusN6Fz9CvysuoILbiENHKZztEpy7mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936190; c=relaxed/simple;
	bh=cp1eBjoAT8NOI0oEDQWVIksfHFeL9PGp78iWB16k6Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLpri2oL0s4KF1ZU+qJZqS8LMPoocffkkgMdLwzEXftEF5CIUKRfXIPeKP9WfNznw+JlaO4MB6yAw+mI7SK0E+X3eh7rLSSMq3gpb94sW513l99Zf6umqRBi3gyivcn7et1cLEo8fmBqBTAsIk17GJ/tP4mYiQ1MJTuTH0jmY/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Je6Xy/OQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936189; x=1740472189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cp1eBjoAT8NOI0oEDQWVIksfHFeL9PGp78iWB16k6Lw=;
  b=Je6Xy/OQ+wax9XBNaqHN4iFYUlMJB8Fwyc5ieqP0gTJ9WjzO34iMHX/M
   WfB6S9IOXOKfvJM8z6Nh8pJVfrJePZquL8aTJ3Em72h60E+rbSooCZBuY
   h2JyY+PLh90Q733jNATUIj9kEk0mzQKWac+D0TcYqLTgkQSW5A6wctzEs
   ymBmBitL6qwxQdCz3DJWNxQGZhcxDZyayFepeRUgCLeCJ00FDzbR0a38e
   SoMTJeqf3732nnmp9Jx9BFtNiEIYovOEVZk0PB5P981ML5EEcjG2tVRGw
   zsTJkikycQreZh1vRqnAbBWkDNcvArfj761PqZkm0GWyggXIU3MLalwfb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623307"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623307"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519407"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
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
Subject: [PATCH v8 07/14] KVM: TDX: Pass desired page level in err code for page fault handler
Date: Mon, 26 Feb 2024 00:29:21 -0800
Message-Id: <3d2a6bfb033ee1b51f7b875360bd295376c32b54.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h   |  6 +++++-
 arch/x86/kvm/vmx/tdx.c      | 18 ++++++++++++++++--
 arch/x86/kvm/vmx/tdx_arch.h | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c      |  2 +-
 4 files changed, 41 insertions(+), 4 deletions(-)

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
index d73a32588ad8..6941e9483e7e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1812,7 +1812,20 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
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
@@ -1839,7 +1852,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
-	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual, err_page_level);
 }
 
 static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
@@ -3027,7 +3040,8 @@ int tdx_pre_memory_mapping(struct kvm_vcpu *vcpu,
 
 	/* TDX supports only 4K to pre-populate. */
 	*max_level = PG_LEVEL_4K;
-	*error_code = TDX_SEPT_PFERR;
+	*error_code = TDX_SEPT_PFERR |
+		((PG_LEVEL_4K << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK);
 
 	r = get_user_pages_fast(mapping->source, 1, 0, &page);
 	if (r < 0)
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 87ef22e9cd49..19f2deafde5b 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -221,6 +221,25 @@ union tdx_sept_level_state {
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
index f8a00a766c40..a2004a0feb1c 100644
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


