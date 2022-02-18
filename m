Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FDC4BB7DD
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 12:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiBRLMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 06:12:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiBRLMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 06:12:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDD25E5D4;
        Fri, 18 Feb 2022 03:12:29 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d16so7532544pgd.9;
        Fri, 18 Feb 2022 03:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cscMbHy8lEh8C4QC/LiR+iHTGNH1GOnDZKV+ex6QkPY=;
        b=GqHiSW1HOPlPxbDAK9Q8LwKimZTAunQFhF/3AnaFtKeNqAHqQczs3YI+hLoUsInU0S
         eAzCK8i6i00cv2C22DYNML+psbunMt8xoFmvMK6AKyok2pfhzsk49D9UDh1U1sieJCqm
         JWBiMVcfcvvJdVW/4esDoXSBky1kE8zX73cHzcYK/ncaTQWQ0A+nptOJXKaAWyf2d3j2
         TGmT6lZvh7ORX2XqrmInZFXMBzfJ96tE82lpHChtyu74AKMTBXWRAS50PDue6Fb7ujpC
         XSSpQPFCr5WoBA6rEe0TP31fncwOPZ4AWClZDJK4dFV2Yfr70suB8t3mBROgKPe4jqX/
         l7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cscMbHy8lEh8C4QC/LiR+iHTGNH1GOnDZKV+ex6QkPY=;
        b=Y21xZ1Z6xtjvLjaNqPujXTd3jz07koeOuHCkYRg0NXaXvnVsCQzqT09carIIftM0C0
         1t7SEUIPmuBEZYYo9SoGFUQxRWsjmBk/uuMuPvF0UfPN9Hzm4Lrz2DMDq2rpZAlNtInb
         Et45B0/sS5MhMFu/gKsDHO+Ryu+M5zzgS/j2mb1mOyez8hna+3D3WtKAqYJBqsYxRHlM
         VEcn5Z8jRJO3MwO/DbvZejpTic2dyNbjvZCMmFJx9ivIrU6j9OKMLi5dgPjMH0KWx/4C
         d1ADoGe67ABPLcEAF+aAweA3hzx5NE67PIEm0+K7h+5Q8hORWZ8nhfY32TefrFYbn2LR
         uIEw==
X-Gm-Message-State: AOAM5301cGORskQuV9Op1r44q+XYbgmeRqvrh+p78HdSMT+AcF/Prpzv
        ikCeQCjjfVf7y2ZE5b3bkOD4g/ve3PKKKaNS
X-Google-Smtp-Source: ABdhPJxvlApAgttSSo4vryp0sdTyBOOUFliuJmsD5tjzxGjepTzqPoMl4MQIup1SWZy7zq9+qYeBhw==
X-Received: by 2002:a62:7e06:0:b0:4e0:f0f8:9b86 with SMTP id z6-20020a627e06000000b004e0f0f89b86mr7542341pfc.26.1645182749358;
        Fri, 18 Feb 2022 03:12:29 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id 189sm2806426pfv.133.2022.02.18.03.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 03:12:29 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  kvm/vmx: Make setup/unsetup under the same conditions
Date:   Fri, 18 Feb 2022 19:11:13 +0800
Message-Id: <20220218111113.11861-1-flyingpeng@tencent.com>
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

Make sure nested_vmx_hardware_setup/unsetup are called in pairs under
the same conditions.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ffcfe54eea5..5392def71093 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7852,7 +7852,7 @@ static __init int hardware_setup(void)
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
-	if (r)
+	if (r && nested)
 		nested_vmx_hardware_unsetup();
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-- 
2.27.0

