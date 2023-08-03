Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029FB76EF8D
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjHCQdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbjHCQdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:18 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88830E77
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:17 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1bb575a6ed3so821171fac.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080397; x=1691685197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fx5RruSr8XX/h9I2AtxnZ2PV0E5AQnOItUyD2ZQGSo=;
        b=OXVlIvxqZq/ugA1tq8HnCrf89IYbUi3eCY5Lw7klgG72620m39mehcGvLdVyg8XyzC
         m2SoQpwziTq7cySZd+Q4LKeLr6ZjPVep9YuOuiRsYcHZ21oia+3/B58NVbFXThBSXxro
         +ZftTWsJA6qUlshZf0K89f4vgs4nFbHNvi1Auv3VxjtLAOLCtIrHJl4b6vHKM8GyhiJD
         q9xMGGPOqIKCLnOvkIwOmKEs4NVy0KTcsN2vxA8omyt2IF3/7+U0kZomC/Aojok5VYn7
         MWVlAumDQBlubFvgBOpBgQoQfJ/ApYfWdm/sXjcZ/eC8VLaUDFFrYDkQaUmff8ziH8Cu
         Iw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080397; x=1691685197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fx5RruSr8XX/h9I2AtxnZ2PV0E5AQnOItUyD2ZQGSo=;
        b=B1KHgLM58dTLbUenxZ0yd/rzym7QgCyIwy86v32YdhokE5LL5sdnfMO8uaA5ey3Ubf
         o33INV6rpXoTvNkY7mmcodu+ImnueJG21crEfHTE+pfeZ6ncWDFDBUOKjN/ScBRcjziJ
         Pyobqw8L/oGy8fFUgDzOMgcgaSu2givWyX2XSzDwU5zoG4pE4G6gI7qKINGLpMbX6fMN
         bpFPNKcZK58pCEJA9vA/wTgnvanVgCyd/1QSoIFiCJq0GRc3K3KnrTdfKsvEDjLKwTiO
         z2nZUcmT3hXUA5BjtOnOwXLQ/4ghzFsBEDQ1lCigvjO61cTa6vdDV4MZcroa1fjXdT8Z
         cb4w==
X-Gm-Message-State: ABy/qLY9YRrk2ghC4YPdi/rS03YV6/PTAjLpkMLx7WWqanh6O7ZVxqhS
        JOngp/FtiOpAvb+daUgzqh3clQ==
X-Google-Smtp-Source: APBJJlGcRltldAfni3BfR3KZMxmiX5SNdIToiZOXvm/eqO5x/Ld7sy5xC6M5vBBDuRjgsANoD+hfWQ==
X-Received: by 2002:a05:6870:4251:b0:1ba:199a:984a with SMTP id v17-20020a056870425100b001ba199a984amr21455947oac.55.1691080396728;
        Thu, 03 Aug 2023 09:33:16 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:16 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 03/10] RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
Date:   Thu,  3 Aug 2023 13:32:55 -0300
Message-ID: <20230803163302.445167-4-dbarboza@ventanamicro.com>
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
index 1ffd8ac3800a..e06256dd8d24 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -216,9 +216,17 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
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

