Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946B77A26D4
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbjIOTBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbjIOTBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:01:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A162700
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9aa0495f9cfso775997866b.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804448; x=1695409248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOpx/VA/+gwdtEbnTetIr2FQsXveadRswnAsnH4GXos=;
        b=BD3S+lptWgYbVUp07tAI39aXmGHExjkVI+ULI4guCoMcX2UaJt/VcJfNLn+L/kL2MP
         1bQl/GaJ94PJuYfMHKdxw9xyA5C/5Ubxt7pmltSmvHLmgYGur6x1AZEQUOtYC0tOFoes
         4HQYFD+xCXNX6/eiPMmyLkOHasgzkditqy+BMYmQ/TvskYQOVKyNpffdNzMDqG3FiVEL
         UtmbnIclVcnvBgtl8fNMYdiKcMNVrwNL8gDprbiG5p3TeHer/qN8Ih4n8p0pg2mhGvTO
         5bpsuwiI6o6j7iOky8uNiDbKRtyFhlgpCcxh74KD2pImVLLZEQJ6KL118ZFcvP+dpeW5
         HxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804448; x=1695409248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOpx/VA/+gwdtEbnTetIr2FQsXveadRswnAsnH4GXos=;
        b=fY/U9ioprgoL+pCD6ZsPi5C+zgJ0S6e9z3lAT0tqDfCOIXvI+83pIeY+NEv25Po6Ww
         5ULzfRc/j8w67dycq2MNYnkRmrgFwxDckbweLhoZeHJGEv/nF4ItUl9prHp34azRdNEG
         H0PNgbagU/oCQ/u1kkqs09qszx+my3xTttlF+YWqAN9irK0WvcrIGb0UagRC4e3zvPRJ
         ro3i1C2bvhfkKfVU3LZp96MXzmhawx0Qc/KHuyf0vAYmrMVKtePcWf6cseruvavcV/J+
         jdmrucnogm6MTx00Af0phMzN0gM50IhkkD1/q0XABr8LRrxDeJOLongbON9Ay72LzCej
         tjDg==
X-Gm-Message-State: AOJu0YxKo9TB0U6vBuyjH4ZGBJKYrf0aXFA8eNHH70t/vwdL/kyTHvzD
        oXq2KucdD3Dbk7SSBW155C13WA==
X-Google-Smtp-Source: AGHT+IELleuQSkuMS3U2vjtSOoyli3O0jtH4oH1By3hb7PvHE0MO+UI88qPm19yIOTSyq5wf6F29XQ==
X-Received: by 2002:a17:907:3f91:b0:9a5:b247:3ab with SMTP id hr17-20020a1709073f9100b009a5b24703abmr9362665ejc.19.1694804445231;
        Fri, 15 Sep 2023 12:00:45 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id mf13-20020a170906cb8d00b0099caf5bed64sm2735321ejb.57.2023.09.15.12.00.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:44 -0700 (PDT)
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
Subject: [PATCH 5/5] accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
Date:   Fri, 15 Sep 2023 21:00:08 +0200
Message-ID: <20230915190009.68404-6-philmd@linaro.org>
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

We don't need to expose these TCG-specific methods to the
whole code base. Register them as AccelClass handlers, they
will be called by the generic accel_cpu_[un]realize() methods.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/internal.h   | 3 +++
 include/exec/cpu-all.h | 2 --
 accel/tcg/tcg-all.c    | 2 ++
 cpu.c                  | 8 --------
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/accel/tcg/internal.h b/accel/tcg/internal.h
index e8cbbde581..57ab397df1 100644
--- a/accel/tcg/internal.h
+++ b/accel/tcg/internal.h
@@ -80,6 +80,9 @@ bool tb_invalidate_phys_page_unwind(tb_page_addr_t addr, uintptr_t pc);
 void cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
                                uintptr_t host_pc);
 
+bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
+void tcg_exec_unrealizefn(CPUState *cpu);
+
 /* Return the current PC from CPU, which may be cached in TB. */
 static inline vaddr log_pc(CPUState *cpu, const TranslationBlock *tb)
 {
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 1e5c530ee1..230525ebf7 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -422,8 +422,6 @@ void dump_exec_info(GString *buf);
 
 /* accel/tcg/cpu-exec.c */
 int cpu_exec(CPUState *cpu);
-bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
-void tcg_exec_unrealizefn(CPUState *cpu);
 
 /**
  * cpu_set_cpustate_pointers(cpu)
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 03dfd67e9e..6942a9766a 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -227,6 +227,8 @@ static void tcg_accel_class_init(ObjectClass *oc, void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
+    ac->realize_cpu = tcg_exec_realizefn;
+    ac->unrealize_cpu = tcg_exec_unrealizefn;
     ac->allowed = &tcg_allowed;
     ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
 
diff --git a/cpu.c b/cpu.c
index b928bbed50..1a8e730bed 100644
--- a/cpu.c
+++ b/cpu.c
@@ -140,11 +140,6 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
         return;
     }
 
-    /* NB: errp parameter is unused currently */
-    if (tcg_enabled()) {
-        tcg_exec_realizefn(cpu, errp);
-    }
-
     /* Wait until cpu initialization complete before exposing cpu. */
     cpu_list_add(cpu);
 
@@ -190,9 +185,6 @@ void cpu_exec_unrealizefn(CPUState *cpu)
      * accel_cpu_unrealize, which may free fields using call_rcu.
      */
     accel_cpu_unrealize(cpu);
-    if (tcg_enabled()) {
-        tcg_exec_unrealizefn(cpu);
-    }
 }
 
 /*
-- 
2.41.0

