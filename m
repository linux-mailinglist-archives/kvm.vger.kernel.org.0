Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE98D3958FA
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhEaKfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhEaKfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622457239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ak/JVpt5VjrHCT0yuMxYvCWZQxr6SPN1itqhUbp05tI=;
        b=LqROm3zTZVHES9mXuXOrCB/eAhK8SIRZCyEkJZzDh8qmh/9Otcxp1tHQmGADQlDtJchGh9
        0P9dKKklKm/UZMOUr3hglXo17vBqq4WqZLjM+BBN/LZZwWljJA58S4T6xs1saztzubXT0u
        Vclte4eHh1AfQ61UbFTuLajGQRflWj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-jHTQYOXMMU-i3xPadOjp9A-1; Mon, 31 May 2021 06:33:57 -0400
X-MC-Unique: jHTQYOXMMU-i3xPadOjp9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D4371013722;
        Mon, 31 May 2021 10:33:56 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 539DD5D9CD;
        Mon, 31 May 2021 10:33:54 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v3 2/5] KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs at once
Date:   Mon, 31 May 2021 12:33:41 +0200
Message-Id: <20210531103344.29325-3-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't want to have to create a new binary for each vcpu config, so
prepare to run the test for multiple vcpu configs in a single binary.
We do this by factoring out the test from main() and then looping over
configs. When given '--list' we still never print more than a single
reg-list for a single vcpu config though, because it would be confusing
otherwise.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 68 ++++++++++++++-----
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 7bb09ce20dde..14fc8d82e30f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -56,8 +56,8 @@ struct vcpu_config {
 	struct reg_sublist sublists[];
 };
 
-static struct vcpu_config vregs_config;
-static struct vcpu_config sve_config;
+static struct vcpu_config *vcpu_configs[];
+static int vcpu_configs_n;
 
 #define for_each_sublist(c, s)							\
 	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
@@ -400,29 +400,20 @@ static void check_supported(struct vcpu_config *c)
 	}
 }
 
-int main(int ac, char **av)
+static bool print_list;
+static bool print_filtered;
+static bool fixup_core_regs;
+
+static void run_test(struct vcpu_config *c)
 {
-	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
 	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
-	bool print_list = false, print_filtered = false, fixup_core_regs = false;
 	struct kvm_vm *vm;
 	struct reg_sublist *s;
 
 	check_supported(c);
 
-	for (i = 1; i < ac; ++i) {
-		if (strcmp(av[i], "--core-reg-fixup") == 0)
-			fixup_core_regs = true;
-		else if (strcmp(av[i], "--list") == 0)
-			print_list = true;
-		else if (strcmp(av[i], "--list-filtered") == 0)
-			print_filtered = true;
-		else
-			TEST_FAIL("Unknown option: %s\n", av[i]);
-	}
-
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
@@ -442,7 +433,7 @@ int main(int ac, char **av)
 				print_reg(c, id);
 		}
 		putchar('\n');
-		return 0;
+		return;
 	}
 
 	/*
@@ -541,6 +532,44 @@ int main(int ac, char **av)
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
 		    config_name(c), missing_regs, failed_get, failed_set, failed_reject);
 
+	pr_info("%s: PASS\n", config_name(c));
+	blessed_n = 0;
+	free(blessed_reg);
+	free(reg_list);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	struct vcpu_config *c, *sel = NULL;
+	int i;
+
+	for (i = 1; i < ac; ++i) {
+		if (strcmp(av[i], "--core-reg-fixup") == 0)
+			fixup_core_regs = true;
+		else if (strcmp(av[i], "--list") == 0)
+			print_list = true;
+		else if (strcmp(av[i], "--list-filtered") == 0)
+			print_filtered = true;
+		else
+			TEST_FAIL("Unknown option: %s\n", av[i]);
+	}
+
+	if (print_list || print_filtered) {
+		/*
+		 * We only want to print the register list of a single config.
+		 * TODO: Add command line support to pick which config.
+		 */
+		sel = vcpu_configs[0];
+	}
+
+	for (i = 0; i < vcpu_configs_n; ++i) {
+		c = vcpu_configs[i];
+		if (sel && c != sel)
+			continue;
+		run_test(c);
+	}
+
 	return 0;
 }
 
@@ -945,3 +974,8 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+
+static struct vcpu_config *vcpu_configs[] = {
+	reg_list_sve() ? &sve_config : &vregs_config,
+};
+static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.31.1

