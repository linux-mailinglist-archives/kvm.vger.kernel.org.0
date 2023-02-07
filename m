Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F5568E427
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 00:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjBGXFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 18:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBGXFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 18:05:10 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4D83A5B5
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 15:04:44 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o36so12131119wms.1
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 15:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mY6NeUci0HQtTva2v+94F98gv/kbTw7O8GGA4dBnL3M=;
        b=Vi2Ppf9keVW26+otagfWa7oYewc9B9pagBPslJ3Kjc68ep9DpstkoM9u12dNmSCOv0
         YOY4GifEbRhhywq+8KX/SbPc6kZleF1JQo/8ISWnqj2dPvXW0K4GnQPIxRze1daggjZ1
         yHrIG8cKtcmzLBxOXsyJC/VjbAt6XOtj0pVTCjfjRxuNZ3rcBcOWcLp2gMNMnwDxldGN
         FKHGITBMIrEMFl3f8TAXkoZTflRdGqaOZ5ZQkxfDNstrgaJ1CWnwcHOCecN9sUGv4RFu
         xkR6wCpqcY8iOCVCgCXGVGtkZhlxaYdjn4SmA5jmdJybaMwHKPJIPBVVLDchVy3f9wpB
         /c8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mY6NeUci0HQtTva2v+94F98gv/kbTw7O8GGA4dBnL3M=;
        b=2zGR4b1GCsr10HF4NDMQLbuAAzPT+S9aj+pWS97JzbdVeEc6CWgUIukbzrT07i2jhI
         DWpj6QvXBHLuBYgXFweSu9MjJjpV6RNul+h0u5OSUKuUp8+kI6GmWeX5X0KgACZyGxz/
         xIYDih3rG22qO47uFzh0iFo0yJd9Gg0wWcWDVP6+FlsE0INyI4HcYm5McfNPJdu21F5O
         umCMnHc1GChFJPdTnwE4tkbNWf/GsmfS7JQyDR0pCsvfhPNYaoUwB+qYJ7XtJS5rdzNr
         GohdzHFVyiWpoVG669owX1v2i71mUwKr9KbyfMz5liRo7hvtJQJk7Hh5GTBtalVIHIJG
         lb2g==
X-Gm-Message-State: AO0yUKV5PQMzVHTF+lKb+l4VyphtF01qkGOVybA8INS5HWo+/GK/IIhs
        p9kMNxjsKUR/zSb9f8wqpuh/dA==
X-Google-Smtp-Source: AK7set9wPArZnF4SVnH4QEUNB0nS0WwTK3Ac0MpBDwlm03kZYykByKxRj9RU0c9YArnn2f6Vh8/neA==
X-Received: by 2002:a05:600c:1694:b0:3de:27c3:ef13 with SMTP id k20-20020a05600c169400b003de27c3ef13mr4537840wmn.9.1675811083383;
        Tue, 07 Feb 2023 15:04:43 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:c04f:2463:c151:8b87])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c190e00b003dcc82ce53fsm146485wmq.38.2023.02.07.15.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 15:04:42 -0800 (PST)
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
Subject: [PATCH v7 3/9] cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
Date:   Tue,  7 Feb 2023 23:04:30 +0000
Message-Id: <20230207230436.2690891-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207230436.2690891-1-usama.arif@bytedance.com>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
MIME-Version: 1.0
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
index 6c0a92ca6bb5..fffb0da61ccc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1504,8 +1504,30 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
 
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
@@ -1882,6 +1904,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
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
@@ -1906,14 +1932,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
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

