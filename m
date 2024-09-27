Return-Path: <kvm+bounces-27599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1FF987C20
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 02:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13C131F247DE
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA32413A40D;
	Fri, 27 Sep 2024 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cCXiUjIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCA4C98
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727396208; cv=none; b=DKuP1C1RIjtAFdr4kUHuaqe0Qo+1jc0Ao8XfGaW8hQD+GToVj/cabzVh+PFS5inwm4f6oef4gU12SdJBtbPUTC1WMvXhWyKKSAt9WIB7u4JKaPmSHHOjI4Tb70fCDfotckgwsPvM33/4nvsWf5K2bceUGgFXekJomuQAjISc0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727396208; c=relaxed/simple;
	bh=XUxMxGbo8IVDbos6wBsnolJD2X9/FpSrjZX7NpyOkvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J1t2Jk/CvTlqegG1ET0DUR55hAfSBTo0RjUBWe99wqSJBCRVb2PTfdyzwjaK/MY6bOc3iivYVJRqTc/iihf9bbjVFr08EXxCTjJtjz2796V7TnELAUAUCq/i9XEtwHxxjzcziWUZZ91FYvaWX8ggKICzhwBNajvoyxF6Oulplac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cCXiUjIa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e070439426so2248089a91.1
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 17:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727396206; x=1728001006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BT2ULlw760pN7swvLVwkns3C2/rih9SJJkz53vDfr04=;
        b=cCXiUjIaPzIDAlBu7asmH/5sECoMHafYECfaApR7/InQiDwObMtshG90HruQriZBTG
         IH9fKbhJAEeQ/QXMzrokzOaKP3Rcn2P0TEIX1IjYtGJPloZFYCu9WagMhpJIj5pvO5OH
         L9lTsQa/afM+xecxEFOyEWShahI/CSdufbzMTmI1CVfHXvVqD7ctdg7xDnGwyXOu3R5Q
         o2kSowIwK6pil5c09w6b7O5vlJtQx2o1a1S4gPc8qJP82doK7wwI418nyG0v5TO8I8xb
         A8+1RNke0HSS8BW0NLsA1Qh2DRgDR7iifPbukV7jIOJ79OSXVnXKSiLWD9DElMQTDRIL
         RAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727396206; x=1728001006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BT2ULlw760pN7swvLVwkns3C2/rih9SJJkz53vDfr04=;
        b=aLR3kgQ+74/0Ae12PBY9Q3IPYGK/cTordGihjskm7/MH6MgkvQssH5HbslAA/sNBBz
         Uq9XTsx1gEVdkoTzkRO3yMCCGQDt8eQTBFXfNEYXyDuxOYcTJlXz7h8QgKrvoLJmLSt2
         0kemAtr2iXfJ5jxXhdzT/bPDVBUaxly8wNtVD8GlWKthnS+osFO6sFD3tRLU31tLUMY1
         3eoH9/pu3fv3RD99wuaTBM07GmmI1N6d6mWbzZWbS+nWqVEHGlmT8HnLXvslPHdKWt8C
         9Sdb+HHWsYptHtF+iRsLlvHZjWlfNiC/fVQk0+tM8j9gjmFWwOyIh3fA/vVEmCTVUydr
         tLkQ==
X-Gm-Message-State: AOJu0Yxc9YM18PuvTvgqP/iJ4pFwKXfTpgn1FpEwqS1vBwOyaL9ZR+72
	4XqdTzp7esX5E+6CLr/6UbXv1iNFJ3iJDykvjYQe7OlglghIuRX3tyU82nY5N15cS4DWXuDqPjC
	Efg==
X-Google-Smtp-Source: AGHT+IGwasQylCvu4I8BVuSCdmfP6ZlSeL8v6Z33k4yxeX8y33WMwNDys5uVYIJwxQ2AD7a3aefe7ozkktc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2289:b0:20b:26e2:5507 with SMTP id
 d9443c01a7336-20b37c3063dmr231745ad.11.1727396205787; Thu, 26 Sep 2024
 17:16:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Sep 2024 17:16:35 -0700
In-Reply-To: <20240927001635.501418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927001635.501418-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240927001635.501418-5-seanjc@google.com>
Subject: [PATCH 4/4] Revert "KVM: x86/mmu: Introduce a quirk to control
 memslot zap behavior"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Remove KVM_X86_QUIRK_SLOT_ZAP_ALL, as the code is broken for shadow MMUs,
