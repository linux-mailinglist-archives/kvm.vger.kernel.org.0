Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD85276C06B
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjHAW0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjHAW0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:26:48 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0261BC3
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:46 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6bca857accbso1978993a34.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928806; x=1691533606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=di5SkeicRbmXIcOnY2hN20hVOPJQfmwRGNAJoH5+d+qNpiwhIyMqpN5ANQLK6ntmdT
         TtESBGIrvbNnSaLMcAl4oGaHHwcE4pAWpBW0p5Pvj2gOS1T4FTzKa87WPCOa3/cQyqF3
         4p9o7vX3yPG1q2tYdUrUsjgxYcvdg3tU1eSn6DOaij9S2nl0MU/bpgOhiL2yaUVyPciF
         zqv6MXwvcaXud2GbBMFMSL3+19S5+Cd27+qjGTb8C0LW/1LhNb1r8oWoT9bsZiDyJwHX
         +w8RrTx3ZlNARP707X3WpGb/+kfrh2LzBNlvpq/XV75UtV/2jD9vAcMBzlmDtOOgYg2p
         9nKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928806; x=1691533606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=OdVdTN3cWcRZkU2BuoOe48lVKhLrEGptqqZ0IkqS/b4uypgJCDUb3jvCAYBBWbbi6R
         OGKBxispEbdHZaPv8Qiw3A/Yd5jQbyEGiabID4Q7NmsxvOtW4t3LQ3HEfOQf565RAK7m
         BoObq8K+9qL+0wDPi03smfolpmOyp0xVN31uO5+7WAgN8tfqtuPyVlOux41eWFqYmQ0j
         hY/8SQLbb0I3+7CwO6WPBc5H/eYQ4T9SGXunevyJJV5QOWAjlqdiBDEaKKNA9cSyKdBh
         KNOVcoo35NKgcpU9onM7kb7gSp+1QieXBa5biD5JtuTNh8zCIaZ+3J8HkjG+gzRH/AHT
         FNRw==
X-Gm-Message-State: ABy/qLZISgekdt6xXPrcIOKMKEX3E4YaFaj0s3LRdkG008rMy6orCEMv
        HLkCjLfEulZdjSTDuCvkg6m2Wg==
X-Google-Smtp-Source: APBJJlEm/6GXbm7Xxy1xuZrkRoGgwoBa808/7qLXZh26/RqiFuT1qXfEHNTzxUwP073mbwT37pr5dw==
X-Received: by 2002:a9d:7399:0:b0:6b9:b1a7:1f92 with SMTP id j25-20020a9d7399000000b006b9b1a71f92mr15220073otk.8.1690928806005;
        Tue, 01 Aug 2023 15:26:46 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:45 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 4/9] RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
Date:   Tue,  1 Aug 2023 19:26:24 -0300
Message-ID: <20230801222629.210929-5-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801222629.210929-1-dbarboza@ventanamicro.com>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_REG_RISCV_TIMER_REG can be read via get_one_reg(). But trying to
write anything in this reg via set_one_reg() results in an EOPNOTSUPP.

Change the API to behave like cbom_block_size: instead of always
erroring out with EOPNOTSUPP, allow userspace to write the same value
(riscv_timebase) back, throwing an EINVAL if a different value is
attempted.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 527d269cafff..75486b25ac45 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -218,7 +218,8 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_TIMER_REG(frequency):
-		ret = -EOPNOTSUPP;
+		if (reg_val != riscv_timebase)
+			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_TIMER_REG(time):
 		gt->time_delta = reg_val - get_cycles64();
-- 
2.41.0

