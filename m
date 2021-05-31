Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC785395900
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhEaKft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:35:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhEaKfo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622457244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48lhE5C9Bp6I7YDXh1OuJHO4D0lfrHenvSLim7QkDdM=;
        b=Q9Xeu5zRUYyezCvkxK8Rw0w/CAqyC6dfOPlHWA5FlXQ6WR62OKRQvGhhBRy4oeHwW2XJpF
        0+rgVNfw7TDJJfwqpt3r1LEOeVQGGRdXw2eUCPA672BD/nCkssLrDNTwUr5UcA04iwphtH
        RA0S9ZdgLVj58MPlHBmcpcq/nqOWncY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-FLUBxI-KP-KsKHvdwcIC1w-1; Mon, 31 May 2021 06:34:02 -0400
X-MC-Unique: FLUBxI-KP-KsKHvdwcIC1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94F4F19251A3;
        Mon, 31 May 2021 10:34:01 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81C465D9CD;
        Mon, 31 May 2021 10:33:59 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v3 4/5] KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
Date:   Mon, 31 May 2021 12:33:43 +0200
Message-Id: <20210531103344.29325-5-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 .../selftests/kvm/aarch64/get-reg-list.c      | 31 +++++++++++++------
 4 files changed, 21 insertions(+), 15 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 524c857a049c..dd36575b732a 100644
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
index daaee1888b12..5c8f3725a7f0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -79,7 +79,6 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
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
index 03e041d97a18..b46b8a1fdc0c 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -27,16 +27,13 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
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
 static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
 
@@ -588,7 +585,8 @@ static struct vcpu_config *parse_config(const char *config)
 int main(int ac, char **av)
 {
 	struct vcpu_config *c, *sel = NULL;
-	int i;
+	int i, ret = 0;
+	pid_t pid;
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
@@ -617,10 +615,22 @@ int main(int ac, char **av)
 		c = vcpu_configs[i];
 		if (sel && c != sel)
 			continue;
-		run_test(c);
+
+		pid = fork();
+
+		if (!pid) {
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
@@ -1026,6 +1036,7 @@ static struct vcpu_config sve_config = {
 };
 
 static struct vcpu_config *vcpu_configs[] = {
-	reg_list_sve() ? &sve_config : &vregs_config,
+	&vregs_config,
+	&sve_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.31.1

