Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE84D0774
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiCGTTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 14:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiCGTS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:18:59 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C0BFD3A
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 11:18:00 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 19so9558152wmy.3
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 11:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dbqVSaoeE145ys9uRLEZZR3pFJY2Pmc5WG68rQTUDjk=;
        b=k5NesdgsXTht6dMH9Zs1gYWtYMsdq2oaoUryBtRQ299vTq+wKnD4nno1egKbIrBVvt
         u37JkSvL43u/gPcfLHEvrdES3On3K8okyZKtK5x2IaGkdK0XOr7WB7zQ9Zcbj6CmcmdK
         9Q6QJ9Hpjk2XNo/+94qYcfJQzracg57M/trJW6e8B5gjvzvUh4ypNZwjQtF4ZxhHttPH
         RY9eQVjhbBd/2+kGoSzknYgZXbhAs5GglyD9L3X75TZDWmEoUhXsoTT0NkLyTmW4h/na
         S9CvMWfORnMzpWyVUpT8XabV69cJNTthtxd3VRYBNCWPUjkEEJsNFDT0CozCWgfN8F7p
         NcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dbqVSaoeE145ys9uRLEZZR3pFJY2Pmc5WG68rQTUDjk=;
        b=XRLNa3gpLDT7l5H9jYRparNtut3Yb9pptiA4pV/LDynJOfG+pJ6gudmF1OaB3R0M/E
         D9fxO5Ha4jUHKFvgkDiRHXKZiPpzoGE4fVN++pZT9LBRoegeMkkrq2ddsQfOq0Pgy3+8
         QsV1mrKCgwkmv8jQgIg5cipI18tqN9KGqaYTkKLB3ct+mWU9ekL/FMEGaJx4dpPMYRsP
         F9cfCmakJocQp2BGz3szaLzuPWchl7kDCz0iO9ZLUDZxEa13bCUxU4MsEP8sQPOeDJ7q
         w3q86fB567tVsq2JZRIRxcbcuHIHHWhjsCxw1qTYp2QAF7bfwYIR1B9rg5xJ/9k9BSNU
         jS4A==
X-Gm-Message-State: AOAM532SZVql254u2DyveDyyAiVNhwabT4EAtpu4njoWXZVLqgNKEHVZ
        T57FvvRevIn4RSJ+2YXHUirRRA==
X-Google-Smtp-Source: ABdhPJzlJiMYAf08xQYWLIojU4uURtjWC9ZBAz30RgCGZ9HLvlLDJ9lUmbZ5j3Q/JntOftXy/SgAdQ==
X-Received: by 2002:a05:600c:4615:b0:386:9f67:8c63 with SMTP id m21-20020a05600c461500b003869f678c63mr381658wmo.12.1646680678579;
        Mon, 07 Mar 2022 11:17:58 -0800 (PST)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c1d8f00b003899d50f01csm200741wms.6.2022.03.07.11.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 11:17:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: [PATCH 1/1] vhost: Protect the virtqueue from being cleared whilst still in use
Date:   Mon,  7 Mar 2022 19:17:57 +0000
Message-Id: <20220307191757.3177139-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost_vsock_handle_tx_kick() already holds the mutex during its call
to vhost_get_vq_desc().  All we have to do here is take the same lock
during virtqueue clean-up and we mitigate the reported issues.

Also WARN() as a precautionary measure.  The purpose of this is to
capture possible future race conditions which may pop up over time.

Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/vhost/vhost.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe28..ef7e371e3e649 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	int i;
 
 	for (i = 0; i < dev->nvqs; ++i) {
+		/* No workers should run here by design. However, races have
+		 * previously occurred where drivers have been unable to flush
+		 * all work properly prior to clean-up.  Without a successful
+		 * flush the guest will malfunction, but avoiding host memory
+		 * corruption in those cases does seem preferable.
+		 */
+		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
+
+		mutex_lock(&dev->vqs[i]->mutex);
 		if (dev->vqs[i]->error_ctx)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
 		if (dev->vqs[i]->kick)
@@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 		if (dev->vqs[i]->call_ctx.ctx)
 			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
 		vhost_vq_reset(dev, dev->vqs[i]);
+		mutex_unlock(&dev->vqs[i]->mutex);
 	}
 	vhost_dev_free_iovecs(dev);
 	if (dev->log_ctx)
-- 
2.35.1.616.g0bdcbb4464-goog

