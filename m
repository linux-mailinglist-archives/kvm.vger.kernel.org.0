Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4164F369E11
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244147AbhDXAvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhDXAt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:49:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15DBC06136A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d8-20020a25eb080000b02904e6f038cad5so26111315ybs.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b+GdRfiaLMn2dSo2d+DAg1VA45RjBqE++zgwaZZFJKg=;
        b=kTvoVs7Enelp9QXEVJWtZafvgD2YeKehMVsyr6tIo3simXB0zM5yuctnGDDo9YQ9Ci
         CwJuqP+my7DjJq6fAwO5SS5gak2wfGNs7C0gl66d4LZUNMQZNpbDS1suAZi1zcIamMxF
         ghDWeNFjWTahtqq15Sl4yS6rrEWNkYwHVV63Pa6VLIA3s0n8XKAK48Zv1+LCf6K/CjRq
         4erH9Yk2Qupy+4rp86jy7YzXlLujdqJJl60D2itG79sMWU9WnX7V8d7n1Te39q+hx2bP
         mJ0zTiTV6wwsgDTzLzkrkqMQe8gxJqrFU/Dhj5seNPTA1iqIkAbhhX6sSWPtZsDHXyeo
         2OJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b+GdRfiaLMn2dSo2d+DAg1VA45RjBqE++zgwaZZFJKg=;
        b=V7HZ+lJrM8EwJ1jVXl/RnAIvIEMdXz62ZBgFgQ6WeZ7SB+27hkmETjwHtdCowr+AHZ
         JPb32dWjyrGeMXedbnU4ijRf768VWuvEOHRMCEynbhWCpdeZjScb77euqjAs01uTbKsT
         5cziW3DhJFhXJV2wx275krthuGc0Fscc7Y4bd/4T76K+CoWoEIrh1s3WAM8mk95YUKe8
         MiBOKdixaQJup//+yXEEA3TK2u0J+G9+O7VQjcG+GOpOXVyRf+rpmwTVx5sNgNnrJEtk
         I836hxZqmnBrYeRV5YWzbH5+rn9LmCCFHLByYOxc8jeC91XxsL8xP2HI1db40pWmQqbt
         MtMA==
X-Gm-Message-State: AOAM531tSUOecXdKfz/eMVQrChRm0tb9E93uYKGbDnCYF3yYJrb15oUJ
        RJlNXfFYk6+Een7XWnkiYXuHOURnj7U=
X-Google-Smtp-Source: ABdhPJz4pJvMhFssUtGQghZ1OOf+Szg4/DUHPlgGx/Mmsz/euo8RqdCoqnvCdHpnFELywoak2ymQl5NiobE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:504b:: with SMTP id e72mr6967336ybb.152.1619225266221;
 Fri, 23 Apr 2021 17:47:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:23 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-22-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 21/43] KVM: VMX: Invert handling of CR0.WP for EPT without
 unrestricted guest
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

Opt-in to forcing CR0.WP=1 for shadow paging, and stop lying about WP
being "always on" for unrestricted guest.  In addition to making KVM a
wee bit more honest, this paves the way for additional cleanup.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 805888541142..d0050c140b4d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -135,8 +135,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
-	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | 	\
-	 X86_CR0_WP | X86_CR0_PG | X86_CR0_PE)
+	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 
 #define KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR4_VMXE
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
@@ -3103,9 +3102,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
-static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
-					unsigned long cr0,
-					struct kvm_vcpu *vcpu)
+static void ept_update_paging_mode_cr0(unsigned long cr0, struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -3124,9 +3121,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
-
-	if (!(cr0 & X86_CR0_WP))
-		*hw_cr0 &= ~X86_CR0_WP;
 }
 
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
@@ -3139,6 +3133,8 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
+		if (!enable_ept)
+			hw_cr0 |= X86_CR0_WP;
 
 		if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
 			enter_pmode(vcpu);
@@ -3157,7 +3153,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 
 	if (enable_ept && !is_unrestricted_guest(vcpu))
-		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
+		ept_update_paging_mode_cr0(cr0, vcpu);
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
-- 
2.31.1.498.g6c1eba8ee3d-goog

