Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D12B9547
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 15:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgKSOmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 09:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgKSOmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 09:42:12 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6564CC0613D4
        for <kvm@vger.kernel.org>; Thu, 19 Nov 2020 06:42:12 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 23so6669466wrc.8
        for <kvm@vger.kernel.org>; Thu, 19 Nov 2020 06:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0DCehF4zZ3fhQRejLB/8aYMpRa95wWTeDCqZJ49ug5U=;
        b=i1Sv/jjKYQNSH5Pz1p4TGEKHSE0hAsyjZLamNltZNlFfnx9kl1jNBiB7w7S5eMBcEx
         E2grbscvm5lSzF9JX11ScuBzFqjEJLeR8ycnUqFVbKeoeXJ7FGw5EgP4pWvc8Lt+7BCO
         wM8PlYMmj8jYsifflCGxslxUT8/cqKq33xazI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0DCehF4zZ3fhQRejLB/8aYMpRa95wWTeDCqZJ49ug5U=;
        b=RYbjZOwf9B9dqjwE+jXzsmJ1nqbkJUeHIIsJPxYXreHTNeO5N9ieh4hidemaN5ZDkj
         +ZhK8Ck2yUqQJrm1s2/BoV11LuQLUu4LEfE7B9YXubZ2o1askQ/iRdsUbdFRIaI7OBdB
         Amjep1KXEHK/tSONb4kZBkoHvB4RV1+abmRhbB6HBQIZ+hUBUSUPSec1gKPq7f8pqzhM
         wat4MDWlz28Uzh2NS2VA8OT+AGbl0nfJNE8NE3H3Uzda5/anSZFx3y8uW6/nk5zeuXyw
         8kRAn7C7E1hMp0SgGR/Zt1kM7GJuoamxZCUDaBOLUHPseCuMOAYAlCuvQkI5DYDMGiw4
         /HzA==
X-Gm-Message-State: AOAM531zePvsiLF4QakLCnpGecR38MMLwhMA1L5UZUOOdSJf9wHPJTuH
        dPQWQJb1Sz2PUBbxmEiv0z0SLQ==
X-Google-Smtp-Source: ABdhPJwRDiYEVmrnM9D+VsbIGMAPURrigSEJrBogS0M9J7biGvurleAJJ9e0+X8pidbyd6ZTdX7+3w==
X-Received: by 2002:adf:c452:: with SMTP id a18mr10837202wrg.189.1605796931124;
        Thu, 19 Nov 2020 06:42:11 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id x63sm51292wmb.48.2020.11.19.06.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:42:10 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v6 13/17] resource: Move devmem revoke code to resource framework
Date:   Thu, 19 Nov 2020 15:41:42 +0100
Message-Id: <20201119144146.1045202-14-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want all iomem mmaps to consistently revoke ptes when the kernel
takes over and CONFIG_IO_STRICT_DEVMEM is enabled. This includes the
pci bar mmaps available through procfs and sysfs, which currently do
not revoke mappings.

To prepare for this, move the code from the /dev/kmem driver to
kernel/resource.c.

During review Jason spotted that barriers are used somewhat
inconsistently. Fix that up while we shuffle this code, since it
doesn't have an actual impact at runtime. Otherwise no semantic and
behavioural changes intended, just code extraction and adjusting
comments and names.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
--
v3:
- add barrier for consistency and document why we don't have to check
  for NULL (Jason)
v4
- Adjust comments to reflect the general nature of this iomem revoke
  code now (Dan)
v6:
- An unintentional change which caused side-effects of this
  refactoring is that iomem_get_mapping returned NULL for
  !CONFIG_IO_STRICT_DEVMEM. But that makes core vfs code blow up,
  which assumes a mapping always exists. Undo that accidentional
  change. Reported by John.
- Augment the commit message to explain what actually changed with
  this extraction (also John).
