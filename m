Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFFB443E3E
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 09:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhKCITp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 04:19:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15355 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhKCITp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 04:19:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hkfkd678Zz90V8;
        Wed,  3 Nov 2021 16:16:57 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:06 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:06 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v5 1/6] vfio: simplify the conditional statements in vfio_msi_enable
Date:   Wed, 3 Nov 2021 16:16:52 +0800
Message-ID: <20211103081657.1945-2-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211103081657.1945-1-longpeng2@huawei.com>
References: <20211103081657.1945-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's unnecessary to test against the specific return value of
VFIO_DEVICE_SET_IRQS, since any positive return is an error
indicating the number of vectors we should retry with.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 hw/vfio/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 5cdf1d4..dd30806 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -650,7 +650,7 @@ retry:
     if (ret) {
         if (ret < 0) {
             error_report("vfio: Error: Failed to setup MSI fds: %m");
-        } else if (ret != vdev->nr_vectors) {
+        } else {
             error_report("vfio: Error: Failed to enable %d "
                          "MSI vectors, retry with %d", vdev->nr_vectors, ret);
         }
@@ -668,7 +668,7 @@ retry:
         g_free(vdev->msi_vectors);
         vdev->msi_vectors = NULL;
 
-        if (ret > 0 && ret != vdev->nr_vectors) {
+        if (ret > 0) {
             vdev->nr_vectors = ret;
             goto retry;
         }
-- 
1.8.3.1

