Return-Path: <kvm+bounces-36500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C79A1B6F1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2D9A16E276
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BE37580C;
	Fri, 24 Jan 2025 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRuCQ6/U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0FF4D599
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725879; cv=none; b=l5/GrIkDGBVtAiL8jWLZu06MtAwrN+fm+byucd9NrcGc9KRpRDVdLDetHbR23zjhS+AZGbPeYRO/EjT3DYDJU6lIPnem2doZZfeDb80RDLuWAMZBxUdlI2f/xVyrGCT07r8e/7NJPMAK8sd0RU7c/eyfHuOjBGavFdfmQ/hNU/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725879; c=relaxed/simple;
	bh=57vNewpNjlNsOGxCHvti2rQKSJRLR2ytKnQk0AXe0PQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AvN8fkV/j5Pmy4OPjRF3/7KJC76vYQO3WgiJpDCoxOQuZcCN2CcPX7n+TvW3sl+Sf67VngKPGdW+m+Lnb27lHWf9rOIdVvUPmeAECxp4NpP8CEMHe1RMH7Y7eg12en1gqIIv9mNT1ypm17OLidtxvqRAVSm5U+xB6vEtk1wF7yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lRuCQ6/U; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725879; x=1769261879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=57vNewpNjlNsOGxCHvti2rQKSJRLR2ytKnQk0AXe0PQ=;
  b=lRuCQ6/ULJfOmdL3trCtAxB4w7qAOdCGYkObYyhp+8+d+CeHuPJVglZc
   WFtPWgcv/sJ/X9KrUcKWLCUfIYur8/qYFXN/IKYBAtXddLjU6IYhajZ6b
   yxSOU/ORQfNy0xIIqZ6369Ja2mu9oJpIXIXB1pdom8HIXORWK6MUf695o
   LnQtKD3tVMtMInnG0YMXSXiYq45ico1kOvxOysWvf6513s10z33EcUec3
   Dr4eKnXv/fVxg3OKDqqrEfXR9eAB8lgA/XugQAkq3HAzvQMHD1pexlvu3
   4ywyq/h91abpraJb8d/0SFqTuoI/GhG3ATOYSmpPUKErhvG827nx25GCg
   g==;
X-CSE-ConnectionGUID: r9MWZehcSf+u1XDAFInOMA==
X-CSE-MsgGUID: GJ5qBUSbTQ620agxbbw93Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246298"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246298"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:58 -0800
X-CSE-ConnectionGUID: 0CXDbUQTSmOIl/OBnySsXw==
X-CSE-MsgGUID: PxUwDFD5TKmZmxHT4HD22w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804234"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:54 -0800
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
Subject: [PATCH v7 15/52] i386/tdx: load TDVF for TD guest
Date: Fri, 24 Jan 2025 08:20:11 -0500
Message-Id: <20250124132048.3229049-16-xiaoyao.li@intel.com>
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

From: Chao Peng <chao.p.peng@linux.intel.com>

TDVF(OVMF) needs to run at private memory for TD guest. TDX cannot
support pflash device since it doesn't support read-only private memory.
Thus load TDVF(OVMF) with -bios option for TDs.

Use memory_region_init_ram_guest_memfd() to allocate the MemoryRegion
for TDVF because it needs to be located at private memory.

Also store the MemoryRegion pointer of TDVF since the shared ramblock of
it can be discared after it gets copied to private ramblock.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86-common.c  | 6 +++++-
 target/i386/kvm/tdx.c | 6 ++++++
 target/i386/kvm/tdx.h | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index 008496b5b851..1f9492c2dbfd 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -44,6 +44,7 @@
 #include "standard-headers/asm-x86/bootparam.h"
 #include CONFIG_DEVICES
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 
 #ifdef CONFIG_XEN_EMU
 #include "hw/xen/xen.h"
@@ -1035,11 +1036,14 @@ void x86_bios_rom_init(X86MachineState *x86ms, const char *default_firmware,
     if (machine_require_guest_memfd(MACHINE(x86ms))) {
         memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, "pc.bios",
                                            bios_size, &error_fatal);
+        if (is_tdx_vm()) {
+            tdx_set_tdvf_region(&x86ms->bios);
+        }
     } else {
         memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
                                bios_size, &error_fatal);
     }
-    if (sev_enabled()) {
+    if (sev_enabled() || is_tdx_vm()) {
         /*
          * The concept of a "reset" simply doesn't exist for
          * confidential computing guests, we have to destroy and
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2124284e1653..f1c0553e6d4a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -137,6 +137,12 @@ static int get_tdx_capabilities(Error **errp)
     return 0;
 }
 
+void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
+{
+    assert(!tdx_guest->tdvf_mr);
+    tdx_guest->tdvf_mr = tdvf_mr;
+}
+
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(cgs);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index d39e733d9fcc..b73461b8d8a3 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -30,6 +30,8 @@ typedef struct TdxGuest {
     char *mrconfigid;       /* base64 encoded sha348 digest */
     char *mrowner;          /* base64 encoded sha348 digest */
     char *mrownerconfig;    /* base64 encoded sha348 digest */
+
+    MemoryRegion *tdvf_mr;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -39,5 +41,6 @@ bool is_tdx_vm(void);
 #endif /* CONFIG_TDX */
 
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
+void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


