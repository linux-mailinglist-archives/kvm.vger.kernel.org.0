Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7088B1A1B32
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDHFFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38574 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgDHFFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853ldS191183;
        Wed, 8 Apr 2020 05:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BeFWvYA7XIlpPY3jCn3WOorYd4LJtWrT9UyxM8q4o68=;
 b=auE3HQCWrQ+mTWzjzKVzofN4aU72M02C0tq5tNvEj4eZaVcWC6iqezU+lJkUo5962rlA
 4ZF60eMjEPMJ/A+8xOPnVl/EcZMjVmy4P1EQt2LIUz1XimSSpXMqTTHEoyRPWWueCrSf
 dtyPCZWNXf9wQpZMuGhmod9YAnk8TApPTY89QWpUzPyBn9D9WOLqI17P+nDESrlNKk6o
 8EzKhFq6WMDGbcm8hkad6UGs+rc7rm+V1z6dR9vdiS1flnJyUIY05WrkQ4GntkRrYyB3
 U2JU5+ly+cjPGtpBoV6957nPGgXe4v3R7Y0Qx/scVGjvo/UwzNxEdXC/XsDjF6GrmEoA /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3091m0s0su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852YOP062381;
        Wed, 8 Apr 2020 05:05:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3091mh1kq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855KuN030519;
        Wed, 8 Apr 2020 05:05:20 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:20 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 15/26] x86/alternatives: Non-emulated text poking
Date:   Tue,  7 Apr 2020 22:03:12 -0700
Message-Id: <20200408050323.4237-16-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
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

Patching at runtime needs to handle interdependent pv-ops: as an example,
lock.queued_lock_slowpath(), lock.queued_lock_unlock() and the other
pv_lock_ops are paired and so need to be updated atomically. This is
difficult with emulation because non-patching CPUs could be executing in
critical sections.
(We could apply INT3 everywhere first and then use RCU to force a
barrier but given that spinlocks are everywhere, it still might mean a
lot of time in emulation.)

Second, locking operations can be called from interrupt handlers which
means we cannot trivially use IPIs to introduce a pipeline sync step on
non-patching CPUs.

Third, some pv-ops can be inlined and so we would need to emulate a
broader set of operations than CALL, JMP, NOP*.

Introduce the core state-machine with the actual poking and pipeline
sync stubbed out. This executes via stop_machine() with the primary CPU
carrying out a text_poke_bp() style three-staged algorithm.

The control flow diagram below shows CPU0 as the primary which does the
patching, while the rest of the CPUs (CPUx) execute the sync loop in
text_poke_sync_finish().

 CPU0				    CPUx
 ----                               ----

 patch_worker()			    patch_worker()

   /* Traversal, insn-gen */	      text_poke_sync_finish()
   tps.patch_worker()		      /*
  				       * wait until:
     /* for each patch-site */ 	       *  tps->state == PATCH_DONE
     text_poke_site()		       */
       poke_sync()

  	   ...				       ...

   smp_store_release(&tps->state, PATCH_DONE)

Commits further on flesh out the rest of the code.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
sync_one() uses the following for pipeline synchronization:

+       if (in_nmi())
+               cpuid_eax(1);
+       else
+               sync_core();

The if (in_nmi()) clause is meant to be executed from NMI contexts.
Reading through past LKML discussions cpuid_eax() is probably a
bad choice -- at least in so far as Xen PV is concerned. What
would be a good primitive to use insead?

Also, given that we do handle the nested NMI case, does it make sense
to just use native_iret() (via sync_core()) in NMI contexts well?

---
 arch/x86/kernel/alternative.c | 247 ++++++++++++++++++++++++++++++++++
 1 file changed, 247 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 004fe86f463f..452d4081eded 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -979,6 +979,26 @@ void text_poke_sync(void)
 	on_each_cpu(do_sync_core, NULL, 1);
 }
 
