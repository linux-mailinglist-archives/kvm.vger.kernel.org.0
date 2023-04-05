Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0C6D7977
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbjDEKSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbjDEKSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:18:41 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C3F211F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:40 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so3732949wmb.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGm3E04zIWsYk05zgucyUicl5+3W8OYlCuN37xDTmqU=;
        b=rTu1tRZPqV4LFx/UoOZi2WLzS6khixq6d/WYxFS7eNNn/OYGeFnv0qc3Qcr02VSKxy
         rb660oY/fmNu7J89tEYsSKeFFMuIPWe0bwl6jY9zC3o3nLjl9EKCdNxVkCbBuJ6lm5CH
         gjTz1i3s9XYei/E+itmN9I/+2jlgOY1BBVZJB9fjEYyywfgateusSwusPqpu7NrWhMR0
         GMl837ggRVzo1kt3Z33apYrhv71R+7WptfZnBSbUKuQc75ogJNF4kCG2j8Ggv1YnBRCy
         yVn/ZgcJgjoRbF4Cbyz/wswjzVjQZxiYa1fX9y35/BD8s5WDn2b95Nx3tL6XSawRO0qk
         iJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGm3E04zIWsYk05zgucyUicl5+3W8OYlCuN37xDTmqU=;
        b=IEarSNIDb2U/SMUy5JNw/aBJLMSmyyMe6T9da/fyvDRIjdcZuOBtqfcMLrdcKIg2L+
         c43IuT9f8bi0YV10eYyEvUhidZ71tcWHeTpPQGCQqtJ2gcHnJSpkqf24en+JMKnqK+Rj
         IrewPtvPh9OdpqxHvxCGynKCuUTdvm8JTl4UWKz94lM8Le1C99XJO38f0Hhs2+G/4CvO
         3H43h7jbT6zi8y0lnLR+LW+54om85tNiGIlz5Q4aBEwvjjlqIEkznB/b7Bdl4cG0xIx4
         H7CsonKibJUt4wwLwkeH5zI7bfbNVzuy9MNxujIq2y3alYc8xMP+DKwhs5nrqaIs7CC3
         OULw==
X-Gm-Message-State: AAQBX9e9BuV/7UXAW4c9ENiqHcAm8KgF25eGL5lQhSmMQWyMiW8RxKTU
        tKy+09vXFO0YhuZKu0BHgkr8hA==
X-Google-Smtp-Source: AKy350ZDfAFPi7DjfgX/oekuSK5IMwY5EAU6LrxLx1bImlo8Bj5BMxd5ZdtWz6ZThOU3rdF/7XqStA==
X-Received: by 2002:a1c:770e:0:b0:3ed:8780:f27b with SMTP id t14-20020a1c770e000000b003ed8780f27bmr4338493wmi.16.1680689919738;
        Wed, 05 Apr 2023 03:18:39 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id l6-20020a1c7906000000b003ee4e99a8f6sm1696262wme.33.2023.04.05.03.18.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:39 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 04/14] accel: Destroy HAX vCPU threads once done
Date:   Wed,  5 Apr 2023 12:18:01 +0200
Message-Id: <20230405101811.76663-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
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

When the vCPU thread finished its processing, destroy
it and signal its destruction to generic vCPU management
layer.

Add a sanity check for the vCPU accelerator context.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hax/hax-accel-ops.c | 3 +++
 target/i386/hax/hax-all.c       | 1 +
 2 files changed, 4 insertions(+)

diff --git a/target/i386/hax/hax-accel-ops.c b/target/i386/hax/hax-accel-ops.c
index 18114fe34d..0157a628a3 100644
--- a/target/i386/hax/hax-accel-ops.c
+++ b/target/i386/hax/hax-accel-ops.c
@@ -53,6 +53,8 @@ static void *hax_cpu_thread_fn(void *arg)
 
         qemu_wait_io_event(cpu);
     } while (!cpu->unplug || cpu_can_run(cpu));
+    hax_vcpu_destroy(cpu);
+    cpu_thread_signal_destroyed(cpu);
     rcu_unregister_thread();
     return NULL;
 }
@@ -69,6 +71,7 @@ static void hax_start_vcpu_thread(CPUState *cpu)
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, hax_cpu_thread_fn,
                        cpu, QEMU_THREAD_JOINABLE);
+    assert(cpu->hax_vcpu);
 #ifdef _WIN32
     cpu->hThread = qemu_thread_get_handle(cpu->thread);
 #endif
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index a2321a1eff..38a4323a3c 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -209,6 +209,7 @@ int hax_vcpu_destroy(CPUState *cpu)
     CloseHandle(cpu->hThread);
 #endif
     g_free(vcpu);
+    cpu->hax_vcpu = NULL;
     return 0;
 }
 
-- 
2.38.1

