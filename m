Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A866A80CD
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjCBLNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjCBLM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:12:58 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C304460BC
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:12:34 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1481304wmb.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 03:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ygAcJKnTKCTvVciunh9HcyMwipcH5PYmlVu4YEhebA=;
        b=D+r/dhbux9bWn3bdSKFMDOmtU+M9oGCX43ZJiTWYM8hQdBEDxb7vPAHENCcra+PfhR
         AnfvEJ4nQvLE4ozP9Gei1DHQHiIE/o2sTEA9uqbJRlv0bnTrwjGqSxOCIAgV7KLksPeJ
         UX20qqolJbRP6QeitCMEwH1zbqHixH8DeLgOiMX3O9h6yeK3nBmJm4JwM3NjQ3vJLXDP
         BiYlPEMUlFdczGF716HEL/Mwj2tdCaNQtr/7Bu5RBGBLNHg1+WZzV+s1yuvcEL5T02mF
         hR2N2U/WYR98LUG0ZYGePMLz6V/9gYx7Q3cZHeyB6H07jJmf5dFwAEZ9DX0rftaQgK72
         1l9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ygAcJKnTKCTvVciunh9HcyMwipcH5PYmlVu4YEhebA=;
        b=F7GOGCymxWjsHr3m7iWvRwkhspRHbMlAkE6mJLzuAw1aQnjOUc0o8mLuSDHJtzIJRX
         DQ/RRZDpaaaYbd5W9mwDJjrSdzqGJxjV4TIpAc266CIClVOUZLb4w13EdQoLcocflf/x
         mgLJZmJ6mrAci+nRsZ94vj0tcikEAE9jkIVImDRUZ5NvdnXPxhBOOP/8CTXY346IpZWj
         1KEN4NyM2Loo5nf3eHsma4GtLR1Ul0wLc9iMQqYVn8o/FMkrLbtKeZzH9QcRSWdCrNi8
         ucppd6IeZ1+THVTTAGKU9EQedjCyoNwtT2hnbwwKnIwhmW5TZgU0R1UdfNsPfX1Oo7Ty
         PNhA==
X-Gm-Message-State: AO0yUKVlzU7DRUnZt85qqDJ0XTEi3IE8e2w97F9EaYB4mscs0iStVlZf
        8lMiNSXcoL4AW0hbiZ3QABCHkg==
X-Google-Smtp-Source: AK7set9V5L4riousWuV7maxosEQUP32dIAIlljh8CcytA6tIn+pVA9C5Ps5VFYPQEduiNmlp/522pQ==
X-Received: by 2002:a05:600c:3c9d:b0:3eb:598d:6494 with SMTP id bg29-20020a05600c3c9d00b003eb598d6494mr1197912wmb.16.1677755552821;
        Thu, 02 Mar 2023 03:12:32 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:11aa:3c13:d3e:eb29])
        by smtp.gmail.com with ESMTPSA id a5-20020a5d4565000000b002c3f81c51b6sm14724830wrc.90.2023.03.02.03.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:12:32 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
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
        Usama Arif <usama.arif@bytedance.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH v13 02/11] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Thu,  2 Mar 2023 11:12:18 +0000
Message-Id: <20230302111227.2102545-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230302111227.2102545-1-usama.arif@bytedance.com>
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
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

