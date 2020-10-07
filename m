Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53FA28650A
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgJGQpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgJGQot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:44:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAECC0613D9
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:44:48 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j136so3139464wmj.2
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nwvirki0A8lJPE+AYl74w0fQ2EaO5tAbqC5bxM8kl0c=;
        b=BrDuHver6w7p5ZRQIzaxr9X28nldTZHPs6TeyR3rufkPUprK+7Pd7YvnCY9V+/ntoj
         rZAaEGBxdMEd6l9H14pKva/3vm5MWV5Hx2NleOTAHYs4Cd1KzpFCG+Sm6tIWC/JSTsWT
         wFRHzHOiKTlq+UBh4t8T/9Kw/KRf+ey2pudIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwvirki0A8lJPE+AYl74w0fQ2EaO5tAbqC5bxM8kl0c=;
        b=MtVgFHq/od27+XhdiU5QF5XpHdH/H/Pfg9qc96qesBj2mZzXfJBA/+PFI9A9V2H/a0
         42sQ31zVJmeBhh9jRdnNqaMbEbXn0WULcAVLeyUO0XAJKn0aP8DSJRMqNRHETjUFtisQ
         fuY5a3toYJBDQI+RmSXdqeZZRVXS1eI2roqsR7S8dX1tfzlYs6QgzITp/vK13bPc+5kN
         houakM0nttxNsAvc88eJpVAWwTldhsjvkl8gQR8/alZQ0B5NIZZxVilNR+R4ndA7fjfF
         2AtKAHzyTeRczvnNr3mgjqaNMhaBFboJ6VH22xtEO2gd8mlPXfdpV6wWgQDtKLyFuNIE
         frZw==
X-Gm-Message-State: AOAM530un93Fq96/OQ3VUIKPzOEa1kIAHdQn0X69Hy8l/SoV/jYE4voN
        PqMkLIsVWeQFd+tfLlF6EVlnkg==
X-Google-Smtp-Source: ABdhPJw1zUoIbUqRt+OcQIxyRCGoJAtVTtOUoH3PCLKd4mzA2jl8YcAArzeHuhJ7i3WhTCjkjS4Rxg==
X-Received: by 2002:a7b:c08c:: with SMTP id r12mr4042397wmh.184.1602089087475;
        Wed, 07 Oct 2020 09:44:47 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z191sm3332280wme.40.2020.10.07.09.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:44:46 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 10/13] PCI: revoke mappings like devmem
Date:   Wed,  7 Oct 2020 18:44:23 +0200
Message-Id: <20201007164426.1812530-11-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
the region") /dev/kmem zaps ptes when the kernel requests exclusive
acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
the default for all driver uses.

Except there's two more ways to access pci bars: sysfs and proc mmap
support. Let's plug that hole.

For revoke_devmem() to work we need to link our vma into the same
address_space, with consistent vma->vm_pgoff. ->pgoff is already
adjusted, because that's how (io_)remap_pfn_range works, but for the
mapping we need to adjust vma->vm_file->f_mapping. Usually that's done
at ->open time, but that's a bit tricky here with all the entry points
and arch code. So instead create a fake file and adjust vma->vm_file.

Note this only works for ARCH_GENERIC_PCI_MMAP_RESOURCE. But that
seems to be a subset of architectures support STRICT_DEVMEM, so we
should be good.

The only difference in access checks left is that sysfs pci mmap does
not check for CAP_RAWIO. But I think that makes some sense compared to
/dev/mem and proc, where one file gives you access to everything and
no ownership applies.

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
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/char/mem.c     | 16 +++++++++++++++-
 drivers/pci/mmap.c     |  3 +++
 include/linux/ioport.h |  2 ++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index abd4ffdc8cde..5e58a326d4ee 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -810,6 +810,7 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 }
 
 static struct inode *devmem_inode;
+static struct vfsmount *devmem_vfs_mount;
 
 #ifdef CONFIG_IO_STRICT_DEVMEM
 void revoke_devmem(struct resource *res)
@@ -843,6 +844,20 @@ void revoke_devmem(struct resource *res)
 
 	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1);
 }
+
+struct file *devmem_getfile(void)
+{
+	struct file *file;
+
+	file = alloc_file_pseudo(devmem_inode, devmem_vfs_mount, "devmem",
+				 O_RDWR, &kmem_fops);
+	if (IS_ERR(file))
+		return NULL;
+
+	file->f_mapping = devmem_indoe->i_mapping;
+
+	return file;
+}
 #endif
 
 static int open_port(struct inode *inode, struct file *filp)
@@ -1010,7 +1025,6 @@ static struct file_system_type devmem_fs_type = {
 
 static int devmem_init_inode(void)
 {
-	static struct vfsmount *devmem_vfs_mount;
 	static int devmem_fs_cnt;
 	struct inode *inode;
 	int rc;
diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
index b8c9011987f4..63786cc9c746 100644
--- a/drivers/pci/mmap.c
+++ b/drivers/pci/mmap.c
@@ -7,6 +7,7 @@
  * Author: David Woodhouse <dwmw2@infradead.org>
  */
 
+#include <linux/file.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
@@ -64,6 +65,8 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 		vma->vm_pgoff += (pci_resource_start(pdev, bar) >> PAGE_SHIFT);
 
 	vma->vm_ops = &pci_phys_vm_ops;
+	fput(vma->vm_file);
+	vma->vm_file = devmem_getfile();
 
 	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				  vma->vm_end - vma->vm_start,
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 6c2b06fe8beb..83238cba19fe 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -304,8 +304,10 @@ struct resource *request_free_mem_region(struct resource *base,
 
 #ifdef CONFIG_IO_STRICT_DEVMEM
 void revoke_devmem(struct resource *res);
+struct file *devm_getfile(void);
 #else
 static inline void revoke_devmem(struct resource *res) { };
+static inline struct file *devmem_getfile(void) { return NULL; };
 #endif
 
 #endif /* __ASSEMBLY__ */
-- 
2.28.0

