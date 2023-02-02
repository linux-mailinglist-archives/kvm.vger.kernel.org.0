Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74A6688952
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjBBV4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjBBV4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:56:49 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BA7098B
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:56:34 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h16so2972335wrz.12
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZN0/JHYpO4HmptKsonBLHsoSegp6yzcZ7Pz1OBnmRqA=;
        b=yqnYiCH8AqjbpexuA4/vbph6hoxbvOnFhN1VxUqRO95nCraYxvYmd29sN+sEN/dpGG
         qxQDpQJPYq2APbiu5GOOas85BV89BgLqSB51zCXUT7VVHB9vtkWtygPz5StqwzLrzNFA
         QBdT8ALik941Wvo4RA0zOH+VtJhYzV7HawC2LrqvNxKAhGUtMYsoWHtXeQFZ/jE2LZm3
         kH5hPItDQILWhGiBf1ejjmMXVtuQT19dCO/Xwis6fWph+NCB844DcHURiyK3hAHeAdN6
         h7CsMWxwW2cRn540KCGUyJiKH6fppnyjLc5mkK8/SO+NTN2/XNJw+JKcDyOM0YLUuPM8
         Zu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZN0/JHYpO4HmptKsonBLHsoSegp6yzcZ7Pz1OBnmRqA=;
        b=pLHxsFOfEgM2M288/kSpsvsS4jvZ+JtMGabaGI0fp4c/A8HeGhaBNHG1lwdhGYrx5e
         1pWDyr/DEjeSG244W9S7VHsb/mFIIDQubyI2G8o6Zj74cuJ3A/HkLsCfuIC7TOp+KckJ
         V3yE4KIny0AKgIgWFAmd0CO2Xbr9tGoi+kHINCkQxFDo34J9K2113x7LeJYe2z6xMa84
         lik1VGA05Ghao6emNPqZLAhEqhVl+0XIQp8II2UhIaUI3lVBsAui2v9cGHLAd/OSJrbv
         Jthg3/ZlVze5DJqw3tmSx+3qDTxekvhWGU4ImGK78MyRLu03f9t66zTV/CexP/YFI/tC
         yMxA==
X-Gm-Message-State: AO0yUKWJmGI4mUXyNKDjH1bOuCaO78K/F5N6i2OJG+R0cn6NxGR1s9yg
        91t4pFr67Kq8sbaCzerE3OxOuQ==
X-Google-Smtp-Source: AK7set++8PqjIdeq1L46OVBnOkqhdxJF6/lj85wbCGaMyYm8j4fJrWSCPonIGrdEOwiXsqBa+kIDGw==
X-Received: by 2002:a05:6000:15cd:b0:2bf:d8ed:ba46 with SMTP id y13-20020a05600015cd00b002bfd8edba46mr8519729wry.47.1675374993184;
        Thu, 02 Feb 2023 13:56:33 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d6d08000000b00297dcfdc90fsm506078wrq.24.2023.02.02.13.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:56:32 -0800 (PST)
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
Subject: [PATCH v6 03/11] cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
Date:   Thu,  2 Feb 2023 21:56:17 +0000
Message-Id: <20230202215625.3248306-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202215625.3248306-1-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
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

If the platform registers these states, bring all CPUs to each registered
state in turn, before the final bringup to CPUHP_BRINGUP_CPU. This allows
the architecture to parallelise the slow asynchronous tasks like sending
INIT/SIPI and waiting for the AP to come to life.

There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_DYN step,
this means that *all* CPUs are brought through the prepare states and to
CPUHP_BP_PREPARE_DYN before any of them are taken to CPUHP_BRINGUP_CPU
and then are allowed to run for themselves to CPUHP_ONLINE.

So any combination of prepare/start calls which depend on A-B ordering
for each CPU in turn, such as the X2APIC code which used to allocate a
cluster mask 'just in case' and store it in a global variable in the
prep stage, then potentially consume that preallocated structure from
the AP and set the global pointer to NULL to be reallocated in
CPUHP_X2APIC_PREPARE for the next CPU... would explode horribly.

We believe that X2APIC was the only such case, for x86. But this is why
it remains an architecture opt-in. For now.

Note that the new parallel stages do *not* yet bring each AP to the
CPUHP_BRINGUP_CPU state. The final loop in bringup_nonboot_cpus() is
untouched, bringing each AP in turn from the final PARALLEL_DYN state
(or all the way from CPUHP_OFFLINE) to CPUHP_BRINGUP_CPU and then
waiting for that AP to do its own processing and reach CPUHP_ONLINE
before releasing the next. Parallelising that part by bringing them all
to CPUHP_BRINGUP_CPU and then waiting for them all is an exercise for
the future.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/linux/cpuhotplug.h |  2 ++
 kernel/cpu.c               | 27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 6c6859bfc454..e5a73ae6ccc0 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -133,6 +133,8 @@ enum cpuhp_state {
 	CPUHP_MIPS_SOC_PREPARE,
 	CPUHP_BP_PREPARE_DYN,
 	CPUHP_BP_PREPARE_DYN_END		= CPUHP_BP_PREPARE_DYN + 20,
+	CPUHP_BP_PARALLEL_DYN,
+	CPUHP_BP_PARALLEL_DYN_END		= CPUHP_BP_PARALLEL_DYN + 4,
 	CPUHP_BRINGUP_CPU,
 
 	/*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6c0a92ca6bb5..5a8f1a93b57c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1505,6 +1505,24 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
 void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
 	unsigned int cpu;
+	int n = setup_max_cpus - num_online_cpus();
+
+	/* ∀ parallel pre-bringup state, bring N CPUs to it */
+	if (n > 0) {
+		enum cpuhp_state st = CPUHP_BP_PARALLEL_DYN;
+
+		while (st <= CPUHP_BP_PARALLEL_DYN_END &&
+		       cpuhp_hp_states[st].name) {
+			int i = n;
+
+			for_each_present_cpu(cpu) {
+				cpu_up(cpu, st);
+				if (!--i)
+					break;
+			}
+			st++;
+		}
+	}
 
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -1882,6 +1900,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
 		step = cpuhp_hp_states + CPUHP_BP_PREPARE_DYN;
 		end = CPUHP_BP_PREPARE_DYN_END;
 		break;
+	case CPUHP_BP_PARALLEL_DYN:
+		step = cpuhp_hp_states + CPUHP_BP_PARALLEL_DYN;
+		end = CPUHP_BP_PARALLEL_DYN_END;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1906,14 +1928,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
 	/*
 	 * If name is NULL, then the state gets removed.
 	 *
-	 * CPUHP_AP_ONLINE_DYN and CPUHP_BP_PREPARE_DYN are handed out on
+	 * CPUHP_AP_ONLINE_DYN and CPUHP_BP_P*_DYN are handed out on
 	 * the first allocation from these dynamic ranges, so the removal
 	 * would trigger a new allocation and clear the wrong (already
 	 * empty) state, leaving the callbacks of the to be cleared state
 	 * dangling, which causes wreckage on the next hotplug operation.
 	 */
 	if (name && (state == CPUHP_AP_ONLINE_DYN ||
-		     state == CPUHP_BP_PREPARE_DYN)) {
+		     state == CPUHP_BP_PREPARE_DYN ||
+		     state == CPUHP_BP_PARALLEL_DYN)) {
 		ret = cpuhp_reserve_state(state);
 		if (ret < 0)
 			return ret;
-- 
2.25.1

