Return-Path: <kvm+bounces-6756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F26F1839F62
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 931E31F2B1E7
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E235539E;
	Wed, 24 Jan 2024 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJaSdt1b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B81FBEE;
	Wed, 24 Jan 2024 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064159; cv=none; b=mHHG2GE8bcsNXCdlVDiLnLI9rX9ZIJaDxPCP6vBUqP+3nPl+V1Mz3E8YVe6/98mT5So2M5osMBl2l403NZBFLgZ3I5cbHDjZ4Oz0ArX0fwzFB64vdzi/tu1bC9oK/++RWiyis3YglbF1qkaL/CVnN/5e6Arx2AiduSZZKEMWVRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064159; c=relaxed/simple;
	bh=0U7ALq4ceBj9fsXzc9ZLpGtprVUwlTHjsrBo2twXG2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NUpt3dJKmLovI8//TpRfd7R97dfNdsu0R5h83QG3q77apjEspkQxzmEpxao0DiJi155gKmeJbCItI7+vkbZvC8jTg07HXRbZtiMODanZrA7kjGYTNUgRaBeTQmdkLgk6EoDJbJGElKN4nhL7toebCLpQ2DqDDOBaIfIHRQiXbGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJaSdt1b; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064157; x=1737600157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0U7ALq4ceBj9fsXzc9ZLpGtprVUwlTHjsrBo2twXG2w=;
  b=QJaSdt1blPhz20acTALN3rW026MPMhpAVauAZtnANwgbXSkOG5inCb9Z
   zPZuyXkv31IOCFOloShKid7WXMq3gKgerHr4nHoIzMv0c2ozAsvuPRs9E
   r1yAA1tvbdkbG6hNzRKDXRfjzEcBJq/+DIZ2I0lkJNTMp3AzCvb9HaZ3N
   vIqRvscEUoca+bibrxL5bX3UZUs6qKkmSGflIuGAckdBz3dw96ocSNuyV
   g7blte0RZKClCN6WU7+0rMpzwS9sqzw/dcWZUrPC7SBMQ1qQkQZ6a+zJn
   80cDHvqfVST9rQbXhwylhI8Vta8RK+hZHUFplMf48YvbXNgIl4CxFL+Sq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586464"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586464"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825849"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:34 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 08/27] KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
Date: Tue, 23 Jan 2024 18:41:41 -0800
Message-Id: <20240124024200.102792-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Rework and rename cpuid_get_supported_xcr0() to explicitly operate on
vCPU state, i.e. on a vCPU's CPUID state, now that the only usage of
the helper is to retrieve a vCPU's already-set CPUID.

Prior to commit 275a87244ec8 ("KVM: x86: Don't adjust guest's CPUID.0x12.1
(allowed SGX enclave XFRM)"), KVM incorrectly fudged guest CPUID at runtime,
which in turn necessitated massaging the incoming CPUID state for
KVM_SET_CPUID{2} so as not to run afoul of kvm_cpuid_check_equal().
I.e. KVM also invoked cpuid_get_supported_xcr0() with the incoming CPUID
state, and thus without an explicit vCPU object.

Opportunistically move the helper below kvm_update_cpuid_runtime() to make
it harder to repeat the mistake of querying supported XCR0 for runtime
updates.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 294e5bd5f8a0..624954203b40 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -247,21 +247,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-/*
- * Calculate guest's supported XCR0 taking into account guest CPUID data and
- * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
- */
-static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
-}
-
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
@@ -312,6 +297,21 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
+/*
+ * Calculate guest's supported XCR0 taking into account guest CPUID data and
+ * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
+ */
+static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
+	if (!best)
+		return 0;
+
+	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
+}
+
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
 #ifdef CONFIG_KVM_HYPERV
@@ -361,8 +361,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
 
 	kvm_update_pv_runtime(vcpu);
 
-- 
2.39.3


