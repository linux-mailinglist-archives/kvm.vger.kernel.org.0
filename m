Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED17448E70F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiANJFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbiANJFX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 04:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642151122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QSqhd5EHQVjGBS9+fRjPxVdCzG4rtUKAbc2JLGcS0M8=;
        b=Tdmn81NDuGk/W9lmrPZvnvKxNi3F3oF85nkAc/WEiAaEMIa7WYIob3LcK3ZxWniad+wxHm
        p0CCmBSjYHD8j2SY3JEO95hJ82wwbcdbseHolnyrOgmYegHu1zckE7bDiecjfutkSTpUDF
        pjZZD6CHIx5W0ip39K17u9ZDWhvqgqg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-PkmIbh8FPKu1ddb3yu7GiQ-1; Fri, 14 Jan 2022 04:05:21 -0500
X-MC-Unique: PkmIbh8FPKu1ddb3yu7GiQ-1
Received: by mail-pl1-f200.google.com with SMTP id p5-20020a170902bd0500b00148cb2d29ecso7602832pls.4
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 01:05:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QSqhd5EHQVjGBS9+fRjPxVdCzG4rtUKAbc2JLGcS0M8=;
        b=btCnduMQRkLoq6bVbFqRGEdhOHvlB0wHadZTtBcf68tKtCLaWq0TkFuQUCB0K2MFLo
         tiHa4zVLF6d6jayk0JC7DJmSYuSW0+F9z9ecSERAyYd7wWQ9Mmjh9Fwl8+qbqs83Jrg8
         LiJrwfzRYvtUECqiTY2pvlwNl648Hs8+rLT3bKlHtJDNsNR2ytjwZQqeWtCQh06kv787
         4FLtOU/830a/nPOiYSxKWaGh+1vz4pGYg74pNLcQ7z9ZMXSbfPrLmaDTwT37tTEzRRGt
         IbryLkt8rcXvKvNnNvBjpkBJFFmR2/oiEC+JVeY8aR1tA7JEL7j3KgdbVyo3F5CAaRg6
         lz1A==
X-Gm-Message-State: AOAM532l5vUQu9C4g6WveZy1Z+hAls5QBNECn4xWtzhk9A8g0oXYl54q
        6PFdXbMtNVLIxMPfxgF6AceTKtBUg+s3LFxrX0jmTNxNszUGcdeiwTaW9xgGRz9wvwJoNnXH2He
        zixQ8kfQTFeJu
X-Received: by 2002:a17:902:7603:b0:148:daa7:ed7e with SMTP id k3-20020a170902760300b00148daa7ed7emr8569167pll.150.1642151119913;
        Fri, 14 Jan 2022 01:05:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxW79PSPSMG4VhQolpshd54Loc7rye/TOYMJd/7+9JvMi8g1YuVwpqwFGtXO0bt0SuSVXZouw==
X-Received: by 2002:a17:902:7603:b0:148:daa7:ed7e with SMTP id k3-20020a170902760300b00148daa7ed7emr8569146pll.150.1642151119627;
        Fri, 14 Jan 2022 01:05:19 -0800 (PST)
Received: from steredhat.redhat.com (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id c6sm5217474pfv.62.2022.01.14.01.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:05:18 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Date:   Fri, 14 Jan 2022 10:05:08 +0100
Message-Id: <20220114090508.36416-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vhost_enable_notify() we enable the notifications and we read
the avail index to check if new buffers have become available in
the meantime.

We are not caching the avail index, so when the device will call
vhost_get_vq_desc(), it will find the old value in the cache and
it will read the avail index again.

It would be better to refresh the cache every time we read avail
index, so let's change vhost_enable_notify() caching the value in
`avail_idx` and compare it with `last_avail_idx` to check if there
are new buffers available.

Anyway, we don't expect a significant performance boost because
the above path is not very common, indeed vhost_enable_notify()
is often called with unlikely(), expecting that avail index has
not been updated.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1:
- improved the commit description [MST, Jason]
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..07363dff559e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 		       &vq->avail->idx, r);
 		return false;
 	}
+	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
-	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
+	return vq->avail_idx != vq->last_avail_idx;
 }
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
-- 
2.31.1

