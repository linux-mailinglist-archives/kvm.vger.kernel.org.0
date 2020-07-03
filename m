Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91A21372A
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgGCJD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:03:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725764AbgGCJD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 05:03:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593767036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+xCzX5pjcy148tNCg3zvK7ruz7b/+qmBTdtfJlorfws=;
        b=Yh6jaUIx8sjqTg/oCQD/4z1J1e/dWNv0nyXvFZXHJZnBwZ1frgRNfD7GyqsmO/tLHJE02X
        nm0jjXhOBeqcgO4yRbwz4yWaVHPE24I7n4vpYqOrtaqCbVU4ws44j+9T3y0TUrRxh7YxtS
        QvW2WUMVLPpRHu7HllrDqg/M62Vs0ms=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-1YlxY1XUPsa7HeHOdMzYJA-1; Fri, 03 Jul 2020 05:03:52 -0400
X-MC-Unique: 1YlxY1XUPsa7HeHOdMzYJA-1
Received: by mail-wm1-f70.google.com with SMTP id v24so34593347wmh.3
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 02:03:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+xCzX5pjcy148tNCg3zvK7ruz7b/+qmBTdtfJlorfws=;
        b=ZVqyvVVcumT82V1WYDIR3V8vr7gz2W4A1dXOfa1VXdbE4Y9IUiLHuYMGc8AeC3oZFL
         FSW0YHbnri8xCqWLYlf1pzqgDhhznNqhjNFoOOohaUieg7a3cj8yPN+ATy1A5hBDCAJN
         1s/cGNqSBz+lrcB7n6p02Hig+Rvlyq17whZdn4NHfd6624gcIIGEEk+3XZKWowr7goF6
         4aZ8qYrtX+6OqNHQp5Ja+6zVA1DO2J/YCJ8wu7OTLnxxQzmy3woskWautbou8VFNksFS
         s8PjcV1MgQMr0tKoJEMXsVvDi5cCDYBxQJM3tYEUAFx6z+Pq0uVYTqzgCKgODJ89vZ+A
         KIMQ==
X-Gm-Message-State: AOAM533XghS+TbqWB8elZH67dn+iLT5g9SSmxN98UUoYVCnSuKqKaBWn
        62hsqXFzdQ7SXWR1VoEOUvIHscEEcbjVdYtB86h/E5+suS35PVPDuKud+W7dc2SpqaEA/ttqh9I
        AumFBsP6dNyvd
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr34465105wmi.19.1593767030945;
        Fri, 03 Jul 2020 02:03:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxH6CgeufSo9JwIW+9iWhgBDRu9Y5rZ/6J6Jir103NVXBTOiQlnZIXgjcjYMvIQK8/q4Sijiw==
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr34465084wmi.19.1593767030736;
        Fri, 03 Jul 2020 02:03:50 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id r1sm13030791wrt.73.2020.07.03.02.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 02:03:50 -0700 (PDT)
Date:   Fri, 3 Jul 2020 05:03:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 07/41] accel/kvm: Convert to ram_block_discard_disable()
Message-ID: <20200703090252.368694-8-mst@redhat.com>
References: <20200703090252.368694-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703090252.368694-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Discarding memory does not work as expected. At the time this is called,
we cannot have anyone active that relies on discards to work properly.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20200626072248.78761-5-david@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 accel/kvm/kvm-all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d54a8701d8..ab36fbfa0c 100644
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
@@ -2229,7 +2228,8 @@ static int kvm_init(MachineState *ms)
 
     s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
     if (!s->sync_mmu) {
-        qemu_balloon_inhibit(true);
+        ret = ram_block_discard_disable(true);
+        assert(!ret);
     }
 
     return 0;
-- 
MST

