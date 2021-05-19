Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B491C388FEA
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353885AbhESOJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 10:09:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347041AbhESOJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 10:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621433264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7GTQBNGZoTX0xb+GuNByFAV5LQVduIalFtZy8xJ1/rU=;
        b=Q1IIC7YY2wk/d/bCukSRRixNCuBvql7+NqVO8JXo9CJ/dxfxeO3vRopNTk56Pwuh5ZLUyl
        eRcBHL9iFTXESA1Uso+DrBKuqHeTEdXQRhSBbONN+1mKgnY2VvH5i16jdXF7ZB52WPPYM6
        bcWyXYl8rJ+OVktohxzt3vIwCe7i6+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-VkdFJco2M3uZy_aO1_Nmdg-1; Wed, 19 May 2021 10:07:40 -0400
X-MC-Unique: VkdFJco2M3uZy_aO1_Nmdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FD8101371E;
        Wed, 19 May 2021 14:07:39 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B19810013C1;
        Wed, 19 May 2021 14:07:32 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 2/5] KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs at once
Date:   Wed, 19 May 2021 16:07:23 +0200
Message-Id: <20210519140726.892632-3-drjones@redhat.com>
In-Reply-To: <20210519140726.892632-1-drjones@redhat.com>
References: <20210519140726.892632-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index e5d9cb312717..06f737973511 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -53,8 +53,8 @@ struct vcpu_config {
 	struct reg_sublist sublists[];
 };
 
-static struct vcpu_config vregs_config;
-static struct vcpu_config sve_config;
+static struct vcpu_config *vcpu_configs[];
+static int vcpu_configs_n;
 
 #define for_each_sublist(c, s)							\
 	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
@@ -351,29 +351,20 @@ static void check_supported(struct vcpu_config *c)
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
@@ -393,7 +384,7 @@ int main(int ac, char **av)
 				print_reg(c, id);
 		}
 		putchar('\n');
-		return 0;
+		return;
 	}
 
 	/*
@@ -492,6 +483,44 @@ int main(int ac, char **av)
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
 		    c->name, missing_regs, failed_get, failed_set, failed_reject);
 
+	pr_info("%s: PASS\n", c->name);
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
 
@@ -889,3 +918,8 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+
+static struct vcpu_config *vcpu_configs[] = {
+	reg_list_sve() ? &sve_config : &vregs_config,
+};
+static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.30.2

