Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79A376957F
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjGaMEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjGaMEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:37 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3E510D5
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:36 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a44cccbd96so3006458b6e.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805076; x=1691409876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIucR+Sjo1L1b52bma92ee9wHRVqNY7UNJqfHapIUO8=;
        b=eAAVNloP9p+8BWzpb+GCeyEqZre3HkYr+w7Wldlxy8JC2pOPcvfcfsAReK8/lp6+FO
         2GHUqukJ3POTBxEAHlsd+40caRTdkCqpoKxXXvGPFgNt0Qq/W962EwqFg/UTTfa9yd6t
         GpfwfNZLqBcP1X3Ctz0tMIcl0snYkAZ9vBimx8uInovpB3LaeWt42mLJ9KvX2nsHhfhA
         F9eyHTfo0s42IS3A4DjvWh7p3ziFGMXGk8zh9fqVKc+iuiZvaKVMu8ogFhYPV5loLwus
         SAsIgIrYHwElnvhV9X4XrbaOGZ7PVC0cPdxBzlnEKRSu5qXuMGGKl2HK7iV82mkGb8od
         Zh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805076; x=1691409876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIucR+Sjo1L1b52bma92ee9wHRVqNY7UNJqfHapIUO8=;
        b=HN3wH88UnO9RUjpDet/HkXVCuIlWdvfhqbswZcmfVkB2pGP6MdJqUyrmu6aI3BL3Mv
         V+86oHuUMCLfJvUQA8DRLczcujb42TIkfgrLig6W3o9FO6s4mlpud7+/rUUY5/l9T4jS
         h+OJBhAw0fqtNTIEgkb4Dlpo9AFOE3fPyxP3sDZKQMDKFfCagbbG8Skyyb+u0e09eI6q
         +yzEsZVueW6IT8s3t4p3xO+bxxHe3SloaRln0d61LjMj4NzVfOntvc7NRVbizZKW8Yea
         9u8zNzWbmzmptLsh4gCb9oSsZ0k2kU+U31c5bgl/DfGzU7Jvq2Djf4ZIYUbFc7s1vJop
         EVyg==
X-Gm-Message-State: ABy/qLbpdoqSfoQDp1a56I8WCSuVWw8pUKpEGCldgPWVF1EtakhkCtB4
        huHbkSymA/tXCHSYSr0h9hGSzw==
X-Google-Smtp-Source: APBJJlFF1X9useGPToJKkpTy0AkH3xIA5EFERBBIFwAku2kDhpMk0eZE6+trW1uN+35617iGK2V/hw==
X-Received: by 2002:a05:6808:1689:b0:3a4:633:44d2 with SMTP id bb9-20020a056808168900b003a4063344d2mr11844680oib.18.1690805076179;
        Mon, 31 Jul 2023 05:04:36 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:35 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 3/6] RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
Date:   Mon, 31 Jul 2023 09:04:17 -0300
Message-ID: <20230731120420.91007-4-dbarboza@ventanamicro.com>
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
index e630a68e4f27..42bf01ab6a8f 100644
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

