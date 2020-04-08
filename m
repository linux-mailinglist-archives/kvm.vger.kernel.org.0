Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6551A1B2F
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDHFFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgDHFFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038543Ku180070;
        Wed, 8 Apr 2020 05:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9yuxA5IXffsHO48sJ1wSgMyLJZle9AjoqPIszA4NVpU=;
 b=TQKqFBITBOYFQPzrNmpK8lt+fAndAJZKKrFX4BoBfb3k0yVhyuTFG+bMvg1kjTKqqkWy
 0No7sGhvNNEA4WExF8iTf8oZ4ynJpKO7oVj5T82k4fJ4H4eiDDhx2ii1PaDE/ZJkjuAG
 9XqgH0YcYoLaJCMHDEPIUridLwfcI/eI7UrondSX711ga15j3ojbzxmjOeqxrhwCzrCb
 2EKHdqYbPZh8gkWroa37MP20onJ8TiMCnXkNm6oPl0xnrjcZACdDeECz4ERk5QF7757e
 aLRLRT0ZzSH3iWAPQ0uPPJsPOY8PD22Z+N4NiVmO/qZq/FSZJwwkC3Mn2Wbi5Tsx9M7I DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3091mnh14t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852XvE062261;
        Wed, 8 Apr 2020 05:05:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3091mh1kr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855LAJ022165;
        Wed, 8 Apr 2020 05:05:21 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:21 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 16/26] x86/alternatives: Add paravirt patching at runtime
Date:   Tue,  7 Apr 2020 22:03:13 -0700
Message-Id: <20200408050323.4237-17-ankur.a.arora@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add paravirt_patch_runtime() which uses text_poke_late() to patch
paravirt sites.

Also add paravirt_worker() which does the actual insn generation
generate_paravirt() (which uses runtime_patch() to generate the
appropriate native or paravirt insn sequences) and then calls
text_poke_site() to do the actual poking.

 CPU0                                CPUx
 ----                                ----

 patch_worker()                      patch_worker()

   /* Traversal, insn-gen */           text_poke_sync_finish()
   tps.patch_worker()
     /* = paravirt_worker() */         /*
                                        * wait until:
     /* for each patch-site */          *  tps->state == PATCH_DONE
     generate_paravirt()                */
       runtime_patch()
     text_poke_site()
       poke_sync()

           ...                                 ...

   smp_store_release(&tps->state, PATCH_DONE)

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/text-patching.h |  2 +
 arch/x86/kernel/alternative.c        | 98 +++++++++++++++++++++++++++-
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index c4b2814f2f9d..e86709a8287e 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -21,6 +21,8 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #ifndef CONFIG_PARAVIRT_RUNTIME
 #define __parainstructions_runtime	NULL
 #define __parainstructions_runtime_end	NULL
+#else
+int paravirt_runtime_patch(void);
 #endif
 
 /*
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 452d4081eded..1c5acdc4f349 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1463,7 +1463,9 @@ static void poke_sync(struct text_poke_state *tps, int state, int offset,
 /**
  * text_poke_site() - called on the primary to patch a single call site.
  *
- * Returns after switching tps->state to PATCH_SYNC_DONE.
+ * Called in thread context with tps->state == PATCH_SYNC_DONE where it
+ * takes tps->state through different PATCH_SYNC_* states, returning
+ * after having switched the tps->state back to PATCH_SYNC_DONE.
  */
 static void __maybe_unused text_poke_site(struct text_poke_state *tps,
 					  struct text_poke_loc *tp)
@@ -1598,6 +1600,16 @@ static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage)
 	return ret;
 }
 
+/*
+ * Check if this address is still in scope of this module's .text section.
+ */
+static bool __maybe_unused stale_address(struct alt_module *am, u8 *p)
+{
+	if (p < am->text || p >= am->text_end)
+		return true;
+	return false;
+}
+
 #ifdef CONFIG_PARAVIRT_RUNTIME
 struct paravirt_stage_entry {
 	void *dest;	/* pv_op destination */
@@ -1654,4 +1666,88 @@ void text_poke_pv_stage_zero(void)
 	lockdep_assert_held(&text_mutex);
 	pv_stage.count = 0;
 }
+
+/**
+ * generate_paravirt - fill up the insn sequence for a pv-op.
+ *
+ * @tp - address of struct text_poke_loc
+ * @op - the pv-op entry for this location
+ * @site - patch site (kernel or module text)
+ */
+static void generate_paravirt(struct text_poke_loc *tp,
+			      struct paravirt_stage_entry *op,
+			      struct paravirt_patch_site *site)
+{
+	unsigned int used;
+
+	BUG_ON(site->len > POKE_MAX_OPCODE_SIZE);
+
+	text_poke_loc_init(tp, site->instr, site->instr, site->len, NULL, true);
+
+	/*
+	 * Paravirt patches can patch calls (ex. mmu.tlb_flush),
+	 * callee_saves(ex. queued_spin_unlock).
+	 *
+	 * runtime_patch() calls native_patch(), or paravirt_patch()
+	 * based on the destination.
+	 */
+	used = runtime_patch(site->type, (void *)tp->text, op->dest,
+			     (unsigned long)site->instr, site->len);
+
+	/* No good way to recover. */
+	BUG_ON(used < 0);
+
+	/* Pad the rest with nops */
+	add_nops((void *)tp->text + used, site->len - used);
+}
+
+/**
+ * paravirt_worker - generate the paravirt patching
+ * insns and calls text_poke_site() to do the actual patching.
+ */
+static void paravirt_worker(struct text_poke_state *tps)
+{
+	struct paravirt_patch_site *site;
+	struct paravirt_stage *stage = tps->stage;
+	struct paravirt_stage_entry *op = &stage->ops[0];
+	struct alt_module *am;
+	struct text_poke_loc tp;
+	int i;
+
+	list_for_each_entry(am, tps->head, next) {
+		for (site = am->para; site < am->para_end; site++) {
+			if (stale_address(am, site->instr))
+				continue;
+
+			for (i = 0;  i < stage->count; i++) {
+				if (op[i].type != site->type)
+					continue;
+
+				generate_paravirt(&tp, &op[i], site);
+
+				text_poke_site(tps, &tp);
+			}
+		}
+	}
+}
+
+/**
+ * paravirt_runtime_patch() -- patch pv-ops, including paired ops.
+ *
+ * Called holding the text_mutex.
+ *
+ * Modify possibly multiple mutually-dependent pv-op callsites
+ * (ex. pv_lock_ops) using stop_machine().
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int paravirt_runtime_patch(void)
+{
+	lockdep_assert_held(&text_mutex);
+
+	if (!pv_stage.count)
+		return -EINVAL;
+
+	return text_poke_late(paravirt_worker, &pv_stage);
+}
 #endif /* CONFIG_PARAVIRT_RUNTIME */
-- 
2.20.1

