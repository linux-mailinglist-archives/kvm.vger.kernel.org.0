Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6CF6CCB15
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjC1T6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjC1T6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:58:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9CD3C3B
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:04 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q19so10339739wrc.5
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680033483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X91DtJ/JfDBYHgJ9R+MsUlxcd9N/rlmrW5KIlOR8liw=;
        b=NWYwEsRz9geMdPiZTptjEO/9APlaCqvEYwMbECwAldxXFGFACgIWK90ii/GU/MH0bv
         BZi+c0pfVDIua+d5qc0dsTUUYxTuWgQo943MJfDPirAdFrEzrxH9/wQ5VZbbD7+9M+8V
         VFdYMw4UFXT1TIsDaSj/BN3KRp2iVO55u2TfrvQohfiR8WW6ukbp+Qb7nink2lOLE/N2
         QGPBXS7HapIA84q1rxlmR3mOhwTq0O2ZGtfFsDrPzi9MDfgUGNBDuP+zPhMWUUwJ7sTa
         pT+OQ4Sgm2fD8eEXcfi1nICr9juzJneQFELj28gTxjEZ8pY9F+uiPs6ZMU/JjykbSJ6J
         DMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X91DtJ/JfDBYHgJ9R+MsUlxcd9N/rlmrW5KIlOR8liw=;
        b=vSKUcXZeKgRWJ8U/lUpkvIMWAQdt3mXiu3ocDxtl0qkj0CGMT25wSy7spmL+3vgGKh
         p7TipZodclznyA4SpZGSZbR4JQrXbJkzlcSAMkRd2AUGyDvCtroLIQ1ebq1tP6iP1Qn9
         tw7/AXx4bZQ/3qd6l5xbzSey4CUx4FZG6KZq74QyajbquNup5lcGDPBnn31kxxW2zGlE
         u2g+hQNFUyc1WI8xloa0JX2yahSrOP+5nOsJawUuZSAIyigw2nIuz3XT4KJXv+zZsHSY
         o8novYfFg9ZWsTJtt/Xv3+1NMFJbJ9VMN4rBvQkN4xNpqf3ViQyZc8xByPJuXExJAYSk
         LDFA==
X-Gm-Message-State: AAQBX9dqmeZ8LnesAOEB2Z0Mp41aOaTgEyeq72vHwvLiWh2O6aQaexTo
        WpQibEllgyX+l2xw/w/vEwK3Uw==
X-Google-Smtp-Source: AKy350amb/QgxxCJbkb1cMFpzryewCgKpdAjyNU+f2iuwOROJhsX0a0Dv8edkHUKYfph0Bz2+qREpg==
X-Received: by 2002:a5d:54d0:0:b0:2d5:553a:93ac with SMTP id x16-20020a5d54d0000000b002d5553a93acmr14146098wrv.7.1680033483331;
        Tue, 28 Mar 2023 12:58:03 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8445:3123:91d7:959d])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm28248386wrw.99.2023.03.28.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 12:58:02 -0700 (PDT)
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
        Usama Arif <usama.arif@bytedance.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v17 3/8] cpu/hotplug: Add CPUHP_BP_PARALLEL_STARTUP state before CPUHP_BRINGUP_CPU
Date:   Tue, 28 Mar 2023 20:57:53 +0100
Message-Id: <20230328195758.1049469-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230328195758.1049469-1-usama.arif@bytedance.com>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There is often significant latency in the early stages of CPU bringup,
and time is wasted by waking each CPU (e.g. with SIPI/INIT/INIT on x86)
and then waiting for it to make its way through hardware powerup and
through firmware before finally reaching the kernel entry point and
moving on through its startup.

Allow a platform to register a pre-bringup CPUHP state to which each
CPU can be stepped in parallel, thus absorbing some of that latency.

There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_STARTUP
step, this means that *all* CPUs are brought through the prepare states
all the way to CPUHP_BP_PARALLEL_STARTUP before any of them are taken
to CPUHP_BRINGUP_CPU and then are allowed to run for themselves to
CPUHP_ONLINE.

