Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C2376AFE
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhEGUFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhEGUFk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HAbS4DSaHwq3VjIy/QN5U+O97794StrG8eQAE/Tm1ng=;
        b=Wo2H6Gd97ibX3QXM1weyOksLdFXHaJ2Tsdjbu7UPGrlJm0Hd5PHNVQdW1FFreQEegKt4nJ
        f+Jc293jfSvxyjiJt+hCwoX5S78wO2HK5dddMqgxKOMGfShV9D9db4+SIrTWvjlCmpk8X1
        zaG/rBV/lAP5qyFZS4zss2HdiJ0yI5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-Fyc_Iuo1MxeENksMuIHMug-1; Fri, 07 May 2021 16:04:37 -0400
X-MC-Unique: Fyc_Iuo1MxeENksMuIHMug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDE271006C80;
        Fri,  7 May 2021 20:04:36 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8FE51A865;
        Fri,  7 May 2021 20:04:34 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 5/6] KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
Date:   Fri,  7 May 2021 22:04:15 +0200
Message-Id: <20210507200416.198055-6-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can easily run the test for multiple vcpu configs, let's
merge get-reg-list and get-reg-list-sve into just get-reg-list. We
also add a final change to make it more possible to run multiple
tests, which is to fork the test, rather than directly run it. That
allows a test to fail, but subsequent tests can still run.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 -
 tools/testing/selftests/kvm/Makefile          |  1 -
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |  3 --
 .../selftests/kvm/aarch64/get-reg-list.c      | 31 ++++++++++++-------
 4 files changed, 20 insertions(+), 16 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index bd83158e0e0b..e3745c90d8b2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/get-reg-list
-/aarch64/get-reg-list-sve
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..bf54fc23bcff 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,7 +78,6 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
deleted file mode 100644
index efba76682b4b..000000000000
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
+++ /dev/null
@@ -1,3 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#define REG_LIST_SVE
-#include "get-reg-list.c"
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index f5e122b6b257..2f7caa0b9e57 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -27,17 +27,14 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <assert.h>
+#include <sys/types.h>
+#include <sys/wait.h>
 #include "kvm_util.h"
 #include "test_util.h"
 #include "processor.h"
 
-#ifdef REG_LIST_SVE
-#define reg_list_sve() (true)
-#else
-#define reg_list_sve() (false)
-#endif
-
 enum {
 	VREGS,
 	SVE,
@@ -560,7 +557,7 @@ int main(int ac, char **av)
 {
 	struct vcpu_config *c = NULL;
 	bool print_list = false, print_filtered = false;
-	int i;
+	int i, ret = 0;
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
@@ -595,11 +592,22 @@ int main(int ac, char **av)
 	}
 
 	for (i = 0, c = vcpu_configs[0]; c; ++i, c = vcpu_configs[i]) {
-		check_supported(c);
-		run_test(c);
+		pid_t pid = fork();
+
+		if (!pid) {
+			check_supported(c);
+			run_test(c);
+			exit(0);
+		} else {
+			int wstatus;
+			pid_t wpid = wait(&wstatus);
+			TEST_ASSERT(wpid == pid && WIFEXITED(wstatus), "wait: Unexpected return");
+			if (WEXITSTATUS(wstatus) && WEXITSTATUS(wstatus) != KSFT_SKIP)
+				ret = KSFT_FAIL;
+		}
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -998,6 +1006,7 @@ static struct vcpu_config sve_config = {
 };
 
 static struct vcpu_config *vcpu_configs[] = {
-	reg_list_sve() ? &sve_config : &vregs_config,
+	&vregs_config,
+	&sve_config,
 	NULL
 };
-- 
2.30.2

