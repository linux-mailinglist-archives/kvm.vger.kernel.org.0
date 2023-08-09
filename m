Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6792D775FDD
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjHIMyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjHIMyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:54:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D642F2122;
        Wed,  9 Aug 2023 05:53:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379CqBJ3005733;
        Wed, 9 Aug 2023 12:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-03-30;
 bh=4x+zE4hQtUzx7DvsxU62TsC9MtAa7FotAn6Rbv4QSws=;
 b=s8vkesQltMGztBt8U/Sn8oCyOJoaMWgkXjG0sdvIljOLPU+A90hZgOGa0RGeQ0gsWG/u
 henwl5geffvsUq3Gz1gOpYYXuS+l+qPn/q/T8CwJ93S5ALoTV1boT8Mcc/Yvi5hvdk5/
 ERNgVPpCfFOpQJeXI9q1v7xo/9MHaZxFStAatnpa2344tObkh9CsezfwhB8DpuJcRnvs
 J7X23Z4OUeEJ3Mvaf63dqgc+yLYw3CAX10nKY9YsBD5pCudZmyZLvIJ2xaKjc0ccGu/N
 7NKY+ZK8zzMU5fI79j5uYZ/RJiKjVDhXEtRdENi32/xqMFNYZDDgb7LI4DJLs8wSY4QV Og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9cuerfvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379BXdcP021556;
        Wed, 9 Aug 2023 12:52:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdyfvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379CqCGJ027258;
        Wed, 9 Aug 2023 12:52:57 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s9cvdyf90-4;
        Wed, 09 Aug 2023 12:52:57 +0000
From:   Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 3/7] x86/kvm: Move haltpoll_want() to be arch defined
Date:   Wed,  9 Aug 2023 14:39:37 +0300
Message-Id: <1691581193-8416-4-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_10,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=950 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090113
X-Proofpoint-ORIG-GUID: Iz4AGH0IRJb3G1PZ_b520EPEYVR2M_ZH
X-Proofpoint-GUID: Iz4AGH0IRJb3G1PZ_b520EPEYVR2M_ZH
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Right now, kvm_para_has_hint(KVM_HINTS_REALTIME) is x86 only, and so in
the pursuit of making cpuidle-haltpoll arch independent, move the check
for haltpoll enablement to be defined per architecture. To that end, add
a arch_haltpoll_want() and move the check there.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/x86/include/asm/cpuidle_haltpoll.h | 1 +
 arch/x86/kernel/kvm.c                   | 6 ++++++
 drivers/cpuidle/cpuidle-haltpoll.c      | 4 ++--
 include/linux/cpuidle_haltpoll.h        | 5 +++++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..2c5a53ce266f 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_want(void);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5984da..817594cbda11 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1151,4 +1151,10 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_want(void)
+{
+	return kvm_para_has_hint(KVM_HINTS_REALTIME);
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 0ca3c8422eb6..e2d4d78744ae 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -96,7 +96,7 @@ static void haltpoll_uninit(void)
 
 static bool haltpoll_want(void)
 {
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+	return (kvm_para_available() && arch_haltpoll_want()) || force;
 }
 
 static int __init haltpoll_init(void)
@@ -110,7 +110,7 @@ static int __init haltpoll_init(void)
 		return -ENODEV;
 #endif
 
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!haltpoll_want())
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..bae68a6603e3 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_want(void)
+{
+	return false;
+}
 #endif
 #endif
-- 
1.8.3.1

