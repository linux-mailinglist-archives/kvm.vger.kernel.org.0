Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFCE3958FB
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhEaKfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:35:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhEaKfl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622457242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fNFJWYJ5qP5ubawMUB9LySQn1LbFIskQpAnvNMRLr1o=;
        b=PxQWuK9Q5zXWCAjKoUTOj5SR3XGQiKhckwt5Y9Lu+dNJE0I1m2y8Dqa5VBbGXfmDIUFNgl
        +8LL1SGimZ6pmpIp8ToztD41dqIys11EmGhsPxNC/0W92p8oZKuMeO+NbInKoxqWxOts8e
        e6d6f74bk3YPnHCAYDqQrHqh295VbXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-8OdQoRj_MHy3q16DAmmpaQ-1; Mon, 31 May 2021 06:34:00 -0400
X-MC-Unique: 8OdQoRj_MHy3q16DAmmpaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B6CA1013722;
        Mon, 31 May 2021 10:33:59 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC4905D9CD;
        Mon, 31 May 2021 10:33:56 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v3 3/5] KVM: arm64: selftests: get-reg-list: Provide config selection option
Date:   Mon, 31 May 2021 12:33:42 +0200
Message-Id: <20210531103344.29325-4-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new command line option that allows the user to select a specific
configuration, e.g. --config=sve will give the sve config. Also provide
help text and the --help/-h options.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 56 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 14fc8d82e30f..03e041d97a18 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -539,6 +539,52 @@ static void run_test(struct vcpu_config *c)
 	kvm_vm_free(vm);
 }
 
+static void help(void)
+{
+	struct vcpu_config *c;
+	int i;
+
+	printf(
+	"\n"
+	"usage: get-reg-list [--config=<selection>] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
+	" --config=<selection>        Used to select a specific vcpu configuration for the test/listing\n"
+	"                             '<selection>' may be\n");
+
+	for (i = 0; i < vcpu_configs_n; ++i) {
+		c = vcpu_configs[i];
+		printf(
+	"                               '%s'\n", config_name(c));
+	}
+
+	printf(
+	"\n"
+	" --list                      Print the register list rather than test it (requires --config)\n"
+	" --list-filtered             Print registers that would normally be filtered out (requires --config)\n"
+	" --core-reg-fixup            Needed when running on old kernels with broken core reg listings\n"
+	"\n"
+	);
+}
+
+static struct vcpu_config *parse_config(const char *config)
+{
+	struct vcpu_config *c;
+	int i;
+
+	if (config[8] != '=')
+		help(), exit(1);
+
+	for (i = 0; i < vcpu_configs_n; ++i) {
+		c = vcpu_configs[i];
+		if (strcmp(config_name(c), &config[9]) == 0)
+			break;
+	}
+
+	if (i == vcpu_configs_n)
+		help(), exit(1);
+
+	return c;
+}
+
 int main(int ac, char **av)
 {
 	struct vcpu_config *c, *sel = NULL;
@@ -547,20 +593,24 @@ int main(int ac, char **av)
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
 			fixup_core_regs = true;
+		else if (strncmp(av[i], "--config", 8) == 0)
+			sel = parse_config(av[i]);
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
-		sel = vcpu_configs[0];
+		if (!sel)
+			help(), exit(1);
 	}
 
 	for (i = 0; i < vcpu_configs_n; ++i) {
-- 
2.31.1

