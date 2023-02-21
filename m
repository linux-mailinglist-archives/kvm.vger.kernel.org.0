Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5369169EA3F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 23:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjBUWgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 17:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjBUWgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 17:36:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B9B32CFD
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 14:35:47 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c12so6002106wrw.1
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 14:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=X20kH30gjx7jjeCYiS6bQkNDwSInIurUWisx/6toeIFXG/YzuOPt0mhulplticXJJe
         USL1tmF05q+lyIutCdciaox5IYlKFbhv0HkvZ0KGkyUVo65y3mqW0WE8WVOV4ETYnps9
         rdNUF4poSBGHofVV448YYuN0dPIC/EAiuXaUizBF+XTt1quvq/JXxnEAT5X3UdRYUIW5
         Hx4Whh9fhnXuN0n4nICZgcnNa/s9vNuS+/7Yl5YZBeHuDoyN5NqdLcpyLQhNlsxppRA8
         KIU35W3+PcULhhqvwtYaMq9NUHxUp4bWhdVUWk8Kpd4akXD9w3T4Ucb/NVDanuEwuE4O
         h3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=NqulfFPFgsHOzXxkM5A6sv3WDgdktujccJGhzg9iIrxjzigtMy/yZ5YvPBCMjm3mFO
         tIOodVrnmGRTBCw/ZabVn5XhZqu4941Kbdp0pHxhz8LsQ9dEcuVVcS7jGWNmJO+rBs/L
         jWvo656koI1f0t0AcmNJkIiob1H10OY6ok0MuX6jO6ONo/WHJokgxqtHApD/AKSBDzBW
         30/AcIEev48WIFvatjOIOg06socPkXWvrfOnsGT3VvnkLILtW656WmhvitSTKfzSEni5
         /PEIpy0UuJnhozTy994Nvt70POYcDRhmOlxC8tzGzgMT07zCxkEOZRyt/LSEo3XbKtHe
         wvTA==
X-Gm-Message-State: AO0yUKWrJwImGDbTxGQIc7X9ZM6nlghmYGDSRLUEju66HRe5kjaSJcgK
        GVfawwFxktRpsIVTKXoendxpCA==
X-Google-Smtp-Source: AK7set9BaJSHF4wIZLirsz+n00bJjuNDQJsJpTXAXXS/VfEmdH4eDKM9ZBFAU4uVU26IupmNku7quQ==
X-Received: by 2002:a5d:6ad0:0:b0:2bf:1ec:a068 with SMTP id u16-20020a5d6ad0000000b002bf01eca068mr6457170wrw.53.1677018945757;
        Tue, 21 Feb 2023 14:35:45 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d434d000000b002c55ec7f661sm4501254wrr.5.2023.02.21.14.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 14:35:45 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v10 2/8] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Tue, 21 Feb 2023 22:33:46 +0000
Message-Id: <20230221223352.2288528-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230221223352.2288528-1-usama.arif@bytedance.com>
References: <20230221223352.2288528-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Instead of relying purely on the special-case wrapper in bringup_cpu()
to pass the idle thread to __cpu_up(), expose idle_thread_get() so that
the architecture code can obtain it directly when necessary.

This will be useful when the existing __cpu_up() is split into multiple
phases, only *one* of which will actually need the idle thread.

If the architecture code is to register its new pre-bringup states with
the cpuhp core, having a special-case wrapper to pass extra arguments is
non-trivial and it's easier just to let the arch register its function
pointer to be invoked with the standard API.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 include/linux/smpboot.h | 7 +++++++
 kernel/smpboot.h        | 2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 9d1bc65d226c..3862addcaa34 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -5,6 +5,13 @@
 #include <linux/types.h>
 
 struct task_struct;
+
+#ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
+struct task_struct *idle_thread_get(unsigned int cpu);
+#else
+static inline struct task_struct *idle_thread_get(unsigned int cpu) { return NULL; }
+#endif
+
 /* Cookie handed to the thread_fn*/
 struct smpboot_thread_data;
 
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index 34dd3d7ba40b..60c609318ad6 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
@@ -5,11 +5,9 @@
 struct task_struct;
 
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
-struct task_struct *idle_thread_get(unsigned int cpu);
 void idle_thread_set_boot_cpu(void);
 void idle_threads_init(void);
 #else
-static inline struct task_struct *idle_thread_get(unsigned int cpu) { return NULL; }
 static inline void idle_thread_set_boot_cpu(void) { }
 static inline void idle_threads_init(void) { }
 #endif
-- 
2.25.1

