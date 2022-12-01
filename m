Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23A263EDB2
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiLAK1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiLAK1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:27:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48402196
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:27:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so4778073pjc.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 02:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OxFUiqdAJq9zJUGdn0FVmVDZqtniT0uf+dPwrOJEVb0=;
        b=SvwxgkT0mlR8TU2D7UkHvI5KTopI7d3Q7kuWkdTAATevpP+IT/E2Qp1SITch/sC4Oa
         vKI+lEmfxEAA64pL/hJ4hddMKIOwdo3lmE6GWtKUt12KIdDAUUq0qj849+CuoKoOWR5i
         Lw7uGyQy6a3YpV0/QC+YHohcRN/QBhsl8MOTKChIdOLeJxSA0q0P79wTL+xYWzEF1mQq
         piDhXHsptpT26s/9IK2vKjQwcvORX8pOKYUAZRUHKe6jnCsvvjRsl4KvH+gc3bEqJvIS
         3ELNkf1kkn/QdEhidPjZahEKR51ixoVXmlQY8HYnvsVIVF+tFurwB/r0YIApmOhdXzeH
         3Y7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxFUiqdAJq9zJUGdn0FVmVDZqtniT0uf+dPwrOJEVb0=;
        b=rs/ZyK8gZxarGUgwaAZUuP2YVkWX5jOz8EaEYRglTMCjE8HmuithB1bJrwTa9KEtog
         DzXDs96I4Fe+OHsi279v4dewwAP5eApsFZNZDynK4yA8IuP+iQ2iv7EPBShIvlBL5fXY
         N21ERs9ypgXoQXgUqfRPpVeiy3xowM93Exp7/r1Z84Ra5/M0fYs6BMFFK6TUo+UtMSgW
         mT32CvC9PWaMa85kFjnwko371WXYyKVpqzcnxN71jgeOfPlduM1E7F1ZM6GrwPahBvJ9
         GBpGSsX5mHKsY17OyvJZWIFUEiwcQRWIH0o3S81epSWyuSBJbDejw0XYHS8ahSzk2LUn
         hHxw==
X-Gm-Message-State: ANoB5plo53BKLWyGPVVOnbcFjICXmOoOLti6743KYgqH28uY4IxUDNDe
        ALlEmTOihMz2QZjnFtVxgzUU+Q==
X-Google-Smtp-Source: AA0mqf51XnulmYGgXDPa5v7SpGarx6NnyJ7v5ENHAFkG1WvupdG7YBhpo9GH2WDW/G86CKU6v6tRyA==
X-Received: by 2002:a17:90a:4206:b0:213:2039:64c2 with SMTP id o6-20020a17090a420600b00213203964c2mr75959602pjg.165.1669890456205;
        Thu, 01 Dec 2022 02:27:36 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id z1-20020a1709028f8100b00188fcc4fc00sm3245052plo.79.2022.12.01.02.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:27:35 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] accel/kvm/kvm-all: Handle register access errors
Date:   Thu,  1 Dec 2022 19:27:28 +0900
Message-Id: <20221201102728.69751-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A register access error typically means something seriously wrong
happened so that anything bad can happen after that and recovery is
impossible.
Even failing one register access is catastorophic as
architecture-specific code are not written so that it torelates such
failures.

Make sure the VM stop and nothing worse happens if such an error occurs.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 accel/kvm/kvm-all.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..9e848f750e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2709,7 +2709,13 @@ bool kvm_cpu_check_are_resettable(void)
 static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     if (!cpu->vcpu_dirty) {
-        kvm_arch_get_registers(cpu);
+        int ret = kvm_arch_get_registers(cpu);
+        if (ret) {
+            error_report("Failed to get registers: %s", strerror(-ret));
+            cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
+            vm_stop(RUN_STATE_INTERNAL_ERROR);
+        }
+
         cpu->vcpu_dirty = true;
     }
 }
@@ -2723,7 +2729,13 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
 
 static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
 {
-    kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE);
+    int ret = kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE);
+    if (ret) {
+        error_report("Failed to put registers after reset: %s", strerror(-ret));
+        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
+        vm_stop(RUN_STATE_INTERNAL_ERROR);
+    }
+
     cpu->vcpu_dirty = false;
 }
 
@@ -2734,7 +2746,12 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu)
 
 static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
 {
-    kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
+    int ret = kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
+    if (ret) {
+        error_report("Failed to put registers after init: %s", strerror(-ret));
+        exit(1);
+    }
+
     cpu->vcpu_dirty = false;
 }
 
@@ -2827,7 +2844,14 @@ int kvm_cpu_exec(CPUState *cpu)
         MemTxAttrs attrs;
 
         if (cpu->vcpu_dirty) {
-            kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE);
+            ret = kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE);
+            if (ret) {
+                error_report("Failed to put registers after init: %s",
+                             strerror(-ret));
+                ret = -1;
+                break;
+            }
+
             cpu->vcpu_dirty = false;
         }
 
-- 
2.38.1

