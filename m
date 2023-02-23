Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FD96A105B
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjBWTND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjBWTM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:12:57 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64532567BB
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:08 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t15so11669153wrz.7
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=V7OoY+Xkb1vzkS5nj+lYutSsnw1LLzyIz6O92ioTe4bcq67o38+hPJ+XTpkDTM3bx+
         pcuZkF8TIS5mtmNsNeKwBd/4jBIuSnQAu79D9emHf5V2xG4utkfDG478Jz9txH4BVwwH
         UovpWvDcaLRxN6Si7ssBQMsqY8iMmhB0ZlhOsaLjGFoRk/pDnp8kxjtVxEnAb3v9rMm6
         WrvS03lvV2I84wKNfON28EiIXpS5n2cwPIsjNToKGkr4cssGxeHmd7ijVPfpCYGyHATD
         u/QUatv6Xxkd0zj9CH/ixQO4vyC2tknuYhgwhKszsJWW7IaKfzW8NQA9cpIAcLA1QtuF
         9RfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=c4gPjB4DFD/LHHFJGk6Y4MdX+cwS9ZU+mSUulNVoWWlPya5wjmJUZG5Fox6+5fxHwx
         EuAZUIwAuk2Pq2jpni2BF/xBS5rIKbldcmfdLotsG+hzfyOOIJqYgI8dx0R6E0CDnjeO
         9XTXHlBbQBRnCX1OUVk0GH8C/TDixJBGpzhtTugmvIU4Aodx03z2f5to/fLo1+ve5FZq
         u2cSN9zGCnCAGi+PbrFxOy0elru0qnwTf022EU3riECIB/S0KQF8JZk/JuBFHPXmIeKf
         37pXNS8KkHgW7RDEfYvh78E2rdIRPDeHURmrZ51ZtkVBNE359hsVevFM/l3kLUmrlN6z
         ALpg==
X-Gm-Message-State: AO0yUKXAh3eyw3oq5Nwqp6xyh4ZXS7zVJCk++zQz2huMNaBeCUkhq4jY
        VLhFcVfZ3gzqE1R8Qk33Wibwiw==
X-Google-Smtp-Source: AK7set8o4OPS2IvvLyAOA9REigNbP4TvG/YxCLJGXZAiimnREB0PO0EkJTLACVjZPS1chTvD/T+MOw==
X-Received: by 2002:a5d:5309:0:b0:2c7:1b6e:5a9c with SMTP id e9-20020a5d5309000000b002c71b6e5a9cmr13124wrv.2.1677179505012;
        Thu, 23 Feb 2023 11:11:45 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:44 -0800 (PST)
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
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v11 02/12] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Thu, 23 Feb 2023 19:11:30 +0000
Message-Id: <20230223191140.4155012-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230223191140.4155012-1-usama.arif@bytedance.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
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

