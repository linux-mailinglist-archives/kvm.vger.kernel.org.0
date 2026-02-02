Return-Path: <kvm+bounces-69919-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BuuGk0mgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69919-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:33:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD424D234B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDC4F3088617
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7EB3590D8;
	Mon,  2 Feb 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzVJN2lf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0A7354AC6
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071432; cv=none; b=LZSBWtfEbgkp/ApB/aFiXbccZxYmD7PoM9Ach1yydcROMXqsMa+3elmMdkRntfBjfms9h8lQZrweda/UqVUZI10iVtrOhwQRoF0zYgNeZXmjcQuaBAKfOqvtRgYXnePH3Uu+Fwn4xm5VgYPXtONfWxTuqWu2AMZ90JGUXin37sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071432; c=relaxed/simple;
	bh=LvtzlkA+hb/qIpifK0ohqILrKvBs0un3n44sJCCRAgQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HycxjSe969W8my+FzEnLyTpkYjN13h2oEcQR6V5f7HjlSZuzMBtfgPRpc+Im5rcKDyNPZjzqwsYkowx6Hvxq+svNhxW0prOn6QveU50tCa0F0/MbTjVqTNyPyRPhBNDnZpowT/sQusw4T9rPbCg/0G9zahBqGOhU/aBr0cOGJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzVJN2lf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a784b2234dso137624295ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071429; x=1770676229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGbWwdIBiOiJYoBtJCalXTa4dTPyH8zVecky2rXrjjg=;
        b=uzVJN2lfY/UUHO7iLvVxv8m/954w/d1ewsHMfV3IJnr7pcQBe9ZIUJaxqB5jm59OgD
         NtzD0xQn80ktSyfsb8BLGG6FusKhl/ioaWcL9E+SRDOBowZK0uwDi+NVD2PVf/DhO0aV
         jkNjPs9w1gTGg6HFtaYcQEHwrKsSCOOWVNqZcWh5/aB+SFXjP23rFxlz5DppCNVV2Ce9
         C+XDSSUs3C9zI29DYJEQMem7YIg/XzDV63ak3Zp40nS227rwETkse9lzQGl8lXDG0lgd
         r3Y1qJciNibqvVmj34yQvhuMtYuqhEkGIcMaJBl/6UcZcjplerSUvyF7qlc+Dio/Um3J
         0CCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071429; x=1770676229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGbWwdIBiOiJYoBtJCalXTa4dTPyH8zVecky2rXrjjg=;
        b=QR4VfoV/JMZt4RF/7sTwo6twpPK+4L3jbM1nPOVGh6k0DDVi8pDCZyp1CmcSyWpQUf
         g4gomEjyi1p/i12w4BNRjBJRIxdr9cQwlOFUCyaCve4nh79JbLpC+khlhiz8cGdZcPiL
         W2tp0Q8Nml3c59tqNB1awFYU+ialPmRD2FU0RijIbtQbm9IuAIhI/rz9+iIZ4v2e+ufP
         D6Bl/Q+8WX0Oh71nXPZDe6z6XGGrUNHvyp9bT+bWi53iHrnv9V2QqRP9eDywEnduIsyG
         feQ1G9cUrFdiv7qcu5lBiRdBWzQAeTzelECssZcsZgpslXorLlV7KD5D6gohmcsHaXhc
         vMJg==
X-Gm-Message-State: AOJu0Yym1z8jDXHVYdQcilYxf8J4mbk3DFADYTxl4qTDSIGlMO7z0/CT
	AERjYTIRrGJbRK7xPr62uDh4e2JnmiQbGTMytR8lA1Sh0rXqQQeFT+iYgJyFYJPQL4LMFuhGHCr
	bIlY0tEMkXUZscT0qMcgn+2s4rWNv2LhqjY5baO9lcuYCwg6PLsGlKHv3LO0AOrxtsW4YtK77i8
	jEZzK3Kg7I+lcl96M8EW9R5wmeHngZ93SytQBMRZcq7rwukvUiKZdyasKD5QA=
X-Received: from plbmp6.prod.google.com ([2002:a17:902:fd06:b0:2a8:7338:717c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef08:b0:2a0:8be7:e3db with SMTP id d9443c01a7336-2a8d96c2519mr132437575ad.15.1770071429269;
 Mon, 02 Feb 2026 14:30:29 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:42 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <5c054c407535edb0a3ccd1f2d2c4f72395d66482.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 04/37] KVM: Stub in ability to disable per-VM memory
 attribute tracking
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
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69919-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BD424D234B
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Introduce the basic infrastructure to allow per-VM memory attribute
tracking to be disabled. This will be built-upon in a later patch, where a
module param can disable per-VM memory attribute tracking.

Split the Kconfig option into a base KVM_MEMORY_ATTRIBUTES and the
existing KVM_VM_MEMORY_ATTRIBUTES. The base option provides the core
plumbing, while the latter enables the full per-VM tracking via an xarray
and the associated ioctls.

kvm_get_memory_attributes() now performs a static call that either looks up
kvm->mem_attr_array with CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled, or
just returns 0 otherwise. The static call can be patched depending on
whether per-VM tracking is enabled by the CONFIG.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h        | 23 ++++++++++-------
 virt/kvm/Kconfig                |  6 ++++-
 virt/kvm/kvm_main.c             | 44 ++++++++++++++++++++++++++++++++-
 4 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d427cf9187c3..f8f0de0c367e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2307,7 +2307,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index af2fcfff7692..0e7920a0f957 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2515,19 +2515,15 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
+DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
-	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
-
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
@@ -2537,6 +2533,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
+#endif
+
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long mask, unsigned long attrs);
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range);
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index c12dc19f0a5e..02c4c653bb31 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -105,10 +105,14 @@ config KVM_MMU_LOCKLESS_AGING
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
+config KVM_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
+config KVM_VM_MEMORY_ATTRIBUTES
+       select KVM_MEMORY_ATTRIBUTES
+       bool
+
 config KVM_GUEST_MEMFD
        depends on KVM_GENERIC_MMU_NOTIFIER
        select XARRAY_MULTI
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 26e0d532ba03..4dc9fd941ecb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,6 +102,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static bool vm_memory_attributes = true;
+#else
+#define vm_memory_attributes false
+#endif
+DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -2441,7 +2452,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 #ifdef kvm_arch_has_private_mem
@@ -2452,6 +2463,12 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+}
+
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
@@ -2648,7 +2665,24 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 
 	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
 }
+#else  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	BUILD_BUG_ON(1);
+}
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void)
+{
+	if (vm_memory_attributes)
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_get_vm_memory_attributes);
+	else
+		static_call_update(__kvm_get_memory_attributes,
+				   (void *)__static_call_return0);
+}
+#else  /* CONFIG_KVM_MEMORY_ATTRIBUTES */
+static void kvm_init_memory_attributes(void) { }
+#endif /* CONFIG_KVM_MEMORY_ATTRIBUTES */
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -4947,6 +4981,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
+		if (!vm_memory_attributes)
+			return 0;
+
 		return kvm_supported_mem_attributes(kvm);
 #endif
 #ifdef CONFIG_KVM_GUEST_MEMFD
@@ -5353,6 +5390,10 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_SET_MEMORY_ATTRIBUTES: {
 		struct kvm_memory_attributes attrs;
 
+		r = -ENOTTY;
+		if (!vm_memory_attributes)
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&attrs, argp, sizeof(attrs)))
 			goto out;
@@ -6539,6 +6580,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_memory_attributes();
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-- 
2.53.0.rc1.225.gd81095ad13-goog


