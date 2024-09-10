Return-Path: <kvm+bounces-26406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB729746B2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:50:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4AFC1F22860
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AB01BD4EB;
	Tue, 10 Sep 2024 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZClEDWzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75661AC8B9
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011899; cv=none; b=mI7mCqHxAH1myd6ew68oU8UK6Gn/rOS/HA0Vk3E8eesbmpJ8Xv8uQQUkTJtruTTz+aPC8bbuppnNfYMoltd82K8UKvDZNWboIxGqO8xbC+3tYmANjn/Ko6VZreytYu2e4vve9OrqP5RHTN+WD9bkLhDsQrjTIwuWSslxBSdmUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011899; c=relaxed/simple;
	bh=tK2AWcK5RorCRS4IJuPgWIL6zepcg7gijUrMtw7JGFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M3Oe2TASeIRKAF34s51Wb1/OpdKZWQOqs8+bIWG8a4TiW6EZ/TEqgc9ZFEWhEt+6rlH1bR5sl4WR7vgncJuya+fKFpU5fCXSw1N+zu/UqGTaHtJRJ1UGkR4om9LBY8xPKyTtYuMb1X8WUnAYJHsthJv44CHUrFq5J135NgmHmuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZClEDWzJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-205516d992eso15743225ad.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011896; x=1726616696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Gc31H97UbE78QiSNq4CUIpVlCNlnI2SeIjwGOQZSc0=;
        b=ZClEDWzJk1GlPJoEJMSACkIJIVStYDEWhklSbtVitrIhLSwZcqKKOwxF1b7Aj79upQ
         lkgFyGXxfW44uE5cKHMyx31/womGfKAnsTKSBYXZqenNfK23jqY8VomAsbvlxohGpRVJ
         cnD4V99vvwrxjudqLigTUd6EC7SFHVa0+QSUmkKKng7SDkGc7HfDgGTr6XycKMEDJX2G
         13lBs+/gXQdD/HS9KN6Kqb1GUm8/uRIO7lNVlBB3FKBiiafo7EITnrUA8yzox/vTbyoR
         JQxe69VGtXtt+IMK/0lkT4d1B9+eEb+Y61w/afDzO6GybDokVkMdd8QJpZSwCIXXtRe2
         Tz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011896; x=1726616696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Gc31H97UbE78QiSNq4CUIpVlCNlnI2SeIjwGOQZSc0=;
        b=orfot1Br0G5F3SmQvEZArZZ8fAcdwKrzgnrdhj/UA8iUnmrGr/g28GcPjSk1QfGsqX
         eN4k9cVB7Cg02VniiaZcvLUh3byPnBtxN/wU3vGb0P5Su/H22MV1lmLFHMRtuGHTjf8P
         +Aib1U1RMYViwkboAsHrsFOAOIZPibiJPX7EjjmZuL4kFVZqLm+e/Ng6DVfu7On7emXY
         5YVnCWualO8P5fAbcGHRvGEILZc/I+4x1p829SDnuUQZZuBSgjd49RZYYvmpuoixkdzh
         KnHxkXukWAX+tuzQ85RAEvzU25xK9jcbVd33UQjFfUGHpqekSQ4x7lYKD4e0kYOl1PR9
         FFvA==
X-Forwarded-Encrypted: i=1; AJvYcCWGkPxS2l1kHQ6XH9qHrTxYkYh2DvQLdPXof5o8eM2dXOA3TQRcVkTt1wsBMVqRh+2L/yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YznruU7XtysnlQMPWGab0BNBXDSrMRvM5GvCUTxTx3GUFehHIEi
	keNIyk3ULmMKfvazEsDBKZkNZdJ56mAe5l3deN88GIJEwvuXArrL6pxRhmoTY45kyaJLOEghtc7
	z6ChsPjWE1UG5y9XEDsSG5w==
X-Google-Smtp-Source: AGHT+IGTAqnZcaBNVO3Nl4Ef5dtGerZRypTfLYB/jrgUVkEZWYdnxrwGBGsysGpj4YxZly3jtQUA0VOLee5RXF37ZQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:ce91:b0:206:928c:bfd9 with
 SMTP id d9443c01a7336-20752208a62mr470995ad.6.1726011896097; Tue, 10 Sep 2024
 16:44:56 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:45 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <3fec11d8a007505405eadcf2b3e10ec9051cf6bf.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 14/39] KVM: guest_memfd: hugetlb: initialization and cleanup
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

First stage of hugetlb support: add initialization and cleanup
routines.

