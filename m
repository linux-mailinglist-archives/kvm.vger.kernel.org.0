Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9D81C6D89
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgEFJuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58682 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728640AbgEFJuY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePQAGUxkbDh1KstjsNvoLvmQ61QNRVAAmm68r4w7K/A=;
        b=XcgkJg4Hi3SM90RjgDl1whalxwQ945p6WBJBEY6vfm3JLN5SAVhZBIYHaR/67xrnkUIQDu
        wWPUoU/5mooeUHxi+c77nDGtrZLp0NujVWWlp0YOJ/KaqRpglP7ZTw7ZK9yuCbxytolpmt
        4noph6jcvCHfkzt5SDbbtHDGHthUsUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-WBZ3s7CHPq61jgOylngiQw-1; Wed, 06 May 2020 05:50:22 -0400
X-MC-Unique: WBZ3s7CHPq61jgOylngiQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDF488018AB;
        Wed,  6 May 2020 09:50:20 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0A415C1BD;
        Wed,  6 May 2020 09:50:18 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 03/17] accel/kvm: Convert to ram_block_discard_set_broken()
Date:   Wed,  6 May 2020 11:49:34 +0200
Message-Id: <20200506094948.76388-4-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Discarding memory does not work as expected. At the time this is called,
we cannot have anyone active that relies on discards to work properly.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..33421184ac 100644
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
@@ -2107,7 +2106,7 @@ static int kvm_init(MachineState *ms)
=20
     s->sync_mmu =3D !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU=
);
     if (!s->sync_mmu) {
-        qemu_balloon_inhibit(true);
+        g_assert(ram_block_discard_set_broken(true));
     }
=20
     return 0;
--=20
2.25.3

