Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4523D1A1B6F
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDHFF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgDHFF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853kcS191152;
        Wed, 8 Apr 2020 05:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=f3lI3rU1/Ay+Euh85CO5VhgXpZoiQo2cE1fiMRnLh1w=;
 b=nMq6d/oDWDkNt2ukCGxAciCrkLF9QtnmmkiNw9DRJnvr/apWes/2eAGiQcGqMSCJVtmo
 M6AtPpl2ujYjQf5RDs/ynkxYwT9oSpQgxsfAqkfYM3b0ktBcH6b5z2SyZWM2/IcvPU0Q
 ocfvrZ3Cx8jlOay/V59oyr80m0cPdV01ga90ZR0ZRoz2qZCBTheZFVMeTUWz4GOlnssG
 SSLKEhsbansJomlmhFH0Bu4iSxQ4+844Zl0p2Ssk3gqZecDCRH8tvncx2cWmCY+MBahS
 9fFyUtYO5a4JeZxrmJbEfjc0ZKNjEFNDNmbY4C7ivOd/gfozUSL3n9ED7t1mddqW8YD0 aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3091m0s0sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853LB1158807;
        Wed, 8 Apr 2020 05:05:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3091m01fvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855DaW015230;
        Wed, 8 Apr 2020 05:05:13 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:12 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 10/26] x86/paravirt: Add primitives to stage pv-ops
Date:   Tue,  7 Apr 2020 22:03:07 -0700
Message-Id: <20200408050323.4237-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
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

Add paravirt_stage_alt() which conditionally selects between a paravirt
or native pv-op and then stages it for later patching.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/paravirt_types.h |  6 +++
 arch/x86/include/asm/text-patching.h  |  3 ++
 arch/x86/kernel/alternative.c         | 58 +++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3b9f6c105397..0c4ca7ad719c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -350,6 +350,12 @@ extern struct paravirt_patch_template native_pv_ops;
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
 
+#define paravirt_stage_alt(do_stage, op, opfn)				\
+	(text_poke_pv_stage(PARAVIRT_PATCH(op),				\
+			    (do_stage) ? (opfn) : (native_pv_ops.op)))
+
+#define paravirt_stage_zero() text_poke_pv_stage_zero()
+
 /*
  * Neat trick to map patch type back to the call within the
  * corresponding structure.
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e2ef241c261e..706e61e6967d 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -55,6 +55,9 @@ extern void text_poke_bp(void *addr, const void *opcode, size_t len, const void
 extern void text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate);
 extern void text_poke_finish(void);
 
+bool text_poke_pv_stage(u8 type, void *opfn);
+void text_poke_pv_stage_zero(void);
+
 #define INT3_INSN_SIZE		1
 #define INT3_INSN_OPCODE	0xCC
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 8189ac21624c..0c335af9ee28 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1307,3 +1307,61 @@ void __ref text_poke_bp(void *addr, const void *opcode, size_t len, const void *
 	text_poke_loc_init(&tp, addr, opcode, len, emulate);
 	text_poke_bp_batch(&tp, 1);
 }
+
+#ifdef CONFIG_PARAVIRT_RUNTIME
+struct paravirt_stage_entry {
+	void *dest;	/* pv_op destination */
+	u8 type;	/* pv_op type */
+};
+
+/*
+ * We don't anticipate many pv-ops being written at runtime.
+ */
+#define PARAVIRT_STAGE_MAX 8
+struct paravirt_stage {
+	struct paravirt_stage_entry ops[PARAVIRT_STAGE_MAX];
+	u32 count;
+};
+
+/* Protected by text_mutex */
+static struct paravirt_stage pv_stage;
+
+/**
+ * text_poke_pv_stage - Stage paravirt-op for poking.
+ * @addr: address in struct paravirt_patch_template
+ * @type: pv-op type
+ * @opfn: destination of the pv-op
+ *
+ * Return: staging status.
+ */
+bool text_poke_pv_stage(u8 type, void *opfn)
+{
+	if (system_state == SYSTEM_BOOTING) { /* Passthrough */
+		PARAVIRT_PATCH_OP(pv_ops, type) = (long)opfn;
+		goto out;
+	}
+
+	lockdep_assert_held(&text_mutex);
+
+	if (PARAVIRT_PATCH_OP(pv_ops, type) == (long)opfn)
+		goto out;
+
+	if (pv_stage.count >= PARAVIRT_STAGE_MAX)
+		goto out;
+
+	pv_stage.ops[pv_stage.count].type = type;
+	pv_stage.ops[pv_stage.count].dest = opfn;
+
+	pv_stage.count++;
+
+	return true;
+out:
+	return false;
+}
+
+void text_poke_pv_stage_zero(void)
+{
+	lockdep_assert_held(&text_mutex);
+	pv_stage.count = 0;
+}
+#endif /* CONFIG_PARAVIRT_RUNTIME */
-- 
2.20.1