---
 drivers/char/mem.c     | 85 +-----------------------------------
 include/linux/ioport.h |  6 +--
 kernel/resource.c      | 98 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 99 insertions(+), 90 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 7dcf9e4ea79d..43c871dc7477 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -31,9 +31,6 @@
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/security.h>
-#include <linux/pseudo_fs.h>
-#include <uapi/linux/magic.h>
-#include <linux/mount.h>
 
 #ifdef CONFIG_IA64
 # include <linux/efi.h>
@@ -836,42 +833,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	return ret;
 }
 
-static struct inode *devmem_inode;
-
-#ifdef CONFIG_IO_STRICT_DEVMEM
-void revoke_devmem(struct resource *res)
-{
-	/* pairs with smp_store_release() in devmem_init_inode() */
-	struct inode *inode = smp_load_acquire(&devmem_inode);
-
-	/*
-	 * Check that the initialization has completed. Losing the race
-	 * is ok because it means drivers are claiming resources before
-	 * the fs_initcall level of init and prevent /dev/mem from
-	 * establishing mappings.
-	 */
-	if (!inode)
-		return;
-
-	/*
-	 * The expectation is that the driver has successfully marked
-	 * the resource busy by this point, so devmem_is_allowed()
-	 * should start returning false, however for performance this
-	 * does not iterate the entire resource range.
-	 */
-	if (devmem_is_allowed(PHYS_PFN(res->start)) &&
-	    devmem_is_allowed(PHYS_PFN(res->end))) {
-		/*
-		 * *cringe* iomem=relaxed says "go ahead, what's the
-		 * worst that can happen?"
-		 */
-		return;
-	}
-
-	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1);
-}
-#endif
-
 static int open_port(struct inode *inode, struct file *filp)
 {
 	int rc;
@@ -891,7 +852,7 @@ static int open_port(struct inode *inode, struct file *filp)
 	 * revocations when drivers want to take over a /dev/mem mapped
 	 * range.
 	 */
-	filp->f_mapping = inode->i_mapping;
+	filp->f_mapping = iomem_get_mapping();
 
 	return 0;
 }
@@ -1023,48 +984,6 @@ static char *mem_devnode(struct device *dev, umode_t *mode)
 
 static struct class *mem_class;
 
-static int devmem_fs_init_fs_context(struct fs_context *fc)
-{
-	return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
-}
-
-static struct file_system_type devmem_fs_type = {
-	.name		= "devmem",
-	.owner		= THIS_MODULE,
-	.init_fs_context = devmem_fs_init_fs_context,
-	.kill_sb	= kill_anon_super,
-};
-
-static int devmem_init_inode(void)
-{
-	static struct vfsmount *devmem_vfs_mount;
-	static int devmem_fs_cnt;
-	struct inode *inode;
-	int rc;
-
-	rc = simple_pin_fs(&devmem_fs_type, &devmem_vfs_mount, &devmem_fs_cnt);
-	if (rc < 0) {
-		pr_err("Cannot mount /dev/mem pseudo filesystem: %d\n", rc);
-		return rc;
-	}
-
-	inode = alloc_anon_inode(devmem_vfs_mount->mnt_sb);
-	if (IS_ERR(inode)) {
-		rc = PTR_ERR(inode);
-		pr_err("Cannot allocate inode for /dev/mem: %d\n", rc);
-		simple_release_fs(&devmem_vfs_mount, &devmem_fs_cnt);
-		return rc;
-	}
-
-	/*
-	 * Publish /dev/mem initialized.
-	 * Pairs with smp_load_acquire() in revoke_devmem().
-	 */
-	smp_store_release(&devmem_inode, inode);
-
-	return 0;
-}
-
 static int __init chr_dev_init(void)
 {
 	int minor;
@@ -1086,8 +1005,6 @@ static int __init chr_dev_init(void)
 		 */
 		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
 			continue;
-		if ((minor == DEVMEM_MINOR) && devmem_init_inode() != 0)
-			continue;
 
 		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
 			      NULL, devlist[minor].name);
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5135d4b86cd6..02a5466245c0 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -307,11 +307,7 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 struct resource *request_free_mem_region(struct resource *base,
 		unsigned long size, const char *name);
 
