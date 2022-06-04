Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0888353D470
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350108AbiFDBWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350154AbiFDBWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6FC5A0A1
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b15-20020a170902d50f00b00167501814edso1317367plg.8
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Q6jiJ1aOlB4Q05bHH1ZFB2hdrPIp9AfEUSu7/w240Y4=;
        b=KgbygI/vzVuigftSIpxOF/RP0xC4SuwPBrdHaJbujeDODCoyp31R84p1TXEk9qXcGT
         OkCt1KnDW6Jdu30WquxirBTjKPas9yZ584QIo/+dWNiaBt0DdySunLYTIdmigWbTQz8p
         r4nMlPCX+QUp2ppFxvCqTSt9lME3fen1zSjeutdnR6OdxLAuhSKcQEQpGU6pmPpBodr/
         o+rtyoxfY5kYYfxCXIzNnKamFQBJe1Cnbx+vggNzvT4P9rISxjnkP8Ur4GRdhsUEkXce
         +PhfgnbWZUl1ASVuxG34dgjY4GBKCrNm2cU5ORYetBk2zi0c1c9lp6XjD7OJY2u/+q2T
         +qLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Q6jiJ1aOlB4Q05bHH1ZFB2hdrPIp9AfEUSu7/w240Y4=;
        b=bYmBun5QyE1hvBqegWwlmeFBpXfHQNMv02B+BHb3NxKUjMKEJKF4vpsdyPeR6yLYHf
         BNYndTKRoixKEnWkaQddtpD/pHf778G6/XhXsx/6akqP2rmvKTmae2DM+5mKM79Lh/dg
         3ovrxr6zFaW+v1rDs9QjO+6oBnHDBY4fNbBv5wGOh7OW2ApnFapH+fW+aR8ZjZrhPHo8
         Lyw00/Pz3p4gmj17t5joWkH7KXZmGlNgKXv/TJFaokwrftF62uCHbjbX4uuDbDJZNHh+
         5ApvHFyQusezkA9lv60m9Dc8lwdb0Qi7W6om4TFwTqZ6e+/pzE1TVJTWYUKbhv4X6GLj
         SWvA==
X-Gm-Message-State: AOAM533E3vQlrU9/tX0TDdNJ+S9Lu37zvyC/PsNW05ogqu5Q90/siiWX
        7N6btmJq1xSl7kPwlSkZGgtEayNkfDY=
X-Google-Smtp-Source: ABdhPJwUPtDy1Jv5+WRl4sT0qLarIF4vY6xMsjglors72WbxpaNAHO+VPvAz7CMjdxSrv4/LG9mUcYT2PTY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:6bc7:0:b0:3fd:1b8d:d114 with SMTP id
 g190-20020a636bc7000000b003fd1b8dd114mr5764548pgc.308.1654305683428; Fri, 03
 Jun 2022 18:21:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:29 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 13/42] KVM: selftests: Remove the obsolete/dead MMU role test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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
index 27e432273180..9a256c1f1bdf 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -56,7 +56,6 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
-TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9a7ce6b047f1..a5e7b7bdec41 100644
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
index 9fd82580a382..000000000000
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
-	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
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
2.36.1.255.ge46751e96f-goog

