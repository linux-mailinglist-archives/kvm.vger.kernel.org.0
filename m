Return-Path: <kvm+bounces-9870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D6E8678BD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3423B293E25
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8E412F368;
	Mon, 26 Feb 2024 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JaiUA9Os"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0860012EBF1;
	Mon, 26 Feb 2024 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958102; cv=none; b=ks3hdiBlvHT22cXVkHdYNAsHsabmTlbXwmZ5IZCtNfM9MPcYcnIKVX5Ne07Rm/39b6grTC7GSDlddXvhBVhiFm2IXlfZoS9ii47f+G+MhKv55QlHArcyAgah71SLj1QWg21bB0iOfR1e0E5dtZq3m+a3l8iTNYHN+8uwXHpukiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958102; c=relaxed/simple;
	bh=mp4bIEVXnnIUzxsDHcmVT4EyPtcJSElBPfc+LZawrHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dn8IPm82lxPy417X+GYEPZd0/o/Ubr72U9C0+6rw2asD+HEm2UNixuUgxKOMNLBvaP1CxV+gBclETNNDqlJbKUEBuyOnl0Y+rAYcE70z7mfIf/GCfJ3L6f08yaUSax/6GL8S22PMCbFsB0IvKClnpALFZNcT4ltpNa1hwrdH0Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JaiUA9Os; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e4f49c5632so593160b3a.0;
        Mon, 26 Feb 2024 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958100; x=1709562900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGcizR5RhJyAZaF61CVdloVSq2PxTGm8Bnu+7WmTNJg=;
        b=JaiUA9OstKah3JAP40jBp3Ftu3TGLqF+Xr1kXv3+SKImIaqe+BvycZ1DKWjH/Y0kiJ
         gfU8bvoNd3SyawEMImClrHqiZqTQ1TF5IhAJmjFy1bz4ABJ/KL7goTSbtb6FBbOFxWgr
         pnF3Xb76va9t633C4l0qiWJZlhT/NyYv+7mWDseUEsq5Kznb/ZbAxlR+NBodD1dnDKX8
         vmz5Kzwm2ipDH0sA2q65s7yZIJ17aRdJ/KqnPX79PnMUTJPz2ErdCtA/G56I0gJtijYw
         8FJjSzcuLq1zf0iWvJ4hdt6xgzjrSzV2wUpFegEK1XgFMb4Y5sY1Q+//oBwsRoL0oF4x
         yBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958100; x=1709562900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGcizR5RhJyAZaF61CVdloVSq2PxTGm8Bnu+7WmTNJg=;
        b=te1+KLHPNfOK+NXIF/i8XuZPszyp1pKoWzSkglIVds+DwuUe2l84CDgJVVAi5XEqyd
         OrgsyJkaoCS3QvztLrtRor9A9L8DLMXafvkQgiQ2tPP8+rraujppSU/AfufEQNt1oVHC
         O9/ghD7nP2J5KQny6ae2Xqg+ApMeg1/a7FTI8Tkx2b5h48TQGMX8SLxH3xalYylhuXxR
         jZ/cGHRigytSd6thCWfzf0zxEMnpY4oLTN8+Pv7zMNTHC5S7DIYnba8bBSpvWDQa541H
         ykvjHKl2tYa1IMDh456iXKdRh3y5pcvPPuCviir0pJOC0EzqC9LDmCzclntyGpDkm+rg
         mh2g==
X-Forwarded-Encrypted: i=1; AJvYcCXxHT2Cd1zhnERzs/7i0Sk9iI+OMqVLLZkClItcp6kVDteAn4xQTuW8nS2GfCWox4Z6aIbBp09YdinjwpGuOEdz5o4L
X-Gm-Message-State: AOJu0Yx/X6xL+ZmblyVv5SMPjtUAr8IY5Hpy0SNvlpDuRTPYWszgNoQ4
	WGMu9uU3sV8G3bos0ArObBbJtYOM/VE3VekMT2TOiVe74HcKzdbeJQkzU6d/
X-Google-Smtp-Source: AGHT+IEQ5ZAAPokPrEcDDW70e6Lag98en0XxkSEwYRvhdcHIwCUTOJilf0F9mb76AEaNtv2jcqpTtw==
X-Received: by 2002:a05:6a00:1397:b0:6e4:f761:1a4c with SMTP id t23-20020a056a00139700b006e4f7611a4cmr6338374pfg.12.1708958099979;
        Mon, 26 Feb 2024 06:34:59 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id it8-20020a056a00458800b006e05c801748sm4103087pfb.199.2024.02.26.06.34.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:59 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 07/73] KVM: x86/mmu: Adapt shadow MMU for PVM
Date: Mon, 26 Feb 2024 22:35:24 +0800
Message-Id: <20240226143630.33643-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In PVM, shadow MMU is used for guest MMU virtualization. However, it
needs some changes to adapt for PVM:

1. In PVM, hardware CR4.LA57 is not changed, so the paging level of
   shadow MMU should be same as host. If the guest paging level is 4 and
   host paging level is 5, then it performs like shadow NPT MMU and
   'root_role.passthrough' is set as true.

