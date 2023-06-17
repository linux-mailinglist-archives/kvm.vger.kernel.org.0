Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EAC733D6C
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjFQBc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFQBc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:32:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09F53AAE
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:26 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-666eec46206so362626b3a.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965546; x=1689557546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghZd0EKhf6zwbSGX8Xn3+2U2jGi5da3/3tMUOfzdgis=;
        b=LX1x0JRoF8m32vS2JI2nzAerxVhcE3UoWLK4m6IECKwHdvB2PwOynpXO9NeNYxTvkB
         RFearwiEFTNfAIUqEMmzZ5DYwVylYKCSe2bbGLARV8QIWDNJYxNTuf36DHN+3X9yLdzL
         j2m2emSsrssKh48EL3/EHRLmGbu2zUb8gezphQuIv4Ryb1OakI5fIdswOL/HIt1syShb
         QbRQoTt665T4m8YxSxjExB/FUKOCkPu0Q4COQYpMYnuUV4hHL4dVYR34AQbnBCg6acXW
         5MeWFqgTIef9XaT8thoTIw/7wwEH9NXXD3u1nt3XB+W/ocpsFgm/icS4bnXNR8s059i1
         s4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965546; x=1689557546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghZd0EKhf6zwbSGX8Xn3+2U2jGi5da3/3tMUOfzdgis=;
        b=LNLdpG+bt+5KKoTU3b0aOFYxV3fDoW/pINCVDKAdv3bldJYMXNedG/FK2s1cGMIKKE
         uf59nA145YHgaAbWnbPWkQ6naMEkOancqDR4OE2lwc07OaiQU2Ff9MeVEqx903J23dH6
         Tpgd4Ppd1ALoCs2XFSJ6tzUP42cQtxOj2riqd3/iUU86i6tWRkfFyNm9j87vKcuxYWQq
         EJIzT+JBndYY1m2OWKTXorYCiTFejnV4A7Z3EB9yRHa6ucQnjwnYh3bMLuVU3MzH41q+
         Z1Lb5JGLPhgYCzmjmmw+PbSCqUrn0iQIBHEs0ODX9AJnFiUR4Ve4cehFcU9ncB3Ane4W
         Gn1Q==
X-Gm-Message-State: AC+VfDy6EUAJoQ8RlktC8OeRYOoTf2vlDLmq2k9qmSgNJ9RFJKTBHGvs
        dXgzgxwg+8C29Lgy++JOUBTqkz/BagM=
X-Google-Smtp-Source: ACHHUZ46BQ3K9gzQ7cJPo8/KJowe2g5mNX6avWQEOC0XnZcU/OPBBS7o6/YbOlbJ9DYFXWuC3xaTlA==
X-Received: by 2002:a05:6a20:3d10:b0:10c:80a:480c with SMTP id y16-20020a056a203d1000b0010c080a480cmr4963821pzi.41.1686965545808;
        Fri, 16 Jun 2023 18:32:25 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:25 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Date:   Sat, 17 Jun 2023 01:31:37 +0000
Message-Id: <20230617013138.1823-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617013138.1823-1-namit@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.

Without setting sctlr_el1.SPAN, tests crash when they access the memory
after an exception.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arm/cstart64.S         | 1 +
 lib/arm64/asm/sysreg.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 61e27d3..d4cee6f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -245,6 +245,7 @@ asm_mmu_enable:
 	orr	x1, x1, SCTLR_EL1_C
 	orr	x1, x1, SCTLR_EL1_I
 	orr	x1, x1, SCTLR_EL1_M
+	orr	x1, x1, SCTLR_EL1_SPAN
 	msr	sctlr_el1, x1
 	isb
 
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 18c4ed3..b9868ff 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -81,6 +81,7 @@ asm(
 
 /* System Control Register (SCTLR_EL1) bits */
 #define SCTLR_EL1_EE	(1 << 25)
+#define SCTLR_EL1_SPAN	(1 << 23)
 #define SCTLR_EL1_WXN	(1 << 19)
 #define SCTLR_EL1_I	(1 << 12)
 #define SCTLR_EL1_SA0	(1 << 4)
-- 
2.34.1

