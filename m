Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7696D7971
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbjDEKSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbjDEKSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:18:32 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D564C27
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:29 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so3732604wmb.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3PbVXrARru//womsk1QFTfUC/jT1xFpRBIRhWzNLeg=;
        b=c4FFRXSdAKN2IWwtiqV7Ffzer7xJF5apMUkKlQiTaxUK2YipBsMKVqtP9PC9OjOLHc
         rMq0iWLrZJBM6oJj3ZcxNuV1npeN62fnwpOyTCL/NyjHhKWn4eE/PATJuuf/ffKK2NvR
         l5O6MKTRN5ifGk9nigJmitObdfRL5i9btUsj2E5xzt7sy+nX/kRuir/iAaexJdDqUFJg
         4racwp2lla6NgRk1CkowemsGQ25lhbtxKUZ69OG2cP31L9IIwSsFNGT7+hn7ucd+REZe
         bpReBOAvbbifyVLiPMUCDSGVvfBSE6MFot4sUTf8DSomPdPCaRK9s3qVOS+XAggbGFny
         j31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3PbVXrARru//womsk1QFTfUC/jT1xFpRBIRhWzNLeg=;
        b=oU6uILbLt+fAiUedRoWqftMaiet0A2yNlxcqDhVh/oer7eJ+/p0RGV6BG10HCY2MhJ
         JrKtF64v83Pjw83Bg/TyE88yy20WeQ6OStLj0Rizd9ZNu7lY0hb5k1I1pGFiegaWJD76
         5cSkaCFtvaiRqUiArv9+xjG0xulvvJGEb3b6S1jLwCAwwxziT/t/A7pmoxobJz1vsYuM
         owkvUDMGBUIFxfKcTDzyUFCiHLh9thVna9XykyGvpRYAn3pjHk6K8Hb/gOCfEbns/T1M
         a6H2a7vrTVbDikTI6/PdRXbVl6lDjUoZFpLCVmmACH3RsSwWZb+FJmPqGjgDz3xVjcGP
         c+yQ==
X-Gm-Message-State: AAQBX9dy9gaDKPWumJtGErvVwOifIuGvKknxdh3PTNxsaClZWUoXNTeB
        uJlgC3humTIEnnpEyZ0JLHVcfQ==
X-Google-Smtp-Source: AKy350brt1TNZ7pG57+pZfUAcAl5eE1plZdTvYqjEnxz0kMrxGEeLijqmQ0ROub7VB7ZqCDrKQfQFA==
X-Received: by 2002:a05:600c:2942:b0:3ee:4ee:bf73 with SMTP id n2-20020a05600c294200b003ee04eebf73mr4220330wmd.24.1680689907651;
        Wed, 05 Apr 2023 03:18:27 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id ay8-20020a05600c1e0800b003edddae1068sm1744815wmb.9.2023.04.05.03.18.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:27 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH 02/14] accel: Remove unused hThread variable on TCG/WHPX
Date:   Wed,  5 Apr 2023 12:17:59 +0200
Message-Id: <20230405101811.76663-3-philmd@linaro.org>
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

On Windows hosts, cpu->hThread is assigned but never accessed:
remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/tcg-accel-ops-mttcg.c   | 4 ----
 accel/tcg/tcg-accel-ops-rr.c      | 3 ---
 target/i386/whpx/whpx-accel-ops.c | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index d50239e0e2..19cfb26c02 100644
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
index 290833a37f..dafff71530 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -291,9 +291,6 @@ void rr_start_vcpu_thread(CPUState *cpu)
 
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

