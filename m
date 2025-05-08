Return-Path: <kvm+bounces-45957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C2DAAFEC2
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D3A01C4162A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BD727D763;
	Thu,  8 May 2025 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IS6hLohu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61EB28851E
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716863; cv=none; b=oJTODGqFbBbkwQaRNqvnV/n/XlvICwjcuC45cyXuy2E4E6a3USu1R7+ItYAO7RFjZKN18XERBX5IZ0YnQX8mGG9sEn+YfCg7ACBqW/H0E79GA0HE9xk58rfnGVZI3ltzW7LgY/A+Pm63hQopoDjEVb4DK3E3FRWTrhv6K7p63hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716863; c=relaxed/simple;
	bh=5S1CixiYB970hm+ZoGlLSx+MtTlVqYPQqy4udp+5eeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SfcCbbfa/wL/A/u/xJ4cOY8jnD1QP57VJAvDUcqoncbmHRteRGOs2rkhudjZLrLcli1lRjwpr1GLWQDbafspxSZ1y7k95qnVH7rOZXRIVpTjL4FGM/N+I9meQss9ssLZhq+roV/ehi9/WFWsf2dVf9Net92ovohFA+Da4ReE0WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IS6hLohu; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716862; x=1778252862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5S1CixiYB970hm+ZoGlLSx+MtTlVqYPQqy4udp+5eeY=;
  b=IS6hLohu3/+9mrB7jnuj1WvzACZucXMorhjhPxsGqOySh+OsgbZt2ApX
   1XEbCr8jlUXuPsqRc7he3keOR2oKtVh8moal6FMK+9GOMbvvfH648MxsW
   T7o5LfG1Grmnia4xeQR9TrDiGDs23gtFetOE9VvURx/4sIovB9yP3MYue
   m9luIfBi8KF5C59S/EBCZzfU5bNzZsohVI7zkYfsvnt+Oru39GbcI8Z1r
   9onWQJBCfaHHSg2wjgaysVfeHjeJFvqrtvPVfE162yhOEjl8v0demdptE
   SMGvZbOeYD2qKF4wBqhzEMJhSq4Bx6GifzcDq8eLST50k/equQxjJBbcA
   A==;
X-CSE-ConnectionGUID: XFs23RKuQouAjTm+pwwlyw==
X-CSE-MsgGUID: 2zav6qNbTsihI6gYeC7apg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716576"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716576"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:42 -0700
X-CSE-ConnectionGUID: m8oDDevrShqjg1U+3XTEWQ==
X-CSE-MsgGUID: JIMIeQtWRqifm4Ahxf+zXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440582"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:38 -0700
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
Subject: [PATCH v9 54/55] i386/tdx: Validate phys_bits against host value
Date: Thu,  8 May 2025 11:00:00 -0400
Message-ID: <20250508150002.689633-55-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For TDX guest, the phys_bits is not configurable and can only be
host/native value.

Validate phys_bits inside tdx_check_features().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - return -EINVAL instead of exit(1); (Zhao Liu)
---
 target/i386/host-cpu.c | 2 +-
 target/i386/host-cpu.h | 1 +
 target/i386/kvm/tdx.c  | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 3e4e85e729c8..8a15af458b05 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -15,7 +15,7 @@
 #include "system/system.h"
 
 /* Note: Only safe for use on x86(-64) hosts */
-static uint32_t host_cpu_phys_bits(void)
+uint32_t host_cpu_phys_bits(void)
 {
     uint32_t eax;
     uint32_t host_phys_bits;
diff --git a/target/i386/host-cpu.h b/target/i386/host-cpu.h
index 6a9bc918baa4..b97ec01c9bec 100644
--- a/target/i386/host-cpu.h
+++ b/target/i386/host-cpu.h
@@ -10,6 +10,7 @@
 #ifndef HOST_CPU_H
 #define HOST_CPU_H
 
+uint32_t host_cpu_phys_bits(void);
 void host_cpu_instance_init(X86CPU *cpu);
 void host_cpu_max_instance_init(X86CPU *cpu);
 bool host_cpu_realizefn(CPUState *cs, Error **errp);
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6aeb4fcc4975..b6b938fcccaa 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -25,6 +25,7 @@
 
 #include "cpu.h"
 #include "cpu-internal.h"
+#include "host-cpu.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
@@ -886,6 +887,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
         return -EINVAL;
     }
 
+    if (cpu->phys_bits != host_cpu_phys_bits()) {
+        error_report("TDX requires guest CPU physical bits (%u) "
+                     "to match host CPU physical bits (%u)",
+                     cpu->phys_bits, host_cpu_phys_bits());
+        return -EINVAL;
+    }
+
     return 0;
 }
 
-- 
2.43.0


