Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B639B6A2F31
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBZLIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBZLIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:38 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891B3D33F
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:08 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so5254840wmb.3
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=Vdmli2xdqqTFvFajej6BB3WjL5gX6kzXUQGsY/1NZ8H7n5Gnr4CKYxNsCZXbok81JA
         zVSdR0aOwQ5OQLk7wimvdRz7uv7ebiDukmGfPNpSBzLWFX+PHn/QmHr6mk1hKqEerdWo
         13DqD17obUw8AE2Iurcm2ND4c/p6rPkZiq1Up0YrBfQS3R2+xPg5Yy7U5z0PRVFsRYNN
         nUjuZu0ro9na0ZN2HWU9tQMqE3LJxIiHet33Duwdt5VhpMbN62ZoANHgob46Pj5cfDeY
         kIacdjh1vIClKSrtoSVAUejXgkyd60bxL+DGr5VJo6oE8xZ7AiYokCKxOzRbsuty8aGH
         k2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yne835l8M0Qgk6uaQXrJLgxrNefMQSePYhKpKknocM=;
        b=hdKjauEiiUQ108+VvQ2OyMBxrbC2U00wwHIcfd8Kc62XHg5MU7a04D5xQpEfeJBcFC
         DXVcj4cjYQP6LEwFIqglfh2fgk7sRcYpXlYShmB0gHrL86cMoGlxo6l31txnoomz7LSk
         /3NUYyeG5cYwhwjP9rMxwJixBRki1tEM+tio4Dr0jd35yrzJETG/TgRDBYXq36svfe1S
         P9cKhDkTS3aSfX4mHrWILcIjvCdEMDKkn4nAQQlTGiDBQSKoqBjByJuDXOG8e8oVriM5
         DsLUDnv+VUTp8HIoQiaoCHEznKPvKn1Qh9zaaSvdGkXHnwlJ3D1ac9ghtKrU2Nw8fN8v
         0owA==
X-Gm-Message-State: AO0yUKU8jD2BS3KsWzT7hiYQrmpUCS5rdGPkS3tiJczCa6zl7bXDlDP9
        MuOHR9AfctxXUqEEBeNZ3WyTrQ==
X-Google-Smtp-Source: AK7set8VA1MdA7EstdhABEExeukBObw/u6YGE6PPbmpKTdascGMc7HKvvsm7g+D8EmsS2mEdAEzrLA==
X-Received: by 2002:a05:600c:829:b0:3eb:399d:ab24 with SMTP id k41-20020a05600c082900b003eb399dab24mr1739119wmp.28.1677409686868;
        Sun, 26 Feb 2023 03:08:06 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:06 -0800 (PST)
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
Subject: [PATCH v12 02/11] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Sun, 26 Feb 2023 11:07:53 +0000
Message-Id: <20230226110802.103134-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

