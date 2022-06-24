Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AC555937A
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiFXGcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiFXGcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:32:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2335DC21
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 23:32:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n10so1332903plp.0
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 23:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xji3fCx86UpFu+GZKhC0W+HkLhkXd0Q5e2LpmrTD11s=;
        b=d/trCjOV9MqQDLLziG+sTTNMClEtFTMSZmnUbx/0wX+zABAFBE4r3ckocM+Qp72EDF
         7F1UdWhWnu6fibOdOQ3s2cH14R/UsgQ0dAvadMB0SoTnKXnpg5zjUlSVvUae72X47xap
         Iivjnxq1LGkVCpSLGFyuWnneOhq7UYGxbwNl3UyTS5j57nAzvnlghCYJsAB36XNTGVji
         7qbuQWhmUSFbVwRmAZLnGM2b30Hg4u3XOhXe1hzvqo/qnTwIyeO2dS2fnMPs2VGhkc9y
         ZRU6a0jkTBvGpUf3dPmwTxv2gp5pXMBsQoyBmd8IsaGQXdFnGOjoR6egS2GRl7Y16j8U
         RQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xji3fCx86UpFu+GZKhC0W+HkLhkXd0Q5e2LpmrTD11s=;
        b=R7euHOpr+RxBbxv6rgEzdsXZpUE/0w594kEyqCB85c+XtKKkKqUQWeNaZkDDQCZYj2
         M9hAqt5xX+jTmzr26xrvzZyNJf36z7nq4V2TuNuVoTaFhx5neLYpcQrL2fZQuhZlGTcC
         /jsTzFVNLn/kmcu404oMicodFI675rAeMToPnDizwx3hFH1LHefkHrzFptl20OxWNXtw
         TbCdi63LY2vmacfskovOfJ/K0jdVa8ZdTprwD1PdGXXyVs+zNupTHn1r+MAJPgXb6jED
         AHumvd79blOpbyBt5xlE2ckamEr206aDj29z6b5yDuU2JikHI6I4ZS89HClIxPWrIuUN
         BYoQ==
X-Gm-Message-State: AJIora+5qWHOdKKvfLCWNUe5LCZseBbtIndNYoqJ9vbcpEBLD2nr/KEY
        C1VA4KF38BBtOIoWvUleBY0=
X-Google-Smtp-Source: AGRyM1sFJOn671vfZucZ0uNvBZlBe2HBN+ET5+WFcyelgqRT8bM0GdA0pnkhzFSusdAjlnW/M/5e5A==
X-Received: by 2002:a17:902:c944:b0:16a:3ed0:e60b with SMTP id i4-20020a170902c94400b0016a3ed0e60bmr15079113pla.7.1656052327632;
        Thu, 23 Jun 2022 23:32:07 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id h5-20020a635745000000b003fdcf361df6sm707524pgm.87.2022.06.23.23.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:32:06 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     linmq006@gmail.com
Subject: [PATCH] accel: kvm: Fix memory leak in find_stats_descriptors
Date:   Fri, 24 Jun 2022 10:31:59 +0400
Message-Id: <20220624063159.57411-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function doesn't release descriptors in one error path,
result in memory leak. Call g_free() to release it.

Fixes: cc01a3f4cadd ("kvm: Support for querying fd-based stats")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 accel/kvm/kvm-all.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ba3210b1c10d..ed8b6b896ed3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3891,6 +3891,7 @@ static StatsDescriptors *find_stats_descriptors(StatsTarget target, int stats_fd
         error_setg(errp, "KVM stats: failed to read stats header: "
                    "expected %zu actual %zu",
                    sizeof(*kvm_stats_header), ret);
+        g_free(descriptors);
         return NULL;
     }
     size_desc = sizeof(*kvm_stats_desc) + kvm_stats_header->name_size;
-- 
2.25.1

