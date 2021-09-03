Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E7400597
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 21:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbhICTPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 15:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349690AbhICTPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 15:15:15 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBF6C061757
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 12:14:15 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y6so390159lje.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 12:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xLSw66OAAWw+ZBe/zEI2ozn92/Q+hqpgUOCe6P3aHvM=;
        b=0Ol5wGaLmLCy/W95qtECqEstiHoEtM3Qbv3mrRTm5yb/9sY8R38YRQ3Hz3XjbrILSY
         9LFoAd5ucSo2zocpjSSHq8CUzHgQU0oRUq8unZkZKWMLVX1Qh9bIMk4KZ2ZnBHT0rYct
         pQEQsjKVDcQE6Hr7TnCy4EFJgunnhZhNGfOjhQ09L6392jkZ2nFbyXNPCBolTB2kNsuG
         8fqmIl+wyI2WOONauP1omdNJtcgI7ar6JYvYpad5sYZAwgwniGwZ0U9MfPTcd0lE2GY+
         f8UOFrrIgD/KW8pvFj6gkGMhLdbFIlpNEP5VmEuipL0b5F2pxDi1bPgLHaFCztaObH4r
         FuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xLSw66OAAWw+ZBe/zEI2ozn92/Q+hqpgUOCe6P3aHvM=;
        b=IdCXK8fdUQSUKNESceRG2dT37VQqixzHQuNKobBL2R2objXZyK3rlfpUG5RqnMQF8t
         exAHUwE7EayPtaBeEfhv4Ib7bDlwmye0sS/rqaiEK3NcezFpRpO8T7AHFuxgaEALuHvT
         ZKe4tZ/5xA6r0z5M4ep5Xga7DV0FVQ72letADiofLvSqacZ9kV78gSjwixxLHtjx9sUH
         Cvz+oVJNApfU3revacy43C8a7TEmAqf9wqmqHGQdILE6i7e9XUrIdFMe8m08UQgOUDce
         1Ylwd3xcAs8eR28SbWHnxQ6l6I1nWu7lo7ZKd/0MfbyLdvJUQwUSrkjStsKb5QD4vz5G
         BvSA==
X-Gm-Message-State: AOAM532xHEqVPwqTz+DxJ9X1Nz5GQDhX5wSyHBkOiOqnzNwvGMVSADpw
        JHQ55GQ4HaoJ4ZVWjuKTLj9BzQ==
X-Google-Smtp-Source: ABdhPJy6QUnVLAYByBZjhO+2QHiuXyS/kQV5ZHDoZVhz2cOHas9ztvbOoLvD5566Am7BgnWK8oO1tA==
X-Received: by 2002:a2e:2283:: with SMTP id i125mr366177lji.485.1630696453685;
        Fri, 03 Sep 2021 12:14:13 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id b2sm27501lfi.283.2021.09.03.12.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 12:14:12 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 5AAEF102F10; Fri,  3 Sep 2021 22:14:14 +0300 (+03)
Date:   Fri, 3 Sep 2021 22:14:14 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTE1GzPimvUB1FOF@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 08:33:31PM +0000, Sean Christopherson wrote:
> Would requiring the size to be '0' at F_SEAL_GUEST time solve that problem?

I guess. Maybe we would need a WRITE_ONCE() on set. I donno. I will look
closer into locking next.

> FWIW, splitting a THP will also require a call into KVM to demote the huge page
> to the equivalent small pages.

But will it though? Even if the page got split we still don't allow
migration so EPT can stay 2M. Or do I miss something?

For truncate/punch I disallowed non-page aligned operations. I ignore
failed split. Yes, we zero the truncated parts, but these parts are
already removed from KVM, so it should be safe.

> > We need to modify truncation/punch path to notify kvm that pages are about
> > to be freed. I think we will register callback in the memfd on adding the
> > fd to KVM memslot that going to be called for the notification. That means
> > 1:1 between memfd and memslot. I guess it's okay.
> 
> Hmm, 1:1 memfd to memslot will be problematic as that would prevent punching a
> hole in KVM's memslots, e.g. to convert a subset to shared.  It would also
> disallow backing guest memory with a single memfd that's split across two
> memslots for <4gb and >4gb.
> 
> But I don't think we need a 1:1 relationship.  To keep KVM sane, we can require
> each private memslot to be wholly contained in a single memfd, I can't think of
> any reason that would be problematic for userspace.
> 
> For the callbacks, I believe the rule should be 1:1 between memfd and KVM instance.
> That would allow mapping multiple memslots to a single memfd so long as they're
> all coming from the same KVM instance.

