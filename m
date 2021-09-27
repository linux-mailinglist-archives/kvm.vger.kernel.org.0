Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11CE4197FE
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhI0PfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:35:01 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:38829 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhI0PfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632756803; x=1664292803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6NLk/pvvNQ1kggf3AzXQzVp0tjH7brsZRx0/ZBuQTQ=;
  b=bolEBAUICuxiWhugjeIq2kw25rvde4b1bA7GAem5DuyiD+C+UYpF8+bU
   UDPUAIKKk+Fxl4QCrQVe2k94AA3B4VnKHxHjcH6YN8T+ZpiKSOSOEelBU
   CNTJCSWqgCrdYvjXPuKM7hpIWB5AHod0HtmUVYP5NJnHSeNWy1JVdByUx
   c=;
X-IronPort-AV: E=Sophos;i="5.85,326,1624320000"; 
   d="scan'208";a="29897146"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 27 Sep 2021 15:33:15 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 5573C8735E;
        Mon, 27 Sep 2021 15:33:13 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:33:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:33:12 +0000
Received: from dev-dsk-ahmeddan-hc-1a-c85ff794.eu-west-1.amazon.com
 (172.19.109.50) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.23 via Frontend Transport; Mon, 27 Sep 2021 15:33:11
 +0000
From:   <ahmeddan@amazon.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <nikos.nikoleris@arm.com>, <drjones@redhat.com>, <graf@amazon.com>
CC:     Daniele Ahmed <ahmeddan@amazon.com>
Subject: [kvm-unit-tests PATCH v2 2/3] [kvm-unit-tests PATCH] x86/msr.c refactor out generic test logic
Date:   Mon, 27 Sep 2021 15:30:27 +0000
Message-ID: <20210927153028.27680-2-ahmeddan@amazon.com>
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

Move the generic MSR test logic to its own function.

Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>
---
 x86/msr.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 7a551c4..8931f59 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -77,26 +77,31 @@ static void test_rdmsr_fault(struct msr_info *msr)
 	       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
 }
 
+static void test_msr(struct msr_info *msr, bool is_64bit_host)
+{
+	if (is_64bit_host || !msr->is_64bit_only) {
+		test_msr_rw(msr, msr->value);
+
+		/*
+		 * The 64-bit only MSRs that take an address always perform
+		 * canonical checks on both Intel and AMD.
+		 */
+		if (msr->is_64bit_only &&
+		    msr->value == addr_64)
+			test_wrmsr_fault(msr, NONCANONICAL);
+	} else {
+		test_wrmsr_fault(msr, msr->value);
+		test_rdmsr_fault(msr);
+	}
+}
+
 int main(int ac, char **av)
 {
 	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
 	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
-		if (is_64bit_host || !msr_info[i].is_64bit_only) {
-			test_msr_rw(&msr_info[i], msr_info[i].value);
-
-			/*
-			 * The 64-bit only MSRs that take an address always perform
-			 * canonical checks on both Intel and AMD.
-			 */
-			if (msr_info[i].is_64bit_only &&
-			    msr_info[i].value == addr_64)
-				test_wrmsr_fault(&msr_info[i], NONCANONICAL);
-		} else {
-			test_wrmsr_fault(&msr_info[i], msr_info[i].value);
-			test_rdmsr_fault(&msr_info[i]);
-		}
+		test_msr(&msr_info[i], is_64bit_host);
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



