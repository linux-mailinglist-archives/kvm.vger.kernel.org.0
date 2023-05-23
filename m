Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44F670D092
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjEWBff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjEWBfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:35:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75E9E;
        Mon, 22 May 2023 18:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2493162D90;
        Tue, 23 May 2023 01:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFFC433D2;
        Tue, 23 May 2023 01:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684805707;
        bh=ZVMZMDyY6PGeWLHzzzIJkAPjAJ4vdQOwm8Dt6MaAg4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qKNIA0kdKj7tAvK2gRaXubxah2TuEOe4R60oz9LFjX5XtltGDbZh/dElX5UrODlWQ
         96ti7dPfXUF5sBC6KfECWZLqEVHvqIOha3ZjDDE5qxy6zyLybP80e9Kh+PSOQr4Bbr
         2s3vbccXWZ8VxznWOUzBsOznhssnAerPySzO5+a+ca9n29gvCR0vkoTaSOiLMACwE+
         pgRpSmESYc559R8moYJ2qtlDgboB/EkoXI7qElZwEi9sDX8cyMcM/BwS2J8FU8QtdR
         XiJ7uYl+B9my4O5b0LCRRlCtKVGMBfZoCj7GNfNPW4TiLDsIJwTS69P8QgKWe1SLmL
         UoD4+02u+dQhA==
Date:   Mon, 22 May 2023 19:35:59 -0600
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
Subject: [PATCH 2/2][next] vfio/ccw: Use struct_size() helper
Message-ID: <f657276073630e806e69726a40ad1cc85101448a.1684805398.git.gustavoars@kernel.org>
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

Prefer struct_size() over open-coded versions.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 57906a9c6324..43601816ea4e 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -171,8 +171,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		return -ENODEV;
 	}
 
-	parent = kzalloc(sizeof(*parent) + sizeof(struct mdev_type *),
-			 GFP_KERNEL);
+	parent = kzalloc(struct_size(parent, mdev_types, 1), GFP_KERNEL);
 	if (!parent)
 		return -ENOMEM;
 
-- 
2.34.1

