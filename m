Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141B079BEC8
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbjIKUtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbjIKO1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 10:27:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439DECF0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 07:27:34 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9a65f9147ccso572824866b.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 07:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694442452; x=1695047252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y2u6ntARkJIvNRR76qoe5f9qgwmF82Gn0r5UusWtZxI=;
        b=HXP+MMGSnBMYgaqz7ZCSpVLw9eKTGAqrhKQ0kcn2HmYxlc0e+vzGh2DR5YTBhql24/
         Pkw5DkrR1HLKoo572zn6SWlgpBEpu/EUjfPnxH6u+tLYI7pifcfRjQIBWSLHxUQIVExy
         cq8y8xP0gYTIA9SUe8FCalqsrv2cfk3x8bm7GRMqVw56V4RznCiw9E5Brnd6b8dKxcTA
         xu/CHKuo5IQLpDOY18RpX9ao+xcpwEjzAS959Tx423rrfNY/BYe+ggONyvAzHFNR/HSx
         W0rrkx7c5C85LJnCiKawppsgh5gWLW9sFhC+E0z7sIPgsNvBlzbVCwxn4f7kjeBMDM/P
         NNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694442452; x=1695047252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y2u6ntARkJIvNRR76qoe5f9qgwmF82Gn0r5UusWtZxI=;
        b=B1UquZZVz58hd8qErXeAS0uZP6+1dwxuBwet3VUZ6oESpfNapMurK1KP4fMzlSvzV9
         Rd3NJBP9svW4ErqsI3Z75MmxXAaldZkrovIllNiq0OFES9w1meiLk/AbrKtkU3iZ3i+u
         ZhQudb+c9Zjl0cR7g2A94PBf1tt9JJRTvdaUmvZaeY+af9bsybbUFzM3RvENBL3JDi/v
         zOuhiO4vShD1Hm0TfxG1eOTSuaYvmDqTIz8C88FTWURIejZbeGQcOyYxJztFW0ElGJwo
         OMaDTQIsMos9RlXIV/bCmKVRg+UDPgHLm+93wIjTgxbYPaoSLaiDYF5y0sq2jTJ77DO4
         WUjg==
X-Gm-Message-State: AOJu0Yxhl2FPMj6TAQtNfrP08DsTAr1w/rBPlJ4anHnIFNesrB7MfEq8
        pIwwF/Ezje/T0+tY2dqp7jpk/w==
X-Google-Smtp-Source: AGHT+IE6EaLC3OIVPcB4+Vjhcm6RbMF4kh3NqMBKkSHliE2tkXbVcgIzIe+A4mYSR40xCMeyuua83Q==
X-Received: by 2002:a17:906:cc12:b0:9a1:e293:9882 with SMTP id ml18-20020a170906cc1200b009a1e2939882mr8487409ejb.63.1694442452656;
        Mon, 11 Sep 2023 07:27:32 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id lx24-20020a170906af1800b0099cb349d570sm5430139ejb.185.2023.09.11.07.27.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 07:27:32 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v3] target/i386: Restrict system-specific features from user emulation
Date:   Mon, 11 Sep 2023 16:27:29 +0200
Message-ID: <20230911142729.25548-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commits 3adce820cf ("target/i386: Remove unused KVM
stubs") and ef1cf6890f ("target/i386: Allow elision of
kvm_hv_vpindex_settable()"), when building on a x86 host
configured as:

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

libqemu-x86_64-linux-user.fa is user emulation specific, so
having system emulation code called there is dubious.

'--enable-debug' disables optimizations (CFLAGS=-O0).

While at this (un)optimization level GCC eliminate the
following dead code (CPP output of mentioned build):

 static void x86_cpu_get_supported_cpuid(uint32_t func, uint32_t index,
                                         uint32_t *eax, uint32_t *ebx,
                                         uint32_t *ecx, uint32_t *edx)
 {
     if ((0)) {
         *eax = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EAX);
         *ebx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EBX);
         *ecx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_ECX);
         *edx = kvm_arch_get_supported_cpuid(kvm_state, func, index, R_EDX);
     } else if (0) {
         *eax = 0;
         *ebx = 0;
         *ecx = 0;
         *edx = 0;
     } else {
         *eax = 0;
         *ebx = 0;
         *ecx = 0;
         *edx = 0;
     }
 }

Clang does not.

Instead of trying to deal with compiler specific checks around
__OPTIMIZE__ (see commit 2140cfa51d "i386: Fix build by providing
stub kvm_arch_get_supported_cpuid()"), simply restrict code
belonging to system emulation, easing user emulation linking.

Reported-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 24ee67b42d..83914d5d1b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6163,6 +6163,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
             *edx = env->features[FEAT_7_0_EDX]; /* Feature flags */
 
+#ifndef CONFIG_USER_ONLY
             /*
              * SGX cannot be emulated in software.  If hardware does not
              * support enabling SGX and/or SGX flexible launch control,
@@ -6181,6 +6182,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                     CPUID_7_0_ECX_SGX_LC))) {
                 *ecx &= ~CPUID_7_0_ECX_SGX_LC;
             }
+#endif
         } else if (count == 1) {
             *eax = env->features[FEAT_7_1_EAX];
             *edx = env->features[FEAT_7_1_EDX];
@@ -7152,6 +7154,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
         mark_unavailable_features(cpu, w, unavailable_features, prefix);
     }
 
+#ifndef CONFIG_USER_ONLY
     if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
         kvm_enabled()) {
         KVMState *s = CPU(cpu)->kvm_state;
@@ -7179,6 +7182,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
             mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
         }
     }
+#endif
 }
 
 static void x86_cpu_hyperv_realize(X86CPU *cpu)
-- 
2.41.0

