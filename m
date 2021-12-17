Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8129478FAF
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhLQPaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:10852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238222AbhLQPaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755006; x=1671291006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oudfdu6myNVjvoNfDhIoilt+uJCzFGHVxT+rvDPYbcw=;
  b=j1iwBUDiQL47pNPKRKxemujDYKX8ixqVtUDU/muQG1MQOwMANr/JzB25
   jRf4GSlYXJapWKWqGdeBL/4ECdZy/wM6jQIzwuYNMxudU+I1pQRQtgPgB
   LxdJawtyl7EklzexfnzpkDxZLBm6tFNQItu6g4KVYphlhUGxEKsWR1ln2
   b86/AIL9vk8lrgS7AFY4wFOWwnHFnqURaa9tZCUNnQ7h3EoSBbU69Xy6/
   Vz7Dxer6if224LFqLbe7y9VWvsBeqtEJag0Bk7fhApmupc/q7Nrzuig3v
   97yOlOfs7e4Rxl9C3S97JBY35N1N7W0obpIP/i1rliyXqdtLdyDLABbOg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723447"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723447"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588422"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:04 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 09/23] kvm: x86: Enable dynamic XSAVE features at KVM_SET_CPUID2
Date:   Fri, 17 Dec 2021 07:29:49 -0800
Message-Id: <20211217153003.1719189-10-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Statically enable all xfeatures allowed by guest perm in
KVM_SET_CPUID2, with fpstate buffer sized accordingly. This avoids
run-time expansion in the emulation and restore path of XCR0 and
XFD MSR [1].

Change kvm_vcpu_after_set_cpuid() to return error given fpstate
reallocation may fail.

[1] https://lore.kernel.org/all/20211214024948.048572883@linutronix.de/

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a068373a7fbd..eb5a5070accb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -204,10 +204,12 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
-static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
+	u64 xfeatures;
+	int r;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
@@ -222,9 +224,17 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
 	if (!best)
 		vcpu->arch.guest_supported_xcr0 = 0;
-	else
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+	else {
+		xfeatures = best->eax | ((u64)best->edx << 32);
+
+		vcpu->arch.guest_supported_xcr0 = xfeatures & supported_xcr0;
+
+		if (xfeatures != vcpu->arch.guest_fpu.xfeatures) {
+			r = fpu_update_guest_perm_features(&vcpu->arch.guest_fpu);
+			if (r)
+				return r;
+		}
+	}
 
 	/*
 	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
@@ -260,6 +270,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * adjustments to the reserved GPA bits.
 	 */
 	kvm_mmu_after_set_cpuid(vcpu);
+
+	return 0;
 }
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
@@ -301,9 +313,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	kvm_update_kvm_cpuid_base(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
-
-	return 0;
+	return kvm_vcpu_after_set_cpuid(vcpu);
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.27.0

