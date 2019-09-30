Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F52C33C8
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbfJAME6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:04:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732057AbfJAME6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:04:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C48LR172799;
        Tue, 1 Oct 2019 12:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=tmIzy72qo+rS2sy4J+XBqwA5jvB3VFv9TPhVygdVa7Y=;
 b=VRQJMsQlWcHI5cDsMpqi7PVWUkLh7ENNobf1T6yRegfa6GD84cj467aaVWfXAj0j6peJ
 CHV9NWR9xl2/4WAdR9bpH13oLwS1okn4u+I0c39dTkJaOXhBR+nDGNqCDHMr+d6vSCAN
 KNI0u3KjqD7S5MVByVumius9whOs2g9HjOAvUuyUsn2u6lRvxIhBfNIqt8QlElck2OCa
 4lSSnpeARZVjLNh7Rq9MH3MfXwpxds68teDFmrlf7BlERa5Vohv81HCyhEvZlmkmu0Ba
 /u9hzQfhgcD9My2kvb+YCVYXUtRGiQWrpYbGSX5k6H6r9mwkxU5S7eqLF8MbLF8o76ss Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxunbrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C3OGK157533;
        Tue, 1 Oct 2019 12:04:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vbnqcs9n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91C4SRe010289;
        Tue, 1 Oct 2019 12:04:28 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:04:27 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete and map it to "nopvspin"
Date:   Mon, 30 Sep 2019 20:09:00 +0800
Message-Id: <1569845340-11884-5-git-send-email-zhenzhong.duan@oracle.com>
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

Includes asm/hypervisor.h in order to reference x86_hyper_type.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 6 +++++-
 arch/x86/hyperv/hv_spinlock.c                   | 9 +++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1f0a62f..43f922c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1436,6 +1436,10 @@
 	hv_nopvspin	[X86,HYPER_V] Disables the paravirt spinlock optimizations
 				      which allow the hypervisor to 'idle' the
 				      guest on lock contention.
+				      This parameter is obsoleted by "nopvspin"
+				      parameter, which has equivalent effect for
+				      HYPER_V platform.
+
 
 	keep_bootcon	[KNL]
 			Do not unregister boot console at start. This is only
@@ -5331,7 +5335,7 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
-	nopvspin	[X86,XEN,KVM] Disables the qspinlock slow path
+	nopvspin	[X86,XEN,KVM,HYPER_V] Disables the qspinlock slow path
 			using PV optimizations which allow the hypervisor to
 			'idle' the guest on lock contention.
 
diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 07f21a0..e00e319 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -12,12 +12,11 @@
 
 #include <linux/spinlock.h>
 
+#include <asm/hypervisor.h>
 #include <asm/mshyperv.h>
 #include <asm/paravirt.h>
 #include <asm/apic.h>
 
-static bool __initdata hv_pvspin = true;
-
 static void hv_qlock_kick(int cpu)
 {
 	apic->send_IPI(cpu, X86_PLATFORM_IPI_VECTOR);
@@ -64,7 +63,7 @@ __visible bool hv_vcpu_is_preempted(int vcpu)
 
 void __init hv_init_spinlocks(void)
 {
-	if (!hv_pvspin || !apic ||
+	if (!pvspin || !apic ||
 	    !(ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) ||
 	    !(ms_hyperv.features & HV_X64_MSR_GUEST_IDLE_AVAILABLE)) {
 		pr_info("PV spinlocks disabled\n");
@@ -82,7 +81,9 @@ void __init hv_init_spinlocks(void)
 
 static __init int hv_parse_nopvspin(char *arg)
 {
-	hv_pvspin = false;
+	pr_notice("\"hv_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
+	if (x86_hyper_type == X86_HYPER_MS_HYPERV)
+		pvspin = false;
 	return 0;
 }
 early_param("hv_nopvspin", hv_parse_nopvspin);
-- 
1.8.3.1

