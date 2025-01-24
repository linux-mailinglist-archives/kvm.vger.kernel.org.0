Return-Path: <kvm+bounces-36532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E20A1B724
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6EA13A2093
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6177913A257;
	Fri, 24 Jan 2025 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YoY8EMmB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20576433DE
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725996; cv=none; b=loJBstxq7bO1ReylmqyL+eOMg7b588lUVfui0rJBmgE3RWUi3vaHfLEiRXKInd2TTl/nSBwMipObioX1GaiTCj+J22K1YnyFVQz6RlN3HmIvodVgxdKDTvWh0zkeW6mKTSqWm+rTuf/8+dSGuB1pIXLaPkiAzMiJ3XcpCycfnrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725996; c=relaxed/simple;
	bh=HJDg2gNrnTLyeXcVYWNvxi1qJesg421w8qhKg61bf0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k5O0FCPXRf+Hd6y/QcsoFw08gFe7g6/Gked261pXiM78xGErkGMcbL0lsICh0htbfuhk+Vs8StbEjnewmnfZLAV/RwNLVNfi+O+Yg/+wHGViNiReEJFlhMh/clOIrw/ZuwDjndK2gIS23qh7aWM1a5E/3YJSj81jY9RCOL+jvTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YoY8EMmB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725996; x=1769261996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HJDg2gNrnTLyeXcVYWNvxi1qJesg421w8qhKg61bf0I=;
  b=YoY8EMmBaQqvX2Ngcez966vFu8+zRcmRU572jhgA+VUbwbS74XulUVPl
   xfqPmvOHCNWQxzNfNTKN7T+9s+LHfHfiEovjCQt65GGpppeamjrl7aCRf
   wbO/U1ixuSGFE+H1I2Qe2JMtYC+vLOWnRkOfjoWcKmhoS+2bnCf0mZ+9a
   DVLVeHefJbklfW9CT80sz4Qj2++4drnXos0MpWT2hTmaOMUbJWOZ4+DYr
   CGN88THiMSYn2O6sqIgKMiR+SaXdInsn2qKHJNLegWyobv7xqC/T/S4HI
   YbYfTHXsDcqjzOCd3RL0rrW5xyFyt4APF5OKdSMrpMUNl5JVyIPFxES91
   g==;
X-CSE-ConnectionGUID: h0L6CAa0TEi6SIf7fqE09Q==
X-CSE-MsgGUID: ybP6GIygRzSBdjIAoLL5uQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246607"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246607"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:55 -0800
X-CSE-ConnectionGUID: LG/CYRvYQkyYkHJ10JL3Qg==
X-CSE-MsgGUID: jYYsE2hrSvyw1W0v3/j+pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804472"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:51 -0800
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
Subject: [PATCH v7 46/52] i386/tdx: Mark the configurable bit not reported by KVM as unsupported
Date: Fri, 24 Jan 2025 08:20:42 -0500
Message-Id: <20250124132048.3229049-47-xiaoyao.li@intel.com>
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

There is no interface in KVM to report the support bits of TD guest.
QEMU has to maintain the knowledge itself. E.g., fixed0 and fixed1 are
already hardcoded in tdx_fixed0_bits and tdx_fixed1_bits.

For configurable bits, KVM might filer some due to KVM lacks the support
currently. The filtered bits need to be marked as unsupported as well.
However, there is no interface to report which configurable bit is
turned unconfigurable.

Maintain the configurable bits of TDX module in QEMU and compare with
KVM reported configurable to find the ones being turned unconfigurable
by KVM and mark them as unsupported.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b46e581bb40e..2b9a47020934 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -529,6 +529,50 @@ KvmCpuidInfo tdx_fixed1_bits = {
     },
 };
 
+/* TDX module 1.5.08.04.0784 on EMR */
+KvmCpuidInfo tdx_configurable_bits = {
+    .cpuid.nent = 6,
+    .entries[0] = {
+        .function = 0x1,
+        .index = 0,
+        .eax = 0x0fff3fff,
+        .ebx = 0x00ff0000,
+        .ecx = 0x31044988,
+        .edx = 0xb8400000,
+    },
+    .entries[1] = {
+        .function = 0x7,
+        .index = 0,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .ebx = 0xd02b9b18,
+        .ecx = 0x02417f64,
+        .edx = 0x00054010,
+    },
+    .entries[2] = {
+        .function = 0x7,
+        .index = 0x1,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .eax = 0x00001c30,
+    },
+    .entries[3] = {
+        .function = 0x7,
+        .index = 0x2,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .edx = 0x00000008,
+    },
+    .entries[4] = {
+        .function = 0x1c,
+        .index = 0x0,
+        .eax = 0x0000000b,
+    },
+    .entries[5] = {
+        .function = 0x80000008,
+        .index = 0,
+        .eax = 0x000000ff,
+        .ebx = 0x00000200,
+    },
+};
+
 typedef struct TdxAttrsMap {
     uint32_t attr_index;
     uint32_t cpuid_leaf;
@@ -621,7 +665,7 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
 {
-    struct kvm_cpuid_entry2 *e;
+    struct kvm_cpuid_entry2 *e, *e1;
     uint32_t fixed0, fixed1;
 
     switch (feature) {
@@ -653,6 +697,21 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
     tdx_mask_cpuid_by_attrs(feature, index, reg, &value);
     tdx_mask_cpuid_by_xfam(feature, index, reg, &value);
 
+    e = cpuid_find_entry(&tdx_caps->cpuid, feature, index);
+    if (e) {
+        e1 = cpuid_find_entry(&tdx_configurable_bits.cpuid, feature, index);
+        if (e1) {
+            uint32_t kvm_configurable = cpuid_entry_get_reg(e, reg);
+            uint32_t tdx_module_configurable = cpuid_entry_get_reg(e1, reg);
+            for (int i = 0; i < 32; i++) {
+                uint32_t f = 1U << i;
+                if (f & tdx_module_configurable && !(f & kvm_configurable)) {
+                    value &= ~f;
+                }
+            }
+        }
+    }
+
     e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
     if (e) {
         fixed0 = cpuid_entry_get_reg(e, reg);
-- 
2.34.1


