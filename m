Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818CC700915
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbjELNUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240932AbjELNUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:20:45 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7ED173C
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-965d2749e2eso1465342466b.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683897642; x=1686489642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vK90iJTB08dda6fvu5wKiqOE1X1cb8W54H9qEv6EPKY=;
        b=Xfq30YLnwkK+8xyzgFc1GGGshtpPW+TqCp8LPV4ORZloHX3KVNZHJZw1YzZPFCx6+/
         qvMLTQrDZ90eTYkQ1Fg/SNmNO/y0bABn55ND5hr7lWFnY9s8emjgye/kzay83rlo3l6Z
         4X818wboYmYsKdKtBgRYhRkshPLieHzRUjg9ze07jrTlp2AWyluLS7aeaZTCQwRWQu9X
         VoDLc+BZhuvIRg5cOUFIQ4Gt1l6k7Iobmhgoh9kwIIzlt5F1wFV+GL56uzEf3jfeP5Su
         likeGjbb+k2oBdjYSfag0JaHfX79W+YuzR7W9bmYZcFql2xsxQZux0Gmel5maNk2R3kY
         dZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897642; x=1686489642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK90iJTB08dda6fvu5wKiqOE1X1cb8W54H9qEv6EPKY=;
        b=A0yG387Cu9ZHXdURhewnuO+GKBmFl3USZ9+Op73cZUGZQ8+bleQboumOvJeb6wZ2qN
         epJ1rwqemMdA33S2WYna7Vcw7BEfwrOgdVUlXm6JaUAzN6SnyyvAG6v+GYcMVueP61Eq
         7oVGtWpspdpfSiQCfFlJ9Zfon3KWHjfZLfBP5cNUPxxR12SJqbBhDsX6H4NS5J1cVkh6
         uU2vkhgqFUod6cjFFH4Zx+ppajmwRTodPkGBo+XFGyPjXjosnReAyutUL7vXnO5vFLem
         eWRTzPCbHhokhn076CdcC+hhkUNI4SXLqlRhDD0cZdTsFQxDQxAGHTg17/RR5z8fQp4H
         Ri8A==
X-Gm-Message-State: AC+VfDyeMaPFkYPkfrWZiU/u50G/UVZ2fdKGb3VnBiLad5QYXXFDfQn4
        iNyQqOkb/Srnhv35/9KlJ0VzJg==
X-Google-Smtp-Source: ACHHUZ592gRRCbeuJBz2vuRGwiSMvO298YN/KLp4NL0URV+2ijG6wr2nijEFoXv29j3rFBZDLqUHlQ==
X-Received: by 2002:a17:907:3faa:b0:966:17b2:5b15 with SMTP id hr42-20020a1709073faa00b0096617b25b15mr23183011ejc.7.1683897642260;
        Fri, 12 May 2023 06:20:42 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af43a100a78da3f586d44204.dip0.t-ipconnect.de. [2003:f6:af43:a100:a78d:a3f5:86d4:4204])
        by smtp.gmail.com with ESMTPSA id w21-20020a170907271500b00969dfd160aesm5077981ejk.109.2023.05.12.06.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:20:41 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.3 4/5] KVM: VMX: Make CR0.WP a guest owned bit
Date:   Fri, 12 May 2023 15:20:23 +0200
Message-Id: <20230512132024.4029-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512132024.4029-1-minipli@grsecurity.net>
References: <20230512132024.4029-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ Upstream commit fb509f76acc8d42bed11bca308404f81c2be856a ]

Guests like grsecurity that make heavy use of CR0.WP to implement kernel
level W^X will suffer from the implied VMEXITs.

With EPT there is no need to intercept a guest change of CR0.WP, so
simply make it a guest owned bit if we can do so.

This implies that a read of a guest's CR0.WP bit might need a VMREAD.
However, the only potentially affected user seems to be kvm_init_mmu()
which is a heavy operation to begin with. But also most callers already
cache the full value of CR0 anyway, so no additional VMREAD is needed.
The only exception is nested_vmx_load_cr3().

This change is VMX-specific, as SVM has no such fine grained control
register intercept control.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-7-minipli@grsecurity.net
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 4c91f626c058..e50d353b5c1c 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -4,7 +4,7 @@
 
 #include <linux/kvm_host.h>
 
-#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
+#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 768487611db7..89fa35fba3d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4483,7 +4483,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4634,7 +4634,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 64b35223dc3d..8ead0916e252 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4773,7 +4773,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2acdc54bc34b..423e9d3c9c40 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -640,6 +640,24 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
 				(1 << VCPU_EXREG_EXIT_INFO_2))
 
+static inline unsigned long vmx_l1_guest_owned_cr0_bits(void)
+{
+	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+
+	/*
+	 * CR0.WP needs to be intercepted when KVM is shadowing legacy paging
+	 * in order to construct shadow PTEs with the correct protections.
+	 * Note!  CR0.WP technically can be passed through to the guest if
+	 * paging is disabled, but checking CR0.PG would generate a cyclical
+	 * dependency of sorts due to forcing the caller to ensure CR0 holds
+	 * the correct value prior to determining which CR0 bits can be owned
+	 * by L1.  Keep it simple and limit the optimization to EPT.
+	 */
+	if (!enable_ept)
+		bits &= ~X86_CR0_WP;
+	return bits;
+}
+
 static __always_inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
-- 
2.39.2

