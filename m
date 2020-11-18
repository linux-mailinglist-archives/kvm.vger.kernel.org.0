Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0212B7D6A
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 13:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgKRMLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 07:11:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKRMLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 07:11:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AICALWR010130
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ckQ0zCtD692qCVbG4gPGcSRkah2dYeTD2+liRIXf0KE=;
 b=MJs4iVVPRK/G4gAiOykwFru7Mv7ucV/aKuY77UbRzfZ/SGLKigAd1nM0QjeKIoTuWyUM
 IgRrIQ6jogLTQlEpPaI3v0/RpbHghRrrLIxo8U1sBa5t40hpRkRWTvZDPloDGYR/FFYW
 1zD7z9v8x13LJkLSvyR5L6o+x9e4MWZ/xsz7Y0QHOPg+kaMI19QtPwR4Bff8KvsmB9vu
 mjTA6Rb+FZz0zadU1oVMMpO3jSpZqTcZtPyzp6EVMjgXYS7ZDHy39EgxNMBtvtsWUVqO
 +uPSZiFEwMO5hSTwrfa0IvpOqMp6NMmM4XYFm+KZ+9m86DFuDMXElGgZc+Wq2cVQPZeV 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rayuup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AICAZih115322
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts5xeg62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AICBWuT027928
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 12:11:32 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 04:11:32 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id fa0b1899;
        Wed, 18 Nov 2020 12:11:29 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     kvm@vger.kernel.org
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [kvm-unit-tests PATCH v2 1/1] x86: check that clflushopt of an MMIO address succeeds
Date:   Wed, 18 Nov 2020 12:11:29 +0000
Message-Id: <20201118121129.6276-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118121129.6276-1-david.edmondson@oracle.com>
References: <20201118121129.6276-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the clflushopt instruction succeeds when applied to an
MMIO address at both cpl0 and cpl3.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 x86/Makefile.common   |  3 ++-
 x86/clflushopt_mmio.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg     |  5 +++++
 3 files changed, 52 insertions(+), 1 deletion(-)
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
index 0000000..f048f58
--- /dev/null
+++ b/x86/clflushopt_mmio.c
@@ -0,0 +1,45 @@
+#include "libcflat.h"
+#include "usermode.h"
+#include "pci.h"
+#include "x86/asm/pci.h"
+
+static volatile int ud;
+static void *memaddr = (void *)0xfed00000; /* HPET */
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
+	bool raised;
+
+	setup_vm();
+
+	handle_exception(UD_VECTOR, handle_ud);
+
+	(void) run_in_user(user_clflushopt, false, 0, 0, 0, 0, &raised);
+	try_clflushopt("clflushopt-mmio@cpl0 (%s)");
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
2.29.2