So any combination of prepare/start calls which depend on A-B ordering
for each CPU in turn would explore horribly. As an example, the X2APIC
code prior to commit cefad862f238 ("x86/apic/x2apic: Allow CPU
cluster_mask to be populated in parallel") would allocate a new cluster
mask "just in case" and store it in a global variable in the prep stage,
then the AP would potentially consume that preallocated structure and set
the global pointer to NULL to be reallocated in CPUHP_X2APIC_PREPARE for
the next CPU. Which doesn't work at all if the prepare step is run for
all the CPUs first.

Any platform enabling the CPUHP_BP_PARALLEL_STARTUP step must be
reviewed and tested to ensure that such issues do not exist, and the
existing behaviour of each AP through to CPUHP_BP_PREPARE_DYN and then
immediately to CPUHP_BRINGUP_CPU and CPUHP_ONLINE only one at a time
does not change unless such a state is registered.

Note that this does *not* yet bring each AP to the CPUHP_BRINGUP_CPU
state at the same time, only to the new CPUHP_BP_PARALLEL_STARTUP state.
The final loop in bringup_nonboot_cpus() remains the same, bringing each
AP in turn from the CPUHP_BP_PARALLEL_STARTUP (or all the way from
CPUHP_OFFLINE) to CPUHP_BRINGUP_CPU and then waiting for that AP to do
its own processing and reach CPUHP_ONLINE before releasing the next.

Parallelising that part by bringing them all to CPUHP_BRINGUP_CPU and
then waiting for them all to run to CPUHP_ONLINE at the same time is a
more complicated exercise for the future.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]
---
 include/linux/cpuhotplug.h | 22 ++++++++++++++++++++++
 kernel/cpu.c               | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index c6fab004104a..84efd33ed3a3 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -133,6 +133,28 @@ enum cpuhp_state {
 	CPUHP_MIPS_SOC_PREPARE,
 	CPUHP_BP_PREPARE_DYN,
 	CPUHP_BP_PREPARE_DYN_END		= CPUHP_BP_PREPARE_DYN + 20,
+	/*
+	 * This is an optional state if the architecture supports parallel
+	 * startup. It's used to start bringing the CPU online (e.g. send
+	 * the startup IPI) so that the APs can run in parallel through
+	 * the low level startup code instead of waking them one by one in
+	 * CPUHP_BRINGUP_CPU. This avoids waiting for the AP to react and
+	 * shortens the serialized phase of the bringup.
+	 *
+	 * If the architecture registers this state, all APs will be taken
+	 * to it (and thus through all prior states) before any is taken
+	 * to the subsequent CPUHP_BRINGUP_CPU state.
+	 */
+	CPUHP_BP_PARALLEL_STARTUP,
+
+	/*
+	 * This step brings the AP online and takes it to the point where it
+	 * manages its own state from here on. For the time being, the rest
+	 * of the AP bringup is fully serialized despite running on the AP.
+	 * If the architecture doesn't use the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this step also does all the work of bringing the CPU
+	 * online.
+	 */
 	CPUHP_BRINGUP_CPU,
 
 	/*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 43e0a77f21e8..3382273ea3f4 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1504,13 +1504,45 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
 
 void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
-	unsigned int cpu;
+	unsigned int cpu, n = num_online_cpus();
 
+	/*
+	 * On architectures which have setup the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this invokes all BP prepare states and the parallel
+	 * startup state sends the startup IPI to each of the to be onlined
+	 * APs. This avoids waiting for each AP to respond to the startup
+	 * IPI in CPUHP_BRINGUP_CPU. The APs proceed through the low level
+	 * bringup code and then wait for the control CPU to release them
+	 * one by one for the final onlining procedure in the loop below.
+	 *
+	 * For architectures which do not support parallel bringup all
+	 * states are fully serialized in the loop below.
+	 */
+	if (!cpuhp_step_empty(true, cpuhp_get_step(CPUHP_BP_PARALLEL_STARTUP))) {
+		for_each_present_cpu(cpu) {
+			if (n++ >= setup_max_cpus)
+				break;
+			cpu_up(cpu, CPUHP_BP_PARALLEL_STARTUP);
+		}
+	}
+
+	/* Do the per CPU serialized bringup to ONLINE state */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu, CPUHP_ONLINE);
+
+		if (!cpu_online(cpu)) {
+			struct cpuhp_cpu_state *st = per_cpu_ptr(&cpuhp_state, cpu);
+			int ret = cpu_up(cpu, CPUHP_ONLINE);
+
+			/*
+			 * Due to the above preparation loop a failed online attempt
+			 * might have only rolled back to CPUHP_BP_PARALLEL_STARTUP. Do the
+			 * remaining cleanups. NOOP for the non parallel case.
+			 */
+			if (ret && can_rollback_cpu(st))
+				WARN_ON(cpuhp_invoke_callback_range(false, cpu, st, CPUHP_OFFLINE));
+		}
 	}
 }
 
-- 
2.25.1