Okay, I've added guest_owner field that I check on registering guest. I
don't think we want to tie it directly to kvm, so I left it just void *.

> 
> > Migration going to always fail on F_SEAL_GUEST for now. Can be modified to
> > use a callback in the future.
> > 
> > Swapout will also always fail on F_SEAL_GUEST. It seems trivial. Again, it
> > can be a callback in the future.
> > 
> > For GPA->PFN translation KVM could use vm_ops->fault(). Semantically it is
> > a good fit, but we don't have any VMAs around and ->mmap is forbidden for
> > F_SEAL_GUEST.
> > Other option is call shmem_getpage() directly, but it looks like a
> > layering violation to me. And it's not available to modules :/
> 
> My idea for this was to have the memfd:KVM exchange callbacks, i.e. memfd would
> have callbacks into KVM, but KVM would also have callbacks into memfd.  To avoid
> circular refcounts, KVM would hold a reference to the memfd (since it's the
> instigator) and KVM would be responsible for unregistering itself before freeing
> it's reference to the memfd.

Okay I went this path. This callback exchange looks wierd to me, but I
suppose it works.

Below is how I see it can look like. It only compile-tested and might be
broken in many ways.

I have not found a right abstaction for shmem_test_guest(). Maybe it has
to be a new inode operation? I donno.
For initial prototyping we can call it directly.

Any comments?

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 8e775ce517bb..6f94fc46a3b1 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -10,6 +10,17 @@
 #include <linux/xattr.h>
 #include <linux/fs_parser.h>
 
