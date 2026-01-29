Return-Path: <kvm+bounces-69492-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMkeHQ63emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69492-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C656AAAB19
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8063A3109883
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3637326D62;
	Thu, 29 Jan 2026 01:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfW/qArN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE13783D2
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649407; cv=none; b=d7iWj18/kB2ZJtIouAsLbJB00/ctjYAUueDYcZITVLAGYm4AXxCWr/XgRoe9p6BD35y47TERD9vr/5heFgXhcps8bkr95+EuHfvAIHprCZcPvo/Xo4RBpBiICK0SPRBq6CVSNjPfj+F/RA+Ju7lMZRID035Z73F5m8+LKbWKU54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649407; c=relaxed/simple;
	bh=eGA1sGsrL5gQvVxX2B8XhLkR/dJNKRXiCDxyhvAgE7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cfn82+G6zTIHTJBDvrldkpW9KIcjQkluowke13bQJj2nBQB4Qrjc5SznGtg+Q4pdCJQc52WDZhA1IqV+wriVqrOke8XTarJZfgMpkya0YSOKVa4QY4qk1Wf7MZI0MfJsk8u19ehRdzUp0U485CQTVIdga1Is+84jRKU0l8mzJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfW/qArN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso723497a91.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649405; x=1770254205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V7Fouq+dvqn1XG8w3rkoPxCMRgeF52r64rWaA84oL2w=;
        b=kfW/qArNm57/4auvntJyZjb6Ea5Ffjjg19LJwwL8z1Cxk0XTB2s2VYDwQ6kJ6az5Rs
         UlSuw1HBgldTJDfN+/cSDe6hRvNpKgqol5tpa5x5De0uTXUfGxBPNb+wOhlwf+rw7u1Q
         1T2wZg2heNs504loTN0pe9R6fKJ9HpA7VbvADvy64QPyCUXs2WzVoXc363pwKsFa5DG9
         m1RXGq5iOJoG9w7U4+t0blreplQrBlM0IV8LuLxBWhXbppu1wYfvAb6E0zkUmOS9TkrW
         GMt6XFJsctZ2cayWqC/Rml0fdxPbJIzuhh+vFdbLg1IiF7Xa9Pqs8JNCzLswZfa5/L4D
         SPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649405; x=1770254205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V7Fouq+dvqn1XG8w3rkoPxCMRgeF52r64rWaA84oL2w=;
        b=G2cA90u0eyLU+jknKu0NVOdLiQujSSmE/39+NS0meQ4h+eegzSnrRSb6kopXj+SN7d
         tbly3FjKFU0ae05Da9qODIdAJyouvg1Daushu7IosCEmasF3IixlPsfHrQwJLYaIISaU
         N4+XGuehHIobsG6/fLhZf59B7/b+z6TCVcxSM/hAAbe5qkF9GDMlDYtc6nXE+Z6WsKGv
         LF/XZKv799Fq8DMVKLLQm9cL1MMTFGRjSxc8x72Wne13cGFl/PYja6Np0Se0RVYMnQdd
         cPZFh5DptVim/4KQtzU/WxWaPYg33WlwGIdJvHnqY/nyIIHRUudWqSiKMDBrJ2jv3XVL
         EB9w==
X-Forwarded-Encrypted: i=1; AJvYcCVqxYquyFhp+MPnKCn+f6R4f4r+e3kDc90/cmsaAwJncre07lr6bJKFHvFyq5qdaHoFlc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUINX1ZsqamptHbwQUrVz+whdfBc0P5hhMjEEDfOSzpiSgTJ/u
	HF4/VSpLkFAMqUvTYJrjz8DcXUEO8VuIIqDs6awteoY2ME2a31/d5spGHFOYATQt+U1TfvC5dQg
	do9s9ew==
