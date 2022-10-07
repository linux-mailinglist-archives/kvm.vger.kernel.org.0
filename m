Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556C45F7D8C
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJGS5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 14:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJGS5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 14:57:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23633BC75
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 11:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665169040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=USA0dLCp3e0T9kFwGZ6UENNK9SM+xdYbqavMS0yMc6U=;
        b=c7XAAJHaor/4ic8adpK/MV/gERDPf6x7se+ua/jiXXAXRpOPdOVr6JlkCjfrcZuq+MVz/L
        6NWh82rS9SMpPh2mpNkWFZGavGGodkNF8r4tdP9fKWKAQrnVcaElyYyB/GFk7MqMgqAPXW
        Mdy5YSPK4BS5gY4qHpn+DG0VQSFDUTk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-yn0zLaQTPUGyT4wi2SziLw-1; Fri, 07 Oct 2022 14:57:16 -0400
X-MC-Unique: yn0zLaQTPUGyT4wi2SziLw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5479A101A528;
        Fri,  7 Oct 2022 18:57:16 +0000 (UTC)
Received: from [172.30.42.193] (unknown [10.22.8.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1792A4B3FC6;
        Fri,  7 Oct 2022 18:57:16 +0000 (UTC)
Subject: [PATCH] vfio: More vfio_file_is_group() use cases
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, jgg@nvidia.com
Date:   Fri, 07 Oct 2022 12:57:14 -0600
Message-ID: <166516896843.1215571.5378890510536477434.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace further open coded tests with helper.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Applies on https://lore.kernel.org/all/0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com/

 drivers/vfio/vfio_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 04099a839a52..2d168793d4e1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1615,7 +1615,7 @@ bool vfio_file_enforced_coherent(struct file *file)
 	struct vfio_group *group = file->private_data;
 	bool ret;
 
-	if (file->f_op != &vfio_group_fops)
+	if (!vfio_file_is_group(file))
 		return true;
 
 	mutex_lock(&group->group_lock);
@@ -1647,7 +1647,7 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
 	struct vfio_group *group = file->private_data;
 
-	if (file->f_op != &vfio_group_fops)
+	if (!vfio_file_is_group(file))
 		return;
 
 	mutex_lock(&group->group_lock);
@@ -1667,7 +1667,7 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 {
 	struct vfio_group *group = file->private_data;
 
-	if (file->f_op != &vfio_group_fops)
+	if (!vfio_file_is_group(file))
 		return false;
 
 	return group == device->group;


