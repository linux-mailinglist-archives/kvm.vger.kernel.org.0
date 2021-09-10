Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0B40706A
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 19:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhIJRT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 13:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhIJRTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 13:19:25 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414E6C061756
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:18:14 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id l10so5467697lfg.4
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qcjllYF++W26syAeA+jBC8DEh4Ux0RDmheFF73T+L7Q=;
        b=zMQHA53TNazFgJjtixFtJrDHeR+YPeq8SWqXo+jUhDcnlu9n3RZ/YRpmtFtF3t3qSk
         FlaBDqqGDfOGLC6dhh2qRU3SBEePsDmO6updJpSTqVo6UC3aoUJl08JgUKXwQ8gKeAni
         +Ben0sGccxL3DPvQGJcGJCNSf4eX9V4XLMUhlBPeWpW7czHtvpA6QawOjhCeI2DT0p4u
         U22gyEecGF8KPRcEtCGCzlsvf7lMUTSoGkS9NcEMYwkOFUOlIdXe/J36mIna/KUJHHQ+
         WTlR8wUiikrcfMhnMSf/nk1jrWfCMsV/LVbWe4ZssFcVjzqi8UQJYoFsePk7O8wYn+xd
         xQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qcjllYF++W26syAeA+jBC8DEh4Ux0RDmheFF73T+L7Q=;
        b=AAkojdXnKF4yMk9ssUTV/FKgcGA5qvER8cvSXEErZvp2I3FwNLIFFL0jFGZ8O5nKfb
         N4H2a12OhVMK3PDW9oMieviyHal9DXSDeCj9Z2HuUC1pp0+ERFOL/Dplp//JLCba/1G2
         0FXic/Wh0pjH5vRhQGB8extu3mUcw/GIGhQGNd6CVudwTJ0eKlSuqdeFd1I7J1h9G3Bu
         9Sl4qxfi0tQZ7OUhk1SMM2cFQJfjwBb1rgqtvJjFqRJr6DEcC0LWruz/3bnIYP8TSTVw
         sGIh9gjVJkzmG5jpPuVLT0ClSioTCLlXG6z7cJVWc0j8djus1lgeXKVw1OvED41C3aIV
         dY4A==
X-Gm-Message-State: AOAM5337QtdGagcflgjLdk63jZJ8oEKDg3n0AhZg5XiCKxDzOxZA7Or9
        l5lseM+b5UdohtUKmKpnzVwsjw==
X-Google-Smtp-Source: ABdhPJzpbHEtfXuuL/PT73n42yDDRqsYqSHeEwf4qCDjTm17wjqdRvdTXhayD6eBPAtVmNgLN7VChg==
X-Received: by 2002:ac2:58c9:: with SMTP id u9mr3731641lfo.680.1631294292512;
        Fri, 10 Sep 2021 10:18:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t17sm75201lft.296.2021.09.10.10.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:18:11 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 9C7B4102880; Fri, 10 Sep 2021 20:18:11 +0300 (+03)
Date:   Fri, 10 Sep 2021 20:18:11 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
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
Message-ID: <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5xgu7omaz7zhq4al"
Content-Disposition: inline
In-Reply-To: <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5xgu7omaz7zhq4al
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 03, 2021 at 12:15:51PM -0700, Andy Lutomirski wrote:
> On 9/3/21 12:14 PM, Kirill A. Shutemov wrote:
> > On Thu, Sep 02, 2021 at 08:33:31PM +0000, Sean Christopherson wrote:
> >> Would requiring the size to be '0' at F_SEAL_GUEST time solve that problem?
> > 
> > I guess. Maybe we would need a WRITE_ONCE() on set. I donno. I will look
> > closer into locking next.
> 
> We can decisively eliminate this sort of failure by making the switch
> happen at open time instead of after.  For a memfd-like API, this would
> be straightforward.  For a filesystem, it would take a bit more thought.

I think it should work fine as long as we check seals after i_size in the
read path. See the comment in shmem_file_read_iter().

Below is updated version. I think it should be good enough to start
integrate with KVM.

I also attach a test-case that consists of kernel patch and userspace
program. It demonstrates how it can be integrated into KVM code.

One caveat I noticed is that guest_ops::invalidate_page_range() can be
called after the owner (struct kvm) has being freed. It happens because
memfd can outlive KVM. So the callback has to check if such owner exists,
than check that there's a memslot with such inode.

I guess it should be okay: we have vm_list we can check owner against.
We may consider replace vm_list with something more scalable if number of
VMs will get too high.

Any comments?

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index 4f1600413f91..3005e233140a 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -4,13 +4,34 @@
 
 #include <linux/file.h>
 
+struct guest_ops {
+	void (*invalidate_page_range)(struct inode *inode, void *owner,
+				      pgoff_t start, pgoff_t end);
+};
+
+struct guest_mem_ops {
+	unsigned long (*get_lock_pfn)(struct inode *inode, pgoff_t offset);
+	void (*put_unlock_pfn)(unsigned long pfn);
+
+};
+
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+
+extern inline int memfd_register_guest(struct inode *inode, void *owner,
+				       const struct guest_ops *guest_ops,
+				       const struct guest_mem_ops **guest_mem_ops);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
 {
 	return -EINVAL;
 }
