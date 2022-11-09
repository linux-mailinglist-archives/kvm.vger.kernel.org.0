Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD362286B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKIK0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 05:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKIK0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 05:26:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E022F120B1
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 02:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667989510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=auSM+70YRosWZy5ukGqkwDOs/DSEICJ2nlPZ92XyH9s=;
        b=HBS/5H4w+eivkySfPKHLwZOm+1Hn7eDmvB/3HrgdA7QkVJ04Dv7WmW7lYjiOktfT6x1t8k
        lO9Z/Az64W4MbUrtbyu/GoBlGdHHbmXdH+wyKNTsU+eZn4O7l9IlT401gzSy3airWk01b0
        WfT3to+zBWY857d9bTmnUg4vyJDI5og=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-P6__tXy8OrOWyf09Xr7prw-1; Wed, 09 Nov 2022 05:25:09 -0500
X-MC-Unique: P6__tXy8OrOWyf09Xr7prw-1
Received: by mail-qt1-f199.google.com with SMTP id y19-20020a05622a121300b003a526e0ff9bso12203803qtx.15
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 02:25:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auSM+70YRosWZy5ukGqkwDOs/DSEICJ2nlPZ92XyH9s=;
        b=e4+rhXUss9u8k6t/YdCjn9BzqwdKs3iyvN6gp+twDA1B0LhdCWJAO/FnK7O+Q5/lmY
         ZJI85yQFkylIg18fLVvIsPi6H7GLzgaTeFLHKHFEa91V6w4xC0B9aRrLUsZCLTR9TLNh
         oqr8QOIqfO2FhQf+wao/5CYXR5Qpuwza6zL1Ofzjd4oFQgFKjyPkACGWjbW5ldv7x80r
         LUD3i+IBoj0uN1gn2z0wADboKq75mKHd6JnTlhKJC8BKzg4kOxjYkPn1MFNnv/x/3oqC
         lI425RjTeMc2YhkjuVbQ70YleClYYWoMBJ48nG1Ovkd0LJqes7M/TUPnYHw7zP9aIEnZ
         4ZzA==
X-Gm-Message-State: ACrzQf2Zv12JgzxTsarmnK1RTeNErU7yC4jL3/aW42d5IYrQxoU+eawb
        R7CDQN2P7Y2EY38GfZsRKiuMPak/4989YszO/k3HA1dLbucbCubkPSd8Xv4o3VOeBlU2J/aRdKx
        lunXmh0zS0JQG
X-Received: by 2002:a05:620a:e11:b0:6fa:7435:a409 with SMTP id y17-20020a05620a0e1100b006fa7435a409mr23294694qkm.51.1667989508201;
        Wed, 09 Nov 2022 02:25:08 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7kIiD5hF1VgY+01R04+NKJB6TMPdY1YIPB/qSgWreKxEVuImtPVMcdEaGEZOnk3bJsKCVWaA==
X-Received: by 2002:a05:620a:e11:b0:6fa:7435:a409 with SMTP id y17-20020a05620a0e1100b006fa7435a409mr23294682qkm.51.1667989507953;
        Wed, 09 Nov 2022 02:25:07 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bj10-20020a05620a190a00b006fa313bf185sm10827522qkb.8.2022.11.09.02.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:25:07 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 0/2] vhost: fix ranges when call vhost_iotlb_itree_first()
Date:   Wed,  9 Nov 2022 11:25:01 +0100
Message-Id: <20221109102503.18816-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Patch 2: Replaced Fixes tag with the right one [Jason]

v1: https://lore.kernel.org/virtualization/20221108103437.105327-1-sgarzare@redhat.com/

While I was working on vringh to support VA in vringh_*_iotlb()
I saw that the range we use in iotlb_translate() when we call
vhost_iotlb_itree_first() was not correct IIUC.
So I looked at all the calls and found that in vhost.c as well.

I didn't observe a failure and I don't have a reproducer because
I noticed the problem by looking at the code.

Maybe we didn't have a problem, because a shorter range was being
returned anyway and the loop stopped taking into account the total
amount of bytes translated, but I think it's better to fix.

Thanks,
Stefano

Stefano Garzarella (2):
  vringh: fix range used in iotlb_translate()
  vhost: fix range used in translate_desc()

 drivers/vhost/vhost.c  | 4 ++--
 drivers/vhost/vringh.c | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.38.1

