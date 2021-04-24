Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD42D369E1D
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbhDXAxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244597AbhDXAvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:51:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60064C061346
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e13-20020a25d30d0000b02904ec4109da25so26208000ybf.7
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xQjgXxDowxam8JHFp2lMQSy0uU5l4G90MChbJDwG3P4=;
        b=vrkGY+oTI2Wmke2vymXqHiinOuYnSi6pt0qxIsFDWY4rSh3zLHKkzCF+4c/pNPTL1+
         56kMamCA5mbaPHuJ7yLSXgWMYUOOTWaFOBB6wLJJskT2qn0POVeJ3ueX7QT4vc5hwKle
         Lkk7ORtMHJ+w5qAavedqunXHaoueL6+Nitu4GDM4WJBYeNlZts309QUfSIRiYTwL+1Ak
         qQLtz0UDF3IzaxdMHoAacttefRIPqjwPck33g12HYKSoLLDsjh5dVm0VvaoXTM7dzPaj
         rizbGFen1vqHJvflNG2YRnIg+14a3fSBOUghG7UE+k2VqhbQFOcdItXJhxBMnax/+TST
         Rzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xQjgXxDowxam8JHFp2lMQSy0uU5l4G90MChbJDwG3P4=;
        b=RNmA4YzqKQBfC5amblbf+jyTZoP7KGTRgZy7/AApCaOqYPoy7dS3SnKK9FdbgYEfMq
         ZyTpioKPF1lgbVjOMVDVDWuw47U6AutL7n5kTULVXh3QHjlgkyiBW9NRmV0hj0yCYzy2
         5/s336sE1yxTS1NE3fQlbEO1js6bBbXakwU/YU2cEF4TItnPrptwBuw0Wlj0o2ToFZZP
         9/qqARPX8Vg8RtwKrNZ9jQe0MMNhHw0orsCbjItjSleXcdb4Y1Tm6XQ8zXTkjzNETbMr
         /QgiOzRveMAGXPMxTr+9WmSuTwwM8nB522ZrrBwMZoSbQOVPbu6/wQ6g2/7zuYLDUfp6
         gmCg==
X-Gm-Message-State: AOAM532AeH4Zkt4o4IgvYWYlPSj+waqbydjfIL1Uxn/mzSASQEba4eam
        E4GG6XMqjoOtv4LOoN+7to5vyuSERNg=
X-Google-Smtp-Source: ABdhPJy1vGfcQ/3sgvWc/gFelDhCA3rHMXvsqASU1T0CrCYyFZQ4XET3B3QGekR/FDZ6LrX8PHfitVfMjHk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:7315:: with SMTP id o21mr6501271ybc.319.1619225277610;
 Fri, 23 Apr 2021 17:47:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:28 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-27-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 26/43] KVM: VMX: Process CR0.PG side effects after setting CR0 assets
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the long mode and EPT w/o unrestricted guest side effect processing
down in vmx_set_cr0() so that the EPT && !URG case doesn't have to stuff
vcpu->arch.cr0 early.  This also fixes an oddity where CR0 might not be
marked available, i.e. the early vcpu->arch.cr0 write would appear to be
in danger of being overwritten, though that can't actually happen in the
current code since CR0.TS is the only guest-owned bit, and CR0.TS is not
read by vmx_set_cr4().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 596c8f9766ac..5f30181fd240 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3111,9 +3111,11 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long hw_cr0;
+	unsigned long hw_cr0, old_cr0_pg;
 	u32 tmp;
 
+	old_cr0_pg = kvm_read_cr0_bits(vcpu, X86_CR0_PG);
+
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
 	if (is_unrestricted_guest(vcpu))
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
@@ -3129,11 +3131,16 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			enter_rmode(vcpu);
 	}
 
+	vmcs_writel(CR0_READ_SHADOW, cr0);
+	vmcs_writel(GUEST_CR0, hw_cr0);
+	vcpu->arch.cr0 = cr0;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR0);
+
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
+		if (!old_cr0_pg && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
-		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
+		else if (old_cr0_pg && !(cr0 & X86_CR0_PG))
 			exit_lmode(vcpu);
 	}
 #endif
@@ -3174,17 +3181,11 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			exec_controls_set(vmx, tmp);
 		}
 
-		if (!is_paging(vcpu) != !(cr0 & X86_CR0_PG)) {
-			vcpu->arch.cr0 = cr0;
+		/* Note, vmx_set_cr4() consumes the new vcpu->arch.cr0. */
+		if ((old_cr0_pg ^ cr0) & X86_CR0_PG)
 			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-		}
 	}
 
-	vmcs_writel(CR0_READ_SHADOW, cr0);
-	vmcs_writel(GUEST_CR0, hw_cr0);
-	vcpu->arch.cr0 = cr0;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR0);
-
 	/* depends on vcpu->arch.cr0 to be set to a new value */
 	vmx->emulation_required = emulation_required(vcpu);
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

