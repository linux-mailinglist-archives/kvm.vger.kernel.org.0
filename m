Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A400E6B9420
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjCNMli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 08:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCNMlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 08:41:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8994F2210C
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678797541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZoLxBS4sCcddIB4Qt1Fu55N4ue8UhWhYQjCpsRyp28w=;
        b=iIu2ij4dTyp2Z2an6ArGxOlQuOsZeEdOgLjA9udHgT5Fgh3ronKtrlX85YQUyjKNZYK3hG
        zDe0tkuxLf9YEtfCD80yHh34TMCq9MznsWk8YvWp38GVuEoNmf3kSsHpXxNy5HBE1Dniom
        sABDGXRILy+TCPsRSnlBoa08rYs1JzI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-WnSoYnekPFO02XgVBCawag-1; Tue, 14 Mar 2023 08:35:45 -0400
X-MC-Unique: WnSoYnekPFO02XgVBCawag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA5963855562;
        Tue, 14 Mar 2023 12:35:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B02C400F4F;
        Tue, 14 Mar 2023 12:35:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH] KVM: selftests: skip hugetlb tests if huge pages are not available
Date:   Tue, 14 Mar 2023 08:35:44 -0400
Message-Id: <20230314123544.3050347-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, if KVM memory stress tests are run with hugetlb sources but hugetlb is
not available (either in the kernel or because /proc/sys/vm/nr_hugepages is 0)
the test will fail with a memory allocation error.

This makes it impossible to add tests that default to hugetlb-backed memory,
because on a machine with a default configuration they will fail.  Therefore,
check HugePages_Total as well and, if zero, direct the user to enable hugepages
in procfs.  Furthermore, return KSFT_SKIP whenever hugetlb is not available.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/test_util.c | 25 +++++++++++++--------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 5c22fa4c2825..b772193f6c18 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -165,26 +165,33 @@ size_t get_trans_hugepagesz(void)
 size_t get_def_hugetlb_pagesz(void)
 {
 	char buf[64];
-	const char *tag = "Hugepagesize:";
+	const char *hugepagesize = "Hugepagesize:";
+	const char *hugepages_total = "HugePages_Total:";
 	FILE *f;
 
 	f = fopen("/proc/meminfo", "r");
 	TEST_ASSERT(f != NULL, "Error in opening /proc/meminfo");
 
 	while (fgets(buf, sizeof(buf), f) != NULL) {
-		if (strstr(buf, tag) == buf) {
+		if (strstr(buf, hugepages_total) == buf) {
+			unsigned long long total = strtoull(buf + strlen(hugepages_total), NULL, 10);
+			if (!total) {
+				fprintf(stderr, "HUGETLB is not enabled in /proc/sys/vm/nr_hugepages\n");
+				exit(KSFT_SKIP);
+			}
+		}
+		if (strstr(buf, hugepagesize) == buf) {
 			fclose(f);
-			return strtoull(buf + strlen(tag), NULL, 10) << 10;
+			return strtoull(buf + strlen(hugepagesize), NULL, 10) << 10;
 		}
 	}
 
-	if (feof(f))
-		TEST_FAIL("HUGETLB is not configured in host kernel");
-	else
-		TEST_FAIL("Error in reading /proc/meminfo");
+	if (feof(f)) {
+		fprintf(stderr, "HUGETLB is not configured in host kernel");
+		exit(KSFT_SKIP);
+	}
 
-	fclose(f);
-	return 0;
+	TEST_FAIL("Error in reading /proc/meminfo");
 }
 
 #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
-- 
2.39.1

