Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6385F21BD15
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 20:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGJSfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 14:35:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:56297 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbgGJSfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 14:35:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 10 Jul 2020 11:35:38 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id F24E540CB1;
        Fri, 10 Jul 2020 11:35:42 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 4/4] x86: Allow to limit maximum RAM address
Date:   Fri, 10 Jul 2020 11:33:20 -0700
Message-ID: <20200710183320.27266-5-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710183320.27266-1-namit@vmware.com>
References: <20200710183320.27266-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While there is a feature to limit RAM memory, we should also be able to
limit the maximum RAM address. Specifically, svm can only work when the
maximum RAM address is lower than 4G, as it does not map the rest of the
memory into the NPT.

Allow to do so using the firmware, when in fact the expected use-case is
to provide this infomation on bare-metal using the MEMLIMIT parameter in
initrd.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/x86/fwcfg.c | 4 ++++
 lib/x86/fwcfg.h | 1 +
 lib/x86/setup.c | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
index 06ef62c..c2aaf5a 100644
--- a/lib/x86/fwcfg.c
+++ b/lib/x86/fwcfg.c
@@ -28,6 +28,10 @@ static void read_cfg_override(void)
 	if ((str = getenv("TEST_DEVICE")))
 		no_test_device = !atol(str);
 
+	if ((str = getenv("MEMLIMIT")))
+		fw_override[FW_CFG_MAX_RAM] = atol(str) * 1024 * 1024;
+
+
     fw_override_done = true;
 }
 
diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
index 2f17461..64d4c6e 100644
--- a/lib/x86/fwcfg.h
+++ b/lib/x86/fwcfg.h
@@ -21,6 +21,7 @@
 #define FW_CFG_BOOT_MENU        0x0e
 #define FW_CFG_MAX_CPUS         0x0f
 #define FW_CFG_MAX_ENTRY        0x10
+#define FW_CFG_MAX_RAM		0x11
 
 #define FW_CFG_WRITE_CHANNEL    0x4000
 #define FW_CFG_ARCH_LOCAL       0x8000
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index b5941cd..7befe09 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -66,6 +66,9 @@ void find_highmem(void)
 	u64 upper_end = bootinfo->mem_upper * 1024ull;
 	u64 best_start = (uintptr_t) &edata;
 	u64 best_end = upper_end;
+	u64 max_end = fwcfg_get_u64(FW_CFG_MAX_RAM);
+	if (max_end == 0)
+		max_end = -1ull;
 	bool found = false;
 
 	uintptr_t mmap = bootinfo->mmap_addr;
@@ -79,8 +82,12 @@ void find_highmem(void)
 			continue;
 		if (mem->length < best_end - best_start)
 			continue;
+		if (mem->base_addr >= max_end)
+			continue;
 		best_start = mem->base_addr;
 		best_end = mem->base_addr + mem->length;
+		if (best_end > max_end)
+			best_end = max_end;
 		found = true;
 	}
 
-- 
2.25.1