After guest_mem was massaged to use guest_mem inodes instead of
anonymous inodes in an earlier patch, the .evict_inode handler can now
be overridden to do hugetlb metadata cleanup.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/kvm.h |  26 ++++++
 virt/kvm/guest_memfd.c   | 177 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 197 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..77de7c4432f6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -13,6 +13,7 @@
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
+#include <asm-generic/hugetlb_encode.h>
 
 #define KVM_API_VERSION 12
 
@@ -1558,6 +1559,31 @@ struct kvm_memory_attributes {
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
+#define KVM_GUEST_MEMFD_HUGETLB (1ULL << 1)
+
+/*
+ * Huge page size encoding when KVM_GUEST_MEMFD_HUGETLB is specified, and a huge
+ * page size other than the default is desired.  See hugetlb_encode.h.  All
+ * known huge page size encodings are provided here.  It is the responsibility
+ * of the application to know which sizes are supported on the running system.
+ * See mmap(2) man page for details.
+ */
+#define KVM_GUEST_MEMFD_HUGE_SHIFT     HUGETLB_FLAG_ENCODE_SHIFT
+#define KVM_GUEST_MEMFD_HUGE_MASK      HUGETLB_FLAG_ENCODE_MASK
+
+#define KVM_GUEST_MEMFD_HUGE_64KB      HUGETLB_FLAG_ENCODE_64KB
+#define KVM_GUEST_MEMFD_HUGE_512KB     HUGETLB_FLAG_ENCODE_512KB
+#define KVM_GUEST_MEMFD_HUGE_1MB       HUGETLB_FLAG_ENCODE_1MB
+#define KVM_GUEST_MEMFD_HUGE_2MB       HUGETLB_FLAG_ENCODE_2MB
+#define KVM_GUEST_MEMFD_HUGE_8MB       HUGETLB_FLAG_ENCODE_8MB
+#define KVM_GUEST_MEMFD_HUGE_16MB      HUGETLB_FLAG_ENCODE_16MB
+#define KVM_GUEST_MEMFD_HUGE_32MB      HUGETLB_FLAG_ENCODE_32MB
+#define KVM_GUEST_MEMFD_HUGE_256MB     HUGETLB_FLAG_ENCODE_256MB
+#define KVM_GUEST_MEMFD_HUGE_512MB     HUGETLB_FLAG_ENCODE_512MB
+#define KVM_GUEST_MEMFD_HUGE_1GB       HUGETLB_FLAG_ENCODE_1GB
+#define KVM_GUEST_MEMFD_HUGE_2GB       HUGETLB_FLAG_ENCODE_2GB
+#define KVM_GUEST_MEMFD_HUGE_16GB      HUGETLB_FLAG_ENCODE_16GB
+
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5d7fd1f708a6..31e1115273e1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -3,6 +3,7 @@
 #include <linux/mount.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/hugetlb.h>
 #include <linux/kvm_host.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
@@ -18,6 +19,16 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+struct kvm_gmem_hugetlb {
+	struct hstate *h;
+	struct hugepage_subpool *spool;
+};
+
+static struct kvm_gmem_hugetlb *kvm_gmem_hgmem(struct inode *inode)
+{
+	return inode->i_mapping->i_private_data;
+}
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -154,6 +165,82 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	}
 }
 
