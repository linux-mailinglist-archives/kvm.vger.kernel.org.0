Return-Path: <kvm+bounces-69484-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AIS0CKq2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69484-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD8EAAAB2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C6503085AD0
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232C932E6A2;
	Thu, 29 Jan 2026 01:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8HNgDN9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA87A3314C5
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649393; cv=none; b=NBRwDz60CrFNSLQj4iKLaK0HQVQD4Ay7Ihzsexc517pB0VyYe+hedkTj9vYRCOUswkyb7maZdciN/OWZDnmZhgvpGv99/Q1V0VC2g8djXFil4muQCbB0JuyBdxDb7sBeLBt8cxPseSIydobGfbHklJabNG2V9XxHSLqZlHlBUQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649393; c=relaxed/simple;
	bh=KvOn9sdpHKW3QH4/pQ+ztFzBdmExEpDhGv9YuGKPiRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JN9OCokPa00KyLxFAiAmlF0FL6yzmu6dRcuwqSPPOD6iqVtbWr8ZPii+ffQdv/uL6cnl4iVwYErqtQZ8Q2whlItV0SdXB569vbEuc75jF8bcYr49hkOfhOXz+TQXx3iPmMoMSwROxmkzM0XHeMHz7a2noybrGV5zi4emsj8//0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d8HNgDN9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8234ea73bdeso532124b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649391; x=1770254191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=czjQrUOc/hIkSrdYFZVTFF/3UmFL9ujoJHiw3Kb4R7I=;
        b=d8HNgDN9HVCg3MdK0RAyyRGxFP1wCgTfOeJLZ1/DBZTMdCNZBPY89yzij0It7hzp+E
         frEfTu41gDO3WOF5iBsiwNvCk/+CGs7RgMhtI8fIbnDyFkU02Nc//OpKaih+GXvy66Fg
         k+Uy8Pux0MNtVGavHWx7uKS6hWNFbNCvMphglCX49sRn+N0VNaAk75KHVWMQ1B8yCEaQ
         QtLV8Q4jXZaPHOEmiEqy/FmG88Ev7Ykx3/dO46jnA9rDjXvU8ghlRDwI1M1uvtefJNmq
         a31E11zBZhTwvIZ2aqWmQ2O1cwxCQ7wqy+GkFz18ZVCFjIWc+gN6mZ5jlPKmq8jTKx+t
         LI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649391; x=1770254191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czjQrUOc/hIkSrdYFZVTFF/3UmFL9ujoJHiw3Kb4R7I=;
        b=ogidVpnwLg38XpfT4oI4aAbA0qJFiXJlXI5iTpTJiOzyaPHxakEzO1HeP7k/IuBkaw
         PDNuejtBEMxSq3WSL9xgpwld6p4bcPF1S4/y/JrBG97AkG2o9nzeM7eZwSgKbGQLjnmy
         qfMs0pKbLp2OmLTNKzEA8JlV250UZLM3+MCc4J5DnXqGXVvhYtyF2n/aubsxIvxGQu7d
         ZHGOD7jy5lgz55yN+MtTbzt8unb3LaD0xNLLPDYuz3ZKZC9pj0UhlXd5jr7PG596df+D
         waPnL9oR/Bm6AT2mbuJRtYB+xSpkgcxMP43heLuJzlto04cK785ft2v2BHCMEm1V9tXB
         4Z0A==
X-Forwarded-Encrypted: i=1; AJvYcCXYniGctniTAAYAhegDekTT2X4vqQ0z9oQs+WmIgcAz/+pNV0M6S1xWKtXOEgf1Lph2Nds=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyadd+tl94r2qMwPPXLdRxFnZbX64oX2k812TDPuwA1g80fC3YW
	M5qMOoFLFSHCyZytvQIKSk0uSsfij3bmI5Ntpg8BankY3XzDdXXOh4IqgWoC57BXlNfsTlK78QD
	nNuHZBg==
X-Received: from pfiu8.prod.google.com ([2002:a05:6a00:1248:b0:7cf:2dad:ff87])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6088:b0:81f:997e:59a0
 with SMTP id d2e1a72fcca58-823692fd850mr7473991b3a.64.1769649390925; Wed, 28
 Jan 2026 17:16:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:05 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-34-seanjc@google.com>
Subject: [RFC PATCH v5 33/45] KVM: TDX: Hoist tdx_sept_remove_private_spte()
 above set_private_spte()
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69484-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8FD8EAAAB2
X-Rspamd-Action: no action

