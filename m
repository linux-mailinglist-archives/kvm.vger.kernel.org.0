Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB82C4197FF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhI0Pf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:35:27 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:12473 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhI0Pf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632756830; x=1664292830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YmH0Dm6K9UagQsK+zNHjCetfWZosGYeM6tXGGMVGv6U=;
  b=ZC4rfeXUiEG936kQiQhR/V/I1GZMcvpTQId0CNXQ5yQFpIv6hSvns7gH
   lmgA74wHK6uECJsWsZ+X7IDTDyVqTz/O+A17O/pNCdAHr0NfGxQ+6pMWv
   wUMuoVJyAdKl6wYVX+sAwhk0B9X/ii4JeZpkqUI3+Jf5IgTxiuPClScjn
   k=;
X-IronPort-AV: E=Sophos;i="5.85,326,1624320000"; 
   d="scan'208";a="144866713"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 27 Sep 2021 15:33:40 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 7272E822DF;
        Mon, 27 Sep 2021 15:33:38 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:33:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:33:37 +0000
Received: from dev-dsk-ahmeddan-hc-1a-c85ff794.eu-west-1.amazon.com
 (172.19.109.50) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.23 via Frontend Transport; Mon, 27 Sep 2021 15:33:36
 +0000
From:   <ahmeddan@amazon.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <nikos.nikoleris@arm.com>, <drjones@redhat.com>, <graf@amazon.com>
CC:     Daniele Ahmed <ahmeddan@amazon.com>
Subject: [kvm-unit-tests PATCH v2 3/3] x86/msr.c generalize to any input msr
Date:   Mon, 27 Sep 2021 15:30:28 +0000
Message-ID: <20210927153028.27680-3-ahmeddan@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927153028.27680-1-ahmeddan@amazon.com>
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniele Ahmed <ahmeddan@amazon.com>

If an MSR description is provided as input by the user,
run the test against that MSR. This allows the user to
run tests on custom MSR's.

Otherwise run all default tests.

This is to validate custom MSR handling in user space
with an easy-to-use tool. This kvm-unit-test submodule
is a perfect fit. I'm extending it with a mode that
takes an MSR index and a value to test arbitrary MSR accesses.

Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>
---
 x86/msr.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 8931f59..1a2d791 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -3,6 +3,17 @@
 #include "libcflat.h"
 #include "processor.h"
 #include "msr.h"
+#include <stdlib.h>
+
+/**
+ * This test allows two modes:
+ * 1. Default: the `msr_info' array contains the default test configurations
+ * 2. Custom: by providing command line arguments it is possible to test any MSR and value
+ *	Parameters order:
+ *		1. msr index as a base 16 number
+ *		2. value as a base 16 number
+ *		3. "0" if the msr is available only in 64b hosts, any other string otherwise
+ */
 
 struct msr_info {
 	int index;
@@ -100,8 +111,22 @@ int main(int ac, char **av)
 	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
 	int i;
 
-	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
-		test_msr(&msr_info[i], is_64bit_host);
+	if (ac == 4) {
+		char msr_name[16];
+		int index = strtoul(av[1], NULL, 0x10);
+		snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
+
+		struct msr_info msr = {
+			.index = index,
+			.name = msr_name,
+			.is_64bit_only = !strcmp(av[3], "0"),
+			.value = strtoull(av[2], NULL, 0x10)
+		};
+		test_msr(&msr, is_64bit_host);
+	} else {
+		for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
+			test_msr(&msr_info[i], is_64bit_host);
+		}
 	}
 
 	return report_summary();
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



