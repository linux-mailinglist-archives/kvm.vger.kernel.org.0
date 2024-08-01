Return-Path: <kvm+bounces-22981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DB49452C4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B911282C7E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7B814A0A3;
	Thu,  1 Aug 2024 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xqnkioJg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E980144D00
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537300; cv=none; b=jEG+LY2AVRY1197kYX29suJNUWQaRXeApoEp/cxp9SVmrOcjz5y4moFPmuRy/VCJaaMTLv9O3/nu/86/GQRFpdMA8iA+lgOKP3Vnv/bIdGf2W4SgEFABlZuzFL32Vl4sJTMHGkO2vOiao8CzRKcxu2BwHbWQeBFlM+ZgmW/J5F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537300; c=relaxed/simple;
	bh=B4M5zM2LxlbX4e+OKo938Pgq8tauyjOo2Mz9UK1WRwE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X9plHNFGXjcFFaoL1YaUyffLyU3qzuQdZHvTEeujguU+jmZxWxbP8r0p2+MCNs2FZKPOZR+w0VpieodJYzfkmvP08CvrEbX1sTy38hufzt0p72Q6XAa2PxxIaMYI5sR+JSnMbjgTIolFs8i4qRrx7d4viwTVYAvRWPjwRTuCfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xqnkioJg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0ba463c970so5195654276.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537298; x=1723142098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pYuydgqnu7KvS+vD/kJx/xLlR2Fg91BOlW6zTjcno7Q=;
        b=xqnkioJgRWzyMTa9C3AyqvcLKXN1NXw1GUktnC8nbyN5UNZOJf49BsVPbZikkX1xXR
         x+4xK5Q2URGVSmX0ZbAQ70ZwN9eFbPW6jrUJuqA2rhMI2vzLwHxVK/CU8VHU26QyyPmv
         sB5LDDsFOym5GSofCSESv1Iop7cZzQ1TOMBN38YOTaHqQEClvXoed/8ZO0DEbpk674Xb
         EYzGWJbuNXZJrepSbzsqm/WUThX5yu3M8+5kAUN93pvcVDOl8Ki8vMwdJnKUc46M73TZ
         VP5TFcLtBjfYB1JCMysdb/tUVWiJCKM7sAKuL7c9p2o+GDrq/Fgc5vtCKYUnwadbuB7b
         0AFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537298; x=1723142098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pYuydgqnu7KvS+vD/kJx/xLlR2Fg91BOlW6zTjcno7Q=;
        b=EH1DM0nFmUP2D1OXgvvNaXxUmB5xLewiYP2KkeJA7AxdHXRVkI0v00c8qmnsfBb1Od
         iuOsb1Xg71Ltxc11WI7vOHyOwL6MkI1sbNYnfxvsYyU9/rgUjfdlTzcS8xjXUWk0Qvku
         SG5SUjq6I3fTL5oh5m5s2nwatu2POOR7k+nvv1ucTW8KJ7a8bnrexB6gG5hdtXZ4/85O
         GhB18TcyreFILuiaaZgVY1GWyLjfsta+8BgZKI0mCkr9vy3SRTDZpef9EnJLdmwi54wa
         aYm/8dkdfQQFCJ+rFM+gmTUTteufybG8M0g7eBOiBmbq3JLv/FGxcvpdmaF1FoUOyVYS
         +2Uw==
X-Gm-Message-State: AOJu0YxCep+ZCPYOw+pzSektJvD/W6YojZxm8CHVvRTpAzfb3/MlM1/r
	k0Z6Im6/U045/0Sh2wBveDGsRO10MD0AI15QQonodfC5eqZPS8yMj96tYBLHu3CTF/D3Hu1Yu97
	fbg==
X-Google-Smtp-Source: AGHT+IFfRgjDzueDHA1wB4xIJlPq2Sh0SGDxzPYZTvnWrBT2GBLIr7FzlALzApVC+WiYgVOffmnlJ9uzeLA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b02:b0:e03:31ec:8a24 with SMTP id
 3f1490d57ef6-e0bde422b24mr29349276.8.1722537298373; Thu, 01 Aug 2024 11:34:58
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:45 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-2-seanjc@google.com>
Subject: [RFC PATCH 1/9] KVM: x86/mmu: Add a dedicated flag to track if A/D
 bits are globally enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a dedicated flag to track if KVM has enabled A/D bits at the module