X-Received: from pjwo16.prod.google.com ([2002:a17:90a:d250:b0:34c:84ee:67c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d02:b0:340:d569:d295
 with SMTP id 98e67ed59e1d1-353fed5cad0mr6510840a91.24.1769649404957; Wed, 28
 Jan 2026 17:16:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:13 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-42-seanjc@google.com>
Subject: [RFC PATCH v5 41/45] KVM: TDX: Honor the guest's accept level
 contained in an EPT violation
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69492-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C656AAAB19
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

TDX requires guests to accept S-EPT mappings created by the host KVM. Due
to the current implementation of the TDX module, if a guest accepts a GFN
at a lower level after KVM maps it at a higher level, the TDX module will
synthesize an EPT Violation VM-Exit to KVM instead of returning a size
mismatch error to the guest. If KVM fails to perform page splitting in the
EPT Violation handler, the guest's ACCEPT operation will be triggered
again upon re-entering the guest, causing a repeated EPT Violation VM-Exit.

To ensure forward progress, honor the guest's accept level if an EPT
Violation VMExit contains guest accept level (the TDX-Module provides the
level when synthesizing a VM-Exit in response to a failed guest ACCEPT).

(1) Set the guest inhibit bit in the lpage info to prevent KVM's MMU
    from mapping at a higher level than the guest's accept level.

(2) Split any existing mapping higher than the guest's accept level.

For now, take mmu_lock for write across the entire operation to keep things
simple.  This can/will be revisited when the TDX-Module adds support for
NON-BLOCKING-RESIZE, at which point KVM can split the hugepage without
needing to handle UNBLOCK failure if the DEMOTE fails.

To avoid unnecessarily contending mmu_lock, check if the inhibit flag is
already set before acquiring mmu_lock, e.g. so that a vCPUs doing ACCEPT
on a region of memory aren't completely serialized.  Note, this relies on
(a) setting the inhibit after performing the split, and (b) never clearing
the flag, e.g. to avoid false positives and potentially triggering the
zero-step mitigation.

Note: EPT Violation VM-Exits without the guest's accept level are *never*
caused by the guest's ACCEPT operation, but are instead occur if the guest
accesses of memory before said memory is accepted.  Since KVM can't obtain
the guest accept level info from such EPT Violations (the ACCEPT operation
hasn't occurred yet), KVM may still map at a higher level than the later
guest's ACCEPT level.

So, the typical guest/KVM interaction flow is:
- If guest accesses private memory without first accepting it,
  (like non-Linux guests):
  1. Guest accesses a private memory.
  2. KVM finds it can map the GFN at 2MB. So, AUG at 2MB.
  3. Guest accepts the GFN at 4KB.
  4. KVM receives an EPT violation with eeq_type of ACCEPT + 4KB level.
  5. KVM splits the 2MB mapping.
  6. Guest accepts successfully and accesses the page.

- If guest first accepts private memory before accessing it,
  (like Linux guests):
  1. Guest accepts a private memory at 4KB.
  2. KVM receives an EPT violation with eeq_type of ACCEPT + 4KB level.
  3. KVM AUG at 4KB.
  4. Guest accepts successfully and accesses the page.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c  | 11 ++++++
 arch/x86/kvm/mmu/tdp_mmu.h  |  2 +
 arch/x86/kvm/vmx/tdx.c      | 76 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h |  3 ++
 4 files changed, 92 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e32034bfca5a..0cdc6782e508 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1619,6 +1619,17 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
+/* Split huge pages for the current root. */
+int kvm_tdp_mmu_split_huge_pages(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
+				 int target_level)
+{
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+
+	return tdp_mmu_split_huge_pages_root(vcpu->kvm, root, start, end,
+					     target_level, false);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_split_huge_pages);
+
 static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bd62977c9199..cdb0b4ecaa37 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -97,6 +97,8 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
+int kvm_tdp_mmu_split_huge_pages(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
+				 int target_level);
 
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index af63364c8713..098954f5e07c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,7 @@
 #include "tdx.h"
 #include "vmx.h"
 #include "mmu/spte.h"
+#include "mmu/tdp_mmu.h"
 #include "common.h"
 #include "posted_intr.h"
 #include "irq.h"
@@ -1958,6 +1959,77 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 }
 
+static bool tdx_is_mismatched_accepted(struct kvm_vcpu *vcpu)
+{
+	return (to_tdx(vcpu)->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK) ==
+	       TDX_EXT_EXIT_QUAL_TYPE_ACCEPT;
+}
+
+static int tdx_get_ept_violation_level(struct kvm_vcpu *vcpu)
+{
+	u64 ext_exit_qual = to_tdx(vcpu)->ext_exit_qualification;
+
+	return (((ext_exit_qual & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
+		 TDX_EXT_EXIT_QUAL_INFO_SHIFT) & GENMASK(2, 0)) + 1;
+}
+
+/*
+ * An EPT violation can be either due to the guest's ACCEPT operation or
+ * due to the guest's access of memory before the guest accepts the
+ * memory.
+ *
+ * Type TDX_EXT_EXIT_QUAL_TYPE_ACCEPT in the extended exit qualification
+ * identifies the former case, which must also contain a valid guest
+ * accept level.
+ *
+ * For the former case, honor guest's accept level by setting guest inhibit bit
+ * on levels above the guest accept level and split the existing mapping for the
+ * faulting GFN if it's with a higher level than the guest accept level.
+ *
+ * Do nothing if the EPT violation is due to the latter case. KVM will map the
+ * GFN without considering the guest's accept level (unless the guest inhibit
+ * bit is already set).
+ */
+static int tdx_handle_mismatched_accept(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t start, end;
+	int level, r;
+
+	if (!slot || !tdx_is_mismatched_accepted(vcpu))
+		return 0;
+
+	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
+		return 0;
+
+	level = tdx_get_ept_violation_level(vcpu);
+	if (level > PG_LEVEL_2M)
+		return 0;
+
+	if (hugepage_test_guest_inhibit(slot, gfn, level + 1))
+		return 0;
+
+	guard(write_lock)(&kvm->mmu_lock);
+
+	start = gfn_round_for_level(gfn, level);
+	end = start + KVM_PAGES_PER_HPAGE(level);
+
+	r = kvm_tdp_mmu_split_huge_pages(vcpu, start, end, level);
+	if (r)
+		return r;
+
+	/*
+	 * No TLB flush is required, as the "BLOCK + TRACK + kick off vCPUs"
+	 * sequence required by the TDX-Module includes a TLB flush.
+	 */
+	hugepage_set_guest_inhibit(slot, gfn, level + 1);
+	if (level == PG_LEVEL_4K)
+		hugepage_set_guest_inhibit(slot, gfn, level + 2);
+
+	return 0;
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
@@ -1983,6 +2055,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
 
+		ret = tdx_handle_mismatched_accept(vcpu, gpa_to_gfn(gpa));
+		if (ret)
+			return ret;
+
 		/* Only private GPA triggers zero-step mitigation */
 		local_retry = true;
 	} else {
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a30e880849e3..af006a73ee05 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -82,7 +82,10 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
 #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
 #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
+#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
+#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.53.0.rc1.217.geba53bf80e-goog