+static void __maybe_unused sync_one(void)
+{
+	/*
+	 * We might be executing in NMI context, and so cannot use
+	 * IRET as a synchronizing instruction.
+	 *
+	 * We could use native_write_cr2() but that is not guaranteed
+	 * to work on Xen-PV -- it is emulated by Xen and might not
+	 * execute an iret (or similar synchronizing instruction)
+	 * internally.
+	 *
+	 * cpuid() would trap as well. Unclear if that's a solution
+	 * either.
+	 */
+	if (in_nmi())
+		cpuid_eax(1);
+	else
+		sync_core();
+}
+
 struct text_poke_loc {
 	s32 rel_addr; /* addr := _stext + rel_addr */
 	union {
@@ -1351,6 +1371,233 @@ void __ref text_poke_bp(void *addr, const void *opcode, size_t len, const void *
 	text_poke_bp_batch(&tp, 1);
 }
 
+struct text_poke_state;
+typedef void (*patch_worker_t)(struct text_poke_state *tps);
+
+/*
+ *                        +-----------possible-BP----------+
+ *                        |                                |
+ *         +--write-INT3--+   +--suffix--+   +-insn-prefix-+
+ *        /               | _/           |__/              |
+ *       /                v'             v                 v
+ * PATCH_SYNC_0    PATCH_SYNC_1    PATCH_SYNC_2   *PATCH_SYNC_DONE*
+ *       \                                                    |`----> PATCH_DONE
+ *        `----------<---------<---------<---------<----------+
+ *
+ * We start in state PATCH_SYNC_DONE and loop through PATCH_SYNC_* states
+ * to end at PATCH_DONE. The primary drives these in text_poke_site()
+ * with patch_worker() making the final transition to PATCH_DONE.
+ * All transitions but the last iteration need to be globally observed.
+ *
+ * On secondary CPUs, text_poke_sync_finish() waits in a cpu_relax()
+ * loop waiting for a transition to PATCH_SYNC_0 at which point it would
+ * start observing transitions until PATCH_SYNC_DONE.
+ * Eventually the master moves to PATCH_DONE and secondary CPUs finish.
+ */
+enum patch_state {
+	/*
+	 * Add an artificial state that we can do a bitwise operation
+	 * over all the PATCH_SYNC_* states.
+	 */
+	PATCH_SYNC_x = 4,
+	PATCH_SYNC_0 = PATCH_SYNC_x | 0,	/* Serialize INT3 */
+	PATCH_SYNC_1 = PATCH_SYNC_x | 1,	/* Serialize rest */
+	PATCH_SYNC_2 = PATCH_SYNC_x | 2,	/* Serialize first opcode */
+	PATCH_SYNC_DONE = PATCH_SYNC_x | 3,	/* Site done, and start state */
+
+	PATCH_DONE = 8,				/* End state */
+};
+
+/*
+ * State for driving text-poking via stop_machine().
+ */
+struct text_poke_state {
+	/* Whatever we are poking */
+	void *stage;
+
+	/* Modules to be processed. */
+	struct list_head *head;
+
+	/*
+	 * Accesses to sync_ack_map are ordered by the primary
+	 * via tps.state.
+	 */
+	struct cpumask sync_ack_map;
+
+	/*
+	 * Generates insn sequences for call-sites to be patched and
+	 * calls text_poke_site() to do the actual poking.
+	 */
+	patch_worker_t	patch_worker;
+
+	/*
+	 * Where are we in the patching state-machine.
+	 */
+	enum patch_state state;
+
+	unsigned int primary_cpu; /* CPU doing the patching. */
+	unsigned int num_acks; /* Number of Acks needed. */
+};
+
+static struct text_poke_state text_poke_state;
+
+/**
+ * poke_sync() - transitions to the specified state.
+ *
+ * @tps - struct text_poke_state *
+ * @state - one of PATCH_SYNC_* states
+ * @offset - offset to be patched
+ * @insns - insns to write
+ * @len - length of insn sequence
+ */
+static void poke_sync(struct text_poke_state *tps, int state, int offset,
+		      const char *insns, int len)
+{
+	/*
+	 * STUB: no patching or synchronization, just go through the
+	 * motions.
+	 */
+	smp_store_release(&tps->state, state);
+}
+
+/**
+ * text_poke_site() - called on the primary to patch a single call site.
+ *
+ * Returns after switching tps->state to PATCH_SYNC_DONE.
+ */
+static void __maybe_unused text_poke_site(struct text_poke_state *tps,
+					  struct text_poke_loc *tp)
+{
+	const unsigned char int3 = INT3_INSN_OPCODE;
+	temp_mm_state_t prev_mm;
+	pte_t *ptep;
+	int offset;
+
+	__text_poke_map(text_poke_addr(tp), tp->native.len, &prev_mm, &ptep);
+
+	offset = offset_in_page(text_poke_addr(tp));
+
+	/*
+	 * All secondary CPUs are waiting in tps->state == PATCH_SYNC_DONE
+	 * to move to PATCH_SYNC_0. Poke the INT3 and wait until all CPUs
+	 * are known to have observed PATCH_SYNC_0.
+	 *
+	 * The earliest we can hit an INT3 is just after the first poke.
+	 */
+	poke_sync(tps, PATCH_SYNC_0, offset, &int3, INT3_INSN_SIZE);
+
+	/* Poke remaining */
+	poke_sync(tps, PATCH_SYNC_1, offset + INT3_INSN_SIZE,
+		  tp->text + INT3_INSN_SIZE, tp->native.len - INT3_INSN_SIZE);
+
+	/*
+	 * Replace the INT3 with the first opcode and force the serializing
+	 * instruction for the last time. Any secondaries in the BP
+	 * handler should be able to move past the INT3 handler after this.
+	 * (See poke_int3_native() for details on this.)
+	 */
+	poke_sync(tps, PATCH_SYNC_2, offset, tp->text, INT3_INSN_SIZE);
+
+	/*
+	 * Force all CPUS to observe PATCH_SYNC_DONE (in the BP handler or
+	 * in text_poke_site()), so they know that this iteration is done
+	 * and it is safe to exit the wait-until-a-sync-is-required loop.
+	 */
+	poke_sync(tps, PATCH_SYNC_DONE, 0, NULL, 0);
+
+	/*
+	 * Unmap the poking_addr, poking_mm.
+	 */
+	__text_poke_unmap(text_poke_addr(tp), tp->text, tp->native.len,
+			  &prev_mm, ptep);
+}
+
+/**
+ * text_poke_sync_finish() -- called to synchronize the CPU pipeline
+ * on secondary CPUs for all patch sites.
+ *
+ * Called in thread context with tps->state == PATCH_SYNC_DONE.
+ * Returns with tps->state == PATCH_DONE.
+ */
+static void text_poke_sync_finish(struct text_poke_state *tps)
+{
+	while (true) {
+		enum patch_state state;
+
+		state = READ_ONCE(tps->state);
+
+		/*
+		 * We aren't doing any actual poking yet, so we don't
+		 * handle any other states.
+		 */
+		if (state == PATCH_DONE)
+			break;
+
+		/*
+		 * Relax here while the primary makes up its mind on
+		 * whether it is done or not.
+		 */
+		cpu_relax();
+	}
+}
+
+static int patch_worker(void *t)
+{
+	int cpu = smp_processor_id();
+	struct text_poke_state *tps = t;
+
+	if (cpu == tps->primary_cpu) {
+		/*
+		 * Generates insns and calls text_poke_site() to do the poking
+		 * and sync.
+		 */
+		tps->patch_worker(tps);
+
+		/*
+		 * We are done patching. Switch the state to PATCH_DONE
+		 * so the secondaries can exit.
+		 */
+		smp_store_release(&tps->state, PATCH_DONE);
+	} else {
+		/* Secondary CPUs spin in a sync_core() state-machine. */
+		text_poke_sync_finish(tps);
+	}
+	return 0;
+}
+
+/**
+ * text_poke_late() -- late patching via stop_machine().
+ *
+ * Called holding the text_mutex.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage)
+{
+	int ret;
+
+	lockdep_assert_held(&text_mutex);
+
+	if (system_state != SYSTEM_RUNNING)
+		return -EINVAL;
+
+	text_poke_state.stage = stage;
+	text_poke_state.num_acks = cpumask_weight(cpu_online_mask);
+	text_poke_state.head = &alt_modules;
+
+	text_poke_state.patch_worker = worker;
+	text_poke_state.state = PATCH_SYNC_DONE; /* Start state */
+	text_poke_state.primary_cpu = smp_processor_id();
+
+	/*
+	 * Run the worker on all online CPUs. Don't need to do anything
+	 * for offline CPUs as they come back online with a clean cache.
+	 */
+	ret = stop_machine(patch_worker, &text_poke_state, cpu_online_mask);
+
+	return ret;
+}
+
 #ifdef CONFIG_PARAVIRT_RUNTIME
 struct paravirt_stage_entry {
 	void *dest;	/* pv_op destination */
-- 
2.20.1

