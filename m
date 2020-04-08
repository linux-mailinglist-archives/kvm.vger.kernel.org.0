Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA01A1B56
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDHFG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:06:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgDHFFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03854gSa191662;
        Wed, 8 Apr 2020 05:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=oFQu5c5XJMNWspifH0eo8iyuqi9GZvEBODJQANlcAEo=;
 b=cHnvTrtu81AYis8bhTT0uEby3pTuev6G236CP0PzsfSaOXZPYSInf2z4ytK/OtlP6l24
 Lqi3soKd+woQHGRwBladzfjWwRG2mMJiBf5q0t5K8EPT8EPGhaBSBmky2zhwDcMKpVSP
 AAwuDpZW8mEghBQKJXTcrojf3l5DiOFTj6Z/hRPELctygYmKOxqDrr9GLWPsIYm094qi
 IOpH5F7Ex36yPu5jdMQNcVLsQ+ePyT41+S9Df0QQ6H1+9kX7uxdU3Fm5nlrsEVBGHMHj
 DDWUYplrA9rMgTvIwH9LSQkK1sa2aRpXCCa/GSuBz4lkk4MycLL5tMA60Ghjs06yJO/2 RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3091m0s0sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03851W8H100632;
        Wed, 8 Apr 2020 05:05:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3091m2hv9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:23 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855MKx007459;
        Wed, 8 Apr 2020 05:05:22 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:22 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 17/26] x86/alternatives: Add patching logic in text_poke_site()
Date:   Tue,  7 Apr 2020 22:03:14 -0700
Message-Id: <20200408050323.4237-18-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add actual poking and pipeline sync logic in poke_sync(). This is called
from text_poke_site()).

The patching logic is similar to that in text_poke_bp_batch() where we
patch the first byte with an INT3, which serves as a barrier, then patch
the remaining bytes and then come back and fixup the first byte.

The first and the last steps are single byte writes and are thus
atomic, and the second step is protected because the INT3 serves
as a barrier.

Between each of these steps is a global pipeline sync which ensures that
remote pipelines flush out any stale opcodes that they might have cached.
This is driven from poke_sync() where the primary introduces a sync_core()
on secondary CPUs for every PATCH_SYNC_* state change. The corresponding
loop on the secondary executes in text_poke_sync_site().

