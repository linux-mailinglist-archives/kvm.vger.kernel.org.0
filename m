Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F139376EB8C
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbjHCOB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbjHCOBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:06 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF9C1981
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:38 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6bcc5c86b20so927416a34.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071238; x=1691676038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfxDwps7lgF17ypk0wnS9BfXgR1hQYuTelZWUrO/6tw=;
        b=CMqqPGLsMMuaZEUTphocqW4yFgSoZOpFqaDfOJpm5Rug/qGE9nn49ubd9rzwGFSkYy
         gQUOqVylXWKM/wTTBU8nWcEHm3tuePXEChxVDioVSXD6CJ2rw3z0aEehDSfzXZ+gBX34
         yrO8a/MPZztz43ooGbfxP15GnXMDOCZKYKm6mCz55w1JGXGI9fAY/GO4ynGqjvHLC7vg
         VW/5fP/O+PQuhuSGS42oR/3+eXmK+PtqPtt2VySOYmoEjtW5KTuwpdJPTWr6/AwvmnBU
         MgZ7I0ojWWcuyr4IJ/AJdYFvTeo3cwAlmSsCB5iumEtSoFaYOYFmEPyaAV6/O35EVbNH
         kw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071238; x=1691676038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfxDwps7lgF17ypk0wnS9BfXgR1hQYuTelZWUrO/6tw=;
        b=i+ycoUf0elrDwpaaWkfCZG+cbydgzgmMHEapimCOteqcJtv97pwsPktOxiK/QaCKeb
         mVeHNiTlCxFpZJJQFXKpz2f4osIYo5EIrcDDX3vPRilGFZJISX8eP/eXhmmYDNOFp5Xy
         R3Jlv9nkPXe5i78mvXpfGsChjDrvSV636usfqmhZMFckO8BTYMsib1fB7zrVcl7r5kwo
         rI99BlBtPt+WRQ5nRcxtzNF6I2OGBvU5C4o226/O+GSu5mz2ZdFxZ68zbkXVfY03KXx2
         73yyx3l63HM5C4anr6uA4g6DMVFb/HMpVLhn6tcABqjpTNSLsmGnHVztO9kpNKhHv24d
         Rfgw==
X-Gm-Message-State: ABy/qLZuD0obRmOleND6uYGIALbeR9fcHeY5w8WQdZ5BUDkGKEPqAbkT
        IDvoCelB2amUgIVeHSYpXZs4JrNRV74VdQqg7ZKPsw==
X-Google-Smtp-Source: APBJJlH4xxE7xbhXT7gfioaufiAVlVy9fF4cSW5XrzYXhlLE8iZBPjWLQ97nKoSQ2HQL6LkEmEzfrw==
X-Received: by 2002:a05:6870:ac0d:b0:1b3:eec8:fa90 with SMTP id kw13-20020a056870ac0d00b001b3eec8fa90mr25825081oab.6.1691071237839;
        Thu, 03 Aug 2023 07:00:37 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:37 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 03/10] RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
Date:   Thu,  3 Aug 2023 11:00:15 -0300
Message-ID: <20230803140022.399333-4-dbarboza@ventanamicro.com>
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
index 546f75930d63..49d5676928e4 100644
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

