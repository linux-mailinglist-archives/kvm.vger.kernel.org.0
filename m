Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4F478FDD
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbhLQPbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:31:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhLQPaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755005; x=1671291005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cq5pl+LFSmydyprw9+uNd5O4QogykkkHwYzeeS4aZ1E=;
  b=jNVSj84q8mX12SKcv+7MXFPV5r5owUMOwAnqlq81/LwLAAM1jD8Rk5ev
   +4BimgvJBop9hKAVHpaL4koAInJ0Ylr8ERiOJrsWhh+47RbnmNj2inm+w
   6aAKX4G1A0hMewxe9lOL8BwCvmAS/hGbA+MSfZRTImrauBurm7kKSLD/0
   6N3+zjZmVR/XKAiy135cU6ZBX3E/UEASDErryPBIuw+X0OSsEIus/ViLW
   5tuXPlWY/KQ+3KvfblMyOT+0SyKYHPfDmvJFt/ZHCxF6GdcaGVL7rqn9M
   cn1NmqK19NZFrBkdHU4XJbaytgWg/JmTKybAbbzb8tetr41NPiH0ewgJF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723437"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723437"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588404"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:04 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 05/23] kvm: x86: Check permitted dynamic xfeatures at KVM_SET_CPUID2
Date:   Fri, 17 Dec 2021 07:29:45 -0800
Message-Id: <20211217153003.1719189-6-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest xstate permissions should be set by userspace VMM before vcpu
creation. Extend KVM_SET_CPUID2 to verify that every feature reported
in CPUID[0xD] has proper permission set.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4855344091b8..a068373a7fbd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -81,7 +81,9 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
+			   struct kvm_cpuid_entry2 *entries,
+			   int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
@@ -97,6 +99,16 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
+	/* Check guest permissions for dynamically-enabled xfeatures */
+	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	if (best) {
+		u64 xfeatures;
+
+		xfeatures = best->eax | ((u64)best->edx << 32);
+		if (xfeatures & ~vcpu->arch.guest_fpu.perm)
+			return -ENXIO;
+	}
+
 	return 0;
 }
 
@@ -277,21 +289,21 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
-    int r;
+	int r;
 
-    r = kvm_check_cpuid(e2, nent);
-    if (r)
-        return r;
+	r = kvm_check_cpuid(vcpu, e2, nent);
+	if (r)
+		return r;
 
-    kvfree(vcpu->arch.cpuid_entries);
-    vcpu->arch.cpuid_entries = e2;
-    vcpu->arch.cpuid_nent = nent;
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
 
-    kvm_update_kvm_cpuid_base(vcpu);
-    kvm_update_cpuid_runtime(vcpu);
-    kvm_vcpu_after_set_cpuid(vcpu);
+	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 
-    return 0;
+	return 0;
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.27.0

