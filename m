Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7473553DA92
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbiFEGom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350827AbiFEGn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B9448892;
        Sat,  4 Jun 2022 23:43:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n10so10423332pjh.5;
        Sat, 04 Jun 2022 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bu7ZrkPxS66jxcidoVWV6iYAl5bluEGFikDfLhjYokI=;
        b=M8RXbxYdMIpzAXk26g7e1Flo+N/99FBOkaWgEjMhoc4L0AbKTkdc4F+dbPMw9Hd1XB
         XncFNmvvKS5l22ooBh9AjMrLxiWOYAfJ5buroZc74xJIW2QRoAW4fmcgJNvO4EaZ5goq
         i655sPiap7Yo/hYYW5+lsj/PT1qabJ1VcuRT9veENb4Kj18zYGFwOtMJScUB4KtrtoWU
         w3fIkU7tMD8lXlxKMevEKozOi/lGmlTatFv/QPO0HDHO2Xfe+Thh7NpylZ2/eB9Cc/RP
         bkfzR/QnFTDZoLB9c05B9EMPsnqKOXi9YEsYgJfOEV5UkGfY/u8tbXheqgZz/jwgxAMw
         Vtbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bu7ZrkPxS66jxcidoVWV6iYAl5bluEGFikDfLhjYokI=;
        b=0RYu4u4RbO8Fyd4eJgjotz6EdceRVVc/ENJoX4CuoQX0g4PLMmCDwfOu+lNle2ObG3
         xvHzd+kDtJVaMkgKFC0Fp+XusbYEjMAL5MJfEEKP/+Pbk1XZck46psdA343u9qqdmFwI
         Nr6y0L2kBLj+egLmRtdOdpJ6AkPsYDy4z4lBYxqFfOGlAwoyl70+NWMLw0vzzg+Gmmhj
         mXXrzyFG+7sRPKHKfleEYs6Bv9U1yUMHUdikqK3lU8S9AnL8GiYB9v7D2WNNNOz0rhnR
         otO4w8NrYxW/Q2iGaxvOzQHcaOunzSS+RelvUG4Zo8YtMHHNq1Ll63E63GKNYpLr6rfJ
         mIvg==
X-Gm-Message-State: AOAM532T8HxlsGFarkkGO8Y30Rse+kl4k2JeZjLMgMklmhQxac3pi40g
        6KaDa5Q5ItrQzcw/IsXz4FCEIO7iB/A=
X-Google-Smtp-Source: ABdhPJzq8vJNMjwqjFJY7It9lSU2JDdDSYc/z2ZOXaRYHUPC4hh7tkuK3uwZlndPkBaGP7ahKbYcJw==
X-Received: by 2002:a17:90b:3ecd:b0:1dc:94f2:1bc0 with SMTP id rm13-20020a17090b3ecd00b001dc94f21bc0mr19945260pjb.32.1654411411042;
        Sat, 04 Jun 2022 23:43:31 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id k81-20020a628454000000b0050dc762815esm1186895pfd.56.2022.06.04.23.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:30 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 10/12] KVM: X86/MMU: Don't add parents to struct kvm_mmu_pages
Date:   Sun,  5 Jun 2022 14:43:40 +0800
Message-Id: <20220605064342.309219-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Parents added into the struct kvm_mmu_pages are never used.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5563e5ee2e5..304a515bd073 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1751,10 +1751,9 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp)
 {
 	int i;
 
-	if (sp->unsync)
-		for (i=0; i < pvec->nr; i++)
-			if (pvec->sp[i] == sp)
-				return 0;
+	for (i=0; i < pvec->nr; i++)
+		if (pvec->sp[i] == sp)
+			return 0;
 
 	pvec->sp[pvec->nr] = sp;
 	pvec->nr++;
@@ -1785,9 +1784,6 @@ static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
-			if (mmu_pages_add(pvec, child))
-				return -ENOSPC;
-
 			ret = __mmu_unsync_walk_and_clear(child, pvec);
 			if (ret < 0)
 				return ret;
@@ -1818,7 +1814,6 @@ static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 	if (!sp->unsync_children)
 		return 0;
 
-	mmu_pages_add(pvec, sp);
 	return __mmu_unsync_walk_and_clear(sp, pvec);
 }
 
@@ -1897,33 +1892,12 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int mmu_pages_next(struct kvm_mmu_pages *pvec, int i)
 {
-	int n;
-
-	for (n = i+1; n < pvec->nr; n++) {
-		struct kvm_mmu_page *sp = pvec->sp[n];
-		int level = sp->role.level;
-
-		if (level == PG_LEVEL_4K)
-			break;
-
-	}
-
-	return n;
+	return i + 1;
 }
 
 static int mmu_pages_first(struct kvm_mmu_pages *pvec)
 {
-	struct kvm_mmu_page *sp;
-	int level;
-
-	if (pvec->nr == 0)
-		return 0;
-
-	sp = pvec->sp[0];
-	level = sp->role.level;
-	WARN_ON(level == PG_LEVEL_4K);
-
-	return mmu_pages_next(pvec, 0);
+	return 0;
 }
 
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
-- 
2.19.1.6.gb485710b

