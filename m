Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E572690D54
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjBIPnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 10:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjBIPmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 10:42:44 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A45B64650
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 07:42:07 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso1833294wms.4
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 07:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFpynNqCsjntY/I1AYfIdfaU4qF01G8hntPs8CGUGJk=;
        b=mLQQ5s0LozepNKhlqL43TEbCQto9aNvqir80KAKt+74mLv5eUekNlH6J2dFUIkyPS5
         vAVYAwc85IyHxsye1wVlo1qImm0NKXt6CGqpyR0LzbleWqYaB8BNmpcL3g8OT7hNR/Fg
         8/wPpP97CewoN77qp2wdaFyTvB7BYAoO2nWwjguUYke1kOQjcN3++FrG7Ubjs4fr2J48
         on4ZZ6mrNsv0yODpNt6sHb7BupKPk1v8eYQGw1YTs8rmnIr+1MgTBo3tpl/xx/VBack6
         lSyz6KUqPfElaU2p3PZOee4e4Lkuxx7iPoQCI1iHUBeAS0GVSPKklWb11h5G9ptE0PGL
         CgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFpynNqCsjntY/I1AYfIdfaU4qF01G8hntPs8CGUGJk=;
        b=dIvl2gY8tGLEpl9r8cyPJ1DIKVO98wykXjRtaWYoKCsTyuYWAwSOhhYopMopt9RNwm
         24zuETxsJDSF6tLuhJ1ObR9fUZsi9rJ8nzZk/9AKmtz4+UbpTCHVV+6xUb/wfjeLj2ug
         nJJvC6YSl9msWKRyBdrk63BwhQ9MdjapMJ2ryjMkjhXv9ARKNFOHbaV/SPsabCq3fSc5
         1S58XdcC+S6x2qCqKlc+sa+qMCGH0QbNGoHOi0kGCdCy36vljc5R51xGVsb76RSDOg98
         GazSvvyjr06kqTi77/OY3/vV+LsMU5EWzrrRtUZj210XowVkqFVzl5dQUN6ZY6VNFJVM
         zSKw==
X-Gm-Message-State: AO0yUKWGgPKcGEiTNoXFeBlOuvP7/8nJVFcQFdmqxsfCjcGsrbQH2R5G
        MYuFUTPBBY07QYv46+GgkV+AGA==
X-Google-Smtp-Source: AK7set87voqZzIvZGzHhcTExN5wSgAFSdZV/fUtli4JrSRYuK7OWBQexwLASiKjGgb0Vhb5g5BCezA==
X-Received: by 2002:a05:600c:992:b0:3df:eedf:f35f with SMTP id w18-20020a05600c099200b003dfeedff35fmr4588500wmp.41.1675957327106;
        Thu, 09 Feb 2023 07:42:07 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003df7b40f99fsm5099754wmq.11.2023.02.09.07.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:42:06 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v8 7/9] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Thu,  9 Feb 2023 15:41:54 +0000
Message-Id: <20230209154156.266385-8-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230209154156.266385-1-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[Usama Arif: fixed rebase conflict]
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/kernel/smpboot.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 50621793671d..df839264266b 100644
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

