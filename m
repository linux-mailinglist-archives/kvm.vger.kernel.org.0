Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B4A5030BA
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356179AbiDOWBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356171AbiDOWBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:48 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D5A3BBE0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:19 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id i14-20020a056e020ece00b002ca198245e6so5445965ilk.4
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ukSikfLZPySq7lKrWdQC3W4tZRZDdV+TXwwmzbO5VKE=;
        b=UFQNViFm5ywOL6fUUgUmBF2pMIllmvYSsEmxRVNh1gzD1izmJ3LtYUTbQoVRVd6R7/
         jqzms2/UXzy9A1cKXaPCa6uGhs2jB4kYpL25R2bC00CDonStKGhvdJ4YVdoFWKmexTi/
         QkfTtuq7/OrDuIAAqPw+yUALYUDmuCCrGRxB9F24yb275VyW2/5r9d7nu5//Jrfs1gyU
         bBbceIMSX7GVKPd/CqxGaga7ODuF8yOc8fr/uf+kbuofz35ev3lh9BLs/jGFbUXJ/kkj
         2mjW+x4bwKEomG8LlUwv7ZO+oESMs9ddaaWpZvG/caTzJIQruvv70SZXMOewJ76h8qCh
         w+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ukSikfLZPySq7lKrWdQC3W4tZRZDdV+TXwwmzbO5VKE=;
        b=RK8Yx1vQEoMYH7sBZnAKkHLXxQAPJj9yt6EuHP0xN/6uGXUFZQX9FRzQbJUu/f3lP4
         Utl1E+cxXKuVz2cstHnf2oW1QY1+wDbzm2I+e+x+vuo8EOe8BOgVRZhDvffhAShmlhbw
         a+Yu9LVFZLSUnIZME2XrfmzAkl0T2q3LQnVAwILjLJLXZw2cwF1DeWUEk6VhQ+3bM5D8
         mMmYTR5eiT60KpM3SMt/pIETXPXToyfE5HS8rlW/C5WZ6vIszIelx51dEAhs2p4jjjel
         39VQrPUzWBPVyB+lsvBiivkvovO9EUN9vev/SBNNRLZuJJaiRFsK8Z3ZPVm54GVer0Ml
         Sgog==
X-Gm-Message-State: AOAM53299hyYSQROZDJkjUSZM9thqk+CSYAcNRgL1GwQJmB3SYGH1ZRC
        vANKYDXw2jBME86YAVCs3gaE2PZleJw=
X-Google-Smtp-Source: ABdhPJw3+rg28SXpnYzElP/Fh1mOEN5FS2KtRHWJcXruhJlFqtNNF+kNgwwNT/3GJfepUrZ+VWNiihmiJLs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1a4f:b0:2c7:a4c8:25f5 with SMTP id
 u15-20020a056e021a4f00b002c7a4c825f5mr334502ilv.64.1650059958943; Fri, 15 Apr
 2022 14:59:18 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:55 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-12-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 11/17] KVM: arm64: Move MMU cache init/destroy into helpers
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/kvm/arm.c             |  4 ++--
 arch/arm64/kvm/mmu.c             | 10 ++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 74735a864eee..3bb7b678a7e7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -172,6 +172,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(u32 *hyp_va_bits);
+void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..f7862fec1595 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -320,7 +320,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	kvm_mmu_vcpu_init(vcpu);
 
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
@@ -349,7 +349,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_vcpu_destroy(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 53ae2c0640bc..f29d5179196b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1601,6 +1601,16 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 	return err;
 }
 
+void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+}
+
+void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+}
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
-- 
2.36.0.rc0.470.gd361397f0d-goog

