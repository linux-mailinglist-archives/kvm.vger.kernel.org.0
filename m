Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5553B6E7117
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjDSCWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDSCWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:22:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815B9273C;
        Tue, 18 Apr 2023 19:22:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso2339255b3a.0;
        Tue, 18 Apr 2023 19:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681870966; x=1684462966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qq1wmNOq3mx/jsth4boKCBiQxJHNbyxopmmTMVawJyc=;
        b=YDwa6vd5CVqbJasmby+yXPDe94xJtFcxrqOPai6hf7eSY4JvGA0yUBFGHYIMjafZZD
         fv0yZE5T5ltLQmpbUKhVOVborf5gwR6HD51dSP/U3wYcu5kiME5xBiGnMgUZu5tw6LBx
         x0cQ5q2AOaUseGFCRvhtKwZpH61tFuz+n6x1fqtmJrno/O3zjASVCiEvVaKFMWV8a2og
         HzAV0LKCHVKREYBhOVqNgKJOgHDWrcv1qO+TYJlUoC4qyOOAAH62GA620D2JPoEy3rQL
         I/ktaFquz0Vflpf5w1LdBFMHxpIqaGDwTgX4hEWbPjwaXyFDDUxsTUBThk7dvZ3OT08n
         VjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870966; x=1684462966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qq1wmNOq3mx/jsth4boKCBiQxJHNbyxopmmTMVawJyc=;
        b=ZuzCHW0V9an+m92rsPIA3IucC/2QYiw3zBrjOc+ZuvoRPjhkiJa7Wg4SshRW09vsdv
         aBe+SVATQiEJT6o9yQLFsEICU2kGGi6pt1zfGCj6D55uSjf70BysKh4QyhiKwWPu156C
         cWFx5Cpy/zqgieDfn9XDh8K6dktf1Y317hPyimiA2scCDNB6O/DSj2kYcSXyZUzEom6/
         w6Jrhv4yTcjAGM7xg7HzwedMjQblG2y6XKcoV/2I1bUUzGQ3WOclI+xL3fX+wi6ij+2N
         jJ9A1hjYeMQmKubrSsjI68bPZUC3QOdXj7HP8OB6PH4zOnuFSu2zmOiQwlG8GFGk3Y/x
         Xi7A==
X-Gm-Message-State: AAQBX9d45bjl9X8b/XZfrXGu/SqdacVvNLgZUp+pz0iLljwrllVEa1EO
        tZPA82Ii5dpidg7TpUFckkU=
X-Google-Smtp-Source: AKy350Z/gTxAnzgrPPoCa99OlelHMIHhsiLZsfmDGFbos9SLw4w43Jvt2Lyppsg8KsOGaj8FUnfSmw==
X-Received: by 2002:a05:6a00:b50:b0:63d:4920:c101 with SMTP id p16-20020a056a000b5000b0063d4920c101mr987750pfo.30.1681870965914;
        Tue, 18 Apr 2023 19:22:45 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id z16-20020aa791d0000000b0062bc045bf4fsm10324154pfa.19.2023.04.18.19.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 19:22:45 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v3] KVM: x86: Fix poll command
Date:   Wed, 19 Apr 2023 10:19:25 +0800
Message-Id: <20230419021924.1342184-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
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
V2 -> V3: Keep the return value(0x07) unchanged if there's no interrupt
V1 -> V2: Keep the logic of pic_poll_read(), only fix the return value

 arch/x86/kvm/i8259.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4756bcb5724f..8dec646e764b 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -411,7 +411,10 @@ static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
 		pic_clear_isr(s, ret);
 		if (addr1 >> 7 || ret != 2)
 			pic_update_irq(s->pics_state);
+		/* Bit 7 is 1, means there's an interrupt */
+		ret |= 0x80;
 	} else {
+		/* Bit 7 is 0, means there's no interrupt */
 		ret = 0x07;
 		pic_update_irq(s->pics_state);
 	}
-- 
2.31.1

