Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2C44A4DF
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241828AbhKICmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241775AbhKICmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64854C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:28 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso11984353pfu.7
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7PZd0x6lPt+COIUe7s6j5utQGrhaF5ukxN/0RXAhVWo=;
        b=KkxlOHxbD8sX4/BavdqqOCubN6USToniJ7DdIIAxOUptOkCQavMqqZXwLDQ47hcYxP
         JFyldCgg3BC3Q6ZzfJ6TjKHhFJ0nr/Xp4z6O1LxiDizBwHCYUSvyC5kmEZgOE4IyjR4T
         BicOJ+yQdSq9NtYqEyWBjh0Al+TzfTBWifD1N3o5770pW9r2oJBsxgn4fX1O1pAQt7L/
         CVo7PvNm8WBKi9+pCuA7lNNGYOgvyBdSlTIXdsDue7T4JhIVJ4Gn5yS46ro0tJHlg6zB
         qbZS5P5P7EZSI9N/LZNV+VSRUKdXOjmp/K+hR6AD+DBQQ9TmlOpEc7Cc0sCon22wj9Wt
         6srg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7PZd0x6lPt+COIUe7s6j5utQGrhaF5ukxN/0RXAhVWo=;
        b=k/YHb4uf/uN5wRBt9XDhGZ73CIsaF17YBjJA/A61UTu1RokJYEz7gQhYoJ/AOuXibA
         1Q1TCYQnx9lIh6HPON1Km8LpTtE96gOUWh+8iZ/um6uHnARWw+xlAlko1U4YVXPsahU2
         JzLlRFVaDHmQ6UvI83WG7AWurJ1LH77qh6BS/RZLSeQ0Mh8KNq9A0JrFDSfUSI7QCjZc
         wn7BzkQY5dOJMPoKl0rSgzftiMuHxUQhauBq3v7h3mlVEzlq0gg7YKTuzIprIAz9K3+Q
         RVeeTMUDdcgrlwe5xrdgjEG0ByMrxmNbLaXhks8yWH7dQnFvfNaxzb4W47cIznVfEC5U
         H4UQ==
X-Gm-Message-State: AOAM533ml9LQyo0sk5AAOtxiqqRBrw9N4xwHtaJQOFDNPCQDEC+Xpx8s
        ldIXJgKLaZd2E98XRyYUnd5nxhMFUZoRZgFznGPyjo0GogdPUkAQE7a0iRYC/QrYk/UQOGYaZJK
        eI6M3RKp5tIKOCYqGrMsqUfWKmEIBPILIkvWf9cIaFTnFTgRr51XBX7Pl2EzaESA=
