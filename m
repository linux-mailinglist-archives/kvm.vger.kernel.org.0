Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01327A26CB
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbjIOTAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbjIOTA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:00:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AB268E
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:20 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-530a6cbbb47so664900a12.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804418; x=1695409218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/oPseRALW5l8mhzSg1GPJ0x0BU257Ov4LZVxdjT9FU=;
        b=GQoMpZdbrQ9ILKHGhmkCr/PjB/aoiNBE91zBd7cohwo9lgApLCXh0Rx1ALeF7hD9jK
         HJnYFXU7DNtY9nnDz1hCT1CxmJCEYUWFcuzrJt9JaVMeEVoNlmGlXd1YJC3Y3k0jRCi3
         MHF6Kat2lVy8Z7AxG8X9eH8idix70IPMRxOiCx8+6NpgroyuITH36rThhDaocPf2aMos
         1h7P3wK5Nqa0HIEROvnu3v0qLzSghGuFsn46pjXaJEGPp7hSaAU1Rbl4dGDGDSsinyvC
         rHSkLzx/B1Ujw8pEmQK/k8ntzotTdZlslKP2UpAFQsmmarvMFvjaYAD0kWkNpTXQGvrg
         hgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804418; x=1695409218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/oPseRALW5l8mhzSg1GPJ0x0BU257Ov4LZVxdjT9FU=;
        b=OKNWTObI+vlZTEvF9UsT7uOOZc7KXKFCrXFG3G9iGEbuEhYaLtxhczRShAFzowQbK5
         GgGxFEnmffE9DTsTVFu9yGkaKojPLJx8/CvWkG3lWXwIA2UJZTUVEmJbHaj9Qze3L7jD
         p9LdNV/YxPmlLL0+4CE9+ZeRNJpwiVDVlouGUpZwHwOevlSmcw1ePYsHOBMA5HVqf5fd
         dJExpcia8fHdvnIbRcOJUL+bW7hFGYnUMq7GlwMV7/GXJkbxhVbbmkDk9U/FBUozzmoj
         r+womnZWvN8D33U/N0QADpMqANy2zqVv5qnQQoPJ9wxIujntTBv2O8bsEsCpLzSm+pWY
         pH/Q==
X-Gm-Message-State: AOJu0YxMdiHkwL4RC7NdLuvsVYMjQefUVwIcytp66hP3cyUd7lYjTpkk
        0IXp37Q4zlJVpudhWB0xR8Z94w==
X-Google-Smtp-Source: AGHT+IEbQAuDRA4Cf7TJdz/ag9Jfi6f6vhHvUllHoGBImu9i64hdmiTexC51Mb0Aga2sWMgRs5JN6w==
X-Received: by 2002:aa7:caca:0:b0:523:387d:f5f1 with SMTP id l10-20020aa7caca000000b00523387df5f1mr2283637edt.24.1694804418561;
        Fri, 15 Sep 2023 12:00:18 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id i8-20020a0564020f0800b005309eb7544fsm890148eda.45.2023.09.15.12.00.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:18 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH 1/5] accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
Date:   Fri, 15 Sep 2023 21:00:04 +0200
Message-ID: <20230915190009.68404-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915190009.68404-1-philmd@linaro.org>
References: <20230915190009.68404-1-philmd@linaro.org>
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

We use the '*fn' suffix for handlers, this is a public method.
Drop the suffix.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h      | 4 ++--
 accel/accel-common.c      | 2 +-
 cpu.c                     | 2 +-
 target/i386/kvm/kvm-cpu.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index e84db2e3e5..cb64a07b84 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -90,11 +90,11 @@ void accel_setup_post(MachineState *ms);
 void accel_cpu_instance_init(CPUState *cpu);
 
 /**
- * accel_cpu_realizefn:
+ * accel_cpu_realize:
  * @cpu: The CPU that needs to call accel-specific cpu realization.
  * @errp: currently unused.
  */
-bool accel_cpu_realizefn(CPUState *cpu, Error **errp);
+bool accel_cpu_realize(CPUState *cpu, Error **errp);
 
 /**
  * accel_supported_gdbstub_sstep_flags:
diff --git a/accel/accel-common.c b/accel/accel-common.c
index df72cc989a..b953855e8b 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -119,7 +119,7 @@ void accel_cpu_instance_init(CPUState *cpu)
     }
 }
 
-bool accel_cpu_realizefn(CPUState *cpu, Error **errp)
+bool accel_cpu_realize(CPUState *cpu, Error **errp)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
 
diff --git a/cpu.c b/cpu.c
index 0769b0b153..61c9760e62 100644
--- a/cpu.c
+++ b/cpu.c
@@ -136,7 +136,7 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
     /* cache the cpu class for the hotpath */
     cpu->cc = CPU_GET_CLASS(cpu);
 
-    if (!accel_cpu_realizefn(cpu, errp)) {
+    if (!accel_cpu_realize(cpu, errp)) {
         return;
     }
 
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 7237378a7d..4474689f81 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -35,7 +35,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      * x86_cpu_realize():
      *  -> x86_cpu_expand_features()
      *  -> cpu_exec_realizefn():
-     *            -> accel_cpu_realizefn()
+     *            -> accel_cpu_realize()
      *               kvm_cpu_realizefn() -> host_cpu_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
-- 
2.41.0

