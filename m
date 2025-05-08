Return-Path: <kvm+bounces-45952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F39AAFEBE
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C96B33A67A0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4BF28850F;
	Thu,  8 May 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9w1bqCK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D027B4FF
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716848; cv=none; b=VwOmy8vGdto7tejzykqzYihKIrp2nB52jIeeD/p84VdbX+DziucKDDEwoj52a0q7pvFfD8nG/afUlUtaRtvcwJ+P1LI5nTZip7SxOcgVAIQM2cYlGRJ9PyHF9VWCkCDj1D3IrcHvUSXANmBQft8A4zIYDl4/j1ytxfd0wuCR49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716848; c=relaxed/simple;
	bh=pOLEUR8SCOwB++SmnsFFG3cZP0bcRPjjl0chh6ZN5ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWz7BNF/h72HjMIzzabBKnvALpkBmm8TtR7xJyBYzlmUNCiUXjGsHueN73aGX6/yOU2YyVmfE+ZqWTU5UtlQbvox8HoYWI+hEeRSRk++5lpvxwLZTVJ6mrPZzQrx+ckFJzi4xs/VSWFutBqYxbryk8ysoBWLW1UptyDXlMB/eyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9w1bqCK; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716847; x=1778252847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOLEUR8SCOwB++SmnsFFG3cZP0bcRPjjl0chh6ZN5ns=;
  b=f9w1bqCKj6epDXlXmxz1Vxlp7h7XpXwVZhe67+An5HasFC3x/mW/xKPv
   yudnRSRg9Ce2uzJCZM3w++VcGeh2UbEqPoK4iFEwNeKQbRdOKUZ8k5d2f
   LbOItsoS8gNEW2FeSHzu7SyOtwKqGV0/U9OjNPKEgoiJTROsdhsr8QVND
   czd/DYlXVibb4B32yQWpjfua4bN3pJuVNyswCMAZQtWZkgcJpX7fS5XC+
   /TIYpAq3zfjwNClQGo+lBiJLLu04ghd1GektDynx6NcsvL6mO8KCKA1qp
   6PSQHzEjXOIjmXoyhFKpSl95Qce61Qxccx4XIAGB6yFZuBejSiu7ADA5P
   Q==;
X-CSE-ConnectionGUID: 0FgTy7f9Qv2j34QFcUFX0g==
X-CSE-MsgGUID: 2vd2gPA6TXW/dTfG8+JvkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888546"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888546"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:26 -0700
X-CSE-ConnectionGUID: FE88bzw3RmOPJV8mvosaMA==
X-CSE-MsgGUID: JdSZ7wEtRJifZZjgNPdmvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440530"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:23 -0700
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
Subject: [PATCH v9 49/55] i386/tdx: Define supported KVM features for TDX
Date: Thu,  8 May 2025 10:59:55 -0400
Message-ID: <20250508150002.689633-50-xiaoyao.li@intel.com>
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

For TDX, only limited KVM PV features are supported.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 528b5cb4ae47..16d55613c683 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,8 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 #define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
 
@@ -44,6 +46,14 @@
                                  TDX_TD_ATTRIBUTES_PKS | \
                                  TDX_TD_ATTRIBUTES_PERFMON)
 
+#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
+                                     (1U << KVM_FEATURE_PV_UNHALT) | \
+                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
+                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
+                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
+                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
+                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -638,6 +648,14 @@ static void tdx_add_supported_cpuid_by_xfam(void)
     e->edx |= (tdx_caps->supported_xfam & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
+static void tdx_add_supported_kvm_features(void)
+{
+    struct kvm_cpuid_entry2 *e;
+
+    e = find_in_supported_entry(0x40000001, 0);
+    e->eax = TDX_SUPPORTED_KVM_FEATURES;
+}
+
 static void tdx_setup_supported_cpuid(void)
 {
     if (tdx_supported_cpuid) {
@@ -654,6 +672,8 @@ static void tdx_setup_supported_cpuid(void)
     tdx_add_supported_cpuid_by_fixed1_bits();
     tdx_add_supported_cpuid_by_attrs();
     tdx_add_supported_cpuid_by_xfam();
+
+    tdx_add_supported_kvm_features();
 }
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
-- 
2.43.0