Note that breakpoints are not handled yet.

 CPU0                                CPUx
 ----                                ----

 patch_worker()                      patch_worker()

   /* Traversal, insn-gen */           text_poke_sync_finish()
   tps.patch_worker()                    /* wait until:
     /* = paravirt_worker() */            *  tps->state == PATCH_DONE
                                          */
                  /* for each patch-site */
     generate_paravirt()
       runtime_patch()
     text_poke_site()                    text_poke_sync_site()
        poke_sync()                       /* for each:
          __text_do_poke()                 *  PATCH_SYNC_[012] */
          sync_one()                       sync_one()
          ack()                            ack()
          wait_for_acks()

           ...                                 ...

  smp_store_release(&tps->state, PATCH_DONE)

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/kernel/alternative.c | 103 +++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1c5acdc4f349..7fdaae9edbf0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1441,27 +1441,57 @@ struct text_poke_state {
 
 static struct text_poke_state text_poke_state;
 
+static void wait_for_acks(struct text_poke_state *tps)
+{
+	int cpu = smp_processor_id();
+
+	cpumask_set_cpu(cpu, &tps->sync_ack_map);
+
+	/* Wait until all CPUs are known to have observed the state change. */
+	while (cpumask_weight(&tps->sync_ack_map) < tps->num_acks)
+		cpu_relax();
+}
+
 /**
- * poke_sync() - transitions to the specified state.
+ * poke_sync() - carries out one poke-step for a single site and
+ * transitions to the specified state.
+ * Called with the target populated in poking_mm and poking_addr.
  *
  * @tps - struct text_poke_state *
  * @state - one of PATCH_SYNC_* states
  * @offset - offset to be patched
  * @insns - insns to write
  * @len - length of insn sequence
+ *
+ * Returns after all CPUs have observed the state change and called
+ * sync_core().
  */
 static void poke_sync(struct text_poke_state *tps, int state, int offset,
 		      const char *insns, int len)
 {
+	if (len)
+		__text_do_poke(offset, insns, len);
 	/*
-	 * STUB: no patching or synchronization, just go through the
-	 * motions.
+	 * Stores to tps.sync_ack_map are ordered with
+	 * smp_load_acquire(tps->state) in text_poke_sync_site()
+	 * so we can safely clear the cpumask.
 	 */
 	smp_store_release(&tps->state, state);
+
+	cpumask_clear(&tps->sync_ack_map);
+
+	/*
+	 * Introduce a synchronizing instruction in local and remote insn
+	 * streams. This flushes any stale cached uops from CPU pipelines.
+	 */
+	sync_one();
+
+	wait_for_acks(tps);
 }
 
 /**
  * text_poke_site() - called on the primary to patch a single call site.
+ * The interlocking sync work on the secondary is done in text_poke_sync_site().
  *
  * Called in thread context with tps->state == PATCH_SYNC_DONE where it
  * takes tps->state through different PATCH_SYNC_* states, returning
@@ -1514,6 +1544,43 @@ static void __maybe_unused text_poke_site(struct text_poke_state *tps,
 			  &prev_mm, ptep);
 }
 
+/**
+ * text_poke_sync_site() -- called to synchronize the CPU pipeline
+ * on secondary CPUs for each patch site.
+ *
+ * Called in thread context with tps->state == PATCH_SYNC_0.
+ *
+ * Returns after having observed tps->state == PATCH_SYNC_DONE.
+ */
+static void text_poke_sync_site(struct text_poke_state *tps)
+{
+	int cpu = smp_processor_id();
+	int prevstate = -1;
+	int acked;
+
+	/*
+	 * In thread context we arrive here expecting tps->state to move
+	 * in-order from PATCH_SYNC_{0 -> 1 -> 2} -> PATCH_SYNC_DONE.
+	 */
+	do {
+		/*
+		 * Wait until there's some work for us to do.
+		 */
+		smp_cond_load_acquire(&tps->state,
+				      prevstate != VAL);
+
+		prevstate = READ_ONCE(tps->state);
+
+		if (prevstate < PATCH_SYNC_DONE) {
+			acked = cpumask_test_cpu(cpu, &tps->sync_ack_map);
+
+			BUG_ON(acked);
+			sync_one();
+			cpumask_set_cpu(cpu, &tps->sync_ack_map);
+		}
+	} while (prevstate < PATCH_SYNC_DONE);
+}
+
 /**
  * text_poke_sync_finish() -- called to synchronize the CPU pipeline
  * on secondary CPUs for all patch sites.
@@ -1525,6 +1592,7 @@ static void text_poke_sync_finish(struct text_poke_state *tps)
 {
 	while (true) {
 		enum patch_state state;
+		int cpu = smp_processor_id();
 
 		state = READ_ONCE(tps->state);
 
@@ -1535,11 +1603,24 @@ static void text_poke_sync_finish(struct text_poke_state *tps)
 		if (state == PATCH_DONE)
 			break;
 
-		/*
-		 * Relax here while the primary makes up its mind on
-		 * whether it is done or not.
-		 */
-		cpu_relax();
+		if (state == PATCH_SYNC_DONE) {
+			/*
+			 * Ack that we've seen the end of this iteration
+			 * and then wait until everybody's ready to move
+			 * to the next iteration or exit.
+			 */
+			cpumask_set_cpu(cpu, &tps->sync_ack_map);
+			smp_cond_load_acquire(&tps->state,
+					      (state != VAL));
+		} else if (state == PATCH_SYNC_0) {
+			/*
+			 * PATCH_SYNC_1, PATCH_SYNC_2 are handled
+			 * inside text_poke_sync_site().
+			 */
+			text_poke_sync_site(tps);
+		} else {
+			BUG();
+		}
 	}
 }
 
@@ -1549,6 +1630,12 @@ static int patch_worker(void *t)
 	struct text_poke_state *tps = t;
 
 	if (cpu == tps->primary_cpu) {
+		/*
+		 * The init state is PATCH_SYNC_DONE. Wait until the
+		 * secondaries have assembled before we start patching.
+		 */
+		wait_for_acks(tps);
+
 		/*
 		 * Generates insns and calls text_poke_site() to do the poking
 		 * and sync.
-- 
2.20.1

