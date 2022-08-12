Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B52591517
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 19:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiHLRxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 13:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiHLRxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 13:53:13 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937BEB2847
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:53:12 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660326790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L0jXf6P2p6bz6aHAr7aCyfyKZ4vR3txkHJHPli2GGbc=;
        b=KM6/8jHpWILyr6sfI23IRlJUyDPgLXa3W2nLzoT0tWzd99NhPIGLijTVZI/J9xZMZGj/gS
        Pgv4GYBC+ZE2w+qCsfBLdWHg6SscbUbQ3jLnQQmSgSPKnWgm4L8GrLrfT5+vl6ag8+cKpU
        UTN5cjQBzIvn5pAfCSRsYDXaoF/f60U=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: selftests: Use TEST_REQUIRE() in nx_huge_pages_test
Date:   Fri, 12 Aug 2022 17:53:01 +0000
Message-Id: <20220812175301.3915004-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid boilerplate for checking test preconditions by using
TEST_REQUIRE(). While at it, add a precondition for
KVM_CAP_VM_DISABLE_NX_HUGE_PAGES to skip (instead of silently pass) on
older kernels.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 24 +++++--------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index cc6421716400..e19933ea34ca 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -118,13 +118,6 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
 	vm = vm_create(1);
 
 	if (disable_nx_huge_pages) {
-		/*
-		 * Cannot run the test without NX huge pages if the kernel
-		 * does not support it.
-		 */
-		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
-			return;
-
 		r = __vm_disable_nx_huge_pages(vm);
 		if (reboot_permissions) {
 			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
@@ -248,18 +241,13 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (token != MAGIC_TOKEN) {
-		print_skip("This test must be run with the magic token %d.\n"
-			   "This is done by nx_huge_pages_test.sh, which\n"
-			   "also handles environment setup for the test.",
-			   MAGIC_TOKEN);
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
+	TEST_REQUIRE(reclaim_period_ms > 0);
 
-	if (!reclaim_period_ms) {
-		print_skip("The NX reclaim period must be specified and non-zero");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(token == MAGIC_TOKEN,
+		       "This test must be run with the magic token %d.\n"
+		       "This is done by nx_huge_pages_test.sh, which\n"
+		       "also handles environment setup for the test.");
 
 	run_test(reclaim_period_ms, false, reboot_permissions);
 	run_test(reclaim_period_ms, true, reboot_permissions);

base-commit: 93472b79715378a2386598d6632c654a2223267b
-- 
2.37.1.595.g718a3a8f04-goog

