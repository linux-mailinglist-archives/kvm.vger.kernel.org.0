Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5854576C06A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjHAW0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjHAW0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:26:46 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA61A1BC3
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:43 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6b9defb36a2so5637582a34.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928803; x=1691533603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3eA/e/cB+WcDUoMj89fMOnZM8t06QYD1BWj3IhHamk=;
        b=NRMXz2Obdw/cifjK+L0RgolPw26C7twXbt2QebSreG/+KYTvMociZTnO1XU1TFhEAg
         gEdPIB0CohxtjU6w8w8Anwnu/pmXe3e3U9ER3hEBAXYID0s0WeKAhFiHIffHtBSYKLkU
         D4NWRabUxNCuZQG8NkIx1tjs8i+B1Evnsy8YZ+4h0RSKtnTjp93XrAUq2uf7oebPM+2Y
         bytVHHg8cwRfub405gSLORmLY1PZiZmYMtxlohaEsO5bTA/kKNg1EHpw3FwHLm6aCoWS
         hIgZNAlseXlOzvUfzEk7Pr2EzwJswSIufNi2eFU2pC8phuqWDPAUW2Dh7U5HL2KC83/X
         Cnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928803; x=1691533603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A3eA/e/cB+WcDUoMj89fMOnZM8t06QYD1BWj3IhHamk=;
        b=RGxI9yxG2kNrMegJ5olalLOWqlvWXc43eiE2b3abjJT/zm084yyWNiULWgvQJ6LgVq
         uk9veCL2GKMBbZx0ZopoD6CyGLyVa3Xve0SGddae1J8XKKIfMQvOOgxdNFNPiMy/GEdZ
         W6tkbmAQS/8Sf59ffmHFy/t6H5emFiLhcKW7Ti97LtFaZhKtkLCPkERdmb4SPbHhMSGj
         s4WTV6wOmBpzdthtTDseyWQZ88cJK5aCXGYy9OoxEbw3oO705jerwjv2nWNi5hx3qWoT
         9Ui+Im6xFt/zwe6pKqspzk+IsWnC3Hicmb8BrKAEQna/w7mGCMccxApwnt6Z8N5Viyqm
         mwJg==
X-Gm-Message-State: ABy/qLb6Wv6Iba6RVp7GKm6cUNmCVONpaNoIs6KS7S3HNLFFSqPIDP4n
        oMrx2NcN5AMgqEnQ2iPLbT9zH6CZBcxN6mB/JVdSVA==
X-Google-Smtp-Source: APBJJlHmOOJ+gAPePagRtIsqfdWm48Qym+qt0rsxV/ggxmZSqjYFPuyZ3A92I4GeuBjq8dcaf9fobg==
X-Received: by 2002:a05:6830:1b62:b0:6b9:2b25:459c with SMTP id d2-20020a0568301b6200b006b92b25459cmr15315290ote.28.1690928803303;
        Tue, 01 Aug 2023 15:26:43 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:43 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 3/9] RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
Date:   Tue,  1 Aug 2023 19:26:23 -0300
Message-ID: <20230801222629.210929-4-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801222629.210929-1-dbarboza@ventanamicro.com>
References: <20230801222629.210929-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

zicbom_block_size and zicboz_block_size have a peculiar API: they can be
read via get_one_reg() but any write will return a EOPNOTSUPP.

It makes sense to return a 'not supported' error since both values can't
be changed, but as far as userspace goes they're regs that are throwing
the same EOPNOTSUPP error even if they were read beforehand via
get_one_reg(), even if the same  read value is being written back.
EOPNOTSUPP is also returned even if ZICBOM/ZICBOZ aren't enabled in the
host.

Change both to work more like their counterparts in get_one_reg() and
return -ENOENT if their respective extensions aren't available. After
that, check if the userspace is written a valid value (i.e. the host
value). Throw an -EINVAL if that's not case, let it slide otherwise.

This allows both regs to be read/written by userspace in a 'lazy'
manner, as long as the userspace doesn't change the reg vals.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 291dba76bac6..bd4998c3897b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -213,9 +213,17 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
-		return -EOPNOTSUPP;
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+			return -ENOENT;
+		if (reg_val != riscv_cbom_block_size)
+			return -EINVAL;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
-		return -EOPNOTSUPP;
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
+			return -ENOENT;
+		if (reg_val != riscv_cboz_block_size)
+			return -EINVAL;
+		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mvendorid = reg_val;
-- 
2.41.0

