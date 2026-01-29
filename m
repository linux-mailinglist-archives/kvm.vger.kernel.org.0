Return-Path: <kvm+bounces-69496-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EPiHh+4emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69496-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:30:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D589FAAC54
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73712311631A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1D9378D68;
	Thu, 29 Jan 2026 01:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K8V+kZo+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D534214F
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649414; cv=none; b=pzW3U3nB7RDXsFHVUANWb6BOG+znWtc68BoJeX+hp571ZviR9Wkq0sWy+P1HMK6eLwf8IeGSWz57+DO4atPVDE4PjcJBrluBVP2Krmnb6cKegu1KbJCg+V1Ote9ex79Q+GCsNE0umAndYwBlfm/FuNOSdEjQ8asbXz2IOX4y264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649414; c=relaxed/simple;
	bh=JnLQOFtJ/wcAZWGRwiicTI8EBue9TzM7THLWcXx2/5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EY0peQImxEm1a2n5DV82nEyupxhLCjMhvGhS/s1vMYejtG9bXC6cV78DcQ9laE5cFlasvce9h44IRl9egnCCtZ3j5GUHmlHJpk4YBmZ59WS0WAjyzZJx8OzMnIM+q4vWiGxuPMKWzj2WVRG/CVphKQwzw08rE5aG/K97KH6t3VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K8V+kZo+; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630753cc38so815525a12.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649412; x=1770254212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MGU/mVdsXAmMeHXzQ8R+PnC312tm74tZ14i8PtfNv9E=;
        b=K8V+kZo+TCVkDJzTLsTmgYIc7tz7wyCoh6EcyGfaBOY+9b/Z7/iHaf3w01KXRSQRpf
         Shseces7G//MR4nt20BJt3DZoWf5xLyOmCjZn3KZsOePxY/BsORImdw+NZjIDIIEMejq
         14FrrykW2WzI/U2GDr6syGanp3OibllPjExDTRJos2u58xPulnMIPMrC/NDuqMhEWdUo
         NvcF7nbZq9rKU5PjweCmmLn7L907p3mRB77qLOjKuk/ycZXpzw7tr0fFfqS3/kJOitTt
         qnL/8ph7Qr14czngGOE4K2oVZ5wVGWwoDPw0wcEaOuPS8WNOKlQWoMrkT1EuLEbONn7X
         2j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649412; x=1770254212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MGU/mVdsXAmMeHXzQ8R+PnC312tm74tZ14i8PtfNv9E=;
        b=JKOTxx5S69gabt0HyAKLGF/SI7foeGLdyNP9rTxKnam7rw9SCztTfcJrDMVaiFAczX
         yLu+UgSAD/ZoQuw5QHGoDjrQ7GeCXY36wybd3omEbpFFCqZJ0XIWLaZRcS6/3Qc2BTtW
         4P+f8ugKpolh+ueFkwqDWzBohXuoiRa6iKVNtnkSALUCMiefLBO3eRQ9iz5to1CwNLLm
         HepFCS1cl0MgbLAIuoN+88peXi4bq3Sp2zxW3Xcj5IQK3rqJaO90PDfF/GlbtJ4QdnP9
         OeCPDYLkvZw4dr3G2cRfyHH6NU8Ma+6BdWJD1TwMrnZySGgueP/cLLIJ4nRysLs5YNJm
         6lnA==
X-Forwarded-Encrypted: i=1; AJvYcCU9CG7wbPacuPWG45VhzSSRxgr6/se3gbm6CjFtgV0cSkDwdm9jcOxSI2z4mrf9FbvKCu4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3aA+3b2JtVFGo6sV5I04VHCimFAGp2xNx8sqEPfuFcXPf0ZXK
	bbQyHJJZGrNt4a8T0nY091ozkc64GsvZBgQINYR7KTtqjWMLjYl7gpUSTCmY7lhzH9mVHVoUmu6
	sJMmfvQ==
X-Received: from pjbkb4.prod.google.com ([2002:a17:90a:e7c4:b0:352:c130:fba7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258e:b0:35d:d477:a7fa
 with SMTP id adf61e73a8af0-38ec63390f2mr6964703637.23.1769649411949; Wed, 28
 Jan 2026 17:16:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:17 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-46-seanjc@google.com>
Subject: [RFC PATCH v5 45/45] KVM: TDX: Turn on PG_LEVEL_2M
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69496-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D589FAAC54
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

Turn on PG_LEVEL_2M in tdx_gmem_private_max_mapping_level() when TDX huge
page is enabled and TD is RUNNABLE.

Introduce a module parameter named "tdx_huge_page" for kvm-intel.ko to
enable/disable TDX huge page. Turn TDX huge page off if the TDX module does
not support TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY.

Force page size to 4KB during TD build time to simplify code design, since
- tdh_mem_page_add() only adds private pages at 4KB.
- The amount of initial memory pages is usually limited (e.g. ~4MB in a
  typical linux TD).

Update the warnings and KVM_BUG_ON() info to match the conditions when 2MB
mappings are permitted.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 774d395e5c73..8f9b4ad9871f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -55,6 +55,8 @@
 
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
+static bool __read_mostly enable_tdx_huge_page = true;
+module_param_named(tdx_huge_page, enable_tdx_huge_page, bool, 0444);
 
 #define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
 #define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
@@ -1703,8 +1705,9 @@ static int tdx_sept_map_leaf_spte(struct kvm *kvm, gfn_t gfn, u64 new_spte,
 	kvm_pfn_t pfn = spte_to_pfn(new_spte);
 	int ret;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+	/* TODO: Support hugepages when building the initial TD image. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K &&
+		       to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE, kvm))
 		return -EIO;
 
 	if (KVM_BUG_ON(!vcpu, kvm))
@@ -1885,10 +1888,6 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EIO;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
-
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
 			      level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
@@ -3474,12 +3473,34 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
+/*
+ * For private pages:
+ *
+ * Force KVM to map at 4KB level when !enable_tdx_huge_page (e.g., due to
+ * incompatible TDX module) or before TD state is RUNNABLE.
+ *
+ * Always allow KVM to map at 2MB level in other cases, though KVM may still map
+ * the page at 4KB (i.e., passing in PG_LEVEL_4K to AUG) due to
+ * (1) the backend folio is 4KB,
+ * (2) disallow_lpage restrictions:
+ *     - mixed private/shared pages in the 2MB range
+ *     - level misalignment due to slot base_gfn, slot size, and ugfn
+ *     - guest_inhibit bit set due to guest's 4KB accept level
+ * (3) page merging is disallowed (e.g., when part of a 2MB range has been
+ *     mapped at 4KB level during TD build time).
+ */
 int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	if (!is_private)
 		return 0;
 
-	return PG_LEVEL_4K;
+	if (!enable_tdx_huge_page)
+		return PG_LEVEL_4K;
+
+	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
+		return PG_LEVEL_4K;
+
+	return PG_LEVEL_2M;
 }
 
 static int tdx_online_cpu(unsigned int cpu)
@@ -3665,6 +3686,8 @@ static int __init __tdx_bringup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
 		goto get_sysinfo_err;
 
+	if (enable_tdx_huge_page && !tdx_supports_demote_nointerrupt(tdx_sysinfo))
+		enable_tdx_huge_page = false;
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
-- 
2.53.0.rc1.217.geba53bf80e-goog


