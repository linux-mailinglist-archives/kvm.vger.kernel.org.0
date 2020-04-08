Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087851A1B52
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgDHFFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHFFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853tXe191207;
        Wed, 8 Apr 2020 05:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=CcwUPFYBMcHTPmOlaOoTSoN9P8fiON3G468Rwi+IExw=;
 b=PWi7i/Tl/Y/4IqFE9IYynQEmMUAL6h7KzUdGeQ8aowN7A2vG8aYJ2y1RPUpSFuJ3Al9p
 YwS1TqaOr8c7YrFYOyShMVhWKNWUtudifHat6cRswuPKLXRwcDy1ydKrAXiPIjl6lopM
 RMjHL24gyXWl/nW8A2qcjwXVsP1PZ3/0r+Im3dLJe5hFqWgI0VDvD9B0ICCD6mvtFn3w
 T50v9VWj4ITUUPDhFU4ejXZXdJYGwsLCualChOYeup/fi8BrQuX5+Iys4L4ZzuqJoJTd
 s99H+9vRPTV9un6VQffzowPsPPsbizyuvOJDx6hBeNIF4jIAX6jEt3+aYp275E6ry4xO kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3091m0s0sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852gSW148301;
        Wed, 8 Apr 2020 05:05:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3091kgj7gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855OXP030617;
        Wed, 8 Apr 2020 05:05:24 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:23 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 18/26] x86/alternatives: Handle BP in non-emulated text poking
Date:   Tue,  7 Apr 2020 22:03:15 -0700
Message-Id: <20200408050323.4237-19-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
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

Handle breakpoints if we hit an INT3 either by way of an NMI while
patching a site in the NMI handling path, or if we are patching text
in text_poke_site() (executes on the primary), or in the pipeline sync
path in text_poke_sync_site() (executes on secondary CPUs.)
(The last two are not expected to happen, but see below.)

The handling on the primary CPU is to update the insn stream locally
such that we can return to the primary patching loop but not force
the secondary CPUs to execute sync_core().

From my reading of the Intel spec and the thread which laid down the
INT3 approach: https//lore.kernel.org/lkml/4B4D02B8.5020801@zytor.com,
skipping the sync_core() would mean that remote pipelines -- if they
have relevant uops cached would not see the updated instruction and
would continue to execute stale uops.

This is safe because the primary eventually gets back to the patching
loop in text_poke_site() and resumes the state-machine, re-writing
some of the insn sequences just written in the BP handling and forcing
the secondary CPUs to execute sync_core().

The handling on the secondary, is to call text_poke_sync_site() just as
in thread-context, so it contains acking the patch states such that the
primary can continue making forward progress. This can be called in a
re-entrant fashion.

Note that this does mean that we cannot handle any patches in
text_poke_sync_site() itself since that would end up being called
recursively in the BP handler.

Control flow diagram with the BP handler:

 CPU0-BP                             CPUx-BP
 -------                             -------

 poke_int3_native()                  poke_int3_native()
   __text_do_poke()         	       text_poke_sync_site()
   sync_one()               	        /* for state in:
                                         *  [PATCH_SYNC_y.._SYNC_DONE) */
                                         sync_one()
                                         ack()


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
        poke_sync()                       /* for state in:
          __text_do_poke()                 *  [PATCH_SYNC_0..PATCH_SYNC_y]
          sync_one()                       */
          ack()                            sync_one()
          wait_for_acks()                  ack()

           ...                                 ...

   smp_store_release(&tps->state, PATCH_DONE)

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/kernel/alternative.c | 145 ++++++++++++++++++++++++++++++++--
 1 file changed, 137 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7fdaae9edbf0..c68d940356a2 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1055,6 +1055,8 @@ static int notrace patch_cmp(const void *key, const void *elt)
 }
 NOKPROBE_SYMBOL(patch_cmp);
 
+static void poke_int3_native(struct pt_regs *regs,
+			     struct text_poke_loc *tp);
 int notrace poke_int3_handler(struct pt_regs *regs)
 {
 	struct bp_patching_desc *desc;
@@ -1099,8 +1101,11 @@ int notrace poke_int3_handler(struct pt_regs *regs)
 			goto out_put;
 	}
 
