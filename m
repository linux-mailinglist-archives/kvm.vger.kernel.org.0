Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7C667ED71
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbjA0S0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 13:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbjA0S02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 13:26:28 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7551D8626B
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so5533522pjb.2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 10:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zm221noYPDv16VavlZywICLYGigsQ3r83tHpYQ6Bets=;
        b=ZcBhDH5tOacQHuA94vrShOzYvQg6QtjBICmN2cS9lLp1eNzFB5yxsNZPBOaH2GNR6m
         M5ZLuxW0OtCybveoStp55DxKU8uE0CxX5PfGQPKUBBnGgNvfRWDLBHWWcQjmA0eZe3bS
         0gICApwRPkQqa5+iA0bzYwDiu+ARraoCbqtymSf1RtjJ56UefDcSvvHA9neCIP/RLe+L
         Kq89X4xXUrnImpbZxkgb6zSUkHEl9QULQMfmpvOi2kCMFN1Fd9u6yshUOIupfzv7+26D
         FQzOb1OxA5eOjhxcYwlwt3DoLbjMDjg9TaRwKVBqiHlJ9uZ+TfYZQI2DY6/BwGy43OOh
         EyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zm221noYPDv16VavlZywICLYGigsQ3r83tHpYQ6Bets=;
        b=7DpMFNT1GjzMU7d8R+Kv9NhRLo0NUR1WoAio/8dD+Chdg7gFyCJ6PjjRLnHoJ9Weug
         aKNRwG05dnjAGBAl7upArjHOeaeUlLoKGt9Em2D+TD/GbhzN7ENyXXfUQZ0CtKOQV9+z
         vG/PmQaWifG+ZMN4UpPmlz8nBtLaQxw2JunfJC1V8gdqrizvdgpqTv5XEeLnGPgxRIIV
         sxi9kup2rYsx5xrBChBI6HfTQTYtnPXqAybrxYG/Vdeb3KaPqWUww83buj8e5vHVmnKl
         1KNyJcevdlRCbd/P3dtcLXW3tDKWdgOSPCTyQAE2H/M64Ue2xQfk99LBQssRfRG+vLYX
         yRew==
X-Gm-Message-State: AO0yUKVmOzGKBhG0AegpLigVNXGsW0EXXpL8+0fkxEJ00Z48gJORLQ6R
        wWKP9bGhAqUDjUAiH8xJWzV6Lpyeod3BpU98
X-Google-Smtp-Source: AK7set8xtB8ZM17fWbgG9a9Hf0U5T4cRhB4mYsKyZy5+8l5WFp0aHNt9s3X7BhTHmtZJUgE/ku0LCQ==
X-Received: by 2002:a05:6a20:8423:b0:bc:5a6:1b2a with SMTP id c35-20020a056a20842300b000bc05a61b2amr9264595pzd.49.1674843982840;
        Fri, 27 Jan 2023 10:26:22 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jc5-20020a17090325c500b00189d4c666c8sm3195219plb.153.2023.01.27.10.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:22 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v3 10/14] RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
Date:   Fri, 27 Jan 2023 10:25:54 -0800
Message-Id: <20230127182558.2416400-11-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127182558.2416400-1-atishp@rivosinc.com>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any guest must not get access to any hpmcounter including cycle/instret
without any checks. We achieve that by disabling all the bits except TM
bit in hcounteren.

However, instret and cycle access for guest user space can be enabled
upon explicit request (via ONE REG) or on first trap from VU mode
to maintain ABI requirement in the future. This patch doesn't support
that as ONE REG interface is not settled yet.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 58c5489..c5d400f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -49,7 +49,8 @@ int kvm_arch_hardware_enable(void)
 	hideleg |= (1UL << IRQ_VS_EXT);
 	csr_write(CSR_HIDELEG, hideleg);
 
-	csr_write(CSR_HCOUNTEREN, -1UL);
+	/* VS should access only the time counter directly. Everything else should trap */
+	csr_write(CSR_HCOUNTEREN, 0x02);
 
 	csr_write(CSR_HVIP, 0);
 
-- 
2.25.1