+static inline void kvm_gmem_hugetlb_filemap_remove_folio(struct folio *folio)
+{
+	folio_lock(folio);
+
+	folio_clear_dirty(folio);
+	folio_clear_uptodate(folio);
+	filemap_remove_folio(folio);
+
+	folio_unlock(folio);
+}
+
+/**
+ * Removes folios in range [@lstart, @lend) from page cache/filemap (@mapping),
+ * returning the number of pages freed.
+ */
+static int kvm_gmem_hugetlb_filemap_remove_folios(struct address_space *mapping,
+						  struct hstate *h,
+						  loff_t lstart, loff_t lend)
+{
+	const pgoff_t end = lend >> PAGE_SHIFT;
+	pgoff_t next = lstart >> PAGE_SHIFT;
+	struct folio_batch fbatch;
+	int num_freed = 0;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
+		int i;
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio;
+			pgoff_t hindex;
+			u32 hash;
+
+			folio = fbatch.folios[i];
+			hindex = folio->index >> huge_page_order(h);
+			hash = hugetlb_fault_mutex_hash(mapping, hindex);
+
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			kvm_gmem_hugetlb_filemap_remove_folio(folio);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
+			num_freed++;
+		}
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return num_freed;
+}
+
+/**
+ * Removes folios in range [@lstart, @lend) from page cache of inode, updates
+ * inode metadata and hugetlb reservations.
+ */
+static void kvm_gmem_hugetlb_truncate_folios_range(struct inode *inode,
+						   loff_t lstart, loff_t lend)
+{
+	struct kvm_gmem_hugetlb *hgmem;
+	struct hstate *h;
+	int gbl_reserve;
+	int num_freed;
+
+	hgmem = kvm_gmem_hgmem(inode);
+	h = hgmem->h;
+
+	num_freed = kvm_gmem_hugetlb_filemap_remove_folios(inode->i_mapping,
+							   h, lstart, lend);
+
+	gbl_reserve = hugepage_subpool_put_pages(hgmem->spool, num_freed);
+	hugetlb_acct_memory(h, -gbl_reserve);
+
+	spin_lock(&inode->i_lock);
+	inode->i_blocks -= blocks_per_huge_page(h) * num_freed;
+	spin_unlock(&inode->i_lock);
+}
+
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
@@ -307,8 +394,33 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
+static void kvm_gmem_hugetlb_teardown(struct inode *inode)
+{
+	struct kvm_gmem_hugetlb *hgmem;
+
+	truncate_inode_pages_final_prepare(inode->i_mapping);
+	kvm_gmem_hugetlb_truncate_folios_range(inode, 0, LLONG_MAX);
+
+	hgmem = kvm_gmem_hgmem(inode);
+	hugepage_put_subpool(hgmem->spool);
+	kfree(hgmem);
+}
+
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	u64 flags = (u64)inode->i_private;
+
+	if (flags & KVM_GUEST_MEMFD_HUGETLB)
+		kvm_gmem_hugetlb_teardown(inode);
+	else
+		truncate_inode_pages_final(inode->i_mapping);
+
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
 	.statfs		= simple_statfs,
+	.evict_inode	= kvm_gmem_evict_inode,
 };
 
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
@@ -431,6 +543,42 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
+static int kvm_gmem_hugetlb_setup(struct inode *inode, loff_t size, u64 flags)
+{
+	struct kvm_gmem_hugetlb *hgmem;
+	struct hugepage_subpool *spool;
+	int page_size_log;
+	struct hstate *h;
+	long hpages;
+
+	page_size_log = (flags >> KVM_GUEST_MEMFD_HUGE_SHIFT) & KVM_GUEST_MEMFD_HUGE_MASK;
+	h = hstate_sizelog(page_size_log);
+
+	/* Round up to accommodate size requests that don't align with huge pages */
+	hpages = round_up(size, huge_page_size(h)) >> huge_page_shift(h);
+
+	spool = hugepage_new_subpool(h, hpages, hpages, false);
+	if (!spool)
+		goto err;
+
+	hgmem = kzalloc(sizeof(*hgmem), GFP_KERNEL);
+	if (!hgmem)
+		goto err_subpool;
+
+	inode->i_blkbits = huge_page_shift(h);
+
+	hgmem->h = h;
+	hgmem->spool = spool;
+	inode->i_mapping->i_private_data = hgmem;
+
+	return 0;
+
+err_subpool:
+	kfree(spool);
+err:
+	return -ENOMEM;
+}
+
 static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 						      loff_t size, u64 flags)
 {
@@ -443,9 +591,13 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 		return inode;
 
 	err = security_inode_init_security_anon(inode, &qname, NULL);
-	if (err) {
-		iput(inode);
-		return ERR_PTR(err);
+	if (err)
+		goto out;
+
+	if (flags & KVM_GUEST_MEMFD_HUGETLB) {
+		err = kvm_gmem_hugetlb_setup(inode, size, flags);
+		if (err)
+			goto out;
 	}
 
 	inode->i_private = (void *)(unsigned long)flags;
@@ -459,6 +611,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
 	return inode;
+
+out:
+	iput(inode);
+
+	return ERR_PTR(err);
 }
 
 static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
@@ -526,14 +683,22 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	return err;
 }
 
+#define KVM_GUEST_MEMFD_ALL_FLAGS KVM_GUEST_MEMFD_HUGETLB
+
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
-	u64 valid_flags = 0;
 
-	if (flags & ~valid_flags)
-		return -EINVAL;
+	if (flags & KVM_GUEST_MEMFD_HUGETLB) {
+		/* Allow huge page size encoding in flags */
+		if (flags & ~(KVM_GUEST_MEMFD_ALL_FLAGS |
+			      (KVM_GUEST_MEMFD_HUGE_MASK << KVM_GUEST_MEMFD_HUGE_SHIFT)))
+			return -EINVAL;
+	} else {
+		if (flags & ~KVM_GUEST_MEMFD_ALL_FLAGS)
+			return -EINVAL;
+	}
 
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
-- 
2.46.0.598.g6f2099f65c-goog


