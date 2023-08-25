Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2E7788870
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbjHYNXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245123AbjHYNXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5E9198E
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwpRg1vimm5ETXVsPhZVAnSc4Fv0IJpzAFNNkLS8G5k=;
        b=NSxUM7WCA9Zaxx3h3CmjmADRR1++V0s0AMsvbg7AjvlcuVsEQY2HG1DLfBeobjfoZPOeCG
        Et71kKSZNBtW1o/fEaTMN3NNabFG1FPax5pjqRIpfIxc71tR0dte4nYVmOPW2qqWqYfJgo
        7TxxUQ2erk2xwYcJ83/a6mJ0iVNv7Jo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-qH3Fln_PNQiuvYXvEPTgSw-1; Fri, 25 Aug 2023 09:22:07 -0400
X-MC-Unique: qH3Fln_PNQiuvYXvEPTgSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC357185A78B;
        Fri, 25 Aug 2023 13:22:06 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63AC3140E950;
        Fri, 25 Aug 2023 13:22:03 +0000 (UTC)
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
Subject: [PATCH v2 03/16] softmmu/physmem: Fixup qemu_ram_block_from_host() documentation
Date:   Fri, 25 Aug 2023 15:21:36 +0200
Message-ID: <20230825132149.366064-4-david@redhat.com>
In-Reply-To: <20230825132149.366064-1-david@redhat.com>
References: <20230825132149.366064-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 87dc9a752c..cc491a4bf4 100644
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
index 3df73542e1..57469b3c97 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -2181,23 +2181,6 @@ ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
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

