Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3698A4CC109
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiCCPU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiCCPUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:20:24 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C78D19140A
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 07:19:38 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i6-20020a1c3b06000000b00386f2897400so161672wma.5
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 07:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOoO/JtORNxVZOuIC5thYYXw8aLAykNtaVPyMe7nNAo=;
        b=QPFImnuoqUI4E0pV+jHg3jjHVeJweVwJ3r4BpMu0rntbk9Vr5VjHIk8AmXRhgQEdGJ
         yJvj3ApG6YJgPydyTJQj3NGBBxjmEHO7voiSA7deudhWIr6rkicUEbS6xjLUIVFuUQCn
         RwLJji6fTL7jBleSg1Uo0GjpHv6bYKZvBdA5eLPW4coURfm7jzZ4I0520scjS8fm0OfB
         x2mZEwInNPY2fSiTDooito+65x7TzEAfbxxtnO7lVzK8svl+p+7Cwaia0mIF0id7Xwnq
         0xyUg+FxI5e/ENMgxNnEacX79exFYXFEDu8f1yyL08qCE0AAk2ITEdzFp64quU+WenX8
         +Qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOoO/JtORNxVZOuIC5thYYXw8aLAykNtaVPyMe7nNAo=;
        b=KkOubpcyRKNZOTaAGY4FyVJm6EZHLFPDUNCpPizrVQ7PUG4SSHgRaN1SvJmnKKxUUz
         ZfOwGe5WcfeEFM6r3cmFUEkNXZ5NMpDfKUac0lIsuFWrEZW409yMdSEUK8hWQ6LIN3ng
         Y+AKjOolp5uIZ3xpM0aAN3iW8bnNs+89aMgzBZPrxEbR1Lf4gIPqMBwjxzWmeJRFdIUX
         po3jfovoQkdQAAR04du3TI96M4efCJmHYKYvZtb2HoK9kqy2uuMoK9bQgYAkj0LbVKsL
         ZfwuefiREsBHkKM/fR/QfUMd1R7RWmXZXMJevEGH03NiTmKFX9232NqhaEKbAJaaW8Wk
         6UkA==
X-Gm-Message-State: AOAM532mzigaH5HEFqcmy0H+0RyNi/+GkkIvN17shQTTE9kO9H8jJfIm
        tVKKdfXIPoN0PjOhDT8Iub7OJg==
X-Google-Smtp-Source: ABdhPJwBQE32p1eCLLGgpO7z7Um4TrNO2cXOhEvLouHcngoQPm+YylJZz5schSV+hxeHcTutefuExw==
X-Received: by 2002:a7b:c30e:0:b0:37f:a63d:3d1f with SMTP id k14-20020a7bc30e000000b0037fa63d3d1fmr4077819wmj.178.1646320773221;
        Thu, 03 Mar 2022 07:19:33 -0800 (PST)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id j12-20020a05600c190c00b00380ead5bc65sm2987517wmq.29.2022.03.03.07.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 07:19:32 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held whilst clean-up in progress
Date:   Thu,  3 Mar 2022 15:19:29 +0000
Message-Id: <20220303151929.2505822-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All workers/users should be halted before any clean-up should take place.

Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/vhost/vhost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bbaff6a5e21b8..d935d2506963f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	int i;
 
 	for (i = 0; i < dev->nvqs; ++i) {
+		/* Ideally all workers should be stopped prior to clean-up */
+		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
+
 		mutex_lock(&dev->vqs[i]->mutex);
 		if (dev->vqs[i]->error_ctx)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
-- 
2.35.1.574.g5d30c73bfb-goog

