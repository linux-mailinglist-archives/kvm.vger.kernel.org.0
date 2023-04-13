Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2206E0D46
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDMMNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 08:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDMMNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 08:13:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BA83C21;
        Thu, 13 Apr 2023 05:13:53 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i8so5763449plt.10;
        Thu, 13 Apr 2023 05:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681388032; x=1683980032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Saxvl5qt1Z3mQFBq5MXm2iUi65BPeDQQ5SDFNrUre9o=;
        b=gKtVWu7VtuYe88jEQCtkngg30vFAmje93vdtPc3bXPUi9GOek82Mrnk8gBEFqQx7KJ
         gBrFFS2Xfm8DqKSLVALwXY+AHamirnUqoOcPwAFzzYNw5eQq6vdVMIve6pExAMC2JeYg
         S6/U/zHwA3Nu8KRavzJd5xTL1uVI/PnPQ/aYhp+IY1xcP11GQkC6ue6dWIHSmkknoZ+5
         rwhkUa1Hqoyio6/wN4ijQKJXwIT+WBrxu3wjp5hJjsxmeyNmkwZ5YcvaQVOpg6taaXH1
         byqqA4AIohMbzXtelx9tdhN5nCG/I+CuQue+fJYekekfB7MsYoJtONNaT90+57BhomIQ
         D7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681388032; x=1683980032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Saxvl5qt1Z3mQFBq5MXm2iUi65BPeDQQ5SDFNrUre9o=;
        b=UAegpZlGVHX5RvvGiRMSZvbI/zuje3UsY86RfoIKN5lQ2p0mNL5Nz1bAVlGVxXDHdn
         4tA0ShxikfEWBFdW2aakb8+5VfJRCEb9sYnFsh8oUMLJ1VPOUxiO0N+dalIz2HfO/do0
         3kOL+MYki0NV9NI/NMiaEsjonUMJb1YJiefhVZ+yOurRCjEcJFy6Z9d/Ws+YQi0S5raV
         6YVzeXH5IuTupxRh6Y7nGb/TGvf/ol096U+Rjo1upRROZS6GKyxK11mDEYZ+kdm+Duri
         snJFPMHbqFelbpAmSDyac5/NMB4d8cOXbbplowubYuslWIBPoR90cPVAbXASFwYc6NSO
         9Igw==
X-Gm-Message-State: AAQBX9eyVImTaOb7HML2/YQEb88Jg/Hsn8ffyck4j7+CUUvm/eECbK/X
        RO8vGSiuldni006MmG4MmP4=
X-Google-Smtp-Source: AKy350bBVj+ORBDiZvhDO7M1UqGIqAQF/FMKhs9LQK9n2UWpXzFGiiUx15Ge519tXB6tIKzlQWobBA==
X-Received: by 2002:a17:90a:2a02:b0:246:d1ae:5fce with SMTP id i2-20020a17090a2a0200b00246d1ae5fcemr1662514pjd.35.1681388032339;
        Thu, 13 Apr 2023 05:13:52 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id ep13-20020a17090ae64d00b00246a7401d23sm1212814pjb.41.2023.04.13.05.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 05:13:51 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v2] KVM: x86: Fix poll command
Date:   Thu, 13 Apr 2023 20:11:14 +0800
Message-Id: <20230413121112.2563319-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Fix the implementation of pic_poll_read():
1. Set Bit 7 when there is an interrupt
2. Return 0 when there is no interrupt

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
Changes since Version V2:
- Keep the logic of pic_poll_read(), only fix the return value
---
 arch/x86/kvm/i8259.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4756bcb5724f..6627f8a52f23 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -411,8 +411,9 @@ static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
 		pic_clear_isr(s, ret);
 		if (addr1 >> 7 || ret != 2)
 			pic_update_irq(s->pics_state);
+		ret |= 0x80;
 	} else {
-		ret = 0x07;
+		ret = 0x00;
 		pic_update_irq(s->pics_state);
 	}
 
-- 
2.31.1

