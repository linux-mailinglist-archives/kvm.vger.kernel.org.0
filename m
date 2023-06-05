Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B30D722432
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 13:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjFELII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 07:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjFELHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 07:07:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24927F9
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685963225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kbCiwyqVxBGMkLGPRwYBBYz8NZcSuztWZwPhXZOo2A4=;
        b=EI4MgPcN28oSapdbd2v40W8I1XfH0/PaCC1yAhrMAHv0Fzya1DXjTcuZSrhv4yPHbcz0mL
        tmx7ELO0N09VMy0Tf0Frl0tPsnTHaL8aKC0awpQQaYkDRmr7IHNBCvYeqxQ5fUE/UusEgh
        iBlo698SlGdr9Zw52p4ol4rjPVJKgEA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-UQE2aeQxM0SCmyIIHLglbA-1; Mon, 05 Jun 2023 07:07:04 -0400
X-MC-Unique: UQE2aeQxM0SCmyIIHLglbA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f6f2f18ecbso22383445e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 04:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685963207; x=1688555207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbCiwyqVxBGMkLGPRwYBBYz8NZcSuztWZwPhXZOo2A4=;
        b=JbNsm7quulhrY/u75TpTxtxtS9a07TWxYCu7oedxR/Zf4RvdsiIusIptipYcYDiVEU
         bjXNXQ2heHhzzTeOVLsqXUi61QVOT7mPmlM5ZtXnWp0zT9Km4pjf/Mfb6Un9czqOlJxF
         aDJ4dro/Uqka9v0MkgDpV+nJoxYEqHococ+hSalfdcBx3tPEDsyrv4nHIzX6S3R8410S
         jhmQknRhfMWyaM+QYBNlxGF0813uNjylOGsTsne+2gZ35SYZP8vWTDa3hsxOwWcKT7OC
         CzQo1TqT9gKLtmFQNoea4kVyHM5Zy/FpD94yPz90q97pVxvcP+hH16alzjOCsXTk9Wdc
         /Vig==
X-Gm-Message-State: AC+VfDwABjFF8LyguBJ4CaqZ/k/DL/bBo1JF1echsmOpzkxAZlHZjqpY
        qCBhngHungGr55OtIGswWdhTAIJaGXiMUe+Ra8OjF0VTFknijjx7R33uznikzlgEYPQExFxpqUO
        6QMaXO2gvWaK3
X-Received: by 2002:a05:600c:2318:b0:3f5:fb97:eafe with SMTP id 24-20020a05600c231800b003f5fb97eafemr6359801wmo.30.1685963207565;
        Mon, 05 Jun 2023 04:06:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ53W9xn9TGBpaX8/z08DhNRppPkhtiy/6dFg/34pYnUjNp28hkX6GPjzKGWmEUJ3a7qTnjMfQ==
X-Received: by 2002:a05:600c:2318:b0:3f5:fb97:eafe with SMTP id 24-20020a05600c231800b003f5fb97eafemr6359787wmo.30.1685963207240;
        Mon, 05 Jun 2023 04:06:47 -0700 (PDT)
Received: from step1.redhat.com ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id s5-20020a5d4245000000b0030903d44dbcsm9407323wrr.33.2023.06.05.04.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 04:06:46 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Date:   Mon,  5 Jun 2023 13:06:44 +0200
Message-Id: <20230605110644.151211-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
don't support packed virtqueue well yet, so let's filter the
VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().

This way, even if the device supports it, we don't risk it being
negotiated, then the VMM is unable to set the vring state properly.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
    better PACKED support" series [1] and backported in stable branches.
    
    We can revert it when we are sure that everything is working with
    packed virtqueues.
    
    Thanks,
    Stefano
    
    [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/

 drivers/vhost/vdpa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 8c1aefc865f0..ac2152135b23 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 
 	features = ops->get_device_features(vdpa);
 
+	/*
+	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
+	 * packed virtqueue well yet, so let's filter the feature for now.
+	 */
+	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
+
 	if (copy_to_user(featurep, &features, sizeof(features)))
 		return -EFAULT;
 

base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.40.1

