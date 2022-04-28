Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3341D5134F4
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbiD1N0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiD1N0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:26:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 625DDAC917
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 06:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8PQduM8Cm6+v2eU6zkUJYKtrg0KGSwBOax3SMcC5NWw=;
        b=JSeCV7e+pbXQUnARr8DAYLAy1wH1HcomXBJiwzlma593Jg/Z+OIFkTL4mwmIs1gA4+MB2K
        RIOvp9c3TfuuzGjWB+IV+hZ/uOXHlhUu8qdvHKg80YaHF2htrHLBJVpIgWEpb83QzwPtuf
        gFa0fa8iTu+/xyBxLAF01fRgxVvBJao=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-B7tYvC7PNWG5DT2j1XHIPQ-1; Thu, 28 Apr 2022 09:22:45 -0400
X-MC-Unique: B7tYvC7PNWG5DT2j1XHIPQ-1
Received: by mail-wr1-f72.google.com with SMTP id o11-20020adfca0b000000b0020adc114131so1930399wrh.8
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 06:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PQduM8Cm6+v2eU6zkUJYKtrg0KGSwBOax3SMcC5NWw=;
        b=1n7mE77Y/5qVWyfd9Nt2KZUedCMmKq5pRgmHVSksDVE9fuwuKjTjFSvSp309m/XecH
         hk45sUc+t2smiE50ggI/Cqw0/hZJ1XApJl2aK7+QezQuEFyFala57tVMcNBs4vlb1do3
         BighaF6yMlySxYESfQUdkJKkp2Hrle+iqpxBVLfSpwJAGoR6jZI1VEwmhxo6TyRFDY/B
         Q9eXnn8u+5BX2LOp7ORyA08GO0mSj0Qs6MFoF9p+tzKwvjLl2UuJLXTBn5l5M3HQK4QZ
         MyxQ+QWulHB8s1oP+9dUyCYOtIwMVmJbhqzLnOf7zmImt+TBnL5oNmKLViSAr4HLsbjE
         YLOw==
X-Gm-Message-State: AOAM531Bm6rOFkNwXVX46LSSw3wKgjDLRk2W5OiJLVpIXkxzeEbqP20x
        cJyIvt6EHwlXqgVsNNCO8w3gcnX/ipFp9m8W97pHa8cSwAFv7Fm/8FFnf48zb1lmvPqDtXK+tjH
        eLZ9n0gA5SMNu
X-Received: by 2002:a1c:2185:0:b0:38f:f4ed:f964 with SMTP id h127-20020a1c2185000000b0038ff4edf964mr31065702wmh.115.1651152164528;
        Thu, 28 Apr 2022 06:22:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh0SQ9LojN8eIegKUo+h+ntmqGzG2tJdfRq4/rRAMPBONENZjji/VGZxEgoBORxb2iYpBK1g==
X-Received: by 2002:a1c:2185:0:b0:38f:f4ed:f964 with SMTP id h127-20020a1c2185000000b0038ff4edf964mr31065683wmh.115.1651152164320;
        Thu, 28 Apr 2022 06:22:44 -0700 (PDT)
Received: from step1.redhat.com (host-87-11-6-234.retail.telecomitalia.it. [87.11.6.234])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b00393f1393abfsm4680978wmq.41.2022.04.28.06.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:22:43 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vilas R K <vilas.r.k@intel.com>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net-next 0/2] vsock/virtio: add support for device suspend/resume
Date:   Thu, 28 Apr 2022 15:22:39 +0200
Message-Id: <20220428132241.152679-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vilas reported that virtio-vsock no longer worked properly after
suspend/resume (echo mem >/sys/power/state).
It was impossible to connect to the host and vice versa.

Indeed, the support has never been implemented.

This series implement .freeze and .restore callbacks of struct virtio_driver
to support device suspend/resume.

The first patch factors our the code to initialize and delete VQs.
The second patch uses that code to support device suspend/resume.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano Garzarella (2):
  vsock/virtio: factor our the code to initialize and delete VQs
  vsock/virtio: add support for device suspend/resume

 net/vmw_vsock/virtio_transport.c | 197 ++++++++++++++++++++-----------
 1 file changed, 131 insertions(+), 66 deletions(-)

-- 
2.35.1

