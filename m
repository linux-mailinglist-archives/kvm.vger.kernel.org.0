Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5737692F
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbhEGRBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbhEGRA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 13:00:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8937BC061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 09:59:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so10743093ybp.0
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 09:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nXbsQzZRKADxmz3jPQyGk2mwipulmK8ydHFPEpTQQXY=;
        b=cZAvPBhNqujbaGxJlK4D8mIW+Swf1BC4L7PwZB3GQ7JVWWxdeAIL3qOpHbD1N7+IDP
         tlcRAsw/mMjLviNrHz0tBXTi1JaNLfNk8c+7bk9+0nD6VUhcdBo88t7lHPuldYqc+OP0
         U17N9Sf8vPB2ez0F3tKHgHTGKEuCK5D6KPo26i3BaiXYrC9bKDjH76kSLoXyWhJOB5BR
         Y0vh1d9xhzxQLAnuh6E9lnuowGCPTtBhYd5K7Nbu7a10Nq8InGHZVUwUzrTcxak9TjPW
         YCa1Cy35GJsLR09nU0UHI+GD9Vf3JnTOxzrSetvQ3vn0dWxX03VZvc2vsqlz2az75D6r
         LERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nXbsQzZRKADxmz3jPQyGk2mwipulmK8ydHFPEpTQQXY=;
        b=Qmg9zqOpWjnVL6aYFwfedIul/IMYkzdWoy2rqNF1rWrdIpCP8jgjnoNfK3xvKvl50T
         ckHEmcGhrkdExYMzQH6hBeHikwThDaqcR0PSKJLx2PAUGYcr4TbTHEu8KfRJWDPTQ0pu
         IhdMENKOLFP4SbHN9w6MI4gTfkTBn2/kGipg4r06saxQbOC1RlYI8EFGy/1SJOXvSEXh
         5W7Fy6StBFybseVohuGe17+iGNirq4I8cNvtPq0twOopmFeR7zEW4b9nWCu/rRbZAjjS
         5tzOxeLm/oM5nzE7mVYWdWqWN1ypRMPjg2Hy6vGEkxAVlqzliQlF+FyXWJxWVjDRg/2T
         vP4g==
X-Gm-Message-State: AOAM533mvsZYw97TDqt2XFpjYL8FF/hZZnRcN1LVhUWUzGjjQM1U+7GP
        kxQtlkvh7lnxQKpdo/TJVJ+bh23o99c=
X-Google-Smtp-Source: ABdhPJxTl5XVJuekxZhnDVHK/OX5tlB0XW7XCBsx4xJY6H7vJRWejR56oTeCAQd64J3MY/dfJjlgiNulBOs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7352:5279:7518:418f])
 (user=seanjc job=sendgmr) by 2002:a25:30d5:: with SMTP id w204mr14454275ybw.416.1620406797719;
 Fri, 07 May 2021 09:59:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 May 2021 09:59:47 -0700
In-Reply-To: <20210507165947.2502412-1-seanjc@google.com>
Message-Id: <20210507165947.2502412-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210507165947.2502412-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs for
 protected guests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
tracks the aforementioned registers by trapping guest writes, and also
exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
match the known hardware state.

Fixes: 5265713a0737 ("KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES")
Reported-by: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 73 ++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba5f2bb..1b7d0e97c82b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9963,21 +9963,25 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
-	if (vcpu->arch.guest_state_protected)
-		goto skip_protected_regs;
+	if (!vcpu->arch.guest_state_protected) {
+		dt.size = sregs->idt.limit;
+		dt.address = sregs->idt.base;
+		static_call(kvm_x86_set_idt)(vcpu, &dt);
+		dt.size = sregs->gdt.limit;
+		dt.address = sregs->gdt.base;
+		static_call(kvm_x86_set_gdt)(vcpu, &dt);
 
-	dt.size = sregs->idt.limit;
-	dt.address = sregs->idt.base;
-	static_call(kvm_x86_set_idt)(vcpu, &dt);
-	dt.size = sregs->gdt.limit;
-	dt.address = sregs->gdt.base;
-	static_call(kvm_x86_set_gdt)(vcpu, &dt);
-
-	vcpu->arch.cr2 = sregs->cr2;
-	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
-	vcpu->arch.cr3 = sregs->cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+		vcpu->arch.cr2 = sregs->cr2;
+		mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
+		vcpu->arch.cr3 = sregs->cr3;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+	}
 
+	/*
+	 * Writes to CR0, CR4, CR8, and EFER are trapped (after the instruction
+	 * completes) for SEV-EV guests, thus userspace is allowed to set them
+	 * so that KVM's model can be updated to mirror hardware state.
+	 */
 	kvm_set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
@@ -9990,35 +9994,42 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (is_pae_paging(vcpu)) {
+	/*
+	 * PDPTEs, like regular PTEs, are always encrypted, thus reading them
+	 * will return garbage.  Shadow paging, including nested NPT, isn't
+	 * compatible with protected guests, so ignoring the PDPTEs is a-ok.
+	 */
+	if (!vcpu->arch.guest_state_protected && is_pae_paging(vcpu)) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
 		mmu_reset_needed = 1;
 	}
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
 
-	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+	if (!vcpu->arch.guest_state_protected) {
+		kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+		kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+		kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+		kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+		kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+		kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
 
-	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+		kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+		kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	update_cr8_intercept(vcpu);
+		update_cr8_intercept(vcpu);
 
-	/* Older userspace won't unhalt the vcpu on reset. */
-	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
-	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
-	    !is_protmode(vcpu))
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		/* Older userspace won't unhalt the vcpu on reset. */
+		if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
+		    sregs->cs.selector == 0xf000 &&
+		    sregs->cs.base == 0xffff0000 && !is_protmode(vcpu))
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	}
 
-skip_protected_regs:
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
 		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
-- 
2.31.1.607.g51e8a6a459-goog

