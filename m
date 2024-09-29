Return-Path: <kvm+bounces-27652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C72A6989612
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 17:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E9B1284C54
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 15:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC63F17B439;
	Sun, 29 Sep 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbVN95SU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE4214A91
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727622159; cv=none; b=HaYILArJbgKaUpuD2cQtv3VHVDREiWQFY3PrDpbmu2krj9yRdo/jCkes9g9fjcgtJYkrrisbGe4GYGI1uQJCAVZl3MM1duuBYqqPB4bsWRQnXlyr8V5CwLcQXJD7NEBmhFaWdv84kiX22SZjlwbuZZhGc0PaJmxuiP0fJHbk1tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727622159; c=relaxed/simple;
	bh=fvKUlPBMc4rieM+dr99vygBaO8iEqKnBCOo6Pxjbl/I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BZ4XneT8s2s25H4qum6PwM58n0DJjasv/L/JhfPxkMPKRWVgirXydHGl9PNiahN1c2VLY87aIM2+f+nJYzWtKxZdyMZ130WHSt8dF/wy6hhHjaATkD/MeNo2BkgAR36lfBDN6FEkCvOhbmYprYaZIS0kNnm8hucalD6ZRrioXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbVN95SU; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-50958a19485so200742e0c.2
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 08:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727622156; x=1728226956; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UQtBGVwzDynAvR1i658lctfbT6PK1N7vwZ/hsRUD4YQ=;
        b=GbVN95SUSVJLkc9NrOg4ALF7w0tVvIccH5ngHDV3tA9pM4XIcmLN8zgdlRop0yuibg
         euDOOpbZeFCyH1rolNUFSUhUaAkLYUPrmNlknuRpX31s/OcamZIf8S+9Y82VyRsil4Hm
         X3VTzkuRjm55OCaZucuWrjUtm7sinx9u3LmN6ObIiZkYUFEjVyIlRSZUwjeBtQBi7AAh
         aiTu5rAQMKHT9Xy4d/c1Sg/s+fXLmJYcYRVIzjSVigwMHfaRuhjtoIqIJ1Bb/Rjz+4Ur
         cr7K4XBCwjOHpT91im7rhHotYWqFcJaE/u2TPRFZT0NZ+vFX8oH1odbUCDLWBt/e69/J
         WdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727622156; x=1728226956;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UQtBGVwzDynAvR1i658lctfbT6PK1N7vwZ/hsRUD4YQ=;
        b=aWM3DdiBIlf2WH+Qc7gGriKqL8UulShR1alhbfOwStR65SZjhoLvbYrF+SGJDklqgx
         d1Bbq1L65oWkJButcUQQAozM/JjthuIxfWGWI4fbTim/9/xBooQbEn1+4BTAIH5rrjxz
         Z07nY9rVajj5WNeP/kGUK8JhDRkTNNYIdeJ0pLcEpoDD5eRT1rkmpifi3YYan9dy/hZt
         BDq7Bo/8/0hZ+C2QmszpRqeR/7ev4XjR34guzFAspLZnLfCqYkAH9nYZWvPu8Ds7ySwJ
         zEc5H5qz/hcBgo3FZotZX6LzG35qg69akQZJG1ClJm454dyfduTsWYLe05jvFKmRNNrb
         NyPA==
X-Gm-Message-State: AOJu0YynQB9u1RAmYmWbMwlks7TWqiaqXnLOJqr8JpF9Nh/+X+iif70Z
	dVjC4OC3wMZpWKmZ8Nuu5WF1xF+y0ITtr2hF7flEZG27bFOeiy/X3Z/WVdtde7/qIzL6BwTFlEw
	IQe7cm4iqSXjP1Vw5GZmxT9HwedLVzRhx
X-Google-Smtp-Source: AGHT+IGrpB2L43jehbpKdMqksmTk5A0CqU7ErhUNA+FWxeCfxDnW9ye5X6V2tz454He76jO7BbdPx9SACrw3rC8prOU=
X-Received: by 2002:a05:6122:3b0e:b0:509:e278:c28a with SMTP id
 71dfb90a1353d-509e278c998mr1176726e0c.7.1727622156205; Sun, 29 Sep 2024
 08:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Michael Williamson <mike.a.williamson@gmail.com>
Date: Sun, 29 Sep 2024 11:02:24 -0400
Message-ID: <CACcEcgQq_yxvjAo7BticTw6ne8S2uUjbCFxPTnWHT24oMkxf=w@mail.gmail.com>
Subject: Supporting VFIO on nVidia's Orin platform
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I've been trying to get VFIO working on nVidia's Orin platform (ARM64) in
order to support moving data efficiently off of an attached FPGA PCIe board
using the SMMU from a user space application.  We have a full application
working on x86/x64 boxes that properly support the VFIO interface.  We're
trying to port support to the Orin.

I'm on nVidia's 5.15.36 branch.  It doesn't work out of the box, as the
tegra194-pcie platform controller is lumped in the same iommu group as the
actual PCIe card.  The acs override patch didn't help to separate them.

I have a patch below that *seems* to work for us, but I will admit I do not
know the implications of what I am doing here.

Can anyone let me know if this is (and why it is) a bad idea, and what really
needs to be done?  Or if this is the wrong mailing list, point me in the right
direction?

Thanks,
Mike

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 818e47fc0896..a598a2204781 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -638,8 +638,15 @@ static struct vfio_device
*vfio_group_get_device(struct vfio_group *group,
  * breaks anything, it only does so for user owned devices downstream.  Note
  * that error notification via MSI can be affected for platforms that handle
  * MSI within the same IOVA space as DMA.
+ *
+ * [MAW] - the tegra194-pcie driver is a platform PCie device controller and
+ * fails the dev_is_pci() check below.  Not sure if it's because its grouping
+ * needs to be reworked, but I don't know how this is (or if it
should be) done.
+ * This is a hack to see if we can get it going well enough to use the
+ * SMMU from user space.  The other two devices (for the Orin) in the group
+ * are the host bridge and the PCIe card itself.
  */
-static const char * const vfio_driver_allowed[] = { "pci-stub" };
+static const char * const vfio_driver_allowed[] = { "pci-stub",
"tegra194-pcie" };

 static bool vfio_dev_driver_allowed(struct device *dev,
                                    struct device_driver *drv)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 66bbb125d761..e34fbe17ae1a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -45,7 +45,8 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"

-static bool allow_unsafe_interrupts;
+/** [MAW] - hack, need this set for Orin test, not compiled is module
currently */
+static bool allow_unsafe_interrupts = true;
 module_param_named(allow_unsafe_interrupts,
                   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_interrupts,
@@ -1733,8 +1734,18 @@ static int vfio_bus_type(struct device *dev, void *data)
 {
        struct bus_type **bus = data;

-       if (*bus && *bus != dev->bus)
+       /**
+        * [MAW] - hack.  the orin tegra194-pcie is in this group and
+        * reports in as bus-type of "platform".  We will ignore it
+        * in an attempt to get vfio to play along.
+        */
+       if (!strcmp(dev->bus->name,"platform")) {
+               return 0;
+       }
+
+       if (*bus && *bus != dev->bus) {
                return -EINVAL;
+       }

        *bus = dev->bus;

