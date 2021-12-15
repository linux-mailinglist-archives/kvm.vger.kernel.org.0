Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52D475B38
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbhLOO5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243655AbhLOO5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 09:57:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375B5C06175B;
        Wed, 15 Dec 2021 06:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=Tc77RILQLKEcS45J/6Ljdmr/xCkfDC7wsVb7jXcmkrE=; b=KWcoLwJHZ3htGKX9jXZncdYJYv
        7XydObdw8CiaRHHZpXm3BX+p6rILrYqEGuMR1+dpSlUv/CEaTmT5ySP46yfn9S4ECEZ/+2Ar1X/YH
        k1i3juzmjmurYxVqdWPypcBVn8QAQHHc7lThIZxpwY+fnxtgKaHm9PPzx2lbfRCC7fOUc+16lNPdc
        YlN2QNeZQOZW1VCZG7t8RDDPRKA+Z3TZp6w1uFb9aiBo1hctX1lsk/1Bp/haWiM+azsVLHp0a9C+3
        YTggTjeRNtqX2c6Tlx5VGaYPidzGkkJqM+Mr5CWfMiZGYb8gwVnUnnmKKvTA3x0k3FvJGygXOqT53
        56HMCMRQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhq-00EjwN-Nh; Wed, 15 Dec 2021 14:56:35 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhq-0001No-V9; Wed, 15 Dec 2021 14:56:34 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH v3 3/9] cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
Date:   Wed, 15 Dec 2021 14:56:27 +0000
Message-Id: <20211215145633.5238-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215145633.5238-1-dwmw2@infradead.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
---
 include/linux/cpuhotplug.h |  2 ++
 kernel/cpu.c               | 27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 773c83730906..45c327538321 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -131,6 +131,8 @@ enum cpuhp_state {
 	CPUHP_MIPS_SOC_PREPARE,
 	CPUHP_BP_PREPARE_DYN,
 	CPUHP_BP_PREPARE_DYN_END		= CPUHP_BP_PREPARE_DYN + 20,
+	CPUHP_BP_PARALLEL_DYN,
+	CPUHP_BP_PARALLEL_DYN_END		= CPUHP_BP_PARALLEL_DYN + 4,
 	CPUHP_BRINGUP_CPU,
 
 	/*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 192e43a87407..1a46eb57d8f7 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1462,6 +1462,24 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
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
@@ -1829,6 +1847,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
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
@@ -1853,14 +1875,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
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
2.31.1

