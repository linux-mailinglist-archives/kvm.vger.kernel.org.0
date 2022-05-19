Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05D452D484
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiESNpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiESNp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9454811A0B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A5A5CE2465
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F885C385B8;
        Thu, 19 May 2022 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967919;
        bh=Wd/HwkBqurC96ZGUbUiPBa09e91aiokQncSXqY2+W8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv0J7+q5DNpWtUyZflP18IUXGvVQz6kZ23wtPsn4EH1Zp0na7ewTMNMI/jESdl0jY
         kaJLuZ1/UmO0i5rCxQu/II3wMQGm61PlpJcwlM7M9VjvLRAf9XmuSQk8gq4hhA76+J
         UarGWnqVZ/uJ7PdpUbLO79QDVN75VZvQQ9TwBLMScAoQubJB0T2RMPkx/bCRmstMj7
         IpPPr4YKqDMtLP3VwKpDFVbw1li75USzU3RJF8LIVfPo7DF+HKRPfs1tAvmFOPzf16
         UUwgt3GfGVj23i2SUEuLWseCK13FrmD9oGSIbbE9JH3pbejdapr/o0Fa6b7+m1T2bD
         lmy3TBRccp+0w==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 44/89] KVM: arm64: Introduce predicates to check for protected state
Date:   Thu, 19 May 2022 14:41:19 +0100
Message-Id: <20220519134204.5379-45-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

In order to determine whether or not a VM or (shadow) vCPU are protected,
introduce a helper function to query this state. For now, these will
always return 'false' as the underlying field is never configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h      |  6 ++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c55aadfdfd63..066eb7234bdd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -164,6 +164,7 @@ struct kvm_pinned_page {
 };
 
 struct kvm_protected_vm {
+	bool enabled;
 	unsigned int shadow_handle;
 	struct mutex shadow_lock;
 	struct kvm_hyp_memcache teardown_mc;
@@ -895,10 +896,7 @@ int kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
-static inline bool kvm_vm_is_protected(struct kvm *kvm)
-{
-	return false;
-}
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.pkvm.enabled)
 
 void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index f76af6e0177a..3997eb3dff55 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -58,6 +58,19 @@ static inline struct kvm_shadow_vm *get_shadow_vm(struct kvm_vcpu *shadow_vcpu)
 	return get_shadow_state(shadow_vcpu)->shadow_vm;
 }
 
+static inline bool shadow_state_is_protected(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	return shadow_state->shadow_vm->kvm.arch.pkvm.enabled;
+}
+
+static inline bool vcpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	if (!is_protected_kvm_enabled())
+		return false;
+
+	return shadow_state_is_protected(get_shadow_state(vcpu));
+}
+
 void hyp_shadow_table_init(void *tbl);
 int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
 		       size_t shadow_size, unsigned long pgd_hva);
-- 
2.36.1.124.g0e6072fb45-goog

