Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A424A686F1A
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjBAToi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBATob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:44:31 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F277D6E3
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:44:30 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gr7so30044933ejb.5
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qsy2Uw5CdDxyHnHzJNf7tebm5waQcm3qgkQypIRD0TQ=;
        b=u5nOIOiIHGHsUUIO2RFWXjN11TEIX9e+ptL1+CFtVB/c9QeQUBW4CCMKhj+d+jZC9W
         o/pFuvwXHpvKU8vlW/cQMaNDWw9ok4uB7LnEfQZYqdJ4RbicM3mJwYF33qErrH0McdbG
         dol1+omltPpOKQY+gJs/XG9hjc4gUAUwj6uo+Uf29HCeDeyK9S7kBCmVzfj+WAdTaiQq
         GBlkXnew/QD5OUivpAPWqzpIL6dpx4aP3jDDVIlYTRhATKAcyEr1YPyss0/IcWNpOZ3C
         B7UvaRb7awdj/0U0aX0rRbASJ8Glxqm26OFAY87zPlrP9k5ra2Xo6PpZYUfrgVtaR6CQ
         zcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qsy2Uw5CdDxyHnHzJNf7tebm5waQcm3qgkQypIRD0TQ=;
        b=Q2P8xjaNvbQQxIrNw8WQJRp/259IyHqh98esbf0V7ojGk0OhkjIHKwdS7fR3OrG1W6
         U3ajg7XReLNW+4/rXQsqDG1T3S3DilO9dsUYnXfpWjPuVcutT+ioSyg0iz7//sa5b4RL
         zO4f3kYJnTy/W4PQvgbBI0MetxQ1d6pHlWCkEWUYNzHTcHW4gv5/biIwl7LwnDsVc9Uv
         WD9+9OS6QghqASl59r+RlIuxU7UqVv8ETlpHrR+ucjFfO3jTRUHcr1Z6xpMSrUqy5O1L
         jm0riyc5ijuWntgkHwc2LXSqh/re6JVosu1kaM5H6eaRqL0ECjypXuqznpwpk0rhws2O
         GuEg==
X-Gm-Message-State: AO0yUKUEziHLIAbJyXgDsrQaHk9GQ265KmiEnLG/39KIh8NDIhFPq75o
        5inU2CuanuVxj2ksCXId7YZqhKxSPjhIdu6zJ1k=
X-Google-Smtp-Source: AK7set+H1klZL37ScJpHXCuuMJhTfaEvIr9rEf8uMIyTSOnXzcZN68vTuJtwKY8/D3K4EEBkvU7O9A==
X-Received: by 2002:a17:906:4c8a:b0:887:c44a:b8e9 with SMTP id q10-20020a1709064c8a00b00887c44ab8e9mr3727788eju.76.1675280669450;
        Wed, 01 Feb 2023 11:44:29 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af111a00277482c051eca183.dip0.t-ipconnect.de. [2003:f6:af11:1a00:2774:82c0:51ec:a183])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b00869f2ca6a87sm10397579ejd.135.2023.02.01.11.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:44:29 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Date:   Wed,  1 Feb 2023 20:46:04 +0100
Message-Id: <20230201194604.11135-7-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201194604.11135-1-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guests like grsecurity that make heavy use of CR0.WP to implement kernel
level W^X will suffer from the implied VMEXITs.

For a direct MMU role there is no need to intercept a guest change of
CR0.WP, so simply make it a guest owned bit if we can do so.

This implies that a read of a guest's CR0.WP bit might need a VMREAD.
However, the only potentially affected user seems to be kvm_init_mmu()
which is a heavy operation to begin with. But also most callers already
cache the full value of CR0 anyway, so no additional VMREAD is needed.
The only exception is nested_vmx_load_cr3().

Add a new module parameter 'lazycr0' to allow users to revert back to
the old behaviour by loading kvm-intel.ko with 'lazycr0=0'.

This change is VMX-specific, as SVM has no such fine grained control
register intercept control.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---

Initially I wanted to implement the scheme Sean sketched[1]: having a
threshold where we would switch from eager to lazy CR0.WP tracking after
toggling the bit often enough, make the bit guest owned afterwards and
VMREAD CR0 when needed. However, when starting to look for users that
would be affected, I only found kvm_init_mmu() (via kvm_init_mmu() ->
vcpu_to_role_regs() -> kvm_read_cr0_bits(KVM_MMU_CR0_ROLE_BITS)). It has
only these three interesting callers:
1/ kvm_mmu_reset_context(), which isn't all that interesting, as it's a
   heavy weight operation anyway and many of the control flows leading
   to it already cache the value of CR0, so no additional VMREAD is
   needed,
2/ nested_vmx_load_cr3() and
3/ kvm_post_set_cr0(), only when CR0.WP was toggled and the MMU is in
   direct mode (optimization introduced by patch 3).

The last case's most interesting caller is likely kvm_set_cr0(), which
already caches the written CR0 value, thereby vanishes the need for
another VMREAD in vcpu_to_role_regs().

That's why I went with the much simpler approach and always allow CR0.WP
to be guest owned if EPT is enabled as well.

There's nothing we can do for SVM, though :/

[1] https://lore.kernel.org/kvm/Y8cTMnyBzNdO5dY3@google.com/
---
 arch/x86/kvm/kvm_cache_regs.h   | 3 ++-
 arch/x86/kvm/vmx/capabilities.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 9 ++++++++-
 arch/x86/kvm/vmx/vmx.h          | 8 ++++++++
 5 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index c09174f73a34..495ae0204933 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -4,7 +4,8 @@
 
 #include <linux/kvm_host.h>
 
-#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
+#define KVM_LAZY_CR0_GUEST_BITS		X86_CR0_WP
+#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | KVM_LAZY_CR0_GUEST_BITS)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..41d48a3a651e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,6 +12,7 @@
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
 extern bool __read_mostly enable_ept;
+extern bool __read_mostly enable_lazy_cr0;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..2a0010ca7277 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4478,7 +4478,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
 	 * (KVM doesn't change it);
 	 */
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs12->host_cr0);
 
 	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
@@ -4629,7 +4629,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
 
-	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vcpu->arch.cr0_guest_owned_bits = vmx_guest_owned_cr0_bits();
 	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
 
 	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d3b49e0b6c32..1969360d2744 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -91,6 +91,9 @@ module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 bool __read_mostly enable_ept = 1;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
 
+bool __read_mostly enable_lazy_cr0 = 1;
+module_param_named(lazycr0, enable_lazy_cr0, bool, S_IRUGO);
+
 bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
@@ -4765,7 +4768,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
 
-	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
 
 	set_cr4_guest_host_mask(vmx);
@@ -8370,6 +8373,10 @@ static __init int hardware_setup(void)
 		return -EOPNOTSUPP;
 	}
 
+	/* Need EPT for lazy CR0.WP synchronization. */
+	if (!enable_ept)
+		enable_lazy_cr0 = 0;
+
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
 		enable_ept_ad_bits = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..e899c2291a3f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -640,6 +640,14 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
 				(1 << VCPU_EXREG_EXIT_INFO_2))
 
+static inline unsigned long vmx_guest_owned_cr0_bits(void)
+{
+	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
+	if (!enable_lazy_cr0)
+		bits &= ~KVM_LAZY_CR0_GUEST_BITS;
+	return bits;
+}
+
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
-- 
2.39.1

