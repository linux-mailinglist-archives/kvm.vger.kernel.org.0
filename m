Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0A750EAB
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjGLQff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjGLQfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9301BE4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b89bc52cd1so33536635ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179726; x=1691771726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=l6pHiFr/Ic0GF6DMijSsvpY03/gCJqTBZBgAPU5riKEy+RuPXWF1pnbatK3WRW2SVL
         1TKXAXpQeMFgpiDtiFGetj5q/K41RByvjdZ5k48nHJCRly1xsvUcMfWNVYuZ9OvMYE+s
         0WP9SOjK20a7LdH8i1YDdeZLEwBI+9Eu8rUdzvZNWiD5KFK65DMw+ffTOsItgWLTgLuE
         C8NpB4T/w5KYeAWRhl/k1aZ+GrOIIToBX6LvQeMFebynwRNC3uNqmEGE7PgZRREcFPSe
         g9OUwVZS2CH7Js25WT9E70Iw9w3m7IHkSxdtudC+/3NJRsxlOOloOT8drKLoc2II4aOr
         BLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179726; x=1691771726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=CurGsV9Ye2M7Hx9y+rwa2H/jjmCqI81khSoxOJX27hTF2i2bXti2ueIlutvC6gMQmV
         dDjp/aMqZa9Ref4keuQvdORTojGmjWnNtjrwaQPVUG6X8hdKr74h3tGqQET/Xc/Cc5Rr
         SarnFn99yMXtNwikWk0lbWAHluw8qUMSF1P9O5iw4oqPMvPkdIdXiLJG7nWsLbXOM0yl
         Lpvto/wxekdD10UH1uDiW2aDA5CEf/n3NQedheJBKEfNxC49GxRmt6IPgQWUf9QKtfo5
         7b+6j8Nn2fyIT9EkpIrTlwq3i+GLoptulY69rtBgszhhMKCg1uBDXKkwx3GmHsXA8Zcg
         2eUw==
X-Gm-Message-State: ABy/qLZmJSR7c+mCoIOhj8URnp6d8/NYSG/qy/GHIuszA2FOAdoi2kq9
        j/inNh9+4dzBg5eIDgwO3lKyBg==
X-Google-Smtp-Source: APBJJlHQ99D8NzgQJZOIAzGdXuBsZ/Y3apuk74lGBFhJvAtES7Glh3YELu1wLvKCqvAVzSlz3rZSPg==
X-Received: by 2002:a17:903:228d:b0:1b9:d2fc:ba9f with SMTP id b13-20020a170903228d00b001b9d2fcba9fmr10591211plh.11.1689179725632;
        Wed, 12 Jul 2023 09:35:25 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:25 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 5/9] riscv: Sort the ISA extension array alphabetically
Date:   Wed, 12 Jul 2023 22:04:57 +0530
Message-Id: <20230712163501.1769737-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
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

Let us follow alphabetical order for listing ISA extensions in
the isa_info_arr[] array.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3cdb95c..977e962 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -15,11 +15,12 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	/* sorted alphabetically */
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

