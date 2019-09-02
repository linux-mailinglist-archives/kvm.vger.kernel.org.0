Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FB3A543B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 12:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfIBKnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 06:43:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbfIBKnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 06:43:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82AdEn1163436;
        Mon, 2 Sep 2019 10:41:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=w+G+MVA2YN07SA3UzChr+LYUeDR77rQPujOEa86rr/M=;
 b=YivH4ogzTkrVZ4L/v7Zsi3AicDuo49zoVJeXpXOn2MMKZ7HZvvaH9OnkGas7dbNc7cyj
 zI2JDeB1COr6kzMc/ePUPo23okASg63RjKXv3uleXjgwuXaJqryOU6rFJlQJgptXS3I1
 CHam049rqgEB79plAMDFpvIB9N9/z3G2Nb6MxYDGScqYgi8hczcHBlPOOhd/PnXwkcvO
 sUU9woMbp+QCtGfftZajX7zo5kttShWsDEWAp4LpTdW2I2jtVZOhm7/KLOD1IU1e0YJE
 WTFeEGo9AgVxBbJp2V8HFfyiqsfbDEsI0r+SmQar68HvHAePbhi7QQg7wTygHlTtUIv8 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2us1d7816c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 10:41:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82AcAaB014454;
        Mon, 2 Sep 2019 10:41:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2urww6ds8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 10:41:33 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x82AfTDZ020042;
        Mon, 2 Sep 2019 10:41:29 GMT
Received: from paddy.uk.oracle.com (/10.175.163.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 03:41:27 -0700
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
Subject: [PATCH v3] cpuidle-haltpoll: vcpu hotplug support
Date:   Mon,  2 Sep 2019 11:40:31 +0100
Message-Id: <20190902104031.9296-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909020122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909020122
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
of the present cpus through cpuhp_setup_state() callbacks and future
ones that get onlined or offlined. This mimmics similar logic that
intel_idle does.

Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
v3:
* register the teardown callback for correct handling of hotunplug
and error cases. In case cpuhp_setup_state calls fails (e.g. in one of
the cpus that it invoked the callback) it will then call the teardown of
the previously enabled devices; so no need to handle that manually in
haltpoll_uninit().
* use the cpuhp_setup_state() returned dyn allocated state when it
succeeds. And use that state in haltpoll_unint() to call
cpuhp_remove_state() instead of looping online cpus manually. This
is because cpuhp_remove_state() invokes the teardown/offline callback.
* fix subsystem name to 'cpuidle' instead of 'idle' in cpuhp_setup_state()

v2:
* move cpus_read_unlock() after unregistering all cpuidle_devices;
(Marcello Tosatti)
* redundant usage of cpuidle_unregister() when only
cpuidle_unregister_driver() suffices; (Marcelo Tosatti)
* cpuhp_setup_state() returns a state (> 0) for CPUHP_AP_ONLINE_DYN
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  4 +-
 arch/x86/kernel/kvm.c                   | 18 +++----
 drivers/cpuidle/cpuidle-haltpoll.c      | 68 +++++++++++++++++++++++--
 include/linux/cpuidle_haltpoll.h        |  4 +-
 4 files changed, 73 insertions(+), 21 deletions(-)

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
index 9ac093dcbb01..56d8ab814466 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -11,12 +11,16 @@
  */
 
 #include <linux/init.h>
+#include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
 #include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
+static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
+static enum cpuhp_state haltpoll_hp_state;
+
 static int default_enter_idle(struct cpuidle_device *dev,
 			      struct cpuidle_driver *drv, int index)
 {
@@ -46,6 +50,46 @@ static struct cpuidle_driver haltpoll_driver = {
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
+static int haltpoll_cpu_offline(unsigned int cpu)
+{
+	struct cpuidle_device *dev;
+
+	dev = per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
+	if (dev->registered) {
+		arch_haltpoll_disable(cpu);
+		cpuidle_unregister_device(dev);
+	}
+
+	return 0;
+}
+
+static void haltpoll_uninit(void)
+{
+	if (haltpoll_hp_state)
+		cpuhp_remove_state(haltpoll_hp_state);
+	cpuidle_unregister_driver(&haltpoll_driver);
+
+	free_percpu(haltpoll_cpuidle_devices);
+	haltpoll_cpuidle_devices = NULL;
+}
+
 static int __init haltpoll_init(void)
 {
 	int ret;
@@ -56,17 +100,31 @@ static int __init haltpoll_init(void)
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
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "cpuidle/haltpoll:online",
+				haltpoll_cpu_online, haltpoll_cpu_offline);
+	if (ret < 0) {
+		haltpoll_uninit();
+	} else {
+		haltpoll_hp_state = ret;
+		ret = 0;
+	}
 
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

