Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816AF3D9088
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhG1O1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:27:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46734 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237040AbhG1O0u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENPRb002083;
        Wed, 28 Jul 2021 10:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cIgkzIddy+YiMaF1fvXCQPdnkZYFB4QPuMcg2h36EeE=;
 b=PIR28Mdwlt4IVyQOSjgLYIF8dWFYL6rprIb0YPiPHHN1jvTyboU7Aut3WkZ8aMlV+ZpE
 KXVoLYJ3odYpEcTV1iiKAvzSjSQwcGjO1bJO00NL/4IEkph6tGBdR8GMk8sRrukAdNXF
 iVJuMyOPd0YpcBIhHu8SoLdWi9fzehKKIkz+x1ye9SW64uUHAy77rIQdXe7EcC8sI30W
 mDU3XBPntfaiBLzvj6rKWPKSHO+r2tDnErht8XQ+M6bve9LNXvkJ1xSCA8u/qCpeG1+3
 IPVeBXb/80/q3oXrX1oOPg3mj8piKlZKXncnNvrack8MwVusAqXoCvrvPApDBoxeD9K+ pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38u4rbfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:48 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENR4O002254;
        Wed, 28 Jul 2021 10:26:48 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38u4rbew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:48 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEIk6b007180;
        Wed, 28 Jul 2021 14:26:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3a235krqsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQgvw28901714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E5BBA405B;
        Wed, 28 Jul 2021 14:26:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 292B3A405F;
        Wed, 28 Jul 2021 14:26:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/13] KVM: s390: pv: add OOM notifier for lazy destroy
Date:   Wed, 28 Jul 2021 16:26:30 +0200
Message-Id: <20210728142631.41860-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728142631.41860-1-imbrenda@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z-6nkw2e_w2NfXx2-1A_3BWkUY5D8_k7
X-Proofpoint-ORIG-GUID: SO5W6wIGuUFApF9hsFvFdfEvCCUjQrkh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 mlxlogscore=920 spamscore=0 priorityscore=1501 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a per-VM OOM notifier for lazy destroy.

When a protected VM is undergoing deferred teardown, register an OOM
notifier. This allows an OOM situation to be handled by just waiting a
little.

The background cleanup deferred destroy process will now keep a running
tally of the amount of pages freed. The asynchronous OOM notifier will
check the number of pages freed before and after waiting. The OOM
notifier will wait 10ms, and then report the number of pages freed by
the deferred destroy mechanism during that time.

If at least 1024 pages have already been freed in the current OOM
situation, no action is taken by the OOM notifier and no wait is
performed. This avoids excessive waiting times in case many VMs are
being destroyed at the same time, once enough memory has been freed.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 088b94512af3..390b57307f24 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -15,8 +15,12 @@
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/oom.h>
 #include "kvm-s390.h"
 
+#define KVM_S390_PV_LAZY_DESTROY_OOM_NOTIFY_PRIORITY	70
+
 struct deferred_priv {
 	struct mm_struct *mm;
 	bool has_mm;
@@ -24,6 +28,8 @@ struct deferred_priv {
 	u64 handle;
 	void *stor_var;
 	unsigned long stor_base;
+	unsigned long n_pages_freed;
+	struct notifier_block oom_nb;
 };
 
 static int lazy_destroy = 1;
@@ -249,6 +255,24 @@ static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+static int kvm_s390_pv_oom_notify(struct notifier_block *nb,
+				  unsigned long dummy, void *parm)
+{
+	unsigned long *freed = parm;
+	unsigned long free_before;
+	struct deferred_priv *p;
+
+	if (*freed > 1024)
+		return NOTIFY_OK;
+
+	p = container_of(nb, struct deferred_priv, oom_nb);
+	free_before = READ_ONCE(p->n_pages_freed);
+	msleep(20);
+	*freed += READ_ONCE(p->n_pages_freed) - free_before;
+
+	return NOTIFY_OK;
+}
+
 static int kvm_s390_pv_destroy_vm_thread(void *priv)
 {
 	struct destroy_page_lazy *lazy, *next;
@@ -256,12 +280,20 @@ static int kvm_s390_pv_destroy_vm_thread(void *priv)
 	u16 rc, rrc;
 	int r;
 
+	p->oom_nb.priority = KVM_S390_PV_LAZY_DESTROY_OOM_NOTIFY_PRIORITY;
+	p->oom_nb.notifier_call = kvm_s390_pv_oom_notify;
+	r = register_oom_notifier(&p->oom_nb);
+
 	list_for_each_entry_safe(lazy, next, &p->mm->context.deferred_list, list) {
 		list_del(&lazy->list);
 		s390_uv_destroy_pfns(lazy->count, lazy->pfns);
+		WRITE_ONCE(p->n_pages_freed, p->n_pages_freed + lazy->count + 1);
 		free_page(__pa(lazy));
 	}
 
+	if (!r)
+		unregister_oom_notifier(&p->oom_nb);
+
 	if (p->has_mm) {
 		/* Clear all the pages as long as we are not the only users of the mm */
 		s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
-- 
2.31.1

