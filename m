Return-Path: <kvm+bounces-20374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8775091437D
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E76284CEB
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8C82EB1D;
	Mon, 24 Jun 2024 07:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GtDt0KK3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208F3C099;
	Mon, 24 Jun 2024 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213683; cv=none; b=AUULJFwOks3qfuX3zXPVT6hS8FVvTaEo0RUhq798TntisUUmmGIH2TTKwiyYecF2w2KJAhKXJytoShOssj1+5CDWRxhUU60uV86O/86X3LbZBigeL358D9/Rsk0avQxvtpcyJDRWEJ9yzJh1jhK2jrMdqONTAdqfo4ksGLMRdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213683; c=relaxed/simple;
	bh=MSJJprILcfmTjSAIUrfkFgMpD14a45oMknilvPrEnN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM01+I8rjSMUwcveuS0LL/H8rkLqXFHVQaiiHMM31fJc8/qRVPeaWS6XjvX0ybqG7YHbprBUXioEXqeCxMMbV36BN0R8QqnKZEJgQcq991p1B2+pKzFPyi0W50wE2d/vDiwj/UUsQY9HKdQdCxRC/1w0ReDuEIDjyLCW4RK11A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GtDt0KK3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719213681; x=1750749681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MSJJprILcfmTjSAIUrfkFgMpD14a45oMknilvPrEnN8=;
  b=GtDt0KK3uhNqxJ4R41geqNxdpeJj6aQ36jc/5zk+DbEDGrM8IHxyYL9j
   E8m8Ya437y9c8cVLR74hnlH3CKKZrbnyWCPocIcrKme9VmN09y08cXteY
   tfqMDofllBOF8edzYCL0U1mWf5dPTnmkObBprP8X5TTOPhxWa5csacVX9
   Sbf8aETsUzzxudhmbYnQBlVQgp5XAJqUK0Oj8Z3MSxXQQNjpd3XqmfCh9
   6rDCxire5dnzNopSDhBcxOD4o6AbzStES2LzyugXD24QRYLNThPmR0uH5
   hXhGUZJjO5hAOUhNPJxIXLg/XGtpA2aOSGNgIoeYWLxS8wSUq6UZqyakT
   A==;
X-CSE-ConnectionGUID: gJW4fCtfTX6oh3vRsqHJ4A==
X-CSE-MsgGUID: 7V1l3MCiSX2MipayE5N0lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11112"; a="41574851"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="41574851"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 00:21:17 -0700
X-CSE-ConnectionGUID: +orOdddtRD6FTIGvmxYEfg==
X-CSE-MsgGUID: quPbILWfQiCWTVhzEeQ34w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="43085341"
Received: from vkasired-desk2.fm.intel.com ([10.105.128.132])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 00:21:17 -0700
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
To: dri-devel@lists.freedesktop.org,
	kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 1/3] vfio: Export vfio device get and put registration helpers
Date: Sun, 23 Jun 2024 23:53:09 -0700
Message-ID: <20240624065552.1572580-2-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240624065552.1572580-1-vivek.kasireddy@intel.com>
References: <20240624065552.1572580-1-vivek.kasireddy@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..d06d4a9a3127 100644
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
index 000a6cab2d31..2258b0585330 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -279,6 +279,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.45.1


