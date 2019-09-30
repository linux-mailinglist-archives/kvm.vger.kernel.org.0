Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CBC33D2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbfJAMGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:06:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41068 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfJAMGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:06:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C4Rdi173097;
        Tue, 1 Oct 2019 12:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=EEFx1lHigtewl5NRAn81FB4CA+LzMW4aRG66eOeJJNU=;
 b=sbVdUiPmaKEmcJzQySGd+tdSrCCfykUa+LhF24WBGrA3AXT1lM6TrCxJZAxJOMme84jn
 OQAzSE25TIm0poszHCaivrZkPI0vHDcA5554WGVbNW11Ww5IaIUUvacFrecd1mk/B4ga
 5AmSsqTgALF6nrEJ8FyydFNwwd1ojzzWizPqpZmmgeJ3zLGHbXQElbRKHmVJVHeBc8lA
 hzftjy4fLbXgCBLjUUO+2kUD+ImCydWJedt95qmpPYRRpWFwAZSTyvBKtEuVtseoT+KG
 67fgTzI9Bu62G1HEud2rQM4QIONaxrmyDcGs2jGbJfe88ocl7lHhTgH0wReyt6tQzXEX Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxunbqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C49Fi188581;
        Tue, 1 Oct 2019 12:04:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqd0rchd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91C4KB9017689;
        Tue, 1 Oct 2019 12:04:20 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:04:20 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/4] x86/kvm: Change print code to use pr_*() format
Date:   Mon, 30 Sep 2019 20:08:58 +0800
Message-Id: <1569845340-11884-3-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569845340-11884-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1569845340-11884-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pr_*() is preferred than printk(KERN_* ...), after change all the print
in arch/x86/kernel/kvm.c will have "KVM: xxx" style.

No functional change.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/kvm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a4f108d..7b8cf0d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -7,6 +7,8 @@
  *   Authors: Anthony Liguori <aliguori@us.ibm.com>
  */
 
+#define pr_fmt(fmt) "KVM: " fmt
+
 #include <linux/context_tracking.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -286,7 +288,7 @@ static void kvm_register_steal_time(void)
 		return;
 
 	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
-	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
+	pr_info("stealtime: cpu %d, msr %llx\n",
 		cpu, (unsigned long long) slow_virt_to_phys(st));
 }
 
@@ -321,7 +323,7 @@ static void kvm_guest_cpu_init(void)
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
-		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
+		pr_info("setup async PF for cpu %d\n",
 		       smp_processor_id());
 	}
 
@@ -347,7 +349,7 @@ static void kvm_pv_disable_apf(void)
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
 	__this_cpu_write(apf_reason.enabled, 0);
 
-	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
+	pr_info("Unregister pv shared memory for cpu %d\n",
 	       smp_processor_id());
 }
 
@@ -509,7 +511,7 @@ static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	pr_info("KVM setup pv IPIs\n");
+	pr_info("setup pv IPIs\n");
 }
 
 static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
@@ -639,11 +641,11 @@ static void __init kvm_guest_init(void)
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
-		pr_info("KVM setup pv sched yield\n");
+		pr_info("setup pv sched yield\n");
 	}
 	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
 				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
-		pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
+		pr_err("failed to install cpu hotplug callbacks\n");
 #else
 	sev_map_percpu_data();
 	kvm_guest_cpu_init();
@@ -746,7 +748,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
 		}
-		pr_info("KVM setup pv remote TLB flush\n");
+		pr_info("setup pv remote TLB flush\n");
 	}
 
 	return 0;
@@ -879,8 +881,8 @@ static void kvm_enable_host_haltpoll(void *i)
 void arch_haltpoll_enable(unsigned int cpu)
 {
 	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
-		pr_err_once("kvm: host does not support poll control\n");
-		pr_err_once("kvm: host upgrade recommended\n");
+		pr_err_once("host does not support poll control\n");
+		pr_err_once("host upgrade recommended\n");
 		return;
 	}
 
-- 
1.8.3.1

