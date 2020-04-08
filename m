Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72E51A1B53
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDHFGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:06:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgDHFFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038543dJ012900;
        Wed, 8 Apr 2020 05:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=kgW9iCiG5LItARQCVcpvzlvJOL8EYizS/WgTMkqF5GQ=;
 b=B6xflBgt96z3OrC1orNU/7h9/R5v5aKEPszgWArvG/YKVpuevq436ajAtgFfMwwdSjz0
 qZ7szdFGT7K5dCH8fbEDuMV7ugSL0fmHYKseM8dvx37f8AQsc3UsdMHIQF7jtDV3zk7R
 6h1PtbnmbtR7f5lhdQjlpxnf475s3S1o8AunH6alLl8VdqfsQrWo5obLyFLDKU9XF/2Y
 nf2f6XasqEBFPrCnC1Z3c7eAYzDdMYy7rMkts1JewP/sftLhmdV22oay8ytjJwHUm1O+
 gKqGihxgS0ZEkpoFHmiB7Z9NlvPtwIpjjHwX1F9KKqC0ifLje9IrxufEFjigj0nILJUn BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m390y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03851VPa100593;
        Wed, 8 Apr 2020 05:05:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3091m2hvn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855UrV007479;
        Wed, 8 Apr 2020 05:05:30 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:30 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 23/26] x86/kvm: Add worker to trigger runtime patching
Date:   Tue,  7 Apr 2020 22:03:20 -0700
Message-Id: <20200408050323.4237-24-ankur.a.arora@oracle.com>
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

Make __pv_init_lock_hash() conditional on either paravirt spinlocks
being enabled (via kvm_pv_spinlock()) or if paravirt spinlocks
might get enabled (runtime patching via CONFIG_PARAVIRT_RUNTIME.)

Also add a handler for CPUID reprobe which can trigger this patching.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/kernel/kvm.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 31f5ecfd3907..1cb7eab805a6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,7 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/text-patching.h>
 
 static int kvmapf = 1;
 
@@ -909,12 +910,15 @@ void __init kvm_spinlock_init(void)
 	if (num_possible_cpus() == 1)
 		return;
 
-	if (!kvm_pv_spinlock())
-		return;
-
-	__pv_init_lock_hash();
+	/*
+	 * Allocate if pv_spinlocks are enabled or if we might
+	 * end up patching them in later.
+	 */
+	if (kvm_pv_spinlock() || IS_ENABLED(CONFIG_PARAVIRT_RUNTIME))
+		__pv_init_lock_hash();
 }
-
+#else	/* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline bool kvm_pv_spinlock(void) { return false; }
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
@@ -952,3 +956,23 @@ void arch_haltpoll_disable(unsigned int cpu)
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
 #endif
+
+#ifdef CONFIG_PARAVIRT_RUNTIME
+void kvm_trigger_reprobe_cpuid(struct work_struct *work)
+{
+	mutex_lock(&text_mutex);
+
+	paravirt_stage_zero();
+
+	kvm_pv_steal_clock();
+	kvm_pv_tlb();
+	paravirt_runtime_patch(false);
+
+	paravirt_stage_zero();
+
+	kvm_pv_spinlock();
+	paravirt_runtime_patch(true);
+
+	mutex_unlock(&text_mutex);
+}
+#endif /* CONFIG_PARAVIRT_RUNTIME */
-- 
2.20.1

