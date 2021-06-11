Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF413A392C
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFKBN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:13:26 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:39755 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhFKBNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:13:25 -0400
Received: by mail-pj1-f74.google.com with SMTP id w4-20020a17090a4f44b029016bab19a594so4950244pjl.4
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TYvOocfdGGEik5oZUAe7GQBrIevpGvdRMy9WY4nI218=;
        b=nJiRvBrw35+0e+bGUhSL73s0Hx6KBViDlQOEx2lufnpIp8rb+7F4TVjxSimCI21IaT
         gf65GmCFoRjdO3sMt19FwCyYyKMze/l4ZNpy155VJMv0I3Qusn9XPVyeivmGgI8Ei5Nv
         P3QviUCZNiaiXjjZ67VtOyunCLgJsB7VO9dO5q9N32cBGYk4oqLQXMkZXGn2uGthIbLp
         XjluerlLQa9RLg9DZMkoM0JjriEkldpHGApbJefIudAby1QNU+MvVOmCTX+QbjPJTHZo
         vUrcCT9k0ED5QM9hzhCI+jNqC9iAEV5SVSdv/e8dohRd+XcUPks0yh5nqy/gY/q4/RoP
         UxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TYvOocfdGGEik5oZUAe7GQBrIevpGvdRMy9WY4nI218=;
        b=X+ME8UjI8Thvp17LA8+oKjmSO+J9X3wEHVUVlXvggTjfXh7GkLON2cUriV1RELvTpH
         2UbJETUNZkP9MUvw9GgajrgXIg2ilkg7bWD1wbWIiKDUxheDJ3cYtquPr8naUBMiog3I
         H1E1VYuMSGN1NvDO/kDm/aMjfgJ0Z0TK3oIUvg6v2Zcemz7aCAxyKOJI8XtAiuLc2Baa
         xfwrv1szEjTnWaeefjL1BN2O7t50th0GUEbeSAcGq1VEGlW571M9yYyC0i/G9ZFm1MMV
         VjhXGqRJBGFMxQ/XIu7YiFVbEs91SKXxNwF7W8h48LAcpfUcC0grv5NJ0mBLE6E7+Y/8
         LT2A==
X-Gm-Message-State: AOAM5330UlsjDnvuhDyinChO0BPmH+Jg1vsCId3N0he01GK7at1olK40
        58I957VROQl5MtJciYhRBzfuajNocdB7YQ48w2WyBDk1r8wiSDfMRtmRiemJqZAgGTMYEKlOF4W
        /tziJ8jOuq6RbJkKNsL/JMMLHzzf9I2qX0jYIWp3rRlgtzniKadugmCvkU2bV/Bc=
X-Google-Smtp-Source: ABdhPJycRe7gKvuKJjbcx7/YnZK2hdrk+Fowwdb5tNbq0e3YWn5ixMHsFSvSFp/tERi+LURVZLTQINtmCH9KPw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:720b:b029:113:19d7:2da7 with SMTP
 id ba11-20020a170902720bb029011319d72da7mr1419291plb.55.1623373828499; Thu,
 10 Jun 2021 18:10:28 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:17 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
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
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  2 --
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++++++++-----------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fcd8e3855111..beb76d6deaa9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -349,6 +349,7 @@ enum {
 	UCALL_SYNC,
 	UCALL_ABORT,
 	UCALL_DONE,
+	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 6
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e9f584991332..92a62c6999bc 100644
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
index 257c5c33d04e..a217515a9bc2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1201,7 +1201,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
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
+
+		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
+			  vector);
 	}
 }
 
-- 
2.32.0.272.g935e593368-goog

