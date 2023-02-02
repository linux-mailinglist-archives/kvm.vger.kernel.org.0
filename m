Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FC68895F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjBBV5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjBBV5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:57:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859A6B009
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:56:33 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bk16so2972584wrb.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGUMPbv5ehkWjyJkrcI0+C5Cz30zQDLH70pUeAdBLkQ=;
        b=2M4JOPBXhf4n8GQQdyrzHe3qWIJaL7f9plv5S3ltmqAiKFtsvcGXGUTC2Zuij3BMbs
         HhlEqG9+INFdfdUkReFlmvH2JPZMrNCztu3WfOAY+06RdcFUOlBB41XvMs68Ya736yK2
         nOZn1J7hYgH42tp/gN4crt3m2pxOLEjJAusMRXcc680eWWrSJLJMCjmPufzsVttIRkCW
         9QkU3r7GppcN34bu8GaPenanJDgtpVPDONSrvDRiSQXJXkEZApH8tlqbG9jFp0sxPyy2
         H0xXvJvm2qthioHCwmimhIU+Q9Nh8Kc7h/9OaMxXMAdSlKwy88YLZFA1gae6hbRvVar+
         bsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGUMPbv5ehkWjyJkrcI0+C5Cz30zQDLH70pUeAdBLkQ=;
        b=g6i6dvlj4ECoKuf+7bnLr4F8o0O1RSt3Rf6A4iYZQkrm77CCwNgy5d4e4bMVY2EJgN
         Fj1LOPvMu7soMP1PqdlIR1IIWK/7IdUoMSawfsn1BjDPl25q4naJVyRbUco5GIgQ+ogm
         5Z78hGxrghlZTeMROpwLhoEysmfXUaHcIVOnteAlKiLu336HjcCZlf2dIH7F+4ZBRXwJ
         UKpsFWfQHE6cGTvR6RTll4HLtZxwjqiffmbW5gYRyabvdxk5aHjt3jh6S97l7+2pVopC
         Q9Z5cxwzFNoZ1YnQRmpqnd7eyeaBu3uzAIBHYHL0htacuvRfrhGv6me6Hr3w2L/4U8Vc
         kvLA==
X-Gm-Message-State: AO0yUKWgtIg4wtCh2Z19q/0jB9qbH9oJ8tkNF0jQ0o4rgzIuuavw+nQ1
        vFeZ1apMdxxGVr5syHyqye1ptyDX0SISkR4PMfs=
X-Google-Smtp-Source: AK7set/CDswZdmTsSZsErF7V63uar9uvceQgDgLkLPtGwcWkpo8b1nJ0th3Lj0DuhHf/pnavpwsO/g==
X-Received: by 2002:a5d:6c6d:0:b0:2bf:d6f9:23d6 with SMTP id r13-20020a5d6c6d000000b002bfd6f923d6mr7783377wrz.45.1675374992316;
        Thu, 02 Feb 2023 13:56:32 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d6d08000000b00297dcfdc90fsm506078wrq.24.2023.02.02.13.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:56:31 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v6 02/11] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Thu,  2 Feb 2023 21:56:16 +0000
Message-Id: <20230202215625.3248306-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202215625.3248306-1-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
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
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
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

