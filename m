Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8D01A1B4E
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgDHFFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgDHFFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03854HmH012943;
        Wed, 8 Apr 2020 05:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=3KrJyMdl6FuU/9RrwZPu8LutFkDCWnKoiuaiLyLQY8k=;
 b=Nz0B0/o9yL4G/oeYKXgml5AlpwAqrxs9OSYyfd/2t3KASsuXVslfpk3aV4siEspeImVv
 hF5mZp00cKk33qyWWIWzgx7Z/2TQbCIg4+L+xdwnRQHABYbAaX8eoRfCCmAuRRNxd8Yw
 b9h2KmNAKrdNawOdsrEQ9YaTpzcLbV4+S29wLj8mtcKjr+8OuLKxgVlpROe8Uc7ntEYy
 plZiZePsltN5gQ4IzVpPOcYcmZwK2LMz2g5CfWO4pPFGbQEi7yhGvMUP7T5/BxCphx9t
 ZQkM0P06aEe4dKlyv9maop2wZsC0FwJjCcQC7CvJv65TbINE/KWXveQRy4d4cNgM292g JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m390xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03851WbQ100696;
        Wed, 8 Apr 2020 05:05:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3091m2hvdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855PX9030620;
        Wed, 8 Apr 2020 05:05:25 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:25 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 19/26] x86/alternatives: NMI safe runtime patching
Date:   Tue,  7 Apr 2020 22:03:16 -0700
Message-Id: <20200408050323.4237-20-ankur.a.arora@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Runtime patching can deadlock with multiple simultaneous NMIs.
This can happen while patching inter-dependent pv-ops which are
used in the NMI path (ex pv_lock_ops):

 CPU0   			    CPUx
 ----                               ----

 patch_worker()                     patch_worker()

   /* Traversal, insn-gen */          text_poke_sync_finish()
   tps.patch_worker()                   /* wait until:
     /* = paravirt_worker() */           *  tps->state == PATCH_DONE
                                         */
           /* start-patching:lock.spin_unlock */
      generate_paravirt()
        runtime_patch()

      text_poke_site()                  text_poke_sync_site()
        poke_sync()                      /* for state in:
          __text_do_poke()                *  PATCH_SYNC_[012]
	  ==NMI==                         */
	                                 ==NMI==
         tries-to-acquire:nmi_lock       acquires:nmi_lock
                                         tries-to-release:nmi_lock
					 ==BP==
   				         text_poke_sync_site()

      /* waiting-for:nmi_lock */    /* waiting-for:patched-spin_unlock() */

A similar deadlock exists if two secondary CPUs get an NMI as well.

Fix this by patching NMI-unsafe ops in an NMI context. Given that the
NMI entry code ensures that NMIs do not nest, we are guaranteed that
this can be done atomically.

We do this by registering a local NMI handler (text_poke_nmi()) and
triggering a local NMI on the primary (via patch_worker_nmi()) which
then calls the same worker (tps->patch_worker()) as in thread-context.

On the secondary, we continue with the pipeline sync loop (via
text_poke_sync_finish()) in thread-context; however, if there is an
NMI on the secondary, we call text_poke_sync_finish() in the handler
which continues the work that was being done in thread-context.

Also note that text_poke_nmi() always executes first so we know that
it takes priority over any arbitrary code executing in the installed
NMI handlers.

 CPU0                                CPUx
 ----                                ----

 patch_worker(nmi=true)              patch_worker(nmi=true)

   patch_worker_nmi() -> triggers NMI   text_poke_sync_finish()
   /* wait for return from NMI */         /* wait until:
            ...                            *  tps->state == PATCH_DONE
                                           */

   smp_store_release(&tps->state,
                     PATCH_DONE)
                                          /* for each patch-site */

                                          text_poke_sync_site()
 CPU0-NMI                                 /* for each:
 --------                                  *  PATCH_SYNC_[012]
                                           */
 text_poke_nmi()                            sync_one()
   /* Traversal, insn-gen */                ack()
   tps.patch_worker()
   /* = paravirt_worker() */                ...

   /* for each patch-site */

     generate_paravirt()
       runtime_patch()

     text_poke_site()
       poke_sync()
         __text_do_poke()
         sync_one()
         ack()
         wait_for_acks()

          ...


Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/text-patching.h |   2 +-
 arch/x86/kernel/alternative.c        | 120 ++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e86709a8287e..9ba329bf9479 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -22,7 +22,7 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_runtime	NULL
 #define __parainstructions_runtime_end	NULL
 #else
-int paravirt_runtime_patch(void);
+int paravirt_runtime_patch(bool nmi);
 #endif
 
 /*
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c68d940356a2..385c3e6ea925 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1442,6 +1442,14 @@ struct text_poke_state {
 
 	unsigned int primary_cpu; /* CPU doing the patching. */
 	unsigned int num_acks; /* Number of Acks needed. */
+
+	/*
+	 * To synchronize with the NMI handler.
+	 */
+	atomic_t nmi_work;
+
+	/* Ensure this is patched atomically against NMIs. */
+	bool nmi_context;
 };
 
 static struct text_poke_state text_poke_state;
