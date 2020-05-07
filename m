Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15681C88DC
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGLuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:50:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52938 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGLuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 07:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588852218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hheAW7ZXosbFpl+myMBjZitiYwnYA4D1bAZDHmS+meI=;
        b=Z038iNeZeNJCbo0AQBmJbTAEkV/uOWntcN60qfPUmij+cdcIc59Hu0N8ztGcXXqZeNvcCy
        I179N+SARPS2xc4c0NVv8B0CkigWxd7rm7fpHJIVyugTaU6gSEkO3ghaRM22/JjudB+lVV
        qYzz2ni7Rw7oqv7CngWYnarU7Vj3zk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-b6JVzb_INw6yEKkEtfhudw-1; Thu, 07 May 2020 07:50:17 -0400
X-MC-Unique: b6JVzb_INw6yEKkEtfhudw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0405F80058A;
        Thu,  7 May 2020 11:50:16 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BF2E1C933;
        Thu,  7 May 2020 11:50:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH v2 2/9] KVM: x86: fix DR6 delivery for various cases of #DB injection
Date:   Thu,  7 May 2020 07:50:04 -0400
Message-Id: <20200507115011.494562-3-pbonzini@redhat.com>
In-Reply-To: <20200507115011.494562-1-pbonzini@redhat.com>
References: <20200507115011.494562-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Go through kvm_queue_exception_p so that the payload is correctly delivered
through the exit qualification, and add a kvm_update_dr6 call to
kvm_deliver_exception_payload that is needed on AMD.

Reported-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          |  8 ++------
 arch/x86/kvm/x86.c              | 11 ++++++-----
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0dea9f122bb9..8c247bcb037e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1449,6 +1449,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
+void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..bb5a527e49d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4677,12 +4677,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
-			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
 
-			kvm_queue_exception(vcpu, DB_VECTOR);
+			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
 		}
 		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
@@ -4936,9 +4934,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
 			return 0;
 		} else {
-			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-			vcpu->arch.dr6 |= DR6_BD | DR6_RTM;
-			kvm_queue_exception(vcpu, DB_VECTOR);
+			kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BD);
 			return 1;
 		}
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d786c7d27ce5..109115c96897 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,6 +104,7 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
+static void kvm_update_dr6(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -473,6 +474,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+		kvm_update_dr6(vcpu);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
@@ -572,11 +574,12 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
-static void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
-				  unsigned long payload)
+void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
+			   unsigned long payload)
 {
 	kvm_multiple_exception(vcpu, nr, false, 0, true, payload, false);
 }
+EXPORT_SYMBOL_GPL(kvm_queue_exception_p);
 
 static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 				    u32 error_code, unsigned long payload)
@@ -6719,9 +6722,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 					   vcpu->arch.db);
 
 		if (dr6 != 0) {
-			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-			vcpu->arch.dr6 |= dr6 | DR6_RTM;
-			kvm_queue_exception(vcpu, DB_VECTOR);
+			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			*r = 1;
 			return true;
 		}
-- 
2.18.2


