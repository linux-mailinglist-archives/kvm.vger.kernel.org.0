Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A489373CEFB
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 09:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjFYHfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 03:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjFYHfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 03:35:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC021BD;
        Sun, 25 Jun 2023 00:35:08 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b6824141b4so21860385ad.1;
        Sun, 25 Jun 2023 00:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687678508; x=1690270508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C5Qhgf3eHEY34s30IwtCK+m3Ylt1vHBadRJK6BRuhis=;
        b=ZBZhfQtKpa9sP/cu0swfriz88rJJuacx/MgOrI3Hk7CcjCDGIBhYPOH9ohNnb+MJq2
         r6D5kMAt/8ISinrZBl28Okz1XWN6flhrAugDuqkDWEZKsNnOMb8WPhu6zYY2lQqPBUWv
         3IDTRLWxVeBjMC6CcnLQXWZvRGcFzmL5qAVUeCGWaL+4YA4SSa5alTYbQxJiG20ceAWE
         pls+YYzuj5Vprxy4AYuxK3GxAFnyhk5dx5hx5z+nP/Pbd6tVX1LKPS2R+SpllQkBoBsz
         D3Oi+byUQAyGpMi7SFNP4ajIzF2NKOTVyZLnggFnyXQ0vfN8FqocRBvdzADPE9E4cqbC
         gb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687678508; x=1690270508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C5Qhgf3eHEY34s30IwtCK+m3Ylt1vHBadRJK6BRuhis=;
        b=H1+aVRBCVpMRKMa9xLp1uUOYrmMNAlEIOFoTbn3gqwErbb4RVmd4Kbm/+VdmC81eUo
         ZCiKNmQs5KJP2P41fFFeOYmN3L/dMF4FzF1udJRs4pIDgJSZmRuAPIg2XRdLgl9nDaRK
         RTgo9TM3hEmDE2ExdqyUfq2ztZM/+CKad8TsIF6YPEINsKjuuyP3E8lG/LeGIihFMx32
         rELeLAYjP5T3IhQPAz5ve8NJOzxoKPHWH6WDVEjuvkIUAnu7hy1sl3suzIWOqTK3S4au
         K5gs7F5KkEbdTHVE6Q7XPvCnsfS18GHxtgxVR3QdmvvpOutsx8kJSsWY6QgX+zR0SGDq
         rKDA==
X-Gm-Message-State: AC+VfDwwYofioHNx/JgXxqcoh1kYm4Qcc6wUTaNyN+/n44d5588AQr91
        jo5l/WTUja61Hbtf60G48HshaFmUoG+0Xej9alY=
X-Google-Smtp-Source: ACHHUZ5VVoTgzIu6h8u9TpUOLWfD4Qv5ugSGXO/LjifTp+Fni23RQCOAoaadEZGK1VVTg0Gpj04vkw==
X-Received: by 2002:a17:902:c94e:b0:1b7:e061:af16 with SMTP id i14-20020a170902c94e00b001b7e061af16mr3983401pla.23.1687678508015;
        Sun, 25 Jun 2023 00:35:08 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902740b00b001b66e3a77easm2106859pll.50.2023.06.25.00.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 00:35:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Use sysfs_emit() instead of sprintf()
Date:   Sun, 25 Jun 2023 15:34:38 +0800
Message-ID: <20230625073438.57427-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
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

From: Like Xu <likexu@tencent.com>

Use sysfs_emit() instead of the sprintf() for sysfs entries. sysfs_emit()
knows the maximum of the temporary buffer used for outputting sysfs
content and avoids overrunning the buffer length.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 60397a1beda3..78f6f816c7d1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6862,7 +6862,7 @@ static void mmu_destroy_caches(void)
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
-		return sprintf(buffer, "never\n");
+		return sysfs_emit(buffer, "never\n");
 
 	return param_get_bool(buffer, kp);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..254f2296e549 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -366,9 +366,9 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
 static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 {
 	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param)))
-		return sprintf(s, "???\n");
+		return sysfs_emit(s, "???\n");
 
-	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
+	return sysfs_emit(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
 static void vmx_setup_fb_clear_ctrl(void)
-- 
2.41.0

