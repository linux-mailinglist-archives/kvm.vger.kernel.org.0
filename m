Return-Path: <kvm+bounces-71548-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yFsxD9DinGnrLwQAu9opvQ
	(envelope-from <kvm+bounces-71548-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:29:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2B117F70D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 30A9230426BD
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01CB37F8D1;
	Mon, 23 Feb 2026 23:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tlTa2Pl7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6632737F8A5
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889263; cv=none; b=O7hDqMWV7pMw0Dj4ciZKpuRiKEhr2Y5BZNkS+XNp4q0oMjUGb2WlUsyQvPhRwcts3K3zm2eALnIpSUnLwmgchhhXf2AL/LiHmnIApIP+LvKO3gHZ9OBIVSMG/oQzWmoXr+HWHdudx0GirzGTG0NqBnXEAyS8E/AuR9S8kmStxjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889263; c=relaxed/simple;
	bh=xEee9cxbr7GG38D2/dBLujjBWCXTmk4ZStmSNh98uT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shtYr5be1DD74C64o85ovBGwjvdD2w2XkDjWCCLfqbFNG+5CCp9a6+zZHunzvd/l2Y3lhOJ7ILKMfv++fYf2JhePqbYPjxAbZUUO+mLodhrmEsLHjTk1WFHwZHGkNiqbL/5fmLXVKhfg7CqOdN9/APvrGnCD/+3S/1UDj7WOAVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tlTa2Pl7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a964077671so31995ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 15:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771889261; x=1772494061; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9xRDS+GbzpVTn5dJQsaYxoqI8Nli76XDWLyH8tQ4yc=;
        b=tlTa2Pl7yC8vFqnCUdHPSyXCbNU1emA/dEGUWJC/oKyPsaajyUG4UwEKed4XzIYF+w
         +g9tcjoJRBapjLzSfCp93HZkgqeb2WoHR4bEPXMkS8CTV1ak7YDFYwMs6WLSf9dC1QOF
         1D/gjmzWawCjI1PRJduJSxx6s7Xams/1mwVfjs8jwsNfx8I/fzPrZl88VkdcHR1/LX86
         oNOYWTy0MLFOCBrgjqCPqEOYw3HwFHF/fVAsSPQJflTFyQvMoOS/uVzJCWq1AwYYSSj/
         oi3bxrNsPpzr1+JlZgQv4vbnMYNor9fu3mkaY50XOg83Bp30zq5eiUPG0G7seIEI7/Cl
         X85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771889261; x=1772494061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9xRDS+GbzpVTn5dJQsaYxoqI8Nli76XDWLyH8tQ4yc=;
        b=OpklZUl8ebGa9JnCSuvWRxWYCQiRZOmFo1+s3Q/X/solDVTjl4g/K76YhuVyzy8tYj
         XeT8wE/t0tzPK5fOR7DLy8mKc1eTg2mc4qL/LvLdYSt5D4PdIKTF1Bfp3X6BDYQflEJb
         l+UTEib8rClhj5kN4BYt5G67t1JBYXIQM3+LdLMoWHLleeKzwx6fGy/PWMbjrKa4smKr
         mv7i0FIxgDY0SqqCeFz+HOE352n2QONumafTbUdvF69zzPFnPAIWKe/aBc+lmhBD+knd
         SwYYez/3pSZFKZ7HBz2r/alLNwVF10T6M+wHQthH7HQEo51kb/tSxrUdOeXtseEF01FG
         vs4g==
X-Forwarded-Encrypted: i=1; AJvYcCXRd1HWxrOfvRFNQyQ9xpXQY7PQaCP9V4VY9x8uxQlpzA1Si4STrrWbqUJD4lCHg1EKCQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK2LpDuMob/eZBUMl8HwTt96zGY0m6l1PFMIQhNsUmK/fYPMgZ
	5zG3zOLC7MKbi0VEdOH/+DvF0z1edUckgRehT+CZP13nzWsC1AW7mUVK41RGNHusAg==
X-Gm-Gg: ATEYQzxMDH5Znx3L+0xVnB8uCXEJqgx8EyF6cO1rjHh9BPwo4CcUplRPOvO7Tx6oR2M
	oqYv9ZJbMFqGqb5ZMNmP4ORohC41PhtPWcUpwYvE0BiWtDhs91WTZGRCf4IoUud5Ico6xSAqKUh
	G3ZM7bBFF25E+lloWn/J114NIdM8v4WC8JhNQIW3uTfuEhbjkuTEL+hWvDI9S7AT5z6owZGzNa8
	+W6mF/GdApZsDHU+twQSIUziJZWZYOdFTcqC21DG8mHUgo2Qmq6herItJY66epIcK/UadgARoGG
	6pTjaxTzuIUJxiTtmv/OXIKgQR/96kQ17jJMWoyh+d3qeH2JCzlR+5GdhVX2RxlvmlUdFnXXka9
	VIiFY9RGCw+EFhOrt0mhXiUZmuFtHQppRIUTccl0KOsvggFs4MeyqcrWgfOVlA5aZPcydc95mR5
	GNT6n9J3iyM5c+WTx+eMud7JOHk6vX/MMCsQm7nnKxRzEaxifEiAJE2MzAwJVI0A==
X-Received: by 2002:a17:903:1968:b0:2a0:89b0:71d6 with SMTP id d9443c01a7336-2ada34bcd22mr245115ad.17.1771889260189;
        Mon, 23 Feb 2026 15:27:40 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e318sm81858705ad.43.2026.02.23.15.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 15:27:39 -0800 (PST)
Date: Mon, 23 Feb 2026 23:27:35 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <bz7mhzvgawf4loxbv74iodj6aaf4e2snlb7szgjk2lia2uxnhr@dcp3m3jl3i63>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-7-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-7-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71548-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA2B117F70D
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:53PM +0000, David Matlack wrote:
>From: Vipin Sharma <vipinsh@google.com>
>
>Enable userspace to retrieve preserved VFIO device files from VFIO after
>a Live Update by implementing the retrieve() and finish() file handler
>callbacks.
>
>Use an anonymous inode when creating the file, since the retrieved
>device file is not opened through any particular cdev inode, and the
>cdev inode does not matter in practice.
>
>For now the retrieved file is functionally equivalent a opening the
>corresponding VFIO cdev file. Subsequent commits will leverage the
>preserved state associated with the retrieved file to preserve bits of
>the device across Live Update.
>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/vfio/device_cdev.c             | 21 ++++++---
> drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
> drivers/vfio/vfio_main.c               | 13 ++++++
> include/linux/vfio.h                   | 12 ++++++
> 4 files changed, 98 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>index 8ceca24ac136..935f84a35875 100644
>--- a/drivers/vfio/device_cdev.c
>+++ b/drivers/vfio/device_cdev.c
>@@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
> 	device->cdev.owner = THIS_MODULE;
> }
>
>-/*
>- * device access via the fd opened by this function is blocked until
>- * .open_device() is called successfully during BIND_IOMMUFD.
>- */
>-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
> {
>-	struct vfio_device *device = container_of(inode->i_cdev,
>-						  struct vfio_device, cdev);
> 	struct vfio_device_file *df;
> 	int ret;
>
>@@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> 	vfio_device_put_registration(device);
> 	return ret;
> }
>+EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
>+
>+/*
>+ * device access via the fd opened by this function is blocked until
>+ * .open_device() is called successfully during BIND_IOMMUFD.
>+ */
>+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>+{
>+	struct vfio_device *device = container_of(inode->i_cdev,
>+						  struct vfio_device, cdev);
>+
>+	return __vfio_device_fops_cdev_open(device, filep);
>+}
>
> static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
> {
>diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>index f01de98f1b75..7f4117181fd0 100644
>--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>@@ -8,6 +8,8 @@
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>+#include <linux/anon_inodes.h>
>+#include <linux/file.h>
> #include <linux/kexec_handover.h>
> #include <linux/kho/abi/vfio_pci.h>
> #include <linux/liveupdate.h>
>@@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> 	return ret;
> }
>
>+static int match_device(struct device *dev, const void *arg)
>+{
>+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
>+	const struct vfio_pci_core_device_ser *ser = arg;
>+	struct pci_dev *pdev;
>+
>+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
>+	if (!pdev)
>+		return false;
>+
>+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
>+}
>+
> static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> {
>-	return -EOPNOTSUPP;
>+	struct vfio_pci_core_device_ser *ser;
>+	struct vfio_device *device;
>+	struct file *file;
>+	int ret;
>+
>+	ser = phys_to_virt(args->serialized_data);
>+
>+	device = vfio_find_device(ser, match_device);
>+	if (!device)
>+		return -ENODEV;
>+
>+	/*
>+	 * Simulate opening the character device using an anonymous inode. The
>+	 * returned file has the same properties as a cdev file (e.g. operations
>+	 * are blocked until BIND_IOMMUFD is called).
>+	 */
>+	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
>+					&vfio_device_fops, NULL,
>+					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
>+	if (IS_ERR(file)) {
>+		ret = PTR_ERR(file);
>+		goto out;
>+	}
>+
>+	ret = __vfio_device_fops_cdev_open(device, file);
>+	if (ret) {
>+		fput(file);
>+		goto out;
>+	}
>+
>+	args->file = file;
>+
>+out:
>+	/* Drop the reference from vfio_find_device() */
>+	put_device(&device->device);
>+
>+	return ret;
>+}
>+
>+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>+{
>+	return args->retrieved;
> }
>
> static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
> {
>+	kho_restore_free(phys_to_virt(args->serialized_data));
> }
>
> static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
>@@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> 	.unpreserve = vfio_pci_liveupdate_unpreserve,
> 	.freeze = vfio_pci_liveupdate_freeze,
> 	.retrieve = vfio_pci_liveupdate_retrieve,
>+	.can_finish = vfio_pci_liveupdate_can_finish,
> 	.finish = vfio_pci_liveupdate_finish,
> 	.owner = THIS_MODULE,
> };
>diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>index 276f615f0c28..89c5feef75d5 100644
>--- a/drivers/vfio/vfio_main.c
>+++ b/drivers/vfio/vfio_main.c
>@@ -13,6 +13,7 @@
> #include <linux/cdev.h>
> #include <linux/compat.h>
> #include <linux/device.h>
>+#include <linux/device/class.h>
> #include <linux/fs.h>
> #include <linux/idr.h>
> #include <linux/iommu.h>
>@@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
> }
> EXPORT_SYMBOL(vfio_dma_rw);
>
>+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
>+{
>+	struct device *device;
>+
>+	device = class_find_device(vfio.device_class, NULL, data, match);
>+	if (!device)
>+		return NULL;
>+
>+	return container_of(device, struct vfio_device, device);
>+}
>+EXPORT_SYMBOL_GPL(vfio_find_device);
>+
> /*
>  * Module/class support
>  */
>diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>index 9aa1587fea19..dc592dc00f89 100644
>--- a/include/linux/vfio.h
>+++ b/include/linux/vfio.h
>@@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
> void vfio_virqfd_disable(struct virqfd **pvirqfd);
> void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
>
>+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
>+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
>+#else
>+static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
>+					       struct file *filep)
>+{
>+	return -EOPNOTSUPP;
>+}
>+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
>+
>+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
>+
> #endif /* VFIO_H */
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

