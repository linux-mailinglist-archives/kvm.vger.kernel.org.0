Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C331679BB9F
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjIKUrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237848AbjIKNPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 09:15:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD51DE9
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 06:15:12 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so11838032a12.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 06:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694438111; x=1695042911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JTa1mjppJcFOyEO7rTUqbYp1VGc27zPh41oxE71ODV4=;
        b=erlu7mfLP33Np/HKZcr3SJqJBw8WE7nu61XsSDehv7UElObccPTk+66VdnQtPDlqDK
         0zJvF2PravA7XYoiRAyE65T06ztb+Q5QWqeOMPVZUne2ke4Q/92oaiTu241bmd4aqbSn
         s0dYIJwjQ9YfsUtaylaa+9JbEISm6Wir/M8WEFlZjfH1r6JSmVG0QbsUiE5hIYy5lnRO
         egujW+soFmUFD5BMzRFTHXrX+tPybOuoUY9WFvkyu52j1FszHxd2gD60nV1wTACWtliC
         qHD2kXbrCOiBb+nvCSLU53NegJ3YJ3zcAgwzzRgEC5UtluWKiHgMew9/8Jw51tHb4l6h
         NCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694438111; x=1695042911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTa1mjppJcFOyEO7rTUqbYp1VGc27zPh41oxE71ODV4=;
        b=dtBV8jDbajBaMaxF+veFBQQ9RX5LEjRZ1AXbljbEG8S4NpSVrgLPWcTxvruDapuMsV
         8a19SDAWkbcr+isvnI8/nxZAa74K/tvZaA/Nde0L75GY9DbujKwkFV7GE7gbgICAg8vN
         HVJRV8yNkEo9ek/SlyonhQrKRjDA6R72ozVxKB9Ncbqad/m1qeF/EPvzq23P06zWDhhb
         xjmHFOX0FBt+/NpynvU09VHNj1+SiUEACFCGLWPdqvJl/i5b6orqL0uUupIQCW9A6YyC
         MCbDSTUasc8Xz1o8/E4dTGktju4mA2MZf6kHAC50FQDo8pYnKKutGGgpAWZ+llsvyzW+
         45nQ==
X-Gm-Message-State: AOJu0Yz/hCZMXhzcDZk7qt/iPJqXQRhO4EnIsBWbu/Ar0g15+pBDi9K0
        KFQafY7DAnGhGlikzec5oFHlAw==
X-Google-Smtp-Source: AGHT+IEoyIRx087y6wclx8Jfh3GUmwcPQSFsRB22Oucd36jaRrPV+oJxu3au6m+AP8weLvwVd3b1lg==
X-Received: by 2002:a17:907:8a1c:b0:9a5:7dec:fab9 with SMTP id sc28-20020a1709078a1c00b009a57decfab9mr17789791ejc.9.1694438111054;
        Mon, 11 Sep 2023 06:15:11 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090694d000b00982be08a9besm5397044ejy.172.2023.09.11.06.15.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 06:15:10 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2] target/i386: Re-introduce few KVM stubs for Clang debug builds
Date:   Mon, 11 Sep 2023 15:15:07 +0200
Message-ID: <20230911131507.24943-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commits 3adce820cf..ef1cf6890f, When building on
a x86 host configured as:

  $ ./configure --cc=clang \
    --target-list=x86_64-linux-user,x86_64-softmmu \
    --enable-debug

we get:

  [71/71] Linking target qemu-x86_64
  FAILED: qemu-x86_64
  /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `cpu_x86_cpuid':
  cpu.c:(.text+0x1374): undefined reference to `kvm_arch_get_supported_cpuid'
  /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `x86_cpu_filter_features':
  cpu.c:(.text+0x81c2): undefined reference to `kvm_arch_get_supported_cpuid'
  /usr/bin/ld: cpu.c:(.text+0x81da): undefined reference to `kvm_arch_get_supported_cpuid'
  /usr/bin/ld: cpu.c:(.text+0x81f2): undefined reference to `kvm_arch_get_supported_cpuid'
  /usr/bin/ld: cpu.c:(.text+0x820a): undefined reference to `kvm_arch_get_supported_cpuid'
  /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o:cpu.c:(.text+0x8225): more undefined references to `kvm_arch_get_supported_cpuid' follow
  clang: error: linker command failed with exit code 1 (use -v to see invocation)
  ninja: build stopped: subcommand failed.

'--enable-debug' disables optimizations (CFLAGS=-O0).

While at this (un)optimization level GCC eliminate the
following dead code:

  if (0 && foo()) {
      ...
  }

Clang does not. This was previously documented in commit 2140cfa51d
("i386: Fix build by providing stub kvm_arch_get_supported_cpuid()").

Fix by partially reverting those commits, restoring a pair of stubs
for the unoptimized Clang builds.

Reported-by: Kevin Wolf <kwolf@redhat.com>
Suggested-by: Daniel P. Berrangé <berrange@redhat.com>
Fixes: 3adce820cf ("target/i386: Remove unused KVM stubs")
Fixes: ef1cf6890f ("target/i386: Allow elision of kvm_hv_vpindex_settable()")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm-stub.c  | 31 +++++++++++++++++++++++++++++++
 target/i386/kvm/meson.build |  2 ++
 2 files changed, 33 insertions(+)
 create mode 100644 target/i386/kvm/kvm-stub.c

diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
new file mode 100644
index 0000000000..d3d4a238ce
--- /dev/null
+++ b/target/i386/kvm/kvm-stub.c
@@ -0,0 +1,31 @@
+/*
+ * QEMU KVM x86 specific function stubs
+ *
+ * Copyright Linaro Limited 2012
+ *
+ * Author: Peter Maydell <peter.maydell@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "kvm_i386.h"
+
+#ifndef __OPTIMIZE__
+/* This function is only called inside conditionals which we
+ * rely on the compiler to optimize out when CONFIG_KVM is not
+ * defined.
+ */
+uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
+                                      uint32_t index, int reg)
+{
+    abort();
+}
+#endif
+
+bool kvm_hv_vpindex_settable(void)
+{
+    return false;
+}
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 5d9174bbb5..40fbde96ca 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -1,3 +1,5 @@
+i386_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
+
 i386_softmmu_kvm_ss = ss.source_set()
 
 i386_softmmu_kvm_ss.add(files(
-- 
2.41.0