and the underlying premise is dodgy.

As was tried in commit 4e103134b862 ("KVM: x86/mmu: Zap only the relevant
pages when removing a memslot"), all shadow pages, i.e. non-leaf SPTEs,
need to be zapped.  All of the accounting for a shadow page is tied to the
memslot, i.e. the shadow page holds a reference to the memslot, for all
intents and purposes.  Deleting the memslot without removing all relevant
shadow pages, as is done when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled,
results in NULL pointer derefs when tearing down the VM.

 BUG: kernel NULL pointer dereference, address: 00000000000000b0
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 6085f43067 P4D 608c080067 PUD 608c081067 PMD 0
 Oops: Oops: 0000 [#1] SMP NOPTI
 CPU: 79 UID: 0 PID: 187063 Comm: set_memory_regi Tainted: G        W          6.11.0-smp--24867312d167-cpl #395
 Tainted: [W]=WARN
 Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
 RIP: 0010:__kvm_mmu_prepare_zap_page+0x3a9/0x7b0 [kvm]
 Code:  <48> 8b 8e b0 00 00 00 48 8b 96 e0 00 00 00 48 c1 e9 09 48 29 c8 8b
 RSP: 0018:ff314a25b19f7c28 EFLAGS: 00010212
 Call Trace:
  <TASK>
  kvm_arch_flush_shadow_all+0x7a/0xf0 [kvm]
  kvm_mmu_notifier_release+0x6c/0xb0 [kvm]
  mmu_notifier_unregister+0x85/0x140
  kvm_put_kvm+0x263/0x410 [kvm]
  kvm_vm_release+0x21/0x30 [kvm]
  __fput+0x8d/0x2c0
  __se_sys_close+0x71/0xc0
  do_syscall_64+0x83/0x160
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Rather than trying to get things functional for shadow MMUs (which
includes nested TDP), scrap the quirk idea, at least for now.  In addition
to the function bug, it's not clear that unconditionally doing a targeted
zap for all non-default VM types is actually desirable.  E.g. it's entirely
possible that SEV-ES and SNP VMs would exhibit worse performance than KVM's
current "zap all" behavior, or that it's better to do a targeted zap only
in specific situations, etc.

This reverts commit aa8d1f48d353b0469bff357183ee9df137d15ef0.

Cc: Kai Huang <kai.huang@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |  8 --------
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/include/uapi/asm/kvm.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 34 +--------------------------------
 4 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e32471977d0a..a4b7dc4a9dda 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8097,14 +8097,6 @@ KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     guest CPUID on writes to MISC_ENABLE if
                                     KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
                                     disabled.
-
-KVM_X86_QUIRK_SLOT_ZAP_ALL          By default, KVM invalidates all SPTEs in
-                                    fast way for memslot deletion when VM type
-                                    is KVM_X86_DEFAULT_VM.
-                                    When this quirk is disabled or when VM type
-                                    is other than KVM_X86_DEFAULT_VM, KVM zaps
-                                    only leaf SPTEs that are within the range of
-                                    the memslot being deleted.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..4738f6f5a794 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2358,8 +2358,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
-	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
-	 KVM_X86_QUIRK_SLOT_ZAP_ALL)
+	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a8debbf2f702..bf57a824f722 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -439,7 +439,6 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
-#define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e081f785fb23..0d94354bb2f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7049,42 +7049,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_mmu_zap_all(kvm);
 }
 
-/*
- * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
- *
- * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
- * case scenario we'll have unused shadow pages lying around until they
- * are recycled due to age or when the VM is destroyed.
- */
-static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
-{
-	struct kvm_gfn_range range = {
-		.slot = slot,
-		.start = slot->base_gfn,
-		.end = slot->base_gfn + slot->npages,
-		.may_block = true,
-	};
-
-	write_lock(&kvm->mmu_lock);
-	if (kvm_unmap_gfn_range(kvm, &range))
-		kvm_flush_remote_tlbs_memslot(kvm, slot);
-
-	write_unlock(&kvm->mmu_lock);
-}
-
-static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
-{
-	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
-	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	if (kvm_memslot_flush_zap_all(kvm))
-		kvm_mmu_zap_all_fast(kvm);
-	else
-		kvm_mmu_zap_memslot_leafs(kvm, slot);
+	kvm_mmu_zap_all_fast(kvm);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
-- 
2.46.1.824.gd892dcdcdd-goog


