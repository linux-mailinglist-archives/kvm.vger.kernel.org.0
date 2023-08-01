Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5572176C06E
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjHAW1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjHAW1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:27:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5342D4B
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:55 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6bb140cd5a5so4756186a34.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928814; x=1691533614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7r2555zrpJ45pF+RZsLZv8NXTIDALNMtu3ezuIYWIw=;
        b=ir1bf1NkUd1QfJs0MVe44GeSJKW7Ts13wluYRfyXEMKO4rAiARVU3OEf1ZOSa4uVQF
         Mb4RWqPD1BOAuEgWt/4d+56bFlfW5NVoBuWtt61bcrrh1mSxlq1IjQq1zOXsGHwjocco
         Nk978lpLIl07pOTduDqRPuhAw7NJd3tQZ1twkagrsOjpoXPMPD/TvCVzzAuQD5DBvppr
         lnO3xRJByWxB6qQ8dJe4OgZrn0Yj+u1+MlgNaaFs4x2kmSr3R8m7PTMz27Aawz0goNE6
         9JzzQO3md131Sqfur2oRUuCQ/DcEku7139RHYYkiFbnchk9pL3X3PADfe5HLZYrvZ14G
         23EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928814; x=1691533614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A7r2555zrpJ45pF+RZsLZv8NXTIDALNMtu3ezuIYWIw=;
        b=GEr8QzIKQSiSQpcZMDPZTFBbFA9jM62Wx1MnBKCKJKHO3fK8kB7J45GkpEfZiwwXka
         scPxTOXZJqiTzipMsJHVqinmVybXFP7rUNHEgjW5o/PSk/+7499VkutG1H3rnNGWX6DW
         5m7dFuYiHiS+bAxOrk6FSKNUuQhnkGSsCpaqUV7LmimK35H4j5ThJcM5oO7vMXIFC0Ht
         P/izfFTyXxSA4T8KkStZ+qZXvILUPHcmEHRT9qrce8uGCy8RLFIUdb//K9npXOeou58y
         iuLVFQdd1wi2SRTE1U5TdAjL0QWOdXtV6r+U5IHKo/XKSQq3s4PEKTwITRBgi9ymspAm
         hicw==
X-Gm-Message-State: ABy/qLZqee48tOwR8mUR84PvaphQX4dj/L9wVN96jHSwCDnfQvwT1xAZ
        bRF7kgDrOXj9qnqLqSQ1EaonPw==
X-Google-Smtp-Source: APBJJlFRhJs+P7xUCrp791oiLfhFUY5WOcY/fx+DPuNv6D9PvqDYzDNwGY3bVHnAmRGk3hvNYCx9jw==
X-Received: by 2002:a9d:7543:0:b0:6b9:1917:b2f5 with SMTP id b3-20020a9d7543000000b006b91917b2f5mr12958739otl.28.1690928814338;
        Tue, 01 Aug 2023 15:26:54 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:54 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 7/9] RISC-V: KVM: avoid EBUSY when writing the same machine ID val
Date:   Tue,  1 Aug 2023 19:26:27 -0300
Message-ID: <20230801222629.210929-8-dbarboza@ventanamicro.com>
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

Right now we do not allow any write in mvendorid/marchid/mimpid if the
vcpu already started, preventing these regs to be changed.

However, if userspace doesn't change them, an alternative is to consider
the reg write a no-op and avoid erroring out altogether. Userpace can
then be oblivious about KVM internals if no changes were intended in the
first place.

Allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace makes
no changes in mvendorid/marchid/mimpid during reg write.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index b0821f75cc61..1ceccc93ccdb 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -232,18 +232,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		if (reg_val == vcpu->arch.mvendorid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mvendorid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		if (reg_val == vcpu->arch.marchid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.marchid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		if (reg_val == vcpu->arch.mimpid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mimpid = reg_val;
 		else
-- 
2.41.0

