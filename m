Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06B876EF8C
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbjHCQd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbjHCQdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:24 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F299AE5E
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:19 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6bcae8c4072so938214a34.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080399; x=1691685199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=layCgJMKTMdCi6CUwpGdosiF30u+gDMVAdsZicD45LuGPmu3PhVeuMEJrwDZikHCtY
         EtTtmqb7C2PaHl1fI73JUHKLNRChtqT12pdd82mW5dNPh/3mKpRlTKZ2/livS7Q6LaG4
         LNh1FJ911hXWY+2HRLipzSeGe+ljI/mHCIltzEsUGGlDMY+QPdq/dXsKlN0kTezY6xVk
         tigGCb/4o2r4pQJo2q+eRLeEqmJeh2Zzxsjsam74y7Gm+ssjSi/wKl1BoAwkMGu7fcfk
         f9U1nYn2rPLB/TurCeF8Fit9kMuuLkpon/D/6/YmFiskWAeAXANYohA2ypdHxieUG9XT
         KOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080399; x=1691685199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgDQfKgZT9Ai5Y6MxDXe+dFoAViK+yC0G5UtB2DQuPI=;
        b=Z4ZKMaQzaKs6JfSBM93tyzaZLQRwS/a4qxdj9e5NP3SsnFllqRYS09VWlvglxdazlU
         QGPareM0qk+9fcl2BFylAQvozbVYRt8LiDIk0MKltp6lJhJNB2gBFy3dRMPel2ZFkM3m
         3r/+9MY6woBP2NQGS1YvOu46jtruaoRCCRQoPX/KlCSmzefoapNNgmvQ4WnaqqPugU0y
         jifOv/GR2W0gM8u/srEo1yFi3piLB3e2VTIjpFEHjEnFr6uZeek9gU6lPeEYouPotpp+
         H1+RyuSuO1kP2uKM7M1M7cy3Mgnm8Y2MZWKHOKdJ+b4kWV8RccxJTmqVzSscPMrKNrC1
         SoaA==
X-Gm-Message-State: ABy/qLa5etzMBGhhbBYhMH+YHwX+Mjx50vnkEgAq+fz40pZQCzdilq9V
        I00EBIaR6g4FbVBtv3r9n+HhYQ==
X-Google-Smtp-Source: APBJJlG0rs3nKhuYYR5c82UKA4Dk+/x0du7zwqROz1SCshYkrDRGHKOreX+5liY/Az2sNnl2PH+VLg==
X-Received: by 2002:a05:6870:a90b:b0:1be:f721:db04 with SMTP id eq11-20020a056870a90b00b001bef721db04mr11116042oab.4.1691080399322;
        Thu, 03 Aug 2023 09:33:19 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:18 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 04/10] RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
Date:   Thu,  3 Aug 2023 13:32:56 -0300
Message-ID: <20230803163302.445167-5-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
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

