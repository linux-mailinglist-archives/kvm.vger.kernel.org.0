Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB2686FFD
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjBAUpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjBAUpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:45:21 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7F3783E7
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:44:50 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t7so10140611wrp.5
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVGzQu3A2f4Qgo78q6jxGuOz9gIN1MMwXavNYjSHKBU=;
        b=1pmygf+5X1mOOTRudl4VcLIfZwAStujjk3QFGa6j7KBal48TQf/affncmOD3//kkMI
         rcmGFccJCavXlkXytWAbcm6emsOHDwsjt6vCZUF43+rfAZGCQ79xzEj6NExy3AWl2TIH
         yqq4qgKbDrRXWSdk/Q6LTGijK2ZwPQRhSwcI44pdzEE7QTuapkzHDgxfAFcajF4pFeiU
         c+DydIzDTjs9qzHUYHbj4pjAqVKeSBkn3qUBcz10GgDBL1+qKVKQYV54cTXisUVhB59K
         zisPp3vUaSdjviwrmlQIpnH9yGM9tfJ3vGj1rRhx0PEZ2z+5ua/QBLLFDvzwKxEmVQh9
         qy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVGzQu3A2f4Qgo78q6jxGuOz9gIN1MMwXavNYjSHKBU=;
        b=HormtI80XRX5wf3WyeDHWVvGpTLmgTsTp2RAtKZq6FBa3CINSQF6Cg5Z/Yf+VXP/Yw
         kp9KFfXmKa+2yggDEjehOLpjlIdmhZx2bNJWoX3+3DdrVQmNM3moAOU1S6XaCtX2YrW5
         bVc2G4ksh07Zcv81Cba1MXadrt8xuh4buo16jffI71izFFJ33q6I6O30At4sKuKnt0ZD
         tIFg9cwUKiM3SnlfhspoiBVUwT2BGGZgoNxJRwmDlxiEcFTJCIiMRia4tpELmXgI/kyo
         fortjrfR6JcvX3aa+WLG0jISnV/5YIIWFqTL1S+WGWCfJs3ESlchfEQzpkjdj1qYmK6Q
         3VRg==
X-Gm-Message-State: AO0yUKUSsFdEdwBNs8Q9UCQMzgrByxQw8Sdf8tc++ejuxwlfZA+C6NwO
        9cY7xk4XqMvnRHV3PQO3lIdQHQ==
X-Google-Smtp-Source: AK7set8mJWiWAyJ74ti7VNQuSfGVVgfkF41VUhLW8nQG2B3Y90nuZ7EqdpXgzcSEUSguB8Fe2CwcUg==
X-Received: by 2002:a05:6000:1004:b0:2bf:d332:e123 with SMTP id a4-20020a056000100400b002bfd332e123mr3000451wrx.62.1675284288852;
        Wed, 01 Feb 2023 12:44:48 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d598f000000b002bdff778d87sm19993584wri.34.2023.02.01.12.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:44:48 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 2/9] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Wed,  1 Feb 2023 20:43:31 +0000
Message-Id: <20230201204338.1337562-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201204338.1337562-1-usama.arif@bytedance.com>
References: <20230201204338.1337562-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

