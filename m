Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B3769582
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjGaMEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 08:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjGaMEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 08:04:43 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F3F10EA
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:42 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3a7293bb9daso696766b6e.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690805081; x=1691409881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/G0IwVJLR2t3toGYLVhTTy1luMUvUk5+J3HPr91WKI=;
        b=jdB0bZjCbnhEc6O9ewJ5xaBpeZCo5G3llR4i2db5ONdCF93K0gd/AL53RIoiLOkmnk
         eGo1BDBUXqQZ8ZMNU03TfIHGxQROjYL6umpAANjBWPCQmH42hrMu8G3wv1kyWpmsqNHj
         lFxfP8tJX/zCoiGO9odyKjQgNxl76izXDyROtT2yMwQYo8GlNo8ylOM0+OnLjBmZ7tt7
         g2+3DhXDbpa+7XFzE+Z/cV9l9wG/Wu9wFkqQD6blPvYpPNVseMlLE7GoTYWbfp02gjgk
         OXZlx+VesQ3/d+O+9GtGgO0mjb6fccvt2mVVSCHh6D0eBQiCN79dvOPKDB6tYlSSQKLf
         8e5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690805081; x=1691409881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/G0IwVJLR2t3toGYLVhTTy1luMUvUk5+J3HPr91WKI=;
        b=OxD3JNbGuIUPAd38ACkBtYxEoVtdMKayxocJm8gFl48d5gQ+eHbuuZBm/MUWscvB5h
         NZU9NBFCQMNdnQtAo1a8j7Hq75PgV5zt1yrGHQAB0K0e6Z/GIYZCENUV+h4eky2SSGMX
         NpXOWoPbG37hnzgNW4GqOm6j7c0u7ZERBDGDzwTnntDqQySzfKQh3RvHMXczPDwN7WtE
         P5sdawApHqKlQMqWOxdmi+4n9E/8xZjHaLAfPNOWqJuZvPKBseeESxVK8CuOXgbxukZK
         vSJTB32Pg+1gj5TKahkZsI75EyNsOwYm/+bNjd9fdbkzJUpgkVkP9SVEOZPHYPwGwyZy
         d8Lg==
X-Gm-Message-State: ABy/qLbZVakJLuQkS97cxnqzpjXKx4erykaUKTHv966v8TmLFjYj2Nxo
        S3yWDJDRVHdTVPn5pUgwluITVQ==
X-Google-Smtp-Source: APBJJlHIHCqrSrjtB30WJ6r7S8ELH+xlN95Tp7EtN4g6xbD+5HemVufzJTifbbVdLravlyptBlBv9w==
X-Received: by 2002:a05:6808:20a5:b0:3a7:37ae:4a47 with SMTP id s37-20020a05680820a500b003a737ae4a47mr2710551oiw.12.1690805081564;
        Mon, 31 Jul 2023 05:04:41 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id a12-20020aca1a0c000000b003a41484b23dsm3959316oia.46.2023.07.31.05.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 05:04:41 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 5/6] RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
Date:   Mon, 31 Jul 2023 09:04:19 -0300
Message-ID: <20230731120420.91007-6-dbarboza@ventanamicro.com>
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
index 42bf01ab6a8f..07ce747620f9 100644
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