X-Google-Smtp-Source: ABdhPJyZeUY1gD4uhMncXTUXTVCynHHQyEClaB3J19aVo94b9xq6INrEPKCtUNuTetOpfR96X8W9qAtSLlzsKA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr137439pjf.1.1636425567125; Mon, 08 Nov 2021 18:39:27 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:58 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 09/17] KVM: selftests: aarch64: cmdline arg to set EOI mode in vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new cmdline arg to set the EOI mode for all vgic_irq tests.  This
specifies whether a write to EOIR will deactivate IRQs or not.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 58 ++++++++++++++++---
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 0b89a29dfe79..3e18fa224280 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -29,6 +29,7 @@
  */
 struct test_args {
 	uint32_t nr_irqs; /* number of KVM supported IRQs. */
+	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
 };
 
 /*
@@ -112,7 +113,7 @@ static uint64_t gic_read_ap1r0(void)
 	return reg;
 }
 
-static void guest_irq_handler(struct ex_regs *regs)
+static void guest_irq_generic_handler(bool eoi_split)
 {
 	uint32_t intid = gic_get_and_ack_irq();
 
@@ -129,6 +130,8 @@ static void guest_irq_handler(struct ex_regs *regs)
 
 	gic_set_eoi(intid);
 	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+	if (eoi_split)
+		gic_set_dir(intid);
 
 	GUEST_ASSERT(!gic_irq_get_active(intid));
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
@@ -151,6 +154,24 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
+#define CAT_HELPER(a, b) a ## b
+#define CAT(a, b) CAT_HELPER(a, b)
+#define PREFIX guest_irq_handler_
+#define GUEST_IRQ_HANDLER_NAME(split) CAT(PREFIX, split)
+#define GENERATE_GUEST_IRQ_HANDLER(split)					\
+static void CAT(PREFIX, split)(struct ex_regs *regs)				\
+{										\
+	guest_irq_generic_handler(split);					\
+}
+
+GENERATE_GUEST_IRQ_HANDLER(0);
+GENERATE_GUEST_IRQ_HANDLER(1);
+
+static void (*guest_irq_handlers[2])(struct ex_regs *) = {
+	GUEST_IRQ_HANDLER_NAME(0),
+	GUEST_IRQ_HANDLER_NAME(1),
+};
+
 static void reset_priorities(struct test_args *args)
 {
 	int i;
@@ -220,6 +241,8 @@ static void guest_code(struct test_args args)
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
 
+	gic_set_eoi_split(args.eoi_split);
+
 	reset_priorities(&args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
@@ -268,10 +291,11 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 
 static void print_args(struct test_args *args)
 {
-	printf("nr-irqs=%d\n", args->nr_irqs);
+	printf("nr-irqs=%d eoi-split=%d\n",
+			args->nr_irqs, args->eoi_split);
 }
 
-static void test_vgic(uint32_t nr_irqs)
+static void test_vgic(uint32_t nr_irqs, bool eoi_split)
 {
 	struct ucall uc;
 	int gic_fd;
@@ -280,6 +304,7 @@ static void test_vgic(uint32_t nr_irqs)
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
+		.eoi_split = eoi_split,
 	};
 
 	print_args(&args);
@@ -297,7 +322,7 @@ static void test_vgic(uint32_t nr_irqs)
 			GICD_BASE_GPA, GICR_BASE_GPA);
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
-			guest_irq_handler);
+			guest_irq_handlers[args.eoi_split]);
 
 	while (1) {
 		vcpu_run(vm, VCPU_ID);
@@ -328,8 +353,11 @@ static void help(const char *name)
 {
 	printf(
 	"\n"
-	"usage: %s [-n num_irqs]\n", name);
-	printf(" -n: specify the number of IRQs to configure the vgic with.\n");
+	"usage: %s [-n num_irqs] [-e eoi_split]\n", name);
+	printf(" -n: specify the number of IRQs to configure the vgic with. "
+		"It has to be a multiple of 32 and between 64 and 1024.\n");
+	printf(" -e: if 1 then EOI is split into a write to DIR on top "
+		"of writing EOI.\n");
 	puts("");
 	exit(1);
 }
@@ -337,18 +365,24 @@ static void help(const char *name)
 int main(int argc, char **argv)
 {
 	uint32_t nr_irqs = 64;
+	bool default_args = true;
 	int opt;
+	bool eoi_split = false;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	while ((opt = getopt(argc, argv, "hg:n:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:e:")) != -1) {
 		switch (opt) {
 		case 'n':
 			nr_irqs = atoi(optarg);
 			if (nr_irqs > 1024 || nr_irqs % 32)
 				help(argv[0]);
 			break;
+		case 'e':
+			eoi_split = (bool)atoi(optarg);
+			default_args = false;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -356,7 +390,15 @@ int main(int argc, char **argv)
 		}
 	}
 
-	test_vgic(nr_irqs);
+	/* If the user just specified nr_irqs and/or gic_version, then run all
+	 * combinations.
+	 */
+	if (default_args) {
+		test_vgic(nr_irqs, false /* eoi_split */);
+		test_vgic(nr_irqs, true /* eoi_split */);
+	} else {
+		test_vgic(nr_irqs, eoi_split);
+	}
 
 	return 0;
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

