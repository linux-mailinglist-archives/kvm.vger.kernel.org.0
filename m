Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4014B4659EC
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 00:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353828AbhLAXtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 18:49:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353809AbhLAXtM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 18:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638402348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=snCVb5fbZV6vUruHANKIGvnBOyU9q8ZLGqcF9z3ztd4=;
        b=NPPghUy5wDu+TPBhLbTJuHLC+dUpTAt7WyPOq48kNOgHu8u5Xu71nBN3JsPkiZY2fO89B7
        QhIhhZBxze7KbkklGsrBovgfLpFpd6NEYVveMVAk9B1tybFp6bITRgf6cypY68SpR5VJg5
        kgM5sVsxwVoEq2V2tItooDuZRdiYb/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-dCV-kQihNemiLgjPHwW1tg-1; Wed, 01 Dec 2021 18:45:47 -0500
X-MC-Unique: dCV-kQihNemiLgjPHwW1tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C423E180830C;
        Wed,  1 Dec 2021 23:45:46 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.17.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C814960843;
        Wed,  1 Dec 2021 23:45:41 +0000 (UTC)
Subject: [PATCH] vfio/pci: Resolve sparse endian warnings in IGD support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 01 Dec 2021 16:45:41 -0700
Message-ID: <163840226123.138003.7668320168896210328.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sparse warns:

sparse warnings: (new ones prefixed by >>)
>> drivers/vfio/pci/vfio_pci_igd.c:146:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [addressable] [usertype] val @@     got restricted __le16 [usertype] @@
   drivers/vfio/pci/vfio_pci_igd.c:146:21: sparse:     expected unsigned short [addressable] [usertype] val
   drivers/vfio/pci/vfio_pci_igd.c:146:21: sparse:     got restricted __le16 [usertype]
>> drivers/vfio/pci/vfio_pci_igd.c:161:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [addressable] [usertype] val @@     got restricted __le32 [usertype] @@
   drivers/vfio/pci/vfio_pci_igd.c:161:21: sparse:     expected unsigned int [addressable] [usertype] val
   drivers/vfio/pci/vfio_pci_igd.c:161:21: sparse:     got restricted __le32 [usertype]
   drivers/vfio/pci/vfio_pci_igd.c:176:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [addressable] [usertype] val @@     got restricted __le16 [usertype] @@
   drivers/vfio/pci/vfio_pci_igd.c:176:21: sparse:     expected unsigned short [addressable] [usertype] val
   drivers/vfio/pci/vfio_pci_igd.c:176:21: sparse:     got restricted __le16 [usertype]

These are due to trying to use an unsigned to store the result of
a cpu_to_leXX() conversion.  These are small variables, so pointer
tricks are wasteful and casting just generates different sparse
warnings.  Store to and copy results from a separate little endian
variable.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202111290026.O3vehj03-lkp@intel.com/
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_igd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 362f91ec8845..352c725ccf18 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -309,13 +309,14 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 
 	if ((pos & 3) && size > 2) {
 		u16 val;
+		__le16 lval;
 
 		ret = pci_user_read_config_word(pdev, pos, &val);
 		if (ret)
 			return ret;
 
-		val = cpu_to_le16(val);
-		if (copy_to_user(buf + count - size, &val, 2))
+		lval = cpu_to_le16(val);
+		if (copy_to_user(buf + count - size, &lval, 2))
 			return -EFAULT;
 
 		pos += 2;
@@ -324,13 +325,14 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 
 	while (size > 3) {
 		u32 val;
+		__le32 lval;
 
 		ret = pci_user_read_config_dword(pdev, pos, &val);
 		if (ret)
 			return ret;
 
-		val = cpu_to_le32(val);
-		if (copy_to_user(buf + count - size, &val, 4))
+		lval = cpu_to_le32(val);
+		if (copy_to_user(buf + count - size, &lval, 4))
 			return -EFAULT;
 
 		pos += 4;
@@ -339,13 +341,14 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 
 	while (size >= 2) {
 		u16 val;
+		__le16 lval;
 
 		ret = pci_user_read_config_word(pdev, pos, &val);
 		if (ret)
 			return ret;
 
-		val = cpu_to_le16(val);
-		if (copy_to_user(buf + count - size, &val, 2))
+		lval = cpu_to_le16(val);
+		if (copy_to_user(buf + count - size, &lval, 2))
 			return -EFAULT;
 
 		pos += 2;


