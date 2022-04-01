Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4B4EE9D0
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbiDAIhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiDAIha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:37:30 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FDC1E31B8;
        Fri,  1 Apr 2022 01:35:40 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id kl29so1518740qvb.2;
        Fri, 01 Apr 2022 01:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zn/8FpD3aw/Sk7OYOO4PmEBsuTnjKB0BqLg1RPT9WL8=;
        b=ZLkrrXspDRUrkXZlZrIZ5GBRIDJFsDGS1BhXYv2CaGAODzelJsavoB3off+X6J+1Q7
         RysWeUoXYsutLYg8hWQptiQGqUOeyDVfD91zyZVtSNE1zKJSgU77KOUGqgNXckARL3Yj
         ITLpytoS8fEPnPpmiIy9dNdKyIm+rzPpmsX2uYVHUmW0I9ONI2uYQnWJuLSSn3FK4SqA
         rLLAe264XXmCGAieKpXo0uOQjzj9cjQA6Vc+iS/wMmmjSlP4Uvz84bMh9Td+NCxIU7J1
         3TJvlHgjPP3azttVdu+xpV4zdK7s1auDYNnzBcBXC37aZlDtFSN+kd7YQO8aocc/PLvS
         9X5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zn/8FpD3aw/Sk7OYOO4PmEBsuTnjKB0BqLg1RPT9WL8=;
        b=Ilc8lDdjN/N+/3SEOIZVVmwb/HPghjdQXojemrE/nPZuGDXF7qVN1lWY57kOhZktD/
         /8dKBATxmZ5EW6riQdS4F9FeTVBKsYO0ycrsCdL4ogOrHRPm+T1fOt5ECeHSBkPm/Kyl
         y8I9mwlzIHOG8Ugq0UtYRDCr20TZc6C2zwBgYG+Mpz0GjCdlt5OmmeZ8ZDgyXQ6iyFlt
         CobWrKbCkHKy0K0JVLfvjXZFJsBdHYEzxCI3WNq0Z6419pqDTNe4yJyNjn6n17PIwWDl
         8xLn3cILOZPGh3buisvPDbOgJuR1wTQvPCJY0KtJeBogTe0KeMpe57MnKj1TAuV+OZX8
         /XBQ==
X-Gm-Message-State: AOAM5327iKYNI0+KMWOxqhFvQJUQYqh7gccV/9OyPHnbj2FgLoA+AZBb
        JWpVwe3ZOVmlgK+4YCtNBJc=
X-Google-Smtp-Source: ABdhPJwN9T/E/rCPaNJ9DKzqYVuTAoZWyTbMdnwwgPVHHLypasl52QP8J4ePJxE/60aeB+Xdz+ld3Q==
X-Received: by 2002:a05:6214:1bce:b0:441:2d37:1fd1 with SMTP id m14-20020a0562141bce00b004412d371fd1mr7193280qvc.10.1648802139234;
        Fri, 01 Apr 2022 01:35:39 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j18-20020ac85c52000000b002e1b9897ae7sm1431151qtj.10.2022.04.01.01.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 01:35:38 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] KVM: x86/mmu: remove unnecessary flush_workqueue()
Date:   Fri,  1 Apr 2022 08:35:30 +0000
Message-Id: <20220401083530.2407703-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

All work currently pending will be done first by calling destroy_workqueue,
so there is unnecessary to flush it explicitly.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2f9a34a0168..b822677ee3da 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -51,7 +51,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
-	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
-- 
2.25.1

