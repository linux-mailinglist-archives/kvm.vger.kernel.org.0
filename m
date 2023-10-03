Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02427B6950
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjJCMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjJCMbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:31:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA33EB4
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:31:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-32157c8e4c7so913896f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336274; x=1696941074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCJq244pl4+8992N+SUfSZJnXy6q+2iGjPbprJxjpgU=;
        b=zW23qhqzX08s2zqM8IC3UiIo4DZiI8VBF7IR4Y5C3jUraRcCOx9JwrFZ4mJa2ShNpO
         dFu06Nr/PRPEeOvCAovsflillWkcqhiV21xu4K2uJdVDwd5bdyRYF1IAd388N43kN+ZS
         IZI5kCrH6TV858MtO+viJsMtv3mDllpc6HzqoFE3sRFcVv7QbnfRLzlhAt13ODvzI3Q8
         IqjCM9epWEY5/XyEofwdYLO5RRIBqzsBd6dYxbAoybTFi4DoXw/JjLQUlRWpOQ/HhPgp
         SqpJwnsw68aNzGBr2D1Ryygs1vYp7aC16Dv/bfHrF9OWiihGavnlTtBBS6iLPUHr7ZgJ
         +3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336274; x=1696941074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCJq244pl4+8992N+SUfSZJnXy6q+2iGjPbprJxjpgU=;
        b=WvqCfLSarzGXgG/GkbN2MQh9OtmkND7n7AkofZVdFU8OODbbgdamruS/qO3u47EzJ4
         jfEwYs+g5deIuzuwic+YObJgsidcFUrzmx02b3Wnr+fMHyaNChCQSR243xCQdNHQMdAt
         LzknF3ypIsQQf9BikMshARAaWyv805xeLs7W+A187wpjsQoGA9KYrQqp/zqPQJeqTfFd
         lFomT+hGej13cKYyAf5BgcGVyNshvzxI7fLxlnBP5I5I4bXAlYAUJd22BAn4SDd6EmFk
         KxwIcEnJtA2mSoh2Gs9kggCIVvVGey9z0PrGWY7PlnPEd9HiGOoPWyG55etoUu/gNZsb
         DYtQ==
X-Gm-Message-State: AOJu0Yy+qk46DDTr621KcXnHHlGyjLE7oFSMMfTzpLeLxe3r3Hz3zLpH
        Ss0rmoB9tZlEQw6Lo3bRf+MWPA==
X-Google-Smtp-Source: AGHT+IFOv9460imGFEIgqRm0UvkQ7r6CSfyL7aih3gY5LLipvr1UBoZ7dIbBHQMj6JPYXiQgRbHH4Q==
X-Received: by 2002:adf:e852:0:b0:323:2038:944 with SMTP id d18-20020adfe852000000b0032320380944mr13304917wrn.58.1696336274319;
        Tue, 03 Oct 2023 05:31:14 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id j14-20020a5d464e000000b0031f8a59dbeasm1478930wrs.62.2023.10.03.05.31.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:31:13 -0700 (PDT)
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
Subject: [PATCH v2 7/7] accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
Date:   Tue,  3 Oct 2023 14:30:25 +0200
Message-ID: <20231003123026.99229-8-philmd@linaro.org>
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

We don't need to expose these TCG-specific methods to the
whole code base. Register them as AccelClass handlers, they
will be called by the generic accel_cpu_[un]realize() methods.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Claudio Fontana <cfontana@suse.de>
---
 accel/tcg/internal.h   | 3 +++
 include/exec/cpu-all.h | 2 --
 accel/tcg/tcg-all.c    | 2 ++
 cpu.c                  | 9 ---------
 4 files changed, 5 insertions(+), 11 deletions(-)

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
index 03dfd67e9e..8ab873a5ab 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -227,6 +227,8 @@ static void tcg_accel_class_init(ObjectClass *oc, void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
+    ac->cpu_common_realize = tcg_exec_realizefn;
+    ac->cpu_common_unrealize = tcg_exec_unrealizefn;
     ac->allowed = &tcg_allowed;
     ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
 
diff --git a/cpu.c b/cpu.c
index 2a1eff948b..658d179582 100644
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
 
@@ -187,13 +182,9 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     cpu_list_remove(cpu);
     /*
      * Now that the vCPU has been removed from the RCU list, we can call
-     * tcg_exec_unrealizefn and
      * accel_cpu_common_unrealize, which may free fields using call_rcu.
      */
     accel_cpu_common_unrealize(cpu);
-    if (tcg_enabled()) {
-        tcg_exec_unrealizefn(cpu);
-    }
 }
 
 /*
-- 
2.41.0

