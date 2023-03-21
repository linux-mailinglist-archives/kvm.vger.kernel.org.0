Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1D6C3AE4
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCUTmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjCUTlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:41:55 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60D74FCDF
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:40:53 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v1so8778700wrv.1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679427637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DktZ/R8hIfvx1jODzCxrB4AmB9U5V9FbvM8VCV2fQU8=;
        b=PMusNAMzrj2S5E/UImuGRw0Y2hKIAn7ciHXdgf+MQYDpFK6JCTiXnL5RAgYe5jJ19K
         7qOo5eum1pTPHY9mJtl6U1n2DsKZCpsltLeI5Ub07faBl6tSZB2jRL8yE6FVnRFjaQzk
         Uv2kgoJdnXR9KWI2BH7w32fsAcXNbpmVCZE6JThofYZnTcHp8Astk6Mp7Lt2fR7zxSHI
         NWBOTQ8FkVqATaktP2aLnfBpkCFwmeQRiORCUzoNXCVrAR/Et3YIx55B06RZTncQZ0mO
         F8aqMEg4pcvm3JqMoP6gdf+hlv3NxXvz7MxePYGvh8TG8/QGo9i26oIwCj7HLjd9o4NR
         PkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DktZ/R8hIfvx1jODzCxrB4AmB9U5V9FbvM8VCV2fQU8=;
        b=WXEQsUxDMB2teY4sHdyzAOxugIdLlYlDptLT05kEiUxI/80cDVRdzWduWcThQ+sk7M
         zycHB2Burix/8PJpD5hZOmj+c1rEZvCXAPJmLshNY6kJsq3dC0dAHE24xs1ngmx8Km/i
         cnh2DUItQ7+DDQ7Xoctb3mqSfRZ7LINVRtbAySLbo9BKbXGg/ZeC/BdaL4j2FkEtXAil
         hB0X4AMVNEot4LkE8rphjt//q+KvIa/w/3AuGZt09g5V5GsjUiEb1AC3UUsn+wE0o2u6
         PyBjGNS6094+RQCn9LSPj+ETukSIBz4+dacoyXMZwhwXCiM18Nba+a4ILRPYC0B5xGDD
         rJEQ==
X-Gm-Message-State: AO0yUKXgIL0F2/aJMtSZYpCyk6THMPDOzrcbov/DK+ohDdVBxMcZsfrP
        yBrU3pidOQVdxqOB7TNxcqFNSQ==
X-Google-Smtp-Source: AK7set8yNBGtMW+ICx97TQzjIgPCLUigGTU1e2rGyo2B2yU/vgtF9Dds11HgawcSjXOFN/YDP5ioQA==
X-Received: by 2002:a5d:4ccf:0:b0:2ce:a13b:76b4 with SMTP id c15-20020a5d4ccf000000b002cea13b76b4mr2941937wrt.24.1679427637108;
        Tue, 21 Mar 2023 12:40:37 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7a8a:d679:ba4e:61cf])
        by smtp.gmail.com with ESMTPSA id a3-20020adffb83000000b002c561805a4csm12005026wrr.45.2023.03.21.12.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:40:36 -0700 (PDT)
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
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
Date:   Tue, 21 Mar 2023 19:40:03 +0000
Message-Id: <20230321194008.785922-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321194008.785922-1-usama.arif@bytedance.com>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
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

There is often significant latency in the early stages of CPU bringup,
and time is wasted by waking each CPU (e.g. with SIPI/INIT/INIT on x86)
and then waiting for it to respond before moving on to the next.

Allow a platform to register a set of pre-bringup CPUHP states to which
each CPU can be stepped in parallel, thus absorbing some of that latency.

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

Any platform enabling the CPUHP_BP_PARALLEL_DYN steps must be reviewed
and tested to ensure that such issues do not exist, and the existing
behaviour of bringing CPUs to CPUHP_BP_PREPARE_DYN and then immediately
to CPUHP_BRINGUP_CPU and CPUHP_ONLINE only one at a time does not change
unless such a state is registered.

Note that the new parallel stages do *not* yet bring each AP to the
CPUHP_BRINGUP_CPU state at the same time, only to the new states which
exist before it. The final loop in bringup_nonboot_cpus() is untouched,
bringing each AP in turn from the final PARALLEL_DYN state (or all the
way from CPUHP_OFFLINE) to CPUHP_BRINGUP_CPU and then waiting for that
AP to do its own processing and reach CPUHP_ONLINE before releasing the
next.

Parallelising that part by bringing them all to CPUHP_BRINGUP_CPU
and then waiting for them all is an exercise for the future.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 include/linux/cpuhotplug.h |  2 ++
 kernel/cpu.c               | 49 ++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index c6fab004104a..ef3cf69a3d5b 100644
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
index 43e0a77f21e8..cf3c1c6f0710 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1504,13 +1504,49 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
 
 void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
+	unsigned int n = setup_max_cpus - num_online_cpus();
 	unsigned int cpu;
 
+	/*
+	 * An architecture may have registered parallel pre-bringup states to
+	 * which each CPU may be brought in parallel. For each such state,
+	 * bring N CPUs to it in turn before the final round of bringing them
+	 * online.
+	 */
+	if (n > 0) {
+		enum cpuhp_state st = CPUHP_BP_PARALLEL_DYN;
+
+		while (st <= CPUHP_BP_PARALLEL_DYN_END && cpuhp_hp_states[st].name) {
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
+
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu, CPUHP_ONLINE);
+		if (!cpu_online(cpu)) {
+			int ret = cpu_up(cpu, CPUHP_ONLINE);
+
+			/*
+			 * For the parallel bringup case, roll all the way back
+			 * to CPUHP_OFFLINE on failure; don't leave them in the
+			 * parallel stages. This happens in the nosmt case for
+			 * non-primary threads.
+			 */
+			if (ret && cpuhp_hp_states[CPUHP_BP_PARALLEL_DYN].name) {
+				struct cpuhp_cpu_state *st = per_cpu_ptr(&cpuhp_state, cpu);
+				if (can_rollback_cpu(st))
+					WARN_ON(cpuhp_invoke_callback_range(false, cpu, st,
+									    CPUHP_OFFLINE));
+			}
+		}
 	}
 }
 
@@ -1882,6 +1918,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
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
@@ -1906,14 +1946,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
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

