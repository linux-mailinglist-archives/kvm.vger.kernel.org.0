Return-Path: <kvm+bounces-72915-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2LJeG8vDqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72915-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A891B216A06
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD7C13217DBC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DABE043D4F2;
	Thu,  5 Mar 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X6ynK1/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631742F54F;
	Thu,  5 Mar 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732695; cv=none; b=O3b1adFkBX6qrQwOkXtFu1o6Q9e6tivFkUCjfwFSSXGQvvnjfttUfJPjRIbaw/yZDstvV6HS25Zc5gCUi5VofhJ18pvIfcPx7eR6JW8FkbUVBcAmA9Vt8tgVfugJKfufY7MYNe+mUTle8w77i2HKkfpVVR1Ugb9jDVtGg5A+eoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732695; c=relaxed/simple;
	bh=Xp9vVVC9VmSIjmyuA7qa6qei/ZbOzg/Sj/hvegc3Ao8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CokNIpctnGpIifoPslcUefiJk5kH6N7ejk+v38wS/IpuNOfxFIsDb5aJTfO0SwjOzYWKxfVo7JdOmqVUaZvdY8DXF4waJV8lcKQGITcWX0+MSwRQFoUUqCC4hS7hlvdG7+R9s0GqQnjlN/XlnowNG8E2OuFJGIj+9Xj3au8F7cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X6ynK1/E; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732692; x=1804268692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xp9vVVC9VmSIjmyuA7qa6qei/ZbOzg/Sj/hvegc3Ao8=;
  b=X6ynK1/ENyq7Ol2PDeohMzJEcOzna/gNtxZ3mmZuyLRwt1sAHHJHIuAV
   tiIlD5iWQBCffv4uhL/JrQlTEqPUmyePdaLkFq1/xfzmztCTXUUKleuA6
   sIBg9w7TRsWrXMKJHBQKzHZGfy16w08h9yhntsaqsDdXmA5Ldljvy4+XJ
   rpzpsuk2BfzhwUBwcc+y9CQu2FgxYRQE2vPpDbSDVf8POWdxfF5Ul9oMb
   u87e4NBqsi742RSMS5RWzHXlDn5J9UwzS61aRN+c+hrttXB1PAxp0ctWd
   HyiNdrldDrsS/2VTk2XPiDzSrkYwfZgPNDC20QTKaOL7m+tSSm8HCDdnt
   g==;
X-CSE-ConnectionGUID: tj1mA6V6Qkymp91SQimaUw==
X-CSE-MsgGUID: vZToPptaRgCJEkJRUFaQbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301956"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301956"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:50 -0800
X-CSE-ConnectionGUID: 5cvMxudgT1aSgr3LDBmKnw==
X-CSE-MsgGUID: REg7F8XTT2yTbKlTU/pxpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896527"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:48 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/36] KVM: selftests: Add test for nVMX MSR_IA32_VMX_PROCBASED_CTLS3
Date: Thu,  5 Mar 2026 09:44:07 -0800
Message-ID: <ed4d1fdf71f92aa2c83d69da930e67229e278726.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A891B216A06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72915-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add test case for nVMX MSR_IA32_VMX_PROCBASED_CTLS3 emulation.  Test if the
access to MSR_IA32_VMX_PROCBASED_CTLS3 to succeed or fail, depending on
whether the vCPU supports it or not.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../testing/selftests/kvm/x86/vmx_msrs_test.c | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
index 90720b6205f4..3ec5b73b4f2f 100644
--- a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
@@ -48,6 +48,11 @@ static void vmx_fixed0and1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index)
 
 static void vmx_save_restore_msrs_test(struct kvm_vcpu *vcpu)
 {
+	union vmx_ctrl_msr ctls;
+	const struct kvm_msr_list *feature_list;
+	bool ctl3_found = false;
+	int i;
+
 	vcpu_set_msr(vcpu, MSR_IA32_VMX_VMCS_ENUM, 0);
 	vcpu_set_msr(vcpu, MSR_IA32_VMX_VMCS_ENUM, -1ull);
 
@@ -65,6 +70,54 @@ static void vmx_save_restore_msrs_test(struct kvm_vcpu *vcpu)
 	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_EXIT_CTLS);
 	vmx_fixed0and1_msr_test(vcpu, MSR_IA32_VMX_TRUE_ENTRY_CTLS);
 	vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_VMFUNC, -1ull);
+
+	ctls.val = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS);
+	TEST_ASSERT(!(ctls.set & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS),
+		    "CPU_BASED_ACTIVATE_TERTIARY_CONTROLS should be cleared.");
+
+	feature_list = kvm_get_feature_msr_index_list();
+	for (i = 0; i < feature_list->nmsrs; i++) {
+		if (feature_list->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS3) {
+			ctl3_found = true;
+			break;
+		}
+	}
+
+	if (ctls.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
+		uint64_t kvm_ctls3, ctls3;
+
+		TEST_ASSERT(ctl3_found,
+			    "MSR_IA32_VMX_PROCBASED_CTLS3 was not in feature msr index list.");
+
+		kvm_ctls3 = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3);
+		ctls3 = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3);
+		TEST_ASSERT(kvm_ctls3 == ctls3,
+			    "msr values for kvm and vcpu must match.");
+
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, 0);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+		vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+
+		/*
+		 * The kvm host should be able to get/set
+		 * MSR_IA32_VMX_PROCBASED_CTLS3 irrespective to the bit
+		 * CPU_BASED_ACTIVATE_TERTIARY_CONTROLS of
+		 * MSR_IA32_VMX_TRUE_PROCBASED_CTLS.
+		 */
+		ctls.val = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
+			     ctls.set & ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, 0);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+		vmx_fixed1_msr_test(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, ctls.val);
+	} else {
+		TEST_ASSERT(!ctl3_found,
+			    "MSR_IA32_VMX_PROCBASED_CTLS3 was in feature msr index list.");
+
+		TEST_ASSERT(!_vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, 0),
+			    "setting MSR_IA32_VMX_PROCBASED_CTLS3 didn't fail.");
+	}
 }
 
 static void __ia32_feature_control_msr_test(struct kvm_vcpu *vcpu,
-- 
2.45.2


