Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7F5B2037
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiIHOMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiIHOMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:12:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FBBB07F1;
        Thu,  8 Sep 2022 07:12:31 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b144so13267964pfb.7;
        Thu, 08 Sep 2022 07:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=U02/Kmp4vnmickAmHlzFNy/q3NuNhMIS7lgkXtU4VOU=;
        b=SwSn7mWt1tAlkjM+c/m1mTBqnxBjHqO+qaL07ivWbm+aLV04x3e8DgySIniKjjnYlN
         iddJzvPllYbIxPd7jMX9WwOCpEtzmOc5XZYkCpkiOgHb8JQjuJrXLSGLjNm3zo3TSG2x
         uDB8XMdbwZzlDz/X/PQNW9i25wqXm2YTsx9HXAQHKQ6bL/0Im8mWn4sqbIVqypVmEIG+
         NML5fUFJ63Zqm7896hm2jJaEtLgANyNmSDH129os+3+QY35DSFg0hViXQNjnJgM+P2uw
         1pwWei6lwAIEE21/syLV0Zr6ZxHRfC584oNWfjFPah6kRDjj4+tolEHZhzcqWHgOjRuV
         yabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=U02/Kmp4vnmickAmHlzFNy/q3NuNhMIS7lgkXtU4VOU=;
        b=QtZF/Z9U9ChTs2bbMnd3lsr84AKPv4ql7O36nyniPQbH9Xlyls8DBOZDjJQSTTilGH
         zBz7L9vmIHgCvy2NP0EsM4K9oIUlwyS/rfKG1aiFfKyU2fguI6uTupcr2fkf3fzx5SUu
         eF57Kv8+E0Tvtft4+V4yLrhX0WEk7ApUmFmcYsNQVkaJgos+cYIQou1c8D+ZUjFNroOk
         V/AvXPL2oWhmp38IYt5nUrNThJTC8GsjRE1txz7p2vvvLImetI2rWlJHPXEq7Fjanoxe
         3333izVH+41ZqNrmGNKZIL6/3qJyscziyyV74wJjpqkhvNTru4mZAaXQF0xWxxI2o5yO
         mEfA==
X-Gm-Message-State: ACgBeo1NRmwCAosewIt14WqoS3TBExU1U7V7SMTYD0bgR2J+hn6Ce9HT
        O4qrPsGIeVPnzcx8XEXqc8oXIp1BeozS5rQ4
X-Google-Smtp-Source: AA6agR5mV0eJROcbPOno07CsR89QBYMUu7nwSsuDw1ye8mrYzQsS3lBIeoLhp32Gu27XM5FGlcpEJQ==
X-Received: by 2002:a63:e516:0:b0:434:9462:69cd with SMTP id r22-20020a63e516000000b00434946269cdmr7528101pgh.503.1662646350500;
        Thu, 08 Sep 2022 07:12:30 -0700 (PDT)
Received: from localhost.localdomain ([47.241.28.43])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b001725d542190sm14771697plx.181.2022.09.08.07.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:12:30 -0700 (PDT)
From:   Liam Ni <zhiguangni01@gmail.com>
X-Google-Original-From: Liam Ni <zhiguangni01@zhaoxin.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        zhiguangni01@gmail.com
Subject: [PATCH v2] KVM:x86: Clean up ModR/M "reg" initialization in reg op decoding
Date:   Thu,  8 Sep 2022 22:12:10 +0800
Message-Id: <20220908141210.1375828-1-zhiguangni01@zhaoxin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liam Ni <zhiguangni01@gmail.com>

Refactor decode_register_operand() to get the ModR/M register if and
only if the instruction uses a ModR/M encoding to make it more obvious
how the register operand is retrieved.

Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/emulate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f092c54d1a2f..879b52af763a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1137,9 +1137,11 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 				    struct operand *op)
 {
-	unsigned reg = ctxt->modrm_reg;
+	unsigned int reg;
 
-	if (!(ctxt->d & ModRM))
+	if ((ctxt->d & ModRM))
+		reg = ctxt->modrm_reg;
+	else
 		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
 
 	if (ctxt->d & Sse) {
-- 
2.34.1

