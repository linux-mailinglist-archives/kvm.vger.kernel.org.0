Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE592C348A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387973AbfJAMle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:41:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfJAMle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:41:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91CNqMS145658;
        Tue, 1 Oct 2019 12:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=eDTQRxQ6LpMs/7vELk2HTebyriMNj13Xg+/LshFBa30=;
 b=jRk5rGAApPN5hPnErpFedOHIMMIPiUoWwVPmahZ6ZTUOvPDLW/201zf1JJHdvY6c+5tc
 VZ7LfTaQIiF/eJT1bQp3hQ3Gi6mj5GhLHik4NzsKTan0VolqPthNwD/dy927fuk50Q6X
 I8wvpaHCLUv4qCoAR03Xf/VR4rJvIYc9++b22LkEptE+SO1WreR+aKuSbaXifwuVU39P
 KtO6vhwzWwEH/sfpJzDpefafIlkczcLV0Oc8H9rZ6PlltfaRpatyoifTqAq/oQpo8Pf9
 kbki31eDc8HT1unhMDI+Q6xdls1miMagLjnmVnwPjWmA/YJhfTpBHLWNHzE0twaSHD4p NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v9yfq5gd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:40:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91COQ7R039803;
        Tue, 1 Oct 2019 12:40:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqd0sv07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:40:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91Ce3PN005830;
        Tue, 1 Oct 2019 12:40:03 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:40:03 -0700
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
Subject: [PATCH v3 2/4] x86/kvm: Change print code to use pr_*() format
Date:   Mon, 30 Sep 2019 20:44:37 +0800
Message-Id: <1569847479-13201-3-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pr_*() is preferred than printk(KERN_* ...), after change all the print
in arch/x86/kernel/kvm.c will have "KVM: xxx" style.

No functional change.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
 arch/x86/kernel/kvm.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a4f108d..ce4f578 100644
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
+	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
 }
 
 static void kvm_pv_guest_cpu_reboot(void *unused)
@@ -509,7 +509,7 @@ static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	pr_info("KVM setup pv IPIs\n");
+	pr_info("setup pv IPIs\n");
 }
 
 static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
@@ -639,11 +639,11 @@ static void __init kvm_guest_init(void)
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
@@ -746,7 +746,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
 		}
-		pr_info("KVM setup pv remote TLB flush\n");
+		pr_info("setup pv remote TLB flush\n");
 	}
 
 	return 0;
@@ -879,8 +879,8 @@ static void kvm_enable_host_haltpoll(void *i)
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

