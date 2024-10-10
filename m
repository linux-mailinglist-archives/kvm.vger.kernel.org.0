Return-Path: <kvm+bounces-28398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4457F998160
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65D541C21174
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB891C6893;
	Thu, 10 Oct 2024 08:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VwZXtI5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE801C57BE
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550789; cv=none; b=W57jGP8PLFoQl3Y/SmBVH2milnttq1pCcQupzXLGWn1h5V7yBsTqK+PNlOSuGCPnxsgR9lPBiTHFs19zv2rUYtgSmBIs7l/tL1NCvm32uZqsKhZI0bUMVq/I//2PoscwHJg57scIdzus2l2lumLyACwubE7eOPmap39FC0G5Pfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550789; c=relaxed/simple;
	bh=mYaVJvOvzfMQ+zKlTPpie9EoVyIYwwMO4jC1tA91HVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ErbyF0xhUdGfF97Wo3J9bECoEQilRVCJI5j6EafpVkGzLUkQuL6ttYWR9NHbNFLNJhPF05t0ELoIa1Zj9wUb5C//xg+2zxptPhhP74NQiGI6UT81ZE8KQ0jpSOfAvwp3S6g3iK6JEPGoIMWS5H1X0GVvrKSHDY6OzbhsgCtS3Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VwZXtI5M; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e28d223794so13503197b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550787; x=1729155587; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8uqb2Hq7+/kapW0F00vPZqAJ1bU0uvb9gYwuhhY1Sds=;
        b=VwZXtI5MkJcm262Y7vbjZoJ0yfMC3ozcH8osf8PCA6jGRDvOVKipB+QBG9gGzJ8Uk4
         uALZDBHeb1Eau7vQgcPH5NsgEehzqjn37p/uCrvgPP75HF+gPkKwUr7E4gnKwzDjXoqH
         BjFnPqkes8FQH/QEMFI4GIOu19GlpeHf/01ReVqythoqDCncSYAefVRNAdfsMcC3KkHI
         TK7GTod84r+KQtONlskWbBD/mCDlEyXRTp4E0GP/kWfjatboxpgPZWnEyvc8FMoZ8Bz4
         1jod8b9jLZP0NwvLV4EuDPoLyTa697oCvteWceMyXhsc96UCiwPKRjeamykUc3iBv+tc
         lpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550787; x=1729155587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8uqb2Hq7+/kapW0F00vPZqAJ1bU0uvb9gYwuhhY1Sds=;
        b=w9JVau6FdOFWqRAKMfaGZ5vSZ59GnEpTi7o+bJnMc4HuxlBBOuXrWsgjeoJaOE+/J8
         0KjsEcOjGhHMm6JNatBdYU+ub/k5tvfk/aJe9iADcdrhBplDvCN9Ct3pW5STj5PJGHpO
         +0Ay1Qavfi0fNjmYnoPE9Wk59LiijFnXLEifxT6TzSbPFggrye12OjZiyaPLz4G5TLlG
         vmZGz/n2lCWDOl04F4OjvKKa9eGdRV5PT2BL/UZe8qJLrEIDmTt9vuHXt5HXGbQ4AgUj
         jJAU2FNtLNv1dGz31dD6GBsXiw+KRJj6fy89xr6BfUkRHKXU5iuEdfLzz7mhHsXWFvyK
         /tjw==
X-Gm-Message-State: AOJu0YzFIVrYyu9rDKTBfXodChQrJou67JNNDJ6H6g27ZarZ67D34UKD
	1h6uOoukpJYeqp42gA9qqc3SzT4+XEgXyxA3mH8FYIBEHOTtUje2fhQiYJdGYIDfyKDX3k51hiC
	dvXrtgiuGBtRXaLWuXWWIHYPlmxBphK7dbtltC1/x4jp/7mTwo9ELFh61pK0yjUVGHjVv690ZK/
	5Iv8Uky34X2kZVqptQg4rdPfk=
X-Google-Smtp-Source: AGHT+IG7SQRbRuMfYH/Rui+CBChrEOHfesWWRZDd/p/7xcfBTKh/y+cfP2FSghBgXkgmmW6X7QZVv1DCpQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:b545:0:b0:6e2:19f3:ff75 with SMTP id
 00721157ae682-6e3221a89dbmr187767b3.6.1728550785757; Thu, 10 Oct 2024
 01:59:45 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:24 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-6-tabba@google.com>
Subject: [PATCH v3 05/11] KVM: guest_memfd: Add guest_memfd support to kvm_(read|/write)_guest_page()
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
 virt/kvm/kvm_main.c | 137 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 118 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aed9cf2f1685..77e6412034b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3399,23 +3399,114 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
 	return kvm_gmem_toggle_mappable(kvm, start, end, false);
 }
 
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
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		return r;
+
+	page = pfn_to_page(pfn);
+
+	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+	memcpy(data, page_address(page) + offset, len);
+unlock:
+	if (r)
+		put_page(page);
+	else
+		kvm_release_pfn_clean(pfn);
+	unlock_page(page);
+
+	return r;
+}
+
+static int __kvm_write_guest_memfd_page(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn, const void *data,
+					int offset, int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		return r;
+
+	page = pfn_to_page(pfn);
+
+	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+	memcpy(page_address(page) + offset, data, len);
+unlock:
+	if (r)
+		put_page(page);
+	else
+		kvm_release_pfn_dirty(pfn);
+	unlock_page(page);
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
 #endif /* CONFIG_KVM_GMEM_MAPPABLE */
 
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
 	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
 		return -EFAULT;
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
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
@@ -3425,7 +3516,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3434,7 +3525,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3511,22 +3602,30 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
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
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
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
2.47.0.rc0.187.ge670bccf7e-goog


