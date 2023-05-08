Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05496FB437
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbjEHPrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbjEHPro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CE17AA7
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bcb229adaso8942840a12.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560841; x=1686152841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOiyYILIoTqnBpOx8Nww3bxaJ5z+0Kbz04MiChCwDjQ=;
        b=mXKM8+OxWi5QgNjpVRPQI62Czbk+J0r3Vjx4ldkMl9anqgM9igokq8sA/3gOalm3i8
         GeO2DdEDjsW2TYqZTRRSVX8Qpg3DnkHxZsqcu1TxeDa0rZta+WUX8durOBsvjLq0OGck
         4J4SRrP4QcngFwfFVDeQR11spQ/9n4VkmHr+TgLpfvIy6xRGviuNEtks1eAHjnWQcWem
         /BDu+JwY1gRa7WM2IgAlSEM1IzvY7+qUlBZNiUsPebV44UWr6on1xyWdP619ORk99R6a
         WhLiSz/FyF7srL1nj7Jk1Be1UIy7KW0L/h0/kXL81oehPQw8HwJ8s0Lr9xX1yB14shqx
         OpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560841; x=1686152841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rOiyYILIoTqnBpOx8Nww3bxaJ5z+0Kbz04MiChCwDjQ=;
        b=cdvCqpZCLBzIGr89sCA+FFDKlkxQKvLmmbQGB1XCeiueDCK1/DHTOReZZ7jDLDgqmr
         DXEtU0NnYPsjC4Z3Gn78YR20rX6l/HyWlOGRhjJoSuPYRkbHv6y4ClFXeKlWdROPk1oe
         8d39/aFSISggkJIsr1acpvIw0CQKCJop+VGxWnU0x9Ygjg5lZgWwlRORBtb35mPcbaTj
         FtO3Oi8jfY4ZpBZF4Mpdv9qDK73JukyXrJ+HRhh2+f/2V6zXaPnnu/I/fNcabkYaczBr
         tLogwvMqedbze3r4XIiGz0NDoTgtkvkq8hjdrEwOiZvYRyGVqE/t0dLXDqFA0KPk88dQ
         Oc5g==
X-Gm-Message-State: AC+VfDzyuLWaQYDL+SoYJuMXtRRBkYKcEl5eHU57YigT0UDsTF+168/i
        LFgxZc6LZwMs6J59Yiy+vd72gw==
X-Google-Smtp-Source: ACHHUZ4hZg7+tS+VdzU5+LVC8b1Sh5OZ5iKm6JHC2LBP9I0NJOaRYO+D/QdiJACsZxC/qTEyS7Z8WA==
X-Received: by 2002:a17:906:9754:b0:960:dad:5931 with SMTP id o20-20020a170906975400b009600dad5931mr10579869ejy.13.1683560841562;
        Mon, 08 May 2023 08:47:21 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:21 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 4/8] KVM: VMX: Make CR0.WP a guest owned bit
Date:   Mon,  8 May 2023 17:47:05 +0200
Message-Id: <20230508154709.30043-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.15.x
---
 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 90e1ffdc05b7..dd536243f653 100644
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
index e4e4c1d3aa17..2bebb0d43666 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4308,7 +4308,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4459,7 +4459,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 566367409598..cab0ee27db74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4450,7 +4450,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 20f1213a9368..cd73fe0c05b9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -531,6 +531,24 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_dirty = 0;
 }
 
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
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
-- 
2.39.2

