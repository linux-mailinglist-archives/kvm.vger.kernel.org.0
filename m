Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196296AFA07
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 00:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCGXDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 18:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCGXD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 18:03:27 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274B430D4
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 15:02:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id C8E5F37E2EEAEC;
        Tue,  7 Mar 2023 17:02:50 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FQPbnyViRQ7x; Tue,  7 Mar 2023 17:02:50 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 1F86237E2EEAE9;
        Tue,  7 Mar 2023 17:02:50 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 1F86237E2EEAE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678230170; bh=axszmPS1SmBEyyKijsv3+OMSLd1RAFJa3JJFkvUQwI8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=XFdlLT2qka19mnTWCsj/sl9oqo0ntBaB5VHTMYzIwyLPY68Wz1T5jHqui3lrhyvEU
         jX2u7YKrSN/4422IImThgEcKjfjqr69ixYWSDLq8r9VwKdolFb9m+FphmKIkPyBcP+
         wxvydTF/ddH9JzzgwxQ5sFqhu588WE3IqAOCKVB0=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ovDIoYhBbRA1; Tue,  7 Mar 2023 17:02:50 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id ECE3837E2EEAE6;
        Tue,  7 Mar 2023 17:02:49 -0600 (CST)
Date:   Tue, 7 Mar 2023 17:02:48 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <1167019171.17313594.1678230168160.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH] Check for IOMMU table validity in error handler
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC111 (Linux)/8.5.0_GA_3042)
Thread-Index: 16Rw4CWOU+ViWflRkxTny/P6bTpyWw==
Thread-Topic: Check for IOMMU table validity in error handler
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If tce_iommu_take_ownership is unable to take ownership of
a specific IOMMU table, the unwinder in the error handler
could attempt to release ownership of an invalid table.

Check validity of each table in the unwinder before attempting
to release ownership.  Thanks to Alex Williamson for the initial
observation!

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 60a50ce8701e..c012ecb42ebc 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1219,10 +1219,15 @@ static int tce_iommu_take_ownership(struct tce_container *container,
 
 		rc = iommu_take_ownership(tbl);
 		if (rc) {
-			for (j = 0; j < i; ++j)
-				iommu_release_ownership(
-						table_group->tables[j]);
+			for (j = 0; j < i; ++j) {
+				struct iommu_table *tbl =
+					table_group->tables[j];
 
+				if (!tbl || !tbl->it_map)
+					continue;
+
+				iommu_release_ownership(table_group->tables[j]);
+			}
 			return rc;
 		}
 	}
-- 
2.30.2
