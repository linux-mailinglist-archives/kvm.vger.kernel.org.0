Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BD37660A4
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 02:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjG1ARI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 20:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjG1ARH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 20:17:07 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A0A2703
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 17:16:59 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA1-004WRd-7H; Fri, 28 Jul 2023 02:16:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From;
        bh=S7WzY3cM95KMpMl3Uv2Vje9npSPbh7xjo5rDpXQwg/g=; b=Im2/WSnhCBAAE3jqCAJkJR5nYg
        wKH/l03Aqs8yRDAZayR+a2DbmvI7cEYRH3Yilh8XoQeKUs7S1Q9eNtCKrQEm0m5vUkOkBOliDoRBb
        FCyzmlu74gUeYTBR5rWRgHY08e0HA4ORBE3W1q87gdSAKCmSgk96ZHdIVSqe/aeq3549QjNJj1a65
        tNDhbATqWgugSJZryRPgFJSmVt+twVN1/DXJH4rDbg6fgCDs6AU0ebFGPdzeN6OUIp1VLHG4pZ+GF
        nPbSp4OHDTj1l9US4oX7/EIhnXF61xrO5m1cvtZDoJAEQtEjw+J7gRjHI3qbq1GoHLs6Rf8dDAq9i
        BzGpnrYA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA0-0002hQ-Qg; Fri, 28 Jul 2023 02:16:48 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qPB9y-0000WA-P2; Fri, 28 Jul 2023 02:16:46 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check for races
Date:   Fri, 28 Jul 2023 02:12:58 +0200
Message-ID: <20230728001606.2275586-3-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728001606.2275586-1-mhal@rbox.co>
References: <20230728001606.2275586-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attempt to modify vcpu->run->s.regs _after_ the sanity checks performed by
KVM_CAP_SYNC_REGS's arch/x86/kvm/x86.c:sync_regs(). This could lead to some
nonsensical vCPU states accompanied by kernel splats.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 .../selftests/kvm/x86_64/sync_regs_test.c     | 124 ++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 2da89fdc2471..feebc7d44c17 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -15,12 +15,14 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <pthread.h>
 
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
+#define TIMEOUT	2	/* seconds, roughly */
 
 struct ucall uc_none = {
 	.cmd = UCALL_NONE,
@@ -80,6 +82,124 @@ static void compare_vcpu_events(struct kvm_vcpu_events *left,
 #define TEST_SYNC_FIELDS   (KVM_SYNC_X86_REGS|KVM_SYNC_X86_SREGS|KVM_SYNC_X86_EVENTS)
 #define INVALID_SYNC_FIELD 0x80000000
 
+/*
+ * WARNING: CPU: 0 PID: 1115 at arch/x86/kvm/x86.c:10095 kvm_check_and_inject_events+0x220/0x500 [kvm]
+ *
+ * arch/x86/kvm/x86.c:kvm_check_and_inject_events():
+ * WARN_ON_ONCE(vcpu->arch.exception.injected &&
+ *		vcpu->arch.exception.pending);
+ */
+static void *race_events_inj_pen(void *arg)
+{
+	struct kvm_run *run = (struct kvm_run *)arg;
+	struct kvm_vcpu_events *events = &run->s.regs.events;
+
+	for (;;) {
+		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
+		WRITE_ONCE(events->flags, 0);
+		WRITE_ONCE(events->exception.injected, 1);
+		WRITE_ONCE(events->exception.pending, 1);
+
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+/*
+ * WARNING: CPU: 0 PID: 1107 at arch/x86/kvm/x86.c:547 kvm_check_and_inject_events+0x4a0/0x500 [kvm]
+ *
+ * arch/x86/kvm/x86.c:exception_type():
+ * WARN_ON(vector > 31 || vector == NMI_VECTOR)
+ */
+static void *race_events_exc(void *arg)
+{
+	struct kvm_run *run = (struct kvm_run *)arg;
+	struct kvm_vcpu_events *events = &run->s.regs.events;
+
+	for (;;) {
+		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
+		WRITE_ONCE(events->flags, 0);
+		WRITE_ONCE(events->exception.pending, 1);
+		WRITE_ONCE(events->exception.nr, 255);
+
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+/*
+ * WARNING: CPU: 0 PID: 1142 at arch/x86/kvm/mmu/paging_tmpl.h:358 paging32_walk_addr_generic+0x431/0x8f0 [kvm]
+ *
+ * arch/x86/kvm/mmu/paging_tmpl.h:
+ * KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm)
+ */
+static void *race_sregs_cr4(void *arg)
+{
+	struct kvm_run *run = (struct kvm_run *)arg;
+	__u64 *cr4 = &run->s.regs.sregs.cr4;
+	__u64 pae_enabled = *cr4;
+	__u64 pae_disabled = *cr4 & ~X86_CR4_PAE;
+
+	for (;;) {
+		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_SREGS);
+		WRITE_ONCE(*cr4, pae_enabled);
+		asm volatile(".rept 512\n\t"
+			     "nop\n\t"
+			     ".endr");
+		WRITE_ONCE(*cr4, pae_disabled);
+
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void race_sync_regs(void *racer, bool poke_mmu)
+{
+	struct kvm_translation tr;
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	pthread_t thread;
+	time_t t;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+
+	run->kvm_valid_regs = KVM_SYNC_X86_SREGS;
+	vcpu_run(vcpu);
+	TEST_REQUIRE(run->s.regs.sregs.cr4 & X86_CR4_PAE);
+	run->kvm_valid_regs = 0;
+
+	ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
+
+	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
+		__vcpu_run(vcpu);
+
+		if (poke_mmu) {
+			tr = (struct kvm_translation) { .linear_address = 0 };
+			__vcpu_ioctl(vcpu, KVM_TRANSLATE, &tr);
+		}
+	}
+
+	ASSERT_EQ(pthread_cancel(thread), 0);
+	ASSERT_EQ(pthread_join(thread, NULL), 0);
+
+	/*
+	 * If kvm->bugged then we won't survive TEST_ASSERT(). Leak.
+	 *
+	 * kvm_vm_free()
+	 *   __vm_mem_region_delete()
+	 *     vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region)
+	 *       _vm_ioctl(vm, cmd, #cmd, arg)
+	 *         TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret))
+	 */
+	if (!poke_mmu)
+		kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -218,5 +338,9 @@ int main(int argc, char *argv[])
 
 	kvm_vm_free(vm);
 
+	race_sync_regs(race_sregs_cr4, true);
+	race_sync_regs(race_events_exc, false);
+	race_sync_regs(race_events_inj_pen, false);
+
 	return 0;
 }
-- 
2.41.0

