Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2757A26D2
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbjIOTBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjIOTAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:00:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B560A2710
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:33 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9a9d82d73f9so301138866b.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804432; x=1695409232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDSY0XDObgkxUL7brWiUxnx3rvK0ibvXtjHunMwb0Ko=;
        b=ceKBQR1RegoWP4Ac7tjd7JjGTdW5GTQbrYzeSyO/j8Hok0f4+l6mYLWw+b4dEY7qv8
         A/wneIGMpWxXm6xAXG2uYnLLRK/7kqCHAOe081gHgDRyS+5YLfWfCIU2ev2PwyD3fa6d
         JHV+u85xs6Xg4ldaxZg+N67SeoagY4m/kvz38PLeN+dKktu0GzKPdZhG3wY6Bqjm0Lmp
         cC3cE/BqTg1rcsrL9/GzGAOcvClsepFRixyuHuR4Jqo5di80wTMcb7NuJanu8L5t+MeB
         22W4xQkBg6nxG20RIROdfgGanAQSUsExubaDpudUxWupknb6TpMiasWcqT1ZKhBsP5Oj
         s+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804432; x=1695409232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WDSY0XDObgkxUL7brWiUxnx3rvK0ibvXtjHunMwb0Ko=;
        b=ihjYNEE2pFKL8qVSiR2AWHXrcyCblchTGAKgwx+fMkpjt5N/DWFDzOqGkuhTNuS7Y4
         9Mwr7MDBpThz9Ahi53WUT46v1P73aWAwubeCv8IU0FPwlL/XSKtkFEuW2hL3EM66E4QL
         ef00r9azYb7Dmptgz2LlQ1aqxX03IVx4/YE08JIHgJhS123RJsXpHTE3rc61SbxoO2Ng
         yiax4EGPRHIfM1pZo4zBp6MlPidL7np1fc7y2qGKt8kA8s6FVUmLagUmh9HB5VL6YCF4
         XADJxrvSXxFRUySotlcmJt3UtZIlb51cIJsbTnH0VJ4hLun6VYL3zXQP+kLhHnYNowTf
         JwJA==
X-Gm-Message-State: AOJu0YxkHS738PQcU1DG1BwXGWNJe8FYFr6aGVV1uil3G67YINvQGVCE
        TwUkP8kNC102Nw/tm+K4/JbCzA==
X-Google-Smtp-Source: AGHT+IGEP/lvi8q3j5fpuCxcqNS187PK1L6ySZKuoqbnVy4D7JQSt+RyvvPIVtxvhOTk4XTqtPcS7g==
X-Received: by 2002:a17:906:76cc:b0:9a1:ddb9:654f with SMTP id q12-20020a17090676cc00b009a1ddb9654fmr1957052ejn.55.1694804432309;
        Fri, 15 Sep 2023 12:00:32 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id lg13-20020a170906f88d00b009828e26e519sm2750934ejb.122.2023.09.15.12.00.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:31 -0700 (PDT)
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
Subject: [PATCH 3/5] accel: Declare AccelClass::[un]realize_cpu() handlers
Date:   Fri, 15 Sep 2023 21:00:06 +0200
Message-ID: <20230915190009.68404-4-philmd@linaro.org>
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

Currently accel_cpu_realize() only performs target-specific
realization. Introduce the [un]realize_cpu fields in the
base AccelClass to be able to perform target-agnostic
[un]realization of vCPUs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h |  2 ++
 accel/accel-common.c | 21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 23254c6c9c..7bd9907d2a 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -43,6 +43,8 @@ typedef struct AccelClass {
     bool (*has_memory)(MachineState *ms, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 #endif
+    bool (*realize_cpu)(CPUState *cpu, Error **errp);
+    void (*unrealize_cpu)(CPUState *cpu);
 
     /* gdbstub related hooks */
     int (*gdbstub_supported_sstep_flags)(void);
diff --git a/accel/accel-common.c b/accel/accel-common.c
index cc3a45e663..6d427f2b9d 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -122,15 +122,32 @@ void accel_cpu_instance_init(CPUState *cpu)
 bool accel_cpu_realize(CPUState *cpu, Error **errp)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
 
-    if (cc->accel_cpu && cc->accel_cpu->cpu_realizefn) {
-        return cc->accel_cpu->cpu_realizefn(cpu, errp);
+    /* target specific realization */
+    if (cc->accel_cpu && cc->accel_cpu->cpu_realizefn
+        && !cc->accel_cpu->cpu_realizefn(cpu, errp)) {
+        return false;
     }
+
+    /* generic realization */
+    if (acc->realize_cpu && !acc->realize_cpu(cpu, errp)) {
+        return false;
+    }
+
     return true;
 }
 
 void accel_cpu_unrealize(CPUState *cpu)
 {
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+
+    /* generic unrealization */
+    if (acc->unrealize_cpu) {
+        acc->unrealize_cpu(cpu);
+    }
 }
 
 int accel_supported_gdbstub_sstep_flags(void)
-- 
2.41.0

