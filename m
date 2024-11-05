Return-Path: <kvm+bounces-30651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC2D9BC58E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE5F21C2115E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99D51FDF9D;
	Tue,  5 Nov 2024 06:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+oC5gGa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529261714A0
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788659; cv=none; b=X9EP8NNew7ckdm7/GOGUT0UGdKDT483EynwB/MSf0uHF/ykSUo915FN+jNOPSnmyidPyr0ytq69vBmpFBQdfcR3lgRmEGNRzIpGRGaOnwJoi0xUsKBVtGi8YeDBmwXyJ1e18PEaRPbotiPKAGR3Bd5vlB+tgGTV5hAs/sahBPnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788659; c=relaxed/simple;
	bh=eviZxt2uHCaBFHxS9OQDjWkbBKzkgFdGvefQVCQtPgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WwytQQOsQTlwsfkPu4BkNrLJ7ODi5ZhvJU8AF1EByBiM8epMaKlqFyoyw6+MTC2YcAyc11Cowc036GcHsg/FDQemcYGd9XXhd64STfIDsNqYJGU5HjEs5bpVd7dsDoOZZzjLeQm5NCdt4kvWSevW5e5imT2G/y92LVUj1MciJaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W+oC5gGa; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788658; x=1762324658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eviZxt2uHCaBFHxS9OQDjWkbBKzkgFdGvefQVCQtPgg=;
  b=W+oC5gGadj3TAryv4aB0abMcvjBRacnTQ5egb6bnlT2EsJ9W1EJnAME2
   LoVD9B/lg2/BgZiz44u3OkfAwK4hEnZt6a/pVzI0BtPRTXlHbQF2j7hSM
   ZX5FtUCJ+m4eXvY+ILnmRimoc8aHBjInf/npEKMka5UBJj2yDQObjRC0c
   gWJ2PueEKW4zj7XxKdoAA+n8cTqGOwzxaflm8YpwVIX+9XpdcEZPJ5Sym
   rUkMyStnpAHikvw9Aky/7v6AqYvG7TKK7+wIX1j1/GsVbNzHnxy4UlIf3
   gb/oqiCJfnfMGBQykuLK8y/b0rbuOgAOFb3Um1DA9PprfcC9sK0FQRlnu
   A==;
X-CSE-ConnectionGUID: wL2W0e8LRsu/VbR8vGlp0g==
X-CSE-MsgGUID: 0NE4ExfOQh2zpPFrp1hxtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689484"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689484"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:38 -0800
X-CSE-ConnectionGUID: h4M+rUgqSuWhYI8H31oyhw==
X-CSE-MsgGUID: rtUp98ElRPurPn+fT+1nsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988899"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:30 -0800
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
Subject: [PATCH v6 17/60] i386/tdx: load TDVF for TD guest
Date: Tue,  5 Nov 2024 01:23:25 -0500
Message-Id: <20241105062408.3533704-18-xiaoyao.li@intel.com>
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
index b86c38212eab..1df496a15eff 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -44,6 +44,7 @@
 #include "standard-headers/asm-x86/bootparam.h"
 #include CONFIG_DEVICES
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 
 #ifdef CONFIG_XEN_EMU
 #include "hw/xen/xen.h"
@@ -1007,11 +1008,14 @@ void x86_bios_rom_init(X86MachineState *x86ms, const char *default_firmware,
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
index 4193211c3190..d5ebc2430fd1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -120,6 +120,12 @@ static int get_tdx_capabilities(Error **errp)
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
index 0aebc7e3f6c9..e5d836805385 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -28,6 +28,8 @@ typedef struct TdxGuest {
     char *mrconfigid;       /* base64 encoded sha348 digest */
     char *mrowner;          /* base64 encoded sha348 digest */
     char *mrownerconfig;    /* base64 encoded sha348 digest */
+
+    MemoryRegion *tdvf_mr;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -37,5 +39,6 @@ bool is_tdx_vm(void);
 #endif /* CONFIG_TDX */
 
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
+void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


