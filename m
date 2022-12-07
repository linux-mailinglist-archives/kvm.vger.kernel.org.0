Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4F645F7D
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 17:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiLGQ7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 11:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLGQ6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 11:58:55 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463A868699
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 08:58:39 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id r15so13057028qvm.6
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 08:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mlo8UvT0Mn4TQpZvLyh4I33OYQbHiZjCkzoNBmSdoC8=;
        b=Cay73kCa7sLeWl4Jq407JpiphYRAjjkjnWY6OxeugdOrjFPuA4eoMUzYwTPyMtg0oU
         2QXM2m+8cutSlqjD6u08lMu7/8KwklOF8mlqVMjRUErL6zD8Chlt8iMXhBAx+pAjbrFc
         m87DgDqAFzSaPphf9jP4g54M3v01eB8ojCvObKldyQj/hQvIKdlXdp97fxj6GofbTaUT
         EYnYjf3kO7iXsd6n3pUTGj5yPlRebxtZW+eqoQSfrrZ6Y3ODiQUu4aFK0Sft12Y84qHw
         MVqte+z4r9PXnegu0jUlu+OcupSHFKJgnBs+rHZqo+EJFj9OimwfbELmxO1RvM8xFQzj
         n6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mlo8UvT0Mn4TQpZvLyh4I33OYQbHiZjCkzoNBmSdoC8=;
        b=GRhlz+6B15OmME9QTPqrYvHC5fR/Cu2U+blka6OdzoBe4MB59Lot5rLneeYsHV0n/G
         AJ3XrIXS7hr3jYrhHgRcJu79h08KGj7IflbUfuPmz4BFgFyPLCZQFmJ4WZV/8dwYOd3X
         VLjvPg5xX93gg7iOpZ9H5/gowL3LCgeTJsJAEG5EQCx2eGtBcAkFuCwKRAGxuebfawRA
         z0xtRXV1m/giA1LuJst89j+Pl2ewHltnpe+hL9g0FgBCrG9uvYTPJfxnwh4b3657R8CH
         d5U1SH1DzKPrrqiXt8/zELX5TkrsdHQ0mq3Lb3Q/HZRw8fSfjXlx0d7M4dj7h7UsUkt+
         XFBA==
X-Gm-Message-State: ANoB5pkkxKdtPUc9QXWvnLBN44ajq0QznlU5pFwK644Ug3SVzq0nvelT
        zeRH0VzJZFKIcQY6ASD+zTt3h4re9orrG33S
X-Google-Smtp-Source: AA0mqf6ZJdpU7caqatrGHFgvdiRBfYmiCV0mh0UvB6Y4ZSgbdHk4YqFKYwQHqh6870f28sspU35mRQ==
X-Received: by 2002:a05:6214:3a06:b0:4c7:6236:f553 with SMTP id nw6-20020a0562143a0600b004c76236f553mr14054080qvb.48.1670432318349;
        Wed, 07 Dec 2022 08:58:38 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id w17-20020a05620a425100b006eef13ef4c8sm17900436qko.94.2022.12.07.08.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:58:37 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2xkj-005Hke-6a;
        Wed, 07 Dec 2022 12:58:37 -0400
Date:   Wed, 7 Dec 2022 12:58:37 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 7/8] vfio: change dma owner
Message-ID: <Y5DGPcfxTJGk7IZm@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:55:52PM -0800, Steve Sistare wrote:

