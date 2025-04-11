Return-Path: <kvm+bounces-43155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6ECA85ABC
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00E5D1BC1F76
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168DC238C20;
	Fri, 11 Apr 2025 10:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Li71ddM9"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C725221282;
	Fri, 11 Apr 2025 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369027; cv=none; b=LJT4Es4rk4pb3X06RSDR8TK7yhEbXLXdxKbtZVcT0NwzdhW76b8ZKMLo/NKAx4kWVbX+GxCroZl2k0wp6Jvg4yX0Dd44B/TC2ex5SL/kKzYJnG+pLKZJLLxWQp1xsr7vrzcymSw5XVqWaCsseLbGIPqf5NQDKX23LKH0Ywc7kO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369027; c=relaxed/simple;
	bh=zB/MGnfcUM0HicN1On6vH3cQhYwo+G4uPJU6tqb/Pgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX60GXNBknHayNVIa5/6gZ8OiO0kYbN/lqPpRDnz3JlGt05m1pQSGtespWDoUhriArsXHUuJMY141A6Zz/HtIw5ialiGDtHW8lMDqwTYBmOUZeUArLzUWUmaAG2a4qK6dYshRsA/4AvMhnMcjaslBpQl9Qhyhsr2nQkZp2HSxbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Li71ddM9; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744368973;
	bh=dnoZUln+EAjEGDwlnRvIY0rJIrjfNNUSfdyabxk3/N0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Li71ddM9aKP19uf1AwXGV5CCCAY5+C4xKJc2WxtHcRyRWsmvw0H9XE6Osd9a5cWt1
	 Q+cHArAWkaTnjnbuk23RZtdQ+U9gDbVdDAd0zhjXkAu62jNxbjGYmAcFRI6HiHXlgv
	 x/6OWjkXt6IyIWqmSINvdCdUCWGtM8x2TSYBxY5Y=
X-QQ-mid: bizesmtp23t1744368946t15cf48c
X-QQ-Originating-IP: ehBLQkOhan5VWsz5Lv+65mc8nv4szt2NCntTi+SKFNY=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 11 Apr 2025 18:55:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15212760454377048684
EX-QQ-RecipientCnt: 10
From: Chen Linxuan <chenlinxuan@uniontech.com>
To: Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: Winston Wen <wentao@uniontech.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/7] vfio/virtio: add __always_inline for virtiovf_get_device_config_size
Date: Fri, 11 Apr 2025 18:54:51 +0800
Message-ID: <27A329AA0DBF4A2B+20250411105459.90782-3-chenlinxuan@uniontech.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250411105459.90782-1-chenlinxuan@uniontech.com>
References: <31F42D8141CDD2D0+20250411105142.89296-1-chenlinxuan@uniontech.com>
 <20250411105459.90782-1-chenlinxuan@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: M9OL2U7tWoeKVuKD663Z/dXV0DPNz+cv8UHITxKw6UV4gDMi1R6n144D
	VyEBO1HNO1H0nRZPVeaIWwSvVNTRU4mcBYQes+2PuLcRM2CjzlKop4GtSvu1WilzEM4yUj+
	5CHd91FYjlEFkxehBLmqfGxeIaSRf2Rj5++coAqFI0H63wnIhOI+jjyeg3SQAmnHxEZPGZt
	CASF7CR/k2DlUgHRPJzmaf+WDVLiixHnEb7CDqevNbPOakp7RqjQEOqGlWibZXEF5b8icCY
	BhZoNuv2t8GzJal4jA7WsULRVOmR0E2iRjPvgJN1z2rkNy/7JKERScAlehnmKewr0DTa2v5
	36YuhBGVyAUVH6ja/I1c2wvl9/Lnzn3Xd+Fkh9EEKPEAnyV6pud8ZUG6ciq2F3ZvA4VynZT
	w8S4lgzOa1bR3AXqwuSlnA+EFz1rLasBiHgfCaaKREGIV6b0A7jHqMZ0b2rSxHBiEdWAr/O
	qUvKty7rhugcHHNwP9CmbYk93hdVpArIg3C52cVSp1CTfckIRLrZet2BDhBzarfmpewkaji
	JNxhMByv3o+RT4NIZ2w3dQWJ/EjhiYS8OoRBNIKbfjWsIQ76N2lh7VTJNErG0V0wZK+6ldd
	k3DAGh0hkwG8KRL9CbKYewMaYONYFuQp6quRsScnntHC9IK9JiyBVb5YMGgi6weD33vsKtn
	0jc/Zf1FamqyWgquiaxKFkLRCgfH+ko+sTmoLXW+5a3bA0NnIjHe3GdV7cZSW7h2TO4rZ/0
	5QKZ9va7M8lp4ntYQlvy83mCG1zMn/Vkl9MtUKrt67VsJjhnRvZYQcejDHySgh90ov9l8ZE
	6tG/jyQbKRmjBuZJeTYcD4HmG+eN5xBv86Sr/OYgi+IEHHVjxWC2wyLSkZeu8/J5cga+WuC
	j+7HkqMPkx7eZFwILQget+E11gB1a/+jGSzum5uswPCD/ULiWF77RSzQpDqVS3/7PLyhy8T
	/WK+0OVJyVaCPrKNAcoXcFsQT1lyCMx8SclU1308jXohNYqmnuikpeNljgaOfzvp/Hyk+m2
	RrfqqDx0+6dxSj98nhVgN99vZRLzVJZvarXrMWMw==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

From: Winston Wen <wentao@uniontech.com>

On x86_64 with gcc version 13.3.0, I compile
drivers/vfio/pci/virtio/legacy_io.c with:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_VFIO=m
    echo CONFIG_VIRTIO_PCI=y
    echo CONFIG_VIRTIO_PCI_LIB_LEGACY=y
    echo CONFIG_VIRTIO_VFIO_PCI=m
    echo CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY=y
  )
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once" \
    drivers/vfio/pci/virtio/legacy_io.o

Then I get a compile error:

    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC      drivers/vfio/pci/virtio/legacy_io.o
  In file included from <command-line>:
  drivers/vfio/pci/virtio/legacy_io.c: In function 'virtiovf_init_legacy_io':
  ././include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_889' declared with attribute error: BUILD_BUG_ON failed: !is_power_of_2(virtvdev->bar0_virtual_buf_size)
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |                                             ^
  ././include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
    538 |                         prefix ## suffix();                             \
        |                         ^~~~~~
  ././include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^~~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        |         ^~~~~~~~~~~~~~~~
  drivers/vfio/pci/virtio/legacy_io.c:401:9: note: in expansion of macro 'BUILD_BUG_ON'
    401 |         BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
        |         ^~~~~~~~~~~~

Signed-off-by: Winston Wen <wentao@uniontech.com>
Co-Developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
---
 drivers/vfio/pci/virtio/legacy_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
index 832af5ba267c..b6871d50b9f9 100644
--- a/drivers/vfio/pci/virtio/legacy_io.c
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -350,7 +350,7 @@ int virtiovf_open_legacy_io(struct virtiovf_pci_core_device *virtvdev)
 	return virtiovf_set_notify_addr(virtvdev);
 }
 
-static int virtiovf_get_device_config_size(unsigned short device)
+static __always_inline int virtiovf_get_device_config_size(unsigned short device)
 {
 	/* Network card */
 	return offsetofend(struct virtio_net_config, status);
-- 
2.48.1


