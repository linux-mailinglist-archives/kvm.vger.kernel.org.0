Return-Path: <kvm+bounces-25806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A7496ADA2
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7DA2285215
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 01:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B28522F;
	Wed,  4 Sep 2024 01:10:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9215A63D
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725412211; cv=none; b=O85XAQP1AE0yAfaYCgJeBm6n+TmaIIUz8eBrHCkH3Wtud0prY/tZDq04HqNclA3rkSZOG36Uk5Uyrdjmk+T2fpf8RDnR9xiVd0Reg/aBKpiQzhS/x9VLJUe1wzq/Lz1hQtZVw9R9gTFQWSp65qwMHKNOHPei2UUIE3u88cu0hcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725412211; c=relaxed/simple;
	bh=AwddJBi2cfcktqeS4DDhD44LitRSU6L9QqGfic+ZUK8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KvhDMoQFcuVjgHpm7hcsqdqg6tHMfMF6U6wXSQrLuvxLsTImqAq/5vr/jUoFHm5pBxxRovReJVwK5b9Sv0ULL+SmaPmqlAHyaSzTVrvc+xIeZlK3pG7Wsy7vCmGB/cq7xify4LsNUXwWBtcvhmeBWY+llhsyrenAvcVNw6ScZ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wz4CX3NDHz1S9fP;
	Wed,  4 Sep 2024 09:09:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DC165140158;
	Wed,  4 Sep 2024 09:10:04 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 09:10:04 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kwankhede@nvidia.com>, <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] vfio/mdev: Constify struct kobj_type
Date: Wed, 4 Sep 2024 09:18:37 +0800
Message-ID: <20240904011837.2010444-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

This 'struct kobj_type' is not modified. It is only used in
kobject_init_and_add() which takes a 'const struct kobj_type *ktype'
parameter.

Constifying this structure and moving it to a read-only section,
and this can increase over all security.

```
[Before]
   text   data    bss    dec    hex    filename
   2372    600      0   2972    b9c    drivers/vfio/mdev/mdev_sysfs.o

[After]
   text   data    bss    dec    hex    filename
   2436    568      0   3004    bbc    drivers/vfio/mdev/mdev_sysfs.o
```

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 9d2738e10c0b..e44bb44c581e 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -160,7 +160,7 @@ static void mdev_type_release(struct kobject *kobj)
 	put_device(type->parent->dev);
 }
 
-static struct kobj_type mdev_type_ktype = {
+static const struct kobj_type mdev_type_ktype = {
 	.sysfs_ops	= &mdev_type_sysfs_ops,
 	.release	= mdev_type_release,
 	.default_groups	= mdev_type_groups,
-- 
2.34.1


