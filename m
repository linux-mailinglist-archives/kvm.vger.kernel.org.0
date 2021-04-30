Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB8370408
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhD3XZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhD3XZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:25:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C18C06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r2-20020a25ac420000b02904f5a9b7d37fso834807ybd.22
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DrtIzoZNc79OT7R03r+6Yhv7XXgWtVPXBdQ8gE5Za50=;
        b=hrA93mrfNvMtPI4VgsoEAfSKtto6rMPg+XTcD8MyoMUgLaj5o9tLH3AwvT5hgfwWoZ
         etFwv7KD1vg1aRcGGpw5PRSmKq0tE7WHqERR0XauYivNrLYKmOMuupUwQSfEtWMh08r7
         cihPWH3QFt9w3b/V5DeidqkD26w13mLIzcyk41Ym+dhZEgIB0D9x5VVCS+lVeGLOkMhD
         gaP8C7S9g51MowvglkvRjiDYjSssCj4VTPEz6dLV2SIIkDSRr6L80gCz1m98goVOv9hq
         bem2O7Q/hq4UwAFPSw7yjYDMgsjtpCd+KOA/kjvaSRPKIuZorYXLQ7D3DugljqjU1d5q
         96Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DrtIzoZNc79OT7R03r+6Yhv7XXgWtVPXBdQ8gE5Za50=;
        b=hfVIvBM0+IIVU2qRLsGO2vYNJwb+njfxJUPVdMo5vL1Cmus1bDX5VehNnXbu5W9U2i
         CRvbUJHgMwKBCJktjB85lZQOQCuSfidqnoroW9qrL3skHxXGlXt70dZGkuIvnCNO1Atg
         YlXJfemUQPL2q95X4ZL27D2OCOI3Bq88YvMTjIcPs/gbqVB8g9mWlmn/nTLVd74pthpD
         jGcrnczvXvkj/cH39MCOfCBqhslUW/ZfR9Y4ZGo4k33aakdJKz6kusXecETFBtQF+8qj
         CjuSQ3fy9Ghu0NxTe+LDzYtgxTfwzjXv7n+aKjOin5BcvjJ6JYunvsjSIzTftKgya+YL
         DE7A==
X-Gm-Message-State: AOAM531wXLdAfXgJ+s8Yql8ZKTGZ+smX5wof8i5ZN474P6jDLbjWO+1z
        nzRgvPQjvEWCMBpnJd7uyuWtRzBnEK/hVK1ZOKMU97UnGGL1wPEuevdcloUNuGTBG/A0wH1369X
        Rje0bwF7vV7HJbmiOLjSyszMbCpo33PnXKvBUql3YU2BZJkhJ1A30oO3hMwvHPiM=
X-Google-Smtp-Source: ABdhPJxCH47qwg6o/sPFrCh0eBsljgWhHVIlR+rd2tL+C+5G+0C/awiKqu15PVkzt+chVmExB8oH4/OW2Cw2GQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:6d82:: with SMTP id
 i124mr10969252ybc.78.1619825053901; Fri, 30 Apr 2021 16:24:13 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:24:04 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86, the only arch implementing exception handling, reports unhandled
vectors using port IO at a specific port number. This replicates what
ucall already does.

Introduce a new ucall type, UCALL_UNHANDLED, for guests to report
unhandled exceptions. Then replace the x86 unhandled vector exception
reporting to use it instead of port IO.  This new ucall type will be
used in the next commits by arm64 to report unhandled vectors as well.

Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
	halter_guest_code() shows this:

	$ ./x86_64/xapic_ipi_test
	...
	  Unexpected vectored event in guest (vector:0xe)

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    |  1 +
 .../selftests/kvm/include/x86_64/processor.h      |  2 --
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bea4644d645d..7880929ea548 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -347,6 +347,7 @@ enum {
 	UCALL_SYNC,
 	UCALL_ABORT,
 	UCALL_DONE,
+	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 6
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 12889d3e8948..ff4da2f95b13 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -53,8 +53,6 @@
 #define CPUID_PKU		(1ul << 3)
 #define CPUID_LA57		(1ul << 16)
 
-#define UNEXPECTED_VECTOR_PORT 0xfff0u
-
 /* General Registers in 64-Bit Mode */
 struct gpr64_regs {
 	u64 rax;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e156061263a6..96e2bd9d66eb 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,13 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
-		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
-		&& vcpu_state(vm, vcpuid)->io.size == 4) {
-		/* Grab pointer to io data */
-		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
-			+ vcpu_state(vm, vcpuid)->io.data_offset;
+	struct ucall uc;
 
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
+		uint64_t vector = uc.args[0];
 		TEST_ASSERT(false,
-			    "Unexpected vectored event in guest (vector:0x%x)",
-			    *data);
+			    "Unexpected vectored event in guest (vector:0x%lx)",
+			    vector);
 	}
 }
 
-- 
2.31.1.527.g47e6f16901-goog

