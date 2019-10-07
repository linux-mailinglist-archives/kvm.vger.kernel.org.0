Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C205CF58A
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfJHJCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 05:02:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfJHJCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 05:02:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988hUD5149236;
        Tue, 8 Oct 2019 09:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=u2jGBUxoErbaYaYaUwvdGHAGNkpkUIl2vloendr17aw=;
 b=kJCyYW2foTF62Id/gXENuhPw6Lv6uKrn4AmwQpiaq7wK/jeIulwToNUXTYwXL3BrdEx4
 w8SAN8FfiUodRnX5qiPlNLBzKyCjS2Th/HmGw9LSO+t6S1sMBywRfGRgE8pcpA5WFAQv
 GkJ5f+cV01v71RyeHOeGp2eMBIgN9Je81v64PvFF3XqxN6S641NTHzs2omPwwNOewTik
 3f9LzhnwOqN3P2JqEMartjtUDP24xf06C4MysezxLa3LpuZM97S3mhZi1cZL+elhNJ+R
 fIV6Wn83zA1SwCx1imxrFpM08t9oNJtazEp8I5XvHdcLlaJtUy5tkD/DFLlzznsYQfIB qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qc368-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 09:00:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988h3jx124613;
        Tue, 8 Oct 2019 09:00:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vgefa8jf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 09:00:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x98906r5023909;
        Tue, 8 Oct 2019 09:00:06 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 02:00:06 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v5 3/5] x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
Date:   Mon,  7 Oct 2019 17:04:29 +0800
Message-Id: <1570439071-9814-4-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080089
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
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 arch/x86/include/asm/qspinlock.h                |  1 +
 arch/x86/kernel/kvm.c                           | 21 +++++++++++++++++----
 kernel/locking/qspinlock.c                      |  7 +++++++
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c7ac2f3..89d77ea 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5330,6 +5330,11 @@
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
index ef836d6..6e14bd4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -825,18 +825,31 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
  */
 void __init kvm_spinlock_init(void)
 {
-	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+	/*
+	 * Disable PV qspinlocks if host kernel doesn't support
+	 * KVM_FEATURE_PV_UNHALT feature or there is only 1 vCPU.
+	 * virt_spin_lock_key is enabled to avoid lock holder
+	 * preemption issue.
+	 */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
+	    num_possible_cpus() == 1) {
+		pr_info("PV spinlocks disabled\n");
 		return;
+	}
 
 	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
+		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
 		static_branch_disable(&virt_spin_lock_key);
 		return;
 	}
 
-	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
-	if (num_possible_cpus() == 1)
+	if (nopvspin) {
+		pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");
+		static_branch_disable(&virt_spin_lock_key);
 		return;
+	}
+
+	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
 	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
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

