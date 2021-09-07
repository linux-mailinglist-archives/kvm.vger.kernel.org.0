Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29F402E27
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345651AbhIGSLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbhIGSLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:11:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5716EC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:10:04 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n9-20020a63f809000000b0026930ed1b24so5297301pgh.23
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G7khVBYFvA49zN1MZ52NeR3EN5XVTugXq2LEuJFRcSA=;
        b=j5Bz7AXuSg3CFWHBEXnXFwThJ99vfcD2XwHZE92kzgu1zge+KC2SWxZD61KbdFqOcR
         ASi8mmRYrhCFzIel0syhVI1xrdwW7So4mf0kTjL1ajiGQnzgvjxIz3ogBXSdOKsUfqum
         zKbDsZ6FD/vBqHeqAltqAEMvaZV3SopNjeyIIvAt6BNbxVjycueIl+y4fPhVT8QdxqeA
         QaJlxgkul+qDZGk4SgsFv40rGrPwaQuYvNu+dLWZEapdx/c6Kr9a8RMuznpAUviZZfeh
         9ahG+mehOIbgso7lxiEuic4NL/jCz2X7BVllvRYwv7JigC0jR1nkpR5OmyvQFFf9VfXz
         tivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G7khVBYFvA49zN1MZ52NeR3EN5XVTugXq2LEuJFRcSA=;
        b=i5vxFVdsqPI3I5CLlM/1BA+C1uHWpBFcBvVkT+MmjL27t7nIkTPnu1NXJeHH+zer6s
         mzunAYqg2GVprOpPvh0SYNKwIWiGDvWOFFAIQ1UKNhmgpWu3cO02gJ2uFGav2TwZfbPP
         UiidzSH7fzrogMSefgM6IuQsQmXyPI3El/t5a33gNPBlgDP/oClTPxy3YTCK9H1avvjH
         /ADBx+pw5cPACgfEkGMICbkkKI9Ww0dFsSoakIyqFssFa7EBR51FEdJk++AtigDGJM3t
         ocV6xiNac1qYjgab6KeQYVJ5rZS3ZJBSAqaPyCZTkHvwqQeyoYBM1L1Oxs6F9vWqOJQ7
         tyKQ==
X-Gm-Message-State: AOAM530S1WvXBEihn3eEA8QsojcH0GbrywG6mUWtZoIqoza7wktIH+90
        j1fvUmkkpicn06mD7OKakbbnGd27/SOlT/p2GpvM+elyR6aCIXUazS93HJCthdPZB77WcbWEh/M
        3kZzRdhuPjBe1zAI6+NapREqWrjiTRbP3EiB3r+06yUzCgvYkfdkIhRzytKfzR6c=
X-Google-Smtp-Source: ABdhPJzOG5I1fc7cdWS5mntyea5A+bvSpEcgpb5MNPWkd63BQ4U5Q72ws4t4TnVZOwpxXfsKb56ncunp1kc5Vw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:c613:b0:136:5fc8:5372 with SMTP
 id r19-20020a170902c61300b001365fc85372mr15873926plr.41.1631038203685; Tue,
 07 Sep 2021 11:10:03 -0700 (PDT)
Date:   Tue,  7 Sep 2021 11:09:56 -0700
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
Message-Id: <20210907180957.609966-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2 1/2] KVM: selftests: make memslot_perf_test arch independent
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

memslot_perf_test uses ucalls for synchronization between guest and
host. Ucalls API is architecture independent: tests do not need to know
details like what kind of exit they generate on a specific arch.  More
specifically, there is no need to check whether an exit is KVM_EXIT_IO
in x86 for the host to know that the exit is ucall related, as
get_ucall() already makes that check.

Change memslot_perf_test to not require specifying what exit does a
ucall generate. Also add a missing ucall_init.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index d6e381e01db7..1727f75e0c2c 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -127,43 +127,54 @@ static bool verbose;
 			pr_info(__VA_ARGS__);	\
 	} while (0)
 
+static void check_mmio_access(struct vm_data *vm, struct kvm_run *run)
+{
+	TEST_ASSERT(vm->mmio_ok, "Unexpected mmio exit");
+	TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
+	TEST_ASSERT(run->mmio.len == 8,
+		    "Unexpected exit mmio size = %u", run->mmio.len);
+	TEST_ASSERT(run->mmio.phys_addr >= vm->mmio_gpa_min &&
+		    run->mmio.phys_addr <= vm->mmio_gpa_max,
+		    "Unexpected exit mmio address = 0x%llx",
+		    run->mmio.phys_addr);
+}
+
 static void *vcpu_worker(void *data)
 {
 	struct vm_data *vm = data;
 	struct kvm_run *run;
 	struct ucall uc;
-	uint64_t cmd;
 
 	run = vcpu_state(vm->vm, VCPU_ID);
 	while (1) {
 		vcpu_run(vm->vm, VCPU_ID);
 
-		if (run->exit_reason == KVM_EXIT_IO) {
-			cmd = get_ucall(vm->vm, VCPU_ID, &uc);
-			if (cmd != UCALL_SYNC)
-				break;
-
+		switch (get_ucall(vm->vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == 0,
+				"Unexpected sync ucall, got %lx",
+				(ulong)uc.args[1]);
 			sem_post(&vcpu_ready);
 			continue;
-		}
-
-		if (run->exit_reason != KVM_EXIT_MMIO)
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				check_mmio_access(vm, run);
+			else
+				goto done;
 			break;
-
-		TEST_ASSERT(vm->mmio_ok, "Unexpected mmio exit");
-		TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
-		TEST_ASSERT(run->mmio.len == 8,
-			    "Unexpected exit mmio size = %u", run->mmio.len);
-		TEST_ASSERT(run->mmio.phys_addr >= vm->mmio_gpa_min &&
-			    run->mmio.phys_addr <= vm->mmio_gpa_max,
-			    "Unexpected exit mmio address = 0x%llx",
-			    run->mmio.phys_addr);
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld, val = %lu",
+					(const char *)uc.args[0],
+					__FILE__, uc.args[1], uc.args[2]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
 	}
 
-	if (run->exit_reason == KVM_EXIT_IO && cmd == UCALL_ABORT)
-		TEST_FAIL("%s at %s:%ld, val = %lu", (const char *)uc.args[0],
-			  __FILE__, uc.args[1], uc.args[2]);
-
+done:
 	return NULL;
 }
 
@@ -268,6 +279,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
 	data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
+	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
-- 
2.33.0.153.gba50c8fa24-goog

