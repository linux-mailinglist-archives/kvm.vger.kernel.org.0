Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E51C88E6
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEGLuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726946AbgEGLuZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=s1G05H8imO2zOk7SJkYTBhX0Snvn61zgHbE4+WonJ+8=;
        b=QYiTTDGkV1GyxxN8UuJRZAPNd0EvHOXEC8507AndsPEIvMbTte/QbJ2Gy+V4vyhrTJE10R
        hTaU1Z+4Be7CcvZcjusQnlOS0cydMIsp4fTXYEwed3poUGY4NRN6HrcG8gYz1FZ4SIdIj7
        SISxTMze6bWoNcOmwKgL7qcf97vdwNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-v2py6EUQMsiAnkEtzZ14nQ-1; Thu, 07 May 2020 07:50:20 -0400
X-MC-Unique: v2py6EUQMsiAnkEtzZ14nQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A1E464;
        Thu,  7 May 2020 11:50:19 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09F7B1C933;
        Thu,  7 May 2020 11:50:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
Date:   Thu,  7 May 2020 07:50:11 -0400
Message-Id: <20200507115011.494562-10-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_EXIT_DEBUG is raised for the disabled-breakpoints case (DR7.GD),
DR6 was incorrectly copied from the value in the VM.  Instead,
DR6.BD should be set in order to catch this case.

On AMD this does not need any special code because the processor triggers
a #DB exception that is intercepted.  However, the testcase would fail
without the previous patch because both DR6.BS and DR6.BD would be set.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c                        |  2 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c | 24 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e2b71b0cdfce..e45cf89c5821 100644
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
index 077f25d61d1a..8162c58a1234 100644
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
 
+	/* Finally test global disable */
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

