Return-Path: <kvm+bounces-69486-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAg7Kzu2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69486-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B55AAA3A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E7699302FE69
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B343E36F41A;
	Thu, 29 Jan 2026 01:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4pjbbzou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4666636A016
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649396; cv=none; b=WQSmT+ADdjSpSBCL7yV9SxS7UH03i2QNqeGaNkYPZho7m7cyOGWsKLNV7h+cZ9jQmDuqrViHI+HmPz0WtqNRtZ0OxG1YRkHyP37dHrja6WrVw1n8nZNVt2cp5leVEuDOfu+0bKp+4M5BO2htWHZFslfaJYtAnZkzpaTHzcK4Ht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649396; c=relaxed/simple;
	bh=kJQ9hFNF5ygDouQFKIpQgR+27T82l54AJAavRy375H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=geOQMpulhIpBXVGDGKCJn1R0Fp6FXDPfhKCjVVX+LfBuQ8DaWgHzk2XRaBscTTx6AxcMnOGJz3D1SwgzHiCsiPiQlLBwiyB4LLYL/UvfF10h7XWN4r/Q6MNrl/WM/PD9BNDMU1BvZxQ9bK4TidXcNfsp4i/+S9F00gRfAsapcOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4pjbbzou; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a76b0673dcso3864475ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649394; x=1770254194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hk2OrgovQOMb8nY4yl86VZzMpQRRHhLb7boChViJO8g=;
        b=4pjbbzouSAHOfeCMbJTJQjatZ6ebS4fVvg3et4OTAM6aOvrTt+ZH/yy9ulQrRRyCBQ
         ot7I4xF2zR72+Hahb/2TMcjfvulGbfAWlDmvfZwoE+OYAaVQ39yRunyzd4SbNDPHos24
         Vhca8yDkjahNkN39jhk40Fz53W3XGS0qKYQs2Jcz7ujyzC4KZZA0eeKT2ZbvNMSTvKDT
         i3SHsKQOt+4MlLY6do7IjNJzOZ4Jxl6tZz65v/BY9OTpyDAcIT6MWmri24MccQvvPDKS
         eCrpcmToZr799m0bAmva+rt0OSFspkk7tyIYInxgxNjyxTZCHjUxnA+sICfr4kf5GdOy
         D2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649394; x=1770254194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hk2OrgovQOMb8nY4yl86VZzMpQRRHhLb7boChViJO8g=;
        b=CM05E7WyQdyztS/CYsdTdLUamdU1UlNGVLJwP6i2ZKD+RHKaiJ0TI3iM5rCyLU3pDJ
         yZY2aZMIyK8+q5qiKlMDx2ZdqJG4aZeHqkYIKnQKlgmn4Elpike7mpJPYVbpJHJh4RCR
         tExAwBT+VttX5Pxj7DJ77xISMKDdiezokZF7rxwjeHT6Yu6tjFVSC/APJVYptSRaMdBc
         JYPGOgAK7ThYa9yAebH+d/nnEXQNLdoZoGnepofQYeaQxQDZ4szEXCNRzuwdAf5hLrJn
         xUnSRsqCA1+0d9jq2RgRSw94MqLBbrtG0j526QD8DnRjB6Ke6nHJxLSHMzlu1u3vYz75
         TIcw==
X-Forwarded-Encrypted: i=1; AJvYcCVQyzsIWaKTxcSYL03+DIZyyDkbx06L5Yg99efOcaKFF6OZHi8Ospxa4MorFqdjXsWZ/DE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE9yUPXKGbnt4CpLH+26V1cezrOqnUvADo2nvH4XYtKqD9KcPo
	qNik7803KS1kO6rp18E5SjaswMBNr+WkiR8WoKsoVC5C1uxJBm0yke6XttrQhdG7BUv4pMbe5Z+
	OwpzwkA==
