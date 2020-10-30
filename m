Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0006D2A0236
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 11:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgJ3KIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 06:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgJ3KIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 06:08:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB74C0613CF
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:50 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g12so5769230wrp.10
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 03:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4ilcVBAHuOCTtZMsF1m8kT7eVt7mrBkTULM8ihAU5Q=;
        b=GO2lvH63CKIIvm4pmukV3hDOR0RNqeUA9AeBrEF8NltqrZhXote2bDxTwEJdVvTtJd
         xkKihu5rtfTbifyZElLLYgP0VDNzFe0Jt/QvYOwQWROiwJr0/YeFXLdGoKQhPmhfWICx
         70SdqYqWB/N/SS3b98Sha2tiQj/Nzf1byR0IU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4ilcVBAHuOCTtZMsF1m8kT7eVt7mrBkTULM8ihAU5Q=;
        b=NgvuTpqwCK7laJz3ht36KcR6n1rogVRjslJcuq6nGZI1vkca/rmqIfv3iHhLwkJQtF
         6TbDqHq+hUUh7Yu3XYCK1SBkh+a84xarnbmq6PxfeBoiJAWITSqwphJgETMxms2V2fzN
         hZ8gREjoBjWnEJ/EqjvP3VhEOHOLf3QRR+1u3JVsyRhco/JwUt4epADgqlJZTKPKfdtc
         VQFZB2zYeD9nluw3PX4fmNrorpLTy5jX2IJsMJEabKCbQ+WtnW9FFw7tlSSEZeaWVtBG
         fW77mJCU1yuF7twO43R2sxfAjl33geDZTJ4M8OAtpuRq/giRIdxx4NBLAsDseKLmz2r/
         I59w==
X-Gm-Message-State: AOAM5312caQqEm7rq7qcEy21dydtShomCAsSvqVDTqyCdzTvt3S5Jpi0
        M7jNneajdPqqFi7AHV9BfW/35g==
X-Google-Smtp-Source: ABdhPJwl+0pBrq79hYTZxdZJ4HUKk5mm6G3nf6ZchRV1nc1hfz+MJY+K7zHup1CZanOLY9UfEQro7Q==
X-Received: by 2002:a5d:4bd1:: with SMTP id l17mr2236438wrt.38.1604052529128;
        Fri, 30 Oct 2020 03:08:49 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v189sm4430947wmg.14.2020.10.30.03.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 03:08:48 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v5 08/15] mm: Add unsafe_follow_pfn
Date:   Fri, 30 Oct 2020 11:08:08 +0100
Message-Id: <20201030100815.2269-9-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Way back it was a reasonable assumptions that iomem mappings never
change the pfn range they point at. But this has changed:

- gpu drivers dynamically manage their memory nowadays, invalidating
ptes with unmap_mapping_range when buffers get moved

- contiguous dma allocations have moved from dedicated carvetouts to
cma regions. This means if we miss the unmap the pfn might contain
pagecache or anon memory (well anything allocated with GFP_MOVEABLE)

- even /dev/mem now invalidates mappings when the kernel requests that
iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
("/dev/mem: Revoke mappings when a driver claims the region")

Accessing pfns obtained from ptes without holding all the locks is
therefore no longer a good idea.

Unfortunately there's some users where this is not fixable (like v4l
userptr of iomem mappings) or involves a pile of work (vfio type1
iommu). For now annotate these as unsafe and splat appropriately.

This patch adds an unsafe_follow_pfn, which later patches will then
roll out to all appropriate places.

Also mark up follow_pfn as EXPORT_SYMBOL_GPL. The only safe way to use
that by drivers/modules is together with an mmu_notifier, and that's
all _GPL stuff.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
--
v5: Suggestions from Christoph
- reindent for less weirdness
- use IS_ENABLED instead of #ifdef
- same checks for nommu, for consistency
- EXPORT_SYMBOL_GPL for follow_pfn.
- kerneldoc was already updated in previous versions to explain when
  follow_pfn can be used safely
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 34 ++++++++++++++++++++++++++++++++--
 mm/nommu.c         | 27 ++++++++++++++++++++++++++-
 security/Kconfig   | 13 +++++++++++++
 4 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 83d0be101a38..d0fe8bf46a9d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1661,6 +1661,8 @@ int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
