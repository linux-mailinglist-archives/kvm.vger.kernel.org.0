Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3A3C74C7
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhGMQh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhGMQhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:11 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC09C0613A9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id t144-20020a3746960000b02903ad9c5e94baso17330786qka.16
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vZPov19t8seutNZvZmmF4+o9jQkrFF2KtkeJS46Aq18=;
        b=VopMNO7HNEXA8hUjPdJmij4fABMuFmfzYYgItGc0441FQi4C11HDt5fH9s88dy6jaK
         lf2Ks3MiNV/S8wXOU85/kDoApjMfT9uLCwAvyGvMoFpAKZ6mk4iLcp4WYs8PK51S0hpE
         VQhlrRGpvcXODsgUOONai0ZNyBlekD0bDh6ZjgGYjEVGHgNnDCA5oPvVjzX+E/HqooXx
         sgiDsSkVVgMYkfs/z/CxT1tn3X+rKDFbL6RgOVkH97VE3WtZHis00v8RpEllvHe/LBg4
         N5qJveL998nOtOCGNtZUuKUBlZqVHfkeXncK7+8PUih743LvR3eADLKkfLREijOz6ayR
         P6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vZPov19t8seutNZvZmmF4+o9jQkrFF2KtkeJS46Aq18=;
        b=AgcBnlnMY/HRQJLlkm0wdAPFXWjEltO9hLB8mvQV2HhtLDyANOM3zr5TshiYiAqIPa
         I7kQewA5P5e9J0k/PRzTlPRtbRegsAOy0LatdAnS7xogtcyKQ5kzrXv/SiKZyqzq8KR4
         m6WP3fuOtKccV8ry8v+0ESK86btS2c7R+Xd1+2TJ6G31oScG1ETTYHQQoUDw9/1kHiHI
         xahnv6Sv1o7vTrZA/iOGEnYofmWuo4RNUSRCThtPU9+ghAPJLlZdKf9MMmTIispQAzUb
         4yqhefPCs3WeTUzChUTCbJUFRGmnKmqZ7UpNDQZKJQ7U4LF0mt3fCctti/rx/SRyAlVS
         VHFg==
X-Gm-Message-State: AOAM532ufoXHcrHghFfLK1nYOVrPJ5oZ3ax+v0VR1/X77L5WmZCaEttx
        82JB9u7s0xEsM2TvYqn0jW8WnoTVA7Y=
X-Google-Smtp-Source: ABdhPJxTBvC2/uhRrFcuw3Dvu3wtq6/KTPvhO8/hFY8KAScEIlI7/pKb9QNOKEf+W8kvdnqsw1bCV2USwJA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a0c:ff48:: with SMTP id y8mr5643746qvt.29.1626194053767;
 Tue, 13 Jul 2021 09:34:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:59 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-22-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 21/46] KVM: VMX: Invert handling of CR0.WP for EPT without
 unrestricted guest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
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
index f506b94539ab..02aec75ec6f6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -136,8 +136,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
-	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | 	\
-	 X86_CR0_WP | X86_CR0_PG | X86_CR0_PE)
+	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 
 #define KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR4_VMXE
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
@@ -2995,9 +2994,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
-static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
-					unsigned long cr0,
-					struct kvm_vcpu *vcpu)
+static void ept_update_paging_mode_cr0(unsigned long cr0, struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -3016,9 +3013,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
-
-	if (!(cr0 & X86_CR0_WP))
-		*hw_cr0 &= ~X86_CR0_WP;
 }
 
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
@@ -3031,6 +3025,8 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
+		if (!enable_ept)
+			hw_cr0 |= X86_CR0_WP;
 
 		if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
 			enter_pmode(vcpu);
@@ -3049,7 +3045,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 
 	if (enable_ept && !is_unrestricted_guest(vcpu))
-		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
+		ept_update_paging_mode_cr0(cr0, vcpu);
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
-- 
2.32.0.93.g670b81a890-goog

