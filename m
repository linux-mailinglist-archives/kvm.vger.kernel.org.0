Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DF84182E1
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbhIYOx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Sep 2021 10:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbhIYOxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Sep 2021 10:53:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE705C061570
        for <kvm@vger.kernel.org>; Sat, 25 Sep 2021 07:51:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i23so36566335wrb.2
        for <kvm@vger.kernel.org>; Sat, 25 Sep 2021 07:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D1NIBiKsJLet/LtgtEl9N8uYnLoHyxQP991kqXpIcyw=;
        b=YOw2pv9ebkj+SD6dyN66r1sz5ImWnhuE1/NU5zJ+fIQcn+D4ncRESVjKU58DS+dE9G
         UJAdGB+y1u1H7jg+2+BcMVUMovD1pwb/9xNI8oHPh4cnl1fJPGMoluC63jOLulGNIHzx
         Vgl/Ok6wivXRNjSWDIrJfQV+/UUS1WrTz0NVni3AYqZj8Qkxd1729D6ihq+OO/SP5Xrn
         k1ekZ8Kh4vaKb2IGL4F9TduJeD6bHWCC6atssDqBIDbJZ3sfA3YaWSO+Glb5LGVUNRDg
         dt2Nb6l4U0v1o4A4lFERu7AV0sYz9AYrtJ1vf3YskPLWVcMAJ0q+I1akov2isqhIxo+5
         pZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=D1NIBiKsJLet/LtgtEl9N8uYnLoHyxQP991kqXpIcyw=;
        b=W3/SCOotxYkfMQDsr7sV1/a62fIyV/RYo0ECGU5i36uzfyFS3qpbYJzObIsK6esFvu
         azeG9tBa2S7RFCgFhmGFFqA8TajsLFL1vHZ6sMBPbPIUIpXhWsRYg+MSmmGlNzQW1zAz
         jQquWfptsof51q9h34Gj31JaPwdUpAdodtDw2r/OKKMBKSR3CqbUBtOEi2NCQtP+UFCq
         qQ9j8icbYSoCZTs4rL+LJdOSkWHSEfgNw1PT4QO6bUfKT8jR7d6pNVmVetzdeQWdx6wZ
         d4MK+xn6iML643MW4md/aH1lQi4T3E6oBpfg/N6K/ZbWviWcG/gesUZz8OLB/xrQ7bW9
         IMbA==
X-Gm-Message-State: AOAM53235NKSM2Dqqzi02loU3Rtu9YDpf2Uc6pyzKMD6P4FV0Lkik7+q
        jc3MR97ZR8kUSZKZRQ6219A=
X-Google-Smtp-Source: ABdhPJwPXRuJQaR6gpTRqV/YE5q1tGhHLUEN8yWUd/qyt7m3JhVHHlWnvVf5F5l/T3Ktxkn3CgFDrA==
X-Received: by 2002:a05:600c:2e46:: with SMTP id q6mr7286713wmf.182.1632581508227;
        Sat, 25 Sep 2021 07:51:48 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id m4sm13326459wrx.81.2021.09.25.07.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 07:51:47 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH v7 06/40] accel/kvm: Implement AccelOpsClass::has_work()
Date:   Sat, 25 Sep 2021 16:50:44 +0200
Message-Id: <20210925145118.1361230-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925145118.1361230-1-f4bug@amsat.org>
References: <20210925145118.1361230-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM has_work() handler in AccelOpsClass and
remove it from cpu_thread_is_idle() since cpu_has_work()
is already called.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/kvm/kvm-accel-ops.c | 6 ++++++
 softmmu/cpus.c            | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 7516c67a3f5..6f4d5df3a0d 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -74,6 +74,11 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
 }
 
+static bool kvm_cpu_has_work(CPUState *cpu)
+{
+    return kvm_halt_in_kernel();
+}
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -83,6 +88,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->has_work = kvm_cpu_has_work;
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 85b06d3e685..c9f54a09989 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -90,7 +90,7 @@ bool cpu_thread_is_idle(CPUState *cpu)
         return true;
     }
     if (!cpu->halted || cpu_has_work(cpu) ||
-        kvm_halt_in_kernel() || whpx_apic_in_platform()) {
+        whpx_apic_in_platform()) {
         return false;
     }
     return true;
-- 
2.31.1

