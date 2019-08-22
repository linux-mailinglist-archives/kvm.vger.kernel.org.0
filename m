Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAFD9A413
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfHVXuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:50:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:61185 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbfHVXuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:50:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 16:50:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="181553109"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 22 Aug 2019 16:50:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Fix breakage of fw_cfg for 32-bit unit tests
Date:   Thu, 22 Aug 2019 16:50:52 -0700
Message-Id: <20190822235052.3703-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure the fw_cfg overrides are parsed prior consuming any of said
overrides.  fwcfg_get_u() treats zero as a valid overide value, which
is slightly problematic since the overrides are in the .bss and thus
initialized to zero.

Add a limit check when indexing fw_override so that future code doesn't
spontaneously explode.

Cc: Nadav Amit <nadav.amit@gmail.com>
Fixes: 03b1e4570f967 ("x86: Support environments without test-devices")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/fwcfg.c | 10 ++++++++--
 lib/x86/fwcfg.h |  2 --
 x86/cstart64.S  |  2 --
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
index d8d797f..06ef62c 100644
--- a/lib/x86/fwcfg.c
+++ b/lib/x86/fwcfg.c
@@ -5,10 +5,11 @@
 static struct spinlock lock;
 
 static long fw_override[FW_CFG_MAX_ENTRY];
+static bool fw_override_done;
 
 bool no_test_device;
 
-void read_cfg_override(void)
+static void read_cfg_override(void)
 {
 	const char *str;
 	int i;
@@ -26,6 +27,8 @@ void read_cfg_override(void)
 
 	if ((str = getenv("TEST_DEVICE")))
 		no_test_device = !atol(str);
+
+    fw_override_done = true;
 }
 
 static uint64_t fwcfg_get_u(uint16_t index, int bytes)
@@ -34,7 +37,10 @@ static uint64_t fwcfg_get_u(uint16_t index, int bytes)
     uint8_t b;
     int i;
 
-    if (fw_override[index] >= 0)
+    if (!fw_override_done)
+        read_cfg_override();
+
+    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >= 0)
 	    return fw_override[index];
 
     spin_lock(&lock);
diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
index 88dc7a7..2f17461 100644
--- a/lib/x86/fwcfg.h
+++ b/lib/x86/fwcfg.h
@@ -36,8 +36,6 @@
 
 extern bool no_test_device;
 
-void read_cfg_override(void);
-
 static inline bool test_device_enabled(void)
 {
 	return !no_test_device;
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 23c1bd4..d4e4652 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -254,8 +254,6 @@ start64:
 	mov %rax, __args(%rip)
 	call __setup_args
 
-	/* Read the configuration before running smp_init */
-	call read_cfg_override
 	call smp_init
 	call enable_x2apic
 
-- 
2.22.0

