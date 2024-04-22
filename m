Return-Path: <kvm+bounces-15578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AC18AD74E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FA551F22AC7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385F9208C7;
	Mon, 22 Apr 2024 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifIf2w5p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F811C287
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713825241; cv=none; b=muVO+Tx/M65ezWpMtE2rbvJSNWZ63ijgIKfeWT9PRp91vS1yjXcLlb4Uggl8SGdKPtNmGeBjGi6mMmNikCmB8LqWRceoZk3+pgnL4h99/LiSEH6Rppl0S326QtAKSaBQM8L5zKAGsTrr6wJoXiWIXKL9tjry2PICRkbq6y0Ieyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713825241; c=relaxed/simple;
	bh=Esa7+9btRODzsUVDQMcrOdiyvp1xcLDgM3bVgFkIsGw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irbYK/S1ZS9BxLFhsmTRzs5/pvACZ11DWYY4CJ4MgzFv9VKTwKqqhFHmlwpblsxlfIOXY7KzXJXIysPcJMOooXl5/SYOi+k8WgDZvIQi87c5WTM6mY4x0zFsLW3Av8I7PyHF8dMGgbxT8uQgymNMX+quGssnVI9J5p1GX6gMYko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifIf2w5p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713825238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/GvmoGX8DTWmRumzcxb/3+d+/FhKPxb37rJc61sPnX8=;
	b=ifIf2w5p+E0SqCp5zdyFfx6tI3MP3UKwr2hM2zQSY2+TX34ujBZPe+Lx1jQnv7jypYzISh
	Fzu3PAKgIw3NU8GsxNMN+48MbSP/ow+I3R2C6OQk259Nfhr9TtS+JA/g9zxIi70PleS1rW
	yEi+5yLKHpBJM68lgeStr3tkrLeF3Tc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-G99FjV9bPLOCcLfo9Q3X5w-1; Mon, 22 Apr 2024 18:33:56 -0400
X-MC-Unique: G99FjV9bPLOCcLfo9Q3X5w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7da41da873bso612545739f.3
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713825236; x=1714430036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/GvmoGX8DTWmRumzcxb/3+d+/FhKPxb37rJc61sPnX8=;
        b=WerPMQ3QNN5roE6h0LHPDKc2wp1Yn6a/Ece+fueY/yOMquHmFOSJhsaM2YPJh3r99c
         5OdDsNZz7Vuq7ynLBHhpVKJtUjWggERN7EE7ozb2P0nyP7EBR+5a2KPKKVH0aFf2HR/T
         6R7i3o9QCDzOjYxLWQ3IPsAJeBG90vBeA+Ycjl2fHS/3xf2a/WGRZ2uloPBN++pznbWn
         Fnd712n3mbp/U40zIC53shqV/Sx77tM/U5Zxyt5LbvUVYnyulbCgfYiO6uVsq+cIDu2e
         GhzP6Xswh1Gf/eyg3zyuGnK7z+pVLO1Y3Pyx3vbbGQ4EgxWwy8xKt7NAJy+V+xNJM4Yt
         tQkA==
X-Forwarded-Encrypted: i=1; AJvYcCX/99dBsHMvc7HdayqRtMGR5OlOzAP0SKH4/UAVT7nbOsKxeN1e0BTXhl+SEkQzAFE52qbHIEN4ZAHgkRYnY3PwEpx7
X-Gm-Message-State: AOJu0Yw/bVPoKkFDeJ1oO2EVyj/dL4ImD9yb3xF7s4dNzh49bxVZWICg
	qAnOHN+vey1kbhQ/TsIEp+lQdlv1aHBwy9mq+Zknz10wu043NJhjMZ6GFMknXSlYN9F3cKdQM4u
	ag2Us+WG5gsTpqmUu+dr1RLJknZNnMiWBMjXudr+O3CHntweJCg==
X-Received: by 2002:a5d:9844:0:b0:7da:a742:e4fb with SMTP id p4-20020a5d9844000000b007daa742e4fbmr8938961ios.17.1713825235705;
        Mon, 22 Apr 2024 15:33:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHp46R0NbUHQ8q2mvDhTBvs7MfNzO6vcHhtTnodJBPBG34PAAk5kU3hnb/z3ZgpDu0stqV0mg==
