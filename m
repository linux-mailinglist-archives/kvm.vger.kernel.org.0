Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C9F6C8168
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjCXPhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjCXPhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0BC20D2F
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679672186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Joco4lLfDzF0rb3l626/1qV/yRiN74V9xc1/q5OsmGA=;
        b=CioaTP5m806hVsHe9I7fmZKirgQLITqFqFbq9dkg7J2SQ9KuLBjGfsYw5TRftB9TGsGarG
        9xgWAoMZfBV6fEhKBbQfZNAro5xrp1Fvh6qtBcptPSPqmyjyNZfm4VGeEOs5FDlVyuYapo
        6pzTPlTqSkNzOjBsJG08kGFCX4zmlEo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-4y-1ERTaORydhNWRYXw4LA-1; Fri, 24 Mar 2023 11:36:25 -0400
X-MC-Unique: 4y-1ERTaORydhNWRYXw4LA-1
Received: by mail-ed1-f69.google.com with SMTP id k30-20020a50ce5e000000b00500544ebfb1so3735271edj.7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Joco4lLfDzF0rb3l626/1qV/yRiN74V9xc1/q5OsmGA=;
        b=1jEOUoH453bfgpFDBKXo8aNP1UNAUjpgbm191KcApy4Kq3ebbjkgZcyLYY1rXeCLps
         tYjloTDWUabt1MC5Dvfw1eamycW3h/yfZuyVDuuTqybrYEmdtICto7dYkfVr/NtT8AXs
         6Yro1tQgay6YlAEaOP/a7u0WeHZU8jdQxv33Wpuj4hvDw7nAlv2Sv5osu0RCr/33O0y0
         hzk/PDy4VeUrFeNievae4vIgnYT6IxaKzGG4QQDUb8pcf/icGIYDEQUi7yZy3VWq6Raw
         Ls4atOceQf/8g9e1MN2dmOOmap610kjxIp2GMlvl3sTItIbJGJUSBHo2RoRyyW4PvSfk
         2dug==
X-Gm-Message-State: AAQBX9cC/v8O+paxzWxFwb18i5P4UEaUPEnr0qIogu9rh9bCsfSpgkjG
        btE47uP1NZYv3MUoU1Ex1HpIasx6PFaOHbpO9k7IIwWtr05GMQ85+IoSHtptpKRH/SFQm1KL8wR
        I9f80zhaiUAMj
X-Received: by 2002:aa7:db59:0:b0:4fa:7fd8:8f6a with SMTP id n25-20020aa7db59000000b004fa7fd88f6amr2931936edt.38.1679672184008;
        Fri, 24 Mar 2023 08:36:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZuzjfQyZ2dlfFtpF8zvU6NLDalEKpdkp+pwvD8RtLaXEt6mmjXHL+HJgSa4wiuylnLUN+1hw==
X-Received: by 2002:aa7:db59:0:b0:4fa:7fd8:8f6a with SMTP id n25-20020aa7db59000000b004fa7fd88f6amr2931918edt.38.1679672183746;
        Fri, 24 Mar 2023 08:36:23 -0700 (PDT)
Received: from localhost.localdomain (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b00501dd53dbfbsm5468613edj.75.2023.03.24.08.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:36:22 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eperezma@redhat.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: [PATCH v4 3/9] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Fri, 24 Mar 2023 16:36:01 +0100
Message-Id: <20230324153607.46836-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324153607.46836-1-sgarzare@redhat.com>
References: <20230324153607.46836-1-sgarzare@redhat.com>
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