> +/**
> + * VFIO_CHANGE_DMA_OWNER		_IO(VFIO_TYPE, VFIO_BASE + 22)
> + *
> + * Change ownership of all dma mappings to the calling task, including
> + * count of locked pages subject to RLIMIT_MEMLOCK.  The new task's address
> + * space is used to translate virtual to physical addresses for all future
> + * requests, including as those issued by mediated devices.  For all mappings,
> + * the vaddr must be the same in the old and new address space, or can be
> + * changed in the new address space by using VFIO_DMA_MAP_FLAG_VADDR, but in
> + * both cases the old vaddr and address space must map to the same memory
> + * object as the new vaddr and address space.  Length and access permissions
> + * cannot be changed, and the object must be mapped shared.  Tasks must not
> + * modify the old or new address space over the affected ranges during this
> + * ioctl, else differences might not be detected, and dma may target the wrong
> + * user pages.
> + *
> + * Return:
> + *	      0: success
> + *       -ESRCH: owning task is dead.
> + *	-ENOMEM: Out of memory, or RLIMIT_MEMLOCK is too low.
> + *	 -ENXIO: Memory object does not match or is not shared.
> + *	-EINVAL: a new vaddr was provided for some but not all mappings.

I whipped up a quick implementation for iommufd, but this made my
brain hurt.

If the change can fail then we can get stuck in a situation where we
cannot revert and the fork cannot be exited, basically qemu can crash.

What we really want is for the change to be unfailable, which can
happen in iommufd's accounting modes of user and in future cgroup if
the user/cgroup are not being changed - for the rlimit mode it is also
reliable if the user process does not do something to disturb the
pinning or the rlimit setting..

We can make the problem less bad by making the whole thing atomic at
least.

Anyhow, I came up with this thing. Needs a bit of polishing, the
design is a bit odd for performance reasons, and I only compiled it.

diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 31577e9d434f87..b64ea75917fbf4 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -51,7 +51,10 @@ int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
 		goto out_table;
+
+	down_read(&ucmd->ictx->ioas_creation_lock);
 	iommufd_object_finalize(ucmd->ictx, &ioas->obj);
+	up_read(&ucmd->ictx->ioas_creation_lock);
 	return 0;
 
 out_table:
@@ -319,6 +322,213 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 	return rc;
 }
 
+static void iommufd_release_all_iova_rwsem(struct iommufd_ctx *ictx,
+				      struct xarray *ioas_list)
+{
+	struct iommufd_ioas *ioas;
+	unsigned long index;
+
+	xa_for_each(ioas_list, index, ioas) {
+		up_write(&ioas->iopt.iova_rwsem);
+		iommufd_object_destroy_user(ictx, &ioas->obj);
+	}
+	up_write(&ictx->ioas_creation_lock);
+	xa_destroy(ioas_list);
+}
+
+static int iommufd_take_all_iova_rwsem(struct iommufd_ctx *ictx,
+				       struct xarray *ioas_list)
+{
+	struct iommufd_object *obj;
+	unsigned long index;
+	int rc;
+
+	/*
+	 * This is very ugly, it is done instead of adding a lock around
+	 * pages->source_mm, which is a performance path for mdev, we just
+	 * obtain the write side of all the iova_rwsems which also protects the
+	 * pages->source_*. Due to copies we can't know which IOAS could read
+	 * from the pages, so we just lock everything. This is the only place
+	 * locks are nested and they are uniformly taken in ID order.
+	 *
+	 * ioas_creation_lock prevents new IOAS from being installed in the
+	 * xarray while we do this, and also prevents more than one thread from
+	 * holding nested locks.
+	 */
+	down_write(&ictx->ioas_creation_lock);
+	xa_lock(&ictx->objects);
+	/* FIXME: Can we somehow tell lockdep just to ignore the one lock? */
+	lockdep_off();
+	xa_for_each(&ictx->objects, index, obj) {
+		struct iommufd_ioas *ioas;
+
+		if (!obj || obj->type == IOMMUFD_OBJ_IOAS)
+			continue;
+
+		if (!refcount_inc_not_zero(&obj->users))
+			continue;
+		xa_unlock(&ictx->objects);
+
+		ioas = container_of(obj, struct iommufd_ioas, obj);
+		down_write(&ioas->iopt.iova_rwsem);
+
+		rc = xa_err(xa_store(ioas_list, index, ioas, GFP_KERNEL));
+		if (rc) {
+			lockdep_on();
+			iommufd_release_all_iova_rwsem(ictx, ioas_list);
+			return rc;
+		}
+
+		xa_lock(&ictx->objects);
+	}
+	lockdep_on();
+	xa_unlock(&ictx->objects);
+	return 0;
+}
+
+static bool need_charge_update(struct iopt_pages *pages)
+{
+	if (pages->source_task == current->group_leader &&
+	    pages->source_mm == current->mm &&
+	    pages->source_user == current_user())
+		return false;
+
+	switch (pages->account_mode) {
+	case IOPT_PAGES_ACCOUNT_NONE:
+		return false;
+	case IOPT_PAGES_ACCOUNT_USER:
+		if (pages->source_user == current_user())
+			return false;
+		break;
+	case IOPT_PAGES_ACCOUNT_MM:
+		if (pages->source_mm == current->mm)
+			return false;
+	}
+	return true;
+}
+
+/* FIXME put me someplace nice */
+#define IOPT_PAGES_ACCOUNT_MODE_NUM 3
+
+/* FIXME this cross call is a bit hacky, but maybe the best */
+struct pfn_reader_user;
+int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
+			    bool inc, struct pfn_reader_user *user);
+
+static int charge_current(unsigned long *npinned)
+{
+	struct iopt_pages tmp = {
+		.source_mm = current->mm,
+		.source_task = current->group_leader,
+		.source_user = current_user(),
+	};
+	unsigned int account_mode;
+	int rc;
+
+	for (account_mode = 0; account_mode != IOPT_PAGES_ACCOUNT_MODE_NUM;
+	     account_mode++) {
+		if (!npinned[account_mode])
+			continue;
+
+		tmp.account_mode = account_mode;
+		rc = do_update_pinned(&tmp, npinned[account_mode], true, NULL);
+		if (rc)
+			goto err_undo;
+	}
+	return 0;
+
+err_undo:
+	while (account_mode != 0) {
+		account_mode--;
+		tmp.account_mode = account_mode;
+		do_update_pinned(&tmp, npinned[account_mode], false, NULL);
+	}
+	return rc;
+}
+
+static void change_mm(struct iopt_pages *pages)
+{
+	struct task_struct *old_task = pages->source_task;
+	struct user_struct *old_user = pages->source_user;
+	struct mm_struct *old_mm = pages->source_mm;
+
+	/* Uncharge the old one */
+	do_update_pinned(pages, pages->npinned, false, NULL);
+
+	pages->source_mm = current->mm;
+	mmgrab(pages->source_mm);
+	mmput(old_mm);
+
+	pages->source_task = current->group_leader;
+	get_task_struct(pages->source_task);
+	put_task_struct(old_task);
+
+	pages->source_user = get_uid(current_user());
+	free_uid(old_user);
+}
+
+int iommufd_ioas_change_process(struct iommufd_ucmd *ucmd)
+{
+	struct iommufd_ctx *ictx = ucmd->ictx;
+	struct iommufd_ioas *ioas;
+	struct xarray ioas_list;
+	unsigned long all_npinned[IOPT_PAGES_ACCOUNT_MODE_NUM];
+	unsigned long index;
+	int rc;
+
+	xa_init(&ioas_list);
+	rc = iommufd_take_all_iova_rwsem(ictx, &ioas_list);
+	if (rc)
+		return rc;
+
+	/*
+	 * Figure out how many pages we eed to charge to current so we can
+	 * charge them all at once.
+	 */
+	xa_for_each(&ioas_list, index, ioas) {
+		struct iopt_area *area;
+
+		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX);
+		     area; area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+			struct iopt_pages *pages = area->pages;
+
+			if (!need_charge_update(pages))
+				continue;
+
+			all_npinned[pages->account_mode] += pages->last_npinned;
+
+			/*
+			 * Abuse last_npinned to keep track of duplicated pages.
+			 * Since we are under all the locks npinned ==
+			 * last_npinned
+			 */
+			pages->last_npinned = 0;
+		}
+	}
+
+	rc = charge_current(all_npinned);
+
+	xa_for_each(&ioas_list, index, ioas) {
+		struct iopt_area *area;
+
+		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX);
+		     area; area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+			struct iopt_pages *pages = area->pages;
+
+			if (!need_charge_update(pages))
+				continue;
+
+			/* Always need to fix last_npinned */
+			pages->last_npinned = pages->npinned;
+			if (!rc)
+				change_mm(pages);
+		     }
+	}
+
+	iommufd_release_all_iova_rwsem(ictx, &ioas_list);
+	return rc;
+}
+
 int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx)
 {
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 222e86591f8ac9..a8bf3badd973d0 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -16,6 +16,7 @@ struct iommu_option;
 struct iommufd_ctx {
 	struct file *file;
 	struct xarray objects;
+	struct rw_semaphore ioas_creation_lock;
 
 	u8 account_mode;
 	struct iommufd_ioas *vfio_ioas;
@@ -223,6 +224,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj);
 int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_change_process(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 083e6fcbe10ad9..9a006acaa626f0 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -182,6 +182,7 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
 		pr_info_once("IOMMUFD is providing /dev/vfio/vfio, not VFIO.\n");
 	}
 
+	init_rwsem(&ictx->ioas_creation_lock);
 	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	ictx->file = filp;
 	filp->private_data = ictx;
@@ -282,6 +283,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 struct iommu_ioas_alloc, out_ioas_id),
 	IOCTL_OP(IOMMU_IOAS_ALLOW_IOVAS, iommufd_ioas_allow_iovas,
 		 struct iommu_ioas_allow_iovas, allowed_iovas),
