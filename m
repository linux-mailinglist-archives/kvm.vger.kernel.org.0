Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692B21DB33F
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgETMc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46268 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726785AbgETMc1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 08:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NG0vPHohaFewMo5kIy5Kz+ptuosA4jrQTaOaChzyKGY=;
        b=IAr6A1MP2qC0UUSu7iAkU3Olx7e/IoF4MKHMwhVjCr6jiRPjZSL3kZEPNVcdGLC77mmbf/
        YexJgsq18j/b/qskfTtfmYOcogH7yAgluwfXJiQnriIYaTdnPzZ6PFqKKW2Oaic1pLrlRZ
        4YcmddJu9oxjNG7mKjpVbf920zMX4DI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-V2a6Qn7gNQy6YnptGaqThQ-1; Wed, 20 May 2020 08:32:23 -0400
X-MC-Unique: V2a6Qn7gNQy6YnptGaqThQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EB7118FE860;
        Wed, 20 May 2020 12:32:22 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E036B6E9EA;
        Wed, 20 May 2020 12:32:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 03/19] accel/kvm: Convert to ram_block_discard_disable()
Date:   Wed, 20 May 2020 14:31:36 +0200
Message-Id: <20200520123152.60527-4-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Discarding memory does not work as expected. At the time this is called,
we cannot have anyone active that relies on discards to work properly.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d06cc04079..7a6158fb99 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -40,7 +40,6 @@
 #include "trace.h"
 #include "hw/irq.h"
 #include "sysemu/sev.h"
-#include "sysemu/balloon.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
 #include "qapi/qapi-visit-common.h"
@@ -2143,7 +2142,7 @@ static int kvm_init(MachineState *ms)
 
     s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
     if (!s->sync_mmu) {
-        qemu_balloon_inhibit(true);
+        g_assert(ram_block_discard_disable(true));
     }
 
     return 0;
-- 
2.25.4

