Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17436D627B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbjDDNPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbjDDNPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:15:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2243A8C
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Joco4lLfDzF0rb3l626/1qV/yRiN74V9xc1/q5OsmGA=;
        b=eL+cVe7RsT7Sy3ntaee+ZHihAurJCh2+VtJdRh8Quc7vdgS4GUkEu4nVRRUCOjeALfY2LM
        z83suPryyzqj1L9fA9sR/M9PdQH75k8MRkCbbK8NV2GUQWtuIIkzocZ2RYwyIja5ZJ2sID
        1nLZoDv7I4XhfXoqiipHhN+UFy977Ao=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-vZG7rCWRN5yqxlT8K48rHw-1; Tue, 04 Apr 2023 09:14:01 -0400
X-MC-Unique: vZG7rCWRN5yqxlT8K48rHw-1
Received: by mail-qk1-f200.google.com with SMTP id r197-20020a37a8ce000000b0074a59c12b10so724089qke.5
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 06:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Joco4lLfDzF0rb3l626/1qV/yRiN74V9xc1/q5OsmGA=;
        b=7yDutC9vlLyixLAn30aCe9j/ZYU7TcEw1zxebQsREBoayW4u9Boa5F3XVTTDV/djHQ
         dN9UNstIyYmK5iAZ+4SffMwJmyfTib7A9uxod36qNMW+rr00F+orgbnpiNLD1INWTgjy
         vxwFgCj3LTX/Iq9T4ET4RleZIOi1HWhHIM0883OErkiVqp49obRNzeXzEkpXyHKSwvaB
         AHEPbDxwKSab9pfdzQT87lwpCwJvC8lXFsiMxsWu3KP+k1hnaZfXil16s54EDEL2+L0r
         nkys7tllgMVvQwsPWtgKondqO9ZSk4U9GviZS46ldhleuxH62VXMOuyU37YyIuaUs89b
         M9AQ==
X-Gm-Message-State: AAQBX9cU7RRe5i41khi+K459tBMC4buNvRWluIRY2lPF4Cu1kzHkA1vV
        K70ILbgM5MKlbIRRL/LyaY3JhgoyDg00h866GylZ+OBU4T4HYzmN+GVoFKzkPwGX1q8d4B5R1UW
        PRB7T3cTm3xhQ
X-Received: by 2002:ac8:5c49:0:b0:3e4:ce24:99b3 with SMTP id j9-20020ac85c49000000b003e4ce2499b3mr3287134qtj.15.1680614041186;
        Tue, 04 Apr 2023 06:14:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350brY/Pkl/M1hP9EeGxvOvXLmaF54NVKkQ6nW90huVm/ErW3Sapthn6YeLniPqPbLx51QU8jeQ==
X-Received: by 2002:ac8:5c49:0:b0:3e4:ce24:99b3 with SMTP id j9-20020ac85c49000000b003e4ce2499b3mr3287110qtj.15.1680614040964;
        Tue, 04 Apr 2023 06:14:00 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id z5-20020ac87105000000b003e64303bd2dsm2841837qto.63.2023.04.04.06.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:14:00 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     eperezma@redhat.com, stefanha@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: [PATCH v5 3/9] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Tue,  4 Apr 2023 15:13:20 +0200
Message-Id: <20230404131326.44403-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kmap_atomic() is deprecated in favor of kmap_local_page() since commit
f3ba3c710ac5 ("mm/highmem: Provide kmap_local*").

With kmap_local_page() the mappings are per thread, CPU local, can take
page-faults, and can be called from any context (including interrupts).
Furthermore, the tasks can be preempted and, when they are scheduled to
run again, the kernel virtual addresses are restored and still valid.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only for !PREEMPT_RT kernels,
otherwise it only disables migration).

The code within the mappings/un-mappings in getu16_iotlb() and
putu16_iotlb() don't depend on the above-mentioned side effects of
kmap_atomic(), so that mere replacements of the old API with the new one
is all that is required (i.e., there is no need to explicitly add calls
to pagefault_disable() and/or preempt_disable()).

This commit reuses a "boiler plate" commit message from Fabio, who has
already did this change in several places.

Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v3:
    - credited Fabio for the commit message
    - added reference to the commit that deprecated kmap_atomic() [Jason]
    v2:
    - added this patch since checkpatch.pl complained about deprecation
      of kmap_atomic() touched by next patch

 drivers/vhost/vringh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index a1e27da54481..0ba3ef809e48 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
+	kaddr = kmap_local_page(iov.bv_page);
 	from = kaddr + iov.bv_offset;
 	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	return 0;
 }
@@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
+	kaddr = kmap_local_page(iov.bv_page);
 	to = kaddr + iov.bv_offset;
 	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	return 0;
 }
-- 
2.39.2

