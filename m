Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691054F0541
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244411AbiDBRmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 13:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243941AbiDBRmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 13:42:44 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286F2E095
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 10:40:52 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id o17-20020a92c691000000b002c2c04aebe7so3733615ilg.8
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 10:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LigwUYYC4VhhxtS09KVFjs0sG5saYpBwvbWZHNyydng=;
        b=NKUIbjH0SKkdci4xkrqxucxb4e10J6YzgfEfrWlPOqo3uYmRUoKeqDouP/VcaTUvyo
         IBtov8VN/WlMjY1AwlrTF/UlDsXZZhQIup+60SHoXNF+IBnrEq80Jm/xGAPE6FtblLO8
         S7FspLtgNxHx0//bc+A+whljvxEEpt6UgvRU4fLs4jyX+w5O1S1NuhIVpg2TKj6f0vB2
         vSN32ViMyY0L3YTcACI6hYyldUmccE3BfHkJJoXNav/9Q6QCb7WI7RCLQ1wiPhvL36TZ
         fM4kSaF2LZOqxDIoXOO1LhhCS324eDYXPaixU4V3ueEMIRLgJBAfcTEA6elYTHEqMW23
         f95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LigwUYYC4VhhxtS09KVFjs0sG5saYpBwvbWZHNyydng=;
        b=RPDf3qCRfJErNr3pjeMbwFMpFjZD1Rz4ySAaACdEaPLq817WGNRJwwQ/nCjbmpsdJ2
         I7ntW6dENn35XMzOf82f03uGkOvxSNdDTeLOSj2IWCVOiuqivydI4ZabYWGgY93D/8UJ
         VEO03TtCmXtuEpqMaBdQ345a465NGTZ3g2fe2KPS9bluk6kYSDssMOpCqtYOf7ou+ba/
         x5zoDy/i1FP4DNgmCQTSxKJEyxCzmSip/hZVEoXLx7R9nQjsw7sQlKOM47obbTxbCasU
         iMqfVMxHdrdEuS+gLI51qMdFw33/k8+PlwYGZmvVpyRabnwVVI7SMTfO0KZob8rO8EUK
         cbAA==
X-Gm-Message-State: AOAM530DQhezcFF2AtOXCZtSGBgM5hajAme/4UnixeyjmnG7WkSVqUEp
        inLna2xWztIz1RtPQ5fMowf89BqntlE=
X-Google-Smtp-Source: ABdhPJzrUyhT2WOyKdGPJLj7xi4+5aFDvMGMKgqgDavuwSTfoHM1dfGkKHZDJs1ky+LEGuWCsDpRGcVe1NE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:d88:b0:2c8:713f:dcff with SMTP id
 i8-20020a056e020d8800b002c8713fdcffmr2189656ilj.289.1648921251615; Sat, 02
 Apr 2022 10:40:51 -0700 (PDT)
Date:   Sat,  2 Apr 2022 17:40:43 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-4-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 3/4] selftests: KVM: Don't leak GIC FD across dirty log test iterations
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dirty_log_perf_test instantiates a VGICv3 for the guest (if supported by
hardware) to reduce the overhead of guest exits. However, the test does
not actually close the GIC fd when cleaning up the VM between test
iterations, meaning that the VM is never actually destroyed in the
kernel.

While this is generally a bad idea, the bug was detected from the kernel
spewing about duplicate debugfs entries as subsequent VMs happen to
reuse the same FD even though the debugfs directory is still present.

Abstract away the notion of setup/cleanup of the GIC FD from the test
by creating arch-specific helpers for test setup/cleanup. Close the GIC
FD on VM cleanup and do nothing for the other architectures.

Fixes: c340f7899af6 ("KVM: selftests: Add vgic initialization for dirty log perf test for ARM")
Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c9d9e513ca04..7b47ae4f952e 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,11 +18,40 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
 #define GICD_BASE_GPA			0x8000000ULL
 #define GICR_BASE_GPA			0x80A0000ULL
+
+static int gic_fd;
+
+static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
+{
+	/*
+	 * The test can still run even if hardware does not support GICv3, as it
+	 * is only an optimization to reduce guest exits.
+	 */
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+}
+
+static void arch_cleanup_vm(struct kvm_vm *vm)
+{
+	if (gic_fd > 0)
+		close(gic_fd);
+}
+
+#else /* __aarch64__ */
+
+static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
+{
+}
+
+static void arch_cleanup_vm(struct kvm_vm *vm)
+{
+}
+
 #endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
@@ -206,9 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
-#ifdef __aarch64__
-	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-#endif
+	arch_setup_vm(vm, nr_vcpus);
 
 	/* Start the iterations */
 	iteration = 0;
@@ -302,6 +329,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	}
 
 	free_bitmaps(bitmaps, p->slots);
+	arch_cleanup_vm(vm);
 	perf_test_destroy_vm(vm);
 }
 
-- 
2.35.1.1094.g7c7d902a7c-goog

