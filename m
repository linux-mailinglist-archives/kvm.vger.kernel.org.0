Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F782C3635
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 02:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgKYBWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 20:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKYBWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 20:22:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED363C0613D4
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 17:22:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 131so764834pfb.9
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 17:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D1nug8CnSSYJdY2nygQV8051AV6UmGP0HDotUH63z+Q=;
        b=SjYzIQ/3Tmjt/8zU/mE8Ibpn8t4ESgOQeiD21rBi/ByaYigmYymufaNaECRp5QSJe6
         HSCUiQ0ZKyH85HiHWjqA/EimBejPUNUDonvlfq22OF1QO1cZz22dpgCj5eAKSt4648i3
         3U2OB1dBEagPB07MPbtgBZBVZkJM8/Xg4a9ohrvszRjFJJmCCj00rKPg//HbdOZ7VbvL
         SQbxU94CsSOKUBMXr3Nk7nZS3WYHs/7MdSQoJj9mg46ujVofS6me6iWrsJw1+bBqiGiF
         I24QfBUR0a0ZpbgnhacSUwTB+vD6wmVxDYvAzs4/qF+ZdnRi0+sVpSApYfxu1Ki1Hu57
         Lsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D1nug8CnSSYJdY2nygQV8051AV6UmGP0HDotUH63z+Q=;
        b=MsXfxqb1oIMO6hs6voXjpGZWnsoAwar3/+1tzX+mPd0KcbJvv2hcj3g37q3bMRrmX4
         x+Q9ZaHM/LFYlGT9ClcOVf1gOBTiglEOPuU6vbnuTROH+U26SJ359Vg5h5xTtUwwqgl5
         Ly9eqa9KDiFUnoSzquelCePFywR5VCOLtHr0mwToYppZp5DrDlVjAo4tnbnrypHksNMP
         b0lCZ5d1D5xMfLk+oJSQ3n191Qkqlb6zZsV5wzK5mNV36ge3/2UN1TnrdZlNjswjKcxI
         9p9IQxcRMzp8d4fW58J9Rh3VxPuDGQz3/0WvICS57M1VoKFW1FUqZj/zLJ+MfqRJ1Dvj
         kEBQ==
X-Gm-Message-State: AOAM530qEIpOXZN1fWviPpDeCaLdIL/lteSOinSqMHRFI/r+AGZfoaHe
        WdIsJaQMMHsnc4qlZ3O07q9reJF4dTl3hw==
X-Google-Smtp-Source: ABdhPJwDbcPhZdfDVVvGJD5aYRAQrwY11+FCX6nrTkk2u9BYYM55Czh4TBU5TU5/6sx88KdoAN4JHQ==
X-Received: by 2002:a17:90a:d3d3:: with SMTP id d19mr1206595pjw.0.1606267374570;
        Tue, 24 Nov 2020 17:22:54 -0800 (PST)
Received: from pek-vx-bsp2.wrs.com (unknown-124-94.windriver.com. [147.11.124.94])
        by smtp.gmail.com with ESMTPSA id 205sm346757pge.76.2020.11.24.17.22.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Nov 2020 17:22:54 -0800 (PST)
From:   Bin Meng <bmeng.cn@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Bin Meng <bin.meng@windriver.com>
Subject: [kvm-unit-tests][PATCH v1] x86: Add a new test case for ret/iret with a nullified segment
Date:   Wed, 25 Nov 2020 09:22:43 +0800
Message-Id: <1606267363-86660-1-git-send-email-bmeng.cn@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

This makes up the test case for one QEMU x86 emulation issue that
was fixed by the following QEMU patch:
https://lists.nongnu.org/archive/html/qemu-devel/2020-11/msg03534.html

Note the test case only fails on an unpatched QEMU with "accel=tcg".

Signed-off-by: Bin Meng <bin.meng@windriver.com>
---

Changes in v1:
- reworded the commit message to be clearer
- removed the RFC tag as it looked good to Paolo

 x86/emulator.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index e46d97e..7bd3b8f 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -6,10 +6,14 @@
 #include "processor.h"
 #include "vmalloc.h"
 #include "alloc_page.h"
+#include "usermode.h"
 
 #define memset __builtin_memset
 #define TESTDEV_IO_PORT 0xe0
 
+#define MAGIC_NUM 0xdeadbeefdeadbeefUL
+#define GS_BASE 0x400000
+
 static int exceptions;
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally.  */
@@ -925,6 +929,39 @@ static void test_sreg(volatile uint16_t *mem)
     write_ss(ss);
 }
 
+static uint64_t usr_gs_mov(void)
+{
+    static uint64_t dummy = MAGIC_NUM;
+    uint64_t dummy_ptr = (uint64_t)&dummy;
+    uint64_t ret;
+
+    dummy_ptr -= GS_BASE;
+    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret) : "c"(dummy_ptr));
+
+    return ret;
+}
+
+static void test_iret(void)
+{
+    uint64_t val;
+    bool raised_vector;
+
+    /* Update GS base to 4MiB */
+    wrmsr(MSR_GS_BASE, GS_BASE);
+
+    /*
+     * Per the SDM, jumping to user mode via `iret`, which is returning to
+     * outer privilege level, for segment registers (ES, FS, GS, and DS)
+     * if the check fails, the segment selector becomes null.
+     *
+     * In our test case, GS becomes null.
+     */
+    val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
+                      0, 0, 0, 0, &raised_vector);
+
+    report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
+}
+
 /* Broken emulation causes triple fault, which skips the other tests. */
 #if 0
 static void test_lldt(volatile uint16_t *mem)
@@ -1074,6 +1111,7 @@ int main(void)
 	test_shld_shrd(mem);
 	//test_lgdt_lidt(mem);
 	test_sreg(mem);
+	test_iret();
 	//test_lldt(mem);
 	test_ltr(mem);
 	test_cmov(mem);
-- 
2.7.4