X-Received: from plqu6.prod.google.com ([2002:a17:902:a606:b0:2a7:cf29:aee1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8cd:b0:2a7:a653:5203
 with SMTP id d9443c01a7336-2a870de43ccmr68752745ad.27.1769649394405; Wed, 28
 Jan 2026 17:16:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:07 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-36-seanjc@google.com>
Subject: [RFC PATCH v5 35/45] KVM: TDX: Add helper to handle mapping leaf SPTE
 into S-EPT
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
	TAGGED_FROM(0.00)[bounces-69486-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 52B55AAA3A
X-Rspamd-Action: no action

Add a helper, tdx_sept_map_leaf_spte(), to wrap and isolate PAGE.ADD and
PAGE.AUG operations, and thus complete tdx_sept_set_private_spte()'s
transition into a "dispatch" routine for setting/writing S-EPT entries.

Opportunistically tweak the prototypes for tdx_sept_remove_private_spte()
and tdx_sept_link_private_spt() to align with tdx_sept_set_private_spte()
and tdx_sept_map_leaf_spte().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 97 ++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9f7789c5f0a7..e6ac4aca8114 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1670,6 +1670,50 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_map_leaf_spte(struct kvm *kvm, gfn_t gfn, u64 new_spte,
+				  enum pg_level level)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	kvm_pfn_t pfn = spte_to_pfn(new_spte);
+	int ret;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EIO;
+
+	if (KVM_BUG_ON(!vcpu, kvm))
+		return -EINVAL;
+
+	WARN_ON_ONCE((new_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
+
+	ret = tdx_pamt_get(pfn, level, &to_tdx(vcpu)->pamt_cache);
+	if (ret)
+		return ret;
+
+	/*
+	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
+	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
+	 * arbitrary memory until the initial memory image is finalized.  Pairs
+	 * with the smp_wmb() in tdx_td_finalize().
+	 */
+	smp_rmb();
+
+	/*
+	 * If the TD isn't finalized/runnable, then userspace is initializing
+	 * the VM image via KVM_TDX_INIT_MEM_REGION; ADD the page to the TD.
+	 */
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		ret = tdx_mem_page_aug(kvm, gfn, level, pfn);
+	else
+		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
+
+	if (ret)
+		tdx_pamt_put(pfn, level);
+
+	return ret;
+}
+
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
  * tdh_mem_track() is the only caller that increases TD epoch. An increase in
@@ -1729,14 +1773,14 @@ static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
 	return virt_to_page(sp->external_spt);
 }
 
-static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, u64 mirror_spte)
+static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn, u64 new_spte,
+				     enum pg_level level)
 {
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	struct page *external_spt;
 
-	external_spt = tdx_spte_to_external_spt(kvm, gfn, mirror_spte, level);
+	external_spt = tdx_spte_to_external_spt(kvm, gfn, new_spte, level);
 	if (!external_spt)
 		return -EIO;
 
@@ -1752,7 +1796,7 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 }
 
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					enum pg_level level, u64 old_spte)
+					u64 old_spte, enum pg_level level)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	kvm_pfn_t pfn = spte_to_pfn(old_spte);
@@ -1806,55 +1850,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				     u64 new_spte, enum pg_level level)
 {
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	kvm_pfn_t pfn = spte_to_pfn(new_spte);
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	int ret;
-
 	if (is_shadow_present_pte(old_spte))
-		return tdx_sept_remove_private_spte(kvm, gfn, level, old_spte);
-
-	if (KVM_BUG_ON(!vcpu, kvm))
-		return -EINVAL;
+		return tdx_sept_remove_private_spte(kvm, gfn, old_spte, level);
 
 	if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
 		return -EIO;
 
 	if (!is_last_spte(new_spte, level))
-		return tdx_sept_link_private_spt(kvm, gfn, level, new_spte);
+		return tdx_sept_link_private_spt(kvm, gfn, new_spte, level);
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
-
-	WARN_ON_ONCE((new_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
-
-	ret = tdx_pamt_get(pfn, level, &tdx->pamt_cache);
-	if (ret)
-		return ret;
-
-	/*
-	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
-	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
-	 * arbitrary memory until the initial memory image is finalized.  Pairs
-	 * with the smp_wmb() in tdx_td_finalize().
-	 */
-	smp_rmb();
-
-	/*
-	 * If the TD isn't finalized/runnable, then userspace is initializing
-	 * the VM image via KVM_TDX_INIT_MEM_REGION; ADD the page to the TD.
-	 */
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		ret = tdx_mem_page_aug(kvm, gfn, level, pfn);
-	else
-		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
-
-	if (ret)
-		tdx_pamt_put(pfn, level);
-
-	return ret;
+	return tdx_sept_map_leaf_spte(kvm, gfn, new_spte, level);
 }
 
 static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
-- 
2.53.0.rc1.217.geba53bf80e-goog


