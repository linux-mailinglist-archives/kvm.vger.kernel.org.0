Return-Path: <kvm+bounces-69920-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sK1OCN8lgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69920-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:31:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4844ED2308
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7E1503013FE9
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12D83559DD;
	Mon,  2 Feb 2026 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuCmKHRD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34318387357
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071433; cv=none; b=VTgO8qLvSTlI8karyjV1YpekDndpl3P3pw6qYmeOo/lwtOGLf2yJ/tT3z7jiSeuduqf/YjOsqgelEWCjZEi0ey1p3hDhmkXs1f2Ep1rGyZmdzIaUrSJoADoU/MZIYMNPsZNG0ujdfkXL0t3epEoabJ11ozhxqfhLPatDMfyiSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071433; c=relaxed/simple;
	bh=d2H1BGE6RHVhxhflqbuW01HyLaMUDiiIGpBz3uzgI5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VMgdWaC6EJiwNnRMghXExUYXuFgbefXaOP0qqxnNc1TU8nsjm7PyRCUxOVR1Q+Gl4/SmdNUgl1rduPjr16DXZlYdWSTOjLvqF8r0Dv9ML/Zz+8sx9MFWh5sU/8Zct+2gIIAFDSldIp1FqzH0Kcwouyila/lwJL4K6wLIqUeISdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuCmKHRD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b62da7602a0so3220237a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071431; x=1770676231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CMAiEssV4YeURzqIHB2H0raKyM96PK0rO+9805+zuX8=;
        b=yuCmKHRDEPX9LUHasILyky4EC9s8LixIM02H03cfMQhcy1pQ7VoeGzY7EfCgh+pe+V
         llptJmCVr/pVGvpZmdMw1Gdr5JUVI5qwpPCHXvwFqzHzPa8bW+ex7NqkQU1gJI/yvZwV
         ejSO0omamtRL2rxHPXf305CR/x1UdwQYM2+6vXHHxQ8jGdTldZ4ETVUYrjgVdHNeIa4b
         YB+8wD1nhtCbsOi4ASBVCNTMEIVdBL120YAz4JyJDQFZgzegabHEEDu5DF136WFp2qK1
         2cuficdJh7vGeydGZyjZ1qUMrA8Ol/tUO7ooSQGpNDBmn7kxhlFgkSUI/ulhXGujhHWa
         sJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071431; x=1770676231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CMAiEssV4YeURzqIHB2H0raKyM96PK0rO+9805+zuX8=;
        b=fxyPz5lvKUTve7TmKP42KA8n/e2lUMCZuR9nk1ExzoleCz00SQB1R2F0YtgQVf1HHW
         Zz2sl83La3kCnKpE0/IpyOXahmT9VEBm8nyNbqy3oDWMxSSgX8GdAV3WC9uzSjkjLwMz
         mguPO3E9xN0PwemO/5ZzScV4V2WmNzrTTTWFDQ++c7sK+vTKTkg+mBAkIL/74C0JBHpL
         c00cdlzHwsbYxrS/F/RRi+tMeNjmeugnn21LVaeou9U8YSgDNvqBAOSyhpeON5zJNLJq
         Wg+hOMscPkqpIZ6WEXTOJKoTm+Uy9AdCt7U/VDRvnBtcPs+Ek4gT9b4IIuYmvUGfITDg
         YBHg==
X-Gm-Message-State: AOJu0YzsAsSHJPju29ijnh1TwoLFdxWLlrvLq+LsoIIFzm6e/nLtrDuX
	LjbQmTWEI6eK1ryNTe/kYw64iK4mwy1tyGxGPbBd9S/JsGria13lLLtk3aUrA4Rx6DCBl5HiEo4
	mzKTJcWAvVpvL6IRKdxvvrOGYHe7tyePZzKnzoEN2kPiPUrUyZH5Gj9knJp4hLE++MbRXSS38u8
	vEGTpmad84iMso4Bb/4haayVtSekTOGu254tiKPB7WBO76eO9gLdWv+QVTNzI=
X-Received: from pgyy67.prod.google.com ([2002:a63:3246:0:b0:bac:a20:5ee6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:4c7:b0:35f:b96d:af11 with SMTP id adf61e73a8af0-392dffe0de8mr13077873637.5.1770071430884;
 Mon, 02 Feb 2026 14:30:30 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:43 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <47a301ce76440b7edaab517449487c95cd48f43f.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 05/37] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69920-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4844ED2308
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
core and architecture code to query per-GFN memory attributes.

kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
queries the guest_memfd file's to determine if the page is marked as
private.

If vm_memory_attributes is not enabled, there is no shared/private tracking
at the VM level. Install the guest_memfd implementation as long as
guest_memfd is enabled to give guest_memfd a chance to respond on
attributes.

guest_memfd should look up attributes regardless of whether this memslot is
gmem-only since attributes are now tracked by gmem regardless of whether
mmap() is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 37 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 42 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e7920a0f957..c12ee89392d8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2544,6 +2544,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7a970e5fab67..810fec394075 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -515,6 +515,43 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct inode *inode;
+	unsigned long attrs;
+
+	/*
+	 * If this gfn has no associated memslot, there's no chance of the gfn
+	 * being backed by private memory, since guest_memfd must be used for
+	 * private memory, and guest_memfd must be associated with some memslot.
+	 */
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return 0;
+
+	inode = file_inode(file);
+
+	/*
+	 * Acquire the filemap lock to ensure the mtree lookup gets a
+	 * stable result.  The caller _must_ still protect consumption
+	 * of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
+	 * against ongoing attribute updates.  Acquiring the filemap
+	 * lock only ensures a stable _lookup_, the result can become
+	 * stale as soon as the lock is dropped.
+	 */
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	attrs = kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	return attrs;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_get_memory_attributes);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4dc9fd941ecb..5d06e2c74ae7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2676,6 +2676,9 @@ static void kvm_init_memory_attributes(void)
 	if (vm_memory_attributes)
 		static_call_update(__kvm_get_memory_attributes,
 				   kvm_get_vm_memory_attributes);
+	else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_gmem_get_memory_attributes);
 	else
 		static_call_update(__kvm_get_memory_attributes,
 				   (void *)__static_call_return0);
-- 
2.53.0.rc1.225.gd81095ad13-goog