@@ -1715,6 +1723,7 @@ static void poke_int3_native(struct pt_regs *regs,
  * on secondary CPUs for all patch sites.
  *
  * Called in thread context with tps->state == PATCH_SYNC_DONE.
+ * Also might be called from NMI context with an arbitrary tps->state.
  * Returns with tps->state == PATCH_DONE.
  */
 static void text_poke_sync_finish(struct text_poke_state *tps)
@@ -1741,6 +1750,12 @@ static void text_poke_sync_finish(struct text_poke_state *tps)
 			cpumask_set_cpu(cpu, &tps->sync_ack_map);
 			smp_cond_load_acquire(&tps->state,
 					      (state != VAL));
+		} else if (in_nmi() && (state & PATCH_SYNC_x)) {
+			/*
+			 * Called in case of NMI so we should be ready
+			 * to be called with any PATCH_SYNC_x.
+			 */
+			text_poke_sync_site(tps);
 		} else if (state == PATCH_SYNC_0) {
 			/*
 			 * PATCH_SYNC_1, PATCH_SYNC_2 are handled
@@ -1753,6 +1768,91 @@ static void text_poke_sync_finish(struct text_poke_state *tps)
 	}
 }
 
+/*
+ * text_poke_nmi() - primary CPU comes here (via self NMI) and the
+ * secondary (if there's an NMI.)
+ *
+ * By placing this NMI handler first, we can restrict execution of any
+ * NMI code that might be under patching.
+ * Local NMI handling also does not go through any locking code so it
+ * should be safe to install one.
+ *
+ * In both these roles the state-machine is identical to the one that
+ * we had in task context.
+ */
+static int text_poke_nmi(unsigned int val, struct pt_regs *regs)
+{
+	int ret, cpu = smp_processor_id();
+	struct text_poke_state *tps = &text_poke_state;
+
+	/*
+	 * We came here because there's a text-poke handler
+	 * installed. Get out if there's no work assigned yet.
+	 */
+	if (atomic_read(&tps->nmi_work) == 0)
+		return NMI_DONE;
+
+	if (cpu == tps->primary_cpu) {
+		/*
+		 * Do what we came here for. We can safely patch: any
+		 * secondary CPUs executing in NMI context have been
+		 * captured in the code below and are doing useful
+		 * work.
+		 */
+		tps->patch_worker(tps);
+
+		/*
+		 * Both the primary and the secondary CPUs are done (in NMI
+		 * or thread context.) Mark work done so any future NMIs can
+		 * skip this and go to the real handler.
+		 */
+		atomic_dec(&tps->nmi_work);
+
+		/*
+		 * The NMI was self-induced, consume it.
+		 */
+		ret = NMI_HANDLED;
+	} else {
+		/*
+		 * Unexpected NMI on a secondary CPU: do sync_core()
+		 * work until done.
+		 */
+		text_poke_sync_finish(tps);
+
+		/*
+		 * The NMI was spontaneous, not self-induced.
+		 * Don't consume it.
+		 */
+		ret = NMI_DONE;
+	}
+
+	return ret;
+}
+
+/*
+ * patch_worker_nmi() - sets up an NMI handler to do the
+ * patching work.
+ * This stops any NMIs from interrupting any code that might
+ * be getting patched.
+ */
+static void __maybe_unused patch_worker_nmi(void)
+{
+	atomic_set(&text_poke_state.nmi_work, 1);
+	/*
+	 * We could just use apic->send_IPI_self here. However, for reasons
+	 * that I don't understand, apic->send_IPI() or apic->send_IPI_mask()
+	 * work but apic->send_IPI_self (which internally does apic_write())
+	 * does not.
+	 */
+	apic->send_IPI(smp_processor_id(), NMI_VECTOR);
+
+	/*
+	 * Barrier to ensure that we do actually execute the NMI
+	 * before exiting.
+	 */
+	atomic_cond_read_acquire(&text_poke_state.nmi_work, !VAL);
+}
+
 static int patch_worker(void *t)
 {
 	int cpu = smp_processor_id();
@@ -1769,7 +1869,10 @@ static int patch_worker(void *t)
 		 * Generates insns and calls text_poke_site() to do the poking
 		 * and sync.
 		 */
-		tps->patch_worker(tps);
+		if (!tps->nmi_context)
+			tps->patch_worker(tps);
+		else
+			patch_worker_nmi();
 
 		/*
 		 * We are done patching. Switch the state to PATCH_DONE
@@ -1790,7 +1893,8 @@ static int patch_worker(void *t)
  *
  * Return: 0 on success, -errno on failure.
  */
-static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage)
+static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage,
+					 bool nmi)
 {
 	int ret;
 
@@ -1807,12 +1911,20 @@ static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage)
 	text_poke_state.state = PATCH_SYNC_DONE; /* Start state */
 	text_poke_state.primary_cpu = smp_processor_id();
 
+	text_poke_state.nmi_context = nmi;
+
+	if (nmi)
+		register_nmi_handler(NMI_LOCAL, text_poke_nmi,
+				     NMI_FLAG_FIRST, "text_poke_nmi");
 	/*
 	 * Run the worker on all online CPUs. Don't need to do anything
 	 * for offline CPUs as they come back online with a clean cache.
 	 */
 	ret = stop_machine(patch_worker, &text_poke_state, cpu_online_mask);
 
+	if (nmi)
+		unregister_nmi_handler(NMI_LOCAL, "text_poke_nmi");
+
 	return ret;
 }
 
@@ -1957,13 +2069,13 @@ static void paravirt_worker(struct text_poke_state *tps)
  *
  * Return: 0 on success, -errno on failure.
  */
-int paravirt_runtime_patch(void)
+int paravirt_runtime_patch(bool nmi)
 {
 	lockdep_assert_held(&text_mutex);
 
 	if (!pv_stage.count)
 		return -EINVAL;
 
-	return text_poke_late(paravirt_worker, &pv_stage);
+	return text_poke_late(paravirt_worker, &pv_stage, nmi);
 }
 #endif /* CONFIG_PARAVIRT_RUNTIME */
-- 
2.20.1

