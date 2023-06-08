Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27135727955
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjFHH6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjFHH6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:41 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4351BF9
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:40 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f6a494810fso2783251cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211119; x=1688803119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uR4vGAi/HAsBM59SbR3YpKTHihC3NFHqV1mwlrVIWs=;
        b=GvrbfRwJpEXF0UUprcpAZJdJ/b/d7Ws/5/jJotwgMFcQJisi8DnObj8vX3sDGrE0Aa
         eTq6/vZfRVjQ32WZ5gh45Ezj4cOUPCCipmbMDv2uM0+rmf/W63IYRxcVk7O80yoVkszw
         nXiYhEnOnU10UlF0fT1eJrjjJmuGvaRUqIMYqpJHRtOClmYAw5yI0MDvuNGRBoXYCqwV
         2xY26viwzt13synhCLWvi4lgeY+DDDT0+GYfvOHCDWXeuKyfMmfBjNX0fxpFm7cP4Yub
         yrrCwkZvOmBnZ3D6PTY1YmGzs+7cU62WWcE93wUh3XzTeJe9PPwdKkqnaOlMJSxEoUiT
         3pYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211119; x=1688803119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uR4vGAi/HAsBM59SbR3YpKTHihC3NFHqV1mwlrVIWs=;
        b=MphL4h+ixWXFf/NUQEAHc6Z/vX9ZUsCrV029cAM7DF5JdN7pqAFk01e2Ehs88SbZ5A
         Bja0CRyr1fhzIGPBMUZws3wA8ztMNgmGXcAUEtVPaRqZbpwPIeP8gFs3xLrVLZJRyJFL
         GA6rIojvJck/kZ3PmNWz++mRxm49Q4KGvu59pAC0MxciopoX87Gv3VKKPjGUPZr8xx00
         TNIjmiuepkprltO9nE2+ubMGOXW/+ZrZ8zt96JW9u7ExEZPOvCKkwhw+xAE+s344MuLQ
         GxdkEOXLFmh2B6ZOBL3hCqfkFhjcm6LO3T8OM/Urvfng8sO6tHSwOe0GZSYjA2i5MA40
         EgWg==
X-Gm-Message-State: AC+VfDxs23Op82x/Z2IPk4wICEJ7xjYUyUY/x24KLW0w7NB30dWegBhN
        MokCbPjmRVi0iHWMBhDG8oX6OslLEHQ=
X-Google-Smtp-Source: ACHHUZ52J1jHb+M/M/+4nUh1iyI5fsrCqpwzitxgH0ir7vG7XqcGRo1PiqB40N/R5HldTVTo5wvBag==
X-Received: by 2002:a05:622a:2c1:b0:3ef:37d5:49e0 with SMTP id a1-20020a05622a02c100b003ef37d549e0mr6059436qtx.21.1686211119213;
        Thu, 08 Jun 2023 00:58:39 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 01/12] powerpc: Report instruction address and MSR in unhandled exception error
Date:   Thu,  8 Jun 2023 17:58:15 +1000
Message-Id: <20230608075826.86217-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
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

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v3:
- New patch

 lib/powerpc/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index ec85b9d8..05b4b04f 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -38,7 +38,7 @@ void do_handle_exception(struct pt_regs *regs)
 		return;
 	}
 
-	printf("unhandled cpu exception %#lx\n", regs->trap);
+	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n", regs->trap, regs->nip, regs->msr);
 	abort();
 }
 
-- 
2.40.1

