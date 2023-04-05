Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068FD6D82F3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbjDEQGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjDEQF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0775278
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n9-20020a05600c4f8900b003f05f617f3cso3151266wmq.2
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6WERmjWn5FvlAk9wBZ9HpDjQNTvh7yNAmb4fbxF/bQ=;
        b=ui9pQqlkMvaDWCZp6I6ifckgckCFMdULH8djIjHBtGiKqLjSUyanx69f6iIYVMfxSY
         PDG366DUK3lbyUBNP2TISRXho9Y39mi+0yOtKEssWyJs8AW+r0iZXdfVcgRVJmp8SyvR
         jPWJ8qjkwLGf7F7Iy7M1OZPrcf0uWtn65EXI26LFqGpDfTiuMP6i+YQtxah+yEf+3N2I
         NfyrUvV8ItcveuyyyrfgYuOGCWAsChzWI0Cy5GdHPeHvnwaJTnTNUDpZ7tRMAHPsQguV
         7ankTk82Gs8dVyGeY4jCBSGFQ/hPIEZB2U94cG+S76nY5p/JXNSjjluwvo8eICuJ2rnX
         GNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6WERmjWn5FvlAk9wBZ9HpDjQNTvh7yNAmb4fbxF/bQ=;
        b=4r7U5QhDVnQSHyfhJCqmfZSTftZbUBronRLVekMLVn80rd3sttPFT73ai5BZLaCCYz
         3gQs+SXMmBOnELdMN2pDgY6f0I3SdJcR9J0t2QLXGivi3k541JNObTWwYGJC5zeWD/FI
         BpforYkbNRYdjEWCmajTlJ0dw/p2emYGvHNbJGaDYm7kq8CV0Df/kGVneZdkJ92WEGRt
         LyPPT6ztr3J0063gZxjsBhGPZUxNFfCK1Ykc8S31etViVMMoOPbPh/g0I8O6qEeePDNr
         uDEJzhgpi1kJpCVKSRYe2NY4gxz3mYFTqxAh1RnGKEYxUltR5tnrHKce8dT77ooJnjI8
         E+xw==
X-Gm-Message-State: AAQBX9dP+TXDp/vyjp0w9QfI+hokulSJDaiTg5HDf0eM69s3p1i233J8
        v6R6yPOCdSmRs5XXZdzHAL47SQ==
X-Google-Smtp-Source: AKy350anKvfZnCI3q7zDlxj99iOPWMUyn9/cm32XZyeYL/HMzbFHfQJWndVFdMqz9Z6VrABSDFBDsQ==
X-Received: by 2002:a05:600c:ace:b0:3ed:ea48:cd92 with SMTP id c14-20020a05600c0ace00b003edea48cd92mr5367145wmr.15.1680710749843;
        Wed, 05 Apr 2023 09:05:49 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id p26-20020a1c545a000000b003edf2ae2432sm2600498wmi.7.2023.04.05.09.05.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:49 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [RFC PATCH 09/10] target/riscv: Restrict KVM-specific fields from ArchCPU
Date:   Wed,  5 Apr 2023 18:04:53 +0200
Message-Id: <20230405160454.97436-10-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These fields shouldn't be accessed when KVM is not available.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
RFC: The migration part is likely invalid...

kvmtimer_needed() is defined in target/riscv/machine.c as

  static bool kvmtimer_needed(void *opaque)
  {
      return kvm_enabled();
  }

which depends on a host feature.
---
 target/riscv/cpu.h     | 2 ++
 target/riscv/machine.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 638e47c75a..82939235ab 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -377,12 +377,14 @@ struct CPUArchState {
     hwaddr kernel_addr;
     hwaddr fdt_addr;
 
+#ifdef CONFIG_KVM
     /* kvm timer */
     bool kvm_timer_dirty;
     uint64_t kvm_timer_time;
     uint64_t kvm_timer_compare;
     uint64_t kvm_timer_state;
     uint64_t kvm_timer_frequency;
+#endif /* CONFIG_KVM */
 };
 
 OBJECT_DECLARE_CPU_TYPE(RISCVCPU, RISCVCPUClass, RISCV_CPU)
diff --git a/target/riscv/machine.c b/target/riscv/machine.c
index 9c455931d8..e45d564ec3 100644
--- a/target/riscv/machine.c
+++ b/target/riscv/machine.c
@@ -201,10 +201,12 @@ static bool kvmtimer_needed(void *opaque)
 
 static int cpu_post_load(void *opaque, int version_id)
 {
+#ifdef CONFIG_KVM
     RISCVCPU *cpu = opaque;
     CPURISCVState *env = &cpu->env;
 
     env->kvm_timer_dirty = true;
+#endif
     return 0;
 }
 
@@ -215,9 +217,11 @@ static const VMStateDescription vmstate_kvmtimer = {
     .needed = kvmtimer_needed,
     .post_load = cpu_post_load,
     .fields = (VMStateField[]) {
+#ifdef CONFIG_KVM
         VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
         VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
         VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
+#endif
         VMSTATE_END_OF_LIST()
     }
 };
-- 
2.38.1