-	if (desc->native)
-		BUG();
+	if (desc->native) {
+		poke_int3_native(regs, tp);
+		ret = 1; /* handled */
+		goto out_put;
+	}
 
 	len = text_opcode_size(tp->emulated.opcode);
 	ip += len;
@@ -1469,8 +1474,15 @@ static void wait_for_acks(struct text_poke_state *tps)
 static void poke_sync(struct text_poke_state *tps, int state, int offset,
 		      const char *insns, int len)
 {
-	if (len)
+	if (len) {
+		/*
+		 * Note that we could hit a BP right after patching memory
+		 * below. This could happen before the state change further
+		 * down. The primary BP handler allows us to make
+		 * forward-progress in that case.
+		 */
 		__text_do_poke(offset, insns, len);
+	}
 	/*
 	 * Stores to tps.sync_ack_map are ordered with
 	 * smp_load_acquire(tps->state) in text_poke_sync_site()
@@ -1504,11 +1516,22 @@ static void __maybe_unused text_poke_site(struct text_poke_state *tps,
 	temp_mm_state_t prev_mm;
 	pte_t *ptep;
 	int offset;
+	struct bp_patching_desc desc = {
+		.vec = tp,
+		.nr_entries = 1,
+		.native = true,
+		.refs = ATOMIC_INIT(1),
+	};
 
 	__text_poke_map(text_poke_addr(tp), tp->native.len, &prev_mm, &ptep);
 
 	offset = offset_in_page(text_poke_addr(tp));
 
+	/*
+	 * For INT3 use the same exclusion logic as BP emulation path.
+	 */
+	smp_store_release(&bp_desc, &desc); /* rcu_assign_pointer */
+
 	/*
 	 * All secondary CPUs are waiting in tps->state == PATCH_SYNC_DONE
 	 * to move to PATCH_SYNC_0. Poke the INT3 and wait until all CPUs
@@ -1537,6 +1560,19 @@ static void __maybe_unused text_poke_site(struct text_poke_state *tps,
 	 */
 	poke_sync(tps, PATCH_SYNC_DONE, 0, NULL, 0);
 
+	/*
+	 * All CPUs have ack'd PATCH_SYNC_DONE. So there can be no
+	 * laggard CPUs executing BP handlers. Reset bp_desc.
+	 */
+	WRITE_ONCE(bp_desc, NULL); /* RCU_INIT_POINTER */
+
+	/*
+	 * We've already done the synchronization so this should not
+	 * race.
+	 */
+	if (!atomic_dec_and_test(&desc.refs))
+		atomic_cond_read_acquire(&desc.refs, !VAL);
+
 	/*
 	 * Unmap the poking_addr, poking_mm.
 	 */
@@ -1548,7 +1584,8 @@ static void __maybe_unused text_poke_site(struct text_poke_state *tps,
  * text_poke_sync_site() -- called to synchronize the CPU pipeline
  * on secondary CPUs for each patch site.
  *
- * Called in thread context with tps->state == PATCH_SYNC_0.
+ * Called in thread context with tps->state == PATCH_SYNC_0 and in
+ * BP context with tps->state < PATCH_SYNC_DONE.
  *
  * Returns after having observed tps->state == PATCH_SYNC_DONE.
  */
@@ -1561,6 +1598,26 @@ static void text_poke_sync_site(struct text_poke_state *tps)
 	/*
 	 * In thread context we arrive here expecting tps->state to move
 	 * in-order from PATCH_SYNC_{0 -> 1 -> 2} -> PATCH_SYNC_DONE.
+	 *
+	 * We could also arrive here in BP-context some point after having
+	 * observed bp_patching.nr_entries (and after poking the first INT3.)
+	 * This could happen by way of an NMI while we are patching a site
+	 * that'll get executed in the NMI handler, or if we hit a site
+	 * being patched in text_poke_sync_site().
+	 *
+	 * Just as thread-context, the BP handler calls text_poke_sync_site()
+	 * to keep the primary's state-machine moving forward until it has
+	 * finished patching the call-site. At that point it is safe to
+	 * unwind the contexts.
+	 *
+	 * The second case, where we are patching a site in
+	 * text_poke_sync_site(), could end up in recursive BP handlers
+	 * and is not handled.
+	 *
+	 * Note that unlike thread-context where the start state can only
+	 * be PATCH_SYNC_0, in the BP-context, the start state could be any
+	 * PATCH_SYNC_x, so long as (state < PATCH_SYNC_DONE) since once a
+	 * CPU has acked PATCH_SYNC_2, there is no INT3 left for it to observe.
 	 */
 	do {
 		/*
@@ -1571,16 +1628,88 @@ static void text_poke_sync_site(struct text_poke_state *tps)
 
 		prevstate = READ_ONCE(tps->state);
 
-		if (prevstate < PATCH_SYNC_DONE) {
-			acked = cpumask_test_cpu(cpu, &tps->sync_ack_map);
-
-			BUG_ON(acked);
+		/*
+		 * As described above, text_poke_sync_site() gets called
+		 * from both thread-context and potentially in a re-entrant
+		 * fashion in BP-context. Accordingly expect to potentially
+		 * enter and exit this loop twice.
+		 *
+		 * Concretely, this means we need to handle the case where we
+		 * see an already acked state at BP/NMI entry and, see a
+		 * state discontinuity when returning to thread-context from
+		 * BP-context which would return after having observed
+		 * tps->state == PATCH_SYNC_DONE.
+		 *
+		 * Help this along by always exiting with tps->state ==
+		 * PATCH_SYNC_DONE but without acking it. Not acking it in
+		 * text_poke_sync_site(), guarantees that the state can only
+		 * forward once all secondary CPUs have exited both thread
+		 * and BP-contexts.
+		 */
+		acked = cpumask_test_cpu(cpu, &tps->sync_ack_map);
+		if (prevstate < PATCH_SYNC_DONE && !acked) {
 			sync_one();
 			cpumask_set_cpu(cpu, &tps->sync_ack_map);
 		}
 	} while (prevstate < PATCH_SYNC_DONE);
 }
 
+static void poke_int3_native(struct pt_regs *regs,
+			     struct text_poke_loc *tp)
+{
+	int cpu = smp_processor_id();
+	struct text_poke_state *tps = &text_poke_state;
+
+	if (cpu != tps->primary_cpu) {
+		/*
+		 * We came here from the sync loop in text_poke_sync_site().
+		 * Continue syncing. The primary is waiting.
+		 */
+		text_poke_sync_site(tps);
+	} else {
+		int offset = offset_in_page(text_poke_addr(tp));
+
+		/*
+		 * We are in the primary context and have hit the INT3 barrier
+		 * either ourselves or via an NMI.
+		 *
+		 * The secondary CPUs at this time are either in the original
+		 * text_poke_sync_site() loop or after having hit an NMI->INT3
+		 * themselves in the BP text_poke_sync_site() loop.
+		 *
+		 * The minimum that we need to do here is to update the local
+		 * insn stream such that we can return to the primary loop.
+		 * Without executing sync_core() on the secondary CPUs it is
+		 * possible that some of them might be executing stale uops in
+		 * their respective pipelines.
+		 *
+		 * This should be safe because we will get back to the patching
+		 * loop in text_poke_site() in due course and will resume
+		 * the state-machine where we left off including by re-writing
+		 * some of the insns sequences just written here.
+		 *
+		 * Note that we continue to be in poking_mm context and so can
+		 * safely call __text_do_poke() here.
+		 */
+		__text_do_poke(offset + INT3_INSN_SIZE,
+			       tp->text + INT3_INSN_SIZE,
+			       tp->native.len - INT3_INSN_SIZE);
+		__text_do_poke(offset, tp->text, INT3_INSN_SIZE);
+
+		/*
+		 * We only introduce a serializing instruction locally. As
+		 * noted above, the secondary CPUs can stay where they are --
+		 * potentially executing in the now stale INT3.) This is fine
+		 * because the primary will force the sync_core() on the
+		 * secondary CPUs once it returns.
+		 */
+		sync_one();
+	}
+
+	/* A new start */
+	regs->ip -= INT3_INSN_SIZE;
+}
+
 /**
  * text_poke_sync_finish() -- called to synchronize the CPU pipeline
  * on secondary CPUs for all patch sites.
-- 
2.20.1

