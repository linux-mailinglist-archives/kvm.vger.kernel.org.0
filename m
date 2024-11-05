Return-Path: <kvm+bounces-30687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 301C59BC5BB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7868281A9B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC641FDFA0;
	Tue,  5 Nov 2024 06:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OweGKFtz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38119047D
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788810; cv=none; b=kfDNjSIzWZzp+obvs5+9tlhHM9M7kuWga6BoNmJAzi9M35fgCDYawOY1smbd5etHRXhWTRgqu6JIsjWRzLLEF3uDXOMx++MxPxUkP84rq+VlWsZE2Zfz05QO725KMqIT5xXt4b8LrXzD+G4y8wzFR5ipWohVEkuaxELnnf40B+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788810; c=relaxed/simple;
	bh=Cd6UQJeNLnYBe3u2FXzM6iswu2YcXGcY/0+XpTAWb5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l+uVmCczFwj9VOeWrxiROX2PSKoVW+o5n09OfZ7++0SKEW51S7uN+K7Rqn6ybllDr//zb8bOUi6J35QiDaPGO0iCLFehgdDpycwYa/Lohs80pFR8Y2teM6AZCG7JQVo5R6DiRNtDpC9NjjZO61TqYb9uq705uQMbW0m8YtUF5AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OweGKFtz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788809; x=1762324809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cd6UQJeNLnYBe3u2FXzM6iswu2YcXGcY/0+XpTAWb5M=;
  b=OweGKFtz9olkZSs9FXw8mN9a59SOgvzlwOh4WEbT/CbbzZPrgz2KDti8
   13H2rroWiZ/sbEqZsecYKGwJ7upXx9/lWFzZ7igxihg5OyUzbbkhbOE16
   +XRYsqFCUgqmEEFMPhB3BzAbEVNXzoio0SK8tJKtnfGGLRYi1bJEZo/Ez
   Qv6abnY0t5yuniE/fW96Rno5HKDacd0EJXvSQxixykxFR5GIwpOydZBRg
   WIRV3g+neXZBt/c9CRWLdArtMNhlK3kSXI10nwFC55jBoLMbLut0Ulp2V
   A/YVIOWoWeNmulmrZ0M1/OXsUdoztPm3FPBIRNbcYv6eETH1Ie9yoFRYG
   Q==;
X-CSE-ConnectionGUID: ywJ03oHARlSUsK5SqaDRQg==
X-CSE-MsgGUID: 1+G/l8s7Sy6W0Q/9IgjU5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689898"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689898"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:09 -0800
X-CSE-ConnectionGUID: rHLLn7tpR9W0Ru67Q1UL8w==
X-CSE-MsgGUID: ttu57Bs2RkOUlOsMPVmdKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989941"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:05 -0800
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
Subject: [PATCH v6 53/60] i386/cpu: introduce mark_forced_on_features()
Date: Tue,  5 Nov 2024 01:24:01 -0500
Message-Id: <20241105062408.3533704-54-xiaoyao.li@intel.com>
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

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 29 +++++++++++++++++++++++++++++
 target/i386/cpu.h |  5 +++++
 2 files changed, 34 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e728fb6b9f10..472ab206d8fe 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5507,6 +5507,35 @@ void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
     }
 }
 
+void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                             const char *verbose_prefix)
+{
+    CPUX86State *env = &cpu->env;
+    FeatureWordInfo *f = &feature_word_info[w];
+    int i;
+
+    if (!cpu->force_features) {
+        env->features[w] |= mask;
+    }
+
+    cpu->forced_on_features[w] |= mask;
+
+    if (!verbose_prefix) {
+        return;
+    }
+
+    for (i = 0; i < 64; ++i) {
+        if ((1ULL << i) & mask) {
+            g_autofree char *feat_word_str = feature_word_description(f, i);
+            warn_report("%s: %s%s%s [bit %d]",
+                        verbose_prefix,
+                        feat_word_str,
+                        f->feat_names[i] ? "." : "",
+                        f->feat_names[i] ? f->feat_names[i] : "", i);
+        }
+    }
+}
+
 static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
                                          const char *name, void *opaque,
                                          Error **errp)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e70e7f5ced4b..b5b1c3917427 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2135,6 +2135,9 @@ struct ArchCPU {
     /* Features that were filtered out because of missing host capabilities */
     FeatureWordArray filtered_features;
 
+    /* Features that are forced enabled by underlying hypervisor, e.g., TDX */
+    FeatureWordArray forced_on_features;
+
     /* Enable PMU CPUID bits. This can't be enabled by default yet because
      * it doesn't have ABI stability guarantees, as it passes all PMU CPUID
      * bits returned by GET_SUPPORTED_CPUID (that depend on host CPU and kernel
@@ -2446,6 +2449,8 @@ void host_cpuid(uint32_t function, uint32_t count,
 bool cpu_has_x2apic_feature(CPUX86State *env);
 void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
                                const char *verbose_prefix);
+void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                             const char *verbose_prefix);
 
 static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
 {
-- 
2.34.1


