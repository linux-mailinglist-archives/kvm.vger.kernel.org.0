Return-Path: <kvm+bounces-36258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D892BA19529
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 626A33ACC09
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30964214216;
	Wed, 22 Jan 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V1QyOfL4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955862147F3
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559668; cv=none; b=Z9rff00XC4JrOROugkaapHvFKM+AAcPlreyxAPbsZSqSsxpxBaT4EPBu5GrF5sQt/NhojNfBgr5jfaQfC3G6SYFeYiPtkW4Y0toEjW0DKUCEM94yfQrNqYEFGfUlEWOId018JqhHL2NlxXuI9/+coWBT6viT3chNlLHfFjjY+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559668; c=relaxed/simple;
	bh=FsDwrIACdTO2Ca0fJAZSznrHNQJw7b+9sXwyD6/dAzU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fAW+O8fdOlR6NPMqFCHq5QgGUTx1HNcqbW5xtLpFFemweUcbJCvwyLGFHlf/zmOP8O9cmU7x1jQ7EVymzhBlTFiAUFltKou4kfPYHtfOacOU662yIb7rD03pl/jxk0JnqSsw6hkBslR7s6WpqX9fkpZPYmFPmMejxa+D8pjGea8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V1QyOfL4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so38966095e9.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559665; x=1738164465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgc9nfq2iOlwc6s0mq0Zmi5Z5E3sXJP1ktmubqSKFNg=;
        b=V1QyOfL4Elc1NCZljNFQ0ljD1flWoh3L1AgQ/GY1+uNHKCkiUX8AvdJ3KPBHqggjcL
         TFw3aBTRu80x1AQzYCdpf9ll/L3LLeEgEp93ZVPWOgcxg4Hwv3tZLbbivCU34ZamHGmR
         9ipXwuUx7ZGb0+K/iPkgO+6UzzTdKN9MxtFC+ogujY/9cVBd8aU+5r5DlgRsEoTFSmOm
         wdfBstEaJ6FbOGOnaMyHkRXQDumcoRF0/IHayZn+lp39X/H1x3DObsalM/HuPUtnTyLF
         U8o8IJErC5mpIZNWLDixf/oKdip9t934k/6b3hJH7YXw6ihZLkZTGzoyxX+S1uY4JOCM
         Ogdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559665; x=1738164465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgc9nfq2iOlwc6s0mq0Zmi5Z5E3sXJP1ktmubqSKFNg=;
        b=X9y4Y2IVkpR7F73nNxWLlyI5SBSS6G4diJw+S22kar37NHTKAfuTqTAp96dJdaCR0f
         7eIZ57iiKdErsPL15EI/BkCxxlDL4iDuBP38WniGyppBckwKDhoB6QCmfQ1vYbAnNZiL
         is85g0d+T3dM21s420a4Kr2UZ9rftZdTvqNPhm9t6IcMYAzvuk77tQN3gxw8lzvVMIw9
         bT84j0W9cHWDbML/RJsX7/Ap/TR5Q93n+URuCFULLVKgwBkjev4NsZvQt86p99nUBO4O
         VZxk5t+DNGHCWCkZ2MPM2ap5Tzyydk4usZsA7CIAwDvGwZnCD+12SwBKtcGQ3e+Tv1/j
         2LGQ==
X-Gm-Message-State: AOJu0YymrwWZ3GYrK827N/FYJBiZGyoAZlavHmpdf7jTUs2qDs0k3Nq0
	NgI6Y5N/lawy/7o3EXjQtkBEZODdaSo0WPmxqGbqSj6a9JLtm4xdAm+IP5aL2VTDoitFE+nBAj2
	ZsuAyOyVkdzgbDtAkamLZxyDXZlXdtWjxz2UrWzjLT4gctWoXU9nJ5pS8zSp7SWLlyzWS4CSdTd
	XnOqpyfQYGjxfXc5zJrqH8g8Y=
X-Google-Smtp-Source: AGHT+IHEkzSzLwVsFu5ntmtLdr5cJ4QHwoT2gxzzZv4Yr44awgwt7PF8ZqHc/3pFw4mwJzLSVOUAJ9pbQg==
X-Received: from wmof18.prod.google.com ([2002:a05:600c:44d2:b0:438:af71:5fbb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310a:b0:434:f335:855
 with SMTP id 5b1f17b1804b1-43891440ab1mr187994315e9.28.1737559664727; Wed, 22
 Jan 2025 07:27:44 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:31 +0000
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-3-tabba@google.com>
Subject: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Make kvm_(read|/write)_guest_page() capable of accessing guest
memory for slots that don't have a userspace address, but only if
the memory is mappable, which also indicates that it is
accessible by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 118 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 99 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..ad9802012a3f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3094,21 +3094,93 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
-/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+static int __kvm_read_guest_memfd_page(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, void *data, int offset,
+				       int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	r = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, NULL);
+	if (r)
+		return r;
+
+	memcpy(data, page_address(page) + offset, len);
+	kvm_release_page_clean(page);
+
+	return r;
+}
+
+static int __kvm_write_guest_memfd_page(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn, const void *data,
+					int offset, int len)
 {
+	struct page *page;
+	u64 pfn;
 	int r;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	r = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, NULL);
+	if (r)
+		return r;
+
+	memcpy(page_address(page) + offset, data, len);
+	kvm_release_page_dirty(page);
+
+	return r;
+}
+#else
+static int __kvm_read_guest_memfd_page(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, void *data, int offset,
+				       int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+
+static int __kvm_write_guest_memfd_page(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn, const void *data,
+					int offset, int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+#endif /* CONFIG_KVM_GMEM_MAPPABLE */
+
+/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
+{
 	unsigned long addr;
 
 	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
 		return -EFAULT;
 
+	if (kvm_arch_private_mem_inplace(kvm) &&
+	    kvm_slot_can_be_private(slot) &&
+	    !slot->userspace_addr) {
+		return __kvm_read_guest_memfd_page(kvm, slot, gfn, data,
+						   offset, len);
+	}
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
+	if (__copy_from_user(data, (void __user *)addr + offset, len))
 		return -EFAULT;
 	return 0;
 }
@@ -3118,7 +3190,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3127,7 +3199,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3204,22 +3276,30 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
-				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const void *data, int offset, int len)
 {
-	int r;
-	unsigned long addr;
-
 	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
 		return -EFAULT;
 
-	addr = gfn_to_hva_memslot(memslot, gfn);
-	if (kvm_is_error_hva(addr))
-		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
-		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (kvm_arch_private_mem_inplace(kvm) &&
+	    kvm_slot_can_be_private(slot) &&
+	    !slot->userspace_addr) {
+		int r = __kvm_write_guest_memfd_page(kvm, slot, gfn, data,
+						     offset, len);
+
+		if (r)
+			return r;
+	} else {
+		unsigned long addr = gfn_to_hva_memslot(slot, gfn);
+
+		if (kvm_is_error_hva(addr))
+			return -EFAULT;
+		if (__copy_to_user((void __user *)addr + offset, data, len))
+			return -EFAULT;
+	}
+
+	mark_page_dirty_in_slot(kvm, slot, gfn);
 	return 0;
 }
 
-- 
2.48.0.rc2.279.g1de40edade-goog


