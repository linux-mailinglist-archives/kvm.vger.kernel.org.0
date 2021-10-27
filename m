Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A3A43C9F8
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242006AbhJ0Mss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240311AbhJ0Msn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bxd5XP5fcsL/t1gO40/CCrT43QsDH7dh39uTsHCFhA=;
        b=Wwdfg0mWrYKjpfLDFI67/33ewd2Y3zBzimGbvZUv7C3yAI3PtiE2xr7J5XfJXF9KsGdty+
        6IjxXK66qG0MPLswmp5/X0KD+VVB+wGHyPNsTkVQHKme0IitAShlQycEqSXc/qaY74O0P5
        z0Z0wpxjTzeqdvMRAbWf2Uy+Croh10g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-v5V9zn3EM-aX8RYnt3439A-1; Wed, 27 Oct 2021 08:46:13 -0400
X-MC-Unique: v5V9zn3EM-aX8RYnt3439A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C23A78066F8;
        Wed, 27 Oct 2021 12:46:11 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BB61196E6;
        Wed, 27 Oct 2021 12:46:08 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 09/12] memory: Drop mapping check from memory_region_get_ram_discard_manager()
Date:   Wed, 27 Oct 2021 14:45:28 +0200
Message-Id: <20211027124531.57561-10-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's sufficient to check whether a memory region is RAM, the region
doesn't necessarily have to be mapped into another memory region.
For example, RAM memory regions mapped via an alias will never make
"memory_region_is_mapped()" succeed.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 softmmu/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/softmmu/memory.c b/softmmu/memory.c
index d8a584ca80..2496bff729 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2045,7 +2045,7 @@ int memory_region_iommu_num_indexes(IOMMUMemoryRegion *iommu_mr)
 
 RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
 {
-    if (!memory_region_is_mapped(mr) || !memory_region_is_ram(mr)) {
+    if (!memory_region_is_ram(mr)) {
         return NULL;
     }
     return mr->rdm;
-- 
2.31.1

