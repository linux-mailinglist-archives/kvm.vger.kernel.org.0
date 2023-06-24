Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB42B73CC27
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjFXRmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjFXRm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:42:26 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DDD1BDB
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51d9124e1baso192751a12.2
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628544; x=1690220544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NN9VasAt75iFOv6bKm088IUAp3WHizK1u2macVzvnVk=;
        b=TpoTyF2JMLfTdhJFfQDIJVDl7wyit9krNMh5pkE5UD2Z85JsI+MhIJfZq4TxXmpXb/
         Jq5HiN89HJ4wr6rXLea/eWyd7618cAZZiB+S4t907FNYoN5Za7XtU53Yo99TffKFQ0cf
         44Xmr7D3BCBiDEaJRA6+UHWtBWBj4mZwYkdJuNkFUXvTWvqPJQ+tLi4m5dnTjJoqSct8
         IsWj6zhrwB+4NlanWGr0JPLUH/XYLaVY04sIYBZkfBiSkR23DgIuGBjyK/H2gFkyPBbE
         jt5/4gwPqUFkxozHegLbIIK30roYFKpcZHG+a2L3V4oBZU7sNJ0K7b+DJi29MWniwKkO
         nrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628544; x=1690220544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NN9VasAt75iFOv6bKm088IUAp3WHizK1u2macVzvnVk=;
        b=i6GZAlse1/hfzqWJ10z7EMcwhpTLW+vgXpywlMO8FlMqy5yY62MQGTpa3PK9Y4LW+5
         2ZWX+4k/f92vxogVXOoNyBDIGqu/kuGsKL8Y6QzRtapLH+QkRPJ0totBO5DWwbkqGN3/
         +nVHD8myCVgq0v3SrOpdSPyrxQ1dWWWeNKw8/tMRNZkeUtnTPh7q6Iv+WRQKx9tPex5c
         2iLUXXW1rwOyZGlhFTNLgeUc713e+LCQjDWjRpTdHkNRyNcbGm5UZWCfs2GuESOYQrq6
         BPjKCquWlq/GTUP/3WlNCIHVl7bUU9yob9xh1bLfDnFH3zt14q29SDihL5DmdxbBVML7
         hv/Q==
X-Gm-Message-State: AC+VfDyrNTSH7EeckWpf6qz4djFZIev/VSi1GhrbBWYABVjaduL8YAR6
        KRLO+GlAXm+8/jlNxIPqtwMOH65pYNxz9+LLEfk=
X-Google-Smtp-Source: ACHHUZ6JpBB7yANElxTtai7vYezx6pxHzspfxWNJcM+HOCv+99GHSiTFtorTZQaQzhh9nxIlf7DEgQ==
X-Received: by 2002:a17:907:5c8:b0:974:7713:293f with SMTP id wg8-20020a17090705c800b009747713293fmr22846007ejb.41.1687628544073;
        Sat, 24 Jun 2023 10:42:24 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id i10-20020a170906250a00b0096a6be0b66dsm1102885ejb.208.2023.06.24.10.42.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:42:23 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 08/16] accel: Move HAX hThread to accelerator context
Date:   Sat, 24 Jun 2023 19:41:13 +0200
Message-Id: <20230624174121.11508-9-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index a7fae8571e..8b40946afc 100644
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
index 4372ee596d..87153f40ab 100644
--- a/target/i386/hax/hax-i386.h
+++ b/target/i386/hax/hax-i386.h
@@ -27,6 +27,9 @@ typedef HANDLE hax_fd;
 extern struct hax_state hax_global;
 
 struct AccelCPUState {
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
index 9d9011cc38..18d78e5b6b 100644
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
index bf4b0ad941..4bf6cc08d2 100644
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

