Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D014E4E8E
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242902AbiCWIve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbiCWIvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B687673075
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C46ALa3Wn3pwhctoVHx8CVmLq4tfYoG9vF9MoJZBSbM=;
        b=fBkkv9yxbRB1dumZgYsyfS5epLtrHpd0LsjkF8B0xDu7KXuFGVstCIfwaHEU3PY4GmRRY3
        7gTDUNK/PizYL53TZR/lIZ/jvHqsozPHJh4G3GD27hlGVcVXVIPXkibYHxsNWE5zYQYCJ1
        5eg1VUVSX8Mekz9cSyC3iM+dztfmaSQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-su0w4nwpNZ-2H15eFRML7Q-1; Wed, 23 Mar 2022 04:50:00 -0400
X-MC-Unique: su0w4nwpNZ-2H15eFRML7Q-1
Received: by mail-qv1-f71.google.com with SMTP id 33-20020a0c8024000000b0043d17ffb0bdso739122qva.18
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C46ALa3Wn3pwhctoVHx8CVmLq4tfYoG9vF9MoJZBSbM=;
        b=llokGhzjL7xUtsYCb2uL5XYm9S/BhtnYjV0nS+8vHPoGxjR0eq/w22ax+2cOfyY+IH
         CKZNpSD9VDryT2I977eyjqRE65VbxE1OObbNH8yPo79zDbmQp0zrpXrU34m/MJVFfN6x
         u/uFxZv89GbbcEaYqeGlFvziOXF68eXjKYNgtHJ8jbTwxllk9QZ0qIxty7TCNhHahv9+
         zSJmcHrGBdaIMdBIIDHfE0g5iHAfcIiksP6u9/E48Ay2r6NhQK2+F9GQ/58FxiR27Swb
         Vjkia9oXQ7P4Z5K6/hUWwgfv+wWPWrR45/8axt5pmjQVlyxKKdfvCnE49lILu7VcH5pK
         TMfw==
X-Gm-Message-State: AOAM530iRSCiwBsy0XPGubOooaYDsGI4e7FeCu5DM8UbG8dldWPLzsH2
        6q12hUboQrQmGpFvCF/y0SzdngAcPpduM4KJwAOWVLpg1a/lEmRuDzx649LeNpAIdDu5jWzsG86
        Lv7JFWv8y92AC
X-Received: by 2002:a05:622a:107:b0:2e1:d655:cc4c with SMTP id u7-20020a05622a010700b002e1d655cc4cmr23525887qtw.669.1648025400244;
        Wed, 23 Mar 2022 01:50:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfE8/OMwCCgqFxQqE3tKOs0mFQYucCfXdxmrRXsheQTGYlj3H8WZkZdUr2Tkkn7dzVMymHwA==
X-Received: by 2002:a05:622a:107:b0:2e1:d655:cc4c with SMTP id u7-20020a05622a010700b002e1d655cc4cmr23525876qtw.669.1648025399984;
        Wed, 23 Mar 2022 01:49:59 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:49:59 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/3] vsock/virtio: enable VQs early on probe and finish the setup before using them
Date:   Wed, 23 Mar 2022 09:49:51 +0100
Message-Id: <20220323084954.11769-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch fixes a virtio-spec violation. The other two patches
complete the driver configuration before using the VQs in the probe.

The patch order should simplify backporting in stable branches.

v2:
- patch 1 is not changed from v1
- added 2 patches to complete the driver configuration before using the
  VQs in the probe [MST]

v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/

Stefano Garzarella (3):
  vsock/virtio: enable VQs early on probe
  vsock/virtio: initialize vdev->priv before using VQs
  vsock/virtio: read the negotiated features before using VQs

 net/vmw_vsock/virtio_transport.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.35.1

