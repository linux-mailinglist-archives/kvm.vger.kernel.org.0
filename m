Return-Path: <kvm+bounces-65295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B856CA4347
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 255B230179B4
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77222E0920;
	Thu,  4 Dec 2025 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8ABHuJd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jxdvfIo7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364102D9EDC
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861024; cv=none; b=OXuj3aSqjZvnPbeRLVVxrnA1OzhjL9IoobNdYE5kd6O7JZGkZlsd0MfWEZGPxEaR3AzDb2C3Abm8DyrE21Qi6K0gtIRZWvafsV8qDljyn6oTB31LmHF8pyHXpf5XLKoCzJlFd3nJ7ilmTGOJXDW5VpTjD8ZOEozMfg1xU2aMs/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861024; c=relaxed/simple;
	bh=lJveRauWUx7y5IzCU8bQ8COo3Mcg7RepbtONX9mf16o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKzPMEbSO9oNyMkojhG5s2ldndMOuLGrBW2WGhvC+Nl4oqg15WaFebrTZX5a5p/LF59JEGvDKEIvxY/hoymNUB5STL5kAvBhqJy/cP0MF7t9G0eB/cBRFsEiokxGc+VWFtHLzmhaxAMXRl2UJ8IaFAXbQMyU2Ck5LM8xtEm5YQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y8ABHuJd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jxdvfIo7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
	b=Y8ABHuJdNfYRdpXQV7bS1S34L25lJwCIexVvhSNdU9UhcNLF3BSYMl5hwnGIB+KgGleZxl
	0LYKcJ8hM3udGNUJhMN3tM/bQk5PgwzIiZGrZ3MadPIHrGa1/BxY0QihPa/KhSDafAhxdY
	Fgcu5Lqeg5vu63SiMldT6Am9gFRyy9g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-dyMngBtcOKq5o-4YvcrZXg-1; Thu, 04 Dec 2025 10:10:14 -0500
X-MC-Unique: dyMngBtcOKq5o-4YvcrZXg-1
X-Mimecast-MFC-AGG-ID: dyMngBtcOKq5o-4YvcrZXg_1764861013
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b245c49d0cso220317385a.3
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 07:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764861013; x=1765465813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
        b=jxdvfIo7LhB54e4GmojuV+AGhWHdrNXhp6kTm2cpx++qND90Vf2sOhly5tgQxla10P
         qtdOV5S0bTpoavddaiD3SObJj4orWmDuAlCGP6jCtGbgWLmLT5WJ8cJ1MJDSuon/rYjo
         GHQq88bfTCaeDEj4yRKQTbUq9ZbLRXRpK396dIhmvL9QObX5eDoZaC3FdH1xDRFlQ75W
         ggzJWhlcFuFz5+O6lnSQBgnMn6lG+QO3Y8BGnVInup8X2TvKK6T9r+q/yWQgm5zNfoID
         JfHwP0z7owYnuJfue5MsrRZl0GQF/DqU04UohKhV9X4tTHwucBwWVBP3iIFHAyX/Nqu6
         1bkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861013; x=1765465813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i3kfS3mg3HiGefUEuetCpDNaxRxqIsOmdjOWI6Qvpxo=;
        b=O5NnJRLMln3eJ30lrFudlErLwG5NNUDUcTV1G21/kSjJsAvFIcBvz9q0s6YtvKtVu2
         EWbEtOiBxtH8JJ5q+n9jsisQf+3HzUA3tpdfGGo84X5He6xHLoavsEnUkDR516Mx0mE5
         OBBeGKDTUqUaJS8cZh9O4JTqbBwEs6GQXQJI27G4t1efK7FyoYia7/+JLkJ5GfXVOG3m
         U5vGQ5pO7GRByQoXjVr5EI6RImkYAzO6xXQMUdOLdFMKr99yC4A5sR7Gq8o4FSu3GKLX
         vCxu8klMLPnTtCtk6cJZa2jANXa3CxaDbigibw6AyGPB705OlhUs04NioJWN+oSZwbT7
         XipQ==
