Return-Path: <kvm+bounces-10418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A167A86C128
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2661F23CBD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E824D4EB38;
	Thu, 29 Feb 2024 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQ/Pey1i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756D4779C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189061; cv=none; b=L9Loy34zJPCL5vntmsmHwV14hFS66uC9G4Wv37pDm1itmVR6f2t3C8DL3w15Xg7JhKfDBng4tKsNPOTqS28IBxZsKixuNmDISfcCnFkTi50N8JSPlaeNNvEdQ88RxtM2xWG27n/mEGrSg5G2tBUNTsDwQI88jobahwMAU4cvHwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189061; c=relaxed/simple;
	bh=LHQPUt9kNMbszwvd34sfpT4+wYNaQjOCt0b7dVNRHqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pFlN/PrsUwKUFCH3+M8zaZkRrhNaU2PMeLZiYv7hmGem/27EmD8pF2z90LdAyOtOryNuXq7nv3Ao5uwYHDm57zg28fmUNtBHoeNRReeUdcMlQEQ4N84I85ASNsFb3KerzHMT0IdbYStbTH9x9JTFQn86VdDum+PewotS81UNvkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQ/Pey1i; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709189059; x=1740725059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LHQPUt9kNMbszwvd34sfpT4+wYNaQjOCt0b7dVNRHqs=;
  b=lQ/Pey1ivKPSyzWt+NUhlQNmM5ni87JqkzEb1qlQWFz3/5FGEgVdf5M2
   CSYNV0aTIWwoIoz8kAhsAA+Q3R9UwmBtcyALy7qamJnRSMUWhCv0+hm0d
   KDP02h6Rlu8m5r9Sqo6FaVbjhHhKpocxIP4z36SzmqPFLzUyWZBaU3NE4
   EQ7LF8vHHvWa7nIw5Nr/7M1ZR3UGc4QgRL2ezsX1Z1hhAKghcSY4lYwk2
   NcxpdkLZbCOKBKQU4LVBq97Lz0+yAprWukOfzWw78KOHIB8CW70ctdaIg
   A/vuubP1rzhi+ZldUFmEDh21wyMe6QbqdPf7UXxjD7Gv8hraSiqh1BZR9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803308"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803308"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:44:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076531"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:44:13 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 62/65] i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
Date: Thu, 29 Feb 2024 01:37:23 -0500
Message-Id: <20240229063726.610065-63-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
by VMM, while the features enumerated/controlled by other MSRs except
MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.

Only configure MSR_IA32_UCODE_REV for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 44 ++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 83276e23b19f..d23f94b77257 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3270,32 +3270,34 @@ static void kvm_init_msrs(X86CPU *cpu)
     CPUX86State *env = &cpu->env;
 
     kvm_msr_buf_reset(cpu);
-    if (has_msr_arch_capabs) {
-        kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
-                          env->features[FEAT_ARCH_CAPABILITIES]);
-    }
-
-    if (has_msr_core_capabs) {
-        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
-                          env->features[FEAT_CORE_CAPABILITY]);
-    }
-
-    if (has_msr_perf_capabs && cpu->enable_pmu) {
-        kvm_msr_entry_add_perf(cpu, env->features);
+
+    if (!is_tdx_vm()) {
+        if (has_msr_arch_capabs) {
+            kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
+                                env->features[FEAT_ARCH_CAPABILITIES]);
+        }
+
+        if (has_msr_core_capabs) {
+            kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
+                                env->features[FEAT_CORE_CAPABILITY]);
+        }
+
+        if (has_msr_perf_capabs && cpu->enable_pmu) {
+            kvm_msr_entry_add_perf(cpu, env->features);
+        }
+
+        /*
+         * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
+         * all kernels with MSR features should have them.
+         */
+        if (kvm_feature_msrs && cpu_has_vmx(env)) {
+            kvm_msr_entry_add_vmx(cpu, env->features);
+        }
     }
 
     if (has_msr_ucode_rev) {
         kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
     }
-
-    /*
-     * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
-     * all kernels with MSR features should have them.
-     */
-    if (kvm_feature_msrs && cpu_has_vmx(env)) {
-        kvm_msr_entry_add_vmx(cpu, env->features);
-    }
-
     assert(kvm_buf_set_msrs(cpu) == 0);
 }
 
-- 
2.34.1


