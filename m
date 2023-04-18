Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141876E5F26
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDRKto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDRKtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:49:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E2D5BBF;
        Tue, 18 Apr 2023 03:49:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-246eebbde1cso2153966a91.3;
        Tue, 18 Apr 2023 03:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681814975; x=1684406975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVrqBF397n+wyX1nXbC/nI8o17aiMQaR1hvjDl7dDXg=;
        b=GIsmMcGJRopC8pM1uUDcw0uD8zMW/7xHmShVLsYoq7VFw4kSHC/STVQuUXu74aGAHi
         o2RyfriUazcmr4JfOZ32skmJ5kQzW9peZMbNm3pTFZJefXDFsbVUOfaeFpCPS0FE4SAG
         0opqk45WHWfsmFi6UplvgiCCQFMIfdbIb74oMvPnoaQz0xJy1kFy7QcSFJr3OM7Sska4
         bPKwXEGPUB8YLpoPo/wrUK2GXMhc7QygC+E7Q0CgP4T2cNtBSSL8C7aaEJDcobqgYo3/
         Bc9j10MP9Ocmri4sHp2Tr4fx1k07Enp/4EkwCyA8KZFnrQl98C1BJHNweQdi+DsrwrBF
         kQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681814975; x=1684406975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DVrqBF397n+wyX1nXbC/nI8o17aiMQaR1hvjDl7dDXg=;
        b=QXksa3r5ZreO7lL2QoU63SVZCNp3G34Il6f+g5YrCiJoDaZGcssBnIAnDz89U/htPE
         V2Q0VWkzllfiIsPuwM4iRfX8MzRKN1igt3eQYEGMEXi+8Y6gIAuVzORyzNca6QD7Uga4
         Ow1t+MpG6IvINJZujzWrKnUo8zgzzr8nCTHWc454DldLUHTCit6lK+yk7yLNGg6mpCSp
         QgmHbdPBNqC1SpqWUhBdTpDRTg0UAT5d24icTEexKf41Fme0nKgxEGD4YEvexerElUdr
         StTJuePE+Z3isrNA1LRMUe62uluCSUqtbaM/zTUSMCFG/vJvKEO4BPHPrnM2kIpBeC2I
         6nyA==
X-Gm-Message-State: AAQBX9dX8VpLuEMZAtBHToiG+AtJVJ9H79K4udWcrIkpspoXpcMW4zX1
        lv9RbP9UUHVf6OOV9oe7y04=
X-Google-Smtp-Source: AKy350YMXNhm14FGlQ6oLuFJ5X/eenUtM34P1Mu1GpPalGaC/Vyg7NTb1ABjIjTxUtdHRoCXRt5Gmg==
X-Received: by 2002:a17:90a:e144:b0:237:ae7c:15be with SMTP id ez4-20020a17090ae14400b00237ae7c15bemr1616438pjb.30.1681814974762;
        Tue, 18 Apr 2023 03:49:34 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id gz2-20020a17090b0ec200b002473d046e23sm6906437pjb.3.2023.04.18.03.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:49:34 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 1/2] KVM: x86: Fix poll command
Date:   Tue, 18 Apr 2023 18:47:44 +0800
Message-Id: <20230418104743.842683-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230418104743.842683-1-alexjlzheng@tencent.com>
References: <20230418104743.842683-1-alexjlzheng@tencent.com>
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

From: Jinliang Zheng <alexjlzheng@tencent.com>

According to the hardware manual, when the Poll command is issued, the
byte returned by the I/O read is 1 in Bit 7 when there is an interrupt,
and the highest priority binary code in Bits 2:0. The current pic
simulation code is not implemented strictly according to the above
expression.

Fix the implementation of pic_poll_read(), set Bit 7 when there is an
interrupt.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 arch/x86/kvm/i8259.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4756bcb5724f..861872e2641a 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -411,6 +411,8 @@ static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
 		pic_clear_isr(s, ret);
 		if (addr1 >> 7 || ret != 2)
 			pic_update_irq(s->pics_state);
+		/* Bit 7 is 1, means there's an interrupt */
+		ret |= 0x80;
 	} else {
 		ret = 0x07;
 		pic_update_irq(s->pics_state);
-- 
2.31.1

