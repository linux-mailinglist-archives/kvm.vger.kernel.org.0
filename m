Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7276EBA2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbjHCOCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbjHCOBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:24 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760913ABC
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:48 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6bcb15aa074so710134a34.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071247; x=1691676047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMgdqxcdnDQl98YLRV0LQz8Q38GTfP1yqCfHWC0ZO9E=;
        b=OCubc2jtAM5saxSdv7vwSmoa0U1OQXP79Jz28sjbUAmAnzUFCYIwjnly6PT+H9qfel
         ds3DMFmheazZErFepvPTe3pKElknJ08jUJruuQrxei/F9g7B2xjN4SCVaXUBVy3Qipup
         lHO167bvB/GQJUgwCb8SY1P4IdoSNPsrMR6oyQpHIaW0IrpbNfe8XACcOIFszH07GDPW
         TfHUGOAZtE4N9hSF5q0qNHZBpKct3f7cBxaZ/H/rGGD1oIyFnPSIfeMv75OeNO1JFyMw
         IRVZZhYrrWJK15ZfFLGCjdmj0HdA1qPHcwzYBw5I+p5HuKmN7ZQ2k7qdC7O8Wm1N5cfw
         Rz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071247; x=1691676047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMgdqxcdnDQl98YLRV0LQz8Q38GTfP1yqCfHWC0ZO9E=;
        b=KqbBjIq3MzdRCwOLY2Tyu/0OC7lkD8oBCgDNBwiChFxcdH0dIIXw8qcptkNDPfymLr
         sdcPaVfQQw0FgS5n/SIX45l9vRisbiq+GligVpF471hFq98hH9mdR5qxYeaDvc90tI3K
         UOMHS0yiIPvLg/ktbTbvXSe98SgAxJnQxXEnoQi+H7Rh7ATjZVl2zmj4cp4WhoWeh7oX
         eP2mHzEoHm5EIGFfIBeZLtYSeRCf+xSr7xCGTmweUO+DwGvz3eXPpondLeSou9+PJtsZ
         OIldVAx5NZoyog1RdtglcFyFUpR3SLibKLRDMIMNiG8MCz2Ifu4NzAzURUSOjNVfzU+Y
         uMvg==
X-Gm-Message-State: ABy/qLbHzbcDjsMZpWHgXc5RUTk8uQkKLRJO/UYeADCAwVcCqv2vKT9S
        dwIcPoDbLynw6Hux75Fv5wJn/HfTXzcwefIPSsX/Eg==
X-Google-Smtp-Source: APBJJlEcDRgMfvC3IQOWIDRGvND2vw9Hl/YKtkj7BedFr1ziA1rcBuyU5M2yaJHjMLmruPyJIQMDLQ==
X-Received: by 2002:a05:6830:831:b0:6b8:6bd1:d0d3 with SMTP id t17-20020a056830083100b006b86bd1d0d3mr18175614ots.5.1691071246747;
        Thu, 03 Aug 2023 07:00:46 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:46 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 06/10] RISC-V: KVM: avoid EBUSY when writing same ISA val
Date:   Thu,  3 Aug 2023 11:00:18 -0300
Message-ID: <20230803140022.399333-7-dbarboza@ventanamicro.com>
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

kvm_riscv_vcpu_set_reg_config() will return -EBUSY if the ISA config reg
is being written after the VCPU ran at least once.

The same restriction isn't placed in kvm_riscv_vcpu_get_reg_config(), so
there's a chance that we'll -EBUSY out on an ISA config reg write even
if the userspace intended no changes to it.

We'll allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace made
no changes to the ISA config reg.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 0cf25c18b582..e752e2dca8ed 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -190,6 +190,13 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
 			return -EINVAL;
 
+		/*
+		 * Return early (i.e. do nothing) if reg_val is the same
+		 * value retrievable via kvm_riscv_vcpu_get_reg_config().
+		 */
+		if (reg_val == (vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK))
+			break;
+
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the enable/disable request for certain extensions */
 			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-- 
2.41.0

