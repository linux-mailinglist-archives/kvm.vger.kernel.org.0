Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A8253DA97
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350812AbiFEGoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350768AbiFEGoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:44:00 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8982D48394;
        Sat,  4 Jun 2022 23:43:35 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f65so285522pgc.7;
        Sat, 04 Jun 2022 23:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RHnX3Bz/yPg0aUke0Eo3cgpI4N778FFMTEZJU+eVzVo=;
        b=MyL7EC6VSCYrB9jrxMq5kuB2zoDT+CBEQrFILANjMOKVe95OaK3v1EMXAS/NxAuMwB
         XDrpSLxyiFjGz1L3Tk0at7HaoL2RSi0uA2gZNxw6dlwbjM31oso3CuyF6h0B1mlivFie
         knX2AIe3FtorrwTx0Nm+DYywtw5Xl/NvL6PtNHoDegbxsAieTJN4jfHbOm+0d9i2+dH9
         0yvV3xfA4CGkvC0osNZLinMTzr2NYlEmMJxlSv7dMHdpUORevXIS/JXBF27es1xLZGxZ
         ym6tYD0UnfMJ7Y65VPnSiusT2s4mZSFdJjApBtAnro9L/RJLbkyDjhbD1ZR+ojq+7b0l
         /4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RHnX3Bz/yPg0aUke0Eo3cgpI4N778FFMTEZJU+eVzVo=;
        b=e4E7+qaFg9O4X8lRdxeaQ6CYm/zwaddgeKd+ao/OlonDvDvVJ+oxmAYiLUKdtd9Hiz
         YasgykPAwazkIMdH6v/vIogrSmqsTIaPQOevhUH0ZPu19zK4JXARV+4WtndlX1BZfWuJ
         dgMh4S2tCYtrwNszVxbFldfAR/I9vxydvdUE3RBBV0L8Xvb6B6a2hXTL5omiexB7nzlT
         mgOV37nwGC2WCT/LvAY91o+e112KCyvswjR0Dpznba1r0mx7hIO+ZYaPqFtSfZOKsi/P
         BwmM/0TlvAuMHfcgLVXpMmcKvUerFnRXr4nOLP6FdJxvEiL/ybw6jGynl0rDYzIrvf+b
         9nkw==
X-Gm-Message-State: AOAM531udQmW8FeNWVXryP1Om+JGpZ/1RTA1woESM74+Ij3a9RCYUyTs
        ezvSIlpfYLRvpClFucyy9JeE7Iq7U68=
X-Google-Smtp-Source: ABdhPJzteKFqnQkYZNWjDY+hJqG9wUHBf4WkIiGjArY2/M6ztizXDlW2+jEGLf7ES6EVNT+FuO7NUw==
X-Received: by 2002:a63:ef4e:0:b0:3f9:e8c4:b72d with SMTP id c14-20020a63ef4e000000b003f9e8c4b72dmr15529949pgk.328.1654411414879;
        Sat, 04 Jun 2022 23:43:34 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id jg15-20020a17090326cf00b001640594376dsm8155910plb.183.2022.06.04.23.43.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:34 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 11/12] KVM: X86/MMU: Remove mmu_pages_first() and mmu_pages_next()
Date:   Sun,  5 Jun 2022 14:43:41 +0800
Message-Id: <20220605064342.309219-12-jiangshanlai@gmail.com>
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

Use i = 0 andd i++ instead.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 304a515bd073..7cfc4bc89f60 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1886,19 +1886,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 #define for_each_sp(pvec, sp, i)					\
-		for (i = mmu_pages_first(&pvec);			\
-			i < pvec.nr && ({ sp = pvec.sp[i]; 1;});	\
-			i = mmu_pages_next(&pvec, i))
-
-static int mmu_pages_next(struct kvm_mmu_pages *pvec, int i)
-{
-	return i + 1;
-}
-
-static int mmu_pages_first(struct kvm_mmu_pages *pvec)
-{
-	return 0;
-}
+		for (i = 0; i < pvec.nr && ({ sp = pvec.sp[i]; 1;}); i++)
 
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
 			     struct kvm_mmu_page *parent, bool can_yield)
-- 
2.19.1.6.gb485710b

