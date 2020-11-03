Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ADF2A4AC9
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgKCQJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:09:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgKCQJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 11:09:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3FtcFk168866
        for <kvm@vger.kernel.org>; Tue, 3 Nov 2020 16:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=BzyRShX+37XSMmw8RUqVfB2YPoE1HUlKjtCnZT+4haU=;
 b=tB3D0CIQ1uPCQwoze6bGxoFg1zjXdz9scrCatZ8YUxhQk7p8WmE7/VjO9Iyo/RaKHeI6
 QuDTzU4HuZd/TIObbFT5Le/0B+taZYVNxeZGaU3Kvp2jEKm0wOUl9Wn/uIPTcyuTsgtW
 UvzCU+SEZ3Yy9I03cLNIvOtoo1hIvB5yy4ShNd9CfYP8KdlQBKbjFsn8/mO9nZi4HMBi
 xYi4UbBHMR9EaLF+rQZiWb2/MPsMJXn/vaI9Voswe0AmP3soE19Sl1A07K/ANwrSt46H
 WMPuf5XydD5wupWcjahKMJ+FtKB8DhQhJeQzKCXqScu1xEtADeMmER/f9Whnqql2wTbW cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvca359-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Tue, 03 Nov 2020 16:09:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3FsnX7126213
        for <kvm@vger.kernel.org>; Tue, 3 Nov 2020 16:09:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf48pkvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Tue, 03 Nov 2020 16:09:00 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3G8xIE001861
        for <kvm@vger.kernel.org>; Tue, 3 Nov 2020 16:08:59 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 08:08:59 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id b0adc6ae;
        Tue, 3 Nov 2020 16:08:55 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     kvm@vger.kernel.org
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [kvm-unit-tests PATCH] x86: check that clflushopt of an MMIO address succeeds
Date:   Tue,  3 Nov 2020 16:08:55 +0000
Message-Id: <20201103160855.261881-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the clflushopt instruction succeeds when applied to an
MMIO address at both cpl0 and cpl3.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
This is a test for the fix included in:
https://lore.kernel.org/r/20201103120400.240882-1-david.edmondson@oracle.com

 x86/Makefile.common   |  3 ++-
 x86/clflushopt_mmio.c | 58 +++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg     |  5 ++++
 3 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 x86/clflushopt_mmio.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b942086..e11666a 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
+               $(TEST_DIR)/clflushopt_mmio.flat
 
 test_cases: $(tests-common) $(tests)
 
diff --git a/x86/clflushopt_mmio.c b/x86/clflushopt_mmio.c
new file mode 100644
index 0000000..06c1b32
--- /dev/null
+++ b/x86/clflushopt_mmio.c
@@ -0,0 +1,58 @@
+#include "libcflat.h"
+#include "usermode.h"
+#include "pci.h"
+#include "x86/asm/pci.h"
+
+static volatile int ud;
+static void *memaddr;
+
+static void handle_ud(struct ex_regs *regs)
+{
+	ud = 1;
+	regs->rip += 4;
+}
+
+static void try_clflushopt(const char *comment)
+{
+	int expected = !this_cpu_has(X86_FEATURE_CLFLUSHOPT);
+
+	ud = 0;
+	/* clflushopt (%rbx): */
+	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (memaddr));
+
+	report(ud == expected, comment, expected ? "ABSENT" : "present");
+}
+
+static uint64_t user_clflushopt(void)
+{
+	try_clflushopt("clflushopt-mmio@cpl3 (%s)");
+
+	return 0;
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	struct pci_dev pcidev;
+	unsigned long membar = 0;
+	bool raised;
+
+	setup_vm();
+
+	ret = pci_find_dev(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_TEST);
+	if (ret != PCIDEVADDR_INVALID) {
+		pci_dev_init(&pcidev, ret);
+		assert(pci_bar_is_memory(&pcidev, PCI_TESTDEV_BAR_MEM));
+		membar = pcidev.resource[PCI_TESTDEV_BAR_MEM];
+		memaddr = ioremap(membar, PAGE_SIZE);
+		printf("pci-testdev at %#x membar %lx (@%p)\n",
+		       pcidev.bdf, membar, memaddr);
+
+		handle_exception(UD_VECTOR, handle_ud);
+
+		(void) run_in_user(user_clflushopt, false, 0, 0, 0, 0, &raised);
+		try_clflushopt("clflushopt-mmio@cpl0 (%s)");
+	}
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 872d679..35bedf8 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -359,3 +359,8 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
 file = tsx-ctrl.flat
 extra_params = -cpu host
 groups = tsx-ctrl
+
+[clflushopt_mmio]
+file = clflushopt_mmio.flat
+extra_params = -cpu host
+arch = x86_64
-- 
2.28.0

