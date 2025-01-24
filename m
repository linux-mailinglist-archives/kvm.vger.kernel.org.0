Return-Path: <kvm+bounces-36515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D696A1B711
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BB0D188C9BD
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663DD13AD11;
	Fri, 24 Jan 2025 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DyhvdlDg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B982D98
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725933; cv=none; b=YM3/0rUdfJ/kl41lCZbhQ7VcI2aESyjj0XnHy/r+V2HHNWzLkoma7jUeztQ9AqRfFwrxtD1TftQxjqo4ztza7k6PINT+EzCRgp5ysds4HGLzffOPPdjSwrJecdi6M2qh2iwVG+X/Crgff9j9O+F5EK7+QMklBazH7tNa+DTR8GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725933; c=relaxed/simple;
	bh=tR1BwcYVrk3irorerAFU49kWmu5J765/vc7Xg99OXgc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RTMJuUdp6GogWnSPCuqZLDsmtxQbYsyqAG1FkHsvGYH8qiEcIm9+g9/4lGkTGfgdH1uVtucktibhlKM77pbZa/gy7FjqaKCmJCX/Ido+C97X7jOEgF7fITDDFj+K0YU8L+QOxUrKfBsWdMz3R3zAp+LdSUjxpWoZJROI2OuG29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DyhvdlDg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725933; x=1769261933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tR1BwcYVrk3irorerAFU49kWmu5J765/vc7Xg99OXgc=;
  b=DyhvdlDgcUhDIscAujJs4IZG+qO9mnFqy7bCskinBrcbLZ9gqJMo16g4
   xNlbbSyN447efFXD2sy7q1g/5ZTEhgoWWOxbLc0lfIJNee/iYQTtwNi2j
   Wu70n6ogbEM/+Y2LKihq6RtWmwJtGjQFNsvHrljabMw+seUETybdLmE6M
   zh8nOCNMRUFr6pRzOOjip7d8IVJL9iB3jf5MMWt+0DC4tOQUZr2H4dmD/
   g/Qv9SwV3jkX9ShnaQ04tCg9q2ZBr6AB/ERVMGjPJairfwQZNUtosnz/8
   LhUZtWHulxWQSHGwn7gzCbDI4uxo+p83U4F79BbE3GSlZuBGC0BpOStUr
   A==;
X-CSE-ConnectionGUID: +vDW95TiSZCfL+xFVW20+A==
X-CSE-MsgGUID: A+Voz1pdQlm4X4M0bQ/uSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246464"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246464"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:52 -0800
X-CSE-ConnectionGUID: sIRdno3xRHSOkSR1B5e4tQ==
X-CSE-MsgGUID: RryqET44Te+aiODkHS5GLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804371"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:48 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 29/52] i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
Date: Fri, 24 Jan 2025 08:20:25 -0500
Message-Id: <20250124132048.3229049-30-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
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
index 164be7633a20..a86c42a47558 100644
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
index 252a07fe823e..a369cf90f5f6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -36,6 +36,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/i386/topology.h"
 #ifndef CONFIG_USER_ONLY
+#include "confidential-guest.h"
 #include "system/reset.h"
 #include "qapi/qapi-commands-machine-target.h"
 #include "exec/address-spaces.h"
@@ -8156,6 +8157,15 @@ static void x86_cpu_post_initfn(Object *obj)
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


