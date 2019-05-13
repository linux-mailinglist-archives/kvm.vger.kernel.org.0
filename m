Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AD01B8AF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfEMOje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730136AbfEMOjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DESr12184826;
        Mon, 13 May 2019 14:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=03NJAuy8gQRMw5NMdO5oIpncwVrdcNhEn/qnXsnIh+Q=;
 b=g5WaOGjMCQGcw3yFQID9Xz5SR+orOYV1jEvqta9pP1dW+3vk6S7rk3Xf0Xqs9c72Ro1w
 /TCodkQB+5Z4YQjeExvs0QvsKAbjAzfxUXW21GiZ7ZoPR7nSWQ/5N76ENeSlLIaBPOuq
 oraTRR4s8rulSGRtJmfzQ6I6tr45ficozvt9Zf9IR0tS1V0R/j/qCwAykrzu4TBWku12
 vyAVK6nNFxTgtyozBfwL3irrf/S3fPxxNjChwJoT7jqQ+3BTuw9SWcfOTckw2b1l05Nd
 oG/FOBhG00v9BsVeDYzcuV3eTXQRhjHKRHxD7Luw1u+N5LvXr+eEUi8yT9Gj8XmE4JX0 Bg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7aqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:38:48 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ5022780;
        Mon, 13 May 2019 14:38:45 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 02/27] KVM: x86: Introduce address_space_isolation module parameter
Date:   Mon, 13 May 2019 16:38:10 +0200
Message-Id: <1557758315-12667-3-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130102
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
 arch/x86/kvm/Makefile    |    2 +-
 arch/x86/kvm/isolation.c |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kvm/isolation.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a..9f404e9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -10,7 +10,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o page_track.o debugfs.o
+			   hyperv.o page_track.o debugfs.o isolation.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm.o pmu_amd.o
diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
new file mode 100644
index 0000000..e25f663
--- /dev/null
+++ b/arch/x86/kvm/isolation.c
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

