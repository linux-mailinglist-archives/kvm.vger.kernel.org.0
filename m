Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBA273A59C
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjFVQJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjFVQJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:09:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550A31BE7
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3fa798cf201so1557985e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450160; x=1690042160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGm3E04zIWsYk05zgucyUicl5+3W8OYlCuN37xDTmqU=;
        b=oSZmsX3T/bloo+326SGPd5ZsHm46v9IjsSm+mX6+GHNqWc46SWntkTlBPS90redCNR
         ZUMjqxtJd3cZHvi9zSxHB4xdh1n7b8jsItx4rFl+mHiH+OgAFoaK+J/yb1D8i8vh1g6X
         Wh9p6+BtcM6BS/8tmV15GdIAi11Ly82V4oPU2YaNVUAxQtA0pzh18AGcDLF12Jbmstq5
         FC0EyBMowodStWUPlID3y0Fm2oMAF3cehAD/OcX6fjRY42O0eaZ1AhKvLl08mXhP6Qb/
         KU5JoMrq5Jkcz4ttchABNISgzL5QJIvTO362BtWKxVuE531Y/t0qEaegExQ9L9kbFuzp
         Gf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450160; x=1690042160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGm3E04zIWsYk05zgucyUicl5+3W8OYlCuN37xDTmqU=;
        b=bLXlyifWNT1DEvXajiNAC0Dw7oBPuumQEPUElIdJVKXchwV2VPdxXuDWqWr9mRXC7+
         vJOg7fyXTbSh1C99YZ8mT4c9wgoY/q7sQIyaKCgGlqU8ld3C1G94GbYHQNZu6lz1Ax4o
         VLMK522tqcTMKCMA8YwT9v1zXZH2nqkXdJqqPrF3SgyYCWEIac2zqUmBPpUm0F8DjLpH
         K4tfv776RlYHeCWYQfPu9flVMyJUOiSn2//3NYyWRySjuxpolAwpuqHHrBSA4uhn9jyw
         vz+vDoEKYjA9ToFtZEGsVH1barasI7xmV65bMyxIVgsL2MaFM1iJDDqBY6sWw8EO0X48
         oNxw==
X-Gm-Message-State: AC+VfDxeoA32aQnV1i1UcruG5qfRD4ko9FQ4g323Aoqfihd1nVGbZ0pq
        JXQXOrgycCHVPFoovzuCUm+Ibg==
X-Google-Smtp-Source: ACHHUZ74qZrgBDYUQFFsXIVlBQ+o5CwN3jxcBXCwUZJbgQTonuPJrTO0oSESuEoeaErY25ll4f9Zaw==
X-Received: by 2002:a05:600c:2650:b0:3f8:1f52:f3a9 with SMTP id 16-20020a05600c265000b003f81f52f3a9mr13773747wmy.23.1687450160763;
        Thu, 22 Jun 2023 09:09:20 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id x16-20020a05600c21d000b003f90b58df65sm13346472wmj.29.2023.06.22.09.09.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:09:20 -0700 (PDT)
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
Subject: [PATCH v2 05/16] accel: Destroy HAX vCPU threads once done
Date:   Thu, 22 Jun 2023 18:08:12 +0200
Message-Id: <20230622160823.71851-6-philmd@linaro.org>
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