+int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
+		      unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
 		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index ac32039ce941..0db0c5e233fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4795,7 +4795,12 @@ EXPORT_SYMBOL(follow_pte_pmd);
  * @address: user virtual address
  * @pfn: location to store found PFN
  *
- * Only IO mappings and raw PFN mappings are allowed.
+ * Only IO mappings and raw PFN mappings are allowed. Note that callers must
+ * ensure coherency with pte updates by using a &mmu_notifier to follow updates.
+ * If this is not feasible, or the access to the @pfn is only very short term,
+ * use follow_pte_pmd() instead and hold the pagetable lock for the duration of
+ * the access instead. Any caller not following these requirements must use
+ * unsafe_follow_pfn() instead.
  *
  * Return: zero and the pfn at @pfn on success, -ve otherwise.
  */
@@ -4816,7 +4821,32 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	pte_unmap_unlock(ptep, ptl);
 	return 0;
 }
-EXPORT_SYMBOL(follow_pfn);
+EXPORT_SYMBOL_GPL(follow_pfn);
+
+/**
+ * unsafe_follow_pfn - look up PFN at a user virtual address
+ * @vma: memory mapping
+ * @address: user virtual address
+ * @pfn: location to store found PFN
+ *
+ * Only IO mappings and raw PFN mappings are allowed.
+ *
+ * Returns zero and the pfn at @pfn on success, -ve otherwise.
+ */
+int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
+		      unsigned long *pfn)
+{
+	if (IS_ENABLED(CONFIG_STRICT_FOLLOW_PFN)) {
+		pr_info("unsafe follow_pfn usage rejected, see CONFIG_STRICT_FOLLOW_PFN\n");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "unsafe follow_pfn usage\n");
+	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+
+	return follow_pfn(vma, address, pfn);
+}
+EXPORT_SYMBOL(unsafe_follow_pfn);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
diff --git a/mm/nommu.c b/mm/nommu.c
index 0faf39b32cdb..79fc98a6c94a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -130,7 +130,32 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	*pfn = address >> PAGE_SHIFT;
 	return 0;
 }
-EXPORT_SYMBOL(follow_pfn);
+EXPORT_SYMBOL_GPL(follow_pfn);
+
+/**
+ * unsafe_follow_pfn - look up PFN at a user virtual address
+ * @vma: memory mapping
+ * @address: user virtual address
+ * @pfn: location to store found PFN
+ *
+ * Only IO mappings and raw PFN mappings are allowed.
+ *
+ * Returns zero and the pfn at @pfn on success, -ve otherwise.
+ */
+int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
+		      unsigned long *pfn)
+{
+	if (IS_ENABLED(CONFIG_STRICT_FOLLOW_PFN)) {
+		pr_info("unsafe follow_pfn usage rejected, see CONFIG_STRICT_FOLLOW_PFN\n");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "unsafe follow_pfn usage\n");
+	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+
+	return follow_pfn(vma, address, pfn);
+}
+EXPORT_SYMBOL(unsafe_follow_pfn);
 
 LIST_HEAD(vmap_area_list);
 
diff --git a/security/Kconfig b/security/Kconfig
index 7561f6f99f1d..48945402e103 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -230,6 +230,19 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+config STRICT_FOLLOW_PFN
+	bool "Disable unsafe use of follow_pfn"
+	depends on MMU
+	help
+	  Some functionality in the kernel follows userspace mappings to iomem
+	  ranges in an unsafe matter. Examples include v4l userptr for zero-copy
+	  buffers sharing.
+
+	  If this option is switched on, such access is rejected. Only enable
+	  this option when you must run userspace which requires this.
+
+	  If in doubt, say Y.
+
 source "security/selinux/Kconfig"
 source "security/smack/Kconfig"
 source "security/tomoyo/Kconfig"
-- 
2.28.0

