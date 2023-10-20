Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A227B7D08F7
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376387AbjJTG7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376363AbjJTG7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D77D51
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9pXnfvE217MgZiA1KwQf4E/+MFgK3AhJc1q/dcWL9Q=;
        b=UiIa/HkbH90wvnYlkZbjBeLZ8lSTCG2vg5n1vf1OG6FaSugezvrBRt5f81QkTk2hkFKxMj
        EOwoI4dZA+zc/c5Tb5+J67kVX6yKTYQv0S4EyRwZ+ciOatmjcdu438BEtumbVOZQ+q4nca
        kYmSJpUyJvry3LJVFt0L8HIU6e3bgkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-Gl8yl_f-MbqeImRuS8JXLA-1; Fri, 20 Oct 2023 02:58:23 -0400
X-MC-Unique: Gl8yl_f-MbqeImRuS8JXLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3D2B88B770;
        Fri, 20 Oct 2023 06:58:21 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 104A325C1;
        Fri, 20 Oct 2023 06:58:14 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Juan Quintela <quintela@redhat.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-arm@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        qemu-ppc@nongnu.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Xu <peterx@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jeff Cody <codyprime@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Fabiano Rosas <farosas@suse.de>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Greg Kurz <groug@kaod.org>, qemu-block@nongnu.org
Subject: [PULL 03/17] migration: Fix parse_ramblock() on overwritten retvals
Date:   Fri, 20 Oct 2023 08:57:37 +0200
Message-ID: <20231020065751.26047-4-quintela@redhat.com>
In-Reply-To: <20231020065751.26047-1-quintela@redhat.com>
References: <20231020065751.26047-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

It's possible that some errors can be overwritten with success retval later
on, and then ignored.  Always capture all errors and report.

Reported by Coverity 1522861, but actually I spot one more in the same
function.

Fixes: CID 1522861
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231017203855.298260-1-peterx@redhat.com>
---
 migration/ram.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 16c30a9d7a..92769902bb 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3873,6 +3873,7 @@ static int parse_ramblock(QEMUFile *f, RAMBlock *block, ram_addr_t length)
         ret = qemu_ram_resize(block, length, &local_err);
         if (local_err) {
             error_report_err(local_err);
+            return ret;
         }
     }
     /* For postcopy we need to check hugepage sizes match */
@@ -3883,7 +3884,7 @@ static int parse_ramblock(QEMUFile *f, RAMBlock *block, ram_addr_t length)
             error_report("Mismatched RAM page size %s "
                          "(local) %zd != %" PRId64, block->idstr,
                          block->page_size, remote_page_size);
-            ret = -EINVAL;
+            return -EINVAL;
         }
     }
     if (migrate_ignore_shared()) {
@@ -3893,7 +3894,7 @@ static int parse_ramblock(QEMUFile *f, RAMBlock *block, ram_addr_t length)
             error_report("Mismatched GPAs for block %s "
                          "%" PRId64 "!= %" PRId64, block->idstr,
                          (uint64_t)addr, (uint64_t)block->mr->addr);
-            ret = -EINVAL;
+            return -EINVAL;
         }
     }
     ret = rdma_block_notification_handle(f, block->idstr);
-- 
2.41.0

