Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AB7246C6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbjFFOuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbjFFOtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:49:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836031712
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:48:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30aeee7c8a0so4508365f8f.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 07:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSOjU/peLBkZFAWfQ1yaQPRur2Vz8IL+LTbwDYZRyv4=;
        b=oi3fFDF5AYQ3Qbn4ovBhoFRM/iaiHlWG5LkCAFue091YkR2wPknZjq6SNIq/bRqWwQ
         uxM82ldwbfG88QsCRX1JMMsYcBwmiDeYnUSc6I37ALF4ckOaSH5glpjwwGcICv0MZYhV
         Erxj2eL8gKrGLBPszi2abOe36VvQmxuoBUAhHoUsFltrBimX3CSmz8gX9ouvurIkRFqb
         DuT9zPLCVm4gI5jAdu5o81EC2E2BNKAYul9nQEIka8+iwFBODCIf8puLIHfQkFhtey3z
         B1KC9s/1ltTbb8ipTWuKgp69xF/ccf7KuMVghaHgxSQPdwxqGVzhCmGtCeK8951kpIRi
         fEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686062928; x=1688654928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSOjU/peLBkZFAWfQ1yaQPRur2Vz8IL+LTbwDYZRyv4=;
        b=N2SK2uU7rKDLYPXUCC58FLBhxTNhmw0EkyYANurIE8c6Q6xBkV8xrc7QUjA/CsnfM/
         BLeBR/sYLVohDTIlP6DgMt+xkqQG1L2p/5zM/ngb1ywvAcUrNohnWWI5HlZYfynm587s
         uQW2lnqrwwbP3aqMdCH3w31uHLLZFdehvlKLGzDxCueUGlM7uFDsFWsT7/hmAoMEdxop
         C3wzYiPaF4Im+w393PNjH/YX184T7KW8ZnCM7IOcO9bg8dQ7ksq3l7aV7Z+iQSAG5KBo
         iI75YbRDGwSi7C1mskceQQUDWXQCDIIq2q67nBKNzz1RUyyx0jkwy6KCyf2TQ96fPhzj
         /Uaw==
X-Gm-Message-State: AC+VfDxO2Q4zOmh/JCEOfxv3NX93GYBL6SKX2MyCm1wf8d8mALJgd48o
        NlBNIEIbxCKkcXxeh4fnr3hoyBL1vplXxI0As2BXKQ==
X-Google-Smtp-Source: ACHHUZ6VjSEJGxNDtpYJTns8vjQUNPaYPEapkvMG2LCJZW4VOAQ5GL5myVffYJO4ITAUOWTfDTSeTQ==
X-Received: by 2002:a5d:5581:0:b0:309:48eb:993d with SMTP id i1-20020a5d5581000000b0030948eb993dmr8923125wrv.15.1686062927841;
        Tue, 06 Jun 2023 07:48:47 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c378900b003f7e4d143cfsm5722692wmr.15.2023.06.06.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:48:47 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 1/3] Makefile: Refine -s handling in the make parameters
Date:   Tue,  6 Jun 2023 15:37:34 +0100
Message-Id: <20230606143733.994679-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606143733.994679-1-jean-philippe@linaro.org>
References: <20230606143733.994679-1-jean-philippe@linaro.org>
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

When looking for the silent flag 's' in MAKEFLAGS we accidentally catch
variable definitions like "ARCH=mips" or "CROSS_COMPILE=/cross/...",
causing several test builds to be silent.

MAKEFLAGS contains the single-letter make flags (without the dash),
followed by flags that don't have a single-letter equivalent such as
"--warn-undefined-variables" (with the dashes), followed by "--" and
command-line variables. For example `make ARCH=mips -k' results in
MAKEFLAGS "k -- ARCH=mips". Running $(filter-out --%) on this does not
discard ARCH=mips, only "--". However adding $(firstword) ensures that
we run the filter either on the single-letter flags or on something
beginning with "--", and avoids silent builds.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6b742369..e711670d 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@
 #
 
 ifeq ($(strip $(V)),)
-	ifeq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
+	ifeq ($(findstring s,$(filter-out --%,$(firstword $(MAKEFLAGS)))),)
 		E = @echo
 	else
 		E = @\#
-- 
2.40.1

