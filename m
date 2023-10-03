Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889FF7B68FE
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjJCMam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjJCMak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:30:40 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6150691
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:30:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-405361bba99so8312855e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336236; x=1696941036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqFGd5F05ZVpX+rAUXHuXXrGJSE30XMuMRRy/YP47Yw=;
        b=kvOZ0xXl8+JgavYiTqtKa6z0sluVA82jIlAHyZd9UzISjLtOgOsgzOPRxidlECdJfl
         ArL4pcaIH4cF3RPUCY7DdxqZ4UFi/Nu/7g1QYwRBqmz+ZoKae+ljJjVxuTuKwfEGoY2I
         1Ao87d945CgxBlI6TtwhqypZFR7xeNKKSMKERcn4/l77F+VHuUOOMbIG6izq62iH3cEo
         tSsIBPIYtcg0XiiRKPjz9dq/JVC8J2DsFWKAYhowMyJupdgNs12Is8eMO5ah26ZYMLWl
         cLhMdJwHMTxbFzDDh9apMD3Exju/VIWMJPH1v8Tp6mF7xUPYtf9+lNi2qaNVa/5yvmTF
         lwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336236; x=1696941036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqFGd5F05ZVpX+rAUXHuXXrGJSE30XMuMRRy/YP47Yw=;
        b=J7sgdp3PehkHtWtMWSyjxRs2IgZpCgrVqiIkzrEjx5mT8GjLhw7ib/PU0XOlb84l24
         cZ0+EY6r9/w67iwlMvVdqX5dF6OWuEg3KFs07j8bgWAktMlkkfwwLOk8rdMcrcgfGjO2
         q3zm9DnZMNdObIrLalePozuHm585Yqs+kpCJQTmG/aFdmdsaaTHyUUkeFIwODjeCWlCS
         08EaKRLx8jw0LBID6gaLG3LOq44ImEfopJNng+ihXmVurJ5T0jLAejOH8n0z1Y98cItB
         iPl8CP2L1aSjauFgmq0EPpt9aq8NhgmI4WBSamjt8FkaIzv20m4olqytJVzQIgpnTeBJ
         jZBA==
X-Gm-Message-State: AOJu0YzEHOerQ8sk2ThS6bNcE8uFcdpozTMhdLB8NTArMPdBmkjOchUy
        yRd6rza84y6kxqwBOZLQso3CPA==
X-Google-Smtp-Source: AGHT+IHlCemvbL7m1K7IS5TqiHcr5lgRDPenb1BNclDOxWgfEhUSel/BooBOcvOiYSYcDzQ5Hhk7WQ==
X-Received: by 2002:a05:600c:210a:b0:3fe:e7b2:c97f with SMTP id u10-20020a05600c210a00b003fee7b2c97fmr12100982wml.36.1696336235719;
        Tue, 03 Oct 2023 05:30:35 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id k2-20020a05600c1c8200b004065d72ab19sm9405951wms.0.2023.10.03.05.30.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:30:35 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 1/7] accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
Date:   Tue,  3 Oct 2023 14:30:19 +0200
Message-ID: <20231003123026.99229-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003123026.99229-1-philmd@linaro.org>
References: <20231003123026.99229-1-philmd@linaro.org>
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
Reviewed-by: Claudio Fontana <cfontana@suse.de>
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

