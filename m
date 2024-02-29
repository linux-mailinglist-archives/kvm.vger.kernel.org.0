Return-Path: <kvm+bounces-10392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 594C586C107
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1A71C21003
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCAA46B98;
	Thu, 29 Feb 2024 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hV/S3GZM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9260F46447
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188893; cv=none; b=lu8Spkv4sbjbix57o7Oxh42czL0R1D26CiUlKUJX0fN8rJTwFRb5dc6Jwt2QAZLXQXzJfFvM/dR1Ge2J5nSQFHRQkZzfphUXAZrjdfA7MC2SPhiSHbCEwVDT+qYS+Y2bN5k9iPxzgv+3yOjtAKtLIQmKurss6lN46dQok/RETMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188893; c=relaxed/simple;
	bh=7gqINbzguIZPAZ32V6gUuwIXeZkcagTHNpNt0PPOTHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=axUF1Qzutje3WTqbTDjONt0IMoWZ06hH/UbixsaJzq+nMfdZS8tm7B8FQXY8m3BzT0hL0Jb78KXqrruVwU0TlCZ6LjQuwYPNt2YTpS+MJul82JD1vIAAXvuhU9tgqfw5FKhKhgzzcEZUJxiVx+d+jE59OT4MC2gRkxozXP8XduU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hV/S3GZM; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188891; x=1740724891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7gqINbzguIZPAZ32V6gUuwIXeZkcagTHNpNt0PPOTHg=;
  b=hV/S3GZMB3OfrUEUn+UNp2rv8jK4kdQ+c1WRSvMkUa4pKQMRJOCbEbK6
   XpNRQ9/6Q5du7M1Y1LyTarAL72kgFABCKzGhemel8GXPhV0gU+ZKWpfsP
   CwF7WfsekVzdElo8fQjmuOP8OnOtZSnbZCdrLA+BhoWxCPeV6BMJF0Hw3
   25xhco2aGDpbvcRcMPbkr81fcyfd8Q7nY3GnrtLFy8+ZKeKiMzud/9Qc3
   ParGsWr1E0uu5CFzgA3EAaNDPlaVJFUraC9gh5fn2Jhu2tVm3ZINCnrB9
   n2c6IGZay/RKUNGX8zh/vl4TaDfcdJqhU7rGHw77h6/ZDaTufmZnundeV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802898"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802898"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:41:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075691"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:41:24 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 36/65] i386/tdx: load TDVF for TD guest
Date: Thu, 29 Feb 2024 01:36:57 -0500
Message-Id: <20240229063726.610065-37-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
 hw/i386/x86.c         | 13 +++++++++++--
 target/i386/kvm/tdx.c |  7 +++++++
 target/i386/kvm/tdx.h |  3 +++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index fa7095310f37..5a0cadc88c4f 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -47,6 +47,7 @@
 #include "hw/intc/i8259.h"
 #include "hw/rtc/mc146818rtc.h"
 #include "target/i386/sev.h"
+#include "kvm/tdx.h"
 
 #include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
@@ -1157,9 +1158,17 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
         (bios_size % 65536) != 0) {
         goto bios_error;
     }
+
     bios = g_malloc(sizeof(*bios));
-    memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
-    if (sev_enabled()) {
+    if (is_tdx_vm()) {
+        memory_region_init_ram_guest_memfd(bios, NULL, "pc.bios", bios_size,
+                                           &error_fatal);
+        tdx_set_tdvf_region(bios);
+    } else {
+        memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    }
+
+    if (sev_enabled() || is_tdx_vm()) {
         /*
          * The concept of a "reset" simply doesn't exist for
          * confidential computing guests, we have to destroy and
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 13f069171db7..7c8e14e3cc58 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -463,6 +464,12 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
             (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
+void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
+{
+    assert(!tdx_guest->tdvf_mr);
+    tdx_guest->tdvf_mr = tdvf_mr;
+}
+
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 2697e6bdfb1d..c021223001a5 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -24,6 +24,8 @@ typedef struct TdxGuest {
     char *mrconfigid;       /* base64 encoded sha348 digest */
     char *mrowner;          /* base64 encoded sha348 digest */
     char *mrownerconfig;    /* base64 encoded sha348 digest */
+
+    MemoryRegion *tdvf_mr;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -35,5 +37,6 @@ bool is_tdx_vm(void);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
+void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


