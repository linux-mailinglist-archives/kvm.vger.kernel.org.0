Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8470E27B02
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfEWKqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWKqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:46:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C3BD5946F
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 10:46:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AEC819C4F;
        Thu, 23 May 2019 10:46:36 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com
Subject: [PATCH] kvm: selftests: ucall improvements
Date:   Thu, 23 May 2019 12:46:35 +0200
Message-Id: <20190523104635.21142-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 23 May 2019 10:46:38 +0000 (UTC)
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
---
 tools/testing/selftests/kvm/lib/ucall.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
index a2ab38be2f47..5994923dfc1e 100644
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
 		gva = *(vm_vaddr_t *)run->mmio.data;
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
2.20.1

