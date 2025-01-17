Return-Path: <kvm+bounces-35811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C23C1A15449
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 272543A6C90
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62E719F116;
	Fri, 17 Jan 2025 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DVkVT9gv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E111A01C6
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131417; cv=none; b=ElBSpCySnigfRKxKYsD0cMYPXB6+BowlE+7Ku7PaITgePumJlwDGrPHC/20zhNbscKqYIELM90f7E9SryVNuPaBwdmTlr3rcIiLI3uJFEZEgTgXz/BHwZNX3sYyfphJKwWpfoXyANOphwgpWxstQ+FKjuAoEZzAI/bdtZftoD/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131417; c=relaxed/simple;
	bh=01N6wpUVFjRTMfZZkFObyBqkWHSMS32uhGlJfZXHtX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=amd5ZHpFacYm+U9IPqz2/6gjTdsdxsJCAgHVzQfOzQyt6B9ns92k/tUxeANxS9ssrvr+W4T+SfRf3Z59hJm48vTP8vmXEi8FteV+TcqB0DXpMhF+/ty+IACBJT6ULW/f7FkQ0rnAmYqnJi9vrKHIxFmSk1LrY/J6qPiHVBKEKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DVkVT9gv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-436723bf7ffso18930875e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131412; x=1737736212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FO66kchh8bGzCA1fstTaZk+RuA83oGXAMjee9RM67m8=;
        b=DVkVT9gvVbXMHP/8kw9OtCMEuxDpLYoqJz0Cg5v65U/5pFu5X99T4DePc31assCpxt
         7psjDS9DKwnXnccAcLJGZyqzX2CYrDpj7Ng9RCd4kHhHAP1t0gNv3c/hcG6BRn44sBvA
         3bysZi3DRsQPOKmemWqqnhheomvNyXvN0l0+06causnwe2ELuIj8uXoP6TKVxjmDTysH
         +c+y8S2LoGGdBx+S2banOUq8F592gj5pTpBv4SGCwme8QFZgijAoYwbzhp/F1ZcN7ggk
         czeZ7eWdn2aZNICZE6v2tr/QtXg+iiR0LqosGF6cMJFwH5U382F8MY7afnlbZzbrRtyT
         FHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131412; x=1737736212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FO66kchh8bGzCA1fstTaZk+RuA83oGXAMjee9RM67m8=;
        b=timJOnRW2BKRTKTlYYviItWMXWWZKViEaY+HI8djY9eUAV4+/wc/yzNSrE07Ly9UlJ
         jJxwbNFQju8dgEEfezHH4na8VzZ1Z3TNpVTDOY7GVQx/L92t+f4ju7CsD5ZUc5EyEmGt
         zvrA3/puxRsyd4flhruFwTYKHz5E2kftrnoHkB7H5E1PwCh/ftMx1i21PR88i/umgN4V
         g2JN7hrMRImqeGZeLeBPYYdYr1lsRW1oItjLtcbiBmTepmV5jwIQ4rj7+DpaiyiW40E0
         D4pUys0l5d83FbyMaWiUbjrv8mjHluP7ZV1okA9luv3vHmiBnuxHxXa23Kpuq1IKJw8C
         xveQ==
X-Gm-Message-State: AOJu0YyHI2o44JbpP3t48v/wba79zouRu+eunuiekNfh5+AfGZgqAISV
	RrvqGZn2+P5bSAHRlL63LGfXGCWs1Uhrzncva4ESmIKLeE5wrwVWLtJJg9CBpz9dBShllXHitV1
	6AXZiREvnmvYPpXj9ZKMce2W4TKhpWOWHOpmbFFiemRnqL1ajGJTnX8vs+Ye6dnC6/PKWMV778R
	SJM/EEI7sdOSUNnlDqyfdlVM8=
X-Google-Smtp-Source: AGHT+IFZgD2R16tEYYHXnP1+7iY9g8PAift3he39jh3cPUQ7kJHFSZqengXdwyt2ds9qO8MFRhz37dcAmQ==
X-Received: from wmbfm15.prod.google.com ([2002:a05:600c:c0f:b0:434:9e7b:42c1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5112:b0:434:a734:d279
 with SMTP id 5b1f17b1804b1-438913f27femr40187145e9.16.1737131412324; Fri, 17
 Jan 2025 08:30:12 -0800 (PST)
Date: Fri, 17 Jan 2025 16:29:50 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-5-tabba@google.com>
Subject: [RFC PATCH v5 04/15] KVM: guest_memfd: Track mappability within a
 struct kvm_gmem_private
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

From: Ackerley Tng <ackerleytng@google.com>

Track whether guest_memfd memory can be mapped within the inode,
since it is property of the guest_memfd's memory contents.

The guest_memfd PRIVATE memory attribute is not used for two
reasons. First because it reflects the userspace expectation for
that memory location, and therefore can be toggled by userspace.
The second is, although each guest_memfd file has a 1:1 binding
with a KVM instance, the plan is to allow multiple files per
inode, e.g. to allow intra-host migration to a new KVM instance,
without destroying guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/guest_memfd.c | 56 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6453658d2650..0a7b6cf8bd8f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -18,6 +18,17 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+struct kvm_gmem_inode_private {
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+	struct xarray mappable_offsets;
+#endif
+};
+
+static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
+{
+	return inode->i_mapping->i_private_data;
+}
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -312,8 +323,28 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
+
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+	/*
+	 * .evict_inode can be called before private data is set up if there are
+	 * issues during inode creation.
+	 */
+	if (private)
+		xa_destroy(&private->mappable_offsets);
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
@@ -440,6 +471,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 						      loff_t size, u64 flags)
 {
 	const struct qstr qname = QSTR_INIT(name, strlen(name));
+	struct kvm_gmem_inode_private *private;
 	struct inode *inode;
 	int err;
 
@@ -448,10 +480,19 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
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
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+	xa_init(&private->mappable_offsets);
+#endif
+
+	inode->i_mapping->i_private_data = private;
 
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
@@ -464,6 +505,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
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
2.48.0.rc2.279.g1de40edade-goog


