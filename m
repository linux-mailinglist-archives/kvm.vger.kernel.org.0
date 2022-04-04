Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED74F1B9B
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380489AbiDDVVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379928AbiDDSX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:23:27 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECBB22B20
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:21:30 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so6903656ioo.0
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
        b=tcxC71n8qRIQtoplY54rvL/t1PM0vquhFBE/lAZhF7XYLojblaLlklu7pRZ9UPnz2y
         1DCwD3eahwdyYR2x+Ew8gFONkQgrmXFyMrYjaAedHmdyKQpBNUDi7wvucA2nf0RRP4yj
         8OjE3G6p/9MKRMB/fxfL3GKqq53KeK6h/oL30r8siKj45GroFMnBACt2kw/jhcfQdX1P
         974RrKtOT0HPojjuNUxVR1SbbTgex41Y1OzCalE1p4ke0cTnIXpM+TDnXprsmKu77tq2
         TagfXw6GPklrVI7x9HWxjeG8KMzXtBHH0KsZRB90fzH0AifnWI5EC/CBe2S2gKzQjerQ
         GO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
        b=Jm2JojI2VJ1VM6fdgGkbbWgFtb8jGxl1oPtZ2+Wo9L2wBwVAeLUGXACwA1XmcnwXtG
         yDyP0DBVaDRyfpS1RaaWkJC3l52bnXGWMblVHYuByUrb+Rp8tTLqzjjgrKKlNqzz3gOx
         SE61XS0Pur5WIxIm/v17YfidRU9FWIIxqliWjacoZc6lK1z8J2I4DACzVHQnLxrPTBW5
         hG+JT0AwBdX4v8mGi7Fs3LxFdQPdq9aHcNnoM7UMAaAeOFr4Ju0OJUo3TEDRtOst7qa9
         u0kpst1IyvMH3MsZOGxPLht6Q3diNFLEHszan7/jtU3pHiJr5B34X/70It2LdACrfFdv
         iD2Q==
X-Gm-Message-State: AOAM532MFYOzolv6ZlyidtP6PgAGjYxMe701yrMVAXIz4zmGzA/4TVq5
        EdgEi6L+p7uV+WHFs3FIrjQ0MpNHqOc=
X-Google-Smtp-Source: ABdhPJxMtg0K6INoCkIU+22+KIhOsbvZj/wp5fDFQBYNYjykIapUx1/xqAWiebo8OINm+4A3zMI6PtlF6Z0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:81d4:0:b0:649:ac07:27b with SMTP id
 t20-20020a5d81d4000000b00649ac07027bmr688893iol.216.1649096490046; Mon, 04
 Apr 2022 11:21:30 -0700 (PDT)
Date:   Mon,  4 Apr 2022 18:21:18 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-3-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 2/3] selftests: KVM: Don't leak GIC FD across dirty log
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

