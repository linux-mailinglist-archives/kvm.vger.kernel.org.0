Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15EC6E5F29
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjDRKtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjDRKtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:49:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D2640EF;
        Tue, 18 Apr 2023 03:49:39 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b5312bd4fso9253183b3a.0;
        Tue, 18 Apr 2023 03:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681814979; x=1684406979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ne4t7JiMf2N7K31rdXpJp0mlGHlHnFrvUNu2fRDvLr4=;
        b=a/Mbnb8QKjZmJQtYsJu30n/UFZjrScTDmSj5Zl+/b1XAoq3xiyMAsGLs1GrgQd7TVc
         O9yzN4Dhq+qohee4RwTms9qIfgLX8ACBXq7hWFE4cN9FEVQqxM3Id/1YsHPPLhJfdMp1
         h7PfxFmLV/kjcdPZO1viP/2MuxtikWUrxsHY1nGVN0T8h2SgczEA4lKh7H4cGh5Nnr3G
         fDVxCWRvmAAUGjQBQxcQZqlW2ANZlnEbjp/nKbmxVJBlM89Kq2rZzlkCuQ0/bvaIpoYp
         kqIxYp+jgbwTsexOvC/eP6Y3vx+UZW7HGNud+egIXIA7xg/U8Qz7k1pjwIETSDd95Y3b
         TYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681814979; x=1684406979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ne4t7JiMf2N7K31rdXpJp0mlGHlHnFrvUNu2fRDvLr4=;
        b=dhDF81QrNYj1kfo7OiTUQWcYl/ncKGZpy1y8rXxE6vxsE98ePwbO4LZXKgMYN+u3E4
         RLkueumbkynb7K+SE7euqtceKt+fsH4Bu00Yb64svpdOfF1JyYM0zNDVBhpYBftiOjKO
         314HiZFeioWJ4kr03QhoZDt6Hj1wFqlwfz2AiGKJVDBDpdlnMhp1m02X2R29wN84jcLZ
         fIyVjMOp/3z4gHZdzpJCbzTJnwjcWVEMbEWvX1SmDRE8XT8Qm8fpzIsTNf0suEpMl2lO
         74IeGX4jNzQdNKOe3/fafjG6tLyhXM7Mk//Yd+hTIg/TbBh7m8PLaizWEW4/4uz4UkPe
         8pHQ==
X-Gm-Message-State: AAQBX9cC8M0udV7ixbKdati9kwZIlwkZFx1JHAFG8pPqOGNo+jCqmmNy
        sDguLyzLX4fRvijyfz0g904=
X-Google-Smtp-Source: AKy350ZWy7S+tSm+v0XcGgZFxoC/P0j3rCfmmRSifXG/3fZo6/qCuS98Vs2vvGPecQUUg7fraCJ52w==
X-Received: by 2002:a17:90b:18d:b0:246:fbf2:7e6e with SMTP id t13-20020a17090b018d00b00246fbf27e6emr1902590pjs.14.1681814979023;
        Tue, 18 Apr 2023 03:49:39 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id gz2-20020a17090b0ec200b002473d046e23sm6906437pjb.3.2023.04.18.03.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:49:38 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 2/2] KVM: x86: Adjust return value of pic_poll_read()
Date:   Tue, 18 Apr 2023 18:47:45 +0800
Message-Id: <20230418104743.842683-3-alexjlzheng@tencent.com>
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

Returning 0x07 raises ambiguity when no interrupt is in pic_poll_read().
Although it will not cause a functional exception (Bit 7 is 0 means no
interrupt), it will easily make developers mistakenly think that a
spurious interrupt (IRQ 7) has been returned.

Return 0x00 instread of 0x07.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 arch/x86/kvm/i8259.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 861872e2641a..57978ad8311c 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -414,7 +414,8 @@ static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
 		/* Bit 7 is 1, means there's an interrupt */
 		ret |= 0x80;
 	} else {
-		ret = 0x07;
+		/* Bit 7 is 0, means there's no interrupt */
+		ret = 0x00;
 		pic_update_irq(s->pics_state);
 	}
 
-- 
2.31.1

