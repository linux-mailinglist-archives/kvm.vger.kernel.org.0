Return-Path: <kvm+bounces-1757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8287EBDAB
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BFCE1C20821
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55418F79;
	Wed, 15 Nov 2023 07:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MiHm0Y3I"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635178F54
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:18:53 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EAD8E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032732; x=1731568732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZ7FlIk1HYztdqvj6ltoIcTo7JYAisDaEO7/8xv8SMQ=;
  b=MiHm0Y3IyRf4s7gUu6oMLNhbanNoCZjkxMpi0U+mv2eFLUIKBmHXi17A
   FvUdlQO9FT2dTaV0UH+jDIgXvt2gUlTxWM8FlTepuoun4Ztx8MG3xxYAr
   xL8Hl17APcnZEFEjKdY++FivnFBGFwzNjxN1Qv9ODwU6AHIsQqm5kpBwJ
   HZzCTJ4MaJI3KD8Zo+NoOvb5jUx0f9s/ZSQ6OYgvHLougcypT5xAHSayw
   71JpuZf8Dsc70AjyAdcjv8h/ktNUz6GKwutc1dwcP0ZCAS795yxLTObX2
   Pw9JCxjjWUXy6nylH8lFEk9s9yRK6YOSQ/NDGUc95mIxKWNeMihI751KZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622815"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622815"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:18:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714798746"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714798746"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:18:42 -0800
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
Subject: [PATCH v3 29/70] i386/tdx: Wire CPU features up with attributes of TD guest
Date: Wed, 15 Nov 2023 02:14:38 -0500
Message-Id: <20231115071519.2864957-30-xiaoyao.li@intel.com>
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

For QEMU VMs, PKS is configured via CPUID_7_0_ECX_PKS and PMU is
configured by x86cpu->enable_pmu. Reuse the existing configuration
interface for TDX VMs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 7d2b1da85951..bb10331e2a88 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -33,6 +33,8 @@
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 #define TDX_ATTRIBUTES_MAX_BITS      64
 
@@ -469,6 +471,15 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
     return 0;
 }
 
+static void setup_td_guest_attributes(X86CPU *x86cpu)
+{
+    CPUX86State *env = &x86cpu->env;
+
+    tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
+                             TDX_TD_ATTRIBUTES_PKS : 0;
+    tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+}
+
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -491,8 +502,9 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
         goto out_free;
     }
 
+    setup_td_guest_attributes(x86cpu);
+
     init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
-
     init_vm->attributes = tdx_guest->attributes;
 
     do {
-- 
2.34.1


