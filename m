Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77269670B79
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjAQWNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjAQWLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:11:51 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC24847EEF
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:44:33 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u19so78209183ejm.8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOV3rwtP0iA8TQDDF9B/zFHDP5AzXHd8KRmKGtRz1nY=;
        b=tXpFGbRqaeGhZGVimlbcoV/9XnwdDGVH7hiIqREcmx64IUGAWAbGzUfS+Q2jzaESyM
         AFl3xbLPrb3Ey64qAv8+UAK5Pp7qbk6IwVqSB/KAqvTxa8MCtymrzccp5EA/NOHmJIam
         FZz+MXubbmE9cUQcbMwKoWjU8BlOjEdeLRZS0FVUmLrfI1mWYMiyHqscPmZxOuX8orBW
         ubbcfHBaySe3/L/ijowed8k/6SoVk0gXTFSR/kM8TbGH2iC+8Syt5JeU6fVAhIlOAaAF
         Rnnk0eKP5L1w8Niy0855lVZCCcJfiYV+SJIo1K5q0VaCpqmWwwSIf1bDJnQcnbJQGMmS
         x0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOV3rwtP0iA8TQDDF9B/zFHDP5AzXHd8KRmKGtRz1nY=;
        b=XUThlT3gBDo2lGq6/BeIYBYAJyVA84bpA9VbGyj1fPnKBVWf8COnfDgDRefCNAOprN
         Hlt8VZhD8Mzh8bIxunIFT2c3bAwrafiO7LcvxJloX4qRLOuGPGNampf5Xz/Fg4iuVjkP
         06fTBBd9n/bi6uZzDBnw/LDwt69jq1sdiJyeirQTpfJUsml672s7gko8Em24pCEdIMCu
         LUarv/83cq+jz696rJKxO7SxaD9qcHMhDLgaUUwwNXiEdSTJm6lXc58mVAFuXa9WOfGJ
         WwxujnkzCfEjTCR+82gcNdJPzJA8mhpX+TYPUY1gDXhrNLVg7jeJAP6vq5Im4CEdM8L5
         T6Lw==
X-Gm-Message-State: AFqh2kr6ZyJ5J4fVx85DOc4osGAk/7yGZI+R/UHW1QqiFFUt16Csr6PS
        O4r+W40XXkld2LggFYVaxi2WordbiLSi1/QYWOg=
X-Google-Smtp-Source: AMrXdXsY3mioBxxzF9rzO54UIsI4Wgpzvkeu6PzACp6IRoyPEm6qKAM/K9pSkMOzUsObYOSA6dMjZw==
X-Received: by 2002:a17:907:8a07:b0:7c1:5ee1:4c57 with SMTP id sc7-20020a1709078a0700b007c15ee14c57mr5084938ejc.8.1673988272166;
        Tue, 17 Jan 2023 12:44:32 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af098f00245ad18781b5e181.dip0.t-ipconnect.de. [2003:f6:af09:8f00:245a:d187:81b5:e181])
        by smtp.gmail.com with ESMTPSA id k2-20020a170906970200b0073dbaeb50f6sm13477051ejx.169.2023.01.17.12.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:44:31 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 3/3] KVM: x86: do not unload MMU roots when only toggling CR0.WP
Date:   Tue, 17 Jan 2023 21:45:56 +0100
Message-Id: <20230117204556.16217-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230117204556.16217-1-minipli@grsecurity.net>
References: <20230117204556.16217-1-minipli@grsecurity.net>
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

There is no need to unload the MMU roots when only CR0.WP has changed --
the paging structures are still valid, only the permission bitmap needs
to be updated.

Change kvm_mmu_reset_context() to get passed the need for unloading MMU
roots and explicitly avoid it if only CR0.WP was toggled on a CR0 write
caused VMEXIT.

This change brings a huge performance gain as the following micro-
benchmark running 'ssdd 10 50000' from rt-tests[1] on a grsecurity L1 VM
shows (runtime in seconds, lower is better):

                      legacy MMU   TDP MMU
kvm.git/queue             11.55s    13.91s
kvm.git/queue+patch        7.44s     7.94s

For legacy MMU this is ~35% faster, for TTP MMU ~43% faster.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  7 ++++---
 arch/x86/kvm/smm.c              |  4 ++--
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 28 +++++++++++++++++++---------
 5 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..e7851315ffa6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1812,7 +1812,7 @@ int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
-void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool unload_mmu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      const struct kvm_memory_slot *memslot,
 				      int start_level);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 505768631614..4022394d3a25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5384,7 +5384,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.cpu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.cpu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_reset_context(vcpu, true);
 
 	/*
 	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
@@ -5393,9 +5393,10 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	KVM_BUG_ON(vcpu->arch.last_vmentry_cpu != -1, vcpu->kvm);
 }
 
-void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool unload_mmu)
 {
-	kvm_mmu_unload(vcpu);
+	if (unload_mmu)
+		kvm_mmu_unload(vcpu);
 	kvm_init_mmu(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index cc43638d48a3..09f47048eb1b 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -131,7 +131,7 @@ void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 		vcpu->arch.pdptrs_from_userspace = false;
 	}
 
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_reset_context(vcpu, true);
 }
 
 void process_smi(struct kvm_vcpu *vcpu)
@@ -369,7 +369,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 #endif
 
 	kvm_update_cpuid_runtime(vcpu);
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_reset_context(vcpu, true);
 	return;
 error:
 	kvm_vm_dead(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..14815fd6dcb1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4648,7 +4648,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	if (enable_ept && is_pae_paging(vcpu))
 		ept_save_pdptrs(vcpu);
 
-	kvm_mmu_reset_context(vcpu);
+	kvm_mmu_reset_context(vcpu, true);
 
 	/*
 	 * This nasty bit of open coding is a compromise between blindly
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..d7c326ab94de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -902,7 +902,9 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
-	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
+	unsigned long cr0_change = cr0 ^ old_cr0;
+
+	if (cr0_change & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
 
@@ -914,10 +916,18 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
 
-	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
+	if (cr0_change & KVM_MMU_CR0_ROLE_BITS) {
+		bool unload_mmu =
+			cr0_change & (KVM_MMU_CR0_ROLE_BITS & ~X86_CR0_WP);
 
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
+		/*
+		 * Toggling just CR0.WP doesn't invalidate page tables per se,
+		 * only the permission bits.
+		 */
+		kvm_mmu_reset_context(vcpu, unload_mmu);
+	}
+
+	if ((cr0_change & X86_CR0_CD) &&
 	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
@@ -1117,7 +1127,7 @@ static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
 	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
+		kvm_mmu_reset_context(vcpu, true);
 
 	/*
 	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
@@ -1740,7 +1750,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 
 	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
+		kvm_mmu_reset_context(vcpu, true);
 
 	return 0;
 }
@@ -11410,7 +11420,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		return ret;
 
 	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
+		kvm_mmu_reset_context(vcpu, true);
 
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
@@ -11452,7 +11462,7 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 		vcpu->arch.pdptrs_from_userspace = true;
 	}
 	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
+		kvm_mmu_reset_context(vcpu, true);
 	return 0;
 }
 
@@ -11970,7 +11980,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 	if (old_cr0 & X86_CR0_PG) {
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-		kvm_mmu_reset_context(vcpu);
+		kvm_mmu_reset_context(vcpu, true);
 	}
 
 	/*
-- 
2.39.0

