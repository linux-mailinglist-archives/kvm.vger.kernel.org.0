Return-Path: <kvm+bounces-9402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAB585FDB9
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF211C22A42
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6603714F9F6;
	Thu, 22 Feb 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a6lQTrEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E692C153514
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618268; cv=none; b=mq6n8amTJyTmQR1fb71epG/2X+O1lQGkSwzbeueB2kr5w0VUn2Y+v5mdLsw/chrewEZLGd3nXP65ZewHnLZVj46dZDkYJ1OgC6WvVd7O/KOSfmrZUpk7tdZ5RmEIgAz0qMlIEp0ROCImRAyhz8qWj11FTEVmSHZyYmzctcdy+9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618268; c=relaxed/simple;
	bh=thrcBYxJpIov0ueUkK9xUJVnk7mGfhkTWP9cDj+zyXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RNQd3XQ6s8LRmSWRRkRRCVotGyzvH+7VOJU1Gc2AasxIAq66OX5OPPdcSebnLh/ybZHO/7A4ZVh6z3eUHiAfrnJwLsgd1d+pfusTpOoOYPscbvpmmnmTv/DDoW2aFrjSnKaof7TbaQWRPOtZma4NASKzvYJntJDUwqpTMExf/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a6lQTrEo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40d62d3ae0cso10480875e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618265; x=1709223065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/cR/Yk//cCpUcqF45wtqjPoccwRQ5dc9zhX4CLbSuaM=;
        b=a6lQTrEoUZOBjENoZF+khYzYfNaoGfmae+1qbTolk/pcqCr4vcsRg/EJ8DJ6kpbm/Y
         H6Tzv0BNeu1yrZxN6WmZcCdEZ/BwrvL9yuw2cJHuD6FLmta0mLBIPyFowT1zajlKd2lj
         bvR3UZfIcmkJ3/I2icmbeCUYqkDVYE5Eojjmv+5FFr3zJ2LNMcAY/bFNmGN7Ptv6mlVU
         idNyJ5ZQoI+qqcghD/cqh9XQ8svjhTORmyzYrNYL+KwNuS7IwGymctRuv6ZyblWpK/mN
         nusPMowTWJag5pa+fOGmuMPAJWFD/i8L0EYLcNprea3xo/mtiYI78zNjFUY3CV3kj3EF
         lnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618265; x=1709223065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cR/Yk//cCpUcqF45wtqjPoccwRQ5dc9zhX4CLbSuaM=;
        b=frj8ijZ4+GycEnDKOVq+923k44yMxIQjJiXgsvgFj/shcIp+9CH/W1XK0k5WL8382K
         ccY8udIjJPA3pd0ZKqwNZ4gtUYDZHPBJmqsC/ypSibLfclBuW9qIi6j3oiTHdtmaKgmc
         D+NObuZ9MptX1+aBkhHrPNn3SYKRiSdBOK0+J+sNtC42Kd/gZou6iH1LQ4oWb+Z9Ga34
         IDgYex3IZ4ilqkiW3BQ4Ktu8+uNkWKp0d+2miDptAXDfAmT0oXO6NRIj5fSkOHAidBO9
         P02TTSCz7k81j4u+ZfzMNCCdR7k2OLdxiz9MVI7S2ETLMHOOCT/BMj+he/jHjF+1X4bL
         MGsQ==
X-Gm-Message-State: AOJu0YymAzWD0Jwx9xdfnSNW9gOGlKXlhORWwy9Nx4HYZWP4Bf+8tWAL
	EttxxwNfDcdNZLvmBBA+dSIBj1U9ZYFkMqT2016LcSjcT8nN51R3+HPx1FPfFUVc82lz2IbH9I6
	vvktTK8fqF/hjOzg0VssPQZYUkTmEHoGlVLA1mf5jFNTApeoItA+m1OL88Vprz4+ink9ImD1PhH
	bEylqAFbN8Tj21aif3vCUaI6E=
X-Google-Smtp-Source: AGHT+IHR+pszL4yvDO1W7/HLWaCbjn0hGceaWyc7avnwPEt4h67Y/r8Z82fKYEdOS79KKYK3ME6EYmrMaw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c2aa:0:b0:411:fa5a:151b with SMTP id
 c10-20020a7bc2aa000000b00411fa5a151bmr112085wmk.1.1708618264912; Thu, 22 Feb
 2024 08:11:04 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:27 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-7-tabba@google.com>
Subject: [RFC PATCH v1 06/26] KVM: Implement kvm_(read|/write)_guest_page for
 private memory slots
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
attempted if the memory is shared with the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 130 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 114 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index adfee6592f6c..f5a0619cb520 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3446,17 +3446,107 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+static int __kvm_read_private_guest_page(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn, void *data, int offset,
+					 int len)
+{
+	u64 pfn;
+	struct page *page;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+	if (kvm_any_range_has_memory_attribute(kvm, gfn, gfn + 1,
+		KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+		r = -EPERM;
+		goto out_unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto out_unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(data, page_address(page) + offset, len);
+	unlock_page(page);
+	kvm_release_pfn_clean(pfn);
+out_unlock:
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
+	u64 pfn;
+	struct page *page;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+	if (kvm_any_range_has_memory_attribute(kvm, gfn, gfn + 1,
+		KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+		r = -EPERM;
+		goto out_unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto out_unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(page_address(page) + offset, data, len);
+	unlock_page(page);
+	kvm_release_pfn_dirty(pfn);
+out_unlock:
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
+	BUG();
+	return -EIO;
+}
+
+static int __kvm_write_private_guest_page(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, const void *data,
+					  int offset, int len)
+{
+	BUG();
+	return -EIO;
+}
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) &&
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
@@ -3466,7 +3556,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3475,7 +3565,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3547,19 +3637,27 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
-	int r;
-	unsigned long addr;
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) &&
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
2.44.0.rc1.240.g4c46232300-goog


