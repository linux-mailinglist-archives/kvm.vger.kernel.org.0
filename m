Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6973A5A8
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjFVQKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjFVQKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:10:05 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA311FDF
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f8fe9dc27aso59335725e9.3
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450191; x=1690042191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvPaiGifFa4V3EDPR8281c6klb7rmX/1fxpDcHgqe0M=;
        b=eMI0lYofss2LnSC9zIInA8Ipk7eMxXhs+QiJpeQw9NS9zkZEFQ1lVPz/mbrEgeEiXA
         Ri7nz3jKh0S6qK5bsBvFyX/ct26k8E5D8eKE417CKn6y2iGv2+rM8N9uwLCMdAKyEI7X
         MMdOjASfQZS5YzkHqhkSQtobW3/VLtYbGQcltoxMV3nPGbcAESIgwLdZybGqteLBVnBg
         a5dpQ46mz72Ed6dT4hb+hrjZXYiJyZjkSA9COUibnKtQZC0+hriXiYatbrVRlJqxvbzY
         lFDuP+sY/SBTHtbuawPlcyqRonlrtNxF9U2xibk40wo1M3U6dJPNYJfm0W1mWDJUNQxk
         k1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450191; x=1690042191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JvPaiGifFa4V3EDPR8281c6klb7rmX/1fxpDcHgqe0M=;
        b=gwQvRd2p6dPuGYLYK+U2soLJ8UVSCi0extPqiN1tOiJEm7oo3xvKbU/BMvbd1FJXDI
         y2PphXT0HHjUMX2V8buI50cwOJmPO80tOpn1huUI6Z1MuH9sS+O0ZCMcBFrUPZwMIRxv
         eArqRTXqPUZvWhvuCjZmGo6kvC+H1erd5fdjl+nAtdJM8orJE1m0IrsiSrWfG9gf+a97
         hi5lYMyI5RmDzBuQpn9bBRO0FOIsIjvgNESKaEFNT5VY7DVKhFUfLHYaSa8mxtcdDvV9
         tSWTaqTeCtCwVrSzVfvyP0hsyrGuQMoce5sB2i2Ps+k2Qfips/nJOowydmtKz8utKSaa
         R2iw==
X-Gm-Message-State: AC+VfDxfNT3rR5gdUKquWQghv2uti+MRpIsbjaB8+IpaEsFYPZZhwTg5
        P+zvXOGEOUQC40t38HkGRBE9nA==
X-Google-Smtp-Source: ACHHUZ6G9OLsvBnleSSkNlcXjvZT2geh5kw9jW1iWf49K3tUM4xM9BzXlYcfgI7DqMTT/RTvu7N/RA==
X-Received: by 2002:a7b:cb05:0:b0:3f8:f015:69c9 with SMTP id u5-20020a7bcb05000000b003f8f01569c9mr12695304wmj.11.1687450190857;
        Thu, 22 Jun 2023 09:09:50 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id 18-20020a05600c231200b003f9063fc3cbsm15728266wmo.44.2023.06.22.09.09.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:09:50 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 08/16] accel: Move HAX hThread to accelerator context
Date:   Thu, 22 Jun 2023 18:08:15 +0200
Message-Id: <20230622160823.71851-9-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hThread variable is only used by the HAX accelerator,
so move it to the accelerator specific context.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/hw/core/cpu.h           | 1 -
 target/i386/hax/hax-i386.h      | 3 +++
 target/i386/hax/hax-accel-ops.c | 2 +-
 target/i386/hax/hax-all.c       | 2 +-
 target/i386/hax/hax-windows.c   | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 7a0eb5ef32..01388d5918 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -337,7 +337,6 @@ struct CPUState {
 
     struct QemuThread *thread;
 #ifdef _WIN32
-    HANDLE hThread;
     QemuSemaphore sem;
 #endif
     int thread_id;
diff --git a/target/i386/hax/hax-i386.h b/target/i386/hax/hax-i386.h
index 341688a254..7055f5b53e 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -27,6 +27,9 @@ typedef HANDLE hax_fd;
 extern struct hax_state hax_global;
 
 typedef struct AccelCPUState {
+#ifdef _WIN32
+    HANDLE hThread;
+#endif
     hax_fd fd;
     int vcpu_id;
     struct hax_tunnel *tunnel;
diff --git a/target/i386/hax/hax-accel-ops.c b/target/i386/hax/hax-accel-ops.c
index a8512efcd5..5031096760 100644
--- a/target/i386/hax/hax-accel-ops.c
+++ b/target/i386/hax/hax-accel-ops.c
@@ -73,7 +73,7 @@ static void hax_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
     assert(cpu->accel);
 #ifdef _WIN32
-    cpu->hThread = qemu_thread_get_handle(cpu->thread);
+    cpu->accel->hThread = qemu_thread_get_handle(cpu->thread);
 #endif
 }
 
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index a55b18f353..c9ccc411e9 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -206,7 +206,7 @@ int hax_vcpu_destroy(CPUState *cpu)
     hax_close_fd(vcpu->fd);
     hax_global.vm->vcpus[vcpu->vcpu_id] = NULL;
 #ifdef _WIN32
-    CloseHandle(cpu->hThread);
+    CloseHandle(vcpu->hThread);
 #endif
     g_free(vcpu);
     cpu->accel = NULL;
diff --git a/target/i386/hax/hax-windows.c b/target/i386/hax/hax-windows.c
index 08ec93a256..b907953321 100644
--- a/target/i386/hax/hax-windows.c
+++ b/target/i386/hax/hax-windows.c
@@ -476,7 +476,7 @@ void hax_kick_vcpu_thread(CPUState *cpu)
      */
     cpu->exit_request = 1;
     if (!qemu_cpu_is_self(cpu)) {
-        if (!QueueUserAPC(dummy_apc_func, cpu->hThread, 0)) {
+        if (!QueueUserAPC(dummy_apc_func, cpu->accel->hThread, 0)) {
             fprintf(stderr, "%s: QueueUserAPC failed with error %lu\n",
                     __func__, GetLastError());
             exit(1);
-- 
2.38.1

