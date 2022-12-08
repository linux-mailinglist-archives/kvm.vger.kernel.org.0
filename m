Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761D66473CD
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLHQC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLHQCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:02:25 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8709D2FD;
        Thu,  8 Dec 2022 08:02:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d1so2126055wrs.12;
        Thu, 08 Dec 2022 08:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+upKZf2dVdk/UxAtWyh1oWLSgNq0wwxbyFaq7JE/2d8=;
        b=Q44swHCZKzaZk3wZ/4tWkIvan1eLvsEiQW7rNIsOHb7fsy0lRHKtKLn2K/vwcQ9c1p
         kIvp+9JrZ9UIhJZOHKnFFn6oZhAqcBTAuajF5GNjSTE8NUE3ytFTPCG4l9I7w4N20lcN
         mcL3LJ5E5cwcJlU+tNZpCrtYeK3R6iejM/i/Iy2qo/jGOGyZ4a2mPOaZbo3RhlkZ+d0M
         fmhjeue1qH8ZumemCJBnu8YUbk9YRzHTTP9bEtt+daUoGkfialkFTXaZA9mI4Zz31e1i
         f0K091Mb0TDdLLiRO0h1qhZKCpWoJLkQaMUancARgTdkOxJCbX3mgaDK24a+ol4W6viz
         xEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+upKZf2dVdk/UxAtWyh1oWLSgNq0wwxbyFaq7JE/2d8=;
        b=xnTdlwu+l1fncpV2muHEaklIiWq6S2BDbfPbdTpaSMleu0fPW90gcFUz2/cEQCNsR/
         o3FHd7QHDR79JQp18qUmBTAm6kTwUC860vmLilF1Ymbzws11roAUQxKK06QH2bSlz6zD
         sVgF3a1ptwH47Xydr5o3jZHHGGhIT9OM8zeWqSB3g0LHajB81FiiYnEzy3Vj0/2CXJ/C
         8EwmXF+YrjpRYCJxH9sG0F/gvSnZhXBfWIYYS0U0rPC6+Poo5ZUjKzY+SHGRSif9fiHO
         i3glqgA5PYvbs2klk8l6BdmCAZzRh3FEXiNFHJgCCuGCpaMtaZisB3Qy6YI2z8I3HyYS
         ypxg==
X-Gm-Message-State: ANoB5pltVR8ceHhsiBTmVefqf2lG1DIH80zpCoDukSPtf7Bqj92X/EJP
        xijAdtnSy0O2cY8CPp0Dd9E8V4VVodOGyWCC
X-Google-Smtp-Source: AA0mqf6cVDconk+NrqZYCtCxzkB8M9gK+LbspUehJ3DlRyW6zfhGopBADDFnhNtDQcH9zshOojkuWw==
X-Received: by 2002:adf:e743:0:b0:242:1c58:8ea7 with SMTP id c3-20020adfe743000000b002421c588ea7mr1834127wrn.46.1670515340150;
        Thu, 08 Dec 2022 08:02:20 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d18-20020adfe892000000b002425be3c9e2sm12558272wrm.60.2022.12.08.08.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:02:19 -0800 (PST)
Date:   Thu, 8 Dec 2022 19:02:17 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] vfio/mlx5: error pointer dereference in error handling
Message-ID: <Y5IKia5SaiVxYmG5@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5IKVknlf5Z5NPtU@kili>
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This code frees the wrong "buf" variable and results in an error pointer
dereference.

Fixes: 34e2f27143d1 ("vfio/mlx5: Introduce multiple loads")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Why did get_maintainer.pl not add Yishai to the CC list?

 drivers/vfio/pci/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 83137228352e..9feb89c6d939 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -826,7 +826,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	spin_lock_init(&migf->list_lock);
 	return migf;
 out_buf:
-	mlx5vf_free_data_buffer(buf);
+	mlx5vf_free_data_buffer(migf->buf);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
-- 
2.35.1

