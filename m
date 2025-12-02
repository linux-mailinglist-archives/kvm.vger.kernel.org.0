Return-Path: <kvm+bounces-65147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F43C9C1C3
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C0214E446F
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFB527BF7D;
	Tue,  2 Dec 2025 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bbj4R0Lq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D53E25FA10
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691658; cv=none; b=XnxAIM3qqC3nM0CJgpaeizdRJCFhN1pkmAtt3IvxVXZhjw22fy9ErnfKRhQEw2lT2oxUc2aeDtxs9dWowN887sNFewSuGUkRLxjc9xu5C02/+XPxcLu4QYNleOsav/xPHJV2OreX9HGO3BvHkho4/xtfmQoKO38FfJ7QDgdFAyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691658; c=relaxed/simple;
	bh=xbQmgoe2IOU9HSvyb9lb+wg4Nep+wx7DJvs7Fx9TRRo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gp6ITyGuvd2g6utPBzOOhbJD/XdvrePLq7IPGBI66vknvY7B56zYnQOlsww8hJeHMAVpCFCRvjdq0SJUTfAiGTYjq5m2yfWIyyqGKDEtpDxaTLE5b48cRJsv7QtKpGqXO2IQPdw3wpslscIQYkM1OceCyNDP930KnzWgi+5UAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bbj4R0Lq; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691656; x=1796227656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xbQmgoe2IOU9HSvyb9lb+wg4Nep+wx7DJvs7Fx9TRRo=;
  b=bbj4R0LqZKFKF948IKtcKnnYQtLsLtuONwh6v+LkroV+c+WoqFZWgETP
   20ywK3wPEV+8BeXkSLL3Kh41oa1VanbzvLICn3LeOGuYBhLQgJxjLPf8N
   R+NAYcJNr4rlANaF4oLYWz+ljM6FIuplTKu1MFmeYjUvfD+HsIjpmPvZ4
   uoYpYTv55eiDGJa3sQqXlIlGhtx0V7Fx+Sa75JZ4ydgzc4+FFEHACqOiS
   ka7x9ajg0oIJRCPjEkjTjwEHkg5gj5OAn37Fxy7GttfP9kyi1SObbrdcU
   MBsrujVcMwPNiL05WvTlFvmhQ7OWysLic15NMZBKoRODuUk0wLZ9iU4Po
   g==;
X-CSE-ConnectionGUID: qMvDQFT6RZGM5DfEiom3xQ==
X-CSE-MsgGUID: Hl09kR7hREqFOZVVH5aK0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142971"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142971"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:07:36 -0800
X-CSE-ConnectionGUID: K6boL9nXQgOc2bG5wpxHdg==
X-CSE-MsgGUID: bP0+wkBRQX+2cM0IZVd8Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537874"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:07:26 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 23/28] target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
Date: Wed,  3 Dec 2025 00:28:30 +0800
Message-Id: <20251202162835.3227894-24-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

The CPUX86State::full_cpuid_auto_level boolean was only
disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
which got removed. Being now always %true, we can remove
it and simplify x86_cpu_expand_features().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Note, although libvirt still uses this property in its test cases, it
was confirmed this property is not exposed to user directly [*].

[*]: https://lore.kernel.org/qemu-devel/aDmphSY1MSxu7L9R@orkuz.int.mamuti.net/
---
 target/i386/cpu.c | 111 ++++++++++++++++++++++------------------------
 target/i386/cpu.h |   3 --
 2 files changed, 54 insertions(+), 60 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 641777578637..72c69ba81c1b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9019,69 +9019,67 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
 
     /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
     x86_cpu_adjust_feat_level(cpu, FEAT_7_0_EBX);
-    if (cpu->full_cpuid_auto_level) {
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
-        x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
-
-        /* Intel Processor Trace requires CPUID[0x14] */
-        if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
-            if (cpu->intel_pt_auto_level) {
-                x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
-            } else if (cpu->env.cpuid_min_level < 0x14) {
-                mark_unavailable_features(cpu, FEAT_7_0_EBX,
-                    CPUID_7_0_EBX_INTEL_PT,
-                    "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
-            }
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
+    x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
+
+    /* Intel Processor Trace requires CPUID[0x14] */
+    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
+        if (cpu->intel_pt_auto_level) {
+            x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
+        } else if (cpu->env.cpuid_min_level < 0x14) {
+            mark_unavailable_features(cpu, FEAT_7_0_EBX,
+                CPUID_7_0_EBX_INTEL_PT,
+                "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
         }
+    }
 
-        /*
-         * Intel CPU topology with multi-dies support requires CPUID[0x1F].
-         * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
-         * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
-         * cpu->vendor_cpuid_only has been unset for compatibility with older
-         * machine types.
-         */
-        if (x86_has_cpuid_0x1f(cpu) &&
-            (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
-        }
+    /*
+     * Intel CPU topology with multi-dies support requires CPUID[0x1F].
+     * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
+     * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
+     * cpu->vendor_cpuid_only has been unset for compatibility with older
+     * machine types.
+     */
+    if (x86_has_cpuid_0x1f(cpu) &&
+        (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
+    }
 
-        /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
-        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
-        }
+    /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
+    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
+    }
 
-        /* SVM requires CPUID[0x8000000A] */
-        if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
-        }
+    /* SVM requires CPUID[0x8000000A] */
+    if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
+    }
 
-        /* SEV requires CPUID[0x8000001F] */
-        if (sev_enabled()) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
-        }
+    /* SEV requires CPUID[0x8000001F] */
+    if (sev_enabled()) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
+    }
 
-        if (env->features[FEAT_8000_0021_EAX]) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
-        }
+    if (env->features[FEAT_8000_0021_EAX]) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
+    }
 
-        /* SGX requires CPUID[0x12] for EPC enumeration */
-        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
-        }
+    /* SGX requires CPUID[0x12] for EPC enumeration */
+    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
     }
 
     /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
@@ -10010,7 +10008,6 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_UINT32("min-xlevel2", X86CPU, env.cpuid_min_xlevel2, 0),
     DEFINE_PROP_UINT8("avx10-version", X86CPU, env.avx10_version, 0),
     DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
-    DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cee1f692a1c3..8c3eb86fa0c7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2292,9 +2292,6 @@ struct ArchCPU {
     /* Force to enable cpuid 0x1f */
     bool force_cpuid_0x1f;
 
-    /* Enable auto level-increase for all CPUID leaves */
-    bool full_cpuid_auto_level;
-
     /*
      * Compatibility bits for old machine types (PC machine v6.0 and older).
      * Only advertise CPUID leaves defined by the vendor.
-- 
2.34.1


