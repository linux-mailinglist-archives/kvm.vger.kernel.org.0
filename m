Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED41C6CC9
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgEFJYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:24:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24325 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728559AbgEFJYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588757043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=sZqM58Ec3WZKbAvwY/cBh3RDnWev4QH4nWVhzFDl5Zo=;
        b=JycxjTwAHGMj/nI3BBxYwICFt0smVhXZajPP0mlTQHx5+lKh/Hr7pEW396AnPURsnf3LyD
        AEtx4blXc4tGE1Kt4cYC7evSCLbupCbenUH8S8KYt0B51/6nwaU2bcXotsr1L4PZQzTXq2
        CX2ksXTnCiP3zEq4YC1euZFNNuwfmJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-r5NlPNRMPC6HpDHTJCbI2Q-1; Wed, 06 May 2020 05:24:01 -0400
X-MC-Unique: r5NlPNRMPC6HpDHTJCbI2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A001800D4A;
        Wed,  6 May 2020 09:24:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 180365D9C5;
        Wed,  6 May 2020 09:24:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3] KVM: x86: fix DR6 delivery for various cases of #DB injection
Date:   Wed,  6 May 2020 05:23:59 -0400
Message-Id: <20200506092359.26797-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Go through kvm_queue_exception_p so that the payload is correctly delivered
through the exit qualification, and add a kvm_update_dr6 call to
kvm_deliver_exception_payload that is needed on AMD.

Reported-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++------
 arch/x86/kvm/x86.c     | 6 +++---
 2 files changed, 5 insertions(+), 9 deletions(-)

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
index c5835f9cb9ad..f571e40de438 100644
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
@@ -6731,9 +6733,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
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

