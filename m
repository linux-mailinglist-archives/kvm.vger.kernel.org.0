Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9869276C06C
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbjHAW1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjHAW0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:26:55 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDDB269E
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:49 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6bb140cd5a5so4756119a34.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928809; x=1691533609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YX68cKaF4vnEW+We5lKkwIPc6M0gbxoD0/Pl/wnYmY=;
        b=NnH3ZwjR+6ym79ufxj3REHVCVWAeZnzD6sE/KtDoPaGASei6BgOjGnOIrHQLFwAy3U
         XVSGEs+KVi0Doy801frFsvgI2DyT9wCKY3XW7IwWeqiMpgI8bI9eDTfdmOtbBPLE6klE
         O1JtG42w3iQC8kxerAhiebSICsKy6mL2MTlKv2o+Oc1oigPJmIgEvd0pgOaedovQOtLL
         S5Shw/AyR9huvVM7ZudNzKO8cyLbPf9A5p7lyJGQNzStSZUnmB28HFpyr1Q6Bm59EF3S
         iJkE5nutwowPiFjH/RrZYOEVloZpHL2/HulBHzD01JITmtkpEKG10+6BXPxW/zVNgTzb
         9hJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928809; x=1691533609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YX68cKaF4vnEW+We5lKkwIPc6M0gbxoD0/Pl/wnYmY=;
        b=LoWYFLUDWPxKsg2PMy4LIy1GW0CEI7m2w6K4HAquLIrrrywKhtMrCOAB+hNDZsbT8V
         lcY5OB92eUq5HqMCrdJoE3caHIjVD8MGcUwETRTz0p1rC36clFtdEcQOLnCPLYdU90mG
         0XN5Kle5yhSgieQyedfxhfqGo/8EvAZ4iA7iCLNrUiOhD6alTIQRIqykt6OOcIHMfXYP
         iKI48GHUmMLfpLp6V52RrbPB8flcXMRtIYK7Bu+c9jHIsNa5X/E4FeMj0k3q3Up5elX2
         W8qFYukmDJ0wVJi/14JTuX0UPY/MxcO8O2kaHdNDM5k8s1kMEWxXDcG7M7yzvzE8sLTr
         2CIA==
X-Gm-Message-State: ABy/qLaikh4ekue8VPymXRzlO2mQmxBXmdraytJ0bkCFbF0YhBcamI9K
        HIy2HVw7jUu15Ha9IwesFatBlQ==
X-Google-Smtp-Source: APBJJlG0JXAwYbBXteC+AdyNoGZj3thfQ5xcgBrMbS00AErUZEJPmh0buonf9MaVmGH4Fi/5TqTGWA==
X-Received: by 2002:a9d:7d85:0:b0:6bc:8aca:ae53 with SMTP id j5-20020a9d7d85000000b006bc8acaae53mr12449074otn.12.1690928808861;
        Tue, 01 Aug 2023 15:26:48 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:48 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 5/9] RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
Date:   Tue,  1 Aug 2023 19:26:25 -0300
Message-ID: <20230801222629.210929-6-dbarboza@ventanamicro.com>
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

vcpu_set_reg_config() and vcpu_set_reg_isa_ext() is throwing an
EOPNOTSUPP error when !vcpu->arch.ran_atleast_once. In similar cases
we're throwing an EBUSY error, like in mvendorid/marchid/mimpid
set_reg().

EOPNOTSUPP has a conotation of finality. EBUSY is more adequate in this
case since its a condition/error related to the vcpu lifecycle.

Change these EOPNOTSUPP instances to EBUSY.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index bd4998c3897b..67e1e9b0fd7e 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -209,7 +209,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			vcpu->arch.isa[0] = reg_val;
 			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
-			return -EOPNOTSUPP;
+			return -EBUSY;
 		}
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
@@ -477,7 +477,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
 	} else {
-		return -EOPNOTSUPP;
+		return -EBUSY;
 	}
 
 	return 0;
-- 
2.41.0

