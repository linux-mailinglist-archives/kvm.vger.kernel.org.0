Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDAC70D089
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbjEWBeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjEWBeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:34:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445868E;
        Mon, 22 May 2023 18:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B4662D89;
        Tue, 23 May 2023 01:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F37C433EF;
        Tue, 23 May 2023 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684805660;
        bh=BmXuXL/UqVGFg/YhKou0jzuTdayluGE9Gf9Xkd6BVDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfscvJfn2ijg4fxrfryZM+rU1I0wnEP4MwW1JE7SHohU7DE9kVcS4HjalgALAffN7
         8d3CKw/1b4BibMj/OUI75yQbJGV5kDG8GAs28Y/i/LwoUTP43GmqVQiin9IEBL7JT+
         Xmz1mTEKTvhmGB7FPfUDnTcYPIfjOHqoBp7H+ZE4I80oyDsXaUFeXuZXZGUVinrSTf
         SFkCl0DqANpM+H5LZz7G2s0dorWeznI8JXT0BmR3lkJMtRGu7o4ICJLS7QaFsACoR2
         bDsXg84vGUHdtQZ1C4lvtpAQzHyZZmdApp6/9eVz3rt80/+kYS/y8ZMtoiTbAqsfLr
         sJD7l6zWlkVNA==
Date:   Mon, 22 May 2023 19:35:12 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Message-ID: <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
References: <cover.1684805398.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1684805398.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element array with flexible-array
member in struct vfio_ccw_parent and refactor the the rest of the code
accordingly.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/297
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 3 ++-
 drivers/s390/cio/vfio_ccw_private.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ff538a086fc7..57906a9c6324 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -171,7 +171,8 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		return -ENODEV;
 	}
 
-	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	parent = kzalloc(sizeof(*parent) + sizeof(struct mdev_type *),
+			 GFP_KERNEL);
 	if (!parent)
 		return -ENOMEM;
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b441ae6700fd..b62bbc5c6376 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -79,7 +79,7 @@ struct vfio_ccw_parent {
 
 	struct mdev_parent	parent;
 	struct mdev_type	mdev_type;
-	struct mdev_type	*mdev_types[1];
+	struct mdev_type	*mdev_types[];
 };
 
 /**
-- 
2.34.1

