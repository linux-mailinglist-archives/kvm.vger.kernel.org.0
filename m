Return-Path: <kvm+bounces-4996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90A581B1D8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCF42B21ED1
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D8555796;
	Thu, 21 Dec 2023 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/RqZ4sd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918F4E1D0;
	Thu, 21 Dec 2023 09:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149430; x=1734685430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=80A9OCb5g70NX77dvI1N49bHlokeM5y3fENbkVjwY90=;
  b=Q/RqZ4sdjzCVUPB5rZDSHECI4rY5M4j9NxHdqiv5MZU+ebfdkUL67O3P
   mUfDT/0kzBxggI5pEe93vR1uOY1T3JSDX9V44q1IoqwpWjRHKe4IC5iCU
   k4y2rtGQxagK25RkQhTswXpWKOQX2Ue7t19KOrMhZoRRonT7dDP+uvjVY
   cTTKY+TcRXKvsnJuutZCC8aKPa44l7IohbpOyzVcsEF+lRP4jYRDkxGnA
   6DCZzVAvQ8dABhCbLsJHkZtq92u6BA6AAWGRGS6AHjYB061dhlnkvzVNO
   XMWvKZr1KQzZKqXLw2KvzPFvAzbkGk0wRhQkAFTfB57S+6RfVgPUOj5RC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729648"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729648"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028584"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028584"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 08/26] KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
Date: Thu, 21 Dec 2023 09:02:21 -0500
Message-Id: <20231221140239.4349-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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


