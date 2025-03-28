Return-Path: <kvm+bounces-42178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA07A74DD2
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECFAC188F3A2
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB771D86CE;
	Fri, 28 Mar 2025 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEJTeIG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF1C1C82F4
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175904; cv=none; b=P1M8zbyJUS0dnoJWK0+vebkTXkTX5/Em4MCvOM+m18qhGgOYrWFDeP9egvGNLFjeu35LuPOUOnvdJmcK28JxWaHeWKgka2kwB2yg+/C4T5bKnoJWbCBV6chE7tzNGUhmKnPIJcnp5/f0INfEKn3ydL2a8fcRtNqwpMNinB/Ay3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175904; c=relaxed/simple;
	bh=3g9AH9oSvUwCNVwYdH5PtJPKPAklKGH5WHxqN6AhJFo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrqPekpdkJlwMjxOiZdhMy2d//PligVy5fs7uijG/ySxo+N5a+sUVH0S2TnwggYNgb/x2ZzcP84vr75OH/Qinp2LGsFsq4yMHLTlRRAmS06yi2nI7p8TsFRdMmRTEMcSt2O3bX4jYace+nlV9hdmFwuuHgI2cQqiVTVg1lRl5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEJTeIG2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so18608395e9.2
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743175901; x=1743780701; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/jpShOFnJ6I/k4rEqX8noV9TrB3vpkLt2594tqNmFU=;
        b=LEJTeIG2aQD8mx0jSUajBNXHmQJK/eXEQvR1hENtepmyIVI2cJboExatEjB835HMYv
         gkymrLx6vwKPzJgfWYQEccWIgck0zzoomrSYe6JgcFb1wAKrDuK3AjyJZX1nuN+ObajZ
         HtulFERd0H6KTrko7qVGZ0kQJ5ZSsYlLFC/AKxU4Goapagd5z8vHoeQZH++C7nCGlWyk
         Ey3kFyUZ3VPuA4wJ4hW+JSQtU6WiGDHLwiWyaTE/D0VyL9lNgbJzOy4sULE0uSh/moEL
         V8Gxj7K5maD88mxioTH1gM9Cixsod/va/3FC3hgJqUNWkFlqF39OsN/XAxt8P149uZyE
         17vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743175901; x=1743780701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/jpShOFnJ6I/k4rEqX8noV9TrB3vpkLt2594tqNmFU=;
        b=XvlZglK8eWQNqjYuYfYfigNthMszKtTq3QmyeQmoCQZ5Fcoai89iE8k0QdEgMmOZpN
         sSqIrsAA6pqFxa8qfly/nKcVHe+bbSmvMPJEvT84un2yqqJ13oyz5PD8wQfncuVoeHkr
         SWIDTFUeVjGak0TwIj8IWUEW8XBfPZqwHtGDX59Rp0yUiVrZXAZW3Nk22a8+omWYeVnR
         rBDeP7JFqM7Ar/Kar9RIqhLdHev/9S9sxxTBRB+VStuEQQCkhxDI2d1kqshdarTs02b/
         8hB2fohwyy0ftjlwMUhaq1vZbRZ4nRUenaCH2yDgOK68yxJEu4dxcoJ22lcYkCdORGRZ
         /ggg==
X-Gm-Message-State: AOJu0YzC6SvgeHvFLIaxh/51cp/Z3bsno5G6QPpMt+PDJJiMqOJ1eUdg
	gaFgTR41lTkkNbZWzwWaLuldcuhGgBwax7bPAMUkvSrcQy2Y6vgPxcsAlCYQRx+FR3bflIyFkc7
	ICS22VMaim5eMJ3HhwUmYLZHAemSP22N3qcs1EsjxjA8CPGVVdJHumddezG5gUxT1k4ZzfF/XII
	wLciXom+GYqZ4pchG8hdzNUXM=
X-Google-Smtp-Source: AGHT+IEcG7Zl1YWubAQ/xxzfCc7DzPo7o1l3NxQG19us3iyaCBZ3hbODn54f9bMZd/gVjGPshQUZSrIV3Q==
X-Received: from wmsp31.prod.google.com ([2002:a05:600c:1d9f:b0:43d:1f62:f36c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45c8:b0:43c:fdbe:439b
 with SMTP id 5b1f17b1804b1-43d84f5de84mr98366605e9.4.1743175900745; Fri, 28
 Mar 2025 08:31:40 -0700 (PDT)
Date: Fri, 28 Mar 2025 15:31:29 +0000
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328153133.3504118-4-tabba@google.com>
Subject: [PATCH v7 3/7] KVM: guest_memfd: Track folio sharing within a struct kvm_gmem_private
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

From: Ackerley Tng <ackerleytng@google.com>

Track guest_memfd folio sharing state within the inode, since it is a
property of the guest_memfd's memory contents.

The guest_memfd PRIVATE memory attribute is not used for two reasons. It
reflects the userspace expectation for the memory state, and therefore
can be toggled by userspace. Also, although each guest_memfd file has a
1:1 binding with a KVM instance, the plan is to allow multiple files per
inode, e.g. to allow intra-host migration to a new KVM instance, without
destroying guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 58 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ac6b8853699d..cde16ed3b230 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -17,6 +17,18 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+struct kvm_gmem_inode_private {
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	struct xarray shared_offsets;
+	rwlock_t offsets_lock;
+#endif
+};
+
+static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
+{
+	return inode->i_mapping->i_private_data;
+}
+
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
 void kvm_gmem_handle_folio_put(struct folio *folio)
 {
@@ -324,8 +336,28 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
+
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	/*
+	 * .evict_inode can be called before private data is set up if there are
+	 * issues during inode creation.
+	 */
+	if (private)
+		xa_destroy(&private->shared_offsets);
+#endif
+
+	truncate_inode_pages_final(inode->i_mapping);
+
+	kfree(private);
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
-	.statfs		= simple_statfs,
+	.statfs         = simple_statfs,
+	.evict_inode	= kvm_gmem_evict_inode,
 };
 
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
@@ -553,6 +585,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 						      loff_t size, u64 flags)
 {
 	const struct qstr qname = QSTR_INIT(name, strlen(name));
+	struct kvm_gmem_inode_private *private;
 	struct inode *inode;
 	int err;
 
@@ -561,10 +594,20 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 		return inode;
 
 	err = security_inode_init_security_anon(inode, &qname, NULL);
-	if (err) {
-		iput(inode);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
+	if (!private)
+		goto out;
+
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	xa_init(&private->shared_offsets);
+	rwlock_init(&private->offsets_lock);
+#endif
+
+	inode->i_mapping->i_private_data = private;
 
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
@@ -577,6 +620,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
 	return inode;
+
+out:
+	iput(inode);
+
+	return ERR_PTR(err);
 }
 
 static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
-- 
2.49.0.472.ge94155a9ec-goog