+struct guest_ops {
+	void (*invalidate_page_range)(struct inode *inode,
+				      pgoff_t start, pgoff_t end);
+};
+
+struct guest_mem_ops {
+	unsigned long (*get_lock_pfn)(struct inode *inode, pgoff_t offset);
+	void (*put_unlock_pfn)(unsigned long pfn);
+
+};
+
 /* inode in-kernel data */
 
 struct shmem_inode_info {
@@ -24,6 +35,8 @@ struct shmem_inode_info {
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct inode		vfs_inode;
+	void			*guest_owner;
+	const struct guest_ops	*guest_ops;
 };
 
 struct shmem_sb_info {
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 2f86b2ad6d7e..c79bc8572721 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -43,6 +43,7 @@
 #define F_SEAL_GROW	0x0004	/* prevent file from growing */
 #define F_SEAL_WRITE	0x0008	/* prevent writes */
 #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
+#define F_SEAL_GUEST		0x0020
 /* (1U << 31) is reserved for signed error codes */
 
 /*
diff --git a/mm/memfd.c b/mm/memfd.c
index 081dd33e6a61..ccaa4edb21f7 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -134,7 +134,8 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE | \
-		     F_SEAL_FUTURE_WRITE)
+		     F_SEAL_FUTURE_WRITE | \
+		     F_SEAL_GUEST)
 
 static int memfd_add_seals(struct file *file, unsigned int seals)
 {
@@ -203,10 +204,27 @@ static int memfd_add_seals(struct file *file, unsigned int seals)
 		}
 	}
 
+	if (seals & F_SEAL_GUEST) {
+		i_mmap_lock_read(inode->i_mapping);
+
+		if (!RB_EMPTY_ROOT(&inode->i_mapping->i_mmap.rb_root)) {
+			error = -EBUSY;
+			goto unlock;
+		}
+
+		if (i_size_read(inode)) {
+			error = -EBUSY;
+			goto unlock;
+		}
+	}
+
 	*file_seals |= seals;
 	error = 0;
 
 unlock:
+	if (seals & F_SEAL_GUEST)
+		i_mmap_unlock_read(inode->i_mapping);
+
 	inode_unlock(inode);
 	return error;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index dacda7463d54..761cf4e2152e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -883,6 +883,17 @@ static bool shmem_punch_compound(struct page *page, pgoff_t start, pgoff_t end)
 	return split_huge_page(page) >= 0;
 }
 
+static void guest_invalidate_page(struct inode *inode,
+				  struct page *page, pgoff_t start, pgoff_t end)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	start = max(start, page->index);
+	end = min(end, page->index + HPAGE_PMD_NR) - 1;
+
+	info->guest_ops->invalidate_page_range(inode, start, end);
+}
+
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
@@ -923,6 +934,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			}
 			index += thp_nr_pages(page) - 1;
 
+			guest_invalidate_page(inode, page, start, end);
+
 			if (!unfalloc || !PageUptodate(page))
 				truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -999,6 +1012,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 					index--;
 					break;
 				}
+
+				guest_invalidate_page(inode, page, start, end);
+
 				VM_BUG_ON_PAGE(PageWriteback(page), page);
 				if (shmem_punch_compound(page, start, end))
 					truncate_inode_page(mapping, page);
@@ -1074,6 +1090,9 @@ static int shmem_setattr(struct user_namespace *mnt_userns,
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
+		if ((info->seals & F_SEAL_GUEST) && (newsize & ~PAGE_MASK))
+			return -EINVAL;
+
 		if (newsize != oldsize) {
 			error = shmem_reacct_size(SHMEM_I(inode)->flags,
 					oldsize, newsize);
@@ -1348,6 +1367,8 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 		goto redirty;
 	if (!total_swap_pages)
 		goto redirty;
+	if (info->seals & F_SEAL_GUEST)
+		goto redirty;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -2274,6 +2295,9 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	if (ret)
 		return ret;
 
+	if (info->seals & F_SEAL_GUEST)
+		return -EPERM;
+
 	/* arm64 - allow memory tagging on RAM-based files */
 	vma->vm_flags |= VM_MTE_ALLOWED;
 
@@ -2471,12 +2495,14 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index = pos >> PAGE_SHIFT;
 
 	/* i_mutex is held by caller */
-	if (unlikely(info->seals & (F_SEAL_GROW |
-				   F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
+	if (unlikely(info->seals & (F_SEAL_GROW | F_SEAL_WRITE |
+				    F_SEAL_FUTURE_WRITE | F_SEAL_GUEST))) {
 		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))
 			return -EPERM;
 		if ((info->seals & F_SEAL_GROW) && pos + len > inode->i_size)
 			return -EPERM;
+		if (info->seals & F_SEAL_GUEST)
+			return -EPERM;
 	}
 
 	return shmem_getpage(inode, index, pagep, SGP_WRITE);
@@ -2530,6 +2556,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
+	if (SHMEM_I(inode)->seals & F_SEAL_GUEST)
+		return -EPERM;
 	/*
 	 * Might this read be for a stacking filesystem?  Then when reading
 	 * holes of a sparse file, we actually need to allocate those pages,
@@ -2675,6 +2703,12 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 			goto out;
 		}
 
+		if ((info->seals & F_SEAL_GUEST) &&
+		    (offset & ~PAGE_MASK || len & ~PAGE_MASK)) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		shmem_falloc.waitq = &shmem_falloc_waitq;
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
@@ -3761,6 +3795,20 @@ static void shmem_destroy_inodecache(void)
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
+#ifdef CONFIG_MIGRATION
+int shmem_migrate_page(struct address_space *mapping,
+		struct page *newpage, struct page *page,
+		enum migrate_mode mode)
+{
+	struct inode *inode = mapping->host;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	if (info->seals & F_SEAL_GUEST)
+		return -ENOTSUPP;
+	return migrate_page(mapping, newpage, page, mode);
+}
+#endif
+
 const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
@@ -3769,12 +3817,57 @@ const struct address_space_operations shmem_aops = {
 	.write_end	= shmem_write_end,
 #endif
 #ifdef CONFIG_MIGRATION
-	.migratepage	= migrate_page,
+	.migratepage	= shmem_migrate_page,
 #endif
 	.error_remove_page = generic_error_remove_page,
 };
 EXPORT_SYMBOL(shmem_aops);
 
+static unsigned long shmem_get_lock_pfn(struct inode *inode, pgoff_t offset)
+{
+	struct page *page;
+	int ret;
+
+	ret = shmem_getpage(inode, offset, &page, SGP_WRITE);
+	if (ret)
+		return ret;
+
+	return page_to_pfn(page);
+}
+
+static void shmem_put_unlock_pfn(unsigned long pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+
+	set_page_dirty(page);
+	unlock_page(page);
+	put_page(page);
+}
+
+static const struct guest_mem_ops shmem_guest_ops = {
+	.get_lock_pfn = shmem_get_lock_pfn,
+	.put_unlock_pfn = shmem_put_unlock_pfn,
+};
+
+int shmem_register_guest(struct inode *inode, void *owner,
+			 const struct guest_ops *guest_ops,
+			 const struct guest_mem_ops **guest_mem_ops)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	if (!owner)
+		return -EINVAL;
+
+	if (info->guest_owner && info->guest_owner != owner)
+		return -EPERM;
+
+	info->guest_ops = guest_ops;
+	*guest_mem_ops = &shmem_guest_ops;
+	return 0;
+}
+
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 	.get_unmapped_area = shmem_get_unmapped_area,
-- 
 Kirill A. Shutemov
