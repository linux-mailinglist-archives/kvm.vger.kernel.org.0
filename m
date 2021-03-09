Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38763320D7
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCIIg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCIIgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:36:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8DC06174A;
        Tue,  9 Mar 2021 00:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1nJO4XTKt7zFVdztSkFpRJqlqh8a16sejG+dCghcYvg=; b=k0+T7doXzkMCgq8tMaaEpGRr87
        QzqYywz/YSEgroYM7hAoH60RO0jwfZFoa1odGMIfreObTgvGg6Na9qjKuvDfQ7utlHfZVLtGpLqsn
        zRGjb+4Ciqgp36oxAf9UrKLtdvTDGE6TZucWq4aa+klHVq+Jbn6k/zhIRh5nNsOU0F2QnSQYI/glr
        OZAV8vjXI2/dOy15IqLocAjwsW1BWKzrIFSpqpq6LVC77ZxtQ660ROt0zVjkNL59SmPxXnp0PtaUu
        73TzL1CpIDhWnhZkmLILd6EI4WApkaN4TuwzVEFFQdtvUsQ34JNEMxLRNJPNBGOiKzpmo77CW2GOZ
        pLbt+ETQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJXr7-000FPy-IN; Tue, 09 Mar 2021 08:36:43 +0000
Date:   Tue, 9 Mar 2021 08:36:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per device
Message-ID: <20210309083641.GB55734@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524004828.3480.1817334832614722574.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524004828.3480.1817334832614722574.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:47:28PM -0700, Alex Williamson wrote:
> By linking all the device fds we provide to userspace to an
> address space through a new pseudo fs, we can use tools like
> unmap_mapping_range() to zap all vmas associated with a device.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

I'd much prefer to just piggy back on the anon_inode fs rather than
duplicating this logic all over.  Something like the trivial patch below
should be all that is needed:

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index a280156138ed89..6fe404aab0f0dd 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -225,6 +225,12 @@ int anon_inode_getfd_secure(const char *name, const struct file_operations *fops
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd_secure);
 
+struct inode *alloc_anon_inode_simple(void)
+{
+	return alloc_anon_inode(anon_inode_mnt->mnt_sb);
+}
+EXPORT_SYMBOL_GPL(alloc_anon_inode_simple);
+
 static int __init anon_inode_init(void)
 {
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index 71881a2b6f7860..6b2fb7d0abc57a 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -21,6 +21,7 @@ int anon_inode_getfd_secure(const char *name,
 			    const struct file_operations *fops,
 			    void *priv, int flags,
 			    const struct inode *context_inode);
+struct inode *alloc_anon_inode_simple(void);
 
 #endif /* _LINUX_ANON_INODES_H */
 