+static inline int memfd_register_guest(struct inode *inode, void *owner,
+				       const struct guest_ops *guest_ops,
+				       const struct guest_mem_ops **guest_mem_ops)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 8e775ce517bb..265d0c13bc5e 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -12,6 +12,9 @@
 
 /* inode in-kernel data */
 
+struct guest_ops;
+struct guest_mem_ops;
+
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned int		seals;		/* shmem seals */
@@ -24,6 +27,8 @@ struct shmem_inode_info {
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct inode		vfs_inode;
+	void			*guest_owner;
+	const struct guest_ops	*guest_ops;
 };
 
 struct shmem_sb_info {
@@ -90,6 +95,10 @@ extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
 
+extern int shmem_register_guest(struct inode *inode, void *owner,
+				const struct guest_ops *guest_ops,
+				const struct guest_mem_ops **guest_mem_ops);
+
 /* Flag allocation requirements to shmem_getpage */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
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
index 081dd33e6a61..ae43454789f4 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -130,11 +130,24 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 	return NULL;
 }
 
+int memfd_register_guest(struct inode *inode, void *owner,
+			 const struct guest_ops *guest_ops,
+			 const struct guest_mem_ops **guest_mem_ops)
+{
+	if (shmem_mapping(inode->i_mapping)) {
+		return shmem_register_guest(inode, owner,
+					    guest_ops, guest_mem_ops);
+	}
+
+	return -EINVAL;
+}
+
 #define F_ALL_SEALS (F_SEAL_SEAL | \
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE | \
-		     F_SEAL_FUTURE_WRITE)
+		     F_SEAL_FUTURE_WRITE | \
+		     F_SEAL_GUEST)
 
 static int memfd_add_seals(struct file *file, unsigned int seals)
 {
@@ -203,10 +216,27 @@ static int memfd_add_seals(struct file *file, unsigned int seals)
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
index dacda7463d54..54c213b7b42a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -80,6 +80,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
 #include <linux/uuid.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 
@@ -883,6 +884,18 @@ static bool shmem_punch_compound(struct page *page, pgoff_t start, pgoff_t end)
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
+	info->guest_ops->invalidate_page_range(inode, info->guest_owner,
+					       start, end);
+}
+
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
@@ -923,6 +936,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			}
 			index += thp_nr_pages(page) - 1;
 
+			guest_invalidate_page(inode, page, start, end);
+
 			if (!unfalloc || !PageUptodate(page))
 				truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -999,6 +1014,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 					index--;
 					break;
 				}
+
+				guest_invalidate_page(inode, page, start, end);
+
 				VM_BUG_ON_PAGE(PageWriteback(page), page);
 				if (shmem_punch_compound(page, start, end))
 					truncate_inode_page(mapping, page);
