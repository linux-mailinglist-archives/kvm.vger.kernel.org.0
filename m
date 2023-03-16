Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79B6BDB77
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjCPWVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjCPWVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:21:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BE7B0B99
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o7so2871981wrg.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySNFLglM8SJEJlQ1FHHmy3ZddsPF9igYAJti/ai7CSk=;
        b=E8lXhN7xCG0/Utl/fWZI1ZNtGqI9EJIVGD+gymWMWoRdPZAPfvFi+5QKhLol1oOGHn
         BpYddX/YMFiEjf0YMIdZHef4jpIdVZzFrtXEM+6qB29huW2jgbb2mnXjVF3wKR8EhvD9
         Xzixo1CR0PuIHdZiKI/ReOwtirzLrxUlWuGfc73YebJwwIICs7XRmdiUi5G1JO+Bs55z
         84uOF5NsaJ9x8USZRZHm+RPpwK9gX9dCuqASSP+NT8+etsVloO37LzZ8ldj+/Mz5yzrj
         MFnCA11jiCSq0o8Cb0RjIg0Ds/3zIiecSY6GeEgKiOPQXAUuOB0lKRPtRBXgejW4EsAX
         kz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySNFLglM8SJEJlQ1FHHmy3ZddsPF9igYAJti/ai7CSk=;
        b=ZQdIShPR8+VfONwTSzkXu9AORa9A3OWNNhkzO9Mw98hjriJCKbPUw1PB9hdoBob9Gl
         H3mdPURosccnhvYfUZxXUKqEsZ/z4z2sEGuG/7so1cSps3LclVrttrz+Wf2sm7ZQp2jy
         1MbnFcuKfNtNSauygq3olArsiRts+tArbQLZny8TyEC+qt+dBQYsJbJ4sJy7hcVljLEO
         dwiHXfvooCHNhPc+BfTSWBFDqHW+CWbKEiIrik1HzqE1hBHhbaw96dsv8ByaHxflCZqC
         jvvBtP7Vup3oybScq98QDPFBfPy0COHcfSUIoj7sDVAoMgd0nzjmjHNWTBqW1OEE2qZ9
         JVTg==
X-Gm-Message-State: AO0yUKXmOqbgEYs1NTqJVHM/Axtylaezne7G+Al5ZLEKCI+ypfDn1jtq
        WXecuzLl/YXhcz5mqE48a7hhig==
X-Google-Smtp-Source: AK7set+5XqXeOAvFgIKV6Ij+vs6zqUV01x3VUSIjYxvswKndHN4sQ8p7UD2jILuKmlOr7o+vOWiDdQ==
X-Received: by 2002:adf:dcc2:0:b0:2ce:aa2d:c625 with SMTP id x2-20020adfdcc2000000b002ceaa2dc625mr5869244wrm.22.1679005274770;
        Thu, 16 Mar 2023 15:21:14 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:14 -0700 (PDT)
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
Subject: [PATCH v15 03/12] cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
Date:   Thu, 16 Mar 2023 22:21:00 +0000
Message-Id: <20230316222109.1940300-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
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
 kernel/cpu.c               | 31 +++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

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
index 6b3dccb4a888..6ccc64defd47 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1497,8 +1497,30 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
 
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
@@ -1875,6 +1897,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
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
@@ -1899,14 +1925,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
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

