Return-Path: <kvm+bounces-49418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0048FAD8D59
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69A593AE483
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424062D8798;
	Fri, 13 Jun 2025 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGXs7DE5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C95433D9
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822092; cv=none; b=t/RSbon2MMxJ4nD4SsmfTxwOqSrB+lhTczsmvZq54IkKyU0usPxYAxKGpKmo4l5qhrCgcSCY/Z5tBvJVv9Lu8ehl9pR/MVK8muLpeoTMjfRUe8Anf6wcyo7rRDmqE9rqTYPn73x+TNNw0roHwblRpwDh4pNs/Akj3urKpVTzvAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822092; c=relaxed/simple;
	bh=dpUMDqRxYyy7EaOTCpbZ2yM1jpnDsm+aUl6N3AthocU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qci6o3AN1nxtBrw4M18FDLNRUsB1zC9AYcLYCu1MUtgJWUP3o+FY+CHvP8432PYyqvgFJ4rLF4zTo8p8EZ15dJfweFO7iJog/GRPCATruZn9jmKPGIg7HntrSCZCCoxF5mc51iy47Vnl4H03X8hXNeA2KeZ9NRJWrCv89kjyX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGXs7DE5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749822090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=srvKo/GW1EbJBPf9Cl0G9P4CrJB0MZAkcimCCvUCpgo=;
	b=ZGXs7DE5+Rh7MRW7JkeWSHsfqAj7TNsNeq3ff2u+S/u3c+tdrCO7TyvaEaxKo3g67HUe7v
	o31OE1QLbq9xCQzTxjXW82Gd//a3gXQcx0zkDJKDfmiMa0UgeWG6Z39zqhL+NTv2QUFubP
	SDaF9DrNlopT/eJ4Z/zShybesccXoBE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-qyBTXhL2OAmPMKvbOJ2lDA-1; Fri, 13 Jun 2025 09:41:23 -0400
X-MC-Unique: qyBTXhL2OAmPMKvbOJ2lDA-1
X-Mimecast-MFC-AGG-ID: qyBTXhL2OAmPMKvbOJ2lDA_1749822083
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5e28d0cc0so337901585a.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749822083; x=1750426883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srvKo/GW1EbJBPf9Cl0G9P4CrJB0MZAkcimCCvUCpgo=;
        b=ExJo3XgzWNYx9X5B89Ey7832QbmeTyqI3J3RgdQ96J1T+ywdoo7hCoKyjDCpY6k7AU
         UunHq30KLYkBV+iBa/UK+jTWHFPKqfW0OjEmenpiK3I1TsAOrBjipNYol1TeWyo18Xg7
         YjKHTlnPQrdKigBerC1Bn/UcRuVPl9XzHBdUiw1Y3bzuEgaH2oozmZd4OSV6RlmOCiVJ
         yleZnnyNZ4fkGtc64mvJ3mDXKCyNEWNbVlavYp7tUcdujYBGsen0usMEIGOCdVQFpItk
         oLa0MZyF8+ikiE+qIEkiKK8dl30YVHvp/fa0vsS5mz4cyT044nq6eOcyPIHmq9zHq7G7
         7SUg==
X-Forwarded-Encrypted: i=1; AJvYcCW4Ut2xkAfr2Nf/oQHX4i82dwPmoI/Z/w1vhWmdXopRmVkRAJ+JHntb/bMwV8VQzRXr49s=@vger.kernel.org
X-Gm-Message-State: AOJu0YztFXJi7Y0bgj9Ys9Yby07o4AZMxu6XUBX/j7D769jXFzFQhm+1
	ZeIs3pBrB9Xegt6KPsE4iP+RB4Hug5a2HzAsxjobYscCEiw8pB1PZ97Zv8zyOGx28BpD7msjwka
	VsgzKY3L7tfOh18m11ZRU8nGj+lPpEDGnhffY98LoIwOqA3fprCnl8w==
X-Gm-Gg: ASbGncsV3kqf6N3kC+X65v6s9rSKYXIgpwh1HDSFbGAmg6cu6as5qNPDxqBGJzZec7j
	VgeboW8Uyr9upeNnnvtJHA8Z+Eu8Sg1jfWYexpwq0sG6kZtkfivctt/JdT9ngkFIJvKnLt6TvXT
	dMIj9PsgfGAoOgmlZX1WjP5U8qgqfIgZ3LL0V7ZphD00WIjlg8LUdYqQXtMoEaLwuEbGzB8YXCD
	oCWX793y3bgKrs81N1X0IRRXKn8hjSdPBMuWuKpzmFNXBFnpH9IOB4b+4N10mZSSX0dESutkRs+
	zr4aTMpSBho=
X-Received: by 2002:a05:620a:2627:b0:7cd:3f01:7c83 with SMTP id af79cd13be357-7d3bc44a1f9mr399253585a.39.1749822082999;
        Fri, 13 Jun 2025 06:41:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGy9xhb6Ir/WTjwOiKTV6R2xWTKghNAist5R7llcPyhmuhj1jELKcIWu8eGBTg4hcMRpO8q+w==
X-Received: by 2002:a05:620a:2627:b0:7cd:3f01:7c83 with SMTP id af79cd13be357-7d3bc44a1f9mr399250685a.39.1749822082633;
        Fri, 13 Jun 2025 06:41:22 -0700 (PDT)
Received: from x1.com ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8ee3f72sm171519285a.94.2025.06.13.06.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 06:41:21 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	peterx@redhat.com
Subject: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area hook
Date: Fri, 13 Jun 2025 09:41:10 -0400
Message-ID: <20250613134111.469884-5-peterx@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613134111.469884-1-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a hook to vfio_device_ops to allow sub-modules provide virtual
addresses for an mmap() request.

Note that the fallback will be mm_get_unmapped_area(), which should
maintain the old behavior of generic VA allocation (__get_unmapped_area).
It's a bit unfortunate that is needed, as the current get_unmapped_area()
file ops cannot support a retval which fallbacks to the default.  So that
is needed both here and whenever sub-module will opt-in with its own.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/vfio_main.c | 18 ++++++++++++++++++
 include/linux/vfio.h     |  7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..19db8e58d223 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1354,6 +1354,23 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	return device->ops->mmap(device, vma);
 }
 
+static unsigned long vfio_device_get_unmapped_area(struct file *file,
+						   unsigned long addr,
+						   unsigned long len,
+						   unsigned long pgoff,
+						   unsigned long flags)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->get_unmapped_area)
+		return mm_get_unmapped_area(current->mm, file, addr,
+					    len, pgoff, flags);
+
+	return device->ops->get_unmapped_area(device, file, addr, len,
+					      pgoff, flags);
+}
+
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
@@ -1363,6 +1380,7 @@ const struct file_operations vfio_device_fops = {
 	.unlocked_ioctl	= vfio_device_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.mmap		= vfio_device_fops_mmap,
+	.get_unmapped_area = vfio_device_get_unmapped_area,
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1..48fe71c61ed2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -108,6 +108,7 @@ struct vfio_device {
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
+ * @get_unmapped_area: Optional, provide virtual address hint for mmap()
  */
 struct vfio_device_ops {
 	char	*name;
@@ -135,6 +136,12 @@ struct vfio_device_ops {
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	unsigned long (*get_unmapped_area)(struct vfio_device *device,
+					   struct file *file,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags);
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.49.0