X-Received: by 2002:a5d:9844:0:b0:7da:a742:e4fb with SMTP id p4-20020a5d9844000000b007daa742e4fbmr8938943ios.17.1713825235269;
        Mon, 22 Apr 2024 15:33:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e5-20020a056602158500b007d5f0d54ae9sm1907153iow.0.2024.04.22.15.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 15:33:54 -0700 (PDT)
Date: Mon, 22 Apr 2024 16:33:53 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Niklas Schnelle
 <schnelle@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil
 Pasic <pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben
 Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240422163353.24f937ce.alex.williamson@redhat.com>
In-Reply-To: <20240422174305.GB231144@ziepe.ca>
References: <20240422153508.2355844-1-gbayer@linux.ibm.com>
	<20240422174305.GB231144@ziepe.ca>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Apr 2024 14:43:05 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Apr 22, 2024 at 05:35:08PM +0200, Gerd Bayer wrote:
> > From: Ben Segal <bpsegal@us.ibm.com>
> > 
> > Many PCI adapters can benefit or even require full 64bit read
> > and write access to their registers. In order to enable work on
> > user-space drivers for these devices add two new variations
> > vfio_pci_core_io{read|write}64 of the existing access methods
> > when the architecture supports 64-bit ioreads and iowrites.
> > 
> > Since these access methods are instantiated on 64bit architectures,
> > only, their use in vfio_pci_core_do_io_rw() is restricted by conditional
> > compiles to these architectures.
> > 
> > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > Hi all,
> > 
> > we've successfully used this patch with a user-mode driver for a PCI
> > device that requires 64bit register read/writes on s390. A quick grep
> > showed that there are several other drivers for PCI devices in the kernel
> > that use readq/writeq and eventually could use this, too.
> > So we decided to propose this for general inclusion.
> > 
> > Thank you,
> > Gerd Bayer
> > 
> > Changes v1 -> v2:
> > - On non 64bit architecture use at most 32bit accesses in
> >   vfio_pci_core_do_io_rw and describe that in the commit message.
> > - Drop the run-time error on 32bit architectures.
> > - The #endif splitting the "else if" is not really fortunate, but I'm
> >   open to suggestions.  
> 
> Provide a iowrite64() that does back to back writes for 32 bit?

I was curious what this looked like.  If we want to repeat the 4 byte
access then I think we need to refactor all the read/write accesses
into macros to avoid duplicating code, which results in something like
[1] below.  But also once we refactor to macros, the #ifdef within the
function as originally proposed gets a lot more bearable too [2].

I'd probably just go with something like [2] unless you want to further
macro-ize these branches out of existence in the main function.  Feel
free to grab any of this you like, the VFIO_IORDWR macro should
probably be it's own patch.  Thanks,

Alex

[1]
 drivers/vfio/pci/vfio_pci_rdwr.c |  145 +++++++++++++++++--------------
 include/linux/vfio_pci_core.h    |    3 
 2 files changed, 87 insertions(+), 61 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 03b8f7ada1ac..84bd1d670086 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -89,6 +89,71 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
