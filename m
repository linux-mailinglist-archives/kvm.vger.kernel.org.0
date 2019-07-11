Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB604658E8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfGKO2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfGKO2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOGvb100511;
        Thu, 11 Jul 2019 14:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=R7Xfip06p699muIVGHbRVSpcUyRHanu29pNDIpaJD54=;
 b=LYEr+9/uvSyvI7OVyk9UP5FJcmH4YzsINobd9Ws4d1Sn7zQRqsU665EFWo2tRiz/cBWH
 TQPi+azMpPQ50ca6ZxpYu/g0a8JuwQaUyBMwUTLzLIprNNem/R910eIUU8P5Bv98N3Zz
 VQLKGIpKXFE80COh/4g3j2DCRhhYcgvjn2KBcjXSAHnxcqRegfAAZE4hnlxbfYZgQOEd
 YTBZwZfCqCbfS+eDaW7yYwGctCL21NUDe7ydmDXBTvwj7gQ1BR2oLXZZ5z2nmPV3Av6O
 uW3d4XWaCBCFsg3LcCI9MxRw/Tgth3Gipeew1Xr8UIl8LL6WLVneXw3ZkgDZG2ZEH0Xh 4A== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0cdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:27:02 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuF021444;
        Thu, 11 Jul 2019 14:26:53 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 22/26] KVM: x86/asi: Introduce address_space_isolation module parameter
Date:   Thu, 11 Jul 2019 16:25:34 +0200
Message-Id: <1562855138-19507-23-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Add the address_space_isolation parameter to the kvm module.

When set to true, KVM #VMExit handlers run in isolated address space
which maps only KVM required code and per-VM information instead of
entire kernel address space.

This mechanism is meant to mitigate memory-leak side-channels CPU
vulnerabilities (e.g. Spectre, L1TF and etc.) but can also be viewed
as security in-depth as it also helps generically against info-leaks
vulnerabilities in KVM #VMExit handlers and reduce the available
gadgets for ROP attacks.

This is set to false by default because it incurs a performance hit
which some users will not want to take for security gain.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/Makefile        |    3 ++-
 arch/x86/kvm/vmx/isolation.c |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/isolation.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a..71579ed 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,7 +12,8 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o page_track.o debugfs.o
 
-kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
+kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
+			   vmx/evmcs.o vmx/nested.o vmx/isolation.o
 kvm-amd-y		+= svm.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/vmx/isolation.c b/arch/x86/kvm/vmx/isolation.c
new file mode 100644
index 0000000..e25f663
--- /dev/null
+++ b/arch/x86/kvm/vmx/isolation.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ *
+ * KVM Address Space Isolation
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+
+/*
+ * When set to true, KVM #VMExit handlers run in isolated address space
+ * which maps only KVM required code and per-VM information instead of
+ * entire kernel address space.
+ *
+ * This mechanism is meant to mitigate memory-leak side-channels CPU
+ * vulnerabilities (e.g. Spectre, L1TF and etc.) but can also be viewed
+ * as security in-depth as it also helps generically against info-leaks
+ * vulnerabilities in KVM #VMExit handlers and reduce the available
+ * gadgets for ROP attacks.
+ *
+ * This is set to false by default because it incurs a performance hit
+ * which some users will not want to take for security gain.
+ */
+static bool __read_mostly address_space_isolation;
+module_param(address_space_isolation, bool, 0444);
-- 
1.7.1

