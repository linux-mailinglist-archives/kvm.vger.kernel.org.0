Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB81A1B49
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgDHFFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgDHFFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03854Mlq012951;
        Wed, 8 Apr 2020 05:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=81g/IY4OEO7xOgYmvx3qGX7bGeeG6xG4uYi0m0I9NiU=;
 b=y3BkAb4cOA19nTsI29w6A52wve6TE0t+BHCi9ZdjwQtnGqWvgh7IabI/Dix1L+vltL6+
 mntY0r37PP1IWDBBTy+2YBtG9v4se2ceir0lqHohVla5X8su6jF8zFNfMLzZHJqbyeU1
 P7wxRQe4TE0yGiwyi12K4n95THbgAXKolLnwQ3PAUfmZ/K9Uh2xPVQCki4weMbQtx+gK
 fM3gayV6jAxZK8ngqPZw4OgFn+fyHMWVmJgWb8KULlqVOON31XdqW9E6VL3Q1lXgInRw
 vPrlF4p/kqvG774Zn14qeO8bBeToxilc59nm88kTTuGYfJpVwnNZlH0PLwkmJY8IM9Md xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3091m390y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853K3u158680;
        Wed, 8 Apr 2020 05:05:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091m01g8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855YJq022238;
        Wed, 8 Apr 2020 05:05:34 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:34 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [RFC PATCH 26/26] x86/kvm: Add hint change notifier for KVM_HINT_REALTIME
Date:   Tue,  7 Apr 2020 22:03:23 -0700
Message-Id: <20200408050323.4237-27-ankur.a.arora@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a blocking notifier that triggers when the host sends a hint
change notification.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/kvm_para.h | 10 ++++++++++
 arch/x86/kernel/kvm.c           | 16 ++++++++++++++++
 include/asm-generic/kvm_para.h  |  8 ++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 5a7ca5639c2e..54c3c7a3225e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_KVM_PARA_H
 #define _ASM_X86_KVM_PARA_H
 
+#include <linux/notifier.h>
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <uapi/asm/kvm_para.h>
@@ -96,6 +97,9 @@ extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
 void kvm_callback_vector(struct pt_regs *regs);
 
+void kvm_realtime_notifier_register(struct notifier_block *nb);
+void kvm_realtime_notifier_unregister(struct notifier_block *nb);
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
 #else /* !CONFIG_PARAVIRT_SPINLOCKS */
@@ -137,6 +141,14 @@ static inline void kvm_disable_steal_time(void)
 {
 	return;
 }
+
+static inline void kvm_realtime_notifier_register(struct notifier_block *nb)
+{
+}
+
+static inline void kvm_realtime_notifier_unregister(struct notifier_block *nb)
+{
+}
 #endif
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 163b7a7ec5f9..35ba4a837027 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -951,6 +951,20 @@ void __init kvm_spinlock_init(void)
 static inline bool kvm_pv_spinlock(void) { return false; }
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
+static BLOCKING_NOTIFIER_HEAD(realtime_notifier);
+
+void kvm_realtime_notifier_register(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&realtime_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(kvm_realtime_notifier_register);
+
+void kvm_realtime_notifier_unregister(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&realtime_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(kvm_realtime_notifier_unregister);
+
 #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
 
 static void kvm_disable_host_haltpoll(void *i)
@@ -1004,6 +1018,8 @@ void kvm_trigger_reprobe_cpuid(struct work_struct *work)
 	paravirt_runtime_patch(true);
 
 	mutex_unlock(&text_mutex);
+
+	blocking_notifier_call_chain(&realtime_notifier, 0, NULL);
 }
 
 static DECLARE_WORK(trigger_reprobe, kvm_trigger_reprobe_cpuid);
diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
index 4a575299ad62..d443531b49ac 100644
--- a/include/asm-generic/kvm_para.h
+++ b/include/asm-generic/kvm_para.h
@@ -33,4 +33,12 @@ static inline bool kvm_para_available(void)
 	return false;
 }
 
+static inline void kvm_realtime_notifier_register(struct notifier_block *nb)
+{
+}
+
+static inline void kvm_realtime_notifier_unregister(struct notifier_block *nb)
+{
+}
+
 #endif
-- 
2.20.1