+#ifdef ioread64
+VFIO_IOREAD(64)
+#endif
+
+#define VFIO_IORDWR(size)						\
+static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
+				bool iswrite, bool test_mem,		\
+				void __iomem *io, char __user *buf,	\
+				loff_t off, size_t *filled)		\
+{									\
+	u##size val;							\
+	int ret;							\
+									\
+	if (iswrite) {							\
+		if (copy_from_user(&val, buf, sizeof(val)))		\
+			return -EFAULT;					\
+									\
+		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
+						  val, io + off);	\
+		if (ret)						\
+			return ret;					\
+	} else {							\
+		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
+						 &val, io + off);	\
+		if (ret)						\
+			return ret;					\
+									\
+		if (copy_to_user(buf, &val, sizeof(val)))		\
+			return -EFAULT;					\
+	}								\
+									\
+	*filled = sizeof(val);						\
+	return 0;							\
+}									\
+
+VFIO_IORDWR(8)
+VFIO_IORDWR(16)
+VFIO_IORDWR(32)
+#if defined(ioread64) && defined(iowrite64)
+VFIO_IORDWR(64)
+#else
+static int vfio_pci_core_iordwr64(struct vfio_pci_core_device *vdev,
+				  bool iswrite, bool test_mem,
+				  void __iomem *io, char __user *buf,
+				  loff_t off, size_t *filled)
+{
+	int ret;
+	size_t cnt;
+
+	ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
+				     io, buf, off, &cnt);
+	if (ret)
+		return ret;
+
+	ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
+				     io, buf + cnt, off + cnt,
+				     filled);
+	if (ret)
+		return ret;
+
+	*filled += cnt;
+
+	return 0;
+}
+#endif
 
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
@@ -114,72 +179,30 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-		if (fillable >= 4 && !(off % 4)) {
-			u32 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 4))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite32(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread32(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 4))
-					return -EFAULT;
-			}
+		if (fillable >= 8 && !(off % 8)) {
+			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
+
+		} else if (fillable >= 4 && !(off % 4)) {
+			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 4;
 		} else if (fillable >= 2 && !(off % 2)) {
-			u16 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 2))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite16(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread16(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 2))
-					return -EFAULT;
-			}
+			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 2;
 		} else if (fillable) {
-			u8 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 1))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite8(vdev, test_mem,
-							     val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread8(vdev, test_mem,
-							    &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 1))
-					return -EFAULT;
-			}
+			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
+						    io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 1;
 		} else {
 			/* Fill reads with -1, drop writes */
 			filled = min(count, (size_t)(x_end - off));
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a2c8b8bba711..f4cf5fd2350c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOREAD_DECLATION(8)
 VFIO_IOREAD_DECLATION(16)
 VFIO_IOREAD_DECLATION(32)
+#ifdef ioread64
+VFIO_IOREAD_DECLATION(64)
+#endif
 
 #endif /* VFIO_PCI_CORE_H */

--------------------------------------------------------------------------------------

[2]
 drivers/vfio/pci/vfio_pci_rdwr.c |  122 +++++++++++++++----------------
 include/linux/vfio_pci_core.h    |    3 
 2 files changed, 65 insertions(+), 60 deletions(-)

commit 05aa3342b4f9e249f3bb370e2fdf66e95de556b8
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Mon Apr 22 15:58:48 2024 -0600

    test

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 03b8f7ada1ac..22e889374e47 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -89,6 +89,47 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
+#ifdef ioread64
+VFIO_IOREAD(64)
+#endif
+
+#define VFIO_IORDWR(size)						\
+static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
+				bool iswrite, bool test_mem,		\
+				void __iomem *io, char __user *buf,	\
+				loff_t off, size_t *filled)		\
+{									\
+	u##size val;							\
+	int ret;							\
+									\
+	if (iswrite) {							\
+		if (copy_from_user(&val, buf, sizeof(val)))		\
+			return -EFAULT;					\
+									\
+		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
+						  val, io + off);	\
+		if (ret)						\
+			return ret;					\
+	} else {							\
+		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
+						 &val, io + off);	\
+		if (ret)						\
+			return ret;					\
+									\
+		if (copy_to_user(buf, &val, sizeof(val)))		\
+			return -EFAULT;					\
+	}								\
+									\
+	*filled = sizeof(val);						\
+	return 0;							\
+}									\
+
+VFIO_IORDWR(8)
+VFIO_IORDWR(16)
+VFIO_IORDWR(32)
+#if defined(ioread64) && defined(iowrite64)
+VFIO_IORDWR(64)
+#endif
 
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
@@ -114,72 +155,33 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
+#if defined(ioread64) && defined(iowrite64)
+		if (fillable >= 8 && !(off % 8)) {
+			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
+
+		} else
+#endif
 		if (fillable >= 4 && !(off % 4)) {
-			u32 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 4))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite32(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread32(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 4))
-					return -EFAULT;
-			}
+			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 4;
 		} else if (fillable >= 2 && !(off % 2)) {
-			u16 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 2))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite16(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread16(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 2))
-					return -EFAULT;
-			}
+			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 2;
 		} else if (fillable) {
-			u8 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 1))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite8(vdev, test_mem,
-							     val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread8(vdev, test_mem,
-							    &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 1))
-					return -EFAULT;
-			}
+			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
+						    io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 1;
 		} else {
 			/* Fill reads with -1, drop writes */
 			filled = min(count, (size_t)(x_end - off));
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a2c8b8bba711..f4cf5fd2350c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOREAD_DECLATION(8)
 VFIO_IOREAD_DECLATION(16)
 VFIO_IOREAD_DECLATION(32)
+#ifdef ioread64
+VFIO_IOREAD_DECLATION(64)
+#endif
 
 #endif /* VFIO_PCI_CORE_H */


