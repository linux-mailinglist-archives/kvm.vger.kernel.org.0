Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975FB368BCC
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 06:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhDWEEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 00:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhDWEEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 00:04:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E78C061574
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:04:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o187-20020a2528c40000b02904e567b4bf7eso22784371ybo.10
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pLr79XnV8jmiBhfuyZ12keZz7+PeIzV/RdJo7lz5a20=;
        b=TDeHItoYGUinQ5QfVFpTL9KILDA55Eqn4P65h4cPvtOkm4/Hmqrls8C4Slk0v6F4IT
         NqJ9cYJ2KSsFs1KHdlBIPWaV8rmRK4hrMa6Y/a1MYl7ey3n9kLbbbTM0q1nTAmx4ScLs
         bIdv46WvetYgzKQ4j7cVx4LDhLZZ0lGm2vypeBBIXERpx31lAA7DitsO3LB+IehHp2Fb
         CLp8sB8rxT38ZjW5CwKCZ1azBOXZ3YrFckKxETy1NBIheZJPE2zsEZGQM18srrJ1yF6F
         Z3Akj1ATZnFuOu7DXPqdyAeuxC636MRHtXxDfsv5LnAKcA1PibKrADuGZwSbdH5hWb+v
         5r1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pLr79XnV8jmiBhfuyZ12keZz7+PeIzV/RdJo7lz5a20=;
        b=lXMO/ZJ8NV86aPJYJeS/jOiJpdO2SCzaJ+Jx9dC+twwtENMbqW3n7xU0vcF2eUDIoB
         GgpIZEX54ypQ4NaMDu0xe8n3vlEGABv91wRUl917kMwEu0WFBllK88oomw2/8q64Qr5u
         fyUx859GCG3Oehp2eNuYFs3gcNY2q4G/BdyvBPJFl7y1bWVCnkGZR3jc7x8IkjGKAVA7
         NQeP2j2OAddfh4/G469JGD/zEQgXUvEA8RWcngM6DHdNIPqOpmox2LhVY0RI/SPt9w9V
         Rk3JMsiB2UO7Z5jf4surazmhIM8cd5om02A5wju3+JiXdKRo5/F0czrFIBNbvEvkJp7U
         oUeg==
X-Gm-Message-State: AOAM533bUmDK131rzRzybnuUuBG4v3bi/SSIP7Z442jXRLRbNPx9DO9F
        23ioIC7fF8EgYKQmUr+urb5lt71X3LclAcRdFCDdWbpqI5b10OCIqzI9df6W03kVyErhOO7s9VK
        HpP6AlE4sEq3/FiJi1oOB8Lk9R+JzcSRnlsbFJSnynwWFKdgy7q4p5f/ZK4J/mR8=
X-Google-Smtp-Source: ABdhPJzhqbqtTQPQkUA/D6mJDIS4i1hcyAOurGPF5ymBCTAppBaYCTEgyxXu+iOrn6eJPsYb2pQgCNtory3+JQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:bad0:: with SMTP id
 a16mr2733788ybk.441.1619150644548; Thu, 22 Apr 2021 21:04:04 -0700 (PDT)
Date:   Thu, 22 Apr 2021 21:03:51 -0700
In-Reply-To: <20210423040351.1132218-1-ricarkol@google.com>
Message-Id: <20210423040351.1132218-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210423040351.1132218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 3/3] KVM: selftests: Use a ucall for x86 unhandled vector reporting
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86 reports unhandled vectors using port IO at a specific port number,
which is replicating what ucall already does for x86.  Aarch64, on the
other hand, reports unhandled vector exceptions with a ucall using a
recently added UCALL_UNHANDLED ucall type.

Replace the x86 unhandled vector exception handling to use ucall
UCALL_UNHANDLED instead of port IO.

Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
	halter_guest_code() shows this:

	$ ./x86_64/xapic_ipi_test
	...
	  Unexpected vectored event in guest (vector:0xe)

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      |  2 --
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..379f12cbdc06 100644
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
index a8906e60a108..284d26a25cd3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 
 void kvm_exit_unexpected_vector(uint32_t value)
 {
-	outl(UNEXPECTED_VECTOR_PORT, value);
+	ucall(UCALL_UNHANDLED, 1, value);
 }
 
 void route_exception(struct ex_regs *regs)
@@ -1260,16 +1260,13 @@ void vm_handle_exception(struct kvm_vm *vm, int vector,
 
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
2.31.1.498.g6c1eba8ee3d-goog

