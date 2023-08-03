Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483EA76EB90
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbjHCOBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbjHCOBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:21 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A569A1FED
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:42 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-3a74d759bfcso754823b6e.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071241; x=1691676041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=VkKL4SWpN8H1S05U44mEkQoz7D8we329L1z3V6OpzGmXL1JOMTWJV7E6MIvheGbmbu
         O3TT6cc8d89JSEl8/0y+hznZ2P6tP+P1yWupO4nBDfe3Q+FWN3uj7OwowwOiClEj7ZuA
         kFbJ5TEcNngQKU+P1pRhEyv3kE8YYUaPYYmVOSySImOEXEx9lNpTLYGZX8sGMs9LCsv1
         b/LjWUsKKqdGBdWFeSJncHoi/JqicC0TBqqO765/0PYMyCDUhND/b9Wxm36UtNh1Yonr
         2Zu24pcCNb9kmPJY7xGNO6KB+977IRc6w+6KnpsMHJXUL45sL1Ju6s8Pkk0XVczXIbmf
         5Blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071241; x=1691676041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=k51R42FuJPD2OFlhza1KLdqYiT+MnlM6/8FgzXwGujvA/yfCjBfzRYxh+DGDvOYPCR
         YKA5ol1hWJdmiR3Ou/+QG4G+n6MXsT4YAyI+HermDYhvCfaKy0qyHd6tYWNC73iSgkbP
         KYqUpK8yP37Lp+2XJERHeo5AegQIHpFaua9CQGH8CxP6/1YQ278923p/HtmcuWXgQOhN
         oKs8HpLn2fLyP11rfnqo7IlErGUQPz5b7sgc0bPdF/cxwLCZ7LKrD+CYy5r0whyZQIOP
         iroqgapm4XwWrTbDF2zKWq2uaT96wQDsEd/AEdZglYhNHDVtUgcKnctI9UDuKh6VSxIx
         6Iog==
X-Gm-Message-State: ABy/qLbtPdDTp0hK3vaU8i/TtyvEyF+wwnPXLrP6gqbycWOYVZsflF2t
        458OMGWWbyt+lE1uMt7T/VFLaQ==
X-Google-Smtp-Source: APBJJlFd2x74atNXWpMe8rkpTEAS1KERwXNHpEJ0ZOg6dDJ2zjyuV432rhbjey0HbZ+Rghnf3NT3UA==
X-Received: by 2002:a05:6870:d251:b0:1ba:66c1:da53 with SMTP id h17-20020a056870d25100b001ba66c1da53mr20590605oac.22.1691071240842;
        Thu, 03 Aug 2023 07:00:40 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:40 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 04/10] RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
Date:   Thu,  3 Aug 2023 11:00:16 -0300
Message-ID: <20230803140022.399333-5-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

