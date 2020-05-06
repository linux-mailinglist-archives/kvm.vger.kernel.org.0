Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F91C6EFD
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEFLKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:10:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40475 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728288AbgEFLKw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tnIIIl1MHFTivIQ8LS9seDE0l+b2DCrY7TEgHIHhhj0=;
        b=WeI3E3moMf5I5DFia1Z9sMPr8Qp/tIrA4O894ISXZh3UCjkSVEyG131i876LA2JvMmJHvg
        xQnqiJ9Y5LyMrxV6VODi2bQ06Sw34qdd4iB7d2Tm7XMGlw2cXLgskCKyFGtr2z5uywtxT0
        hA7sMHEbpxpDlsirbpm2ESeKDYC/Ob4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-dfjzOmRZNamn8_nmU_X-Bg-1; Wed, 06 May 2020 07:10:48 -0400
X-MC-Unique: dfjzOmRZNamn8_nmU_X-Bg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D265100CCC5;
        Wed,  6 May 2020 11:10:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1621B5C1D4;
        Wed,  6 May 2020 11:10:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 8/9] KVM: x86, SVM: do not clobber guest DR6 on KVM_EXIT_DEBUG
Date:   Wed,  6 May 2020 07:10:33 -0400
Message-Id: <20200506111034.11756-9-pbonzini@redhat.com>
In-Reply-To: <20200506111034.11756-1-pbonzini@redhat.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Intel, #DB exceptions transmit the DR6 value via the exit qualification
field of the VMCS, and the exit qualification only contains the description
of the precise event that caused a vmexit.

On AMD, instead the DR6 field of the VMCB is filled in as if the #DB exception
was to be injected into the guest.  This has two effects when guest debugging
is in use:

* the guest DR6 is clobbered

* the kvm_run->debug.arch.dr6 field can accumulate more debug events, rather
than just the last one that happened.

Fortunately, if guest debugging is in use we debug register reads and writes
are always intercepted.  Now that the guest DR6 is always synchronized with
vcpu->arch.dr6, we can just run the guest with an all-zero DR6 while guest
debugging is enabled, and restore the guest value when it is disabled.  This
fixes both problems.

A testcase for the second issue is added in the next patch.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/x86.c     | 12 ++++++++----
 arch/x86/kvm/x86.h     |  2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f03bffafd9e6..29dc7311dbb1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1750,6 +1750,8 @@ static int db_interception(struct vcpu_svm *svm)
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
 		kvm_run->debug.arch.dr7 = svm->vmcb->save.dr7;
+		/* This restores DR6 to all zeros.  */
+		kvm_update_dr6(vcpu);
 		kvm_run->debug.arch.pc =
 			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
 		kvm_run->debug.arch.exception = DB_VECTOR;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f4254d716b10..1b5e0fc346bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,7 +104,6 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
-static void kvm_update_dr6(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -1048,10 +1047,14 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_update_dr6(struct kvm_vcpu *vcpu)
+void kvm_update_dr6(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
-	    kvm_x86_ops.set_dr6)
+	if (!kvm_x86_ops.set_dr6)
+		return;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		kvm_x86_ops.set_dr6(vcpu, DR6_FIXED_1 | DR6_RTM);
+	else
 		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
 }
 
@@ -9154,6 +9157,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		for (i = 0; i < KVM_NR_DB_REGS; i++)
 			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
 	}
+	kvm_update_dr6(vcpu);
 	kvm_update_dr7(vcpu);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc0516f..a4c950ad4d60 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -240,6 +240,8 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }
 
+void kvm_update_dr6(struct kvm_vcpu *vcpu);
+
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
-- 
2.18.2


