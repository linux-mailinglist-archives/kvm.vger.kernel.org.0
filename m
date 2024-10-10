Return-Path: <kvm+bounces-28395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E793C99815A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 634B81F2017A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91241C3F1B;
	Thu, 10 Oct 2024 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YWpgfD9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB771C3F04
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550782; cv=none; b=M+xT2kCIeu9AhhRsvy2cdaABsB4oPcHNWeNCP0HfU5zt1Nuh6WhwKZsNwDQT+TFx16LizhX2m4CUidS28bKka0yWKytAchitgJ5Q0erz6WEZqJdTq4KgIy9heEX1weSY1xTT/R33jAewOVQpQzIBjrJ539S2fTwGWuJ082Y3d7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550782; c=relaxed/simple;
	bh=3zI2mMYBgDtaQ2CZ1B/ek40Jw4Rd0C6Kzftoo23lzPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hcbDxAxSXKF02KjiV7AnnZIVigz+G3gCJuJ3vRQhD6iQgav0B0BzblSqpXgWACyT5PXACx3XcEz7/q+Qfk09RW1XQmiXnP7DuEmx6YlDpMg8ouTT/l27ZyyKinp8JJvl/Ti729sXbuQI7TanzZ9QL2OpRIRNC8epo4VxGHXCkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YWpgfD9q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-430581bd920so4088995e9.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550779; x=1729155579; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4yV7g5zb1mLRm2mV+FxGCvZ9J58MmHKq+HH3QCFP3/A=;
        b=YWpgfD9qEOE3PCDGjxniUMjEI0RvNVAouyNjsh2AusKmz3T6wSvSwuDmfBqIm6pYsy
         9AT1lM5Ui/GJcb4JKlyZoADFLsIRRAcQ33odH6od7z1E43KDyGscXeuUPnMygVjXXI5c
         AjXbVjl14q/MT04f/DB5Y1r8XEpZzk56pCYSuhaaD2YD0UyWSJCQ2uiJTHcloi1WbVW5
         rmTyOIfdGrMCqhCJiT+dB51mB6G+lEsvFl5inGtydgxq5yr7XNNFcpU1AB+hjtfWg3fQ
         YNid+3XV7xcQ3bC8969ltCmbWSYrpG+6a26nDSpk0dGLJ8A5/6IphO+D9CscwLqLEOoC
         kv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550779; x=1729155579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4yV7g5zb1mLRm2mV+FxGCvZ9J58MmHKq+HH3QCFP3/A=;
        b=AAyqfXNBRCyplUPUWvqYFccxCrmqfY+PfNmWjMiPxCg8IZusGjurpThQ/RHERdVcIp
         /O7ABuN/ZwTPIcZCizQMa1ZHbjlCUXQmIHSVbfESV3XhcLQj0V/fnL39fVeLgBBW81nN
         eGWPBwHzsWAJUC17BLu/UECmv3h01CleIij1UIuy1tNQDbNbDj3n9theh1jbyjr2fUyd
         PqE78j+SJf+61v38yY0ekeXqpgCSdijorulp1kfXXUCMk4hXGiL+5Y2q+/N5ZwW5TiOv
         1lcaBvACnilR126elvro9AWt4q2GIyWcxUoSkxoByoWNA6+t9tUfJ4f/HT7/51qmJu6v
         u+hA==
X-Gm-Message-State: AOJu0YyO8n4iPFusQW7MwePUOmAQRlYkR1mM6t2d1S7ZJhNB8GAxM9vT
	51XQ+QOg4MZBWv0YMvVFPsqxlB+hE2WciohVDJqsmxH5q50LTfJPTWeKrsiwFxEFY5g6bepZzVm
	5lgb7zmJgct0EsihAfG5TgweDhxfXBmAHT7Spyn+XkCw8rs+e783IlUE4O73vid25DiyjvMXD3y
	q2sVzeP+60SX8qG5638tkj4LQ=
X-Google-Smtp-Source: AGHT+IEhajSTUGX0DrF4NwfEPAhnOGAT61tcgNDfAcBGm901JNES8kGjHixw5Cb+5EsBR7BggcxyXkjnrQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5357:b0:42c:b45c:5e95 with SMTP id
 5b1f17b1804b1-430ccf091e0mr139615e9.1.1728550777855; Thu, 10 Oct 2024
 01:59:37 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:21 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-3-tabba@google.com>
Subject: [PATCH v3 02/11] KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
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
index 5d7fd1f708a6..4d3ba346c415 100644
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
@@ -307,8 +318,28 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
+
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+	/*
+	 * .free_inode can be called before private data is set up if there are
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
@@ -435,6 +466,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 						      loff_t size, u64 flags)
 {
 	const struct qstr qname = QSTR_INIT(name, strlen(name));
+	struct kvm_gmem_inode_private *private;
 	struct inode *inode;
 	int err;
 
@@ -443,10 +475,19 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
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
@@ -459,6 +500,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
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
2.47.0.rc0.187.ge670bccf7e-goog