Move tdx_sept_remove_private_spte() (and its tdx_track() helper) above
tdx_sept_set_private_spte() in anticipation of routing all non-atomic
S-EPT writes (with the exception of reclaiming non-leaf pages) through
the "set" API.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 194 ++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 97 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e451acdb0978..0f3d27699a3d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1670,6 +1670,52 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * Ensure shared and private EPTs to be flushed on all vCPUs.
+ * tdh_mem_track() is the only caller that increases TD epoch. An increase in
+ * the TD epoch (e.g., to value "N + 1") is successful only if no vCPUs are
+ * running in guest mode with the value "N - 1".
+ *
+ * A successful execution of tdh_mem_track() ensures that vCPUs can only run in
+ * guest mode with TD epoch value "N" if no TD exit occurs after the TD epoch
+ * being increased to "N + 1".
+ *
+ * Kicking off all vCPUs after that further results in no vCPUs can run in guest
+ * mode with TD epoch value "N", which unblocks the next tdh_mem_track() (e.g.
+ * to increase TD epoch to "N + 2").
+ *
+ * TDX module will flush EPT on the next TD enter and make vCPUs to run in
+ * guest mode with TD epoch value "N + 1".
+ *
+ * kvm_make_all_cpus_request() guarantees all vCPUs are out of guest mode by
+ * waiting empty IPI handler ack_kick().
+ *
+ * No action is required to the vCPUs being kicked off since the kicking off
+ * occurs certainly after TD epoch increment and before the next
+ * tdh_mem_track().
+ */
+static void tdx_track(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
+		return;
+
+	/*
+	 * The full sequence of TDH.MEM.TRACK and forcing vCPUs out of guest
+	 * mode must be serialized, as TDH.MEM.TRACK will fail if the previous
+	 * tracking epoch hasn't completed.
+	 */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	err = tdh_do_no_vcpus(tdh_mem_track, kvm, &kvm_tdx->td);
+	TDX_BUG_ON(err, TDH_MEM_TRACK, kvm);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+}
+
 static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
 					     u64 new_spte, enum pg_level level)
 {
@@ -1705,6 +1751,57 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					 enum pg_level level, u64 mirror_spte)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	/*
+	 * HKID is released after all private pages have been removed, and set
+	 * before any might be populated. Warn if zapping is attempted when
+	 * there can't be anything populated in the private EPT.
+	 */
+	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return;
+
+	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
+			      level, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
+		return;
+
+	/*
+	 * TDX requires TLB tracking before dropping private page.  Do
+	 * it here, although it is also done later.
+	 */
+	tdx_track(kvm);
+
+	/*
+	 * When zapping private page, write lock is held. So no race condition
+	 * with other vcpu sept operation.
+	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
+	 */
+	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
+			      level, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
+		return;
+
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn, level);
+	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
+		return;
+
+	__tdx_quirk_reset_page(pfn, level);
+	tdx_pamt_put(pfn, level);
+}
+
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				     u64 new_spte, enum pg_level level)
 {
@@ -1756,52 +1853,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	return ret;
 }
 
-/*
- * Ensure shared and private EPTs to be flushed on all vCPUs.
- * tdh_mem_track() is the only caller that increases TD epoch. An increase in
- * the TD epoch (e.g., to value "N + 1") is successful only if no vCPUs are
- * running in guest mode with the value "N - 1".
- *
- * A successful execution of tdh_mem_track() ensures that vCPUs can only run in
- * guest mode with TD epoch value "N" if no TD exit occurs after the TD epoch
- * being increased to "N + 1".
- *
- * Kicking off all vCPUs after that further results in no vCPUs can run in guest
- * mode with TD epoch value "N", which unblocks the next tdh_mem_track() (e.g.
- * to increase TD epoch to "N + 2").
- *
- * TDX module will flush EPT on the next TD enter and make vCPUs to run in
- * guest mode with TD epoch value "N + 1".
- *
- * kvm_make_all_cpus_request() guarantees all vCPUs are out of guest mode by
- * waiting empty IPI handler ack_kick().
- *
- * No action is required to the vCPUs being kicked off since the kicking off
- * occurs certainly after TD epoch increment and before the next
- * tdh_mem_track().
- */
-static void tdx_track(struct kvm *kvm)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	u64 err;
-
-	/* If TD isn't finalized, it's before any vcpu running. */
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
-		return;
-
-	/*
-	 * The full sequence of TDH.MEM.TRACK and forcing vCPUs out of guest
-	 * mode must be serialized, as TDH.MEM.TRACK will fail if the previous
-	 * tracking epoch hasn't completed.
-	 */
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	err = tdh_do_no_vcpus(tdh_mem_track, kvm, &kvm_tdx->td);
-	TDX_BUG_ON(err, TDH_MEM_TRACK, kvm);
-
-	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
-}
-
 static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 					struct kvm_mmu_page *sp)
 {
@@ -1824,57 +1875,6 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 		sp->external_spt = NULL;
 }
 
-static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					 enum pg_level level, u64 mirror_spte)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
-	gpa_t gpa = gfn_to_gpa(gfn);
-	u64 err, entry, level_state;
-
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return;
-
-	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
-			      level, &entry, &level_state);
-	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
-		return;
-
-	/*
-	 * TDX requires TLB tracking before dropping private page.  Do
-	 * it here, although it is also done later.
-	 */
-	tdx_track(kvm);
-
-	/*
-	 * When zapping private page, write lock is held. So no race condition
-	 * with other vcpu sept operation.
-	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
-	 */
-	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
-			      level, &entry, &level_state);
-	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
-		return;
-
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn, level);
-	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
-		return;
-
-	__tdx_quirk_reset_page(pfn, level);
-	tdx_pamt_put(pfn, level);
-}
-
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector)
 {
-- 
2.53.0.rc1.217.geba53bf80e-goog


