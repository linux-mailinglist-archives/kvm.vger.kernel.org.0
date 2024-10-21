Return-Path: <kvm+bounces-29285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E4A9A68B8
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B47E281A80
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110AE1F7062;
	Mon, 21 Oct 2024 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l+WDe/rS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BC41F4FC4;
	Mon, 21 Oct 2024 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729514381; cv=none; b=K8ONkDKtprSsWvIo0mPzyhTmJ3P1aqxw+tD2gaz4FugOeE02/0octdDxXVlmkxiz6x09WJHoab6PXnlWjmx4NzG1m1Zkv5HGOAoD8uux/mHWR3dEIisKX5Fau5ioY1wyGjkgC9wBXtrNLDDwN2om1sKFk8jH59JNwc8ALOTQgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729514381; c=relaxed/simple;
	bh=N6inumPa8oPCKpveca58697EayFfJqdOgAyl9WnGfoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjD/iOA2CNU/EHVpVhhloW64M50J/u3nKWqzhCwzRQMHXz5DzJon509m5ktF9pfzQ34BMvvfGJRzRJ2pBrEiBOK4mIrKRJnPCcmQdrIhTJ069mgMYlneEJ2Xtt98ex5AlDa3cjJj+2TDHopGgL5JUOhQwOXq8+CGLEx4TFBuczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l+WDe/rS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729514379; x=1761050379;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N6inumPa8oPCKpveca58697EayFfJqdOgAyl9WnGfoc=;
  b=l+WDe/rSepjgbyhM1Q6L4C3XXHnEh9imIBP7TD5LJbCpZvan4HImFgQY
   trW3fAhgOp0mDCUL8Xl4z9TNHspJmckxYTohwy4BB5QkSbije7DPZfuDx
   1ee3I/a77tvMUzhSjtTjLvx/zOWq8i4eljWx1EOEgN7V4C95sfdeXYfaQ
   g4O90PMB0zUtMLtbVCcsZLbGhb5cAtWkotpb/12eHF/czXfav/JhMdnVo
   WOrpYdSt99qc2br45dIx0pWXpRjGa9sJkUNNz13bWqV5qRiQ8Si0A+9hF
   Le/uDO6bbbFxdkF9h88Dslm7bj61MSzufbCd9KLultkFWXUW7KvlfPvBC
   g==;
X-CSE-ConnectionGUID: zHMhO4vLSCa4vwbtmJcf3w==
X-CSE-MsgGUID: uRb0yfn2TLqERrJcqg+6+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40120083"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40120083"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 05:39:38 -0700
X-CSE-ConnectionGUID: dKFWS3z9SWCXxMLsPmPd2Q==
X-CSE-MsgGUID: g77htEcCSWWK2FV3dP2Dew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="83528480"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by fmviesa003.fm.intel.com with ESMTP; 21 Oct 2024 05:39:35 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: alex.williamson@redhat.com
Cc: jgg@ziepe.ca,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	xin.zeng@intel.com,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Zijie Zhao <zzjas98@gmail.com>
Subject: [PATCH] vfio/qat: fix overflow check in qat_vf_resume_write()
Date: Mon, 21 Oct 2024 13:37:53 +0100
Message-ID: <20241021123843.42979-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The unsigned variable `size_t len` is cast to the signed type `loff_t`
when passed to the function check_add_overflow(). This function considers
the type of the destination, which is of type loff_t (signed),
potentially leading to an overflow. This issue is similar to the one
described in the link below.

Remove the cast.

Note that even if check_add_overflow() is bypassed, by setting `len` to
a value that is greater than LONG_MAX (which is considered as a negative
value after the cast), the function copy_from_user(), invoked a few lines
later, will not perform any copy and return `len` as (len > INT_MAX)
causing qat_vf_resume_write() to fail with -EFAULT.

Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
CC: stable@vger.kernel.org # 6.10+
Link: https://lore.kernel.org/all/138bd2e2-ede8-4bcc-aa7b-f3d9de167a37@moroto.mountain
Reported-by: Zijie Zhao <zzjas98@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/vfio/pci/qat/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index e36740a282e7..1e3563fe7cab 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -305,7 +305,7 @@ static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
 	offs = &filp->f_pos;
 
 	if (*offs < 0 ||
-	    check_add_overflow((loff_t)len, *offs, &end))
+	    check_add_overflow(len, *offs, &end))
 		return -EOVERFLOW;
 
 	if (end > mig_dev->state_size)
-- 
2.47.0


