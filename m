Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE7425ACF
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 20:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbhJGSe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJGSe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 14:34:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEDBC061570
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 11:32:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b11-20020a17090aa58b00b0019c8bfd57b8so3590387pjq.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 11:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=i6OEbiI8nlcVRWyoELZ1THHrO3woPs2C0f6nWf9PSk4=;
        b=mXR5zPdcv4MXtkg2imDp3q7q0/bEztvEq0fsPXhM84SSV5Us+5vTx3owGhop+XvCbs
         LhxEoD/DAKQznwMtjJqVH2eOGgyFwRbXkZO9um0j11iMwdAb4UV+7XHsj/rddZqkEmtw
         ZWcSJmaPT2/kXZb5cSiwitT7zOnBabZeIiQrjUlWvHmm1wz3yi3b0Ju46pc96bEZTt6l
         ekrL+dGlxbYrHSOCmUqQLb8CLB4q87NB7vm+fYd08OqbV952AP8bq26ZMaIMedtJ3zgx
         PHLzk/O20mxGbtOxtlEVlYEabRFzmWyuvVj2WePmgI9DNQsGaNgvukCY7PhCbwHgKC5p
         wCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=i6OEbiI8nlcVRWyoELZ1THHrO3woPs2C0f6nWf9PSk4=;
        b=CkKI8nhuK1n+kLHss7NMwWdgHLr1MJ/3NrM78HNFk7ivIALiLaGmpVlKIbvwWEUWwQ
         dzi8ZkaWpzjAZ5UoCQgE1Nw3H5NdVMoPZuHMdJCZ+k0dobgTEX6mcbAVl1JTfyoDQo1/
         I9Q677WuEEytBMKbzhMRuMmqNw1cgZlPoedLCB0Q9v+iJdUm1ZyuGxSkBakVv7MHTHr7
         AVxZm9N4KnFHWQoNqjC0At8ZV36Qcn/WUhl2pFNNnicAE0eNckjEeGKITLtTrcDXr908
         klUK2vaCAR9YQg7y9wMCEugHeaPRYJU2eoApn5v4QvPfpYo/8m4JbxBcrlh+KAQM966x
         z+MQ==
X-Gm-Message-State: AOAM533Dbm5yy6P/uKWqB3QmNSlq1pEmYNSE6RWjDawx6AYuOy6B3FXs
        7sbMcaIJRtocJtpfZR10KzJtWJRqYkwlseGHjfot10UpE/kfPODUXmTGGEciQiIZerl4j8XzoIH
        Bn19mLgJCNANXV7nPhVmvqNvjjMK+Vd1g2BjsYbXQbQyN6eKRAnZE4EIyYUPeSRY=
X-Google-Smtp-Source: ABdhPJy7oKg9elfYErbsHYmLS4lp7sNHRNhyxdLMfpQzT1qM4Nmm6PELIP83922J96gkNI0XU07DH5zFMHLEEg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e544:b0:13e:e863:6cd2 with SMTP
 id n4-20020a170902e54400b0013ee8636cd2mr5171887plf.41.1633631553089; Thu, 07
 Oct 2021 11:32:33 -0700 (PDT)
Date:   Thu,  7 Oct 2021 11:32:30 -0700
Message-Id: <20211007183230.2637929-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH] arm64: Add mmio_addr arg to arm/micro-bench
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a command line arg to arm/micro-bench to set the mmio_addr to other
values besides the default QEMU one. Default to the QEMU value if no arg
is passed. Also, the <NUM> in mmio_addr=<NUM> can't be a hex.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/micro-bench.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8e1d4ab..2c08813 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -19,16 +19,19 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <util.h>
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 #include <asm/timer.h>
 
-#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
+#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
+#define QEMU_MMIO_ADDR		0x0a000008
 
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
 static int nr_ipi_received;
+static unsigned long mmio_addr = QEMU_MMIO_ADDR;
 
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
@@ -278,12 +281,10 @@ static void *userspace_emulated_addr;
 static bool mmio_read_user_prep(void)
 {
 	/*
-	 * FIXME: Read device-id in virtio mmio here in order to
-	 * force an exit to userspace. This address needs to be
-	 * updated in the future if any relevant changes in QEMU
-	 * test-dev are made.
+	 * Read device-id in virtio mmio here in order to
+	 * force an exit to userspace.
 	 */
-	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
+	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
 	return true;
 }
 
@@ -378,10 +379,30 @@ static void loop_test(struct exit_test *test)
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
 }
 
+static void parse_args(int argc, char **argv)
+{
+	int i, len;
+	long val;
+
+	for (i = 0; i < argc; ++i) {
+		len = parse_keyval(argv[i], &val);
+		if (len == -1)
+			continue;
+
+		argv[i][len] = '\0';
+		if (strcmp(argv[i], "mmio-addr") == 0) {
+			mmio_addr = val;
+			report_info("found mmio_addr=0x%lx", mmio_addr);
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	int i;
 
+	parse_args(argc, argv);
+
 	if (!test_init())
 		return 1;
 
-- 
2.33.0.882.g93a45727a2-goog

