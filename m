Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E39658FB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfGKO1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbfGKO1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOE8u013326;
        Thu, 11 Jul 2019 14:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=x/IjzSr0NJXbBWkc/GbWFGd8aRvvo+k/bAxRCg2smaA=;
 b=UpGsaKxVuo2eIaT3MIyMj6uwvZYdjod6xr9sIWH6GLVIiGJo5xv5khjwyLVyDDuy1GvG
 yfeeGSjBWTuaMV/ezPA0NULlZQYuPGQftx9frpdHWZCWGt6EzWWMYPjn5VPHT47SjUpI
 A1Zvxp/4R+waiK8CFltSblp1Oe52CtoJA0LD+OBZSfdqHFgWhRLUnvbf0i9N2AFU9yvt
 42HuhPrb/rYgNn3SpXtQLfgcHyAjGcS15pNxoiZQoNGdL0uAmA7B00OD3j6dk0aaUwQn
 KjZFUxYUuNzdESj/m6+MVakQNxN1UqdtuIgCsY0XLrDA5xHgNra+3zY3ilOMR4T3aYcQ vg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2tjm9r0bpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:21 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu2021444;
        Thu, 11 Jul 2019 14:26:12 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 09/26] mm/asi: Helper functions to map module into ASI
Date:   Thu, 11 Jul 2019 16:25:21 +0200
Message-Id: <1562855138-19507-10-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=896 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helper functions to easily map a module into an ASI.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 19656aa..b5dbc49 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -6,6 +6,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <asm/pgtable.h>
 #include <linux/xarray.h>
@@ -81,6 +82,26 @@ extern int asi_map_range(struct asi *asi, void *ptr, size_t size,
 extern int asi_map(struct asi *asi, void *ptr, unsigned long size);
 
 /*
+ * Copy the memory mapping for the current module. This is defined as a
+ * macro to ensure it is expanded in the module making the call so that
+ * THIS_MODULE has the correct value.
+ */
+#define ASI_MAP_THIS_MODULE(asi)			\
+	(asi_map(asi, THIS_MODULE->core_layout.base,	\
+		 THIS_MODULE->core_layout.size))
+
+static inline int asi_map_module(struct asi *asi, char *module_name)
+{
+	struct module *module;
+
+	module = find_module(module_name);
+	if (!module)
+		return -ESRCH;
+
+	return asi_map(asi, module->core_layout.base, module->core_layout.size);
+}
+
+/*
  * Function to exit the current isolation. This is used to abort isolation
  * when a task using isolation is scheduled out.
  */
-- 
1.7.1

