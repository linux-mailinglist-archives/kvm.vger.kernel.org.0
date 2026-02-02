Return-Path: <kvm+bounces-69921-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGOGCMUlgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69921-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:31:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0834BD22EF
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3689C3015CBD
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5653835503F;
	Mon,  2 Feb 2026 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WqdtwWsE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B602D388861
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071435; cv=none; b=WDEHfdnGHaHFfDF/vhNvHdkqpbL+RuKyVkJO1ttk7CPt5iDnmchAmyWrsv6SPAtFr3Sym0Snv57+B/82dp5a5yZmEKQ6R1hC2itBkgLc0Tvk+/MqtamvAC6jxbgrTunR1kAO8G3nC7SSBxonBp3ON1LP8/d5nvzLRDEVgS99vr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071435; c=relaxed/simple;
	bh=StGda4ieY4psoFjGEjNVxjWetznThow3xU6gh+iSGPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EfumpFEr5460C99BWpU7abkiRfSHoBtLO1zkkKtFfIsF1vVE5X1bDrNIMbzc3w1WcnhWVDz0FmT/PJ+oRRF1W/7uTse1rljYFwZsiXm4qUqpaL3QTgOTUduQ1Qazba9bSEJlZeZJFfQ7aL4LWiqYrz4hdTgW453jADGYu9useGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WqdtwWsE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so44614575ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071433; x=1770676233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GUwm2ObTXkw7wnNZ+8gnB1/G5SqZq1H7l6JvFOK25Us=;
        b=WqdtwWsE/VyYKr8te6sExVIwxbnHxVCYX91Z43WLiwGGQjh84i89Pj46F+wXTM9+tF
         M4l9V56sZzGKpkp09kBcJYpgQii37mfpOfrOYitVa1qjPOrVhXFFdSb+gjovoXLJf1re
         qKVW0SgIiJORCm2u1Z5PgYhNtxVwTPQM9HVAe2YEpnPTPQhsCl8/Tsh54BfmuQmqKS1x
         jtCNsYUdDteUXQMsCOLOS0U6D9S6eVyM7gfMSL6PSe9FmVjUq/RUMM+R7+DaBIKlc+GT
         m+DcNIwpF2IjC760tK4Vos69LnB2sk8UQFoq4RSf3elJpwrB0yb826WFevEmIjDQi55m
         Txfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071433; x=1770676233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GUwm2ObTXkw7wnNZ+8gnB1/G5SqZq1H7l6JvFOK25Us=;
        b=O1tVc0PEOnoxSKgDUHf1CA4oN1CUXb2xeRvf2eN1N3/ThOdI39Rgrtu/DE6aOOCqVv
         mDvfswqBDtDktg2F93aNX/R/wv37i4zg50SaETSXp69BG+uRSITuY0HbFmqlr/8eNxh6
         ymIICTBXQV4mA261A1AyopnbmaA7CYvuWYx6iH+AawIL4baFc9gBuJnj2i4OohbVCguu
         pU/i0/TpZnzZfy2XRn8rELBhYgO2d+JHVDkxfBcXBkr9LxnaPzeq6Ex/izsgt4A6d8fI
         rE/6jXkw9g2te8gC3KDPMAGBlIEbR1tTnbF9i9p6myaCrmJ1PPMbUgPZOkuA1oTN3QM1
         XL4A==
X-Gm-Message-State: AOJu0YzL3Eh8XYR6y+nBQ1+XdK/mxrf02vqLUVhjXQN1bximOhuKHh5W
	MPL51dcIS17PTnogcLFBUX8H1ni6gJhbxtDeHmsCdfkRLQ4ZAA0F0fSAeHptuHVkl/9Ko1QWv6N
	wyPAuClYCNU/5XLc4ECxLrjrvJAUf6fs9M9UrZjOyrsgHPgB4GzTC2qr2ZUB5WYPn7xdOEmNCez
	aN2r1FyPK8yV3uLzcckV3nXNsLjVHxgz8QIxPn/KQ3OV1LCkRMP8BKu4//Srs=
X-Received: from plqu12.prod.google.com ([2002:a17:902:a60c:b0:2a0:7f81:6066])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:166e:b0:2a0:e223:f6e6 with SMTP id d9443c01a7336-2a8d8177fc0mr121846735ad.46.1770071432436;
 Mon, 02 Feb 2026 14:30:32 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:44 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <b3559feb3c828ded3e58f46956ec78dd98a72132.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 06/37] KVM: guest_memfd: Update kvm_gmem_populate() to
 use gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69921-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0834BD22EF
X-Rspamd-Action: no action

Update the guest_memfd populate() flow to pull memory attributes from the
gmem instance instead of the VM when KVM is not configured to track
shared/private status in the VM.

Rename the per-VM API to make it clear that it retrieves per-VM
attributes, i.e. is not suitable for use outside of flows that are
specific to generic per-VM attributes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h | 14 +++++++++++++-
 virt/kvm/guest_memfd.c   | 26 +++++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  8 +++-----
 4 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c7de8ff84fd2..25ab6b8901e2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7979,7 +7979,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c12ee89392d8..8f1e10a503f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2536,12 +2536,24 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif
 
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+extern bool vm_memory_attributes;
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
+#else
+#define vm_memory_attributes false
+static inline bool kvm_range_has_vm_memory_attributes(struct kvm *kvm,
+						      gfn_t start, gfn_t end,
+						      unsigned long mask,
+						      unsigned long attrs)
+{
+	WARN_ONCE(1, "Unexpected call to kvm_range_has_vm_memory_attributes()");
+
+	return false;
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 810fec394075..6b3477b226ad 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -934,10 +934,30 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
+				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	if (vm_memory_attributes)
+		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+	mt_for_each(&gi->attributes, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
+	struct gmem_inode *gi;
 	void __user *p;
 
 	int ret = 0, max_order;
@@ -956,6 +976,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
+	gi = GMEM_I(file_inode(file));
+
 	filemap_invalidate_lock(file->f_mapping);
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
@@ -989,9 +1011,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		while (!kvm_gmem_range_is_private(gi, index, 1 << max_order, kvm, gfn)) {
 			if (!max_order)
 				goto put_folio_and_exit;
 			max_order--;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5d06e2c74ae7..666d1f7fbf07 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,9 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
-static bool vm_memory_attributes = true;
-#else
-#define vm_memory_attributes false
+bool vm_memory_attributes = true;
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
@@ -2473,7 +2471,7 @@ static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
@@ -2607,7 +2605,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range has the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
-- 
2.53.0.rc1.225.gd81095ad13-goog


