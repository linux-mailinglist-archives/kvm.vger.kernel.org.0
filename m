Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE15976C069
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjHAW0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjHAW0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:26:43 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1791BF6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:41 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6bcade59b24so1417386a34.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928800; x=1691533600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv6jpKJhy8/Sckln3Iy5hN8VGQyXxzCnKjLb9FdzrLY=;
        b=eQcjHdUMiP4KVuzPbfF/huXAQjIYpENF9bPpOmaZLemhYuhz0fmpcvjgpBzHITCWPa
         WfCGZ6lgn2+XhcuVgYNN5/TotcazrxjP2IKfHCR0HKpvIGFBr2+Im8QoFCYcsSQ3NfoA
         Wu1XJK9DV7duJnim+JeukPLWpBXTXZ2Z7LRUew6AtiwkShit+BsAWCAR5MZDSHf5DpL7
         G8FYYRSKrL6qXdl+p1fQtKXef1ylwbNWWI0IqIG7HTkJ/h2dBVTZKy2KzTor6jLZQJUP
         gelFkNvBmR+awuz1JvbiaCi8iH4b7IJHlWdGG4/q0M9VFgzqSTEOVoPV31k5Lhy8i3pS
         F0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928800; x=1691533600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jv6jpKJhy8/Sckln3Iy5hN8VGQyXxzCnKjLb9FdzrLY=;
        b=EEdFlvncVH2ECOayfScw89Xw5Bv9QS0UlNCPpwLZUsw4ij/o2xxOapviwnjtOTcE5T
         Nb/TP5570P+rSC79KS9ZMphEej0ozCXs+P8tznUY4onp7vQ9enhueP6301eRZXAuwHeQ
         Z5qolKnsN7lsSiP3CyOKvVIXrIUviE2Wgq0iCd23w4dO75rfGh5Z2gM78cdipBRUC3dP
         Q1bylztFvWHYdP1O3GkZf9fiL8mgfLbmFDzVG96uSqq/qecB744VVLVJLAdAEt5yoKTq
         TKulA1xEVYXIUc01aLx8GZAqXnqDehjwMMu9gnPhXdnRSG0xliJsRsgm5y/shjSevOjj
         Y2tA==
X-Gm-Message-State: ABy/qLYfp4vwHHEbuHa7tHz4NCzAoWvjdzSAHGzPaZCjdkvzZCtH1sh+
        pfx/TY/m9fwSMPm1rl4zaIPihqMdx8NZogvGiFkpxw==
X-Google-Smtp-Source: APBJJlHWrpu26IQHATupCfOKcJlmefh6VXi8ZxEkDKe6BPilP80cVJ8dbkAy+62vxre/85ADQSoqOg==
X-Received: by 2002:a9d:75c2:0:b0:6b9:6484:2f08 with SMTP id c2-20020a9d75c2000000b006b964842f08mr12517057otl.36.1690928800720;
        Tue, 01 Aug 2023 15:26:40 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:40 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 2/9] RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
Date:   Tue,  1 Aug 2023 19:26:22 -0300
Message-ID: <20230801222629.210929-3-dbarboza@ventanamicro.com>
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
index ba63522be060..291dba76bac6 100644
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
+		return -ENOENT;
 
 	if (!vcpu->arch.ran_atleast_once) {
 		/*
-- 
2.41.0

