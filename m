Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9919240081B
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 01:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350470AbhICXNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 19:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbhICXNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 19:13:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F45C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 16:12:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id w2-20020a63fb42000000b00255da18df0cso328804pgj.9
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 16:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gq6h7Eo56XYa1ARu4AoG783Vndsp695exWEl2AMV2X8=;
        b=ZkR68gKiUcfrLDsvLcPh0BcfcTWbHCLIFSCCw/WuDHsDuEWnQ6U804KMcS+vyhn4Mp
         lHpY7odhU97mNIWo86KIL0TnSl7fj9uLyk5U2DHdMnaD7FRb/hi74uNau44ZIBqYT4nE
         LkI3OMUgh5u2iacIzCMlhjZnXx6aq5JC8VOh2LW6FLGjloXtmHxA/DOBLoZvq1bYJaP2
         Z3eJSX88GPehYQsh9Tag5g5ItQ24/VBrQrY9ogxLi+on6vAHKZHGXrg8j5qM6kdLxqQt
         MEef4xrRdqAGOuT023oQ5YvwKZ31fptzIEXIIVljrkkJjieT3EvPmRaJ77xf0XnaV6tV
         HxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gq6h7Eo56XYa1ARu4AoG783Vndsp695exWEl2AMV2X8=;
        b=pwnGL1sEGUzhKsVwVuyvqD+wxblXf/3PXQtQmvXP6rBg2WCAHKOuPcLkq0sCJ8owJA
         jVbTa0QUroP5JJ/CXx5Su/tOOJGV6t9S/OPdBylSJTd2wzV3OMhs36jcMAro80kEipPC
         lRdDDRc0aknxryGyN1xRcchSYxYnncUDs8dUwMlLtJYaYWrrcJcJz8WlbUa74BiHLYPN
         5zDZiZCeYtDT86N5fXpV26wUt/7L2W0GhA3SMEQYZcCCxGIQE71bLkatiS6vohZK/B9b
         FLE+Z38MtSJzp6VMVpFUUf+eELHw2Hu8MdgSBvZgi5Xo1r5Ovb9GVge1cfoYTOMmcDXS
         q8ZA==
X-Gm-Message-State: AOAM531DhQxFtW590BYiGkTjCw++5PavwDomEKhPJ32Iqnim5NkB3yCw
        GJgHTzlZH4sWFU/Gnkk/jfYvNMcX5nbE4RXrAP+EN7g4iHjYYnoIMmRQ8ndx30Iba69+8NS6oy0
        a9UQZhR9NB3eYoaEETPcEROSP3t8LppXygZBJuXLTt8aw4yXoP/xtiljwx3VH7As=
X-Google-Smtp-Source: ABdhPJzkS2ggg1deQs/hZ76aK+S9ZNzY69uXp763MMgq27gs9X05cLTwvnREE5jg8QMMHRtfNnXPXfdNewKapw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:dcc9:b0:134:92c7:3cb6 with SMTP
 id t9-20020a170902dcc900b0013492c73cb6mr999233pll.79.1630710737476; Fri, 03
 Sep 2021 16:12:17 -0700 (PDT)
Date:   Fri,  3 Sep 2021 16:11:53 -0700
In-Reply-To: <20210903231154.25091-1-ricarkol@google.com>
Message-Id: <20210903231154.25091-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch independent
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
host. Ucalls API is architecture independent: tests do not need know
what kind of exit they generate on a specific arch.  More specifically,
there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
host to know that the exit is ucall related, as get_ucall() already
makes that check.

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

