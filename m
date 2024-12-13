Return-Path: <kvm+bounces-33744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 678539F12CE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23509280794
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6811F1317;
	Fri, 13 Dec 2024 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixDobfAA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550E61F03E0
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108505; cv=none; b=sEDzNj5k3fLS4eeQANDISzt6KZRyyaxgq8yq+FRjDIoU+AehVE1Da4+RC7qJb1MkdS4ZjFwFkDWbVt8rMbucWS5RS0woiPPe4e8iBdQ3ygTxeM1o7YvegHtPasiw9Rkkh+eMn6cubDbc34WWodQsWdnn1C8uAMa2vmapmkkYShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108505; c=relaxed/simple;
	bh=zcjkMhxoY1cdUKFs54GzqECSAze9A8v0uUzrNhnwYfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MNOn9+EF9dQ4kLcazR1jWK3XLWu4i1TUdGL4jGu046GHO0QLAScujBkV60GE6+fWXrBFjD2CwMYmr35anPj4QdsZSzwUaHXm1idX9ayFCRavr9IcXZmtu3wGJEWBW+VWx/pwUUYt73SfayfHNS1VJMLZuWCkWUF155/i6EFfyN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixDobfAA; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-386321c8f4bso1157931f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108502; x=1734713302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aq6uxvVbG5xxzgybZF/l/V4c8HPIK8uPOyna1cvYXWA=;
        b=ixDobfAAVPu7Gpr5b1FLvRtQqpygtXBnMTBoCz72OBVslgLZFOAFSIk+/7p2jiipDd
         TKKAtwyDdpNGNhqbEfZMKdGAejypFwp06hWd3iwHWARug7WCPbIps//Y3adJbe1CA+ca
         cXJJHKeO32iT6aB9cXi2rr9bVYEavupMvEa/zkAO+bvRJaPg6x231W98eqGELjTRQytn
         2cbUr3lyqpv3k0YAjitHy/Ss6p3qdBw3eAeNa0Rny/tFmdAjL5mAX4qqvKAnroz3BQG9
         v3B3HLkD6Bo1A6oXdRLnYV14SmiNaGduOeth1awbm0rGe0ml4ix+PiK+L+Gj7iAcaifj
         g+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108502; x=1734713302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aq6uxvVbG5xxzgybZF/l/V4c8HPIK8uPOyna1cvYXWA=;
        b=iGFoY0Nz8EoKbqXOskbs6aQjzd84GFRgicCznDmJgVzuXuGG7kMdcNs+aq6kI0mKCH
         cNwIETGxlXUyvbmSSYx2Z5lVHCgiel1rnU+OL5yAqPY6bG60Hh7Uy8r3DqoZGOg8yGNs
         yFAqkpfGHL4SOd56g+kGXU0RotcmhHNoXtsPKCAJ7Ya0jSU4QlbcUX5ZhxO2PjZHTrMW
         ZTIqbl8xXCkGUfpZapqQ2pK+AOb5CIOnwRh6aFVh+3HzkcXoFSqsQPe+mX9Df3f7Pnoe
         dl6VjenHzrNNG6GynsrngoXjvIbdXuXgNFX2R6Tb7vJFwCOHKi3vlvSQ3dc6ReKfH8mR
         WMZg==
X-Gm-Message-State: AOJu0YxwfBZcZsb9qD47xFEVn36riKRwTbk9Z3CcO8XaeIwgOFzwMESn
	axv7Bw9CozWTx5wpuzmVUjdkxNYspX5VUdzV4geFVuywiCfqnfgB0Q/digyCT/j9TcExuYzTAZF
	Oe6XlzvdkvBUCv21euBHevJfT8wVbhrYJSgkwCx+JWCcCRDKhtqzrLTMxD3YVZJHNNBv6y4uA3/
	VHMXHJqD3KkzF5cOztrx5AVwM=
X-Google-Smtp-Source: AGHT+IFSvG/fqSl7ZNJ3qm5zCF5qD4QOJhC1Avgrxg1Y/6IRPNfNklxASuKBBLtf2tg/8VDvraqzyfwYkg==
X-Received: from wmbjl5.prod.google.com ([2002:a05:600c:6a85:b0:434:f119:f1a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4b12:b0:385:fc70:7eb
 with SMTP id ffacd0b85a97d-38880ac252bmr2943992f8f.12.1734108501569; Fri, 13
 Dec 2024 08:48:21 -0800 (PST)
Date: Fri, 13 Dec 2024 16:48:00 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-5-tabba@google.com>
Subject: [RFC PATCH v4 04/14] KVM: guest_memfd: Track mappability within a
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
2.47.1.613.gc27f4b7a9f-goog