2. PVM guest needs to access the host switcher, so some host mapping PGD
   entries will be cloned into the guest shadow paging table during the
   root SP allocation. These cloned host PGD entries are not marked as MMU
   present, so they can't be cleared by write-protecting. Additionally, in
   order to avoid modifying those cloned host PGD entries in the #PF
   handling path, a new callback is introduced to check the fault of the
   guest virtual address before walking the guest page table. This ensures
   that the guest cannot overwrite the host entries in the root SP.

3. If the guest paging level is 4 and the host paging level is 5, then the
   last PGD entry in the root SP is allowed to be overwritten if the guest
   tries to build a new allowed mapping under this PGD entry. In this case,
   the host P4D entries in the table pointed to by the last PGD entry
   should also be cloned during the new P4D SP allocation. These cloned P4D
   entries are also not marked as MMU present. A new bit in the
   'kvm_mmu_page_role' is used to mark this special SP. When zapping this
   SP, its parent PTE will be set to the original host PGD PTEs instead of
   clearing it.

4. The user bit in the SPTE of guest mapping should be forced to be set
   for PVM, as the guest is always running in hardware CPL3.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  6 ++++-
 arch/x86/kvm/mmu/mmu.c             | 35 +++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h     |  3 +++
 arch/x86/kvm/mmu/spte.c            |  4 ++++
 5 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 26b628d84594..32e5473b499d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -93,6 +93,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL_RET0(disallowed_va)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..c76bafe9c7e2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -346,7 +346,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned host_mmu_la57_top_p4d:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
@@ -1429,6 +1430,7 @@ struct kvm_arch {
 	 * the thread holds the MMU lock in write mode.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+	u64 *host_mmu_root_pgd;
 #endif /* CONFIG_X86_64 */
 
 	/*
@@ -1679,6 +1681,8 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	bool (*disallowed_va)(struct kvm_vcpu *vcpu, u64 la);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c57e181bba21..80406666d7da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1745,6 +1745,18 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
+#define HOST_ROOT_LEVEL (pgtable_l5_enabled() ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL)
+
+static inline bool pvm_mmu_p4d_at_la57_pgd511(struct kvm *kvm, u64 *sptep)
+{
+	if (!pgtable_l5_enabled())
+		return false;
+	if (!kvm->arch.host_mmu_root_pgd)
+		return false;
+
+	return sptep_to_sp(sptep)->role.level == 5 && spte_index(sptep) == 511;
+}
+
 static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
@@ -1764,7 +1776,10 @@ static void drop_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(kvm, sp, parent_pte);
-	mmu_spte_clear_no_track(parent_pte);
+	if (!unlikely(sp->role.host_mmu_la57_top_p4d))
+		mmu_spte_clear_no_track(parent_pte);
+	else
+		__update_clear_spte_fast(parent_pte, kvm->arch.host_mmu_root_pgd[511]);
 }
 
 static void mark_unsync(u64 *spte);
@@ -2253,6 +2268,15 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	list_add(&sp->link, &kvm->arch.active_mmu_pages);
 	kvm_account_mmu_page(kvm, sp);
 
+	/* install host mmu entries when PVM */
+	if (kvm->arch.host_mmu_root_pgd && role.level == HOST_ROOT_LEVEL) {
+		memcpy(sp->spt, kvm->arch.host_mmu_root_pgd, PAGE_SIZE);
+	} else if (role.host_mmu_la57_top_p4d) {
+		u64 *p4d = __va(kvm->arch.host_mmu_root_pgd[511] & SPTE_BASE_ADDR_MASK);
+
+		memcpy(sp->spt, p4d, PAGE_SIZE);
+	}
+
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
@@ -2354,6 +2378,9 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 		return ERR_PTR(-EEXIST);
 
 	role = kvm_mmu_child_role(sptep, direct, access);
+	if (unlikely(pvm_mmu_p4d_at_la57_pgd511(vcpu->kvm, sptep)))
+		role.host_mmu_la57_top_p4d = 1;
+
 	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
@@ -5271,6 +5298,12 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
 	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
 
+	/* Shadow MMU level should be the same as host for PVM */
+	if (vcpu->kvm->arch.host_mmu_root_pgd && root_role.level != HOST_ROOT_LEVEL) {
+		root_role.level = HOST_ROOT_LEVEL;
+		root_role.passthrough = 1;
+	}
+
 	/*
 	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
 	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f67..8ea3dca940ad 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -336,6 +336,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto error;
 		--walker->level;
 	}
+
+	if (static_call(kvm_x86_disallowed_va)(vcpu, addr))
+		goto error;
 #endif
 	walker->max_level = walker->level;
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..e302f7b5c696 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -186,6 +186,10 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
 
+	/* PVM guest is always running in hardware CPL3. */
+	if (vcpu->kvm->arch.host_mmu_root_pgd)
+		spte |= shadow_user_mask;
+
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 
-- 
2.19.1.6.gb485710b


