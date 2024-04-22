Return-Path: <kvm+bounces-15461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB748AC4A4
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9868F28176B
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F3F4AED1;
	Mon, 22 Apr 2024 07:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anpJggvx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57B482FE;
	Mon, 22 Apr 2024 07:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713769236; cv=none; b=UOY2NK71o3aZtQEh0pIeuz/mnPTitikxJnGm295XWB6EeqTQxNjzi2i0nfUKYAgkhi2BlOaTTveOm/cRASr5lSZPvbU8pQ+4cBeVhUoq7za2vWVYVAWsKKXBlq1udAGMPlMYUyjJ/W3vWA24eBr5GK5bJ1PWPJjmJbg0FQRe/2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713769236; c=relaxed/simple;
	bh=QW1bLUiDxhnwM5EPUxf7J82zqdGu2UdJY9OdWB1xHmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrcc66j9a5/piGiGQAXoMSu6Zm9DzGTt+EUr1GOGQv4i7CoMilfHWjUm6aI4FGGoToD8IPg3G1NUKAtLtIfwT6MTbEDYCsKuPl5dWG/jDmnzskYBJ/eMETsJflqCQV6Dk0pWEQ/tY0qlHkODIr2Wi9t3dd6kgUcmSUfS5VJCfH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anpJggvx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713769234; x=1745305234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QW1bLUiDxhnwM5EPUxf7J82zqdGu2UdJY9OdWB1xHmI=;
  b=anpJggvxvTGoVfRNBSStrQOeKkAHgCVSZusqCakLKov4dEJ/RiNsGLJu
   zhAD6Rwi6piXX0BofEy7ZQlAFtfatwegsWGyaRBmYjfUD+G+NH0s2C9yA
   G0Jz2ulsSj6a427qpXZD10sM0stYQUrHpoxASvx4cTQJldvzguEmHtPk2
   LM9mynPq6Su6rGaf0eL1ZLn+0dOnN82VYq0T3z9jv6zAHAL164gOiUTkg
   Vq9OT4DF+3lmwbl+lDX/zoC2qPB94yqhZyrp0FTU6Te3X9/txpPcFqEiW
   BWdEeh5Lg6jHRgtSuBQEQTf2S/24HpPVr9riVyZBWA6JJw0wdqv3Npt5N
   w==;
X-CSE-ConnectionGUID: 9MO8qGcwQEyurNynKRLMRw==
X-CSE-MsgGUID: 1ztQiMT0QwS5KYgIlAt/yA==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="13080591"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="13080591"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:00:29 -0700
X-CSE-ConnectionGUID: YBv7kN4xSkCwc4A71P7JmQ==
X-CSE-MsgGUID: +NAByN0NQSa6Wmjkz/k1wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="61362275"
Received: from vkasired-desk2.fm.intel.com ([10.105.128.132])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:00:30 -0700
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
To: dri-devel@lists.freedesktop.org,
	kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v1 1/2] vfio: Export vfio device get and put registration helpers
Date: Sun, 21 Apr 2024 23:30:32 -0700
Message-ID: <20240422063602.3690124-2-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422063602.3690124-1-vivek.kasireddy@intel.com>
References: <20240422063602.3690124-1-vivek.kasireddy@intel.com>
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
index e97d796a54fb..7434461fc1b3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -165,11 +165,13 @@ void vfio_device_put_registration(struct vfio_device *device)
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
index 8b1a29820409..a6302fca8acd 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -278,6 +278,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.43.0


