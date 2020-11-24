Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC22B2C2012
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 09:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgKXIdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 03:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbgKXIdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 03:33:09 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54061C0613CF
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 00:33:09 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id t13so18501038ilp.2
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 00:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D+4ljYp5ekAR8JD2FAt/grYOdgFuxJ9VMOxQc5QIChM=;
        b=FoUNVPwNEDJCIPJXL9qPHaOQEvDP44TszPSk3/mH98HJxtrTynFLR0c1yfwBnrcpwY
         xPD2avNVH8qJPyRz01xHBTCv/u/WdsZDT/QSf94eYXcKy6Nz0f77JssgSHeFTrMlQxJr
         yYkvP3dTwGzdbLFFLaUjT7sr9KKUdk4rvTIVsWKmR+3a8MqfoLMP28yB+OQo9Vc1C6Cg
         x0Xa1elVjSM73pGK7L234QTWHrZjm1TCj1zUz0lEjqkn8YnLpgMnw1cKoTeTFye3/JsZ
         2AQ1oSpmzWvU5h5AacTaViBvxnHdYcXS5diNrYLEoTSzrLI6UjyjIsNVcwIfBVfIF6Id
         55rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D+4ljYp5ekAR8JD2FAt/grYOdgFuxJ9VMOxQc5QIChM=;
        b=jNz2CcRUNo9ggOzhWxUQeaEAnRWHOUEKWXqa6QkqAfkeb2YpZtnJtgISfyXo313Zn/
         XYGm3ktQvaqGrOCRuhByjVJv4MReTZtNrq06+13PDBeiZ2IvY0HTqMJSGSYzwoApTYW7
         E8luBTNrNyl+UpSsCJ+eqbOMov1K9fnw1ov+GI+WtiqezNcJcgp8MB9UpAS2AZ4IgVKv
         qhEmLbmjgxpdkGj2b0o4WiA3hcsvl3CeFTOAXq9BZCO0FKJfx7iFvzr446hryenoMGng
         7ivHHk2BgtkFTW/oObFC2VyvPf8WXewMqyUcnmE0XJEDlAWXfn1OnSmpRvnfCdDmF655
         zTgQ==
X-Gm-Message-State: AOAM532j1sLvKc1iJYfLzBzvxThzh5cj7tNwE2zCRpbNJt584xmRt/M/
        dgjgZTP/ug6EFbdx+dMiFvqF7iJNLt4=
X-Google-Smtp-Source: ABdhPJw/7A17eNwDMgOxftUlbqx73eCEW6HQFC/qaUwUhiIjZJy6RMkfvQ+H4GszAQeTklFP0x53iQ==
X-Received: by 2002:a92:c50d:: with SMTP id r13mr1630559ilg.160.1606206788800;
        Tue, 24 Nov 2020 00:33:08 -0800 (PST)
Received: from pek-vx-bsp2.wrs.com (unknown-124-94.windriver.com. [147.11.124.94])
        by smtp.gmail.com with ESMTPSA id f8sm9299753ile.11.2020.11.24.00.33.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Nov 2020 00:33:08 -0800 (PST)
From:   Bin Meng <bmeng.cn@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Bin Meng <bin.meng@windriver.com>
Subject: [kvm-unit-tests][RFC PATCH] x86: Add a new test case for ret/iret with a nullified segment
Date:   Tue, 24 Nov 2020 16:33:00 +0800
Message-Id: <1606206780-80123-1-git-send-email-bmeng.cn@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

This makes up the test case for the following QEMU patch:
http://patchwork.ozlabs.org/project/qemu-devel/patch/1605261378-77971-1-git-send-email-bmeng.cn@gmail.com/

Note the test case only fails on an unpatched QEMU with "accel=tcg".

Signed-off-by: Bin Meng <bin.meng@windriver.com>
---
Sending this as RFC since I am new to kvm-unit-tests

 x86/emulator.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index e46d97e..6100b6d 100644
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
+    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
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

