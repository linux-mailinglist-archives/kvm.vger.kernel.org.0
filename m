Return-Path: <kvm+bounces-46362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8FDAB5A15
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21DB84A7764
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA152BFC98;
	Tue, 13 May 2025 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yYMQlnwc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5942BF99E
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154100; cv=none; b=i29JP4Xv9mS/DK591xcaq/sI9rVy3vhTmnvXW6jyG3nmGkDMcErRmE7v2gxYLEVl7ziDuuKkoC01aXLaaskyonhTvwSsoUap+LXx5LH/ajs0bqcdYvEB02x4jXsdu5F3LkFfP5um/fx0nX35Zw734XvodzTOREBSFoe5dto74ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154100; c=relaxed/simple;
	bh=TOeeaoQ3m+/LWMfhhlCsyU/JnOcJqolOnfYg+C9z+4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=af2vosUMMAIZlP9QxYbcqkEUg2udWmvXKet86QQZYJFsYx1KIB6o+TRLY/GJFuyp3ih2tpbgwZ2FDz6uGQVrgP0ges7ie/hXAfoKCGU9uu0B8MpnailFoVuJqKzYwjaL1qO43oZL9SsUu8d5GJM74Sgtwt5mvqgI7SPhizhqMXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yYMQlnwc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so26854335e9.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154097; x=1747758897; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sUPX/y9AGDBrl/3DZ/v5doAtXHf0jW3cIL5MwdsoRE0=;
        b=yYMQlnwcg4byULaa1kPujReOlMiiU2kX/9lZzsha1kLoWTLp8G13NhGTCCTsvmV1n+
         p5Ubo5aHAZl0Fmaog5VRldaxU3QvFkVnSpPpXJRAl7ifVvSHBe2rHcQJZ36OdEKkJUXT
         vog9YCwWvpDXmnyhRiLSxt8bfcnOiwk1AWmGBE45dmWbyz4RouOaSGHpNfJMXiOP3D6M
         gwvFXePpQo01/kIs3LxhPSc+CcWzjEWJ6IaUT/GuedET/3ksoUYOVvpbm2fPKYtqIFej
         J/B3hg6xOHdwcTIbyN23FkFsIBEmuk3CeSrEIpwNP/kFp8wdj4r8bIIxiORD7JuSzqf7
         H0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154097; x=1747758897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUPX/y9AGDBrl/3DZ/v5doAtXHf0jW3cIL5MwdsoRE0=;
        b=byjqUP1DDlUEPe9gC5ODgMLSxNSGoTchUC/w/fG01uYYkCz/3Vr+IGuuMXvzpE2tTF
         dHFHqpkwfJhYO0VRcHbotADR3lFuYuyMcZBp8ustGMitw0UDF+iu4qtZ03LIbOgEwtI+
         uhBf8woVmkgMPS+yGLbSPu/EO8Eh/m2yg7nC6lPLOZzQdmD1N1MVKn0Prw3F5pWhhuVk
         MjNJ/klkaQhyCZlUch2Glh4XUpnk+5xZAjhlOPjpuNz8WR0TnHdMI5GH9vpXzHKZe7uz
         xb/vig5ldSrE6/SdHAv1EyZDbt4Vx1+bu3v8fOHchGWQq7oDz6wXOF45B+03MJyVXZ52
         kphA==
X-Gm-Message-State: AOJu0Yy+VdciQGHFEp9LAmXc1RMT6DqShibU1ZUz3CxFdDZa8zzMIpdj
	3vO4bTACh9K2fcGtoO5+6fzt87/HHhIC3eTQRRB2k9UX5qaMfuPPr2jaHDGgLumOvCDI8rRD8Q8
	W/UONrmeHJR+CWfcC16KCMdNwr6Au1TLJFRd11KR02HZ6HfTEo8Zl1z6fPJIKd/11JFPD1af5K1
	zaobc5veYbYtAeH0+HiiuvpVI=
X-Google-Smtp-Source: AGHT+IHPBFphMwR0/rLp+gySy0dxBabpKT4zkEgWC/5U+nwhKCMIpmmhaC+Hj2shZb3rzwt63hBboV4t6w==
X-Received: from wmbep21.prod.google.com ([2002:a05:600c:8415:b0:440:5e01:286b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:37cd:b0:43c:e6d1:efe7
 with SMTP id 5b1f17b1804b1-442d6dd21e9mr126542875e9.26.1747154097178; Tue, 13
 May 2025 09:34:57 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:29 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-9-tabba@google.com>
Subject: [PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and
 fd+offset refer to same range
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

On binding of a guest_memfd with a memslot, check that the slot's
userspace_addr and the requested fd and offset refer to the same memory
range.

This check is best-effort: nothing prevents userspace from later mapping
other memory to the same provided in slot->userspace_addr and breaking
guest operation.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8e6d1866b55e..2f499021df66 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -556,6 +556,32 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
+static bool kvm_gmem_is_same_range(struct kvm *kvm,
+				   struct kvm_memory_slot *slot,
+				   struct file *file, loff_t offset)
+{
+	struct mm_struct *mm = kvm->mm;
+	loff_t userspace_addr_offset;
+	struct vm_area_struct *vma;
+	bool ret = false;
+
+	mmap_read_lock(mm);
+
+	vma = vma_lookup(mm, slot->userspace_addr);
+	if (!vma)
+		goto out;
+
+	if (vma->vm_file != file)
+		goto out;
+
+	userspace_addr_offset = slot->userspace_addr - vma->vm_start;
+	ret = userspace_addr_offset + (vma->vm_pgoff << PAGE_SHIFT) == offset;
+out:
+	mmap_read_unlock(mm);
+
+	return ret;
+}
+
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset)
 {
@@ -585,9 +611,14 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	    offset + size > i_size_read(inode))
 		goto err;
 
-	if (kvm_gmem_supports_shared(inode) &&
-	    !kvm_arch_vm_supports_gmem_shared_mem(kvm))
-		goto err;
+	if (kvm_gmem_supports_shared(inode)) {
+		if (!kvm_arch_vm_supports_gmem_shared_mem(kvm))
+			goto err;
+
+		if (slot->userspace_addr &&
+		    !kvm_gmem_is_same_range(kvm, slot, file, offset))
+			goto err;
+	}
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-- 
2.49.0.1045.g170613ef41-goog


