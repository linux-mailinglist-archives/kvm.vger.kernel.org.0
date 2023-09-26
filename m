Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003B07AF378
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 20:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbjIZS7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 14:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbjIZS7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 14:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F1913A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 11:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695754716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q/KeM+cRvn3GHTg7YjBM909At/Q8zVrNV7vc1/nVhPQ=;
        b=U0c7Bog4Ej2KbK1G6slkwv0l+Xsi+JqRrB6C5DvB/DUC1nagqPP9ww9LINfOkt6A09RVZw
        LOmnDuWWWUHC26HadJpcZIL5oFqeC8i64wGFBTJORZjCLpEe4cG9AGS+xENnBVA6opFOFV
        OYRIj+2+JReGm/4dOp/nJobGdbqYRI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-fT9mbBPmMxGc39bmmIY2Vw-1; Tue, 26 Sep 2023 14:58:30 -0400
X-MC-Unique: fT9mbBPmMxGc39bmmIY2Vw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1200800962;
        Tue, 26 Sep 2023 18:58:27 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B27692026D4B;
        Tue, 26 Sep 2023 18:58:19 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v4 03/18] softmmu/physmem: Fixup qemu_ram_block_from_host() documentation
Date:   Tue, 26 Sep 2023 20:57:23 +0200
Message-ID: <20230926185738.277351-4-david@redhat.com>
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
References: <20230926185738.277351-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's fixup the documentation (e.g., removing traces of the ram_addr
parameter that no longer exists) and move it to the header file while at
it.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/exec/cpu-common.h | 15 +++++++++++++++
 softmmu/physmem.c         | 17 -----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 41788c0bdd..e29b13dc70 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -76,6 +76,21 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
 RAMBlock *qemu_ram_block_by_name(const char *name);
+
+/*
+ * Translates a host ptr back to a RAMBlock and an offset in that RAMBlock.
+ *
+ * @ptr: The host pointer to translate.
+ * @round_offset: Whether to round the result offset down to a target page
+ * @offset: Will be set to the offset within the returned RAMBlock.
+ *
+ * Returns: RAMBlock (or NULL if not found)
+ *
+ * By the time this function returns, the returned pointer is not protected
+ * by RCU anymore.  If the caller is not within an RCU critical section and
+ * does not hold the iothread lock, it must have other means of protecting the
+ * pointer, such as a reference to the memory region that owns the RAMBlock.
+ */
 RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
                                    ram_addr_t *offset);
 ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host);
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 4f6ca653b3..40105d558d 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -2221,23 +2221,6 @@ ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
     return res;
 }
 
-/*
- * Translates a host ptr back to a RAMBlock, a ram_addr and an offset
- * in that RAMBlock.
- *
- * ptr: Host pointer to look up
- * round_offset: If true round the result offset down to a page boundary
- * *ram_addr: set to result ram_addr
- * *offset: set to result offset within the RAMBlock
- *
- * Returns: RAMBlock (or NULL if not found)
- *
- * By the time this function returns, the returned pointer is not protected
- * by RCU anymore.  If the caller is not within an RCU critical section and
- * does not hold the iothread lock, it must have other means of protecting the
- * pointer, such as a reference to the region that includes the incoming
- * ram_addr_t.
- */
 RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
                                    ram_addr_t *offset)
 {
-- 
2.41.0