X-Gm-Message-State: AOJu0YydRICjPt0q+PQTtrACywcup5PCMzsp9ld70nPMDhyIP4G+ryMh
	MawsIbRNcw+msWl3Pak3NoJLFfDglMFlGjCQNHNu2hbstJtHOenFuiTpH2PHjeF2l3zhzkJehfP
	kgs5irJXnFCETSEfWaSv/b/aFgwXBIzBUsGnmqNeKJf2rmOCOwVj6ZU5w0PwSccyKromjDLYItj
	AB/Rc9FZPHJFVbN9UV3yyzgV1cBG4RXAP2+zo=
X-Gm-Gg: ASbGncuYyKjzcESjsvA2UW7u9CA2BJ28icErUYBd0v9wJQlBvQTCyGrj0mnRS2eNgp7
	AUjAfrdBCbkAsEX/HhOXHd/orSgyjNeyOwwMWwIkNkN566oIiQfB1FMiSCTIeNGm7oCuwu1W6cx
	jHc2eTJpUqtll5gI4qbNaI/yVeqTni1lKh5T7ELyaSNi+wCpZ3wSYumrtlf3pM+2qx+SxFO66fZ
	DMD2pqZdmi4W2nlwiEVPu3JNkxtpU3N3kOdRZD0x83lX85pbpNiM2uq1KTphXNlqsAR32dXnwxe
	VddodFUEwkjvt0ECOdvG3Q9Se+yNQzV2RhgMltnetGxe0+Bw6xjqUDbT4x1nQ8sx7zuemeQeqEl
	e
X-Received: by 2002:a05:620a:4095:b0:8b1:c48f:105d with SMTP id af79cd13be357-8b5e773519fmr795858085a.87.1764861012977;
        Thu, 04 Dec 2025 07:10:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBkxqpioh6ZUgFWGNITjXJGV2mFH098xBMOQL61kY3xJnsMn9OK+8WpatADqnDH4w9UHn6yQ==
X-Received: by 2002:a05:620a:4095:b0:8b1:c48f:105d with SMTP id af79cd13be357-8b5e773519fmr795845685a.87.1764861012060;
        Thu, 04 Dec 2025 07:10:12 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:10 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/4] vfio: Introduce vfio_device_ops.get_mapping_order hook
Date: Thu,  4 Dec 2025 10:10:02 -0500
Message-ID: <20251204151003.171039-4-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a hook to vfio_device_ops to allow sub-modules provide mapping order
hint for an mmap() request.  When not available, use the default value (0).

Note that this patch will change the code path for vfio on mmap() when
allocating the virtual address range to be mapped, however it should not
change the result of the VA allocated, because the default value (0) should
be the old behavior.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/vfio_main.c | 14 ++++++++++++++
 include/linux/vfio.h     |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 38c8e9350a60e..3f2107ff93e5d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1372,6 +1372,19 @@ static void vfio_device_show_fdinfo(struct seq_file *m, struct file *filep)
 }
 #endif
 
+static int vfio_device_get_mapping_order(struct file *file,
+					 unsigned long pgoff,
+					 size_t len)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (device->ops->get_mapping_order)
+		return device->ops->get_mapping_order(device, pgoff, len);
+
+	return 0;
+}
+
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
@@ -1384,6 +1397,7 @@ const struct file_operations vfio_device_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= vfio_device_show_fdinfo,
 #endif
+	.get_mapping_order	= vfio_device_get_mapping_order,
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee5..46a4d85fc4953 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -111,6 +111,8 @@ struct vfio_device {
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
+ * @get_mapping_order: Optional, provide mapping order hints for mmap().
+ *                     When unavailable, use the default order (zero).
  */
 struct vfio_device_ops {
 	char	*name;
@@ -139,6 +141,9 @@ struct vfio_device_ops {
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	int	(*get_mapping_order)(struct vfio_device *device,
+				     unsigned long pgoff,
+				     size_t len);
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.50.1