@@ -1074,6 +1092,9 @@ static int shmem_setattr(struct user_namespace *mnt_userns,
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
+		if ((info->seals & F_SEAL_GUEST) && (newsize & ~PAGE_MASK))
+			return -EINVAL;
+
 		if (newsize != oldsize) {
 			error = shmem_reacct_size(SHMEM_I(inode)->flags,
 					oldsize, newsize);
@@ -1348,6 +1369,8 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 		goto redirty;
 	if (!total_swap_pages)
 		goto redirty;
+	if (info->seals & F_SEAL_GUEST)
+		goto redirty;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -2274,6 +2297,9 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	if (ret)
 		return ret;
 
+	if (info->seals & F_SEAL_GUEST)
+		return -EPERM;
+
 	/* arm64 - allow memory tagging on RAM-based files */
 	vma->vm_flags |= VM_MTE_ALLOWED;
 
@@ -2471,12 +2497,14 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
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
@@ -2550,6 +2578,20 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		end_index = i_size >> PAGE_SHIFT;
 		if (index > end_index)
 			break;
+
+		/*
+		 * inode_lock protects setting up seals as well as write to
+		 * i_size. Setting F_SEAL_GUEST only allowed with i_size == 0.
+		 *
+		 * Check F_SEAL_GUEST after i_size. It effectively serialize
+		 * read vs. setting F_SEAL_GUEST without taking inode_lock in
+		 * read path.
+		 */
+		if (SHMEM_I(inode)->seals & F_SEAL_GUEST) {
+			error = -EPERM;
+			break;
+		}
+
 		if (index == end_index) {
 			nr = i_size & ~PAGE_MASK;
 			if (nr <= offset)
@@ -2675,6 +2717,12 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
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
@@ -3761,6 +3809,20 @@ static void shmem_destroy_inodecache(void)
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
@@ -3769,12 +3831,57 @@ const struct address_space_operations shmem_aops = {
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

--5xgu7omaz7zhq4al
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="test-case.patch"

diff --git a/mm/shmem.c b/mm/shmem.c
index 54c213b7b42a..78d07299ef04 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -81,6 +81,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/rmap.h>
 #include <linux/uuid.h>
 #include <linux/memfd.h>
+#include <linux/debugfs.h>
 
 #include <linux/uaccess.h>
 
@@ -3882,6 +3883,85 @@ int shmem_register_guest(struct inode *inode, void *owner,
 	return 0;
 }
 
+static void test_guest_invalidate_page_range(struct inode *inode, void *owner,
+					     pgoff_t start, pgoff_t end)
+{
+	/*
+	 * XXX: We can get here after the owner no longer exists. Need to check
+	 * somehow if the owner is still alive.
+	 */
+
+	printk("invalidate: %#lx-%#lx\n", start, end);
+}
+
+static const struct guest_ops guest_ops = {
+	.invalidate_page_range = test_guest_invalidate_page_range,
+};
+
+#define GUEST_MEM_REGISTER	_IOW('m', 1, int)
+#define GUEST_MEM_UNREGISTER	_IOW('m', 2, int)
+#define GUEST_MEM_GET_PFN	_IOW('m', 3, unsigned long)
+
+static long guest_mem_test_ioctl(struct file *file,
+				 unsigned int cmd, unsigned long arg)
+{
+	static struct file *memfd_file = NULL;
+	static const struct guest_mem_ops *guest_mem_ops = NULL;
+
+	switch (cmd) {
+	case GUEST_MEM_REGISTER: {
+		struct fd memfd = fdget(arg);
+
+		if (memfd_file)
+			return -EBUSY;
+
+		if (!memfd.file)
+			return -EINVAL;
+
+		memfd_file = memfd.file;
+		return memfd_register_guest(memfd_file->f_inode, file,
+					    &guest_ops, &guest_mem_ops);
+	}
+	case GUEST_MEM_UNREGISTER: {
+		if (!memfd_file)
+			return -EINVAL;
+
+		fput(memfd_file);
+		memfd_file = NULL;
+		guest_mem_ops = NULL;
+		return 0;
+	}
+	case GUEST_MEM_GET_PFN: {
+		unsigned long pfn;
+		printk("guest_mem_ops: %px\n", guest_mem_ops);
+		pfn = guest_mem_ops->get_lock_pfn(memfd_file->f_inode, 0);
+		printk("pfn: %#lx\n");
+		if (pfn < 0)
+			return pfn;
+		guest_mem_ops->put_unlock_pfn(pfn);
+		return 0;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
+
+static const struct file_operations guest_mem_test_fops = {
+	.owner	 = THIS_MODULE,
+	.unlocked_ioctl = guest_mem_test_ioctl,
+	.llseek  = no_llseek,
+};
+
+static int __init guest_mem_test(void)
+{
+	debugfs_create_file("guest_mem_test", 0200, NULL, NULL,
+			    &guest_mem_test_fops);
+	return 0;
+}
+late_initcall(guest_mem_test);
+
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 	.get_unmapped_area = shmem_get_unmapped_area,

--5xgu7omaz7zhq4al
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="memfd_guest.c"

#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#define GUEST_MEM_REGISTER	_IOW('m', 1, int)
#define GUEST_MEM_UNREGISTER	_IOW('m', 2, int)
#define GUEST_MEM_GET_PFN	_IOW('m', 3, unsigned long)

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); } while (0)

#define F_SEAL_GUEST	0x0020

int main(int argc, char *argv[])
{
	int fd, test_fd;
	char buf[4];

	/* Create an anonymous file in tmpfs; allow seals to be
	   placed on the file. */

	fd = memfd_create("memfd_guest", MFD_ALLOW_SEALING);
	if (fd == -1)
		errExit("memfd_create");

#if 0
	if (write(fd, "test", 4) != 4)
		errExit("write");
#endif

#if 0
	if (ftruncate(fd, 4096) == -1)
		errExit("ftruncate");
#endif

#if 0
	if (mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0) == MAP_FAILED)
		errExit("mmap");
#endif

	if (fcntl(fd, F_ADD_SEALS, F_SEAL_GUEST) == -1)
		errExit("fcntl");

	if (ftruncate(fd, 2UL << 20) == -1)
		errExit("ftruncate");

	/* Expected to fail */
	if (write(fd, "test", 4) != -1)
		errExit("write");

	if (read(fd, buf, 4) != -1)
		errExit("read");

	if (mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0) != MAP_FAILED)
		errExit("mmap");

	test_fd = open("/sys/kernel/debug/guest_mem_test", O_RDWR);
	if (fd == -1)
		errExit("open");

	if (ioctl(test_fd, GUEST_MEM_REGISTER, fd) == -1)
		errExit("ioctl");

	if (ioctl(test_fd, GUEST_MEM_GET_PFN, 0x100) == -1)
		errExit("ioctl");

	if (ioctl(test_fd, GUEST_MEM_GET_PFN, 0x1) == -1)
		errExit("ioctl");

	if (ftruncate(fd, 0))
		errExit("ftruncate");

	if (ioctl(test_fd, GUEST_MEM_UNREGISTER, fd) == -1)
		errExit("ioctl");

	return 0;
}

--5xgu7omaz7zhq4al--
