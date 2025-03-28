Return-Path: <kvm+bounces-42181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B0BA74DD6
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2CA83B63AC
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A691DB92E;
	Fri, 28 Mar 2025 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FL12P20F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A051DA11B
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175909; cv=none; b=l9bJfTid2hE6bPWPiFeANyRsM3pf40WBzpPDWI1+cL45/0kkzYYcE6Vn/vzwBMgfrEtqYB2uRP1re+FsJ15sxtd3NWNsc1zX/DXxw48JYRkSH/X/ZgmCgFg7u8lKgLj1g2w6GeJKe1+IWDIuBp8ByMN3yco5EUKQsC+oush7u/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175909; c=relaxed/simple;
	bh=ywIBAiOIC5j43YjmiU9xRCcK2knCGG5rRQ+rKgEbt1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cc5XvyfFKisZWGfOcy2ixeS68GTfwBO8H88xGD7LhefmJmLVCQXBOfs2Q/xdH5lQbMiDX+zF8yqQzSexQNVpa9jGLRaE80xtl5qY+XrmGYJplyo9fgsCGvwMvo+dfnVl+r4ZNSq74hHaoGuzfouEXSKsguuwtX2u5JYYQhUbTpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FL12P20F; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so14195625e9.3
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 08:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743175907; x=1743780707; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3RfnojiUTVQNcoqz4Ca2o/3ssUHr85YnTpv1JDxiLk=;
        b=FL12P20F7u8xMJE7WrwcNxU9Z8rGvw4Yqdre3DgDqWwXXApSqQEsW+Ry5YSzqoEgOw
         lk5mqm5i/vwzJPG3Qqw/BkmvJZQIXu7KMbgm6DPkF6+sVFkZh/QkF3OgMWy2NjXEAaTc
         lx7QWxaptoaAraNat7foWWC6YFKLb8QLMBivdQBo5qNi8iKO5wT8EuXuxxYbS/nbV7Ad
         744Ovc/urM3yRLTpsR60FK/gKR4v/9HJqJkVtDvfeZuqCqDwY/kS/qZtIlKjI7G+zazx
         uiW+vjEkZmVhmo8WHq9M1dqjrHf6avT4m3Y8xJlZ1tOJEjOiXYsg7Grgd38BjvDmB+Pl
         zl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743175907; x=1743780707;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3RfnojiUTVQNcoqz4Ca2o/3ssUHr85YnTpv1JDxiLk=;
        b=hvCFaImGo8uBgfs6KANbbu39YbeMpWbHigI9Cu6HoY1JulQC+Rpi9u0lNr9Cx2xRjJ
         UvnilufWZEC/E1xNue9JOl/IbQMeihT6LDxNXx0UwnfhnhDafElusFCQkCowsytg38Ep
         1+Fv8Qag1Ng8ZKsmF4njx0Gy5D9+QWfo9oOBbBmuQaqa78/Gf/sWo8tCofzdMhUefOZZ
         avlqGT/Fo03ghoMLOn3/+UHwbEtfHjUWfUEoqoOK5q+0v21eF7XLuGfp14LQuk94jPEQ
         1ryq9slJuWZnbixRKXyGMLd72Tb1+yQdf9oI/NMsGotNLMKVnt3kCzRs2j+/JWFEkV5i
         28Uw==
X-Gm-Message-State: AOJu0YwU2SMc3byrDbAOFO5XiKW0A+OHXgNA2iK5krNt3Xh84/G+N2RI
	IJcHJoyMIRRdaaZnOIFRuDxmSs6SLlaxncXeS1iYLtN5g7abRzew9mHXOc3ylxy0g3kzYCs/gtE
	v4V/bSxZZm8wUpYFoAc+zvfN+Nd2gwi7aDzEueMi+63dZQXEVwd6/5qs+iADGfzezTlzt494uvw
	CZOz6uf/AqcP299D2oauqYrf0=
X-Google-Smtp-Source: AGHT+IH5o8XkmQE16RpA7JAnMr7kPBXwGpQkyy1fEQJArMIbsDhiWMuAir53k+JzjSmedSowM4jfKUSd+w==
X-Received: from wmbay1.prod.google.com ([2002:a05:600c:1e01:b0:43d:9f1:31a9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e52:b0:43c:fc04:6d34
 with SMTP id 5b1f17b1804b1-43d9489777emr25843765e9.20.1743175906450; Fri, 28
 Mar 2025 08:31:46 -0700 (PDT)
Date: Fri, 28 Mar 2025 15:31:32 +0000
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328153133.3504118-7-tabba@google.com>
Subject: [PATCH v7 6/7] KVM: guest_memfd: Handle invalidation of shared memory
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When guest_memfd backed memory is invalidated, e.g., on punching holes,
releasing, ensure that the sharing states are updated and that any
folios in a transient state are restored to an appropriate state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ce19bd6c2031..eec9d5e09f09 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -118,6 +118,16 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return filemap_grab_folio(inode->i_mapping, index);
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static void kvm_gmem_offset_range_invalidate_shared(struct inode *inode,
+						    pgoff_t start, pgoff_t end);
+#else
+static inline void kvm_gmem_offset_range_invalidate_shared(struct inode *inode,
+							   pgoff_t start, pgoff_t end)
+{
+}
+#endif
+
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 				      pgoff_t end)
 {
@@ -127,6 +137,7 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 	unsigned long index;
 
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		struct file *file = READ_ONCE(slot->gmem.file);
 		pgoff_t pgoff = slot->gmem.pgoff;
 
 		struct kvm_gfn_range gfn_range = {
@@ -146,6 +157,16 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 		}
 
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
+
+		/*
+		 * If this gets called after kvm_gmem_unbind() it means that all
+		 * in-flight operations are gone, and the file has been closed.
+		 */
+		if (file) {
+			kvm_gmem_offset_range_invalidate_shared(file_inode(file),
+								gfn_range.start,
+								gfn_range.end);
+		}
 	}
 
 	if (flush)
@@ -512,6 +533,42 @@ static int kvm_gmem_offset_clear_shared(struct inode *inode, pgoff_t index)
 	return r;
 }
 
+/*
+ * Callback when invalidating memory that is potentially shared.
+ *
+ * Must be called with the offsets_lock write lock held.
+ */
+static void kvm_gmem_offset_range_invalidate_shared(struct inode *inode,
+						    pgoff_t start, pgoff_t end)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	pgoff_t i;
+
+	lockdep_assert_held_write(offsets_lock);
+
+	for (i = start; i < end; i++) {
+		/*
+		 * If the folio is NONE_SHARED, it indicates that it's
+		 * transitioning to private (GUEST_SHARED). Transition it to
+		 * shared (ALL_SHARED) and remove the callback.
+		 */
+		if (xa_to_value(xa_load(shared_offsets, i)) == KVM_GMEM_NONE_SHARED) {
+			struct folio *folio = filemap_lock_folio(inode->i_mapping, i);
+
+			if (!WARN_ON_ONCE(IS_ERR(folio))) {
+				if (folio_test_guestmem(folio))
+					kvm_gmem_restore_pending_folio(folio, inode);
+
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+		}
+
+		xa_erase(shared_offsets, i);
+	}
+}
+
 /*
  * Marks the range [start, end) as not shared with the host. If the host doesn't
  * have any references to a particular folio, then that folio is marked as
-- 
2.49.0.472.ge94155a9ec-goog