level, instead of inferring the state based on whether or not the MMU's
shadow_accessed_mask is non-zero.  This will allow defining and using
shadow_accessed_mask even when A/D bits aren't used by hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  6 +++---
 arch/x86/kvm/mmu/spte.c    |  6 ++++++
 arch/x86/kvm/mmu/spte.h    | 20 +++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c |  4 ++--
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5979eeb916cd..1e24bc4a06db 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3319,7 +3319,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 *    by setting the Writable bit, which can be done out of mmu_lock.
 	 */
 	if (!fault->present)
-		return !kvm_ad_enabled();
+		return !kvm_ad_enabled;
 
 	/*
 	 * Note, instruction fetches and writes are mutually exclusive, ignore
@@ -3454,7 +3454,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * uses A/D bits for non-nested MMUs.  Thus, if A/D bits are
 		 * enabled, the SPTE can't be an access-tracked SPTE.
 		 */
-		if (unlikely(!kvm_ad_enabled()) && is_access_track_spte(spte))
+		if (unlikely(!kvm_ad_enabled) && is_access_track_spte(spte))
 			new_spte = restore_acc_track_spte(new_spte);
 
 		/*
@@ -5429,7 +5429,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.efer_nx = true;
 	role.smm = cpu_role.base.smm;
 	role.guest_mode = cpu_role.base.guest_mode;
-	role.ad_disabled = !kvm_ad_enabled();
+	role.ad_disabled = !kvm_ad_enabled;
 	role.level = kvm_mmu_get_tdp_level(vcpu);
 	role.direct = true;
 	role.has_4_byte_gpte = false;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2c5650390d3b..b713a6542eeb 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -24,6 +24,8 @@ static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
+bool __read_mostly kvm_ad_enabled;
+
 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
 u64 __read_mostly shadow_nx_mask;
@@ -435,6 +437,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
 
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 {
+	kvm_ad_enabled		= has_ad_bits;
+
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
@@ -468,6 +472,8 @@ void kvm_mmu_reset_all_pte_masks(void)
 	u8 low_phys_bits;
 	u64 mask;
 
+	kvm_ad_enabled = true;
+
 	/*
 	 * If the CPU has 46 or less physical address bits, then set an
 	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ef793c459b05..d722b37b7434 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -167,6 +167,15 @@ static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
 #define SHADOW_NONPRESENT_VALUE	0ULL
 #endif
 
+
+/*
+ * True if A/D bits are supported in hardware and are enabled by KVM.  When
+ * enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can disable
+ * A/D bits in EPTP12, SP and SPTE variants are needed to handle the scenario
+ * where KVM is using A/D bits for L1, but not L2.
+ */
+extern bool __read_mostly kvm_ad_enabled;
+
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
@@ -285,17 +294,6 @@ static inline bool is_ept_ve_possible(u64 spte)
 	       (spte & VMX_EPT_RWX_MASK) != VMX_EPT_MISCONFIG_WX_VALUE;
 }
 
-/*
- * Returns true if A/D bits are supported in hardware and are enabled by KVM.
- * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
- * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
- * scenario where KVM is using A/D bits for L1, but not L2.
- */
-static inline bool kvm_ad_enabled(void)
-{
-	return !!shadow_accessed_mask;
-}
-
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dc153cf92a40..2b0fc601d2ce 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1072,7 +1072,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 			   struct kvm_mmu_page *sp, bool shared)
 {
-	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
+	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled);
 	int ret = 0;
 
 	if (shared) {
@@ -1488,7 +1488,7 @@ static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
 	 * from level, so it is valid to key off any shadow page to determine if
 	 * write protection is needed for an entire tree.
 	 */
-	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled();
+	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled;
 }
 
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-- 
2.46.0.rc1.232.g9752f9e123-goog


