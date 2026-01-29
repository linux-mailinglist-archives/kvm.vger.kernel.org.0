Return-Path: <kvm+bounces-69459-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAixFw+1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69459-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8F4AA91D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 948FC3030499
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCD53191C0;
	Thu, 29 Jan 2026 01:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4LkUNy2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3437335562
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649347; cv=none; b=l8AQr/WwsZN6oJNdrK6tWMKsZgPyvnzdAuL/4pmi1N/SmkSKg/4FJUrZHpwH8bsuYcxTbtqG/ul6sAWQ9Re8ehByyYmkfYaqN24jRLXmaXIXPKcwCt6+/z8GqT/VY9NM0PX1l/J6BpfF0xaAVphvOsluyaoCyWbRTuPEXkb7oGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649347; c=relaxed/simple;
	bh=yVpImpTFQZriVyFQbj/bWHkCHJ5SUUu9kYYN2lYkaKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E0TxWadF4xwqbsVHGZnEZEJZwxC9NJ1Dm/2DLiwb9NNUlTukcS1zO0SdKtgSg5mG1HOqMK9I6GCOsKUnY8fIL05Ph0gM0f9fMk4H0Sd79aRaTtBHkpAucoBi9YRHqPwNGpFBNgkZSSAekv7XdpWArbRZKSa5f1qXqm0pJ06nKpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4LkUNy2a; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ec823527eso661560a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649344; x=1770254144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=p4DxLrcS3WgLaR+fYgPLmC8YCbLvAUFJ1rM8P1CFw/Y=;
        b=4LkUNy2alYrfyl04ZgQlm5uL+2WzFB/tbjaLUBWqrBOV7HeurA/0YyvChECR7+xiJF
         bBAI2a5JrQsFaNofX15rT4HFEXoBKaR9PzpCVYHy5tAMDPfu7NXcm8x/PrHk0AOrKpUd
         VRaXURdQ0xAiDm4TVDCrwDDGnsE1N9vIhFovkIEw27j68iRfLaL6CO5QCUFd5w9/UwoB
         ZiXMbkN2uAxZUHqJKdH4gP+iEvK9qECbX+gBAlgTMC+fO7xvbjsyeO3XIWp8YE6lrac1
         LPRt2Gf9hpofFfwfHSE3rF7wWtWwf19oF+GjZKsF+lHGrnxUtI67bgbXT+dOIp3yb819
         I5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649344; x=1770254144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p4DxLrcS3WgLaR+fYgPLmC8YCbLvAUFJ1rM8P1CFw/Y=;
        b=YdSyQjxW7WmAKnMcREjriP32rCZbvHe3ztZknaLFF8jMWLJQbwx62YrByLfuWMYKeT
         uHdhbPsaxUDNonc+5ZZN7OvoQYQDujHi0wJSAzqbJ1wEt4FgulLBIlpJo180e+hCvQzQ
         ynvS7nWv9gSCzOKHaIkt1DsVkNJ9nesauQKYD8r9KojWI8nhrmlJx8aT8a5e794NDe3L
         G8Cx6LMuJbqmFAwPKZoF7DHJQMSdo6dc6FnXQp+uK5+/nLlQMP/eipT8WI4sbXfSKqsV
         43w4KAc0oOiw9F32XQJWww+jEzzvgsDs9OsSVL23tyvipwJdIEnU+LwQENDIGg55nY+J
         5b/A==
X-Forwarded-Encrypted: i=1; AJvYcCXseQ9ZUNtSAXKr3g2Jtwa+aA/UUPGjaXvRxXPlhz+9nD/bcxXAgZCf9/X3MffzZXv8OnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUm47KgjZIwmGeP/ZuqxdHbVxZvfrtzttlyRH+1cAvoz7i8/41
	BX6+3Lb6Q2P/KF2eMbAOmptpw95Eb5/27k35sostNE9OPaghEcuRf8PCisjohd2+yjzSqiHEYxU
	ZtHq7xQ==
X-Received: from pjbbh4.prod.google.com ([2002:a17:90b:484:b0:34c:dd6d:b10e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2705:b0:34c:2db6:57d6
 with SMTP id 98e67ed59e1d1-353fed866a5mr6317423a91.19.1769649344156; Wed, 28
 Jan 2026 17:15:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:41 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-10-seanjc@google.com>
Subject: [RFC PATCH v5 09/45] KVM: x86: Rework .free_external_spt() into .reclaim_external_sp()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69459-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: EE8F4AA91D
X-Rspamd-Action: no action

Massage .free_external_spt() into .reclaim_external_sp() to free up (pun
intended) "free" for actually freeing memory, and to allow TDX to do more
than just "free" the S-EPT entry.  Specifically, nullify external_spt to
leak the S-EPT page if reclaiming the page fails, as that detail and
implementation choice has no business living in the TDP MMU.

Use "sp" instead of "spt" even though "spt" is arguably more accurate, as
"spte" and "spt" are dangerously close in name, and because the key
parameter is a kvm_mmu_page, not a pointer to an S-EPT page table.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c         | 13 ++-----------
 arch/x86/kvm/vmx/tdx.c             | 27 ++++++++++++---------------
 4 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 57eb1f4832ae..c17cedc485c9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -95,8 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
-KVM_X86_OP_OPTIONAL_RET0(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(reclaim_external_sp)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d12ca0f8a348..b35a07ed11fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1858,8 +1858,8 @@ struct kvm_x86_ops {
 				 u64 mirror_spte);
 
 	/* Update external page tables for page table about to be freed. */
-	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				 void *external_spt);
+	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
+				    struct kvm_mmu_page *sp);
 
 	/* Update external page table from spte getting removed, and flush TLB. */
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27ac520f2a89..18764dbc97ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -456,17 +456,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 				    old_spte, FROZEN_SPTE, level, shared);
 	}
 
-	if (is_mirror_sp(sp) &&
-	    WARN_ON(kvm_x86_call(free_external_spt)(kvm, base_gfn, sp->role.level,
-						    sp->external_spt))) {
-		/*
-		 * Failed to free page table page in mirror page table and
-		 * there is nothing to do further.
-		 * Intentionally leak the page to prevent the kernel from
-		 * accessing the encrypted page.
-		 */
-		sp->external_spt = NULL;
-	}
+	if (is_mirror_sp(sp))
+		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 30494f9ceb31..66bc3ceb5e17 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1783,27 +1783,24 @@ static void tdx_track(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
 
-static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, void *private_spt)
+static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
+					struct kvm_mmu_page *sp)
 {
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
 	/*
-	 * free_external_spt() is only called after hkid is freed when TD is
-	 * tearing down.
 	 * KVM doesn't (yet) zap page table pages in mirror page table while
 	 * TD is active, though guest pages mapped in mirror page table could be
 	 * zapped during TD is active, e.g. for shared <-> private conversion
 	 * and slot move/deletion.
+	 *
+	 * In other words, KVM should only free mirror page tables after the
+	 * TD's hkid is freed, when the TD is being torn down.
+	 *
+	 * If the S-EPT PTE can't be removed for any reason, intentionally leak
+	 * the page to prevent the kernel from accessing the encrypted page.
 	 */
-	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
-		return -EIO;
-
-	/*
-	 * The HKID assigned to this TD was already freed and cache was
-	 * already flushed. We don't have to flush again.
-	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
+	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
+		sp->external_spt = NULL;
 }
 
 static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -3617,7 +3614,7 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
 
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
-	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
+	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 }
-- 
2.53.0.rc1.217.geba53bf80e-goog


