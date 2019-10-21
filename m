Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8419DE006F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 11:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbfJVJKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 05:10:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfJVJKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 05:10:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M94Dxj173370;
        Tue, 22 Oct 2019 09:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=HCoo6ok9RA6O3qZcaK2ouk33INMKb7EkdhACLh1Q+q8=;
 b=An7h5vjNpU98UO7VqyCoKDNejxAetnfmbXjybw7S2sv24WyaPO93Yb7mxloIPL6S8tsu
 Geaa2tkM2ST262Jprlu7nbMwuShJslNvJhwits0Y3FH0UPZFDExUyCtikEwbb5wxBerB
 oTt0TpO8DTkvpFTMr47cQapIJ0Rfw8bG5YNl/ar7JTcaq0irUDW1E4rIqFvGRqa1+g1D
 oSe+dMt407Yv1rXGZe4TGAqNOEnYbjTHRnAaYhCb2/ZOe4JRRTwmOobc/Jywzgd3Rydb
 o30/RMrJOX9+dUlfvwWPPbbsWmZAYugZC4FxJf+vTKWsgbQwXfrRcMvNoaui9t3m9JX+ Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswtdc2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 09:08:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M937Ok047561;
        Tue, 22 Oct 2019 09:06:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vrc01fjcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 09:06:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M96fMd006974;
        Tue, 22 Oct 2019 09:06:42 GMT
Received: from z2.cn.oracle.com (/10.182.70.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:06:41 +0000
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com, peterz@infradead.org,
        will@kernel.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v7 3/5] x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
Date:   Mon, 21 Oct 2019 17:11:14 +0800
Message-Id: <1571649076-2421-4-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are cases where a guest tries to switch spinlocks to bare metal
behavior (e.g. by setting "xen_nopvspin" on XEN platform and
"hv_nopvspin" on HYPER_V).

That feature is missed on KVM, add a new parameter "nopvspin" to disable
PV spinlocks for KVM guest.

The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
parameters in future patches.

Define variable nopvsin as global because it will be used in future
patches as above.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 arch/x86/include/asm/qspinlock.h                |  1 +
 arch/x86/kernel/kvm.c                           | 34 ++++++++++++++++++++-----
 kernel/locking/qspinlock.c                      |  7 +++++
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a84a83f..bd49ed2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5334,6 +5334,11 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
+	nopvspin	[X86,KVM]
+			Disables the qspinlock slow path using PV optimizations
+			which allow the hypervisor to 'idle' the guest on lock
+			contention.
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 444d6fd..d86ab94 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -32,6 +32,7 @@ static __always_inline u32 queued_fetch_set_pending_acquire(struct qspinlock *lo
 extern void __pv_init_lock_hash(void);
 extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
 extern void __raw_callee_save___pv_queued_spin_unlock(struct qspinlock *lock);
+extern bool nopvspin;
 
 #define	queued_spin_unlock queued_spin_unlock
 /**
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 249f14a..3945aa5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -825,18 +825,36 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
  */
 void __init kvm_spinlock_init(void)
 {
-	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+	/*
+	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
+	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
+	 * preferred over native qspinlock when vCPU is preempted.
+	 */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
+		pr_info("PV spinlocks disabled, no host support.\n");
 		return;
+	}
 
+	/*
+	 * Disable PV qspinlock and use native qspinlock when dedicated pCPUs
+	 * are available.
+	 */
 	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
-		static_branch_disable(&virt_spin_lock_key);
-		return;
+		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
+		goto out;
 	}
 
-	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
-	if (num_possible_cpus() == 1)
-		return;
+	if (num_possible_cpus() == 1) {
+		pr_info("PV spinlocks disabled, single CPU.\n");
+		goto out;
+	}
+
+	if (nopvspin) {
+		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
+		goto out;
+	}
+
+	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
 	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
@@ -849,6 +867,8 @@ void __init kvm_spinlock_init(void)
 		pv_ops.lock.vcpu_is_preempted =
 			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
 	}
+out:
+	static_branch_disable(&virt_spin_lock_key);
 }
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 2473f10..75193d6 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -580,4 +580,11 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 #include "qspinlock_paravirt.h"
 #include "qspinlock.c"
 
+bool nopvspin __initdata;
+static __init int parse_nopvspin(char *arg)
+{
+	nopvspin = true;
+	return 0;
+}
+early_param("nopvspin", parse_nopvspin);
 #endif
-- 
1.8.3.1

