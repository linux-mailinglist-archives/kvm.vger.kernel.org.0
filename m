Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475CE2B53E
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfE0MaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:30:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfE0MaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 08:30:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C722530842CE
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 12:30:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F35E21017E2C;
        Mon, 27 May 2019 12:30:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH v2] kvm: selftests: ucall improvements
Date:   Mon, 27 May 2019 14:30:06 +0200
Message-Id: <20190527123006.17959-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 27 May 2019 12:30:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure we complete the I/O after determining we have a ucall,
which is I/O. Also allow the *uc parameter to optionally be NULL.
It's quite possible that a test case will only care about the
return value, like for example when looping on a check for
UCALL_DONE.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
v2:
  - rebase; there was a change to get_ucall() that affected
    context.
  - Also switch all unit tests to using a NULL uc if possible.
    It was only possible for one though. Some unit tests only
    use uc.cmd in error messages, but I guess that's a good
    enough reason to have a non-NULL uc.
  - add Peter's r-b

 tools/testing/selftests/kvm/dirty_log_test.c |  3 +--
 tools/testing/selftests/kvm/lib/ucall.c      | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index fc27f890155b..ceb52b952637 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -121,7 +121,6 @@ static void *vcpu_worker(void *data)
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
 	struct kvm_run *run;
-	struct ucall uc;
 
 	run = vcpu_state(vm, VCPU_ID);
 
@@ -132,7 +131,7 @@ static void *vcpu_worker(void *data)
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, &uc) == UCALL_SYNC) {
+		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
 			pages_count += TEST_PAGES_PER_LOOP;
 			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		} else {
diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
index b701a01cfcb6..dd9a66700f96 100644
--- a/tools/testing/selftests/kvm/lib/ucall.c
+++ b/tools/testing/selftests/kvm/lib/ucall.c
@@ -125,16 +125,16 @@ void ucall(uint64_t cmd, int nargs, ...)
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 {
 	struct kvm_run *run = vcpu_state(vm, vcpu_id);
-
-	memset(uc, 0, sizeof(*uc));
+	struct ucall ucall = {};
+	bool got_ucall = false;
 
 #ifdef __x86_64__
 	if (ucall_type == UCALL_PIO && run->exit_reason == KVM_EXIT_IO &&
 	    run->io.port == UCALL_PIO_PORT) {
 		struct kvm_regs regs;
 		vcpu_regs_get(vm, vcpu_id, &regs);
-		memcpy(uc, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(*uc));
-		return uc->cmd;
+		memcpy(&ucall, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(ucall));
+		got_ucall = true;
 	}
 #endif
 	if (ucall_type == UCALL_MMIO && run->exit_reason == KVM_EXIT_MMIO &&
@@ -143,8 +143,15 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
 			    "Unexpected ucall exit mmio address access");
 		memcpy(&gva, run->mmio.data, sizeof(gva));
-		memcpy(uc, addr_gva2hva(vm, gva), sizeof(*uc));
+		memcpy(&ucall, addr_gva2hva(vm, gva), sizeof(ucall));
+		got_ucall = true;
+	}
+
+	if (got_ucall) {
+		vcpu_run_complete_io(vm, vcpu_id);
+		if (uc)
+			memcpy(uc, &ucall, sizeof(ucall));
 	}
 
-	return uc->cmd;
+	return ucall.cmd;
 }
-- 
2.18.1

