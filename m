Return-Path: <kvm+bounces-30667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFE59BC5A5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32E43282B7F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2494E1FE100;
	Tue,  5 Nov 2024 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PwP8qhxB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D217E1FA25C
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788726; cv=none; b=BBOCCk9DZ3z17QFHtakSctrnuugLo+4zW1wU67f5prtD8ynTSkWAdkVWlwZUKqe8gwzGclLxHCsHYZZheJ9zo/F8VVx3/VCFyUkc0BuMQGvkPyyC96CU/7urpBo+kkb14s1g0IecQq3uNw55BzXt5/s8n+GbalIqksEEwFP6TDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788726; c=relaxed/simple;
	bh=63P5g04tq2r6PcAIPsWb8iPHQuE0MH+gEuTLFzYddZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wle3t6NOivKzNiJ7WRnRH2AavMdIkEr9jqUOXR5vOgHeIrGMNGBf4PtkkGIRoYYoHRIvhYs5yWoTuODLpSRMo8uRe1DtW5675BxkTQ4UqhlLS8kVkcp8B2QD5CgEBiijjvr7QD0RwBvtlW/1PWqZhCOqR3nlyzNctUDcuPhcsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PwP8qhxB; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788725; x=1762324725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=63P5g04tq2r6PcAIPsWb8iPHQuE0MH+gEuTLFzYddZI=;
  b=PwP8qhxB7ZCiuq1qGruUdI3EPQ5VZ704WF+BWgbwhA+bDy3PdKDD6CGf
   K1hGtekkeEHgT6AK0cQOu/OxfUqjTBTbPj+crw6WI9RSrwfRoTNEOTNht
   xV7olNevQcSeTgARIiqCApgU0MiswUnBNCPE71d9FLF9xmkKOf1yI/Ane
   CLC0A41kTVX3zhIuXPkoBDqGmBsZ6O1/1zHFgKLu7eccWqlGARDpXpOMD
   +Iqm4ZEEpe2tQh0kavR+psufRIHr9We3wzD9Lxt7tJqB16TztyAgq/N7S
   5+4L51Sh6PwSzGBs/AreibbkN8qI5aSCDyKv/r/ziWBmubP5qNQGlL9rl
   Q==;
X-CSE-ConnectionGUID: 0I5egfcKSKSkDNNswzwblg==
X-CSE-MsgGUID: RaxrW4OZTRKPjvPqKllOpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689691"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689691"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:45 -0800
X-CSE-ConnectionGUID: MdCsSwMrQqKD4Co1gmDzvA==
X-CSE-MsgGUID: KOGn8PVPRDGFMXhDPQsGvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989240"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:40 -0800
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
Subject: [PATCH v6 33/60] i386/cpu: introduce x86_confidenetial_guest_cpu_realizefn()
Date: Tue,  5 Nov 2024 01:23:41 -0500
Message-Id: <20241105062408.3533704-34-xiaoyao.li@intel.com>
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

To execute confidential guest specific cpu realize operations.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
changes in v6:
 - new patch;
---
 target/i386/confidential-guest.h | 12 ++++++++++++
 target/i386/cpu.c                | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 38169ed68e06..4b7ea91023dc 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -40,6 +40,7 @@ struct X86ConfidentialGuestClass {
     /* <public> */
     int (*kvm_type)(X86ConfidentialGuest *cg);
     void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
+    void (*cpu_realizefn)(X86ConfidentialGuest *cg, CPUState *cpu, Error **errp);
     uint32_t (*mask_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
                                     int reg, uint32_t value);
 };
@@ -70,6 +71,17 @@ static inline void x86_confidential_guest_cpu_instance_init(X86ConfidentialGuest
     }
 }
 
+static inline void x86_confidenetial_guest_cpu_realizefn(X86ConfidentialGuest *cg,
+                                                         CPUState *cpu,
+                                                         Error **errp)
+{
+    X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
+
+    if (klass->cpu_realizefn) {
+        klass->cpu_realizefn(cg, cpu, errp);
+    }
+}
+
 /**
  * x86_confidential_guest_mask_cpuid_features:
  *
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c7d65bbeab9b..1ffbafef03e7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7848,6 +7848,18 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
+#ifndef CONFIG_USER_ONLY
+    MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (ms->cgs) {
+        x86_confidenetial_guest_cpu_realizefn(X86_CONFIDENTIAL_GUEST(ms->cgs),
+                                              cs, &local_err);
+        if (local_err != NULL) {
+            goto out;
+        }
+    }
+#endif
+
     if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
         g_autofree char *name = x86_cpu_class_get_model_name(xcc);
         error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
@@ -7972,7 +7984,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
 #ifndef CONFIG_USER_ONLY
-    MachineState *ms = MACHINE(qdev_get_machine());
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
     if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
-- 
2.34.1


