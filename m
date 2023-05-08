Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528C76FB44C
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjEHPtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjEHPtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21978A5F1
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9661a1ff1e9so338449266b.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560900; x=1686152900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHZ3/Gv8tpI6bbfJYN6NaXigTfYVOiTM9ttXlsZaDqM=;
        b=E0GbtbpvKptfy4bOYXF8qBtTwLh2dBmtWciGyAurTskr5TzD30iw/cXhGfMMKaIcdc
         wlwCMU+oIlZM7GBNkg3gt3IKUcoMAO1hYI8Or5yJ9WY+eQHBX0quy5A4vqJer0tnmZ8q
         Xi4WUbI2GmVMa5ekdOIFZ/xsbQGHOE5H6ukPlPM8AMjFKyLUC6irUvcbhcIawrA2DPgc
         31g0FQ+dtqjQ9w4aRHbI114UAci4ZjNPRuamWZoDJFjWCKAA1Jo0zwmH3TPam1unHO0j
         SCVCFVx2u44Q5Q4caUSKqrG7n8UcJYFzfhvydENN1PEik97GkGEV3DJBXp6/Sdb8dXui
         C4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560900; x=1686152900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHZ3/Gv8tpI6bbfJYN6NaXigTfYVOiTM9ttXlsZaDqM=;
        b=HGsqudzndUwhWPSy9RsRHVKFe2ltERrXq08+IDKibW51LIRyU31kDu6ZDxliOEPN4O
         UV7QkM8ouLnC1e0TQD0bcKp6oA98R/jTrjIYe2wSDPRZnX2ugjZCQfFrq8T4RmmywwTB
         Ygqs9Sasd/MFOdqI+WTl0kRqyLHAPTBEl7/6Qo/H4QNo89Aq9fGf2iayIJE7A03H9wr6
         6K1jEw0sM/c4XkxB5tYqfghIp2YV0maZ6VwY4WWA1GrCwnsb35NO5m4Nq3B/4Ae8AwFO
         UAmkfFModGaD8JF3RguqmreApv1gtn6AkxDSriEZJjzN8bePp5ZUe/jB0g83lWeQohpL
         DdKQ==
X-Gm-Message-State: AC+VfDzHFCJeEnGwZ6hww3eU2EBNISMUXrN1DkuWBYuYBhj+ZhhHg42T
        0V8INABWfhU8b/olcxhwX+AgRg==
X-Google-Smtp-Source: ACHHUZ6+STQh3jZq5m7w+8VPANlgzMG0eJxYbDlgdFPCpJgjdLZe0tlTTr+RNVaJu3Hl1pj6a+e9RA==
X-Received: by 2002:a17:907:94c2:b0:966:3114:c790 with SMTP id dn2-20020a17090794c200b009663114c790mr6683942ejc.37.1683560900696;
        Mon, 08 May 2023 08:48:20 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:20 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.10 04/10] KVM: VMX: Make CR0.WP a guest owned bit
Date:   Mon,  8 May 2023 17:47:58 +0200
Message-Id: <20230508154804.30078-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index a889563ad02d..4471aa86270a 100644
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
index c165ddbb672f..5ddb177dd40d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4247,7 +4247,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4397,7 +4397,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index db769fc68378..ff36d93b2552 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4456,7 +4456,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ed4b6da83aa8..28210741fd08 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -447,6 +447,24 @@ static inline u32 vmx_vmexit_ctrl(void)
 u32 vmx_exec_control(struct vcpu_vmx *vmx);
 u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
 
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

