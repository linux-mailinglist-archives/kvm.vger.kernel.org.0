Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DC959F20F
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiHXDbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiHXDbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:31:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F98783048
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-337ed9110c2so228251627b3.15
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=9IPC0RZFheCu6HPtQaFzEc+kW9Jmfu38UrDWGGGi5M0=;
        b=R9TiQdriz832WuZrCwqfZK6ZKXp64ULx9Ynn99liQK/mT6Acni54GKWX+PAxoQRZq0
         3P4o6JdnizMfTbNCkcN6bRI1NKsTE4fo6+VoxAd062MZqJT6g5gY/SIFl69JhuUjaXs3
         vx7AvbXzjHlg5vO18lvjD5h530tLY5iVqtYWH8eb6C/t/vHn26Ujl70gwKhICu94/0KJ
         h+PCCbUmGxHtgajkuHBje5QsjT3DfulTPEeCTymf88rKKrMEcecwtYNYWv3iP1/qGkQR
         BFPL5zRAUMWR8+29cmqBPSihDC3K/YM4cGYLmV3ZSwlhIBjJHDkJu5z6pJc9FZBFUoZT
         fEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=9IPC0RZFheCu6HPtQaFzEc+kW9Jmfu38UrDWGGGi5M0=;
        b=UGJANaNiCmUtyiqCodJ9GV9uTryjUXimd4cODdVtTT7Qg5yxcavEZVz4mf0PBJnkup
         jN5rAHrx7SAZis8aN9Oj9fCv+zMz8tpYe2ZeiNG2BhJzKRRjVZtar3A0hpz4FpMo0jQX
         BnO432A+gljdqpj8W8nCVsvAsGnDxwLye+jiEi2fmh0tMpfQK/5tEBPzuXfpar4d6fd6
         cv2nI6LP3xVMTc+XLy8557+utRVk/SGOdUfRP+7kO4Wg2lOupRyx0rx6G28WAoITUJTj
         pEGfLhhzQbfV++g8BQNl1/gymM9XrCa7LTFO96cG1IzbN6R61ob5A1Auv7BeK7wXdBBI
         x6iA==
X-Gm-Message-State: ACgBeo3toZnkMqO+x7WWEWx70J/3qyxkXOjPp8z8OPTzgT8ArstXY/Wp
        KOpfs2OvOiIZs3By6NeioBkf3n8WVyA=
X-Google-Smtp-Source: AA6agR6WjjPJdaIIt2w61lrBMNCH6OPOnEj03rNvKg4GYyvMXwahq3iOD390HhM8Xud+KyAyfHcONhRhJ4Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:39d5:0:b0:33d:a75a:1bdd with SMTP id
 g204-20020a8139d5000000b0033da75a1bddmr268455ywa.340.1661311861937; Tue, 23
 Aug 2022 20:31:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:30:55 +0000
In-Reply-To: <20220824033057.3576315-1-seanjc@google.com>
Message-Id: <20220824033057.3576315-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220824033057.3576315-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 1/3] KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reinstate the per-vCPU guest_supported_xcr0 by partially reverting
commit 988896bb6182; the implicit assessment that guest_supported_xcr0 is
always the same as guest_fpu.fpstate->user_xfeatures was incorrect.

kvm_vcpu_after_set_cpuid() isn't the only place that sets user_xfeatures,
as user_xfeatures is set to fpu_user_cfg.default_features when guest_fpu
is allocated via fpu_alloc_guest_fpstate() => __fpstate_reset().
guest_supported_xcr0 on the other hand is zero-allocated.  If userspace
never invokes KVM_SET_CPUID2, supported XCR0 will be '0', whereas the
allowed user XFEATURES will be non-zero.

Practically speaking, the edge case likely doesn't matter as no sane
userspace will live migrate a VM without ever doing KVM_SET_CPUID2. The
primary motivation is to prepare for KVM intentionally and explicitly
setting bits in user_xfeatures that are not set in guest_supported_xcr0.

Because KVM_{G,S}ET_XSAVE can be used to svae/restore FP+SSE state even
if the host doesn't support XSAVE, KVM needs to set the FP+SSE bits in
user_xfeatures even if they're not allowed in XCR0, e.g. because XCR0
isn't exposed to the guest.  At that point, the simplest fix is to track
the two things separately (allowed save/restore vs. allowed XCR0).

Fixes: 988896bb6182 ("x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0")
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 5 ++---
 arch/x86/kvm/x86.c              | 9 ++-------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..aa381ab69a19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -729,6 +729,7 @@ struct kvm_vcpu_arch {
 	struct fpu_guest guest_fpu;
 
 	u64 xcr0;
+	u64 guest_supported_xcr0;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..2e0f27ad736a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -315,7 +315,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
-	u64 guest_supported_xcr0;
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
@@ -327,10 +326,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	guest_supported_xcr0 =
+	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
 
 	kvm_update_pv_runtime(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..97ab53046052 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1011,15 +1011,10 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
-static inline u64 kvm_guest_supported_xcr0(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.guest_fpu.fpstate->user_xfeatures;
-}
-
 #ifdef CONFIG_X86_64
 static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
 {
-	return kvm_guest_supported_xcr0(vcpu) & XFEATURE_MASK_USER_DYNAMIC;
+	return vcpu->arch.guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC;
 }
 #endif
 
@@ -1042,7 +1037,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	 * saving.  However, xcr0 bit 0 is always set, even if the
 	 * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
 	 */
-	valid_bits = kvm_guest_supported_xcr0(vcpu) | XFEATURE_MASK_FP;
+	valid_bits = vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
 	if (xcr0 & ~valid_bits)
 		return 1;
 
-- 
2.37.1.595.g718a3a8f04-goog

