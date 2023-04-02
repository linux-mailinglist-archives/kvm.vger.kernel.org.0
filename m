Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A696D3582
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 06:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjDBEpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 00:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBEpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 00:45:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE8E1CB81;
        Sat,  1 Apr 2023 21:45:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c18so25097964ple.11;
        Sat, 01 Apr 2023 21:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680410750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t+bA3SJ3PjGD6qFQQBdTjIrrF87xvGfeEMJfP2Ma1Co=;
        b=ZEJVdOPecChJmV3KOeSfuZTcGdLCAYoNnT4xVp07N7nji1NObeYro/5fGK2sWY8gTg
         uV+nwt8SXkNPWQO+atI4Ltu+UZ0YCbCVcxNC5CqdFkzW8NPMUGBmY3ACMY/UECk316F7
         pCtsUHMxwqmKxf3J1T5YIfQGSjLxqeuXgW+bFPQwNWZPYOnIZX44nto8yc02wDkVysI9
         r0q0vYLDwBEegCsmwfnvILv3SmtI4akL9Nyiffc74XOVJtw9TOHYfSTaePg16Gfa7tdN
         mxIBhmpupDuojaOnMS7m376zs0o4XL/Be9Pxn4nVurifKMahaH2SAt3LDkfxNoh4LZEP
         UIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680410750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+bA3SJ3PjGD6qFQQBdTjIrrF87xvGfeEMJfP2Ma1Co=;
        b=d7hXLj2TTy4ylRNis9bcX4lMRZWXH5npOUS2CEYCRUxF+qrZ7Ok0CinJijzaf0c+al
         8ryllGwdGhWwRqZ4ZSFcUvwqel6Yh6qkWinnr4+LpXwpIUfWaO5/a32y9N05RsBZ+J+D
         MafujaElIbIkJz8oq7xNGgEe3ZGDz5tWMoOuWiKorq4unU1HSvRAuf/YAnqf58O7ZfKZ
         EvcgOG2jujVVqiJl3cPVJEs7tLcRH5PyNU4X+3zzTI9EprviOwTYGSwbxe+SDR1X6mZO
         LZvP3kCFTQuai3SIGIS4okV5il9TCAa6Rg+H+2ZAcyfvvelsvWa4xrviThzpOEsXW0ut
         sNnA==
X-Gm-Message-State: AAQBX9f6n99lbwt0cK4yTcBjLR0jXqQZLLznd5mldsrraSPZ/r4c2y1U
        HdJvP7jor2PNhBhKASFUeLk=
X-Google-Smtp-Source: AKy350aJnnZTQvWuApyIgiaZeG9NGG3UWlb+OVWST3nWi4fR0STN06INNApzpLVSI2cJvEPZU29UFQ==
X-Received: by 2002:a17:90a:47:b0:237:c209:5b14 with SMTP id 7-20020a17090a004700b00237c2095b14mr36985912pjb.22.1680410750239;
        Sat, 01 Apr 2023 21:45:50 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id ja5-20020a170902efc500b00199203a4fa3sm4103756plb.203.2023.04.01.21.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 21:45:49 -0700 (PDT)
From:   Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH kvm] KVM: i8259: Fix poll command
Date:   Sun,  2 Apr 2023 12:45:20 +0800
Message-Id: <20230402044520.2125966-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the hardware manual, when the Poll command is issued, the
byte returned by the I/O read is 1 in Bit 7 when there is an interrupt,
and the highest priority binary code in Bits 2:0. The current pic
simulation code is not implemented strictly according to the above
expression.

Fix the implementation of poll mode in pic simulation by pic_intack,
and remove redundant pic_poll_read code.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 arch/x86/kvm/i8259.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4756bcb5724f..bc5b758e8f73 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -397,35 +397,18 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 		}
 }
 
-static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
-{
-	int ret;
-
-	ret = pic_get_irq(s);
-	if (ret >= 0) {
-		if (addr1 >> 7) {
-			s->pics_state->pics[0].isr &= ~(1 << 2);
-			s->pics_state->pics[0].irr &= ~(1 << 2);
-		}
-		s->irr &= ~(1 << ret);
-		pic_clear_isr(s, ret);
-		if (addr1 >> 7 || ret != 2)
-			pic_update_irq(s->pics_state);
-	} else {
-		ret = 0x07;
-		pic_update_irq(s->pics_state);
-	}
-
-	return ret;
-}
-
 static u32 pic_ioport_read(void *opaque, u32 addr)
 {
 	struct kvm_kpic_state *s = opaque;
 	int ret;
 
 	if (s->poll) {
-		ret = pic_poll_read(s, addr);
+		ret = pic_get_irq(s);
+		if (ret >= 0) {
+			pic_intack(s, ret);
+			ret |= 0x80;
+		} else
+			ret = 0;
 		s->poll = 0;
 	} else
 		if ((addr & 1) == 0)
-- 
2.37.3

