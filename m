Return-Path: <kvm+bounces-69490-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aO0sKHm2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69490-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAE3AAA65
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7021C3024364
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179D8339865;
	Thu, 29 Jan 2026 01:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sEuSOiDV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE736CE0D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649403; cv=none; b=Q5l2tD/zyLroS2tWyplE9BbPTOrxch0EGsbMXuLvkZ6C+5gMI3Ttzbl6GE7r16/c9XKR2T0Ymz5X+8hOTFociZWbl8WMAR+McqcWK05eclACa6PfJ9kRLPE/3DJtxBfg33WaOaXghh6tnc6K5oJBLi3OJgps+quEQQJVbpyuTrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649403; c=relaxed/simple;
	bh=748IjIIuUafEiIM83Ku56LzDm+kATSx23KWSqCyn9i4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kgCUFLXQ0ckCqXHEd8uob87aOUehv1+x5N8C7UZpdniAhzE9q3Uq6BU+WAHRUsvcZcZAcyVMXbvwjd+8X2h63moShPwyIoyVtnqtWWOOeUKiMVRceX8vbMjkxbTtUQzPgV7t/LkAL70TNp53RzsVC/jYriWadBGTqO7V17T467E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sEuSOiDV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ea5074935so323490a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649401; x=1770254201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QSAxn7KWvy+xJKU0DNDq3fpgZfT3mJRUWulB6u+627E=;
        b=sEuSOiDVz3kgLmg+QRTGoCJnBp6tAVQhpvov++AvSZYsTWc3bJowjohb2kmc2rCWLD
         KBV2VbnwNVtw31lHjPU18xL3yiWcrnAe43avbY8es96+TWu1hOY4g3PaTl488/ZDuxlu
         m1eAh1taMnwxvgjkS9HT27noMNxXULl46D6+XfcYsy2GzaUwapx2YnQykkr1DkLmcrNW
         S2f6HGIAQgp3DkdBYURltgW6pHAiFwg2Utwa2ubD+9p2JwO6pJkyn8zk4HPS8RtNQE3o
         uVHdg02GBC8MayI6PJKfGHIdPRli8dqfVHONTS2Vth4oI0TTShHLzUL/3rnQFMFjKSj1
         1Mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649401; x=1770254201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QSAxn7KWvy+xJKU0DNDq3fpgZfT3mJRUWulB6u+627E=;
        b=PeDeGJDWha/KxSOH30XI4BbgnAJzr9dIKGlMrGTpxg7QG2N0hknGbNsFJwcIlZ8x6V
         LMr+UfVzM1aLN3FYbHA3aa39qtFSGUCArvbuCeVQnnh23Cn8dCbxgYjaZpTvHb0VM0wM
         sw4fbMaQcAYgkMJ+SLZtURPEzjgvkyFP1CG34j1nhODvqtS/ur3eq/Q+gHm1HyAjbjaD
         XmtO/dvIz5KtzCUJTc9RDDZv7qb4eaKj/I1FSvJgz2Mph5JiO67sf+A6YNdXGISLj3A+
         dg9N9QnMSuIivtXJQ2OykRYmQc4GY397mdASftCkK0kLGD3CAJAXpvXGnmzMFb8K67TW
         NxfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzqfPP/Fs6bKhPTy7YK9KqtBNF3PelVHVaPc5XomIQG8jF46NpFZSxbAarUoi7EFwJ7j0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA8rnblP+d4gOgaKuWtFrrCOoj99MW5B+uclwcs+xeMrI2yrCk
	dIVWuJcndrWknk1PifWr183Hga2JgWYo00SrD9W0fFZ8Mucavk5Tt4KPjxw6dDTWZgDxSVwHAHH
	SBs+8/g==
X-Received: from pght14.prod.google.com ([2002:a63:eb0e:0:b0:c1d:1cf6:2897])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:568e:b0:38d:fc34:c887
 with SMTP id adf61e73a8af0-38ec654856dmr6765109637.65.1769649401195; Wed, 28
 Jan 2026 17:16:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:11 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-40-seanjc@google.com>
Subject: [RFC PATCH v5 39/45] KVM: TDX: Add core support for
 splitting/demoting 2MiB S-EPT to 4KiB
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69490-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4BAE3AAA65
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

Add support for splitting, a.k.a. demoting, a 2MiB S-EPT hugepage to its
512 constituent 4KiB pages.  As per the TDX-Module rules, first invoke
MEM.RANGE.BLOCK to put the huge S-EPTE entry into a splittable state, then
do MEM.TRACK and kick all vCPUs outside of guest mode to flush TLBs, and
finally do MEM.PAGE.DEMOTE to demote/split the huge S-EPT entry.

Assert the mmu_lock is held for write, as the BLOCK => TRACK => DEMOTE
sequence needs to be "atomic" to guarantee success (and because mmu_lock
must be held for write to use tdh_do_no_vcpus()).

Note, even with kvm->mmu_lock held for write, tdh_mem_page_demote() may
contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
operations.  Therefore, wrap the call with tdh_do_no_vcpus() to kick other
vCPUs out of the guest and prevent tdh_vp_enter() to ensure success.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: wire up via tdx_sept_link_private_spt(), massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e90610540a0b..af63364c8713 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1776,6 +1776,52 @@ static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
 	return virt_to_page(sp->external_spt);
 }
 
+/*
+ * Split a huge mapping into the target level.  Currently only supports 2MiB
+ * mappings (KVM doesn't yet support 1GiB mappings for TDX guests).
+ *
+ * Invoke "BLOCK + TRACK + kick off vCPUs (inside tdx_track())" since DEMOTE
+ * now does not support yet the NON-BLOCKING-RESIZE feature. No UNBLOCK is
+ * needed after a successful DEMOTE.
+ *
+ * Under write mmu_lock, kick off all vCPUs (inside tdh_do_no_vcpus()) to ensure
+ * DEMOTE will succeed on the second invocation if the first invocation returns
+ * BUSY.
+ */
+static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+				       u64 new_spte, enum pg_level level)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+	struct page *external_spt;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	external_spt = tdx_spte_to_external_spt(kvm, gfn, new_spte, level);
+	if (!external_spt)
+		return -EIO;
+
+	if (KVM_BUG_ON(!vcpu || vcpu->kvm != kvm, kvm))
+		return -EIO;
+
+	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
+			      level, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
+		return -EIO;
+
+	tdx_track(kvm);
+
+	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
+			      level, spte_to_pfn(old_spte), external_spt,
+			      &to_tdx(vcpu)->pamt_cache, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
+		return -EIO;
+
+	return 0;
+}
+
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn, u64 new_spte,
 				     enum pg_level level)
 {
@@ -1853,9 +1899,8 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				     u64 new_spte, enum pg_level level)
 {
-	/* TODO: Support replacing huge SPTE with non-leaf SPTE. (a.k.a. demotion). */
-	if (KVM_BUG_ON(is_shadow_present_pte(old_spte) && is_shadow_present_pte(new_spte), kvm))
-		return -EIO;
+	if (is_shadow_present_pte(old_spte) && is_shadow_present_pte(new_spte))
+		return tdx_sept_split_private_spte(kvm, gfn, old_spte, new_spte, level);
 	else if (is_shadow_present_pte(old_spte))
 		return tdx_sept_remove_private_spte(kvm, gfn, old_spte, level);
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


