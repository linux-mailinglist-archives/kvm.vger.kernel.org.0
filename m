Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFB8730C45
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 02:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjFOAit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 20:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjFOAis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 20:38:48 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30E2698
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 17:38:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6665f5aa6e6so927394b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686789527; x=1689381527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LNogAbOui3VcxIgpFmFmpIdKc1yO2VTsr+3l0iF/r34=;
        b=Ga473fOoHsGbkffFcKvrnx60Ml2oDlstulm5s40vgRYt857O1tovN4df8/GF7tMwdX
         enn872ohiUCkoVeM45Lq5/HShADOjHcOm+QT4lKIScuqQhYvcV6YtQpm8c96RUCieuht
         PyKhXuJIK1jkNuLCvwEiOQ8+jtRPBnBkwIXXVO7eAlbFCLqMJBqHKldVfS3IWTgcmvxQ
         tG1MZT3R/Bqa5Hiplpg1r62Ll9zoLal8Adp4a2iyvcKbr/3Ihy5H8izI/Ez3cwdP9hMR
         T6HW8y4o/EAvdOvTnW9VgaXGRb0/p12zmCTXpu9HXp6zjpCgbUXd9ZfpM7KRVzJmzpQG
         3IBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686789527; x=1689381527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNogAbOui3VcxIgpFmFmpIdKc1yO2VTsr+3l0iF/r34=;
        b=BlnBsi79qsXVHqdHcb4n87kQFHX0afhAiS5s4/k49AZY4JBUkupWfbL5e4OUB5VJ7U
         klY52S+CAR4rpWpFP3YNNksKRfMgZAUOACzELmmJaXrFiSD7D1VPSMs2qsfFRYDCa3dc
         Lc5ywEEsOy6wMXb4PJN/NVGDeQYE4LaXQVUgWNIlxljULO6/b2ggg4Bq88dnfuyjAMd+
         82k8lMlIHDhJaSyKUk3kC3VBCpmO3lFuT/iNS4yhOv6oEu8YxRDgH5eBhtWsTlDJar8m
         4cpf7ToZLxFSe3yTkOn8C1VX6gAfXRsJLxkKOPaX7QY60rhoKtOIozG2iDslyhxVzJtM
         iPdA==
X-Gm-Message-State: AC+VfDxUY2pTEFKzElag6h51eEyAy+vv6jQJW1PiRas82dSOp6PbZr40
        PgDvOfv+ztKWY54WoCGmj4w=
X-Google-Smtp-Source: ACHHUZ4cRgURBq0pdeq90UORGtG4YXx4LfbGh6ow6l9kG5q/BjEJEY0fZc/zOgDxxhrlxrFwoV/noA==
X-Received: by 2002:a05:6a00:1594:b0:657:67be:d1c5 with SMTP id u20-20020a056a00159400b0065767bed1c5mr3939763pfk.27.1686789526777;
        Wed, 14 Jun 2023 17:38:46 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x1-20020a056a00270100b005a8173829d5sm5478597pfv.66.2023.06.14.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 17:38:46 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] arm64: timer: ignore ISTATUS with disabled timer
Date:   Wed, 14 Jun 2023 17:38:32 -0700
Message-Id: <20230615003832.161134-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to ARM specifications for the vtimer (CNTV_CTL_EL0): "When the
value of the ENABLE bit is 0, the ISTATUS field is UNKNOWN."

Currently the test, however, does check that ISTATUS is cleared when the
ENABLE bit is zero. Remove this check as the value is unknown.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 2cb8051..0b976a7 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -256,7 +256,7 @@ static void test_timer_pending(struct timer_info *info)
 	set_timer_irq_enabled(info, true);
 
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
+	report(gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal no longer pending");
 
 	info->write_cval(now - 1);
-- 
2.34.1

