Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1975AEFF3
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbiIFQJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbiIFQJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:09:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1EC6C;
        Tue,  6 Sep 2022 08:34:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fv3so5578792pjb.0;
        Tue, 06 Sep 2022 08:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=BB/cT8EaSOA65ryWbpq1Ye2k8Voy1w5k067SZ+8vfRM=;
        b=DB5Ds/qjABXtHcuWxaGeXLuE1KMGDnw6i9Cior2g7S4ipp9iY5w0I0BUYgoIzVnFpQ
         LtLiNjIv7xoQc/yY3pxfUDT1LhN62zXL8UenHXvKWThjeSDahPFEqm4dmFnEmjBYFact
         vFrOYdEO7V6yZ4bwFW3K7r/XmZBri9IGmjkaU4Fk8b74CWEZCc2GNcggI4jUmLCTVpkL
         87L29KL3jNawtNJqq9yDwHokBrpKjgO1nTKOr3xyeL0cUydSOsTmNVR4I2QTXTV4DyoP
         4j/6lxJu2aePKlGIoxjzRpRTrJ1l9PhJyr9CW0Q3CIIyUoqCXLePyHd42qn4P+RDWelY
         1mAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=BB/cT8EaSOA65ryWbpq1Ye2k8Voy1w5k067SZ+8vfRM=;
        b=hOtZrUPmucVk+aVp4gWBkTz/E6nOYw1BPOKJ1gk/yTKEf7XAekWlgDtuoRrJthKCyp
         c8KX7lu0piezZ/H2XSLrAhO2VXkgtgdQuNHii4UlxcNH4bvoFpEyFGUJAU3JjbM8yMaW
         BcOzNXm8+a64vditb6stpIPZuNFtAh+DhyrDR8FW/Mi4CbG03Mzmji4EJxLU7py1fJ6P
         PI3JZWtX1uz7xy2aBbrCRs9uLHINdMv9VJbZD8WW8txfmQ5G9BaP/LzDUWLifpX1m65j
         eFeBp0/ZKQv8t0bj2wO1mvBMnTpciyHmQD7QO1RNMVWTV0tBXrARD1nuJmYiMYHHUrqJ
         +y9g==
X-Gm-Message-State: ACgBeo1G5RzeUfnyw9tBLhV4zFeA+j1p+CksV6fcQl1Q7gGQWE0GUIqb
        1pSdlUpKkHnxqIQ7RbY7G/CKDnrE0y54XMFg
X-Google-Smtp-Source: AA6agR4bWp+CSGZ41R2NcxY8MN9vJx95VCZBS9JHD/fIiqiKRlxbl/DXxesk3GJ0sY9VruQ3jqfl7w==
X-Received: by 2002:a17:902:8498:b0:172:a201:5c12 with SMTP id c24-20020a170902849800b00172a2015c12mr54346567plo.166.1662478463136;
        Tue, 06 Sep 2022 08:34:23 -0700 (PDT)
Received: from localhost.localdomain ([47.241.28.43])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902bd9200b00174fa8cbf3dsm9882425pls.157.2022.09.06.08.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 08:34:22 -0700 (PDT)
From:   Liam Ni <zhiguangni01@gmail.com>
X-Google-Original-From: Liam Ni <zhiguangni01@zhaoxin.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, zhiguangni01@gmail.com
Subject: [PATCH] KVM: Reduce the execution of one instruction
Date:   Tue,  6 Sep 2022 23:33:57 +0800
Message-Id: <20220906153357.1362555-1-zhiguangni01@zhaoxin.com>
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

If the condition is met, reduce the execution of one instruction.

Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f8382abe22ff..ebb95f3f9862 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1139,10 +1139,12 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 				    struct operand *op)
 {
-	unsigned reg = ctxt->modrm_reg;
+	unsigned int reg;
 
 	if (!(ctxt->d & ModRM))
 		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
+	else
+		reg = ctxt->modrm_reg;
 
 	if (ctxt->d & Sse) {
 		op->type = OP_XMM;
-- 
2.25.1

