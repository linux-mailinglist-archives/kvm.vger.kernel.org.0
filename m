Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3729D73CC1C
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjFXRlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjFXRlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:41:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AE51BF7
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fa8692a006so6178275e9.3
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628507; x=1690220507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iG1kgLZ5QV1q9fprOekDS1vi4YDLS9XqOgasp153yeA=;
        b=K86GwMMvk4Df7udKOIOJ1vd/414tWjcj7PaRdAJ3QyILeXtNH5ZrXuja1IMnbHcdr6
         Y3ebUsAdLPajHQlE39ljJ0fh/t/JOBvYNV3b1NEe+LE9+APH19Ejl4JAt+dbQAuXBfQG
         APP2deEp7Mz2AHGIykGQohAv+jMZxXlGcUZUUP5eB4eZ+/bp2zpXSpG45gUaftUbbM4h
         5VXKPOKiAkaTH9X4aafmA+F7qu6COUvyHTBWEy2hotlnbHYRw86edbr2sm8Jd6RGhxKg
         UTQS4TDFLjCbZez6jFysEJYiEbh83uGUurvLwpjCbf3TGV5woFHYcA+a7TFnE+XwwpJc
         rP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628507; x=1690220507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iG1kgLZ5QV1q9fprOekDS1vi4YDLS9XqOgasp153yeA=;
        b=EN1hzNw9NBDtXCbulN24nbyyFGIQ3HyOj28yDwEzjsZWpoRqlxiC5RI1/Z7rvscmb4
         jezaOFBso2fksYJ4FYBXyGxTQr33rClPsupsA3q7nlzi98koJTEYY8KjECRCP4htF/KH
         JpiBabEhhIdBD2iiHw6Z1drKxSM/OGfIovRgMHntnvqP7/Pfn/2bCSn8iw41Z8hvI5PZ
         mXQLDDj9Xk7mc3ewtCrRJ6p5+QXsSisOalgtMra5iaBCc0qQBnjyxprpzNTHjRX43bBx
         5aIWOk8C0yqzhzSMNFAOtyK+MMU49So5R+7mz9te7q605UMRR893AL4s004QOQwiL9JR
         VsxA==
X-Gm-Message-State: AC+VfDx/31hyircgDqUsGh6lLgvWyK8MmjXf7vEfDtc6KV+rFWcN0aan
        fK+9rOfIhYHmY4VAwYfneoQ8rA==
X-Google-Smtp-Source: ACHHUZ7OfepQue0fzzv7ARVu6MjpgeQ79vp0jBcJMaT0gk3oCOgSw7w1smkAWzCkTRk8bysAFxnFSg==
X-Received: by 2002:a1c:7419:0:b0:3f9:b79d:a5fa with SMTP id p25-20020a1c7419000000b003f9b79da5famr10746278wmc.16.1687628507031;
        Sat, 24 Jun 2023 10:41:47 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f9b0f640b1sm2712454wmc.22.2023.06.24.10.41.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:41:46 -0700 (PDT)
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
Subject: [PATCH v3 03/16] accel: Remove unused hThread variable on TCG/WHPX
Date:   Sat, 24 Jun 2023 19:41:08 +0200
Message-Id: <20230624174121.11508-4-philmd@linaro.org>
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

On Windows hosts, cpu->hThread is assigned but never accessed:
remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops-mttcg.c   | 4 ----
 accel/tcg/tcg-accel-ops-rr.c      | 3 ---
 target/i386/whpx/whpx-accel-ops.c | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index b320ff0037..b276262007 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -152,8 +152,4 @@ void mttcg_start_vcpu_thread(CPUState *cpu)
 
     qemu_thread_create(cpu->thread, thread_name, mttcg_cpu_thread_fn,
                        cpu, QEMU_THREAD_JOINABLE);
-
-#ifdef _WIN32
-    cpu->hThread = qemu_thread_get_handle(cpu->thread);
-#endif
 }
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 23e4d0f452..2d523289a8 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -329,9 +329,6 @@ void rr_start_vcpu_thread(CPUState *cpu)
 
         single_tcg_halt_cond = cpu->halt_cond;
         single_tcg_cpu_thread = cpu->thread;
-#ifdef _WIN32
-        cpu->hThread = qemu_thread_get_handle(cpu->thread);
-#endif
     } else {
         /* we share the thread */
         cpu->thread = single_tcg_cpu_thread;
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index e8dc4b3a47..67cad86720 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -71,9 +71,6 @@ static void whpx_start_vcpu_thread(CPUState *cpu)
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, whpx_cpu_thread_fn,
                        cpu, QEMU_THREAD_JOINABLE);
-#ifdef _WIN32
-    cpu->hThread = qemu_thread_get_handle(cpu->thread);
-#endif
 }
 
 static void whpx_kick_vcpu_thread(CPUState *cpu)
-- 
2.38.1