-#ifdef CONFIG_IO_STRICT_DEVMEM
-void revoke_devmem(struct resource *res);
-#else
-static inline void revoke_devmem(struct resource *res) { };
-#endif
+extern struct address_space *iomem_get_mapping(void);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 3ae2f56cc79d..c3d71db7a40e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -18,12 +18,15 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/pfn.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/resource_ext.h>
+#include <uapi/linux/magic.h>
 #include <asm/io.h>
 
 
@@ -1115,6 +1118,55 @@ resource_size_t resource_alignment(struct resource *res)
 
 static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
 
+static struct inode *iomem_inode;
+
+#ifdef CONFIG_IO_STRICT_DEVMEM
+static void revoke_iomem(struct resource *res)
+{
+	/* pairs with smp_store_release() in iomem_init_inode() */
+	struct inode *inode = smp_load_acquire(&iomem_inode);
+
+	/*
+	 * Check that the initialization has completed. Losing the race
+	 * is ok because it means drivers are claiming resources before
+	 * the fs_initcall level of init and prevent iomem_get_mapping users
+	 * from establishing mappings.
+	 */
+	if (!inode)
+		return;
+
+	/*
+	 * The expectation is that the driver has successfully marked
+	 * the resource busy by this point, so devmem_is_allowed()
+	 * should start returning false, however for performance this
+	 * does not iterate the entire resource range.
+	 */
+	if (devmem_is_allowed(PHYS_PFN(res->start)) &&
+	    devmem_is_allowed(PHYS_PFN(res->end))) {
+		/*
+		 * *cringe* iomem=relaxed says "go ahead, what's the
+		 * worst that can happen?"
+		 */
+		return;
+	}
+
+	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1);
+}
+#else
+static void revoke_iomem(struct resource *res) {}
+#endif
+
+struct address_space *iomem_get_mapping(void)
+{
+	/*
+	 * This function is only called from file open paths, hence guaranteed
+	 * that fs_initcalls have completed and no need to check for NULL. But
+	 * since revoke_iomem can be called before the initcall we still need
+	 * the barrier to appease checkers.
+	 */
+	return smp_load_acquire(&iomem_inode)->i_mapping;
+}
+
 /**
  * __request_region - create a new busy resource region
  * @parent: parent resource descriptor
@@ -1182,7 +1234,7 @@ struct resource * __request_region(struct resource *parent,
 	write_unlock(&resource_lock);
 
 	if (res && orig_parent == &iomem_resource)
-		revoke_devmem(res);
+		revoke_iomem(res);
 
 	return res;
 }
@@ -1782,4 +1834,48 @@ static int __init strict_iomem(char *str)
 	return 1;
 }
 
+static int iomem_fs_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
+}
+
+static struct file_system_type iomem_fs_type = {
+	.name		= "iomem",
+	.owner		= THIS_MODULE,
+	.init_fs_context = iomem_fs_init_fs_context,
+	.kill_sb	= kill_anon_super,
+};
+
+static int __init iomem_init_inode(void)
+{
+	static struct vfsmount *iomem_vfs_mount;
+	static int iomem_fs_cnt;
+	struct inode *inode;
+	int rc;
+
+	rc = simple_pin_fs(&iomem_fs_type, &iomem_vfs_mount, &iomem_fs_cnt);
+	if (rc < 0) {
+		pr_err("Cannot mount iomem pseudo filesystem: %d\n", rc);
+		return rc;
+	}
+
+	inode = alloc_anon_inode(iomem_vfs_mount->mnt_sb);
+	if (IS_ERR(inode)) {
+		rc = PTR_ERR(inode);
+		pr_err("Cannot allocate inode for iomem: %d\n", rc);
+		simple_release_fs(&iomem_vfs_mount, &iomem_fs_cnt);
+		return rc;
+	}
+
+	/*
+	 * Publish iomem revocation inode initialized.
+	 * Pairs with smp_load_acquire() in revoke_iomem().
+	 */
+	smp_store_release(&iomem_inode, inode);
+
+	return 0;
+}
+
+fs_initcall(iomem_init_inode);
+
 __setup("iomem=", strict_iomem);
-- 
2.29.2

