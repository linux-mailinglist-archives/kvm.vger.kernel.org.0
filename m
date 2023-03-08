Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF856B0FFA
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCHROe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCHROP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:14:15 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4C15F6D6
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 09:13:34 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c18so10256607wmr.3
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 09:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678295613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ygAcJKnTKCTvVciunh9HcyMwipcH5PYmlVu4YEhebA=;
        b=B03iUazIeK+fTOeTtoIYFrVlkiCg5MKp6EKIDmdOHo+VcLdDxW1z3dCNzk2ZFiCWGN
         fjlhvGekCaLakHwlMXb5VP7URHIdAVayJ40T0qzRe4csvjkR9EX6S10aO0BwcDpeYUMU
         Prhx+quIXkuodhfySavM3z1GsbKf4vpm6WgmkuDXxZBn4aXlCk9xjLa48zu9KUhj7iWq
         86xKIFzUaUaHr9UMtT8GDLYoZfy3qSg3YVJY/nuUKQxPaYE+ztVrnvYTBV9YYpa6mmZx
         Ml6ObVsVHkrw5qmluLVzc2W8BFUtfv6DwPZ8quiiZbzBricZZEqOtnP/XOdydwXaFED9
         2+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ygAcJKnTKCTvVciunh9HcyMwipcH5PYmlVu4YEhebA=;
        b=ywuLJ6kfMxiM+DFio2IQy3wtitcV/OXwqVACwaGJqcVySF46t8/i0VEpKo5lW1h1nD
         RBWP+9FbVtOSC5vhydhz+1cnMoPFLyhmlgdT7VrBd4W1P9q5X7hmKzApamNnBPai2HY9
         CpaTF4ih/rtMH9iCGJCYUtfEuzcu2dzorWOHB1F112OrBG22INoKr9CEhEnidrbvsJON
         euZUhdPmN0328WZGLTdwYeYXsQvn0PnpqzNBO7JFl8QkAD9AWxGUf3pkwToe7jiYHkUA
         9BElMC24chXNyjsPgjTOQ+IPSHqfFwFUegKGtK57htmeDumcW1mQDnqYHGggqODHfqti
         PEXw==
X-Gm-Message-State: AO0yUKU115PwyVODQSVIRZCotAMCIaDisRfO4T9NmhLfsdsrfiG3shZ8
        tywbwBgL1yJzhlPnFMBbkMtdHQ==
X-Google-Smtp-Source: AK7set9E23EQ3CCUsK86/pbHyXxLmsHsJ//uovV0sY/zaz7img3MnVmcwR7TD7FGrbIWyadA/xhM0A==
X-Received: by 2002:a05:600c:470b:b0:3eb:29fe:fe19 with SMTP id v11-20020a05600c470b00b003eb29fefe19mr16946175wmo.34.1678295613083;
        Wed, 08 Mar 2023 09:13:33 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:fe40:3ba4:afe4:4609])
        by smtp.gmail.com with ESMTPSA id l15-20020a1c790f000000b003e0238d9101sm11668wme.31.2023.03.08.09.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:13:32 -0800 (PST)
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
Subject: [PATCH v14 02/12] cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
Date:   Wed,  8 Mar 2023 17:13:18 +0000
Message-Id: <20230308171328.1562857-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308171328.1562857-1-usama.arif@bytedance.com>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
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

