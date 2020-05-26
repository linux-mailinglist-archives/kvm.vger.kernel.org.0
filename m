Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19171C6DDF
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgEFKAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 06:00:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22983 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728180AbgEFKAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 06:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588759223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=V+s+EVTjLJSoyQgVEndJ36QCIydluEdbqn+8ObHr7LM=;
        b=GFrtjBBRSw0u6LrYQ9k7W3tMskFqCOQm9SHi4hclcoR5U6/QnWdijZmj54pcQD+T9DgM6f
        LMIk+WdzGoRfa/mBawYCgWP3LrSVfRmoNtq9bXBfKJRaHUrsomdbwCEdSqY0jo4SWpV+AW
        XEvkTWaP0ERlhRW7I+oxXWzbzZTKoeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-FuhPtV1tOs20XK-JbOdIAQ-1; Wed, 06 May 2020 06:00:18 -0400
X-MC-Unique: FuhPtV1tOs20XK-JbOdIAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0B9B106B242;
        Wed,  6 May 2020 10:00:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B92446294E;
        Wed,  6 May 2020 10:00:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH] KVM: x86: pass correct DR6 for GD userspace exit
Date:   Wed,  6 May 2020 06:00:14 -0400
Message-Id: <20200506100014.7451-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_EXIT_DEBUG is raised for the disabled-breakpoints case (DR7.GD),
DR6 was incorrectly copied from the value in the VM.  Instead,
DR6.BD should be set in order to catch this case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c                        |  2 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c | 24 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2384a2dbec44..ce534336c115 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4927,7 +4927,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		 * guest debugging itself.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
-			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
+			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
 			vcpu->run->debug.arch.dr7 = dr7;
 			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 			vcpu->run->debug.arch.exception = DB_VECTOR;
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index 2b7187db061d..ed94c0b3da35 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -11,10 +11,13 @@
 
 #define VCPU_ID 0
 
+#define DR6_BD		(1 << 13)
+#define DR7_GD		(1 << 13)
+
 /* For testing data access debug BP */
 uint32_t guest_value;
 
-extern unsigned char sw_bp, hw_bp, write_data, ss_start;
+extern unsigned char sw_bp, hw_bp, write_data, ss_start, bd_start;
 
 static void guest_code(void)
 {
@@ -43,6 +46,8 @@ static void guest_code(void)
 		     "rdmsr\n\t"
 		     : : : "rax", "ecx");
 
+	/* DR6.BD test */
+	asm volatile("bd_start: mov %%dr0, %%rax" : : : "rax");
 	GUEST_DONE();
 }
 
@@ -165,6 +170,23 @@ int main(void)
 			    target_dr6);
 	}
 
+	/* Disable all debug controls, run to the end */
+	CLEAR_DEBUG();
+	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
+	debug.arch.debugreg[7] = 0x400 | DR7_GD;
+	APPLY_DEBUG();
+	vcpu_run(vm, VCPU_ID);
+	target_dr6 = 0xffff0ff0 | DR6_BD;
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
+		    run->debug.arch.exception == DB_VECTOR &&
+		    run->debug.arch.pc == CAST_TO_RIP(bd_start) &&
+		    run->debug.arch.dr6 == target_dr6,
+			    "DR7.GD: exit %d exception %d rip 0x%llx "
+			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
+			    run->exit_reason, run->debug.arch.exception,
+			    run->debug.arch.pc, target_rip, run->debug.arch.dr6,
+			    target_dr6);
+
 	/* Disable all debug controls, run to the end */
 	CLEAR_DEBUG();
 	APPLY_DEBUG();
-- 
2.18.2

