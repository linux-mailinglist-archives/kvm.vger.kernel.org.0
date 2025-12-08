Return-Path: <kvm+bounces-65519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2340CAE6A0
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 00:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8EF5301DE07
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 23:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B67E2C21C0;
	Mon,  8 Dec 2025 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vgl7U9KT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA112E65D
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 23:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765237159; cv=none; b=lWNexL1P6Ipqo6WbB28g5SqMAAyuiZcoldHg4QGBmKO5A9VICIOn6YL8g/peFEyxmsot4WSFMc0hOz7gscYbNw/+4YUw42HwH2aJ1CN0CZMfNXbfRRjOBWha74CQ4ACL/z+vsrNf0+Xq/SDeT4UyGA1/BciDGtJMUSgBNG0nCdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765237159; c=relaxed/simple;
	bh=oRw4Re4H9dvB9c+b16Oal3wCU4/sTXQVv0peqCVPmvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O7mH9AoFCYUbmrbw5b767doSTcE3iYyyiWGrRO55CI+jnBKz0HbY0zNefmmWutgbpB9zW6FQR6fi38YpM3w5xM8mGV+V0sk+8nfs6s7MSDSbnMo3U9kYZsGhlCxWvLJGH5DqE6p7y9uL9KBqeZz65UXFWQaw8VNzs/0GrVp7a0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vgl7U9KT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765237156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DJY22PlWPInOrqvKpe/PiGa8UkRjvS7h9lqqZGwwD7g=;
	b=Vgl7U9KToc6FfgeW4Lc6sL+Q45NOOOargS6md6xfJcj170kdOzfTBK7q47CVZauT3yEhTe
	tTtYFHz0wk8IcE302os5LFScnYf/1C358BCPcQs60qTE9uVgU0CJK+muy+oRMI7mgvSbrQ
	DGNWeHb8CPLt4Bdz3pGBYlwW81yBYWA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-qMPD2mBON22YQoiT6unC5A-1; Mon,
 08 Dec 2025 18:39:13 -0500
X-MC-Unique: qMPD2mBON22YQoiT6unC5A-1
X-Mimecast-MFC-AGG-ID: qMPD2mBON22YQoiT6unC5A_1765237152
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C08518005A4;
	Mon,  8 Dec 2025 23:39:12 +0000 (UTC)
Received: from intellaptop.redhat.com (unknown [10.22.65.246])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8212F18004D4;
	Mon,  8 Dec 2025 23:39:11 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH] Skip PMU portion of vmware_backdoors test if PMU is not enabled.
Date: Mon,  8 Dec 2025 18:39:10 -0500
Message-ID: <20251208233910.1000465-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Since 2019, KVM has an explicit check that if guest's PMC is disabled,
then VMware backdoor via RDPCM is disabled as well.

 commit 672ff6cff80ca43bf3258410d2b887036969df5f
 Author: Liran Alon <liran.alon@oracle.com>
 Date:   Mon Mar 25 21:10:17 2019 +0200
 KVM: x86: Raise #GP when guest vCPU do not support PMU

Fix the test failure by checking if PMU is enabled first.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/vmware_backdoors.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index f8cf7ecb150b..c18f0bf86356 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -1,5 +1,6 @@
 
 #include "x86/msr.h"
+#include "x86/pmu.h"
 #include "x86/processor.h"
 #include "x86/apic-defs.h"
 #include "x86/apic.h"
@@ -101,7 +102,7 @@ static uint64_t vmware_backdoor_port(uint64_t vmport, uint64_t vmport_magic,
 		PORT_ARG(a, b, c, m, sf))
 
 
-struct fault_test vmware_backdoor_tests[] = {
+struct fault_test vmware_backdoor_tests_rdpcm[] = {
 	RDPMC_TEST("HOST_TSC kernel", VMWARE_BACKDOOR_PMC_HOST_TSC,
 			KERNEL_MODE, NO_FAULT),
 	RDPMC_TEST("REAL_TIME kernel", VMWARE_BACKDOOR_PMC_REAL_TIME,
@@ -116,6 +117,10 @@ struct fault_test vmware_backdoor_tests[] = {
 			USER_MODE, NO_FAULT),
 	RDPMC_TEST("RANDOM PMC user", 0xfff, USER_MODE, FAULT),
 
+	{ NULL },
+};
+
+struct fault_test vmware_backdoor_tests_ioport[] = {
 	PORT_TEST("CMD_GETVERSION user", VMWARE_BACKDOOR_PORT, VMWARE_MAGIC,
 			VMPORT_CMD_GETVERSION, USER_MODE, NO_FAULT),
 	PORT_TEST("CMD_GETVERSION kernel", VMWARE_BACKDOOR_PORT, VMWARE_MAGIC,
@@ -165,8 +170,15 @@ static void check_vmware_backdoors(void)
 
 	report_prefix_push("vmware_backdoors");
 
-	for (i = 0; vmware_backdoor_tests[i].name != NULL; i++)
-		test_run(&vmware_backdoor_tests[i]);
+	if (this_cpu_has_pmu()) {
+		for (i = 0; vmware_backdoor_tests_rdpcm[i].name != NULL; i++)
+			test_run(&vmware_backdoor_tests_rdpcm[i]);
+	} else {
+		report_skip("Skipping VMWARE pseudo RDPCM tests, PMU not enabled");
+	}
+
+	for (i = 0; vmware_backdoor_tests_ioport[i].name != NULL; i++)
+		test_run(&vmware_backdoor_tests_ioport[i]);
 
 	report_prefix_pop();
 }
-- 
2.49.0


