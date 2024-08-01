Return-Path: <kvm+bounces-22902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9487A944750
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A8D62845D4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0712A170A07;
	Thu,  1 Aug 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CEIuKSS9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FBD170836
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502890; cv=none; b=REg5oSiOyv7mk11WZ5ytSf6dDmZhsyI1Le55rbfUftidlAo9iuPRFY5l6lsj7givt/9nvlQ9tBk9gMUVpJ5y8i44EBjYSzTRe/zHWzPtOWHbKQd2BJY/IMSGwvett9IRhJQXjLDrQ92Jxr8cJ+OtWVIkcsOcmi0dM9yvl7yHdZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502890; c=relaxed/simple;
	bh=du2XpGvCSw1HscL0jxNXXaB3NWH5Lr5MM3GWCqX9g5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GWcg1G3A0cNQ82aUG3UE3Z24nVfeI/oqIMdMInz2XkKXcxiSUtF/ngbNWz+6882Zj2VoHd3HBEGDNvI2H/UQ1vIIHr1cnhwaLT2Xt8nwmamHC74vUsUXajiQK9G5b1wwiWY9G2PYBXY6I0hBiSHjxU91pzlRsWnWY0jzjUclgmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CEIuKSS9; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-650ab31aabdso114815647b3.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502888; x=1723107688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r2dA+/WuAip0LraCdE4saiE0NevgxBDmZ5s6G2UnSY8=;
        b=CEIuKSS92SxTAJccsTwblBOXYtblC/JFSSK9bGt/luHJJqKX+N3o538RnfzUfVhjrx
         sdqr4X5EO1+caszz/fGNHKxZxpjaJq8yu0u2Q3CPWSnaikJD2wwIIpQ4sYxL8fvlTAQC
         JD2MLllq+Q6O38DxF144fgJWTor9SOObl5wxO7i+QHPl4CcTzmHqJf9UiX+V9furY/1U
         kxwaZvXWT6JaTbCoVo5ZhWaQmWtOG0WpjIg+Eq5CLjxeGfdcmSzgFUoYov+FIouQHKlA
         XVoYXN9/SuuUwN0doQJ/xd3Jmw4AAcmR4oD0w7onX3+hO+QhKPkuQH9aAx1mBSERyUDV
         5QDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502888; x=1723107688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r2dA+/WuAip0LraCdE4saiE0NevgxBDmZ5s6G2UnSY8=;
        b=kI7o3EzRH5zJjmcG1V01OLImtB530hfx2vdw3Bs+uolJu84+C6fwgHLRQaQQNoF6D3
         tqQZfgnAmAL1E8wrIq5/3izf2ELdPvhieUX7wTqjfrqByZVOd+fQTxp1bSNAdJzPtTt5
         DRDjRhbqWxI7FHBcXIXUvEoYrz08VujoV4wWSKR1oyM5dBWV6uKe4hmpFm/B+LLWJkGI
         9jNUBZ0DxP1uQcxi1n83PS4uD3o521tbVtHUz+e8n5ggOEkA7FwMmbmObsVImlF6vFJV
         YNw0EQS1+ILRyInhWTpzBFninn5DRaargyrfwF5uP/vSg6Z9tPq2T0fOG7dIn0+HN+3h
         BKPA==
X-Gm-Message-State: AOJu0Yw0kRQpNHbQbCPyJm6kgNmuPIuv7nhgCGSfq+hP8ZLsJHQqm45L
	zLZTSjw8Y+xA81QOC/AkfrW5OchTxUsbga/CtN/eaNLCAjHB1I0NegH2jPaBotT+WHyC6mmFeWf
	to/WLNiJj7bBRd8ubBsGJ6XVOPd69Jo0oQyJKDtTT7/n/f76CV5ykrILvm4HTIxlzeEsG2vnf+3
	1qTmbsQdFnfkbnKgWwovDYqJY=
X-Google-Smtp-Source: AGHT+IFTyhbnlkMzi/3eqbxm5qXZ73AAT9ul7/e/eVlxOdal7iBxLuY+Lba4cs8t3PeL8JTir4ZyTcDElQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:9e:b0:673:b39a:92ce with SMTP id
 00721157ae682-6874be4e4b8mr30147b3.3.1722502887498; Thu, 01 Aug 2024 02:01:27
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:10 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-4-tabba@google.com>
Subject: [RFC PATCH v2 03/10] KVM: Implement kvm_(read|/write)_guest_page for
 private memory slots
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Make __kvm_read_guest_page/__kvm_write_guest_page capable of
accessing guest memory if no userspace address is available.
Moreover, check that the memory being accessed is shared with the
host before attempting the access.

KVM at the host might need to access shared memory that is not
mapped in the host userspace but is in fact shared with the host,
e.g., when accounting for stolen time. This allows the access
without relying on the slot's userspace_addr being set.

This does not circumvent protection, since the access is only
attempted if the memory is mappable by the host, which implies
shareability.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 127 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 111 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f4b4498d4de6..ec6255c7325e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3385,20 +3385,108 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
 	return kvm_gmem_toggle_mappable(kvm, start, end, false);
 }
 
+static int __kvm_read_private_guest_page(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn, void *data, int offset,
+					 int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+
+	if (!__kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(data, page_address(page) + offset, len);
+	unlock_page(page);
+	kvm_release_pfn_clean(pfn);
+unlock:
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static int __kvm_write_private_guest_page(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, const void *data,
+					  int offset, int len)
+{
+	struct page *page;
+	u64 pfn;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+
+	if (!__kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
+		r = -EPERM;
+		goto unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(page_address(page) + offset, data, len);
+	unlock_page(page);
+	kvm_release_pfn_dirty(pfn);
+unlock:
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+#else
+static int __kvm_read_private_guest_page(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn, void *data, int offset,
+					 int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+
+static int __kvm_write_private_guest_page(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, const void *data,
+					  int offset, int len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
 
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
+	if (IS_ENABLED(CONFIG_KVM_PRIVATE_MEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(slot)) {
+		return __kvm_read_private_guest_page(kvm, slot, gfn, data,
+						     offset, len);
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
@@ -3408,7 +3496,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3417,7 +3505,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3492,17 +3580,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
-	int r;
-	unsigned long addr;
+	if (IS_ENABLED(CONFIG_KVM_PRIVATE_MEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(memslot)) {
+		int r = __kvm_write_private_guest_page(kvm, memslot, gfn, data,
+						       offset, len);
+
+		if (r)
+			return r;
+	} else {
+		unsigned long addr = gfn_to_hva_memslot(memslot, gfn);
+
+		if (kvm_is_error_hva(addr))
+			return -EFAULT;
+		if (__copy_to_user((void __user *)addr + offset, data, len))
+			return -EFAULT;
+	}
 
-	addr = gfn_to_hva_memslot(memslot, gfn);
-	if (kvm_is_error_hva(addr))
-		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
-		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog


