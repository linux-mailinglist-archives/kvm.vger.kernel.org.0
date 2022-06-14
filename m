Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48FC54BB55
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357412AbiFNUIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357051AbiFNUHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBBF60C9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2fb7cb07885so33890297b3.23
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vq20hxrPmqVc31s1r8TPtx4ezGH69rkNq0SRoBaom4o=;
        b=V/t4JSSMPQa9jPegCIx0X+tIQTdUIpqToRCCfDar4Zuy7FpaRPzQ1oHMzlhfMDSLph
         U8A0jYqjDHL6wXC0bgEoszqb7jTb8eVqw4ldN4hJtwsZERtszcq7tdbs1yOjpqeMjkj0
         9gaEcOoX3qzb9qjQzckCe2je27zm9469mWkC+zdtY+3ijy6w5Je1M0r4Oh10dc9YOjJv
         DJM/E8jyVvRcG7hWDIoK+xG/r4tBR6mvjjDtOlN8GyHQTuw7xt7xfIAeorqa99k4Y1vH
         /KLTH03//6Jlj9e5vH1mfPrJLGOuxSA2+2Zx43FCpOZHqC4V49fOWfX5GoWmtVCYbwDo
         A+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vq20hxrPmqVc31s1r8TPtx4ezGH69rkNq0SRoBaom4o=;
        b=qcwDq8n91GgGWBK+0VUvOUN461vB5OUGNTHdkG46x5E+PZWlQaWR9m7u3XXaP22tjo
         IdXC2juI7YtuSE2cy2lXuTv8iPdguwsYFhFui3I38dF+gzPIGZ28l9TsMkN8G7psvbhG
         ctOq87fbGq4u7b8/DVkS0xPbhsEJfKc/DOcCszrl7Eob3v5qMSwMFCAEFGKW+uLcyJQ2
         QhQGfVTAgr1cHqXmaDlnU292HH68e6CUcRCYaXvcecngeJR9iyrvA6Nr1abTpkKc0ROi
         Zb4tHhHZ8y+d+QOwN52T356Bp2wVosdN3zuXSbDlA+AeLwCjuZKsUcWOfyN40YMwB3uW
         lCJA==
X-Gm-Message-State: AJIora+JlZ2mOnrv+Fqm4kNt8f0EyKhNRDPY+pPvNz+Ke5Qw+9qGKN7N
        LE3vfx/Gh+7QvLkKS1dluLsOxNZ0Rew=
X-Google-Smtp-Source: AGRyM1uWY1dPZmUvLxKfwFxNKMG50R1/LmedNWgmYjkmMmPw6gtMeKVZPYiya7iuf2HdxjRNxXT11tghX9k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:bbc8:0:b0:664:f99f:877 with SMTP id
 c8-20020a25bbc8000000b00664f99f0877mr6722282ybk.348.1655237256584; Tue, 14
 Jun 2022 13:07:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:38 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 13/42] KVM: selftests: Remove the obsolete/dead MMU role test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the MMU role test, which was made obsolete by KVM commit
feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN").  The
ongoing costs of keeping the test updated far outweigh any benefits,
e.g. the test _might_ be useful as an example or for documentation
purposes, but otherwise the test is dead weight.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 -
 tools/testing/selftests/kvm/Makefile          |   1 -
 .../selftests/kvm/include/x86_64/processor.h  |   3 -
 .../selftests/kvm/x86_64/mmu_role_test.c      | 137 ------------------
 4 files changed, 142 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dd5c88c11059..0ab0e255d292 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -27,7 +27,6 @@
 /x86_64/hyperv_svm_test
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
-/x86_64/mmu_role_test
 /x86_64/platform_info_test
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b52c130f7b2f..2ca5400220b9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -83,7 +83,6 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
-TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b5d2e6c69c1a..95d1b402da9b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -140,9 +140,6 @@ struct kvm_x86_cpu_feature {
 #define CPUID_XSAVE		(1ul << 26)
 #define CPUID_OSXSAVE		(1ul << 27)
 
-/* CPUID.0x8000_0001.EDX */
-#define CPUID_GBPAGES		(1ul << 26)
-
 /* CPUID.0x8000_000A.EDX */
 #define CPUID_NRIPS		BIT(3)
 
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
deleted file mode 100644
index 383fff2c9587..000000000000
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ /dev/null
@@ -1,137 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include "kvm_util.h"
-#include "processor.h"
-
-#define MMIO_GPA	0x100000000ull
-
-static void guest_code(void)
-{
-	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
-	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
-
-	GUEST_ASSERT(0);
-}
-
-static void guest_pf_handler(struct ex_regs *regs)
-{
-	/* PFEC == RSVD | PRESENT (read, kernel). */
-	GUEST_ASSERT(regs->error_code == 0x9);
-	GUEST_DONE();
-}
-
-static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
-{
-	u32 good_cpuid_val = *cpuid_reg;
-	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
-	struct kvm_vm *vm;
-	uint64_t cmd;
-
-	/* Create VM */
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
-
-	/* Map 1gb page without a backing memlot. */
-	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, PG_LEVEL_1G);
-
-	vcpu_run(vcpu);
-
-	/* Guest access to the 1gb page should trigger MMIO. */
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
-		    "Unexpected exit reason: %u (%s), expected MMIO exit (1gb page w/o memslot)\n",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
-
-	TEST_ASSERT(run->mmio.len == 8, "Unexpected exit mmio size = %u", run->mmio.len);
-
-	TEST_ASSERT(run->mmio.phys_addr == MMIO_GPA,
-		    "Unexpected exit mmio address = 0x%llx", run->mmio.phys_addr);
-
-	/*
-	 * Effect the CPUID change for the guest and re-enter the guest.  Its
-	 * access should now #PF due to the PAGE_SIZE bit being reserved or
-	 * the resulting GPA being invalid.  Note, kvm_get_supported_cpuid()
-	 * returns the struct that contains the entry being modified.  Eww.
-	 */
-	*cpuid_reg = evil_cpuid_val;
-	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
-
-	/*
-	 * Add a dummy memslot to coerce KVM into bumping the MMIO generation.
-	 * KVM does not "officially" support mucking with CPUID after KVM_RUN,
-	 * and will incorrectly reuse MMIO SPTEs.  Don't delete the memslot!
-	 * KVM x86 zaps all shadow pages on memslot deletion.
-	 */
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    MMIO_GPA << 1, 10, 1, 0);
-
-	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vcpu);
-	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
-
-	vcpu_run(vcpu);
-
-	cmd = get_ucall(vcpu, NULL);
-	TEST_ASSERT(cmd == UCALL_DONE,
-		    "Unexpected guest exit, exit_reason=%s, ucall.cmd = %lu\n",
-		    exit_reason_str(run->exit_reason), cmd);
-
-	/*
-	 * Restore the happy CPUID value for the next test.  Yes, changes are
-	 * indeed persistent across VM destruction.
-	 */
-	*cpuid_reg = good_cpuid_val;
-
-	kvm_vm_free(vm);
-}
-
-int main(int argc, char *argv[])
-{
-	struct kvm_cpuid_entry2 *entry;
-	int opt;
-
-	/*
-	 * All tests are opt-in because TDP doesn't play nice with reserved #PF
-	 * in the GVA->GPA translation.  The hardware page walker doesn't let
-	 * software change GBPAGES or MAXPHYADDR, and KVM doesn't manually walk
-	 * the GVA on fault for performance reasons.
-	 */
-	bool do_gbpages = false;
-	bool do_maxphyaddr = false;
-
-	setbuf(stdout, NULL);
-
-	while ((opt = getopt(argc, argv, "gm")) != -1) {
-		switch (opt) {
-		case 'g':
-			do_gbpages = true;
-			break;
-		case 'm':
-			do_maxphyaddr = true;
-			break;
-		case 'h':
-		default:
-			printf("usage: %s [-g (GBPAGES)] [-m (MAXPHYADDR)]\n", argv[0]);
-			break;
-		}
-	}
-
-	__TEST_REQUIRE(do_gbpages || do_maxphyaddr, "No sub-tests selected");
-
-	entry = kvm_get_supported_cpuid_entry(0x80000001);
-	TEST_REQUIRE(entry->edx & CPUID_GBPAGES);
-
-	if (do_gbpages) {
-		pr_info("Test MMIO after toggling CPUID.GBPAGES\n\n");
-		mmu_role_test(&entry->edx, entry->edx & ~CPUID_GBPAGES);
-	}
-
-	if (do_maxphyaddr) {
-		pr_info("Test MMIO after changing CPUID.MAXPHYADDR\n\n");
-		entry = kvm_get_supported_cpuid_entry(0x80000008);
-		mmu_role_test(&entry->eax, (entry->eax & ~0xff) | 0x20);
-	}
-
-	return 0;
-}
-- 
2.36.1.476.g0c4daa206d-goog

