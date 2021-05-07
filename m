Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCC376AF7
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhEGUFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhEGUFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5HDSKGvyrRWSdAILh2m5YfuLdjo3ynQDCxiblsihEE=;
        b=Ty6XR4Z8BftjutQvNFjA8up1NCMCEF0X2mutQhJD4Izdilf6rc8FOmZ2vT5S2KEohdMFBT
        66ZWpbNXaDhnv5KJseoncatrapz1n/CD/hKs/2suQtK/4vnTP3dZmuXVgZTeWR1H8gGZ5I
        vsRtCiQKLNxEZOfUyh9DW8pT/CGk6IE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-2PappjDtOrORx5A-YqW9jw-1; Fri, 07 May 2021 16:04:28 -0400
X-MC-Unique: 2PappjDtOrORx5A-YqW9jw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC7AB8014D8;
        Fri,  7 May 2021 20:04:26 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B964B19D61;
        Fri,  7 May 2021 20:04:24 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 1/6] KVM: arm64: selftests: get-reg-list: Factor out printing
Date:   Fri,  7 May 2021 22:04:11 +0200
Message-Id: <20210507200416.198055-2-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A later patch will need the printing to be factored out of the test
code. To factor out the printing we also factor out the reg-list
initialization.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 62 +++++++++++++------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 486932164cf2..44d560a8ca45 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <assert.h>
 #include "kvm_util.h"
 #include "test_util.h"
 #include "processor.h"
@@ -336,12 +337,47 @@ static void check_supported(void)
 	}
 }
 
-int main(int ac, char **av)
+static bool fixup_core_regs;
+
+static void reg_list_init(struct kvm_vm *vm)
 {
 	struct kvm_vcpu_init init = { .target = -1, };
+
+	prepare_vcpu_init(&init);
+	aarch64_vcpu_add_default(vm, 0, &init, NULL);
+	finalize_vcpu(vm, 0);
+
+	reg_list = vcpu_get_reg_list(vm, 0);
+
+	if (fixup_core_regs)
+		core_reg_fixup();
+}
+
+static void print_reg_list(bool print_list, bool print_filtered)
+{
+	struct kvm_vm *vm;
+	int i;
+
+	assert(print_list || print_filtered);
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	reg_list_init(vm);
+
+	putchar('\n');
+	for_each_reg(i) {
+		__u64 id = reg_list->reg[i];
+		if ((print_list && !filter_reg(id)) ||
+		    (print_filtered && filter_reg(id)))
+			print_reg(id);
+	}
+	putchar('\n');
+}
+
+int main(int ac, char **av)
+{
 	int new_regs = 0, missing_regs = 0, i;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
-	bool print_list = false, print_filtered = false, fixup_core_regs = false;
+	bool print_list = false, print_filtered = false;
 	struct kvm_vm *vm;
 	__u64 *vec_regs;
 
@@ -358,28 +394,14 @@ int main(int ac, char **av)
 			TEST_FAIL("Unknown option: %s\n", av[i]);
 	}
 
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
-	prepare_vcpu_init(&init);
-	aarch64_vcpu_add_default(vm, 0, &init, NULL);
-	finalize_vcpu(vm, 0);
-
-	reg_list = vcpu_get_reg_list(vm, 0);
-
-	if (fixup_core_regs)
-		core_reg_fixup();
-
 	if (print_list || print_filtered) {
-		putchar('\n');
-		for_each_reg(i) {
-			__u64 id = reg_list->reg[i];
-			if ((print_list && !filter_reg(id)) ||
-			    (print_filtered && filter_reg(id)))
-				print_reg(id);
-		}
-		putchar('\n');
+		print_reg_list(print_list, print_filtered);
 		return 0;
 	}
 
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	reg_list_init(vm);
+
 	/*
 	 * We only test that we can get the register and then write back the
 	 * same value. Some registers may allow other values to be written
-- 
2.30.2

