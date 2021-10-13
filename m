Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F2842BCDE
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhJMKgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:36:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhJMKgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiq5vh3dCNHXTt2L9OzYv4MKu2jV8o9+6xs4ComEFdU=;
        b=QzS3emDpHFgkWmd/4DDKKacnAUqdmaKevDn6yK0mJGYhteJfRNgXtqvGkxgKKij7GNrEBp
        dzAHmBv4vMEx4iEY/V25ZTEMYUCajn2+9ewC4iCUYGA9Sf3Xat2btL2j438PLHjazYL7Cr
        g0x+KaMoM8W9DdfimzS0EDcqI5q1Er4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-HnIIzyQSMuCRRQdXCqwBtA-1; Wed, 13 Oct 2021 06:34:16 -0400
X-MC-Unique: HnIIzyQSMuCRRQdXCqwBtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDCB4100CCC1;
        Wed, 13 Oct 2021 10:34:14 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2D3F5D9D5;
        Wed, 13 Oct 2021 10:33:50 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH RFC 01/15] memory: Drop mapping check from memory_region_get_ram_discard_manager()
Date:   Wed, 13 Oct 2021 12:33:16 +0200
Message-Id: <20211013103330.26869-2-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 3bcfc3899b..8669f78395 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2038,7 +2038,7 @@ int memory_region_iommu_num_indexes(IOMMUMemoryRegion *iommu_mr)
 
 RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
 {
-    if (!memory_region_is_mapped(mr) || !memory_region_is_ram(mr)) {
+    if (!memory_region_is_ram(mr)) {
         return NULL;
     }
     return mr->rdm;
-- 
2.31.1

