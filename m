Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C34C6189
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 04:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiB1DJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 22:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiB1DJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 22:09:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321F3D1EA;
        Sun, 27 Feb 2022 19:09:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id u16so9785546pfg.12;
        Sun, 27 Feb 2022 19:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nXtb3PBsh54zXS/YgA8lGlY/42S7Z18i2aQnK/BIamM=;
        b=GwcohP0QS7Bk+Vc/ytG14LY+4Acr3jgJtFjkP4R0SvuMBRjlKsVecH5rV9Cr3iM7Ns
         dTG6BiP5s49JasnKvmQNh0v54/zf0nAhPRicV4BwZe44MScTg3F0tAQDJrw2WccK0AiZ
         DgfGWB2GomPulC0HzvoZzIRritWXeOlUxKkHjLOLFqm875vVtht+c3RoYbuSLnZmwe4S
         YtSJQkymM3bz5lXyMiJ7E0gmPHfFFsNQoOn0Yz6OOhNnPvTctsx7jBtvRQlTW/CJlZGm
         ixa4zCtCMBdY0nx/zTggIjkK4y0Bl7srSBvR+EBoKz1Ntj/ei818SOuIFUoYUGYg4Mj5
         Ay4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nXtb3PBsh54zXS/YgA8lGlY/42S7Z18i2aQnK/BIamM=;
        b=hbv/OUiyKbhWTe0+vrdRtOsUVs1GFAd1hAKnUGZQnNivWMypL1NV/5kKdEd+qNP/1W
         bIvxd1+K2CwlVViO7F215abIyLpO4ytZJU8slzpMCSCwjkC4tT4DRSQEcj0u4dA0EvZ9
         uJZpuIAJj6HJsMYzYnAu0+dBYb9gcVHjmC7gGaVgzubST5iPA7eu59zpNOpMPJqv6hT4
         1bovK9Z1bLAtcq9QHy3RGw8nATxzQ+wyI/0uZpVG6/nXcfn3XKKxEVYqDW1yDatOgXrZ
         tTfuGIdNQB8v7jlgwz3hHbsir52+7ayquDSVww+AZ+eGSKEIcXx7vgAJohEiLddkJf8N
         GKlg==
X-Gm-Message-State: AOAM533ojzj0J5le6xW099PxSPTVddxyfe11EZ/b98tpDjvGCM/E6zGE
        aJUJVUMKHyMk0ZyoKPTJSL5durbpG49LMcsC
X-Google-Smtp-Source: ABdhPJzJm3YFO28jWCsHMqZeoDt6kMv7lvueekj4Z5Yx88T1Gl6aibNGsuJQ1N+TwAyPU5XzAcEtHA==
X-Received: by 2002:a63:5ce:0:b0:373:3724:b95c with SMTP id 197-20020a6305ce000000b003733724b95cmr15188301pgf.378.1646017757177;
        Sun, 27 Feb 2022 19:09:17 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id np11-20020a17090b4c4b00b001bd4aa67bafsm2150422pjb.3.2022.02.27.19.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 19:09:16 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  kvm: x86: Adjust the location of pkru_mask of kvm_mmu to reduce memory
Date:   Mon, 28 Feb 2022 11:07:49 +0800
Message-Id: <20220228030749.88353-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

Adjust the field pkru_mask to the back of direct_map to make up 8-byte
alignment.This reduces the size of kvm_mmu by 8 bytes.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5d8700319cc..73dcb09abd5d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -433,14 +433,6 @@ struct kvm_mmu {
 	u8 shadow_root_level;
 	u8 ept_ad;
 	bool direct_map;
-	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
-
-	/*
-	 * Bitmap; bit set = permission fault
-	 * Byte index: page fault error code [4:1]
-	 * Bit index: pte permissions in ACC_* format
-	 */
-	u8 permissions[16];
 
 	/*
 	* The pkru_mask indicates if protection key checks are needed.  It
@@ -450,6 +442,15 @@ struct kvm_mmu {
 	*/
 	u32 pkru_mask;
 
+	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
+
+	/*
+	 * Bitmap; bit set = permission fault
+	 * Byte index: page fault error code [4:1]
+	 * Bit index: pte permissions in ACC_* format
+	 */
+	u8 permissions[16];
+
 	u64 *pae_root;
 	u64 *pml4_root;
 	u64 *pml5_root;
-- 
2.27.0

