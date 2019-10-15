Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00128D6CD4
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 03:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfJOBVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 21:21:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbfJOBVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 21:21:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F1ENDi031607;
        Tue, 15 Oct 2019 01:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=m2u7wIIh1G1CvWQOnHO+T8RoKMQn5Cd56TOwOJpzLVk=;
 b=diDvu1AiLDFc19RH2L+oOoq7NXO5+PUG/kjI3DyJH0LAdTTf07rEk7UXZYRTOHbb10l+
 P3DkVYI6Us4onF6upqqBoQ0ZDSizdjAN6Y5Ji3RdIroctFjUUDYXiUqC8Woi4CnFnJDf
 8ozS55jVOBvxclh8eBRfM/Zo5JxBtFZmvhg/5BDIIkvARwEl2SRiRJwXFwuhUc+m0uo5
 22he53Y/CJKS3qrvppDkU7HhwduzJrfA/j8dbTJ2btR5yfuQdqtmpLO5a+sySWKH9ZnS
 CYdnE7+K3gGrr8UJFApM31HnFIwyaS/EqL0rlMjdvMNcuKDVs8LOAybkG+/f6nfqM2SP fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vk68ucdek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 01:19:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F1IYj6129321;
        Tue, 15 Oct 2019 01:19:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vks07txqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 01:19:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F1JjZR003385;
        Tue, 15 Oct 2019 01:19:45 GMT
Received: from z2.cn.oracle.com (/10.182.70.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 18:19:45 -0700
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
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v6 2/5] x86/kvm: Change print code to use pr_*() format
Date:   Tue, 15 Oct 2019 09:19:24 +0800
Message-Id: <1571102367-31595-3-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571102367-31595-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1571102367-31595-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pr_*() is preferred than printk(KERN_* ...), after change all the print
in arch/x86/kernel/kvm.c will have "kvm_guest: xxx" style.

No functional change.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
 arch/x86/kernel/kvm.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3bc6a266..249f14a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -7,6 +7,8 @@
  *   Authors: Anthony Liguori <aliguori@us.ibm.com>
  */
 
+#define pr_fmt(fmt) "kvm_guest: " fmt
+
 #include <linux/context_tracking.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -286,8 +288,8 @@ static void kvm_register_steal_time(void)
 		return;
 
 	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
-	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
-		cpu, (unsigned long long) slow_virt_to_phys(st));
+	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
+		(unsigned long long) slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
@@ -321,8 +323,7 @@ static void kvm_guest_cpu_init(void)
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
-		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
-		       smp_processor_id());
+		pr_info("setup async PF for cpu %d\n", smp_processor_id());
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
@@ -347,8 +348,7 @@ static void kvm_pv_disable_apf(void)
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
 	__this_cpu_write(apf_reason.enabled, 0);
 
-	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
-	       smp_processor_id());
+	pr_info("Unregister PV shared memory for cpu %d\n", smp_processor_id());
 }
 
 static void kvm_pv_guest_cpu_reboot(void *unused)
@@ -469,7 +469,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 		} else {
 			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
 				(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
-			WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
+			WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
+				  ret);
 			min = max = apic_id;
 			ipi_bitmap = 0;
 		}
@@ -479,7 +480,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 	if (ipi_bitmap) {
 		ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
 			(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
-		WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
+		WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
+			  ret);
 	}
 
 	local_irq_restore(flags);
@@ -509,7 +511,7 @@ static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	pr_info("KVM setup pv IPIs\n");
+	pr_info("setup PV IPIs\n");
 }
 
 static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
@@ -631,11 +633,11 @@ static void __init kvm_guest_init(void)
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
-		pr_info("KVM setup pv sched yield\n");
+		pr_info("setup PV sched yield\n");
 	}
 	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
 				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
-		pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
+		pr_err("failed to install cpu hotplug callbacks\n");
 #else
 	sev_map_percpu_data();
 	kvm_guest_cpu_init();
@@ -738,7 +740,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
 		}
-		pr_info("KVM setup pv remote TLB flush\n");
+		pr_info("setup PV remote TLB flush\n");
 	}
 
 	return 0;
@@ -866,8 +868,8 @@ static void kvm_enable_host_haltpoll(void *i)
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

