Return-Path: <kvm+bounces-45915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A21AAAFE74
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43C74E3DC4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79541280CCE;
	Thu,  8 May 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bGMsmVOS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F31D7E41
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716732; cv=none; b=CAwmh/r3j2xPvxUOVpnVJhUlL0JAnUNi69Y9yIZRGJDh14StDGi3oAeVyyEtlkCdVpgP6LXFCJUDvMchqrJ5+U5W0Rc0XHriRxWnXWCER8Wco34E/3SFV8c/fOHiLq12f0ICLPefcUkDvi+a+6n9jesjpImLSBa8LfSWTMZhRyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716732; c=relaxed/simple;
	bh=rVIzaP3qdWuzL2yXUwNfHyDxSBB10qQRGIk9yvhB6LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JktB5WtYdW++9ISLskIHTAa3P819fYzCfLgfjRsSz1NIoERCHiwL0ysIpZKIz5+YN30qaxxzdEOZpEznHmm7S9I3wSyr/fsnbs0SgwLGR671DW9yqUWLJi8kpfVEV8F5nI/6byYEzJ2t4Io17v5RBeURKxNs16+4vlNuSej58bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bGMsmVOS; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716731; x=1778252731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rVIzaP3qdWuzL2yXUwNfHyDxSBB10qQRGIk9yvhB6LQ=;
  b=bGMsmVOSVclv/QNkAXBVAALKA5S+iGx1X43iTlFCXxz+Df+SxuU2H9Gl
   akKaq0gnLQLum+WGTwf/RXCvCdTNBi+YdMs0njV1zDgVXBhXTKdLrnOdi
   Vyh41jMnZnx+eNV07lvXQNcN4r2LuJxw4czFDiK4gpmDVbnR2ZccQ7NpF
   tEY+AN7hRM4+LfzffC6ailBjicbOXeRsCFSIlK1XPCwc2N+cvCMHxhLk0
   mXsURs9NPzPSJoQNm7HZwGaEdhkqwfi3aqpFyj8/TDjkrbCOm/fzAOVPV
   61oeixHc74K7mFVAQrbBYEyYI5vtd3PVwGGNWYDiuE1WL9bXCLct8d2Kg
   Q==;
X-CSE-ConnectionGUID: 1EHjIj5iTWK7qU+aB5QWLg==
X-CSE-MsgGUID: 5kXKwQ8sTjWhSOS9Okco7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888088"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888088"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:31 -0700
X-CSE-ConnectionGUID: UfPSlbNVQjiVnXIefAqMSw==
X-CSE-MsgGUID: GbZP3mqXTHyont73Gx6GHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439874"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:28 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 12/55] i386/tdx: Validate TD attributes
Date: Thu,  8 May 2025 10:59:18 -0400
Message-ID: <20250508150002.689633-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate TD attributes with tdx_caps that only supported bits are
allowed by KVM.

Besides, sanity check the attribute bits that have not been supported by
QEMU yet. e.g., debug bit, it will be allowed in the future when debug
TD support lands in QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
- error_setg and return -1, for the case of QEMU unsupported attributes
  being requested; (Daniel)

Changes in v8:
- Split the mrconfigid/mrowner/mrownerconfig part into a seperate next
  patch;

Changes in v7:
- Define TDX_SUPPORTED_TD_ATTRS as QEMU supported mask, to validates
  user's request. (Rick)

Changes in v3:
- using error_setg() for error report; (Daniel)
---
 target/i386/kvm/tdx.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1ab063f790d9..3de3b5fa6a49 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,10 +18,15 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
+#define TDX_SUPPORTED_TD_ATTRS  (TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE |\
+                                 TDX_TD_ATTRIBUTES_PKS | \
+                                 TDX_TD_ATTRIBUTES_PERFMON)
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -153,13 +158,34 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
-static void setup_td_guest_attributes(X86CPU *x86cpu)
+static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
+{
+    if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
+        error_setg(errp, "Invalid attributes 0x%lx for TDX VM "
+                   "(KVM supported: 0x%llx)", tdx->attributes,
+                   tdx_caps->supported_attrs);
+        return -1;
+    }
+
+    if (tdx->attributes & ~TDX_SUPPORTED_TD_ATTRS) {
+        error_setg(errp, "Some QEMU unsupported TD attribute bits being "
+                    "requested: 0x%lx (QEMU supported: 0x%llx)",
+                    tdx->attributes, TDX_SUPPORTED_TD_ATTRS);
+        return -1;
+    }
+
+    return 0;
+}
+
+static int setup_td_guest_attributes(X86CPU *x86cpu, Error **errp)
 {
     CPUX86State *env = &x86cpu->env;
 
     tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
                              TDX_TD_ATTRIBUTES_PKS : 0;
     tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+
+    return tdx_validate_attributes(tdx_guest, errp);
 }
 
 static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
@@ -225,7 +251,10 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
-    setup_td_guest_attributes(x86cpu);
+    r = setup_td_guest_attributes(x86cpu, errp);
+    if (r) {
+        return r;
+    }
 
     r = setup_td_xfam(x86cpu, errp);
     if (r) {
-- 
2.43.0


