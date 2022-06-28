Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CCA55E72D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiF1PY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 11:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346653AbiF1PYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:24:53 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B7B2DAB5;
        Tue, 28 Jun 2022 08:24:48 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r133so13221204iod.3;
        Tue, 28 Jun 2022 08:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eLyuLD15Aw0Be/kq7JIpgE2do6KM/UKTXxIdVTRE3sc=;
        b=qERk90jaQ3zsjXchyCff82HyevmOvxF4+R6XNB0yFggouQ4mUlgCpwCcOdwCxw5x7k
         zsXNYwVPpWZ8aJy79efKYk7M0MSLdGkV79eAbAvUq5sYpmvYFn5JjJRXOFMrU8Mvl2od
         A0KeaSjEG1WmET6j4ouMZqBCzQ3/jroUCPwXBi6XTvPb/1EHk/f7ZGeQxVlb0/eqoo+q
         vD7TRhvoAuU4sQUwHV9I9lK4WmfTjr6e2NVxCwh8kl1E31o9zOF2C6SoWWo7aXi5FNT6
         Qf87jozrVf7NjIPhYGiu5/O48Yb0bH9imTvh1wL2Vp7iSMhKKS6EDaqs8R4enoGyAFt7
         HGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eLyuLD15Aw0Be/kq7JIpgE2do6KM/UKTXxIdVTRE3sc=;
        b=VwWsqbE+iGaJq3XHzaCY4eYGrY1Ru0NoFbZaT6Z261cgL+IOKcqF9Tq9Q42bm8LUNF
         ifKTm5JREt66RksHtRTA5K5wLUpiygm0hh0l2VsqjToHlOTeLOivrihOj7c566empnrd
         KHLGPX4zkjEV2yV3z3zwy9IbZiy5/1yWJcWYhJMSJ04h3NFzwDX3d+2hhMdGvNHBilTn
         PugwQgW/0h95XspHmqhFbwkrvfKrr0gytSwcHDFqO/KVMy9Z9k4zTU5/f3+CSKAVE+/3
         ySB0ZVXkhWrUM1dpYg8w0IOEFvhRuFWqORmL5RUjqFqLV8O0vg0vczk7SMm0pl3VkXRx
         sv5w==
X-Gm-Message-State: AJIora9JKxegb/WlapMsDZCm7cl90YVjb7zUOjTqmy/0BHZNAJDw51RM
        1rQbUo0nNm46SCyCDHgzwzWf8ikkaniBkQ==
X-Google-Smtp-Source: AGRyM1ur49F6ppP1KpfkrUv5BG+7OUqsCfEqHbgDFghyK1MNyzHYSTMXncripVNXUchzJ3K67vQaGw==
X-Received: by 2002:a05:6638:4195:b0:33c:ae8e:c240 with SMTP id az21-20020a056638419500b0033cae8ec240mr4193770jab.269.1656429888118;
        Tue, 28 Jun 2022 08:24:48 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id p18-20020a056638217200b00339cae5cb8fsm6222596jak.103.2022.06.28.08.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:24:47 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schspa Shi <schspa@gmail.com>
Subject: [PATCH v2] vfio: Clear the caps->buf to NULL after free
Date:   Tue, 28 Jun 2022 23:24:29 +0800
Message-Id: <20220628152429.286-1-schspa@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

API vfio_info_cap_add will free caps->buf, clear it to NULL after
free.

Signed-off-by: Schspa Shi <schspa@gmail.com>
---
 drivers/vfio/vfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..a0fb93866f61 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1812,6 +1812,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
+		caps->buf = NULL;
 		caps->size = 0;
 		return ERR_PTR(-ENOMEM);
 	}
-- 
2.24.3 (Apple Git-128)

