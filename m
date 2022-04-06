Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FC44F6EE3
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiDFX6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiDFX6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:58:23 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA3C5590
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:56:25 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id r16-20020a056e02109000b002ca35f87493so2716230ilj.22
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
        b=CxQm71obckQx1ot8ttP2ziACqWcKGK4akKG1COLV+bQWzBRg9Azn3q2fUw6u0mZ4La
         mlTSehKe88RUN3Cqari2K1UKweOzh7gRY7rvke0Sxra/LR5yabTeWR3pb6gABgpAiFbh
         3LDUmHjknj3TOpwWLKKUTTr8xa2BRA6ZKHLZWppjCqiXKxKE/+315ZNXsiA0KQ1Himyk
         YBv93Eof/Lgya4aIH5+cvdaqrqFkT48ZnEXupNIiuuliGu6MX1nMotBFktHb532z7a6I
         14qW8I7whAReD61AEBQsI04P7UtTOM97tMAbHs6qs1AgQwe85gA4jCx8P8vj1JGqCJWd
         63PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
        b=qf7/b4IiuDtjdYRWAzgiYA5WpLpw3QwPX+yKY0fFgIukclIKu2r6i9ToRlpxmNCAQH
         UCi7Ccv3UYZmXt4BsdCJuZW8wOWp8ee/U8Aia+/N0TWVKBrqdBDuc7O/ABZCfwwrtMGC
         ohFHJ9g1SSs0CuvK2Q6fiTgvXYKVTolQg1ilU61qtE0MSKRCuyihsfz8valknXT7OpoI
         tGYQJNFp7jtbuV0kwj+Ubzc6mbi0YpDIVj5Kl0Ujn1AaA0R9lRPkY4KBbwrzxlTdO1Ml
         i8qcxTJstSYkyNY4/D6yxXTZUDM6qwyJFtPAJrlElu0wdM9/TQYt5VtcZU6St4u2eRwB
         rW6Q==
X-Gm-Message-State: AOAM5314+nU+ToZYQGZZ3GBSaFU32il9Ts8daAJpo97IglJBaMQwiHXb
        SXtclB7AI/ERU3cSy49j+pA/pLqi0ZI=
X-Google-Smtp-Source: ABdhPJxZYhapYayA71PbkdV1563SUH1JsWUENhomJcQekruoJ8CSaLV4CpWvvqb90+EKwQyAk2ignByhlAY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7513:0:b0:2b9:5b61:e376 with SMTP id
 q19-20020a927513000000b002b95b61e376mr5694259ilc.193.1649289384698; Wed, 06
 Apr 2022 16:56:24 -0700 (PDT)
Date:   Wed,  6 Apr 2022 23:56:14 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-3-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 2/3] selftests: KVM: Don't leak GIC FD across dirty log
 test iterations
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
Reviewed-by: Jing Zhang <jingzhangos@google.com>
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

