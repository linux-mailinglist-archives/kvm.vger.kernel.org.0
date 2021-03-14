Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E49533A339
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 07:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhCNFc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 00:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhCNFbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 00:31:45 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D791C061574;
        Sat, 13 Mar 2021 21:31:45 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id r14so6999349qtt.7;
        Sat, 13 Mar 2021 21:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pt2qdmEDjVSEplThpxjXlBTKYUfK3U6l0UtYEmF5juA=;
        b=LH7DgidSNjqwOPZ+7U0UkXVMWk8qgATc9lVh/wu6WFPKqMU5XZIgiUA5Cc0G+qlr67
         PjAU4SMmyNqT6jUE1w91Ih6z9PQSOp7Ufok2PbM4QXlTCVlMSgGYJv62neC6Fvi4SL9v
         CEvOgtJvTaXDG6EIWJJYSJCIR5QOL+8Zie4wwOUDXwJgslyrgHqSXiwMJyQTcjoHbi9L
         wn22Aiw8B7IlT+TMdT5vvWx7We4voyyilyDpQkK2xR3M4BKNQLOKo6oS0WHoAK+Yi8ko
         Ki/cDbmbcTfGfitPLrT+2PO4/0f5Q3ST+xlSpaBqM2jeRJfpYscuDUfb4XatdyO8P9Vd
         KJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pt2qdmEDjVSEplThpxjXlBTKYUfK3U6l0UtYEmF5juA=;
        b=cMH78blmSRK5L0pmMKplKtkiMvXIohINtfWG1qlgPGyAwTH61uh/gFukflWSp6OQ7f
         sLxn6qs7bu7xjoa23JXDeIoGbfGrjtdiZ1Eracxg4vKiZkDfvItd07BnHB/srZmaQSrF
         4J/2VUTd4r0VUHd8T0y9pC9MFg4xC3F6b6XoMeDZgTSjoLyS+9bGHDtMC+DWPMclJjLS
         c2RZk9Gcr7iaNZ4strAekzPNR1HMBvSrQfKkY+KZ7IV9/7L8/3wwkjtGPNq76AS2XRKe
         G3uSwcl469c2F2mZ7+URF1R2guD7XcSQsTXHrXhL/R/iyT0Ui2ap9iZSMKsHfMxW0Rk8
         F4Rw==
X-Gm-Message-State: AOAM533mK0Odyk/yWiDFcamkdxpTOYcb06aj1kTZvt63lnDryX0GCn1c
        6qJ24NhXYm1hIHyDKB42eB8=
X-Google-Smtp-Source: ABdhPJx4xEdu1pcTey9WTXS+ph+qH+nrmlxv7BzqERauCq5YGrPqJQqKhrCVCozDakqpm59ea4AfxQ==
X-Received: by 2002:ac8:d85:: with SMTP id s5mr18246201qti.390.1615699904167;
        Sat, 13 Mar 2021 21:31:44 -0800 (PST)
Received: from localhost.localdomain ([37.19.198.30])
        by smtp.gmail.com with ESMTPSA id d24sm8425145qkl.49.2021.03.13.21.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 21:31:43 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, akpm@linux-foundation.org, peterx@redhat.com,
        giovanni.cabiddu@intel.com, walken@google.com, jannh@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] vfio: pci: Spello fix in the file vfio_pci.c
Date:   Sun, 14 Mar 2021 10:59:25 +0530
Message-Id: <20210314052925.3560-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/permision/permission/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/vfio/pci/vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 706de3ef94bb..62f137692a4f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2411,7 +2411,7 @@ static int __init vfio_pci_init(void)
 {
 	int ret;

-	/* Allocate shared config space permision data used by all devices */
+	/* Allocate shared config space permission data used by all devices */
 	ret = vfio_pci_init_perm_bits();
 	if (ret)
 		return ret;
--
2.26.2

