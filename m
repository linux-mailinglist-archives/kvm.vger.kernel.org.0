Return-Path: <kvm+bounces-1795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B087EBDFE
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1EB7281486
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62478C8CB;
	Wed, 15 Nov 2023 07:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4aQS2bb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8399C129
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:24:05 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2549E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700033042; x=1731569042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+vky1eDe3AfsFEtbsDT8Wl55ywvftGPx+QKxAe2B98=;
  b=S4aQS2bbWVPdgZtsgpMLYcA48TMiYZ9jk3/7IZa+3y/0UuiKtiiWmBSb
   qBKsgoLp1NSZsPdnlBeNMc9SrP4At6TYk3yVn7zKCePsiaTXqfMmnWsBh
   ykeesz8J9SfKAP+jlNery0KBG158HFmaKhEwOV0XbZDAB6QdAWA7oJt6Z
   ZddrtGIFw8yAsPWYvjLBSP4EJ2G8ucukAtPx+UumsHzpaFs1PRDrv9dzC
   oZwUJA0Myebk9SYjKuv3J7q3SfhqkZ+9iGSc+y6ugE9MUxY05RhNOmeiy
   y/WsPqfppVrui2/60GhtJNxw/TGErMEX5CbDRnXWZ/jW4dt75P7es+v1z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623706"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623706"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:24:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800474"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800474"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:23:56 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 67/70] i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
Date: Wed, 15 Nov 2023 02:15:16 -0500
Message-Id: <20231115071519.2864957-68-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
index 773e0b042ae9..12d909d08862 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3279,32 +3279,34 @@ static void kvm_init_msrs(X86CPU *cpu)
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


