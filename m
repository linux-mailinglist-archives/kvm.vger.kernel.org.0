Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D076957D
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjGaMEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjGaMEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:35 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526F6E68
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:34 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3a5ad44dc5aso3320508b6e.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805073; x=1691409873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNE6gslN2FZbtPWnxyvZs6WmzJ7A08h9mcSC6XkxFoc=;
        b=aESJIiWznJiuLXWXUOl9f6pcdRsAo325ZsbUWL3XuYBw8qSDrwFkt/RPtlzRM749rM
         ckkfXOuQ2HP6NVrxWB1awskSoyWRzgXsu6v7SstGbnvmhQs1b/JcQKZPSSGQNyubvtnA
         cWWjrll0bMsSZBjNEb9dyRSGZz+FLB8I36Tsi9PSA5WtsmfbiRku1VDnXT4I7t7eWxGQ
         XLj/sq8XRI+BlXtr++byayMgvkrfRa+Drdz8UK2x+bsuWvH6UTFRkNgV0VquhPbVsx8J
         vUH1bKyWT4lZgAaxCQcU8lIuGqMNWPOEBWGkQnvh5yfGvP0DRhgbAdctTyf0Zy8TUUuo
         kS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805073; x=1691409873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNE6gslN2FZbtPWnxyvZs6WmzJ7A08h9mcSC6XkxFoc=;
        b=ibU3UBVQmByskcGwbRNtPBO6jnvANEtAWB4jpE7JFpsOVRCI2YtM+pQGFvV7Tqf4eQ
         LJlVktYDew3eZp3StTeiE/+FRbf35Ro/h0HLnsqImKK4y5JeRX4C6k5TgNUk1SzcLkLk
         fqF3xC+I1qNOBvqQUfh/6jfe2YAuIWEcikFaWd+e0jFOqAd9/phM27XakidEWgh8VhwC
         L5dx1hA62i+mgUaetCUGfNOj8noPtOmx6yjJpLSYtVC994+6LiXFSTZSpLJJXw0kgnca
         5c8OGUYjEVbSmxtiCW+VyNhJgV1D+XtweV92Z5XASUDy3J9tX4h0I6RbMdvlNZ7SP9SS
         +qGQ==
X-Gm-Message-State: ABy/qLaiUl9uKo1F1N5HCRmlp7IFTZdBDQG+ui7W0xn5xHoBkWyrX2WF
        sqwwTUVous/30JJ4cL5koYLi/Q==
X-Google-Smtp-Source: APBJJlFCdHu75NZrNZR6O6xW5Sj2fyqLsx5lLm8SnY0dOo8MvPVRM1v8rZ2F6hfUo9YOE04NSqHeaw==
X-Received: by 2002:a05:6808:1205:b0:3a3:f45b:aa3d with SMTP id a5-20020a056808120500b003a3f45baa3dmr12376830oil.39.1690805073344;
        Mon, 31 Jul 2023 05:04:33 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:33 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 2/6] RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
Date:   Mon, 31 Jul 2023 09:04:16 -0300
Message-ID: <20230731120420.91007-3-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731120420.91007-1-dbarboza@ventanamicro.com>
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
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
index ba63522be060..e630a68e4f27 100644
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
@@ -452,7 +452,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return	-EOPNOTSUPP;
+		return	-ENOENT;
 
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
-- 
2.41.0

