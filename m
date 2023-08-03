Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338CA76EF8A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbjHCQdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbjHCQdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:17 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA61A3AA3
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:14 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1bb69c0070dso798599fac.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080394; x=1691685194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Se2JbaEVYLXjTL+pjhDmFAfPctGeuPvLnZbRGMw0k0A=;
        b=b4rf82DOOXLAo6uXuOPKsQdJ7VimE8510z42ayRg4RsS1w9OSeVvKZNaAglixIl7SY
         tSv4f5vykKGjEmVqyCzXRP5Tu8eseQr2wcSecarFNdVy+TICVxg3JsxM28azIhKMXWX5
         lqqH17GN1xoOcY02EDZPFeK5VxnG94CEFcK9RFoRlDyDm3nrFPigASPwoMG+68oXJ+hi
         X5viSYt/tCkPCc1Hr7VS88atC8bCtnLmRgzM26+eWShJyrbXGAESEc/+bAOo5HQF713u
         kyLwSgHc5RKPXoEzbE42igH22frMLNfy/AQ9IUPUl+rDcd6gQkNbcbQntDXIuyH1tKVk
         ZsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080394; x=1691685194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Se2JbaEVYLXjTL+pjhDmFAfPctGeuPvLnZbRGMw0k0A=;
        b=e/H5rD9W6T2YuELnuYh3uZ2U0dUh2wDO8NPm88AiXGzmZq28pgbiE9+Zd2HEuJdYvr
         7zUMtzTprdP7/KBIuzqgKdETJUGRjMgsw8Hh4RmQbxW9zqI9pljgailEL4Uy3264CWHT
         Q5MoONgq6mov5RiOarby9U/zC+Nx6Ovjhu48WqMi1+YQOWFVdAFQ/YwVWWK2rAF85FrR
         kjkbp23XPlztt7A0j7kwMIDJKpJjIpzTxc6/ODxMevkc2aMk9YtDOKyzmgp9MZCYOslp
         Y3L6HkqTUdzCplDY7sdFCMU19q2rBSCjwxBGTr1cfnIYl2J8zA89/08NUaD/lMEwOk8D
         eeWg==
X-Gm-Message-State: ABy/qLY9ke8qqXMLDwTW4cCjGbJlBhjRvQpm+A7yY7ucGdkZsZ0tDAfD
        /WPk/RsMkf7p6rjAVfAw9OKUnw==
X-Google-Smtp-Source: APBJJlFGD5MMq2Hoaz5rq9/cnX5nwZ7QsFelzBO/SLhIYURmphmt1RQt1A03YSPSmHlaKbGw6A5SAQ==
X-Received: by 2002:a05:6870:4182:b0:1ad:4c06:15c with SMTP id y2-20020a056870418200b001ad4c06015cmr20868299oac.18.1691080394134;
        Thu, 03 Aug 2023 09:33:14 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:13 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 02/10] RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
Date:   Thu,  3 Aug 2023 13:32:54 -0300
Message-ID: <20230803163302.445167-3-dbarboza@ventanamicro.com>
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

Following a similar logic as the previous patch let's minimize the EINVAL
usage in *_one_reg() APIs by using ENOENT when an extension that
implements the reg is not available.

For consistency we're also replacing an EOPNOTSUPP instance that should
be an ENOENT since it's an "extension is not available" error.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 456e9f31441a..1ffd8ac3800a 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -135,12 +135,12 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
 		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
-			return -EINVAL;
+			return -ENOENT;
 		reg_val = riscv_cbom_block_size;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
 		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
-			return -EINVAL;
+			return -ENOENT;
 		reg_val = riscv_cboz_block_size;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
@@ -459,7 +459,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return	-EOPNOTSUPP;
+		return -ENOENT;
 
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
-- 
2.41.0

