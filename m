Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A616A1055
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBWTMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBWTMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:12:50 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7686653ECC
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:22 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 6so11156143wrb.11
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cOxOkpCD+vr2n7vBER3mbkwWwlvY2KHB3oBnHbXr/U=;
        b=ErntIUgAGEyRKXt4RMT66Pr0KsOFVw3vBflYFgfNggAyszQJLjPK+0lmvNVh2KXY7g
         wLgsBRVHOmbmRWbenYGMIxstY0+viUEq09wJYgsdb0oa72GZHZyRNICptybAqmyCeY/4
         JSfHCnSohGbanQEtvvBqQOiPK3IGTQsbhuRvCIkXAtcI/l1zNfcYBX53buZ7xaGJm9Si
         tIx8lFSAKy+fGR9TzyT8jccKHgDF22drQHBcbFUumT4w4Cm+cupSv8AmEqAky0qy3J34
         Dsakgq/7oGhgzOOA/T+PDYwDyEqdsiF1RVugLC3zmLNw4vIThARfDuXru7zf/cuVHvwj
         jtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cOxOkpCD+vr2n7vBER3mbkwWwlvY2KHB3oBnHbXr/U=;
        b=cnuqjIz3lvD1npjsjRjhubUZ98fhmn9JN/xVFQK/tTmkCIGsrN6sik708l5aS+rU+4
         boC7deZTvHwKIFcXpnVZ879wxuBbA8yIev1+wTUt3IPNigsf46v0LEgk4t5ygRHs8TGJ
         SPlYGL+ZrmKqzRLm3PJAW85xVkTYdEosY2jqTmxgsUPnIruPDdv4QebOrSatDbwAENuM
         wwAf50qkEJeagt+gQvO75nhJ9DbcMSC7TsDnFmF2DfCSm3pR4jRGRxtpQeV30HOWaJt3
         +kjzaN1qLq4diw3QWueP6KmX8zB1qwzc3WcrRdLW8ahN71KLURzt+Pq69EQVraNFXgct
         NwLQ==
X-Gm-Message-State: AO0yUKVPpVUzBIODJ59X3T6LWBCcYTnmgdng6v7/kF7hHhmBHB1EmnR0
        GFSHU99rURFzQ0PFOA/ZPqJHTw==
X-Google-Smtp-Source: AK7set+dbHx4azJ+uDT3nkXu+TSQadSyr2qdot7zwaRJcS8pl5LZjAZsdxZtDowpkUSbv7n0SuNgfA==
X-Received: by 2002:adf:ea11:0:b0:2c7:a39:7453 with SMTP id q17-20020adfea11000000b002c70a397453mr6424268wrm.54.1677179509837;
        Thu, 23 Feb 2023 11:11:49 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:49 -0800 (PST)
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
Subject: [PATCH v11 07/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Thu, 23 Feb 2023 19:11:35 +0000
Message-Id: <20230223191140.4155012-8-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230223191140.4155012-1-usama.arif@bytedance.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

When the APs can find their own APIC ID without assistance, perform the
AP bringup in parallel.

Register a CPUHP_BP_PARALLEL_DYN stage "x86/cpu:kick" which just calls
do_boot_cpu() to deliver INIT/SIPI/SIPI to each AP in turn before the
normal native_cpu_up() does the rest of the hand-holding.

The APs will then take turns through the real mode code (which has its
own bitlock for exclusion) until they make it to their own stack, then
proceed through the first few lines of start_secondary() and execute
these parts in parallel:

 start_secondary()
    -> cr4_init()
    -> (some 32-bit only stuff so not in the parallel cases)
    -> cpu_init_secondary()
       -> cpu_init_exception_handling()
       -> cpu_init()
          -> wait_for_master_cpu()

At this point they wait for the BSP to set their bit in cpu_callout_mask
(from do_wait_cpu_initialized()), and release them to continue through
the rest of cpu_init() and beyond.

This reduces the time taken for bringup on my 28-thread Haswell system
from about 120ms to 80ms. On a socket 96-thread Skylake it takes the
bringup time from 500ms to 100ms.

There is more speedup to be had by doing the remaining parts in parallel
too — especially notify_cpu_starting() in which the AP takes itself
through all the stages from CPUHP_BRINGUP_CPU to CPUHP_ONLINE. But those
require careful auditing to ensure they are reentrant, before we can go
that far.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 arch/x86/kernel/smpboot.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 74c76c78f7d2..85ce6a8978ff 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/stackprotector.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/cacheinfo.h>
@@ -1325,9 +1326,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 
-	ret = do_cpu_up(cpu, tidle);
-	if (ret)
-		return ret;
+	/* If parallel AP bringup isn't enabled, perform the first steps now. */
+	if (!do_parallel_bringup) {
+		ret = do_cpu_up(cpu, tidle);
+		if (ret)
+			return ret;
+	}
 
 	ret = do_wait_cpu_initialized(cpu);
 	if (ret)
@@ -1349,6 +1353,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+/* Bringup step one: Send INIT/SIPI to the target AP */
+static int native_cpu_kick(unsigned int cpu)
+{
+	return do_cpu_up(cpu, idle_thread_get(cpu));
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
@@ -1566,6 +1576,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_01;
 	}
 
+	if (do_parallel_bringup) {
+		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
+					  native_cpu_kick, NULL);
+	}
+
 	snp_set_wakeup_secondary_cpu();
 }
 
-- 
2.25.1