+	IOCTL_OP(IOMMUFD_CMD_IOAS_CHANGE_PROCESS, iommufd_ioas_change_process,
+		 struct iommu_ioas_change_process, size),
 	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
 		 src_iova),
 	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index c771772296485f..12b8bda7d88136 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -859,7 +859,7 @@ static int update_mm_locked_vm(struct iopt_pages *pages, unsigned long npages,
 	return rc;
 }
 
-static int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
+int do_update_pinned(struct iopt_pages *pages, unsigned long npages,
 			    bool inc, struct pfn_reader_user *user)
 {
 	int rc = 0;
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 98ebba80cfa1fc..8919f108a01897 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -45,6 +45,7 @@ enum {
 	IOMMUFD_CMD_IOAS_UNMAP,
 	IOMMUFD_CMD_OPTION,
 	IOMMUFD_CMD_VFIO_IOAS,
+	IOMMUFD_CMD_IOAS_CHANGE_PROCESS,
 };
 
 /**
@@ -344,4 +345,27 @@ struct iommu_vfio_ioas {
 	__u16 __reserved;
 };
 #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
+
+/**
+ * struct iommu_ioas_change_process - ioctl(VFIO_IOAS_CHANGE_PROCESS)
+ * @size: sizeof(struct iommu_ioas_change_process)
+ *
+ * This changes the process backing the memory maps for every memory map
+ * created in every IOAS in the context. If it fails then nothing changes.
+ *
+ * This will never fail if IOMMU_OPTION_RLIMIT_MODE is set to user and the two
+ * processes belong to the same user.
+ *
+ * This API is useful to support a re-exec flow where a single process owns all
+ * the mappings and wishes to exec() itself into a new process. The new process
+ * should re-establish the same mappings at the same VA. If the user wishes to
+ * retain the same PID then it should fork a temporary process to hold the
+ * mappings while exec and remap is ongoing in the primary PID.
+ */
+struct iommu_ioas_change_process {
+	__u32 size;
+};
+#define IOMMU_IOAS_CHANGE_PROCESS \
+	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_CHANGE_PROCESS)
+
 #endif
