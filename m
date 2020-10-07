Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66DF2864E9
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgJGQpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgJGQop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:44:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987E4C0613DB
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:44:44 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w5so2973471wrp.8
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0cYv7pt2ajdPKJ71Sud+gUJyoyQWkHY61omgO6gUCQ=;
        b=E4wIl1khATPAWsmoahDSq5XJ9XB3/O17Fju2KtWFpZcnpDunS6aB2uzf/IAoSlz+9+
         5VxZXcG5teVG2C1MloXLK4xiaqUArGcDx8l8ZuU+9gaO8lbpEVnn6vpAnmLx4qTlAd8x
         TdyxsIClr7xEEKfXI/m8EFXclIzKOCjXa7FyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0cYv7pt2ajdPKJ71Sud+gUJyoyQWkHY61omgO6gUCQ=;
        b=tw2KWaUMN5gk684R05o/yVxcJK+XGJnYr47inTELO/G00OKAhq//bPHkp9b0WaGe+W
         8pzyNk9LWdoMR8rKxIVyjj7bCvObb9h0yxAayjDpmunqT4gcYP4h8+YT6+qknmKYVHip
         6r7Yx+oQhFdzIqzn+u3v5AFWtvlHBsHX3DwDMI0NImC1bWWT7xZymuYLcef9FwiKqy7Q
         5IuubgTsxCki3xOaVXMhjHuhNYJYUOz0Nt0v7rBy+Az65aHqbu/umJEX3y73xvOmlj/I
         jcUuzCzsq1tpSEwmE6nvOJp4Aef85AdC0ZjRdflHWs4dCr3y9T1/rbkIpHV2U5KR15B9
         0akQ==
X-Gm-Message-State: AOAM532X4eOAhs21dUbWuuamJFa/2GjN1lNBHNAAvOnJIEa8tSPRWYYw
        Ne+R+IdDIezcR0RTk94URiIdeg==
X-Google-Smtp-Source: ABdhPJyOhUNMEwwCQ+AEh8GM5Lra9AvYxZp9hFKsj4jVU6Oiy0Fq4b4Qf4lRUIggnlkhrBK3gQ/vuQ==
X-Received: by 2002:a5d:51ca:: with SMTP id n10mr4539798wrv.222.1602089083290;
        Wed, 07 Oct 2020 09:44:43 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z191sm3332280wme.40.2020.10.07.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:44:42 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrensmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@linux.ie>,
        Hugh Dickins <hugh@veritas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 07/13] mm: close race in generic_access_phys
Date:   Wed,  7 Oct 2020 18:44:20 +0200
Message-Id: <20201007164426.1812530-8-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
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
therefore no longer a good idea. Fix this.

Since ioremap might need to manipulate pagetables too we need to drop
the pt lock and have a retry loop if we raced.

While at it, also add kerneldoc and improve the comment for the
vma_ops->access function. It's for accessing, not for moving the
memory from iomem to system memory, as the old comment seemed to
suggest.

References: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrensmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 include/linux/mm.h |  3 ++-
 mm/memory.c        | 44 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index acd60fbf1a5a..2a16631c1fda 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -566,7 +566,8 @@ struct vm_operations_struct {
 	vm_fault_t (*pfn_mkwrite)(struct vm_fault *vmf);
 
 	/* called by access_process_vm when get_user_pages() fails, typically
-	 * for use by special VMAs that can switch between memory and hardware
+	 * for use by special VMAs. See also generic_access_phys() for a generic
+	 * implementation useful for any iomem mapping.
 	 */
 	int (*access)(struct vm_area_struct *vma, unsigned long addr,
 		      void *buf, int len, int write);
diff --git a/mm/memory.c b/mm/memory.c
index fcfc4ca36eba..8d467e23b44e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4873,28 +4873,68 @@ int follow_phys(struct vm_area_struct *vma,
 	return ret;
 }
 
+/**
+ * generic_access_phys - generic implementation for iomem mmap access
+ * @vma: the vma to access
+ * @addr: userspace addres, not relative offset within @vma
+ * @buf: buffer to read/write
+ * @len: length of transfer
+ * @write: set to FOLL_WRITE when writing, otherwise reading
+ *
+ * This is a generic implementation for &vm_operations_struct.access for an
+ * iomem mapping. This callback is used by access_process_vm() when the @vma is
+ * not page based.
+ */
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write)
 {
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
 	int offset = addr & (PAGE_SIZE-1);
+	int ret = -EINVAL;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return -EINVAL;
+
+retry:
+	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
+		return -EINVAL;
+	pte = *ptep;
+	pte_unmap_unlock(ptep, ptl);
 
-	if (follow_phys(vma, addr, write, &prot, &phys_addr))
+	prot = pgprot_val(pte_pgprot(pte));
+	phys_addr = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
+
+	if ((write & FOLL_WRITE) && !pte_write(pte))
 		return -EINVAL;
 
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
 
+	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
+		goto out_unmap;
+
+	if (pte_same(pte, *ptep)) {
+		pte_unmap_unlock(ptep, ptl);
+		iounmap(maddr);
+
+		goto retry;
+	}
+
 	if (write)
 		memcpy_toio(maddr + offset, buf, len);
 	else
 		memcpy_fromio(buf, maddr + offset, len);
+	ret = len;
+	pte_unmap_unlock(ptep, ptl);
+out_unmap:
 	iounmap(maddr);
 
-	return len;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
-- 
2.28.0

