Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D4F28F1F9
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgJOMWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 08:22:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35173 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgJOMWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 08:22:31 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kT2H4-0006lp-Q3; Thu, 15 Oct 2020 12:22:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/fsl-mc: fix the return of the uninitialized variable ret
Date:   Thu, 15 Oct 2020 13:22:26 +0100
Message-Id: <20201015122226.485911-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the success path in function vfio_fsl_mc_reflck_attach is
returning an uninitialized value in variable ret. Fix this by setting
this to zero to indicate success.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 80fc7f4ed343..42a5decb78d1 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -84,6 +84,7 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
 		vfio_fsl_mc_reflck_get(cont_vdev->reflck);
 		vdev->reflck = cont_vdev->reflck;
 		vfio_device_put(device);
+		ret = 0;
 	}
 
 unlock:
-- 
2.27.0

