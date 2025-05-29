Return-Path: <kvm+bounces-47933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A79AC77D1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45CCC165699
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB342571B6;
	Thu, 29 May 2025 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyaEZ4at"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC7256C7E;
	Thu, 29 May 2025 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497312; cv=none; b=sJSJjlAaF+0crfm0SqwXkFGEnFtgPmrKs1CUvhqxtUXiXEpsaXjpZ/yrEIO3Q/aGikOr4CZJnjiptO/+PwFtMZK/Vm5KwxcgjSJp5sVVeA+VIgxIY7mMWggad48Lu4XBUnIjG9OKiA9SZNMGM2cgiEcspYRF4/FhOJin7IN6vNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497312; c=relaxed/simple;
	bh=s6ATRYdccLI0SPU9T1CSnNoi9tI9HxN5sGOM3iiteL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i7YhH+fB5cYAXhgCpWMJmYXYqOCvfQmFLce19Q4l2uycuCteJFD0Xd7pPCT0HoIYCg2bccWeCKnFKFrnzjlK0Z/ddI1WN8Lvlj4IxcHo3rhNWtUNHjkp1YVus6K0gFuSYc/+IIEXTGDDd8/quWq1M9dzd/YFFDn3wBZMpmix4ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyaEZ4at; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497311; x=1780033311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s6ATRYdccLI0SPU9T1CSnNoi9tI9HxN5sGOM3iiteL0=;
  b=fyaEZ4atcviJgSOrVFuA7bBZlA1NF8+vAtcHOYQnuTA2oZc17ef132Yx
   2v/XIprpCSbw7mSzKHBkrOxOu1H3pAQx9+Icknd5yPyK6LGkCoQH/e6ZR
   xxPMYHcvw8Uzxdn+34C2NYi2IzSXyKsRPe/4qg6RHFQEECRHrJnytYsZ4
   LI4Nd2JtZznRAfo202FOnsP9a+W/94NRgEvAZGIBeFgDgGNUG6ERIMSDR
   Bpg/TRmOq82S9rM3yfyBRw3OSnA7cRG1xkmfZscVPTuvqW91AusR6PXUU
   DTAuwFzcZR9HJP2riqInr+nwvjD/WVtQyGCGJPLv1cAGcy1F/DZ2BxIut
   w==;
X-CSE-ConnectionGUID: R1br230ITTGE9QnmEsYrLA==
X-CSE-MsgGUID: FAAM9qGjQIe030gWUqjU1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67962906"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67962906"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:41:51 -0700
X-CSE-ConnectionGUID: cuUVC9FURPi72lhPv54gcA==
X-CSE-MsgGUID: F9VlM59vRuyz2/iwvuiEyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443247"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:41:44 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 02/30] vfio: Export vfio device get and put registration helpers
Date: Thu, 29 May 2025 13:34:45 +0800
Message-Id: <20250529053513.1592088-3-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..620a3ee5d04d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -171,11 +171,13 @@ void vfio_device_put_registration(struct vfio_device *device)
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put_registration);
 
 bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
+EXPORT_SYMBOL_GPL(vfio_device_try_get_registration);
 
 /*
  * VFIO driver API
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1..ba65bbdffd0b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -293,6 +293,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.25.1


