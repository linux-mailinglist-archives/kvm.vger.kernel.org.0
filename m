Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7A40033B
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhICQ0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349507AbhICQ0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 12:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630686346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t2/IhN3sHR858U3ByMzOyRS6xMfUb5sa3G3fTX0IzAI=;
        b=Q77TpCVcEiahlQdNALsjk3JoTDG4vpKm59/U9IhXTc8wCCuxqOg7ufgU05DW3IaHtyu6sE
        e4tIpKSWFHnatp2zC9UTlqeaw+HwuiRA9n8pGY1ByNOZoLagXtlHr5jN8haClydOI5KsR9
        h3Ehwg6dz/+bZKySK7I6Cqn0JYeNjs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-Ms5amdHeNrqxFpHQ6_S5dQ-1; Fri, 03 Sep 2021 12:25:45 -0400
X-MC-Unique: Ms5amdHeNrqxFpHQ6_S5dQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68A8E501E6;
        Fri,  3 Sep 2021 16:25:44 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89B435D9FC;
        Fri,  3 Sep 2021 16:25:38 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v1] s390x/skey: Test for ADDRESSING exceptions
Date:   Fri,  3 Sep 2021 18:25:37 +0200
Message-Id: <20210903162537.57178-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... used to be broken in TCG, so let's add a very simple test for SSKE
and ISKE. In order to test RRBE as well, introduce a helper to call the
machine instruction.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/mem.h | 12 ++++++++++++
 s390x/skey.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 40b22b6..845c00c 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -50,6 +50,18 @@ static inline unsigned char get_storage_key(void *addr)
 	return skey;
 }
 
+static inline unsigned char reset_reference_bit(void *addr)
+{
+	int cc;
+
+	asm volatile(
+		"rrbe	0,%1\n"
+		"ipm	%0\n"
+		"srl	%0,28\n"
+		: "=d" (cc) : "a" (addr) : "cc");
+	return cc;
+}
+
 #define PFMF_FSC_4K 0
 #define PFMF_FSC_1M 1
 #define PFMF_FSC_2G 2
diff --git a/s390x/skey.c b/s390x/skey.c
index 2539944..58a5543 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -120,6 +120,33 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_invalid_address(void)
+{
+	void *inv_addr = (void *)-1ull;
+
+	report_prefix_push("invalid address");
+
+	report_prefix_push("sske");
+	expect_pgm_int();
+	set_storage_key(inv_addr, 0, 0);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_push("iske");
+	expect_pgm_int();
+	get_storage_key(inv_addr);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_push("rrbe");
+	expect_pgm_int();
+	reset_reference_bit(inv_addr);
+	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -128,6 +155,7 @@ int main(void)
 		goto done;
 	}
 	test_priv();
+	test_invalid_address();
 	test_set();
 	test_set_mb();
 	test_chg();
-- 
2.31.1

