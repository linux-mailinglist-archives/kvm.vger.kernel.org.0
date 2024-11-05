Return-Path: <kvm+bounces-30665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E5E9BC5A3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3C7FB221B1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCE31FCF71;
	Tue,  5 Nov 2024 06:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DouHB9CI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1015C1FDFAF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788717; cv=none; b=jBQfjAcFF1Bs7xbOroTyW56spWvPmlPnx7KfKMrVJMppe+R2dYbLkKw/KkYhSqTuXL0BNujFExEhMAGlNt5uM8a81skaYuX0TIFx4QBL04cKi2UIYI1gZkQ7PLB6KMMbrc7K8MHbvKItOLKf38CZI+sof8VRFWKoo56EnTDGIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788717; c=relaxed/simple;
	bh=PjQf7e/17C3WWdlE56nodz232TMn447UvRVBPAlFKX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LAJgXCtdyQZM7uIyAs3ZDKwOLQlt7+QSSaLLrcr73uyTklBe51xb+XqfpWPmkObndGTufG9YQ7AKjClISs2S6CV+D4t824K9TdAlhKxlaYSW1DttnDKo6rEIoO0t7Cx6anwfOz96AS+PtOeRHJBvxVlf3agd/120TG/10zZmTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DouHB9CI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788716; x=1762324716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjQf7e/17C3WWdlE56nodz232TMn447UvRVBPAlFKX4=;
  b=DouHB9CIvGcUI3sBUK1qmXkLwCW0dBgG50wNUiFePEJLbSzedCCAWzRx
   EIqreKe8vvAzkxcCmJkohm428t1+1GISF7xN9ZAjVp8ad+K7EiLwM7b2p
   h/g1bcJIs1f2/TdAHiaEZlW3X9Gf5Ohn1lQKlAxqEJ5xI+/FoyJByHIJR
   CtgUxY+jWVE8gReGDVqqHSOMNF5IFJnKs6wjqnAguhvqlI6Vj1ccid5g1
   Y6ggGHxZhOHVtVgweyCzLrxi3UDYrFJumFx54T49cRhybi7vSKyXYAGaG
   4dgat3Fz2N34i6AKNRgqNDtlaOOfcFitPgYyx560+ViCaFJM/9nMSN5ZF
   A==;
X-CSE-ConnectionGUID: hWZrcXj7S4eexpEFUf6jXQ==
X-CSE-MsgGUID: Nt1RhzJ8SgKRi0K8PGERBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689669"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689669"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:36 -0800
X-CSE-ConnectionGUID: HBu2ooFlQVmCgAlxAclJfw==
X-CSE-MsgGUID: YoO5oAvySVuB4CPn/mfq7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989162"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:32 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 31/60] i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
Date: Tue,  5 Nov 2024 01:23:39 -0500
Message-Id: <20241105062408.3533704-32-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To allow execute confidential guest specific cpu init operations.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new patch;
---
 target/i386/confidential-guest.h | 11 +++++++++++
 target/i386/cpu.c                | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 7342d2843aa5..38169ed68e06 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -39,6 +39,7 @@ struct X86ConfidentialGuestClass {
 
     /* <public> */
     int (*kvm_type)(X86ConfidentialGuest *cg);
+    void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
     uint32_t (*mask_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
                                     int reg, uint32_t value);
 };
@@ -59,6 +60,16 @@ static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
     }
 }
 
+static inline void x86_confidential_guest_cpu_instance_init(X86ConfidentialGuest *cg,
+                                                            CPUState *cpu)
+{
+    X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
+
+    if (klass->cpu_instance_init) {
+        klass->cpu_instance_init(cg, cpu);
+    }
+}
+
 /**
  * x86_confidential_guest_mask_cpuid_features:
  *
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3baa95481fbc..c7d65bbeab9b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -35,6 +35,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/i386/topology.h"
 #ifndef CONFIG_USER_ONLY
+#include "confidential-guest.h"
 #include "sysemu/reset.h"
 #include "qapi/qapi-commands-machine-target.h"
 #include "exec/address-spaces.h"
@@ -8157,6 +8158,15 @@ static void x86_cpu_post_initfn(Object *obj)
     }
 
     accel_cpu_instance_init(CPU(obj));
+
+#ifndef CONFIG_USER_ONLY
+    MachineState *ms = MACHINE(object_dynamic_cast(qdev_get_machine(),
+                                                   TYPE_MACHINE));
+    if (ms && ms->cgs) {
+        x86_confidential_guest_cpu_instance_init(X86_CONFIDENTIAL_GUEST(ms->cgs),
+                                                 (CPU(obj)));
+    }
+#endif
 }
 
 static void x86_cpu_init_default_topo(X86CPU *cpu)
-- 
2.34.1


