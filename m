Return-Path: <kvm+bounces-41413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F39A8A6793C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E1D1189C34F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBF321147D;
	Tue, 18 Mar 2025 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kTeCcvX9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C0A212D7B
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314863; cv=none; b=H/9aCOuTfIxyQIwquUO7F3gqecfV194Z8C9SJOqUD0Y2vLVMqZLx7FdD/wV4wfm+q+j+Eqa9U6Py5t1WRgmZPGUSARcukKJaz8kEfigG4VevQoNQ+H2/JnIMwJIWFXYXqz7N4HKOOJ/BQi2B470FS/x7So8e8bixGAJNlO6hGAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314863; c=relaxed/simple;
	bh=nukMnpo5hy9oJe7htxSYLAXzKXNYRN9Nkodg1PhI/fU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tc2NoMcMTrHXjYLMlI6QfG0GMDrate4VZ5OjcSAMpgzoxY5l3b/Vm+rTHvKhhUO2/PShmP8018503zPoKgMzvQR0mN0EEBVTROAEd7Wvv1BvmhRgiEj8UXe2PFvYmAfz6w5cvkBWvb1OZH6VbvYJuk9mZunEmTkb4JFoIlMi600=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kTeCcvX9; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d01024089so28539775e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314860; x=1742919660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9KWHi/KBkZHmOxvUg1u2dLw8hruOCqp8/fshelQJPQ=;
        b=kTeCcvX9F0zulynzjuz71s38neWEGV/QOas8kjqCcl8hlPdwMjWMYu6U2HNui60A9d
         asPN6896fjAzN42Tco++6JL1Gcd/4Vt5Dhs/iq4AfApaKdVok5vQ5tVZRb5ZEFQfUd6U
         rDZ2Rhl40Tjcx0CWUs6U6OMLhAH9cO0meoCTCQbj4jTJ4zcH92L1wT2555LR8PPx0D7n
         XeX75K730KzTZTr8UUpND3/E6Y4KUJyZ2mq6quC4lebvyiWJTio05Bq9GdNwL36cOPpo
         i9YpLavnx7GsD8huMBaZFo4YJUN7TTWz5lmZdtxD2Y60LQFj2cDryxPvRevARkmPiijn
         vMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314860; x=1742919660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9KWHi/KBkZHmOxvUg1u2dLw8hruOCqp8/fshelQJPQ=;
        b=rYhchRgoZh7S6LY/gerTjNLB/A/UihCF/y1UHgaRMSDWQXOvxSqtHP+iiQwtyz50vP
         ncGL3p2uoxLgnx+2g71AgrQQNK8lVIQ4vqPTfj4dgoEZPW9r5GRboJvyyhzofJRY3Fr5
         hrETbF+kwTGD3YGH2QT6Zfhhum/4wSNj+9W4+S5AIJpM6VsMVLg5E4zGmHQ+htu86FZc
         Qh9l9Lbf3FSmIs549WhKm0JggsCa4hm+UFDqATLroaZmZi4mf/aXXiCzZuwpIV0ZxDZC
         lIQiMythpwlB/w1992/3kpW1ROgctpn2HioceWDERwqjtxO0ZjIRfb5Zv7pDPwHmXhkW
         sNXA==
X-Gm-Message-State: AOJu0YzZaS5XM96qxSI12XFbuifurgfJzzjmdkhInV3Il3H5ehtYU5c+
	mHqfle1wlrA+cqCqIDMuZvIiPA6d6cabS6N50QXimiTY7uecT/itasdFPWXUijKyOPBuynck4Ma
	KEDMU+Dxq/gYMccyDl4j3+FNVp/ec1L/lhz9jD0GrVquU8AVdOro+LrXkMDB5Vuh/pBedPH9rxr
	Nwc9pddq/7YGW+lpluF7IGAQw=
X-Google-Smtp-Source: AGHT+IEh2X4kUYxpJwUkKLEJgfMN+mg0RefgQxFOkAM1n9rRoUkko5MREaX9qI+5+A7CeT0+SuksFzPCZg==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:43d:4038:9229])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:848d:b0:43d:94:cff0
 with SMTP id 5b1f17b1804b1-43d3b9dc3b0mr24262095e9.19.1742314859735; Tue, 18
 Mar 2025 09:20:59 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:45 +0000
In-Reply-To: <20250318162046.4016367-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-7-tabba@google.com>
Subject: [PATCH v6 6/7] KVM: guest_memfd: Handle invalidation of shared memory
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When guest_memfd backed memory is invalidated, e.g., on punching holes,
releasing, ensure that the sharing states are updated and that any
folios in a transient state are restored to an appropriate state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4fd9e5760503..0487a08615f0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -117,6 +117,16 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
@@ -126,6 +136,7 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 	unsigned long index;
 
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		struct file *file = READ_ONCE(slot->gmem.file);
 		pgoff_t pgoff = slot->gmem.pgoff;
 
 		struct kvm_gfn_range gfn_range = {
@@ -145,6 +156,16 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
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
@@ -509,6 +530,41 @@ static int kvm_gmem_offset_clear_shared(struct inode *inode, pgoff_t index)
 	return r;
 }
 
+/*
+ * Callback when invalidating memory that is potentially shared.
+ *
+ * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
+ */
+static void kvm_gmem_offset_range_invalidate_shared(struct inode *inode,
+						    pgoff_t start, pgoff_t end)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	pgoff_t i;
+
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
+
+	for (i = start; i < end; i++) {
+		/*
+		 * If the folio is NONE_SHARED, it indicates that it is
+		 * transitioning to private (GUEST_SHARED). Transition it to
+		 * shared (ALL_SHARED) and remove the callback.
+		 */
+		if (xa_to_value(xa_load(shared_offsets, i)) == KVM_GMEM_NONE_SHARED) {
+			struct folio *folio = folio = filemap_lock_folio(inode->i_mapping, i);
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
2.49.0.rc1.451.g8f38331e32-goog


