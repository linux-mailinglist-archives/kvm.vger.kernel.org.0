Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609622147E9
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 20:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGDS3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 14:29:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726682AbgGDS3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 14:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593887387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+xCzX5pjcy148tNCg3zvK7ruz7b/+qmBTdtfJlorfws=;
        b=aObAQF5Oo4qUkYlp5CR9FWcGAst/F+qrU5TgDJKIJSQTHWKOz3mJ5ITRe6sB2vNIWqdhF8
        QCECMx2QAlBvks3m83ci8MpPPuSu99dDnIL/g7ByobocyEbpb7Wlwnpq7zhPHXESYEQkFE
        v55LroSmwbyhVyfXf36fBst4BGlIKjU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-bOvtBLJEOqihGnlzzpTAQg-1; Sat, 04 Jul 2020 14:29:45 -0400
X-MC-Unique: bOvtBLJEOqihGnlzzpTAQg-1
Received: by mail-wr1-f71.google.com with SMTP id z1so6560914wrn.18
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 11:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+xCzX5pjcy148tNCg3zvK7ruz7b/+qmBTdtfJlorfws=;
        b=onH46hDIr3joV+/4YseNhUpkXAx+ozvlZrtrrtljKXTnRtEgFePE+w9rahUmhlEE+v
         8uw5Y8GaOtgZTps19x/tDlYSBiTW+ter9GdYB7DjtLdvqAlo1ZScC3bw91OwK15EOnXJ
         5yyYl/+1mQ4CRkecXudHQ0F6Vlq2ZsZUdBCbBgUjtzLxahh8XzaFervRRYrIbIzyz6dD
         yPYFaV6ZemT6Er+DqI+rpl7YB4ZVJN7DT2Rjz+CQk7toerG77hNGSyWZFqul12CY3Yr1
         27wJ+fIt6RTUUsXVf/E/c/7LXiU9a0Kgw9CwaR2B9LYwcB+xhuSJqC6Dd320TVAEzI7Q
         vekQ==
X-Gm-Message-State: AOAM531/1Xq/DUwh6RRs2Hc0cB5sr9U4i7AJw+m2Z7xX6gYXXAL86721
        b8knn9Mk6eoHjcwKCzmxMKyMWT7EjUlgb1katkUiUonwgVs8gDazh3uAic5JUI78JZ9pBz7p1/2
        Q3FJIbPFsVCUZ
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr41024448wmk.67.1593887383900;
        Sat, 04 Jul 2020 11:29:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyZyhovHtwPT8kE0hmJqiRfbF25fSUFZBtXZC1AiAdPjMmXjWkRVXCdBx0KDBob2c9vz1Gng==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr41024439wmk.67.1593887383699;
        Sat, 04 Jul 2020 11:29:43 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id s203sm8617891wms.32.2020.07.04.11.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 11:29:43 -0700 (PDT)
Date:   Sat, 4 Jul 2020 14:29:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL v2 07/41] accel/kvm: Convert to ram_block_discard_disable()
Message-ID: <20200704182750.1088103-8-mst@redhat.com>
References: <20200704182750.1088103-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704182750.1088103-1-mst@redhat.com>
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

