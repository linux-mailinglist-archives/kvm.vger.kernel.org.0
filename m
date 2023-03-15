Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882296BAAD1
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 09:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjCOIdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 04:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjCOIda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 04:33:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1671166E5;
        Wed, 15 Mar 2023 01:33:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u5so19229417plq.7;
        Wed, 15 Mar 2023 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678869205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2vTQAZoeBjlEcGhk3RrVAUomw8DLBSpSN68W8fBtiGg=;
        b=lNSVB4VtYjZer+I7ek45AOkfcs1c+zhiQKToBht/hO0FBWaTeO9oymX6qglT/2gjnb
         a1zQus8fK5DDOf53ANoZIoTjAJn71mF3pXxabpIyZi8DQc7DgwS8SRw99dWtklTZ3PjV
         fF4l2RL33GVjDw3ouctr95Ch9tYXBb58ChftPUOe7OJ6wkAjtWOzWw0VouFfxzhDGSVv
         Obgz324F/8gFTzzg/ClhA5YjVjRupnl6OH9RrOMfHvpgMvZAZvZZc5XmybF2cyic1bKa
         DTQ80KWzd+I8IV6RGIfwNPVY+m7s8+Bjj/mgWZkUfd0uwhpa6IrwyWaa1xzloIP+IWy/
         dz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678869205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2vTQAZoeBjlEcGhk3RrVAUomw8DLBSpSN68W8fBtiGg=;
        b=BBObMtBU6lIurlxLQXVw6p4b7zd4c+8WdVF0WFsqqVksAkB06Mn0kfbaTeXK9nFMBK
         sWRRAKlj0u8a5mFGwfh0/OUKqvFiXejS69G9mkh8H1jYhwSqDed3GNIqTzgCCIuusHCD
         PsWxoPBH9EEpuPl4HoLem73dtrUfTSR8WfmDoqagCkpGMpOhjGS8QhpTj+AKs50zG5qz
         UetTPuhAvthYHqM1VMO1/vIo0PgKnj3e0SEmVkjnbkxSky2yFwcwCh+hO03tRREaXsU0
         Tmqeq+SlwWDanyMDdkwO7f6sTrFgDqFyWREuDnQTrXVfJiR/FEo8hhX1YJF7G1qJtNuJ
         +/hg==
X-Gm-Message-State: AO0yUKUl6XNgsX+kiv5M5UK7lwbRYpBpD/ei8NT+w2e37NN8oQ2+5Lr2
        /HtvNG9Lvpw/RcsxzxJ0qhuCj3gosYB5CGwss1A=
X-Google-Smtp-Source: AK7set/Iw5C4XuG6SwJxpPZY1I4cHrD9Ck/VW9bNRxjHJ79m06v7p7oyXiQ/KwbVGknWrJXkjBWPSA==
X-Received: by 2002:a17:90a:19:b0:23a:ad68:25a7 with SMTP id 25-20020a17090a001900b0023aad6825a7mr33242681pja.2.1678869205233;
        Wed, 15 Mar 2023 01:33:25 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id kx14-20020a170902f94e00b001a064cff3c5sm2990745plb.43.2023.03.15.01.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 01:33:24 -0700 (PDT)
From:   korantwork@gmail.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, mlevitsk@redhat.com, wanpengli@tencent.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Xinghui Li <korantli@tencent.com>
Subject: [PATCH] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
Date:   Wed, 15 Mar 2023 16:33:20 +0800
Message-Id: <20230315083320.230000-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xinghui Li <korantli@tencent.com>

VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
which is meaningless. Delete the duplicate one.

Fixes: 391503528257 ("KVM: x86: SVM: move avic definitions from AMD's spec to svm.h")
Signed-off-by: Xinghui Li <korantli@tencent.com>
---
 arch/x86/include/asm/svm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cb1ee53ad3b1..633f724d461a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -276,7 +276,6 @@ enum avic_ipi_failure_cause {
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
 
 struct vmcb_seg {
-- 
2.31.1

