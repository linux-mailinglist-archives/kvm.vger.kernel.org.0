Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C064E5F69
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348613AbiCXHd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 03:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348816AbiCXHdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 03:33:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA198F7C;
        Thu, 24 Mar 2022 00:31:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a8so7325831ejc.8;
        Thu, 24 Mar 2022 00:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+jBes5m/e131YoblZZDRcsU52MDg1rSadlaC+RwD+To=;
        b=OpDuTpMtzE0RhGUG1pR+nWeI8o4UdMCn8dQbtGo4v9iN7ipB4uFu5TtqOgsDMnbQzg
         5WByTzpHx4HUeR2aygQUqWZivHblzmnQa3TSOVGXaqEVoDWMB10qb8N33crRMOdHIr6M
         OJSELDjXDkVT8uxqO6kauRy8KDSwk0AUvG/6fcnoBJ/8/i1IIHdGuQdc4St7F4x2xV7a
         1XqfulRiO0Tn+U3+AdANPPoaAvOtVEE5BVtaYH/3vZNeRG6qAzrag5p2BeupNmqs6oWj
         r6dYiCGfdF0LcQlDm3eSO1yniwkE7hKMZaL5X6ykXmZdEUOGn9r4uoAP2GTrWHlGv9mk
         PJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+jBes5m/e131YoblZZDRcsU52MDg1rSadlaC+RwD+To=;
        b=gUJmlPvmvVu9n1d253hmlyzd39p5uAXpSWq4/rzxAE+5RkHjDIiaX5azgTKRccqzkr
         GKpY98dPq8JkjTFPRZ4dd+iu5qMowLyzo/FAjMvFYGperIgeROd+kbvTbqVJ9/D2jkNn
         buVBvj5a68bWhPU/JPdjHDMT0FJ55o1ngJkG1mN+6bN0rtQiFSAEPkeoNPMCNHFJBaLD
         1ynEkGXmlZqYgLd0JX9MC1J/bqp7BUG4TXfkRs2eLNqeWZg8NGjfPSQIpqpTOeD2Vodi
         HVyx4FhGCmiCcHVuU4W9uqI00aBhTqN6YoQ+SGNe+cJJqX1pmUm8ni4ZftVYw8+MaXP1
         0r6w==
X-Gm-Message-State: AOAM532MTNZKxfr7JdRCYX3CvUDQML/cs3oiNtgm6MZvMydOX9+rsH5J
        fLWHDaZuY46zzQUQRqEPK0w=
X-Google-Smtp-Source: ABdhPJxGCYgDslAQ72jIbmPmxq00EDKcqrzvpkwqbfjfh2yCC066UqwRfcKn5mcV8ECIgeY5CKLC2w==
X-Received: by 2002:a17:906:a1c8:b0:6da:a635:e402 with SMTP id bx8-20020a170906a1c800b006daa635e402mr4201959ejb.598.1648107101128;
        Thu, 24 Mar 2022 00:31:41 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id gv9-20020a170906f10900b006d7128b2e6fsm766705ejb.162.2022.03.24.00.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:31:40 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] vfio/spapr_tce: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:31:10 +0100
Message-Id: <20220324073110.66125-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 708a95e61831..f64ef767909a 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -104,8 +104,7 @@ static long tce_iommu_unregister_pages(struct tce_container *container,
 		__u64 vaddr, __u64 size)
 {
 	struct mm_iommu_table_group_mem_t *mem;
-	struct tce_iommu_prereg *tcemem;
-	bool found = false;
+	struct tce_iommu_prereg *tcemem = NULL, *iter;
 	long ret;
 
 	if ((vaddr & ~PAGE_MASK) || (size & ~PAGE_MASK))
@@ -115,14 +114,14 @@ static long tce_iommu_unregister_pages(struct tce_container *container,
 	if (!mem)
 		return -ENOENT;
 
-	list_for_each_entry(tcemem, &container->prereg_list, next) {
-		if (tcemem->mem == mem) {
-			found = true;
+	list_for_each_entry(iter, &container->prereg_list, next) {
+		if (iter->mem == mem) {
+			tcemem = iter;
 			break;
 		}
 	}
 
-	if (!found)
+	if (!tcemem)
 		ret = -ENOENT;
 	else
 		ret = tce_iommu_prereg_free(container, tcemem);
@@ -1330,19 +1329,19 @@ static void tce_iommu_detach_group(void *iommu_data,
 {
 	struct tce_container *container = iommu_data;
 	struct iommu_table_group *table_group;
-	bool found = false;
-	struct tce_iommu_group *tcegrp;
+	struct tce_iommu_group *tcegrp = NULL;
+	struct tce_iommu_group *iter;
 
 	mutex_lock(&container->lock);
 
-	list_for_each_entry(tcegrp, &container->group_list, next) {
-		if (tcegrp->grp == iommu_group) {
-			found = true;
+	list_for_each_entry(iter, &container->group_list, next) {
+		if (iter->grp == iommu_group) {
+			tcegrp = iter;
 			break;
 		}
 	}
 
-	if (!found) {
+	if (!tcegrp) {
 		pr_warn("tce_vfio: detaching unattached group #%u\n",
 				iommu_group_id(iommu_group));
 		goto unlock_exit;

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

