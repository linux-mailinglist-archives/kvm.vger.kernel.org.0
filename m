Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443F637F075
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 02:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhEMAi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 20:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346583AbhEMAgh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 20:36:37 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B0DC061364
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:09 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id k13-20020ac8140d0000b02901bad0e39d8fso16870834qtj.6
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v+v7lxe4WlcHH5qrWKNitEm44ROd/TrmyyIntoQFZSQ=;
        b=MgO+hRdgNusWw0X6oTyPfwT0qVeJwDZZTQyY7h9Ntg3CRab7m62wAfWI5Yr2ui9r+Q
         Ff1ISOwvRyrp4mHRxt7XI7sQTVxyuyQxVzS4yRq1goD31X3ilD722VBrJS/P9VvYyN1M
         wQqueGA0hE8Edj2TWZTfACDGNbTAFsW3eTXGwnTFF84dsVJjuU+0hFVaZrc9LGQUXzZK
         ulQjJ5R2I/1xyVXA642FliIr66g2bwK+3A31AJfU34ENfRo2flV1EQ3KSWddgJ38pBnJ
         BRolmS+o7mKlbeNKt6yHex8JW3JWNyZi1HwFpusVmHb+OjEYndY3H+u1NLxZE4sMQ1UT
         KN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v+v7lxe4WlcHH5qrWKNitEm44ROd/TrmyyIntoQFZSQ=;
        b=AAWJGkm5qgqzc4TdwnbvXj53xL/UKF46tJLvtecouMNfvUFJowtsqzNAamVYWMy7zx
         m/it3sO25F7soi0n8xr3umsHDB7NjKuP7MoOksjgynUmeSfDFY2cpLM6HH/vTCVrwltI
         ab0eiF25VTxxUg0szrgsCKpeWTkLjC92HCkGPF+8MZklknOc537VdmkkeD5ModoYx9Oh
         T8wllcyMPMWU9OjyM5zAbeE8X61dq99qKRF2aQzYAzExiqGcK+Igk4p+wrWx1rhxQTmS
         UCSeJE4FO4tQkg2JicGJWrjPpzaTE4HAS7vN/X61riFGTPKJ0hD7LwLvnJpkykpTWc7f
         fH3A==
X-Gm-Message-State: AOAM533AFrvdj68sYESBegdAoo9gqck0hFB1pRpNyate6RukU60K8tkI
        CgLZUsvoZ0LxDAoPq/q/E6zRVuTOjHso9XVifmhGHIr1vuH0ca8H4cf4nrQfD8Y0D7+5nVmf7Ae
        sex8QipR3U44EkZIaXvcFk7P9M4ShwLSrzG8x14HnZByumQSMm0Q1168U3Laf5QQ=
X-Google-Smtp-Source: ABdhPJxXjjcZr8CNIZJnomdYGWC+gztPAf88F8UD2shglQJhf5+t1KFDX5YI9pcZ6rvqnCIxDlFK7m/zQ6guEA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:5aa1:: with SMTP id
 u1mr37879334qvg.23.1620865688188; Wed, 12 May 2021 17:28:08 -0700 (PDT)
Date:   Wed, 12 May 2021 17:27:59 -0700
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Message-Id: <20210513002802.3671838-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210513002802.3671838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  1 +
 .../selftests/kvm/include/x86_64/processor.h   |  2 --
 .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++-----------
 3 files changed, 8 insertions(+), 13 deletions(-)

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
index e156061263a6..814bb695d803 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,12 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
-		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
-		&& vcpu_state(vm, vcpuid)->io.size == 4) {
-		/* Grab pointer to io data */
-		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
-			+ vcpu_state(vm, vcpuid)->io.data_offset;
-
-		TEST_ASSERT(false,
-			    "Unexpected vectored event in guest (vector:0x%x)",
-			    *data);
+	struct ucall uc;
+
+	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
+		uint64_t vector = uc.args[0];
+		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
+			  vector);
 	}
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

