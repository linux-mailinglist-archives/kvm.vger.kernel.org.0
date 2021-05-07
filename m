Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDD376AFD
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhEGUFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEGUFj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/K0CnBhiT6mojV4SkAxOCMYzXjv5gOKz3LE3qfbV3o=;
        b=RnrOwd+2g7Qw1dJRrSUe7Y10j6nG8l9il4WLnUr1WKmWhxZY6eLZ3b5BoyETjhJTtZJcGy
        XQF2FQPFsoMy4gmRzZk3qS1/nCbB1MdlQd7LQuX4h40oFpBLbMolkb0tK/f5Zpr97XAJe0
        MdNPGIYJO6d+OfG3GRCEUe7sMoAG8mA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-oIvfxYOxODKDxT7oPg7wGg-1; Fri, 07 May 2021 16:04:35 -0400
X-MC-Unique: oIvfxYOxODKDxT7oPg7wGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AF531854E21;
        Fri,  7 May 2021 20:04:34 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5251B19D61;
        Fri,  7 May 2021 20:04:32 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 4/6] KVM: arm64: selftests: get-reg-list: Provide config selection option
Date:   Fri,  7 May 2021 22:04:14 +0200
Message-Id: <20210507200416.198055-5-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new command line option that allows the user to select a specific
configuration, e.g. --config:sve will give the sve config. Also provide
help text and the --help/-h options.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 76 +++++++++++++++++--
 1 file changed, 70 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 68d3be86d490..f5e122b6b257 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -38,6 +38,17 @@
 #define reg_list_sve() (false)
 #endif
 
+enum {
+	VREGS,
+	SVE,
+};
+
+static char * const vcpu_config_names[] = {
+	[VREGS] = "vregs",
+	[SVE] = "sve",
+	NULL
+};
+
 static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
 
@@ -502,34 +513,87 @@ static void run_test(struct vcpu_config *c)
 	kvm_vm_free(vm);
 }
 
+static void help(void)
+{
+	char * const *n;
+
+	printf(
+	"\n"
+	"usage: get-reg-list [--config:<selection>[,<selection>...]] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
+	" --config:<selection>[,<selection>...] Used to select a specific vcpu configuration for the test/listing\n"
+	"                                       '<selection>' may be\n");
+
+	for (n = &vcpu_config_names[0]; *n; ++n)
+	printf("                                         '%s'\n", *n);
+
+	printf(
+	"\n"
+	" --list                                Print the register list rather than test it (requires --config)\n"
+	" --list-filtered                       Print registers that would normally be filtered out (requires --config)\n"
+	" --core-reg-fixup                      Needed when running on old kernels with broken core reg listings\n"
+	"\n"
+	);
+}
+
+static struct vcpu_config *parse_config(const char *config)
+{
+	struct vcpu_config *c = NULL;
+	int i;
+
+	if (config[8] != ':')
+		help(), exit(1);
+
+	for (i = 0; i < ARRAY_SIZE(vcpu_config_names) - 1; ++i) {
+		if (strcmp(vcpu_config_names[i], &config[9]) == 0) {
+			c = vcpu_configs[i];
+			break;
+		}
+	}
+
+	if (!c)
+		help(), exit(1);
+
+	return c;
+}
+
 int main(int ac, char **av)
 {
-	struct vcpu_config *c;
+	struct vcpu_config *c = NULL;
 	bool print_list = false, print_filtered = false;
 	int i;
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
 			fixup_core_regs = true;
+		else if (strncmp(av[i], "--config", 8) == 0)
+			c = parse_config(av[i]);
 		else if (strcmp(av[i], "--list") == 0)
 			print_list = true;
 		else if (strcmp(av[i], "--list-filtered") == 0)
 			print_filtered = true;
+		else if (strcmp(av[i], "--help") == 0 || strcmp(av[1], "-h") == 0)
+			help(), exit(0);
 		else
-			TEST_FAIL("Unknown option: %s\n", av[i]);
+			help(), exit(1);
 	}
 
 	if (print_list || print_filtered) {
 		/*
 		 * We only want to print the register list of a single config.
-		 * TODO: Add command line support to pick which config.
 		 */
-		c = vcpu_configs[0];
+		if (!c)
+			help(), exit(1);
 		check_supported(c);
 		print_reg_list(c, print_list, print_filtered);
 		return 0;
 	}
 
+	if (c) {
+		check_supported(c);
+		run_test(c);
+		return 0;
+	}
+
 	for (i = 0, c = vcpu_configs[0]; c; ++i, c = vcpu_configs[i]) {
 		check_supported(c);
 		run_test(c);
@@ -917,7 +981,7 @@ static __u64 sve_rejects_set[] = {
 };
 
 static struct vcpu_config vregs_config = {
-	"vregs",
+	vcpu_config_names[VREGS],
 	.sublists = {
 	{ base_regs,	ARRAY_SIZE(base_regs), },
 	{ vregs,	ARRAY_SIZE(vregs), },
@@ -925,7 +989,7 @@ static struct vcpu_config vregs_config = {
 	},
 };
 static struct vcpu_config sve_config = {
-	"sve", .sve = true,
+	vcpu_config_names[SVE], .sve = true,
 	.sublists = {
 	{ base_regs,	ARRAY_SIZE(base_regs), },
 	{ sve_regs,	ARRAY_SIZE(sve_regs),	sve_rejects_set,	ARRAY_SIZE(sve_rejects_set), },
-- 
2.30.2

