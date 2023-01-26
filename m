Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF067D730
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjAZVEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjAZVES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:04:18 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0646C474CC
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:04:17 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5066df312d7so34104467b3.0
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pPxWfLgCCLgdDqBViXLpcH4/5O5ZDctL4yWGaPba/fE=;
        b=V5MTUqaQkjX9B4uAXAqVkaGYLuT7WG6TVDTNVjvyzYPP/uvaqwF5fJ11XC8A+qlZnB
         7TjNbznHAhe2p5CDy1ViC8WRkAo6AcTOCvCWQUvhfU5DX43F3kZLU9zhmSOMEVoipxpw
         VnUQFhaIh0oT9GPmLH7l644UOTqeh7eFNL1x4GvH+LVz8f7R4wdI8Kw8RKqCCArNcy5s
         i5CmcbL206d95uLDrBQxZksNvZtzHKDH2TeUBtePS1209JU6KYtBicmHI/1BcrAx64SG
         FaiW38AfDE5tfw/JrzgnV38v1/RVGi4lCtgtxvaQPOiBdilo+TjQ/dxGdHv0PzY+k5sM
         TiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pPxWfLgCCLgdDqBViXLpcH4/5O5ZDctL4yWGaPba/fE=;
        b=f4MJGMX/4I+3leXGTOePqGMQXKzf9j/ERqnCuxqjEs7RqnY+i5HED0Rc08Ilvs/CTT
         993aOjb6EvT8bMIsQ2FQtu/ZpKQejOO2zkIlD98YJb5b4fs1DhrytuRbuuawD/OSfZ1L
         RGrI2zb7030mLadq00eKUBS7U1Z8G3WDhHjHmox9SS5LTQCXO7lba0jdrTlzHoDZsCRb
         iSx73sAx255JE0wmf0JDHGJhqBS6nGOZi/87EPnYTulsUD9b04ovIoGN2skPI0y4LF+b
         zrPy2FbXJVNpI/xattl3sMXB5EipMmffd9zPlksEEjvFggAzR7fSy2hZYkA00/Bhu8KH
         o2IA==
X-Gm-Message-State: AFqh2kpC+phfqucf6gRac3KLWUh/hOMXThnRB8rHeQRXclxtvLtbUt+1
        h5g4h5woedOkCWvAoClGWaNSR7tDIu0Upw==
X-Google-Smtp-Source: AMrXdXuVEnOyqisOXE8MODaNT1+bF7yK35HQ8NOt7UujhMVwxFx1hBUdjQG5JC/HooVpCvPDuJ6mrmbftjj6Kw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:9d85:0:b0:6f7:6238:3c62 with SMTP id
 v5-20020a259d85000000b006f762383c62mr3839185ybp.209.1674767056274; Thu, 26
 Jan 2023 13:04:16 -0800 (PST)
Date:   Thu, 26 Jan 2023 13:04:01 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126210401.2862537-1-dmatlack@google.com>
Subject: [PATCH] KVM: x86/mmu: Replace tdp_mmu_page with a bit in the role
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace sp->tdp_mmu_page with a bit in the page role. This reduces the
size of struct kvm_mmu_page by a byte.

Note that in tdp_mmu_init_sp() there is no need to explicitly set
sp->role.tdp_mmu=1 for every SP since the role is already copied to all
child SPs.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 ++++++++---
 arch/x86/kvm/mmu/mmu.c          |  1 +
 arch/x86/kvm/mmu/mmu_internal.h |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 -
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 +-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..33e5b1c56ff4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -304,10 +304,10 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 19 bits in the mask below, not all combinations
+ * But, even though there are 20 bits in the mask below, not all combinations
  * of modes and flags are possible:
  *
- *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *   - invalid shadow pages are not accounted, so the bits are effectively 19
  *
  *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has
@@ -321,6 +321,10 @@ struct kvm_kernel_irq_routing_entry;
  *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
+ *   - When tdp_mmu=1, only a subset of the remaining bits can vary across
+ *     shadow pages: level, invalid, and smm. The rest are fixed, e.g. direct=1,
+ *     access=ACC_ALL, guest_mode=0, etc.
+ *
  * Therefore, the maximum number of possible upper-level shadow pages for a
  * single gfn is a bit less than 2^13.
  */
@@ -340,7 +344,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned tdp_mmu:1;
+		unsigned:4;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f5..458a7c398f76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5128,6 +5128,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.level = kvm_mmu_get_tdp_level(vcpu);
 	role.direct = true;
 	role.has_4_byte_gpte = false;
+	role.tdp_mmu = tdp_mmu_enabled;
 
 	return role;
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..49591f3bd9f9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -54,7 +54,6 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 
-	bool tdp_mmu_page;
 	bool unsync;
 	u8 mmu_valid_gen;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..e0eda6332755 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -280,7 +280,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	sp->role = role;
 	sp->gfn = gfn;
 	sp->ptep = sptep;
-	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..cf7321635ff1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,7 +71,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->role.tdp_mmu; }
 #else
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif

base-commit: de60733246ff4545a0483140c1f21426b8d7cb7f
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
-- 
2.39.1.456.gfc5497dd1b-goog

