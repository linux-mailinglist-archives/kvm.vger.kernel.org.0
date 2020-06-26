Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D4120ACF6
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgFZHXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:23:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34168 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbgFZHXy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 03:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGtscYE02ovFEJQV2k/q0RnteybdWD0PleR2p3WwxKg=;
        b=b8IVell0robaHUnmY2gGtGtHLLOfOwFvSem6hGDW2X9Uo8xnt2Pls2PoCBEHZUjiDy9iXs
        emFo0B1eIlrjz6Df1a751DEW4Hma/CKJ3H8Ob3DlE6e1y2AicMd90APAP6vw1iXoZC46Mn
        EA11ozl8RabDWDxOS1QmdmsOu8GcTsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-P8CVEg5XP92mgBqIAWbjQA-1; Fri, 26 Jun 2020 03:23:50 -0400
X-MC-Unique: P8CVEg5XP92mgBqIAWbjQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A94804001;
        Fri, 26 Jun 2020 07:23:49 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C92AB70915;
        Fri, 26 Jun 2020 07:23:47 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 04/21] accel/kvm: Convert to ram_block_discard_disable()
Date:   Fri, 26 Jun 2020 09:22:31 +0200
Message-Id: <20200626072248.78761-5-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 accel/kvm/kvm-all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f24d7da783..4751ce67a9 100644
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
@@ -2222,7 +2221,8 @@ static int kvm_init(MachineState *ms)
 
     s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
     if (!s->sync_mmu) {
-        qemu_balloon_inhibit(true);
+        ret = ram_block_discard_disable(true);
+        assert(!ret);
     }
 
     return 0;
-- 
2.26.2

