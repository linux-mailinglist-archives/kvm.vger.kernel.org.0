Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B27E732BA1
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbjFPJat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344574AbjFPJaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD1835A4
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrIsuj8P2fGHt+ZGLxwaK6fHrqnFvogAvTAHW3bYqLU=;
        b=CUtFu3mmrIrNlq4b1DVE6IBK2+y6/GTPPpqm1ptkxRDrvVo6I9uDujQgQiEKhthCIjKVEd
        y2/vyjtJng/7Aw1PwdMHCOb/JYaMsvA18NNIE+YiPJUlurVRNBL4Xe7t6RNDeL3OUVwP12
        J7FWw/Zw5s37cjPg3oYs+G17npKUi1U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-QLZAiEhYPJmslZV6usd--Q-1; Fri, 16 Jun 2023 05:27:49 -0400
X-MC-Unique: QLZAiEhYPJmslZV6usd--Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 558203C28BE0;
        Fri, 16 Jun 2023 09:27:49 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3352C1121314;
        Fri, 16 Jun 2023 09:27:46 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH v1 12/15] memory: Clarify mapping requirements for RamDiscardManager
Date:   Fri, 16 Jun 2023 11:26:51 +0200
Message-Id: <20230616092654.175518-13-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We really only care about the RAM memory region not being mapped into
an address space yet as long as we're still setting up the
RamDiscardManager. Once mapped into an address space, memory notifiers
would get notified about such a region and any attempts to modify the
RamDiscardManager would be wrong.

While "mapped into an address space" is easy to check for RAM regions that
are mapped directly (following the ->container links), it's harder to
check when such regions are mapped indirectly via aliases. For now, we can
only detect that a region is mapped through an alias (->mapped_via_alias),
but we don't have a handle on these aliases to follow all their ->container
links to test if they are eventually mapped into an address space.

So relax the assertion in memory_region_set_ram_discard_manager(),
remove the check in memory_region_get_ram_discard_manager() and clarify
the doc.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/exec/memory.h | 5 +++--
 softmmu/memory.c      | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index c3661b2276..1e35a2c828 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -590,8 +590,9 @@ typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
  * populated (consuming memory), to be used/accessed by the VM.
  *
  * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
- * #MemoryRegion isn't mapped yet; it cannot change while the #MemoryRegion is
- * mapped.
+ * #MemoryRegion isn't mapped into an address space yet (either directly
+ * or via an alias); it cannot change while the #MemoryRegion is
+ * mapped into an address space.
  *
  * The #RamDiscardManager is intended to be used by technologies that are
  * incompatible with discarding of RAM (e.g., VFIO, which may pin all
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 7d9494ce70..c1e8aa133f 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2081,7 +2081,7 @@ int memory_region_iommu_num_indexes(IOMMUMemoryRegion *iommu_mr)
 
 RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
 {
-    if (!memory_region_is_mapped(mr) || !memory_region_is_ram(mr)) {
+    if (!memory_region_is_ram(mr)) {
         return NULL;
     }
     return mr->rdm;
@@ -2090,7 +2090,7 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
 void memory_region_set_ram_discard_manager(MemoryRegion *mr,
                                            RamDiscardManager *rdm)
 {
-    g_assert(memory_region_is_ram(mr) && !memory_region_is_mapped(mr));
+    g_assert(memory_region_is_ram(mr));
     g_assert(!rdm || !mr->rdm);
     mr->rdm = rdm;
 }
-- 
2.40.1

