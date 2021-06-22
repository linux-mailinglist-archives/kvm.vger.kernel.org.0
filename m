Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4913B0D06
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhFVSja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:39:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhFVSj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:39:29 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lvlGo-0000m7-VC; Tue, 22 Jun 2021 18:37:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] vfio/mdpy: Fix memory leak of object mdev_state->vconfig
Date:   Tue, 22 Jun 2021 19:37:10 +0100
Message-Id: <20210622183710.28954-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where the call to vfio_register_group_dev fails the error
return path kfree's mdev_state but not mdev_state->vconfig. Fix this
by kfree'ing mdev_state->vconfig before returning.

Addresses-Coverity: ("Resource leak")
Fixes: 437e41368c01 ("vfio/mdpy: Convert to use vfio_register_group_dev()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 samples/vfio-mdev/mdpy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 7e9c9df0f05b..393c9df6f6a0 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -261,6 +261,7 @@ static int mdpy_probe(struct mdev_device *mdev)
 
 	ret = vfio_register_group_dev(&mdev_state->vdev);
 	if (ret) {
+		kfree(mdev_state->vconfig);
 		kfree(mdev_state);
 		return ret;
 	}
-- 
2.31.1

