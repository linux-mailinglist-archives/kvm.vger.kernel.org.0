Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB279B36D
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbjIKUuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbjIKKin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 06:38:43 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40AFCDC
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 03:38:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-99357737980so531528266b.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 03:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694428716; x=1695033516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YnEbICE5DmlevtBmaZnl3yDN8nVPjB9EnaMUokRPLHQ=;
        b=qdf50Dc/6CjVPzkKcgFIF5Zb1t5AJrrd3bAvDoWHjejK+3s7OLIqGzDWjlPOef6Rmg
         8jrXtDQMRNqKLs4Z6SdgDUO8c0TuwnLdjTQcedpoVIfbThNYYO9URGdxlWkaMFjhih2F
         f0QzFM7CsHWnKSYrn6TDd0ZFmMWE5rO3QDS/v1bTXJNW7UqbT10JJvBjoU9ZGDd3itLu
         PIGn8NTHjBXCwzBVs+ZNCpt9pL6ovXHTTJaN7gQVA9f/mTKwQ3g433Dj96H7XnxqP4W1
         m61hpltDeWtDHDNCGYzTCSHc0p6Pg5TLcO3ya4cgn4hnR+M4gTVqp/0U5tkyreGSU19j
         mBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428716; x=1695033516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YnEbICE5DmlevtBmaZnl3yDN8nVPjB9EnaMUokRPLHQ=;
        b=T/ftBMovl7blFQrUW/FMABfbi57l+Yt1nWDPEbtiOE7witaMmkyaWxEZBk8uSPTBZk
         WkSo6MRcrZ2oAjrZ6RsKfOfLC/u8cwp3T/z9j58ZXOB8Q54EJ6HINJEcDwO3tF4PEMUP
         MmN8cjEAMRXI212elGHYSkboe9WTps0EoM9uTe0nKRzeq1gsA11wu+93hNA5X3sB7+tG
         bcImkPCPLaDko1ePMVnhElzDGqpTit3EMgFP6F+muavZNhJRLARdOtcyB3cSJ7ASy9I7
         i9zgJuKcaq7a2vuVM1wxQT2zy/a4mqc1KSIbgtgQspeFT/ncxYoYZt7KGHFl7mQ/+ejF
         btrQ==
X-Gm-Message-State: AOJu0Yx4rsrkj8QnnOVESXA9HgrBKkYwbvpkGFmiDXfsfgA7cBiKvVqY
        0IfnTk4ner2NmBO9nBVjYtUJNQ==
X-Google-Smtp-Source: AGHT+IFjSvvB4G2eEZrSoIPby5ddCxAZgZdv/MfbxJTkw/wssjUUY8LR5XwpUXmGWATZtHgRAEhtsg==
X-Received: by 2002:a17:906:8251:b0:99b:d580:546c with SMTP id f17-20020a170906825100b0099bd580546cmr7687810ejx.23.1694428716135;
        Mon, 11 Sep 2023 03:38:36 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id y22-20020a170906449600b0099bc8db97bcsm5125112ejo.131.2023.09.11.03.38.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 03:38:35 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH] target/i386: Re-introduce few KVM stubs for Clang debug builds
Date:   Mon, 11 Sep 2023 12:38:32 +0200
Message-ID: <20230911103832.23596-1-philmd@linaro.org>
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

Clang does not. Therefore restore a pair of stubs for
unoptimized Clang builds.

Reported-by: Kevin Wolf <kwolf@redhat.com>
Fixes: 3adce820cf ("target/i386: Remove unused KVM stubs")
Fixes: ef1cf6890f ("target/i386: Allow elision of kvm_hv_vpindex_settable()")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm_i386.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 55d4e68c34..0b62ac628f 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -32,7 +32,6 @@
 
 bool kvm_has_smm(void);
 bool kvm_enable_x2apic(void);
-bool kvm_hv_vpindex_settable(void);
 bool kvm_has_pit_state2(void);
 
 bool kvm_enable_sgx_provisioning(KVMState *s);
@@ -41,8 +40,6 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
-uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
-                                      uint32_t index, int reg);
 uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 
 void kvm_set_max_apic_id(uint32_t max_apic_id);
@@ -60,6 +57,10 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
 bool kvm_has_waitpkg(void);
+bool kvm_hv_vpindex_settable(void);
+
+uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
+                                      uint32_t index, int reg);
 
 uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 void kvm_update_msi_routes_all(void *private, bool global,
@@ -76,6 +77,20 @@ typedef struct kvm_msr_handlers {
 bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                     QEMUWRMSRHandler *wrmsr);
 
+#elif defined(__clang__) && !defined(__OPTIMIZE__)
+
+static inline bool kvm_hv_vpindex_settable(void)
+{
+    g_assert_not_reached();
+}
+
+static inline uint32_t kvm_arch_get_supported_cpuid(KVMState *env,
+                                                    uint32_t function,
+                                                    uint32_t index, int reg)
+{
+    g_assert_not_reached();
+}
+
 #endif /* CONFIG_KVM */
 
 void kvm_pc_setup_irq_routing(bool pci_enabled);
-- 
2.41.0

