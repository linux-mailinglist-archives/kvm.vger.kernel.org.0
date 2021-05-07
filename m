Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC1C376AF8
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhEGUFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhEGUFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hF4RU+mW6w91UiYAvJJFN81TYJXmTJV1RSQ9fzh5Kxk=;
        b=JTYOLKuiSWCtujf71zYJRTSnq4hBDM4FxJ2aa2pMr94liu6BQhJSnZEosF90OpdYGZwW+X
        c8Hh7LU8dt9TBpywZkNNY2KSyEFo2jeX8tcNZUoiJurywOwgVu0d8VOxADUwkono20Zenh
        YAMKrpm9u3cmUHKoU87E9JvprxX8APA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-LKN17DpHNASvNB1sfGESpA-1; Fri, 07 May 2021 16:04:33 -0400
X-MC-Unique: LKN17DpHNASvNB1sfGESpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E978E1854E24;
        Fri,  7 May 2021 20:04:31 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D690A1A26A;
        Fri,  7 May 2021 20:04:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 3/6] KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs at once
Date:   Fri,  7 May 2021 22:04:13 +0200
Message-Id: <20210507200416.198055-4-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 .../selftests/kvm/aarch64/get-reg-list.c      | 72 +++++++++++++------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index fbbeee634722..68d3be86d490 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -54,8 +54,7 @@ struct vcpu_config {
 	struct reg_sublist sublists[];
 };
 
-static struct vcpu_config vregs_config;
-static struct vcpu_config sve_config;
+static struct vcpu_config *vcpu_configs[];
 
 #define for_each_sublist(c, s)							\
 	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
@@ -386,35 +385,18 @@ static void print_reg_list(struct vcpu_config *c, bool print_list, bool print_fi
 			print_reg(c, id);
 	}
 	putchar('\n');
+
+	free(reg_list);
+	kvm_vm_free(vm);
 }
 
-int main(int ac, char **av)
+static void run_test(struct vcpu_config *c)
 {
-	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
-	bool print_list = false, print_filtered = false;
 	struct kvm_vm *vm;
 	struct reg_sublist *s;
 
-	check_supported(c);
-
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
-	if (print_list || print_filtered) {
-		print_reg_list(c, print_list, print_filtered);
-		return 0;
-	}
-
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	reg_list_init(vm, c);
 
@@ -514,6 +496,45 @@ int main(int ac, char **av)
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
 		    c->name, missing_regs, failed_get, failed_set, failed_reject);
 
+	blessed_n = 0;
+	free(blessed_reg);
+	free(reg_list);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	struct vcpu_config *c;
+	bool print_list = false, print_filtered = false;
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
+		c = vcpu_configs[0];
+		check_supported(c);
+		print_reg_list(c, print_list, print_filtered);
+		return 0;
+	}
+
+	for (i = 0, c = vcpu_configs[0]; c; ++i, c = vcpu_configs[i]) {
+		check_supported(c);
+		run_test(c);
+	}
+
 	return 0;
 }
 
@@ -911,3 +932,8 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+
+static struct vcpu_config *vcpu_configs[] = {
+	reg_list_sve() ? &sve_config : &vregs_config,
+	NULL
+};
-- 
2.30.2

