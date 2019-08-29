Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F97AA1E9B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 17:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfH2PNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 11:13:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfH2PNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 11:13:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TF9Ea7185188;
        Thu, 29 Aug 2019 15:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=CKit7+Ighkvtwrce/t6NZ2djJ2x69q1/2NpRpmKU0Ns=;
 b=QsmxoNNJdYXGkfCwBAdxnOds9NtfKOWPhM7yWMYkqJsjLZio52x1F0o1a0MLl6PBSHm+
 eW10j8QgmTkIntRVG6Kdnpn6JmDkBu4y8Y05Vx8RJO7ANs8reggGPtY9fOuVF+leYvCp
 J4X/4VyJm1XgoU/IKSdydUFznlYLmZNkmHVC2blDERn8Ce+P556P48iXFQF4Ypqk1hOJ
 SUhHqgzh9coxKr30qoXfquUOksXPaEqJP0mwAggdsfczqlb9M+NXXra/cvXDFXINgC6D
 nKmmtBq+deAGIJW3lwK6zOgGhiChBBBJ9dVs4YLLbKtG5vEjGsG1QB9GKY5q+p3VJtLl 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uph30g0gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:10:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TF9TPI137674;
        Thu, 29 Aug 2019 15:10:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvu049sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 15:10:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TFAaxG030672;
        Thu, 29 Aug 2019 15:10:36 GMT
Received: from paddy.uk.oracle.com (/10.175.160.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 08:10:35 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v2] cpuidle-haltpoll: vcpu hotplug support
Date:   Thu, 29 Aug 2019 16:10:27 +0100
Message-Id: <20190829151027.9930-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
past the online ones and thus fail to register the idle driver.
This is because cpuidle_add_sysfs() will return with -ENODEV as a
consequence from get_cpu_device() return no device for a non-existing
CPU.

Instead switch to cpuidle_register_driver() and manually register each
of the present cpus through cpuhp_setup_state() callback and future
ones that get onlined. This mimmics similar logic that intel_idle does.

Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
v2:
* move cpus_read_unlock() right after unregistering all cpuidle_devices;
(Marcello Tosatti)
* redundant usage of cpuidle_unregister() when only
cpuidle_unregister_driver() suffices; (Marcelo Tosatti)
* cpuhp_setup_state() returns a state (> 0) on success with CPUHP_AP_ONLINE_DYN
thus we set @ret to 0
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  4 +-
 arch/x86/kernel/kvm.c                   | 18 +++----
 drivers/cpuidle/cpuidle-haltpoll.c      | 67 +++++++++++++++++++++++--
 include/linux/cpuidle_haltpoll.h        |  4 +-
 4 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index ff8607d81526..c8b39c6716ff 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -2,7 +2,7 @@
 #ifndef _ARCH_HALTPOLL_H
 #define _ARCH_HALTPOLL_H
 
-void arch_haltpoll_enable(void);
-void arch_haltpoll_disable(void);
+void arch_haltpoll_enable(unsigned int cpu);
+void arch_haltpoll_disable(unsigned int cpu);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8d150e3732d9..a9b6c4e2446d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -880,32 +880,26 @@ static void kvm_enable_host_haltpoll(void *i)
 	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
 }
 
-void arch_haltpoll_enable(void)
+void arch_haltpoll_enable(unsigned int cpu)
 {
 	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
-		printk(KERN_ERR "kvm: host does not support poll control\n");
-		printk(KERN_ERR "kvm: host upgrade recommended\n");
+		pr_err_once("kvm: host does not support poll control\n");
+		pr_err_once("kvm: host upgrade recommended\n");
 		return;
 	}
 
-	preempt_disable();
 	/* Enable guest halt poll disables host halt poll */
-	kvm_disable_host_haltpoll(NULL);
-	smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
-	preempt_enable();
+	smp_call_function_single(cpu, kvm_disable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
 
-void arch_haltpoll_disable(void)
+void arch_haltpoll_disable(unsigned int cpu)
 {
 	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
 		return;
 
-	preempt_disable();
 	/* Enable guest halt poll disables host halt poll */
-	kvm_enable_host_haltpoll(NULL);
-	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
-	preempt_enable();
+	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 9ac093dcbb01..8baade23f8d0 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -11,12 +11,15 @@
  */
 
 #include <linux/init.h>
+#include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
 #include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
+static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
+
 static int default_enter_idle(struct cpuidle_device *dev,
 			      struct cpuidle_driver *drv, int index)
 {
@@ -46,6 +49,48 @@ static struct cpuidle_driver haltpoll_driver = {
 	.state_count = 2,
 };
 
+static int haltpoll_cpu_online(unsigned int cpu)
+{
+	struct cpuidle_device *dev;
+
+	dev = per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
+	if (!dev->registered) {
+		dev->cpu = cpu;
+		if (cpuidle_register_device(dev)) {
+			pr_notice("cpuidle_register_device %d failed!\n", cpu);
+			return -EIO;
+		}
+		arch_haltpoll_enable(cpu);
+	}
+
+	return 0;
+}
+
+static void haltpoll_uninit(void)
+{
+	unsigned int cpu;
+
+	cpus_read_lock();
+
+	for_each_online_cpu(cpu) {
+		struct cpuidle_device *dev =
+			per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
+
+		if (!dev->registered)
+			continue;
+
+		arch_haltpoll_disable(cpu);
+		cpuidle_unregister_device(dev);
+	}
+
+	cpus_read_unlock();
+
+	cpuidle_unregister_driver(&haltpoll_driver);
+
+	free_percpu(haltpoll_cpuidle_devices);
+	haltpoll_cpuidle_devices = NULL;
+}
+
 static int __init haltpoll_init(void)
 {
 	int ret;
@@ -56,17 +101,29 @@ static int __init haltpoll_init(void)
 	if (!kvm_para_available())
 		return 0;
 
-	ret = cpuidle_register(&haltpoll_driver, NULL);
-	if (ret == 0)
-		arch_haltpoll_enable();
+	ret = cpuidle_register_driver(drv);
+	if (ret < 0)
+		return ret;
+
+	haltpoll_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (haltpoll_cpuidle_devices == NULL) {
+		cpuidle_unregister_driver(drv);
+		return -ENOMEM;
+	}
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "idle/haltpoll:online",
+				haltpoll_cpu_online, NULL);
+	if (ret < 0)
+		haltpoll_uninit();
+	else
+		ret = 0;
 
 	return ret;
 }
 
 static void __exit haltpoll_exit(void)
 {
-	arch_haltpoll_disable();
-	cpuidle_unregister(&haltpoll_driver);
+	haltpoll_uninit();
 }
 
 module_init(haltpoll_init);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index fe5954c2409e..d50c1e0411a2 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -5,11 +5,11 @@
 #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
 #include <asm/cpuidle_haltpoll.h>
 #else
-static inline void arch_haltpoll_enable(void)
+static inline void arch_haltpoll_enable(unsigned int cpu)
 {
 }
 
-static inline void arch_haltpoll_disable(void)
+static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
 #endif
-- 
2.17.1

